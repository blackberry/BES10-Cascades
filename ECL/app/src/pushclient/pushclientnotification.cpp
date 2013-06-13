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
 * This class takes care of creating and setting up the framework required
 * to be able to reveive Push Notifications
 *
 ****************************************************************************/

#include "pushclientnotification.hpp"

using namespace bb::network;

PushClientNotification::PushClientNotification(QObject *parent) :
        QObject(parent), m_pushService(0) {
}


/****************************************************************************
 * Create a Session with the Push Service.
 ****************************************************************************/
void PushClientNotification::createSession() {

    // Check to see if the PushService has a connection to the Push Agent.
    // This can occur if the application doesn't have sufficient permissions to use Push.
    if (m_pushService->hasConnection()) {
        m_pushService->createSession();
    } else {
        emit noPushServiceConnection();
    }

}

/****************************************************************************
 * Create a Channel to receive Push Notifications.
 ****************************************************************************/
void PushClientNotification::createChannel() {
    if (m_pushService->hasConnection()) {
        m_pushService->createChannel(m_configuration.ppgUrl());
    } else {
        emit noPushServiceConnection();
    }
}

/****************************************************************************
 * Register so that the Push notification can launch the application.
 ****************************************************************************/
void PushClientNotification::registerToLaunch() {
    m_pushService->registerToLaunch();
}

/****************************************************************************
 * Unregister from Launch Requests. Now The application will no longer get
 * launched after a push notification.
 ****************************************************************************/
void PushClientNotification::unregisterFromLaunch() {
    m_pushService->unregisterFromLaunch();
}

/****************************************************************************
 * Accept the Pus Notification.
 ****************************************************************************/
void PushClientNotification::acceptPush(const QString &payloadId) {
    m_pushService->acceptPush(payloadId);
}

/****************************************************************************
 * Initialize the Push Service. This takes care of setting up the various
 * signal-slot connections required for succesful reciept of push
 * Notifications
 ****************************************************************************/
void PushClientNotification::initializePushService() {

    if (!m_pushService) {

        m_pushService = new PushService(m_configuration.providerApplicationId(),
                m_configuration.invokeTargetPush(), this);

        QObject::connect(m_pushService,
                SIGNAL(createSessionCompleted(const bb::network::PushStatus&)),
                this,
                SIGNAL(createSessionCompleted(const bb::network::PushStatus&)));
        QObject::connect(m_pushService,
                SIGNAL(createChannelCompleted(const bb::network::PushStatus&, const QString)),
                this,
                SIGNAL(createChannelCompleted(const bb::network::PushStatus&, const QString)));
        QObject::connect(m_pushService,
                SIGNAL(destroyChannelCompleted(const bb::network::PushStatus&)),
                this,
                SIGNAL(destroyChannelCompleted(const bb::network::PushStatus&)));
        QObject::connect(m_pushService,
                SIGNAL(registerToLaunchCompleted(const bb::network::PushStatus&)),
                this,
                SIGNAL(registerToLaunchCompleted(const bb::network::PushStatus&)));
        QObject::connect(m_pushService,
                SIGNAL(unregisterFromLaunchCompleted(const bb::network::PushStatus&)),
                this,
                SIGNAL(unregisterFromLaunchCompleted(const bb::network::PushStatus&)));
        QObject::connect(m_pushService, SIGNAL(simChanged()), this,
                SIGNAL(simChanged()));
        QObject::connect(m_pushService,
                SIGNAL(pushTransportReady(bb::network::PushCommand::Type)),
                this,
                SIGNAL(pushTransportReady(bb::network::PushCommand::Type)));
        fprintf(stdout, "PushClientNotificationService::initializePushService <=\n");
    }

}

/****************************************************************************
 * Destroy the channel to receive Push Notifications.
 ****************************************************************************/
void PushClientNotification::destroyChannel() {
    if (m_pushService->hasConnection()) {
        m_pushService->destroyChannel();
    }
}

