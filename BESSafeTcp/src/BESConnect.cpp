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
 * BESSafeTcp.cpp
 *
 *  Created on: Nov 28, 2012
 *      Author: rsperanza
 */

#include "BESConnect.hpp"
#include "BESSafeTcp.hpp"
#include "tcpSocketThread.hpp"
#include "sslSocketThread.hpp"
#include "curlConnectThread.hpp"

BESConnect::BESConnect() : m_networkConfigurationManager(this), m_networkAccessManager(this),
                           m_testSocket(this), m_testSslSocket(this)
{
}

BESConnect::~BESConnect() {
	// TODO Auto-generated destructor stub
}


void BESConnect::testBSDTcpSockets()
{
	TCPSocketThread *tcpSocketThread = new TCPSocketThread();

	tcpSocketThread->start();
}

void BESConnect::testOpenSSLSslSockets()
{
	SSLSocketThread *sslSocketThread = new SSLSocketThread();

	sslSocketThread->start();
}

void BESConnect::testCurlConnections()
{
	CurlConnectThread *curlConnectThread = new CurlConnectThread();

	curlConnectThread->start();
}

void BESConnect::testQtTcpSockets()
{
	// debug code - please ignore
	qDebug() << ("active configuration: " + m_networkAccessManager.activeConfiguration().bearerName() + "\n");
	qDebug() << ("default configuration: " + m_networkConfigurationManager.defaultConfiguration().bearerName() + "\n");

	QNetworkConfiguration besConfiguration;

	QList<QNetworkConfiguration>  configurations = m_networkConfigurationManager.allConfigurations();
	qDebug() << (QString("configurations: ") + configurations.count()  + "\n");

    for(int index = 0; index < configurations.count(); index++) {
    	QNetworkConfiguration configuration = configurations.at(index);

    	qDebug() << ("config: " + configuration.name()  + " : " + configuration.bearerName()  + "\n");

    	if (configuration.name().compare("ti0") == 0) {
    		m_networkAccessManager.setConfiguration(configuration);
    	}
    	if (configuration.name().compare("bb2") == 0) {
    		besConfiguration = configuration;
    	}
    }
	if (m_networkAccessManager.networkAccessible() != QNetworkAccessManager::Accessible) {
		m_networkAccessManager.setNetworkAccessible(QNetworkAccessManager::Accessible);
		qDebug() << (QString("access: ") + " : accessible"  + "\n");
	}

	qDebug() << (QString("active configuration: ") + m_networkAccessManager.configuration().bearerName()  + "\n");

	QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();
	qDebug() << (QString("network interfaces: ") + interfaces.count()  + "\n");
    for(int index = 0; index < interfaces.count(); index++) {
    	QNetworkInterface interface = interfaces.at(index);
    	qDebug() << ("interface: " + interface.name()  + " : " + interface.humanReadableName()  + "\n");

    	qDebug() << (QString("network addresses: ") + interface.addressEntries().count()  + "\n");
        for(int index = 0; index < interface.addressEntries().count(); index++) {
        	QNetworkAddressEntry address = interface.addressEntries().at(index);
        	qDebug() << (QString("address: ") + index + " : " + address.ip().toString()  + "\n");
        }
		if (interface.name().compare("bb2") == 0) {
		    qDebug() << (QString("( BES interface ) ")  + "\n");;
    	}
    }

	bool result = connect(&m_testSocket,
			SIGNAL(connected()),
			this, SLOT(onTestQtTcpSocketConnected()));

	// Displays a warning message if there's an issue connecting the signal
	// and slot. This is a good practice with signals and slots as it can
	// be easier to mistype a slot or signal definition
	Q_ASSERT(result);
	Q_UNUSED(result);

	result = connect(&m_testSocket,
			SIGNAL(readyRead ()),
			this, SLOT(onTestQtTcpSocketReadyRead()));

	// Displays a warning message if there's an issue connecting the signal
	// and slot. This is a good practice with signals and slots as it can
	// be easier to mistype a slot or signal definition
	Q_ASSERT(result);
	Q_UNUSED(result);

    BESSafeTcp::consoleLog("test socket connecting ...\n");
    qDebug() << ("test socket connecting ...\n");

	const char *hostName = "developer.blackberry.com";            // The host that you're connecting to
	const int port = 80;
/*
	QNetworkProxy proxy = m_testSocket.proxy();
	if (proxy != QNetworkProxy::NoProxy) {
	    qDebug() << (QString("default proxy type: ")  + proxy.type() + "\n");
	    qDebug() << (QString("default proxy host: ")  + proxy.hostName() + "\n");
	    qDebug() << (QString("default proxy port: ")  + proxy.port() + "\n");
	}
*/
	safeConnectQTcp(m_testSocket, QString(hostName), port);
}
void BESConnect::onTestQtTcpSocketConnected()
{
    BESSafeTcp::consoleLog("test socket connected\n");
    qDebug() << ("test socket connected\n");

    char *readLine = NULL;
    QByteArray readLineBytes;

    do {
		readLineBytes = m_testSocket.readLine();
		if (readLineBytes.length() > 0) {
			readLine = readLineBytes.data();
		}

		if (readLine) {
		    qDebug() << (QString(readLine) + "\n");
		}
    } while (readLine != NULL);

    qint64 bytesWritten = m_testSocket.write ("GET / HTTP/1.1\nHost: developer.blackberry.com\n\n");
    qDebug() << ("GET / HTTP/1.1\nHost: developer.blackberry.com\n\n");

    do {
		readLineBytes = m_testSocket.readLine();
		if (readLineBytes.length() > 0) {
			readLine = readLineBytes.data();
		} else {
			readLine = NULL;
		}

		if (readLine) {
		    qDebug() << (QString(readLine) + "\n");
		}
    } while (readLine != NULL);

}


