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
 * DataRequest.h
 *
 *  Created on: May 1, 2013
 *      Author: farahh
 */

#ifndef DATAREQUEST_H_
#define DATAREQUEST_H_

#include <qobject.h>
#include "NetworkBase.h"

/**
 * This class is used to request all the Bar and Beer data from the cloud servers.
 */
class DataRequest: public NetworkBase {
	Q_OBJECT

public:
	DataRequest();
	virtual ~DataRequest();

	Q_INVOKABLE void execute(QString query);
	Q_SIGNAL void dataReturned(QVariant result);
	Q_SIGNAL void averageCalculated(QVariant result);

private:
    void requestResponse(QByteArray& result);
};

#endif /* DATAREQUEST_H_ */
