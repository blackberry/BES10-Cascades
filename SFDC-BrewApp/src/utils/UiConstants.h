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
 * UiConstants.h
 *
 *  Created on: Oct 25, 2012
 *      Author: chrisj
 */

#ifndef UICONSTANTS_H_
#define UICONSTANTS_H_

#include <qobject.h>

/**
 * This class defines all the UI constants mostly used to access device screen info
 */
class UiConstants : public QObject {
	Q_OBJECT

	// DisplayInfo
	Q_PROPERTY(bool q10 READ isQ10 CONSTANT);
	Q_PROPERTY(int deviceW READ deviceW CONSTANT);
	Q_PROPERTY(int deviceH READ deviceH CONSTANT);
	
	
public:
	UiConstants();
	virtual ~UiConstants();
	static UiConstants& getInstance()
	{
		static UiConstants instance; // Guaranteed to be destroyed.
		return instance;
	}

	Q_INVOKABLE bool isQ10() const { return ( m_deviceHeight < 1000); }  // Z10: 1280 H; Q10: 720 H
	int deviceW() const { return m_deviceWidth; }
	int deviceH() const { return m_deviceHeight; }

private:
	int m_deviceWidth;
	int m_deviceHeight;
};

#endif /* UICONSTANTS_H_ */