void BESConnect::onTestQtTcpSocketReadyRead()
{
    BESSafeTcp::consoleLog("test socket ready to read\n");
    qDebug() << ("test socket ready to read\n");

    char *readLine = NULL;
    QByteArray readLineBytes;

    do {
		readLineBytes = m_testSocket.readLine();
		if (readLineBytes.length() > 0) {
			readLine = readLineBytes.data();
		} else {
			readLine = NULL;
		}

		if (readLine) {
		    qDebug() << (QString(readLine) + "\n");
		}
    } while (readLine != NULL);
}



void BESConnect::testQtSslSockets()
{
	bool result = connect(&m_testSslSocket,
			SIGNAL(connected()),
			this, SLOT(onTestQtSslSocketConnected()));

	// Displays a warning message if there's an issue connecting the signal
	// and slot. This is a good practice with signals and slots as it can
	// be easier to mistype a slot or signal definition
	Q_ASSERT(result);
	Q_UNUSED(result);

	result = connect(&m_testSslSocket,
			SIGNAL(readyRead ()),
			this, SLOT(onTestQtSslSocketReadyRead()));

	// Displays a warning message if there's an issue connecting the signal
	// and slot. This is a good practice with signals and slots as it can
	// be easier to mistype a slot or signal definition
	Q_ASSERT(result);
	Q_UNUSED(result);

    BESSafeTcp::consoleLog("test SSL socket connecting ...\n");
    qDebug() << ("test SSL socket connecting ...\n");

	const char *hostName = "ca.yahoo.com";            // The host that you're connecting to
	const int port = 443;
/*
	QNetworkProxy proxy = m_testSocket.proxy();
	if (proxy != QNetworkProxy::NoProxy) {
	    qDebug() << (QString("default proxy type: ")  + proxy.type() + "\n");
	    qDebug() << (QString("default proxy host: ")  + proxy.hostName() + "\n");
	    qDebug() << (QString("default proxy port: ")  + proxy.port() + "\n");
	}
*/
	safeConnectQTcp(m_testSslSocket, QString(hostName), port);
}

