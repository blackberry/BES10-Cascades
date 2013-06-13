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
 * This class is holds various configuration parameters of the push
 * service for the Application. It also exposes getters and setter methods
 * for those parameters.
 ****************************************************************************/


#include "pushconfiguration.hpp"

//This should match with id specified in bar-descriptor.xml
#define AAP_ID "bb10.cascades.ecl"
// This needs to match the invoke target specified in bar-descriptor.xml
// The Invoke target key for receiving new push notifications
#define INVOKE_TARGET_KEY_PUSH "bb10.cascades.ecl.invoke.r1.push"

// This needs to match the invoke target specified in bar-descriptor.xml
// The Invoke target key when selecting a notification in the BlackBerry Hub
#define INVOKE_TARGET_KEY_OPEN "bb10.cascades.ecl.invoke.r1.open"

PushConfiguration::PushConfiguration()
      : m_providerApplicationId(AAP_ID)
      , m_ppgUrl("")
      , m_invokeTargetPush(INVOKE_TARGET_KEY_PUSH)
      , m_invokeTargetOpen(INVOKE_TARGET_KEY_OPEN) {
}

PushConfiguration::~PushConfiguration() {
}


/****************************************************************************
* Getter and Setter functions for the Push Invocation target.
****************************************************************************/
QString PushConfiguration::invokeTargetPush() const {
    return m_invokeTargetPush;
}

void PushConfiguration::setInvokeTargetPush(QString invokeTargetPush) {
    m_invokeTargetPush = invokeTargetPush;
}

/****************************************************************************
* Getter and Setter functions for the target to open when a Push Notification
* arrives.
****************************************************************************/
QString PushConfiguration::invokeTargetOpen() const {
    return m_invokeTargetOpen;
}

void PushConfiguration::setInvokeTargetOpen(QString invokeTargetOpen) {
    m_invokeTargetOpen = invokeTargetOpen;
}

/****************************************************************************
* Getter and Setter functions for the Application ID of the provider
****************************************************************************/
QString PushConfiguration::providerApplicationId() const {
    return m_providerApplicationId;
}

void PushConfiguration::setProviderApplicationId(
        const QString& providerApplicationId) {
    m_providerApplicationId = providerApplicationId;
}

/****************************************************************************
* Getter and Setter functions for the URL of the Push Proxy Gateway
****************************************************************************/
QString PushConfiguration::ppgUrl() const {
    return m_ppgUrl;
}

void PushConfiguration::setPpgUrl(const QString& ppgUrl) {
    m_ppgUrl = ppgUrl;
}

