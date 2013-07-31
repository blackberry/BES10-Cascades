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
 * NetworkBase.h
 *
 *  Created on: Apr 30, 2013
 *      Author: farahh
 */

#ifndef NETWORKBASE_H_
#define NETWORKBASE_H_

#include <qobject.h>
#include <qlist>
#include <QtNetwork/qnetworkaccessmanager.h>
#include <QtNetwork/QNetworkReply.h>
#include <QtNetwork/qnetworkrequest.h>
#include <QDebug>
#include <QFile>

#define USER_NAME 		"username"
#define AUTH_TOKEN 		"access_token"
#define AUTH_URL 		"instance_url"
#define AUTH_ISSUE 		"issued_at"
#define AUTH_SIGNATURE 	"signature"
#define AUTH_ID 		"id"

/**
 * Base network class
 */
class NetworkBase: public QObject {
	Q_OBJECT

	Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)
public:
	enum State {
		Init,
		JsonLoaded,
		QtDisplayed,
		ReadyToWrite
	};

	NetworkBase(QObject* parent = NULL);
	virtual ~NetworkBase();
	
	// getters
	bool isLoading();
	
	Q_SIGNAL
	void notifyRequestError(int statusCode);Q_SLOT
	void requestFinished(QNetworkReply* reply);

	void setResultAndState(const QString& resultMsg, State newState);
	void setRhsTitleAndText(const QString& title, const QString& text);
	void writeToJsonFileAndReload(QVariant mQtData, QString name);
	void loadJsonFileRaw(const QString& resultMsg, QString filename);
	void loadJsonFileRaw(const QString& resultMsg, QFile& jsonFile);

Q_SIGNALS:
	void isLoadingChanged();
	void notifyHttpOK();
	
protected:
	virtual void requestResponse(QByteArray& result) = 0;
	virtual void requestError(int returnCode);
	virtual QNetworkRequest* createNetworkRequest(const QUrl& url,
			bool autenticated = false);
	virtual bool submitRequest(QNetworkRequest* request);
	bool postRequest(QNetworkRequest* request, const QByteArray& data);

	QNetworkRequest* m_request;
	QNetworkAccessManager m_networkAccessManager;
	QNetworkReply* m_reply;
	
	void setIsLoading(bool flag);

private:
	bool m_isLoading;

private Q_SLOTS:
	void authenticationRequired(QNetworkReply * reply,
			QAuthenticator * authenticator);
};

#endif /* NETWORKBASE_H_ */
