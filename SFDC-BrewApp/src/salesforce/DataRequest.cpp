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
 * DataRequest.cpp
 *
 *  Created on: May 1, 2013
 *      Author: farahh
 */

#include "DataRequest.h"
#include "../Settings.h"
#include <bb/data/JsonDataAccess>
#include "math.h"
#include "../Constants.h"

using namespace bb::data;

DataRequest::DataRequest() :
		NetworkBase::NetworkBase() {

}

DataRequest::~DataRequest() {
	// TODO Auto-generated destructor stub
}

void DataRequest::execute(QString query) {
	QString url = Settings::getInstance().getValueFor(AUTH_URL, "");
	QString authToken = "Bearer "
			+ Settings::getInstance().getValueFor(AUTH_TOKEN, "");
	QString username = Settings::getInstance().getValueFor("username", TEST_ACCOUNT);

	query.replace("%USERNAME%", username);
	query.replace("%NAMESPACE%", SF_NAMESPACE);

	QUrl requestURL(QUrl::fromEncoded(((url + query).toUtf8())));

	qDebug() << "Requesting URL = " << requestURL;
	qDebug() << "Requesting authToken = " << authToken;

	m_request = createNetworkRequest(requestURL, false);
	m_request->setRawHeader("Authorization", authToken.toUtf8());

	if (!submitRequest(m_request)) {
		qWarning() << "***** There is already a Data Request in progress";
	}

}

void DataRequest::requestResponse(QByteArray& result) {
	qDebug() << "DataRequest::requestResponse = " << QString(result);

	// Strip the namespace here so the rest of the app is not dependent on a specific namespace.
	QString normalized = QString(result).replace( "\"" SF_NAMESPACE ,"\"");
	qDebug() << "DataRequest::requestResponse Normalized = " << normalized;

	JsonDataAccess jda;
	QVariant qtData = jda.loadFromBuffer(normalized);
	emit dataReturned(qtData);

	double quantityRemaining = 0, quantity = 0, average = 0;
	double itemcount = 0;
	QVariantMap qtDataMap = qtData.toMap();
	QVariantList qtDataList = qtDataMap["records"].toList();
	for (int i = 0; i < qtDataList.size(); i++) {
		QVariantMap data = qtDataList.at(i).toMap();
		quantityRemaining += data["__quantity_remaining__c"].toDouble();
		quantity += data["__quantity__c"].toDouble();
		itemcount++;
	}
	average = quantityRemaining / quantity;
	emit averageCalculated(QVariant(average));
}
