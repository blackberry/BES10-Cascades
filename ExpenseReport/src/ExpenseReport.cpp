/* Copyright (c) 2013, 2014  BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include "ExpenseReport.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include <bb/platform/Notification>
#include <bb/platform/NotificationError>
#include <bb/platform/NotificationResult>
#include <bb/system/phone/Phone>

#include <QTimer>

#include "BuildManager.h"

using namespace bb::platform;
using namespace bb::cascades;

// Globals
bool tmpRememberToDeleteNotif = false;

QString NOTIFICATION_PREFIX = "ExpenseReportApp";

ExpenseReport::ExpenseReport(bb::cascades::Application *app)
        : QObject(app) {
    // Expose Phone object to QML
    qmlRegisterType<bb::system::phone::Phone>("bb.system.phone", 1, 0, "Phone");

    // create scene document from main.qml asset
    // set parent to created document to ensure it exists for the whole application lifetime
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    qml->setContextProperty("cppExpenseReport", this);

    // create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();
    // set created root object as a scene
    app->setScene(root);

    m_invokeManager = new InvokeManager();

    // Connect to InvokeManager "invoked" signal to handle incoming push
    // notifications. We will ignore non-push invoke requests.
    connect(m_invokeManager, SIGNAL(invoked(const bb::system::InvokeRequest&)), SLOT(onInvoked(const bb::system::InvokeRequest&)));

    tmpRememberToDeleteNotif = true;

    // not used
    m_iValue = 0;
}

ExpenseReport::~ExpenseReport() {
    if (tmpRememberToDeleteNotif)
        Notification::deleteFromInbox(NOTIFICATION_PREFIX + QString::number(m_push.seqNum() + 12));
}

void ExpenseReport::onInvoked(const InvokeRequest &request) {
    Notification::deleteFromInbox(NOTIFICATION_PREFIX + QString::number(m_push.seqNum() + 12));

    tmpRememberToDeleteNotif = false;
}

int ExpenseReport::value() {
    return m_iValue;
}

void ExpenseReport::setValue(int i) {
    m_iValue = i;
}
