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
 * UiConstants.cpp
 *
 *  Created on: Oct 25, 2012
 *      Author: chrisj
 */

#include "UiConstants.h"
#include <bb/cascades/SystemDefaults>
#include <bb/device/DisplayInfo>
#include <stdio.h>
#include <time.h>
#include <bps/deviceinfo.h>

const char* TMPL_COMMA_SPACE_1 = ", %1";

using namespace bb::device;

UiConstants::UiConstants() {
	bb::device::DisplayInfo display;
	m_deviceWidth = display.pixelSize().width(); // 768; //
	m_deviceHeight =  display.pixelSize().height(); // 1280; //
}

UiConstants::~UiConstants() {}
