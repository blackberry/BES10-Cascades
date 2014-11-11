/*
 * Copyright (c) 2012-2014 BlackBerry Limited.
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
#include "curlConnectThread.hpp"

#include <math.h>

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <QDebug>

static size_t write_data(void *ptr, size_t size, size_t nmemb, void *stream)
{
    qDebug() << (QString(QByteArray((char *)ptr, size*nmemb)).append("\n"));
	return size;
}

CurlConnectThread::CurlConnectThread()
{
}

CurlConnectThread::~CurlConnectThread() {
}

void CurlConnectThread::run()
{
	const char *httpsURL = "https://ca.yahoo.com/?p=us";

    netstatus_proxy_details_t details;
    memset(&details, 0, sizeof(details));
    CURL *curl_handle = NULL;
    bool proxyWasNotRequired = false;

    if (bps_initialize() == BPS_SUCCESS) {

		if (netstatus_get_proxy_details(&details) == BPS_SUCCESS) {

		    // init the curl session
		    curl_global_init(CURL_GLOBAL_ALL);
		    curl_handle = curl_easy_init();

		    if (curl_handle) {

				/* set URL to get */
				curl_easy_setopt(curl_handle, CURLOPT_URL, httpsURL);

				/* if proxy is required, then set proxy */
				if (details.http_proxy_host == NULL) {
					proxyWasNotRequired = true;
					qDebug() << (QString("No proxy required!\n"));
				} else {
					curl_easy_setopt(curl_handle, CURLOPT_PROXY, details.http_proxy_host);
					qDebug() << (QString("proxy host: ").append(details.http_proxy_host).append("\n"));

					/* if we have a valid port number then let libcurl know what it is */
					if (details.http_proxy_port != 0) {
						curl_easy_setopt(curl_handle, CURLOPT_PROXYPORT, (long)details.http_proxy_port);
						qDebug() << (QString("proxy port: ").append(QString::number(details.http_proxy_port)).append("\n"));
					}
				}

				/* if proxy user name is available, then set the user name */
				if (details.http_proxy_login_user != NULL) {
					curl_easy_setopt(curl_handle, CURLOPT_PROXYUSERNAME, details.http_proxy_login_user);
					qDebug() << (QString("proxy username: ").append(details.http_proxy_login_user).append("\n"));
				}
				/* if proxy password is available, then set the password */
				if (details.http_proxy_login_password != NULL) {
					curl_easy_setopt(curl_handle, CURLOPT_PROXYPASSWORD, details.http_proxy_login_password);
					qDebug() << (QString("proxy PASSWORD: ").append(details.http_proxy_login_password).append("\n"));
				}

				/* no progress meter, please */
				curl_easy_setopt(curl_handle, CURLOPT_NOPROGRESS, 1L);

				/* send all data to this function  */
				curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, write_data);

				/*
				 * Notice here that if you want the actual data sent anywhere else but
				 * stdout, you should consider using the CURLOPT_WRITEDATA option.
				 */

			    BESSafeTcp::consoleLog("ready to connect\n");

				// get it!
				curl_easy_perform(curl_handle);

			    BESSafeTcp::consoleLog("retrieved data\n");

				/* Step 5: Tear Down and Clean Up
				 * ==============================
				 */

				// cleanup curl stuff
				curl_easy_cleanup(curl_handle);

		    }


		    // cleanup netstatus proxy details
		    netstatus_free_proxy_details(&details);
		}

	    // cleanup bps stuff
	    bps_shutdown();

    }
}

