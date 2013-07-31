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
 * Settings.h
 *
*  Created on: 6 Dec 2012
 *      Author: heatherf
 */

#ifndef SETTINGS_H_
#define SETTINGS_H_

#include <QLocale>
#include <QObject>
#include <QVariant>

class Settings : public QObject {
	Q_OBJECT

	Q_PROPERTY(bool isFirstStart READ isFirstStart);
	Q_PROPERTY(bool isFirstStartAfterUpgrade READ isFirstStartAfterUpgrade);
	Q_PROPERTY(QString country READ getCountry WRITE setCountry NOTIFY countryChanged);

public:

	virtual ~Settings();
	static Settings& getInstance() {
		static Settings instance; // Guaranteed to be destroyed.
		return instance;
	}

	Q_INVOKABLE QString applicationVersion() const;

	QString getValueFor(const QString &objectName, const QString &defaultValue);
	void saveValueFor(const QString &objectName, const QString &inputValue);
	void clearValueFor(const QString &objectName);

	int getValueFor(const QString &objectName, const int defaultValue);
	void saveValueFor(const QString &objectName, const int inputValue);
	
	bool		isFirstStart() const;
	bool		isFirstStartAfterUpgrade() const;
	QString		getCountry();

	void setCountry(QString country);

	Q_SIGNALS:
	void countryChanged();

private:
	Settings();
	Settings(Settings const&); // Don't implement
	void operator=(Settings const&); // Don't implement
	QString m_country;
	bool m_isFirstStart;
	bool m_isFirstStartAfterUpgrade;
};

#endif /* SETTINGS_H_ */