void BESConnect::onTestQtSslSocketConnected()
{
    BESSafeTcp::consoleLog("test SSL socket connected\n");
    qDebug() << ("test socket connected\n");

    //m_testSslSocket.setSocketDescriptor(m_testSocket.socketDescriptor());
    m_testSslSocket.startClientEncryption ();

    char *readLine = NULL;
    QByteArray readLineBytes;

    do {
		readLineBytes = m_testSslSocket.readLine();
		if (readLineBytes.length() > 0) {
			readLine = readLineBytes.data();
		}

		if (readLine) {
		    qDebug() << (QString(readLine) + "\n");
		}
    } while (readLine != NULL);

    qint64 bytesWritten = m_testSslSocket.write ("GET /?p=us HTTP/1.1\nHost: ca.yahoo.com:443\n\n");
    qDebug() << ("GET /?p=us HTTP/1.1\nHost: ca.yahoo.com:443\n\n");

    do {
		readLineBytes = m_testSslSocket.readLine();
		if (readLineBytes.length() > 0) {
			readLine = readLineBytes.data();
		} else {
			readLine = NULL;
		}

		if (readLine) {
		    qDebug() << (QString(readLine) + "\n");
		}
    } while (readLine != NULL);

}

void BESConnect::onTestQtSslSocketReadyRead()
{
    BESSafeTcp::consoleLog("test SSL socket ready to read\n");
    qDebug() << ("test socket ready to read\n");

    char *readLine = NULL;
    QByteArray readLineBytes;

    do {
		readLineBytes = m_testSslSocket.readLine();
		if (readLineBytes.length() > 0) {
			readLine = readLineBytes.data();
		} else {
			readLine = NULL;
		}

		if (readLine) {
		    qDebug() << (QString(readLine) + "\n");
		}
    } while (readLine != NULL);
}


void BESConnect::queryProxy(const char* queryHostName, const char* queryUrl, char* proxyHost, int& proxyPort)
{
	PROXYINFO *pi_handle = pi_init();
	char proxyResult[256] = { 0 };
	int index = 0;
	int proxyHostLength = 0;
	char message[512] = { 0 };

	switch (pi_getproxy(pi_handle, queryHostName, queryUrl, proxyResult, 256)) {
		case PI_RESULT_PROXY:
		  qDebug() << (QString("proxy result: ")  + proxyResult + "\n");;
		  strcpy(proxyHost, proxyResult);
		  proxyHostLength = strlen(proxyResult);
		  proxyHost[proxyHostLength]  = '\0';
		  for(index = 0; index < proxyHostLength; index++) {
			  if (proxyHost[index] == ':') {
				  proxyHost[index] = '\0';
				  proxyPort = atoi(&proxyHost[index+1]);
				  break;
			  }
		  }

		  sprintf(message, "sys proxy host: %s\n", proxyHost);
		  qDebug() << (QString(message));
		  sprintf(message, "sys proxy port: %d\n", proxyPort);
		  qDebug() << (QString(message));
		  break;

		case PI_RESULT_DIRECT:
		  // You don't need to use a proxy. You should connect directly to this host.
		  qDebug() << (QString("proxy result: ")  + proxyResult + "\n");
		  proxyHost[0] = '\0';
		  proxyPort = 0;
		  break;

		default:
		  // Something went wrong. In most cases, you'd want to connect directly in this case as well
		  break;
	}

	pi_cleanup(pi_handle);
}

QNetworkProxy& BESConnect::queryProxy(const QString& queryHostName, const QString& queryUrl)
{
	QNetworkProxy proxy = QNetworkProxy::NoProxy;
	char proxyHost[256] = { 0 };
	int proxyPort = 0;

	queryProxy((const char*)queryHostName.toAscii(), (const char*)queryUrl.toAscii(), proxyHost, proxyPort);
	if (proxyHost[0] != '\0') {
		  m_besProxy.setType(QNetworkProxy::HttpProxy);
		  m_besProxy.setHostName(proxyHost);
		  m_besProxy.setPort(proxyPort);
		  proxy = m_besProxy;
	}

	return proxy;
}

