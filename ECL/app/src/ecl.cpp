/****************************************************************************
 * Copyright 2012 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ****************************************************************************/
/*
 * This is ECL application class
 *
 ****************************************************************************/

#include "ECL.hpp"
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/network/PushErrorCode>
#include <bb/network/PushStatus>
#include <bb/system/InvokeRequest>
#include <bb/platform/Notification>
#include <bb/system/SystemDialog>

#include "filtereddatamodel.hpp"
#include "ecldatamodel.hpp"
#include "eclutils.hpp"
#include "eclcontact.hpp"
#include "eclconfig.hpp"
#include "ecllistitem.hpp"

using namespace bb::cascades;
using namespace bb::network;
using namespace bb::system;
using namespace bb::platform;

#define BB_OPEN_INVOCATION_ACTION "bb.action.OPEN"

ECL::ECL(bb::cascades::Application *app) :
        QObject(app), m_model(0), m_invokeManager(new InvokeManager(this)) {

    eclUtils = new EclUtils(this);

    jSonDataModel = new EclDataModel(this);
    m_model = new FilteredDataModel(jSonDataModel, this);

    qmlRegisterType<EclContact>("ecl.contact.utils", 1, 0, "EclContact");
    qmlRegisterType<EclConfig>("ecl.contact.utils", 1, 0, "EclConfig");
    qmlRegisterType<EclListItem>("ecl.contact.utils", 1, 0, "CustomListItem");

    connect(&m_pushNotificationService,
            SIGNAL( createSessionCompleted(const bb::network::PushStatus&)),
            this,
            SLOT(onCreateSessionCompleted(const bb::network::PushStatus&)));
    connect(&m_pushNotificationService,
            SIGNAL(createChannelCompleted(const bb::network::PushStatus&, const QString)),
            this,
            SLOT(onCreateChannelCompleted(const bb::network::PushStatus&, const QString)));
    connect(&m_pushNotificationService,
            SIGNAL(destroyChannelCompleted(const bb::network::PushStatus&)),
            this,
            SLOT(onDestroyChannelCompleted(const bb::network::PushStatus&)));
    connect(&m_pushNotificationService,
            SIGNAL(registerToLaunchCompleted(const bb::network::PushStatus&)),
            this,
            SLOT(onRegisterToLaunchCompleted(const bb::network::PushStatus&)));
    connect(&m_pushNotificationService,
            SIGNAL(unregisterFromLaunchCompleted(const bb::network::PushStatus&)),
            this,
            SLOT(onUnregisterFromLaunchCompleted(const bb::network::PushStatus&)));

    connect(m_invokeManager, SIGNAL(invoked(const bb::system::InvokeRequest&)),
            this, SLOT(onInvoked(const bb::system::InvokeRequest&)));
    connect(this, SIGNAL(createSession()), this, SLOT(onCreateSession()),
            Qt::QueuedConnection);
    connect(&m_pushNotificationService,
            SIGNAL(pushTransportReady(bb::network::PushCommand::Type)), this,
            SLOT(onPushTransportReady(bb::network::PushCommand::Type)));
    connect(&m_pushNotificationService, SIGNAL(noPushServiceConnection()), this,
            SLOT(onNoPushServiceConnection()));

    initializePushSession();

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("_model", m_model);
    qml->setContextProperty("_app", this);
    qml->setContextProperty("_eclutils", eclUtils);

    AbstractPane* root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);

}

void ECL::selectionChanged(const QVariantList &indexPath, bool selected) {
    if (indexPath.size() != 1 || !selected)
        return; // Not interested

    // Selected a header item!
    const int selection = indexPath[0].toInt();

    // Toggle the expanded state of the selected header
    m_model->changeHeaderExpansion(selection);
}

/****************************************************************************
 * Slot function to handle the Push Transport being Ready
 ****************************************************************************/
void ECL::onPushTransportReady(bb::network::PushCommand::Type command) {
    if (command == PushCommand::CreateChannel) {
        m_pushNotificationService.createChannel();
    } else if (command == PushCommand::DestroyChannel) {
        m_pushNotificationService.destroyChannel();
    }

}

/****************************************************************************
 * Slot function to handle the noPushServiceConnection() signal.
 ****************************************************************************/
void ECL::onNoPushServiceConnection() {
    qDebug() << "Error: Push Service could not connect to the Push Agent";
}

/****************************************************************************
 * This function is to initialize the Push service and to emit session
 * creation signal.
 ****************************************************************************/
void ECL::initializePushSession() {
    m_pushNotificationService.initializePushService();
    emit createSession();
}

/****************************************************************************
 * Slot function for creating a session.
 ****************************************************************************/
void ECL::onCreateSession() {
    m_pushNotificationService.createSession();
}

/****************************************************************************
 * Slot function for checking the successful creation of the session.
 * if success, then creates a channel
 * otherwise an error
 ****************************************************************************/
void ECL::onCreateSessionCompleted(const bb::network::PushStatus &status) {
    if (status.code() == PushErrorCode::NoError) {
        m_pushNotificationService.registerToLaunch();
        m_pushNotificationService.createChannel();
    } else {
        qDebug() << "onCreateSessionCompleted err: " << status.code();
    }
}

