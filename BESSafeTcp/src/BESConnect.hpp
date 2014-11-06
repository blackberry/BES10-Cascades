/*
 * Copyright (c) 2012-2014 Research In Motion Limited.
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
 * BESSafeTcp.h
 *
 *  Created on: Nov 28, 2012
 *      Author: rsperanza
 */

#ifndef BESCONNECT_H_
#define BESCONNECT_H_

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <netdb.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>

#include <netinet/in.h>
#include <netinet/tcp.h>

#include <sys/types.h>
#include <sys/socket.h>

#include <sys/proxyinfo.h>

#include <bb/cascades/Image>
#include <bb/cascades/ImageTracker>
#include <bb/UIToolkitSupport>

#include <QtCore/QDebug>
#include <QtCore/QFile>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkConfigurationManager>
#include <QtNetwork/QNetworkProxy>
#include <QtNetwork/QTcpSocket>
#include <QtNetwork/QSslSocket>
#include <QtCore/QUrl>

#define READ_BUFFER_SIZE 1024


class BESConnect : public QObject {

	Q_OBJECT

	// Q_PROPERTY(QUrl networkImageSource READ networkImageSource WRITE setNetworkImageSource)

public:
	BESConnect();
	virtual ~BESConnect();

public Q_SLOTS:
	void safeConnectQTcp(QTcpSocket& socket, const QString& hostName, const int& port);
	void safeConnectQTcp(QTcpSocket& socket, const QString& url);

    void testBSDTcpSockets();

    void testOpenSSLSslSockets();

    void testCurlConnections();

    void testQtTcpSockets();
	void onTestQtTcpSocketConnected();
	void onTestQtTcpSocketReadyRead();

    void testQtSslSockets();
	void onTestQtSslSocketConnected();
	void onTestQtSslSocketReadyRead();

private:
	void queryProxy(const char* queryHostName, const char* queryUrl, char* proxyHost, int& proxyPort);
	QNetworkProxy& queryProxy(const QString& hostName, const QString& url);

	void safeConnectFullTcp(int& socket, const char* hostName, const int& port);
	void safeConnectFullQTcp(QTcpSocket& socket, const QString& hostName, const int& port, const QString& url);

    char m_readBuffer[READ_BUFFER_SIZE+1];


	QNetworkProxy m_besProxy;

    QNetworkConfigurationManager m_networkConfigurationManager;
    QNetworkAccessManager m_networkAccessManager;
    QTcpSocket m_testSocket;
    QSslSocket m_testSslSocket;
};

#endif /* BESCONNECT_H_ */
