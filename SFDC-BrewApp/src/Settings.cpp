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
 * Settings.cpp
 *
 *  Created on: 6 Dec 2012
 *      Author: heatherf
 */

#include "Settings.h"

#include <QObject>
#include <bb/cascades/Application>
#include <QSettings>
#include <QMap>
#include <bps/region.h>

static const char
	* KEY_SETTINGS_IS_FIRST_START		= "SETTINGS_IS_FIRST_START",
	* KEY_SETTINGS_PREVIOUS_VERSION		= "SETTINGS_PREVIOUS_VERSION";

/**
 * Application settings to be kept on the keystore.
 *
 */
Settings::Settings() : m_isFirstStart(true), m_isFirstStartAfterUpgrade(false) {

	this->setObjectName("Settings");
	
	// We set up the application Organization and name, this is used by QSettings
	// when saving values to the persistent store.
	QCoreApplication::setOrganizationName("Blackberry");
	QCoreApplication::setApplicationName("BrewMaster");
	
	//this->setCountry(QLocale::system().country());
	
	char *country = NULL;
	char *language = NULL;
	region_get(&language, &country);
	qDebug() << "language" << QString(language) << "country" << QString(country);
	
	this->setCountry(country);
	
	bps_free(country);
	bps_free(language);
	
	QSettings settings;
	m_isFirstStart = this->getValueFor(KEY_SETTINGS_IS_FIRST_START, true);
	if (m_isFirstStart == false) {
		qDebug() << "[Settings] This is not the first time the application has been run";
	} else {
		qDebug() << "[Settings] First start";
	}
	
	// Check if this is the first start after an upgrade.
	QString previousVersion = this->getValueFor(KEY_SETTINGS_PREVIOUS_VERSION, "");
	if (previousVersion.isEmpty() || previousVersion != applicationVersion()) {
		m_isFirstStartAfterUpgrade = true;
	}
}

Settings::~Settings() {
	QSettings settings;
	this->saveValueFor(KEY_SETTINGS_IS_FIRST_START, false);
	this->saveValueFor(KEY_SETTINGS_PREVIOUS_VERSION, applicationVersion());
}

bool contains(const QString &objectName) {
	// A new value is saved to the application settings object.
	QSettings settings;
	return settings.contains(objectName);
}

bool Settings::isFirstStart() const {
	return m_isFirstStart;
}

bool Settings::isFirstStartAfterUpgrade() const {
	return m_isFirstStartAfterUpgrade;
}

QString Settings::getValueFor(const QString &objectName, const QString &defaultValue) {

	QSettings settings;

	// If no value has been saved return the value.
	if (settings.value(objectName).isNull()) {
		return defaultValue;
	}

	// Otherwise return the value stored in the settings object.
	return settings.value(objectName).toString();
}

void Settings::saveValueFor(const QString &objectName, const QString &inputValue) {
	// A new value is saved to the application settings object.
	QSettings settings;
	settings.setValue(objectName, QVariant(inputValue));
}

void Settings::clearValueFor(const QString &objectName) {
	// A new value is saved to the application settings object.
	QSettings settings;
	settings.remove(objectName);
}

int Settings::getValueFor(const QString &objectName, const int defaultValue) {
	QSettings settings;

	// If no value has been saved return the value.
	if (settings.value(objectName).isNull()) {
		return defaultValue;
	}

	// Otherwise return the value stored in the settings object.
	return settings.value(objectName).toInt();
}

void Settings::saveValueFor(const QString &objectName, const int inputValue) {
	// A new value is saved to the application settings object.
	QSettings settings;
	settings.setValue(objectName, QVariant(inputValue));
}

QString Settings::getCountry() {
	return m_country;
}

void Settings::setCountry(QString country) {
	if ( country != m_country ) {
		m_country = country;
		qDebug() << "[Settings] country set to" << m_country;
		Q_EMIT countryChanged();
	}
}

QString Settings::applicationVersion() const {
	QString version = bb::cascades::Application::instance()->applicationVersion();
	//QRegExp regex("(\\d+\\.\\d+\\.\\d+).\\d+");
	//if (regex.indexIn(version) != -1) return regex.cap(1);
	return version;
}
