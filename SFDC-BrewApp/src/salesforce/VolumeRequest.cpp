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
 * VolumeRequest.cpp
 *
 *  Created on: May 3, 2013
 *      Author: bradg
 */

#include "VolumeRequest.h"
#include "../Settings.h"
#include <bb/data/JsonDataAccess>
#include <Qt/qdatetime.h>
#include <algorithm>
#include "../Constants.h"

using namespace bb::data;

VolumeRequest::VolumeRequest() : m_offset(0),
	NetworkBase::NetworkBase() {
}

VolumeRequest::~VolumeRequest() {
	
}

void VolumeRequest::execute() {
	QString url = Settings::getInstance().getValueFor(AUTH_URL, "");
	QString authToken = "Bearer " + Settings::getInstance().getValueFor(AUTH_TOKEN, "");
	QString query = "";
	
	if ( m_beerid != NULL ) {
		query = "/services/data/v24.0/query/?q=SELECT+id,+" SF_NAMESPACE "__quantity__c,+" SF_NAMESPACE "__quantity_remaining__c,+" SF_NAMESPACE "__date__c,+" SF_NAMESPACE "__Account__r.AccountNumber,+" SF_NAMESPACE "__Product__r.ProductCode+FROM+" SF_NAMESPACE "__Volume__c+where+" SF_NAMESPACE "__Account__r.AccountNumber+=+'"+m_barid+"'+and+" SF_NAMESPACE "__Product__r.ProductCode+=+'"+m_beerid+"'+order+by+" SF_NAMESPACE "__date__c+limit+4+offset+"+QString::number(m_offset);
	} else {
		query = "/services/data/v24.0/query/?q=SELECT+SUM(" SF_NAMESPACE "__quantity__c)+quantity,+SUM(" SF_NAMESPACE "__quantity_remaining__c)+quantity_remaining,+DAY_ONLY(" SF_NAMESPACE "__date__c)+date+FROM+" SF_NAMESPACE "__Volume__c+where+" SF_NAMESPACE "__Account__r.AccountNumber+=+'"+m_barid+"'+and+" SF_NAMESPACE "__Product__r.ProductCode+IN+("+m_beerids+")+group+by+DAY_ONLY(" SF_NAMESPACE "__date__c)+limit+4+offset+"+QString::number(m_offset);
	}
	
	QUrl requestURL(url + query);
	
	qDebug() << "VOLUME QUERY: " << query;
	
	m_request = createNetworkRequest(requestURL,false);
	m_request->setRawHeader("Authorization", authToken.toUtf8());

	if (!submitRequest(m_request)) {
		qWarning() << "***** There is already a Data Request in progress";
	}
}

QString VolumeRequest::labelForDateString(QString str) {
	QDateTime dt = m_beerid != NULL ? QDateTime::fromString(str, "yyyy-MM-dd'T'HH:mm:ss.zzz'+0000'") : QDateTime::fromString(str, "yyyy-MM-dd");
	return dt.toString("MMM dd");
}

QVariantMap VolumeRequest::mutateRecords(QVariantList &records) {
	QVariantMap mutatedRecords;
	int max = 0, min = INT_MAX, average = 0;
	int total = 0, size = records.size();
	
	for ( int i = 0; i < size; i++ ) {
		QVariantMap record = records.at(i).toMap();
		QString sQuantityRemaining = m_beerid != NULL ? record.value(SF_NAMESPACE "__quantity_remaining__c").toString() : record.value("quantity_remaining").toString();
		QString dateString = m_beerid != NULL ? record.value(SF_NAMESPACE "__date__c").toString() : record.value("date").toString();
		int quantityRemaining = sQuantityRemaining.toInt();
		
		max = std::max(quantityRemaining, max);
		min = std::min(quantityRemaining, min);
		total += quantityRemaining;
		
		mutatedRecords[labelForDateString(dateString)] = sQuantityRemaining;
	}
	
	average = total / size;
	
	this->setMin(min);
	this->setMax(max);
	this->setAverage(average);
	this->setTotal(total);
	
	return mutatedRecords;
}

void VolumeRequest::requestResponse(QByteArray& result) {
	qDebug() << " DataRequest::requestResponse QString result=" << QString(result);
	
	JsonDataAccess jda;
	QVariant jsonVariant = jda.loadFromBuffer( QString(result));
	
	QVariantMap map = jsonVariant.toMap();
	QVariantList records = map.value("records").toList();
	
	emit success(mutateRecords(records));
}

QString VolumeRequest::periodStatement() {
	switch (m_period) {
		case WEEK:
			return "WEEK";
			break;
		case MONTH:
			return "MONTH";
			break;
	}
	return "";
}

void VolumeRequest::setBarid(QString barid) {
	m_barid = barid;
	Q_EMIT baridChanged();
}
void VolumeRequest::setBeerid(QString beerid) {
	m_beerid = beerid;
	Q_EMIT beeridChanged();
}
void VolumeRequest::setBeerids(QString beerids) {
	m_beerids = beerids;
	Q_EMIT beeridsChanged();
}
void VolumeRequest::setPeriod(int period) {
	m_period = period;
	Q_EMIT periodChanged();
}
void VolumeRequest::setOffset(int offset) {
	m_offset = offset;
	Q_EMIT offsetChanged();
}
void VolumeRequest::setTotal(int total) {
	m_total = total;
	Q_EMIT totalChanged();
}
void VolumeRequest::setAverage(int average) {
	m_average = average;
	Q_EMIT averageChanged();
}
void VolumeRequest::setMin(int min) {
	m_min = min;
	Q_EMIT minChanged();
}
void VolumeRequest::setMax(int max) {
	m_max = max;
	Q_EMIT maxChanged();
}

QString VolumeRequest::barid() {
	return m_barid;
}
QString VolumeRequest::beerid() {
	return m_beerid;
}
QString VolumeRequest::beerids() {
	return m_beerids;
}
int VolumeRequest::period() {
	return m_period;
}
int VolumeRequest::offset() {
	return m_offset;
}
int VolumeRequest::total() {
	return m_total;
}
int VolumeRequest::average() {
	return m_average;
}
int VolumeRequest::max() {
	return m_max;
}
int VolumeRequest::min() {
	return m_min;
}
