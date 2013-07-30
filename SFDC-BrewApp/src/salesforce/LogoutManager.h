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
 * LogoutManager.h
 *
 *  Created on: Apr 30, 2013
 *      Author: farahh
 */

#ifndef LogoutManager_H_
#define LogoutManager_H_

#include <qobject.h>
#include "NetworkBase.h"

/**
 * Logout manager handles the logout request
 */
class LogoutManager : public NetworkBase {
	Q_OBJECT

public:
	LogoutManager(QObject* parent = NULL);
	virtual ~LogoutManager();

	//Logout for OAUTH tokens
	//Reference: http://help.salesforce.com/help/doc/en/remoteaccess_revoke_token.htm
	void logout();
	Q_SIGNAL void loggedOut();
	Q_SLOT void responseOK();

private:
    void requestResponse(QByteArray& result);

};

#endif /* LogoutManager_H_ */