void BESConnect::safeConnectFullTcp(int& sock, const char* hostName, const int& port)
{
	char proxyHost[256] = { 0 };
	int proxyPort;
	char *connectHost;
	int connectPort;
	char httpProxyRequest[512] = { 0 };
	char message[512] = { 0 };

	queryProxy(hostName, NULL, proxyHost, proxyPort);

    // Connect the TCP socket

	// if there is a proxy, you need to connect through there
	if (proxyHost[0] != '\0') {
		connectHost = proxyHost;
		connectPort = proxyPort;
		sprintf(httpProxyRequest, "CONNECT %s:%d HTTP/1.1\r\nHost: %s\r\n\r\n", hostName, port, proxyHost);
	} else {
		connectHost = (char*)hostName;
		connectPort = port;
	}


    struct hostent *hp;
    struct sockaddr_in addr;

    if(!(hp=gethostbyname(connectHost))) {
      fprintf(stderr, "Couldn't resolve host");
      exit(-1);
    }
    memset(&addr,0,sizeof(addr));
    addr.sin_addr=*(struct in_addr*)
      hp->h_addr_list[0];
    addr.sin_family=AF_INET;
    addr.sin_port=htons(connectPort);

    if((sock=socket(AF_INET,SOCK_STREAM,
      IPPROTO_TCP))<0) {
    	fprintf(stderr, "Couldn't create socket");
        exit(-1);
    }
    if(::connect(sock,(struct sockaddr *)&addr,
      sizeof(addr)) <0) {
    	fprintf(stderr, "Couldn't connect socket");
        exit(-1);
    }

	// if there is a proxy, send the connect request and wait for the response before proceeding further
	if (proxyHost[0] != '\0') {

		static fd_set write_handles;
		static fd_set read_handles;
		int bytesRead = 0, bytesWritten = 0, error, responseCount = 0;

        while(1){

			FD_ZERO( &write_handles );
			FD_SET( sock, &write_handles );
			error = select(sock + 1, NULL, &write_handles, NULL, NULL);

			if( error < 0 ) {
			}

			if( FD_ISSET( sock, &write_handles ) ) {

				if (bytesWritten == 0) {
				    qDebug() << (QString(httpProxyRequest));
					bytesWritten = write(sock, httpProxyRequest, strlen(httpProxyRequest));
					sprintf(message, "%d\n", bytesWritten);
					qDebug() << (QString(message));
				} else if (bytesWritten == strlen(httpProxyRequest)) {
					bytesRead=read(sock,m_readBuffer,READ_BUFFER_SIZE);
					sprintf(message, "%d\n", bytesRead);
					qDebug() << (QString(message));
					if (bytesRead > 0) {
						m_readBuffer[bytesRead] = 0;
						qDebug() << (QString(m_readBuffer));
						responseCount++;
						if (responseCount == 1) {
							if (m_readBuffer[9] != '2') {
								sock = 0;
							}
							if (m_readBuffer[9] == '2') {
								// it connected
							}
							break;
						}
					} else {
						break;
					}
				}
			}
        }
	}
 }


void BESConnect::safeConnectQTcp(QTcpSocket& socket, const QString& hostName, const int& port)
{
	safeConnectFullQTcp(socket, hostName, port, QString());
}

void BESConnect::safeConnectQTcp(QTcpSocket& socket, const QString& url)
{
	safeConnectFullQTcp(socket, QString(), -1, url);
}

void BESConnect::safeConnectFullQTcp(QTcpSocket& socket, const QString& hostName, const int& port, const QString& url)
{
    socket.setProxy(queryProxy(hostName, url));

	socket.connectToHost (hostName, port, QIODevice::ReadWrite);
}

