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
 * NetworkBase.cpp
 *
 *  Created on: Apr 30, 2013
 *      Author: farahh
 */

#include "NetworkBase.h"
#include <QDir>
#include <bb/data/JsonDataAccess>

using namespace bb::data;

NetworkBase::NetworkBase(QObject* parent) :
	QObject(parent),
	m_networkAccessManager() {

	m_reply = NULL;
	m_request = NULL;

	// Creates the network access manager and connects a custom slot to its
	// finished signal. Checks the return value for errors.
	bool res = connect(&m_networkAccessManager, SIGNAL(finished(QNetworkReply*)), this,
			SLOT(requestFinished(QNetworkReply*)));
	Q_ASSERT(res);
	res = connect(&m_networkAccessManager, SIGNAL(authenticationRequired(QNetworkReply*,QAuthenticator*)), this,
			SLOT(authenticationRequired(QNetworkReply *, QAuthenticator *)));
	Q_ASSERT(res);
}

NetworkBase::~NetworkBase() {
}

QNetworkRequest* NetworkBase::createNetworkRequest(const QUrl& url,bool authenticated)
{
	QNetworkRequest* request = new QNetworkRequest(url);
	request->setRawHeader("Content-Type","application/x-www-form-urlencoded");
	if (authenticated) {
		request->setRawHeader("Authorization", "Digest commence");
		qDebug() << "NetworkBase::createNetworkRequest -- Token will  be set for " << objectName();
		qDebug() << "Authorization: " << "Digest commence";
	}

	if (m_request != NULL) {
		qDebug() << "NetworkBase::createNetworkRequest there was a previous m_request (" <<  m_request << ") it will be deleted and replace with " << request;
		delete m_request;
		m_request = NULL;
	}

	return request;
}

void NetworkBase::authenticationRequired ( QNetworkReply * reply, QAuthenticator * authenticator )  {}

bool NetworkBase::submitRequest(QNetworkRequest* request) {
	if (m_reply == NULL) {
		m_reply = m_networkAccessManager.get(*request);
		this->setIsLoading(true);
		return true;
	}
	return false;
}

bool NetworkBase::postRequest(QNetworkRequest* request,
		const QByteArray& data) {
	if (m_reply == NULL) {
#ifndef NO_DEBUG
		qDebug() << "NetworkBase::postRequest  -- query: "	<< request->url().toString();
		foreach(QByteArray hdr, request->rawHeaderList()){
		qDebug() << "NetworkBase::postRequest  -- header: " << QString(hdr) << QString(request->rawHeader(hdr));
	}
		qDebug() << "NetworkBase::postRequest  -- body: " << QString(data);
#endif
		m_reply = m_networkAccessManager.post(*request, data);
		this->setIsLoading(true);
		return true;
	}
	qDebug() << "**********Problem trying to post a request while another is in progress.";

	return false;
}

void NetworkBase::requestFinished(QNetworkReply* reply) {
	qDebug() << "NetworkBase::requestFinished  -";

	// Handle the reply data...
	if (reply->error() == QNetworkReply::NoError) {
		emit notifyHttpOK();


		QByteArray returnedData;
			returnedData = reply->readAll();
		QString requestIdentifier = reply->request().attribute(QNetworkRequest::User).value<QString>();

		// Deletes the reply the next time the event loop is entered
		m_reply->deleteLater();
		m_reply = NULL;
		this->requestResponse(returnedData);
	} else {
		qWarning() << "NetworkBase::requestFinished  --  Err:"  << this->objectName() << "  --  Encountered an error (" << reply->error() << "):" << reply->errorString();
		this->requestError(reply->error());

		qDebug() << "NetworkBase::requestFinished  --  Err:query: " << reply->request().url().toString();
		foreach(QByteArray hdr, reply->request().rawHeaderList()) {
			qDebug() << "NetworkBase::postRequest  --  Err:header: " << QString(hdr) << QString(reply->request().rawHeader(hdr));
		}
		QString responseBody = QString::fromUtf8(reply->readAll());
		qDebug() << "Body: " << responseBody.length() << responseBody;
		if (m_request) {
			qDebug() << "Our request: " << m_request->rawHeaderList().size();
			for(int c=0;c<m_request->rawHeaderList().size();++c) {
				QByteArray header = m_request->rawHeaderList()[c];
				qDebug() << "Header " << header;
			}
		}
		// Deletes the reply the next time the event loop is entered
		m_reply->deleteLater();
		m_reply = NULL;
	}
	
	this->setIsLoading(false);
}

void NetworkBase::requestError(int returnCode) {
	qWarning() << "NetworkBase::requestError:" << returnCode;
}

bool NetworkBase::isLoading() {
	return m_isLoading;
}

void NetworkBase::setIsLoading(bool flag) {
	m_isLoading = flag;
	Q_EMIT isLoadingChanged();
}
