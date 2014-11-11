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

#ifndef CURLCONNECTTHREAD_HPP
#define CURLCONNECTTHREAD_HPP

#include <assert.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <openssl/err.h>

#include <openssl/ssl.h>

#include <bps/netstatus.h>
#include <curl/curl.h>

#include <QtCore/QThread>
#include <QtCore/QList>
#include <QtCore/QString>

#define READ_BUFFER_SIZE 1024


class CurlConnectThread :public QThread {

Q_OBJECT

public:
	CurlConnectThread();

	virtual ~CurlConnectThread();

	void run();
};

#endif /* CURLCONNECTTHREAD_HPP */

