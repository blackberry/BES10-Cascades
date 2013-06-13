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

#ifndef ECL_HPP_
#define ECL_HPP_

#include <QObject>
#include <bb/network/PushPayload>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>

#include "pushclient/pushconfiguration.hpp"
#include "pushclient/pushclientnotification.hpp"
#include "eclutils.hpp"

class FilteredDataModel;
class EclDataModel;

namespace bb { namespace cascades { class Application; }}

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */

class ECL : public QObject
{
    Q_OBJECT
public:
    ECL(bb::cascades::Application *app);
    virtual ~ECL() {}

public Q_SLOTS:
    void selectionChanged(const QVariantList &indexPath, bool selected);
    void demoJSONActionTriggered();
    void demoTextActionTriggered();

    void onCreateSessionCompleted(const bb::network::PushStatus &status);
    void onCreateChannelCompleted(const bb::network::PushStatus &status, const QString &token);
    void onDestroyChannelCompleted(const bb::network::PushStatus &status);
    void onRegisterToLaunchCompleted(const bb::network::PushStatus &status);
    void onUnregisterFromLaunchCompleted(const bb::network::PushStatus &status);
    void onCreateSession();
    void onInvoked(const bb::system::InvokeRequest &request);
    void onPushTransportReady(bb::network::PushCommand::Type command);
    void onNoPushServiceConnection();

Q_SIGNALS:

    void notificationChanged();
    void closeActivityDialog();
    void openActivityDialog();
    void activityDialogChanged();
    void createSession();

private:
    void initializePushSession();
    void pushNotificationHandler(bb::network::PushPayload &pushPayload);

private:
    EclDataModel *jSonDataModel;
    FilteredDataModel *m_model;

    EclUtils *eclUtils;

    // The manager object to react to invocations
    bb::system::InvokeManager *m_invokeManager;

    // The wrapper classes for loading/storing configuration values
    PushConfiguration m_configuration;

    PushClientNotification m_pushNotificationService;
};

#endif /* ECL_HPP_ */