/****************************************************************************
 * Slot function for checking the successful creation of the channel.
 ****************************************************************************/
void ECL::onCreateChannelCompleted(const bb::network::PushStatus &status,
        const QString &token) {
    Q_UNUSED(token)
    if (PushErrorCode::NoError != status.code()) {
        qDebug() << "onCreateChannelCompleted err: " << status.code();
    }
}

/****************************************************************************
 * Slot function for checking the successful destruction of the channel.
 ****************************************************************************/
void ECL::onDestroyChannelCompleted(const bb::network::PushStatus &status) {

    if (PushErrorCode::NoError != status.code()) {
        qDebug() << "Destroy channel failed err: " << status.code();
    }
}

/****************************************************************************
 * Slot function for checking the completion of the signal
 * registerToLaunchCompleted.
 ****************************************************************************/
void ECL::onRegisterToLaunchCompleted(const bb::network::PushStatus &status) {

    if (status.code() != PushErrorCode::NoError) {
        qDebug() << "onRegisterToLaunchCompleted err: " << status.code();
    }
}

/****************************************************************************
 * Slot function for checking the completion of signal
 * unregisterFromLaunchCompleted.
 ****************************************************************************/
void ECL::onUnregisterFromLaunchCompleted(
        const bb::network::PushStatus &status) {
    if (status.code() != PushErrorCode::NoError) {
        qDebug() << "onUnregisterFromLaunchCompleted err: " << status.code();
    }
}

/****************************************************************************
 * Slot function for acting on the invoked signal
 * - Initializes the push service
 * - Extracts the payload from invoke request
 * - Calls the push notification handler
 ****************************************************************************/
void ECL::onInvoked(const InvokeRequest &request) {
    // The underlying PushService instance might not have been
    // initialized when an invoke first comes in
    // Make sure that we initialize it here if it hasn't been already

    m_pushNotificationService.initializePushService();

    if (request.action().compare(BB_PUSH_INVOCATION_ACTION) == 0) {
        qDebug() << "onInvoked BB_PUSH_INVOCATION_ACTION ";
        // Received an incoming push
        // Extract it from the invoke request and then process it
        PushPayload payload(request);
        if (payload.isValid()) {
            pushNotificationHandler(payload);
        }
    } else if (request.action().compare(BB_OPEN_INVOCATION_ACTION) == 0) {
        qDebug() << "onInvoked BB_OPEN_INVOCATION_ACTION";
    }
}

/****************************************************************************
 * This function handles the push notifications that the application
 * receives
 * - Notifies the Blackberry hub about the push received
 * - Configures the invoke request target and action for the notification
 ****************************************************************************/
void ECL::pushNotificationHandler(bb::network::PushPayload &pushPayload) {
    // Create a notification for the push that will be added to the BlackBerry Hub
    Notification *notification = new Notification();
    notification->setTitle("Emergency Contact List");
    notification->setBody(QString("New List received"));

    // Add an invoke request to the notification
    InvokeRequest invokeRequest;
    invokeRequest.setTarget(m_configuration.invokeTargetOpen());
    invokeRequest.setAction(BB_OPEN_INVOCATION_ACTION);
    notification->setInvokeRequest(invokeRequest);

    // Add the notification for the push to the BlackBerry Hub
    // Calling this method will add a "splat" to the application icon, indicating that a new push has been received
    notification->notify();

    // If an acknowledgment of the push is required (that is, the push was sent as a confirmed push
    // - which is equivalent terminology to the push being sent with application level reliability),
    // then you must either accept the push or reject the push
    if (pushPayload.isAckRequired()) {
        // In our sample, we always accept the push, but situations might arise where an application
        // might want to reject the push (for example, after looking at the headers that came with the push
        // or the data of the push, we might decide that the push received did not match what we expected
        // and so we might want to reject it)
        m_pushNotificationService.acceptPush(pushPayload.id());
    }

    if (eclUtils->writeToJson("data/data.json", pushPayload.data())) {
        jSonDataModel->load("data/data.json");
        m_model->reload(jSonDataModel);
    }
}

/****************************************************************************
 * This triggers a demo of the ECL Native Application using a pre-created
 * JSON file containing the contact informations.
 ****************************************************************************/
void ECL::demoJSONActionTriggered() {
    if (eclUtils->showConfirmDialog(
            tr("This will temporarily overwrite your contact list with test data."))
            == SystemUiResult::ConfirmButtonSelection) {
        jSonDataModel->load("app/native/assets/data/ecl_data.json");
        m_model->reload(jSonDataModel);
    }
}

/****************************************************************************
 * This triggers a demo of the ECL Native Application using a pre-created
 * text file which gets converted into a JSON file which in turn
 * is used to populate the contact list.
 ****************************************************************************/
void ECL::demoTextActionTriggered() {
    if (eclUtils->showConfirmDialog(
            tr("This will temporarily overwrite your contact list with test data."))
            == SystemUiResult::ConfirmButtonSelection) {
        eclUtils->textFileToJson("app/native/assets/data/ecl_data.txt",
                "data/ecl_demo.json");
        jSonDataModel->load("data/ecl_demo.json");
        m_model->reload(jSonDataModel);
    }
}

