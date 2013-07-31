/* Copyright (c) 2012 Research In Motion Limited.
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
*/


/*
 * LogoutManager.cpp
 *
 *  Created on: Apr 30, 2013
 *      Author: farahh
 */

#include "LogoutManager.h"
#include <QDebug>
#include <bb/data/JsonDataAccess>
#include <bb/data/DataAccessError>
#include "../Settings.h"

using namespace bb::data;

LogoutManager::LogoutManager(QObject* parent) :
	NetworkBase::NetworkBase(parent) {
}

LogoutManager::~LogoutManager() {
	// TODO Auto-generated destructor stub
}

void LogoutManager::logout(){
	qDebug() << " LogoutManager::login";

	QUrl requestURL(QUrl::fromEncoded((QString("https://login.salesforce.com/services/oauth2/revoke").toUtf8())));
	m_request = createNetworkRequest(requestURL,false);

	connect(this, SIGNAL(notifyHttpOK()), this, SLOT(responseOK()));

	QString req("token=" + Settings::getInstance().getValueFor(AUTH_TOKEN, ""));
	QByteArray ba;
	ba.append(req.toUtf8());
	if (!postRequest(m_request, ba)) {
		qWarning() << "***** There is already a Logout Request in progress";
	}
}

void LogoutManager::requestResponse(QByteArray& result) {
	qDebug() << " LogoutManager::requestResponse QString result=" << QString(result);
	//emit loggedOut();
}

void LogoutManager::responseOK(){
	qDebug() << " LogoutManager::responseOK";
	emit loggedOut();
}
