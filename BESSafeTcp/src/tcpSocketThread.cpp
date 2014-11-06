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

#include "BESSafeTcp.hpp"
#include "tcpSocketThread.hpp"

#include <math.h>

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

#include <openssl/err.h>

#include <openssl/ssl.h>

#include <sys/types.h>
#include <sys/socket.h>

#include <sys/proxyinfo.h>

#include <QDebug>

TCPSocketThread::TCPSocketThread()
{
}

TCPSocketThread::~TCPSocketThread() {
}

void TCPSocketThread::run()
{
	const char* hostName = "developer.blackberry.com"; // The host that you're connecting to
	const int port = 80;
	const char *httpRequest = "GET / HTTP/1.1\r\nHost: developer.blackberry.com\r\n\r\n";
	unsigned int bytesRead = 0, bytesWritten = 0;
	int error, responseCount = 0;
	static fd_set write_handles;
	char message[512] = { 0 };

    // Connect the TCP socket
	safeConnectFullTcp(m_socket, hostName, port);

	// check that the safe connect returned without errors
	if (m_socket > 0) {
	    while(1){

			FD_ZERO( &write_handles );
			FD_SET( m_socket, &write_handles );
			error = select(m_socket + 1, NULL, &write_handles, NULL, NULL);

			if( error < 0 ) {
			}

			if( FD_ISSET( m_socket, &write_handles ) ) {

				if (bytesWritten == 0) {
			        BESSafeTcp::consoleLog("sending data ...");
				    qDebug() << (QString(httpRequest));
					bytesWritten = write(m_socket, httpRequest, strlen(httpRequest));
					sprintf(message, "%d\n", bytesWritten);
					qDebug() << (QString(message));

				} else if (bytesWritten == strlen(httpRequest)) {
					bytesRead=read(m_socket,m_readBuffer,READ_BUFFER_SIZE);
					sprintf(message, "%d\n", bytesRead);
					qDebug() << (QString(message));

					if (bytesRead > 0) {
						m_readBuffer[bytesRead] = 0;
						qDebug() << (QString(m_readBuffer));
						responseCount++;
					} else {
	                    BESSafeTcp::consoleLog("received data ...");
						break;
					}
				}
			}
	    }

		close(m_socket);
	}
}

void TCPSocketThread::queryProxy(const char* queryHostName, const char* queryUrl, char* proxyHost, int& proxyPort)
{
	PROXYINFO *pi_handle = pi_init();
	char proxyResult[256] = { 0 };
	int index = 0;
	int proxyHostLength = 0;
	char message[512] = { 0 };
	int proxyCode = 0;

    qDebug() << QString("proxy query host: ") << queryHostName << "\n";
    qDebug() << QString("proxy query URL: ") << queryUrl << "\n";

	proxyCode = pi_getproxy(pi_handle, queryHostName, queryUrl, proxyResult, 256);

	switch (proxyCode) {
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
          qWarning() << QString("unexpected proxy result: ") << proxyCode << " : " << proxyResult << "\n";
          proxyHost[0] = '\0';
          proxyPort = 0;
		  break;
	}

	pi_cleanup(pi_handle);
}

void TCPSocketThread::safeConnectFullTcp(int& sock, const char* hostName, const int& port)
{
	char proxyHost[256] = { 0 };
	int proxyPort;
	char *connectHost;
	int connectPort;
	char httpProxyRequest[512] = { 0 };
	char message[512] = { 0 };

	queryProxy(hostName, "", proxyHost, proxyPort);

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
      sprintf(message, "Couldn't resolve host");
      qDebug() << (QString(message));
      return;
    }
    memset(&addr,0,sizeof(addr));
    addr.sin_addr=*(struct in_addr*)
      hp->h_addr_list[0];
    addr.sin_family=AF_INET;
    addr.sin_port=htons(connectPort);

    if((sock=socket(AF_INET,SOCK_STREAM,
      IPPROTO_TCP))<0) {
        sprintf(message, "Couldn't create socket");
        qDebug() << (QString(message));
        return;
    }
    if(::connect(sock,(struct sockaddr *)&addr,
      sizeof(addr)) <0) {
        sprintf(message, "Couldn't connect socket");
        qDebug() << (QString(message));
        return;
    }

	// if there is a proxy, send the connect request and wait for the response before proceeding further
	if (proxyHost[0] != '\0') {

		static fd_set write_handles;
		unsigned int bytesRead = 0, bytesWritten = 0;
		int error, responseCount = 0;

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

    if (sock) {
        sprintf(message, "socket connected\n");
        qDebug() << (QString(message));
        BESSafeTcp::consoleLog(message);
    }

 }

