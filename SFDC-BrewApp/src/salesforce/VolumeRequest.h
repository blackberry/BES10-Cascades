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
 * VolumeRequest.h
 *
 *  Created on: May 3, 2013
 *      Author: bradg
 */

#ifndef VOLUMEREQUEST_H_
#define VOLUMEREQUEST_H_

#include <qobject.h>
#include "NetworkBase.h"

/**
 * The volume request is a network request for all the different beer volumes at a paticular bar
 */
class VolumeRequest: public NetworkBase {
	Q_OBJECT

	Q_PROPERTY(QString barid READ barid WRITE setBarid NOTIFY baridChanged)
	Q_PROPERTY(QString beerid READ beerid WRITE setBeerid NOTIFY beeridChanged)
	Q_PROPERTY(QString beerids READ beerids WRITE setBeerids NOTIFY beeridsChanged)
	Q_PROPERTY(int period READ period WRITE setPeriod NOTIFY periodChanged)
	Q_PROPERTY(int offset READ offset WRITE setOffset NOTIFY offsetChanged)

	Q_PROPERTY(int total READ total NOTIFY totalChanged)
	Q_PROPERTY(int average READ average NOTIFY averageChanged)
	Q_PROPERTY(int max READ max NOTIFY maxChanged)
	Q_PROPERTY(int min READ min NOTIFY minChanged)
	
public:
	VolumeRequest();
	virtual ~VolumeRequest();
	
	enum {
		WEEK = 0,
		MONTH
	} VolumePeriod;
	
	Q_INVOKABLE void execute();
	QString periodStatement();
	QVariantMap mutateRecords(QVariantList &records);
	QString labelForDateString(QString str);
	
	void setPeriod(int period);
	void setBarid(QString barid);
	void setBeerid(QString beerid);
	void setBeerids(QString beerids);
	void setOffset(int offset);

	QString barid();
	QString beerid();
	QString beerids();
	int period();
	int offset();
	int total();
	int average();
	int max();
	int min();
	
Q_SIGNALS:
	void success(QVariantMap records);
	void baridChanged();
	void beeridChanged();
	void beeridsChanged();
	void periodChanged();
	void offsetChanged();
	void totalChanged();
	void averageChanged();
	void maxChanged();
	void minChanged();
protected:
    void requestResponse(QByteArray& result);
    void setTotal(int total);
    void setAverage(int average);
    void setMin(int min);
    void setMax(int max);
    
private:
    QString m_barid;
    QString m_beerid;
    QString m_beerids;
    int m_period;
    int m_offset;

    int m_total;
    int m_average;
    int m_min;
    int m_max;
};

Q_DECLARE_METATYPE( VolumeRequest* );

#endif
