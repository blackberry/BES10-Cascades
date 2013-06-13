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

#ifndef PUSHCLIENTNOTIFICATION_HPP_
#define PUSHCLIENTNOTIFICATION_HPP_

#include "pushconfiguration.hpp"

#include <bb/network/PushService>
#include <QObject>

class PushClientNotification :  public QObject
{
    Q_OBJECT

public:
    PushClientNotification(QObject *parent = 0);

    void createSession();
    void createChannel();
    void initializePushService();
    void destroyChannel();
    void registerToLaunch();
    void unregisterFromLaunch();
    void acceptPush(const QString &payloadId);

signals:
    void createSessionCompleted(const bb::network::PushStatus &status);
    void createChannelCompleted(const bb::network::PushStatus &status, const QString &token);
    void destroyChannelCompleted(const bb::network::PushStatus &status);
    void registerToLaunchCompleted(const bb::network::PushStatus &status);
    void unregisterFromLaunchCompleted(const bb::network::PushStatus &status);
    void simChanged();
    void pushTransportReady(bb::network::PushCommand::Type command);
    void piRegistrationCompleted(int code, const QString &description);
    void piDeregistrationCompleted(int code, const QString &description);
    void noPushServiceConnection();


private:
    PushConfiguration m_configuration;
    bb::network::PushService *m_pushService;

};


#endif /* PUSHCLIENTNOTIFICATION_HPP_ */
