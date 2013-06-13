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

#ifndef PUSHCONFIGURATION_HPP_
#define PUSHCONFIGURATION_HPP_

#include <QString>

/*!
 * Configuration settings for the push application.
 */
class PushConfiguration {
public:
    PushConfiguration();
    virtual ~PushConfiguration();

    QString providerApplicationId() const;
    QString ppgUrl() const;
    QString invokeTargetPush() const;
    QString invokeTargetOpen() const;
    bool launchApplicationOnPush() const;

    void setProviderApplicationId(const QString& providerApplicationId);
    void setPpgUrl(const QString& ppgUrl);
    void setPushInitiatorUrl(const QString& pushInitiatorUrl);
    void setInvokeTargetPush(QString invokeTargetPush);
    void setInvokeTargetOpen(QString invokeTargetOpen);
    void setLaunchApplicationOnPush(bool launchApplicationOnPush);

private:
    // If writing a consumer application, this corresponds to the unique ID you receive in your confirmation email after signing up
    // for the BlackBerry Push Service.
    // If writing an enterprise application and you are using the Push Service SDK to implement your Push Initiator on the server-side,
    // this corresponds to the arbitrary application ID that you decide on.
    // If writing an enterprise application and you are not using the Push Service SDK, this will be null.
    QString m_providerApplicationId;

    // This matches the URL used to register with / unregister from the BlackBerry Push Service (BIS) PPG.
    // For eval, this would be http://cp<cpid>.pushapi.eval.blackberry.com.
    // For production, this would be http://cp<cpid>.pushapi.na.blackberry.com
    // Replace <cpid> with your content provider ID (that you received when registering).
    // This applies to consumer applications only and will be null for enterprise applications.
    QString m_ppgUrl;

    QString m_invokeTargetPush;
    QString m_invokeTargetOpen;
};

#endif /* PUSHCONFIGURATION_HPP_ */
