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


#include "applicationui.hpp"

#include <cstdlib>
#include <time.h>
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/maps/MapView>
#include <bb/cascades/maps/MapData>
#include <bb/cascades/XmlDataModel>
#include <bb/platform/geo/GeoLocation>
#include <bb/platform/geo/Point>
#include <bb/platform/geo/Marker>
#include <bb/PpsObject>
#include <bb/system/InvokeManager>
#include <bb/platform/RouteMapInvoker>
#include <bb/platform/Notification.hpp>
#include <QTimer>
#include "salesforce/VolumeRequest.h"
#include "utils/UiConstants.h"
#include "Settings.h"
#include "Constants.h"

using namespace bb::cascades;
using namespace bb::system;
using namespace bb::platform;

#define VERSION_MAJOR 1
#define VERSION_MINOR 0

#define BB_OPEN_INVOCATION_ACTION "bb.action.OPEN"
//#define NOTIFICATION_PREFIX "com.bitheads.orlando_brewing_"
#define NOTIFICATION_PREFIX "com.bitheads.orlandobrewingapp"
#define INVOKE_TARGET_KEY_OPEN "com.bitheads.orlandobrewingapp.invoke.open"

#define SETTINGS_NEXT_NOTIFICATION_ID "SETTINGS_NEXT_NOTIFICATION_ID"

static const char* QMLSPACE = "bbmodel";

ApplicationUI::ApplicationUI(bb::cascades::Application *app) :
		QObject(app) {

	m_dataModel = new XmlDataModel(this);
	m_dataModel->setSource(QUrl("data/bars.xml"));

	m_logoutManager = new LogoutManager(this);

	m_barsDataModel = new ArrayDataModel(this);
	m_barRequest = new DataRequest();
	connect(m_barRequest, SIGNAL(dataReturned(QVariant)), this,
			SLOT(barDataReturned(QVariant)));

	m_contactRequest = new DataRequest();
	connect(m_contactRequest, SIGNAL(dataReturned(QVariant)), this,
			SLOT(contactReturned(QVariant)));

	m_progressdialog = NULL;
	m_toast = NULL;
	m_dialog = NULL;

	qmlRegisterType<RouteMapInvoker>(QMLSPACE, VERSION_MAJOR, VERSION_MINOR,"RouteMapInvoker");
	qmlRegisterType<VolumeRequest>(QMLSPACE, VERSION_MAJOR, VERSION_MINOR,"VolumeRequest");
	qmlRegisterType<DataRequest>(QMLSPACE, VERSION_MAJOR, VERSION_MINOR,"DataRequest");
	qRegisterMetaType<DataRequest*>("DataRequest*");
	qRegisterMetaType<VolumeRequest*>("VolumeRequest*");
	qmlRegisterType<QTimer>(QMLSPACE, VERSION_MAJOR, VERSION_MINOR,"QTimer");

	// create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
	QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

	qml->setContextProperty("app", this);
	qml->setContextProperty("uiConstants", &(UiConstants::getInstance()));
	qml->setContextProperty("settings", &(Settings::getInstance()));

	// create root object for the UI
	AbstractPane *root = qml->createRootObject<AbstractPane>();
	// set created root object as a scene
	app->setScene(root);
	
	m_invokeManager = new InvokeManager(this);
    connect(m_invokeManager, SIGNAL(invoked(const bb::system::InvokeRequest&)),
                SLOT(onInvoked(const bb::system::InvokeRequest&)));
}

void ApplicationUI::onInvoked(const bb::system::InvokeRequest &request)
{
	// The underlying PushService instance might not have been
	// initialized when an invoke first comes in
	// Make sure that we initialize it here if it hasn't been already
	// It requires an application ID (for consumer applications) so we have to check
	// that configuration settings have already been stored
	qDebug() << "ProjTWCtabbed::onInvoked - " << request.action();
	
	if (request.action().compare(BB_OPEN_INVOCATION_ACTION) == 0){
		QByteArray data = request.data();
		QString id = QString::fromUtf8(data.data(), data.size());
		qDebug() << "Received open action" << id;
		Q_EMIT gotoDetails(id);
	}
}

void ApplicationUI::login(QString username, QString pass) {
	qDebug() << "[brewmaster] ApplicationUI::login username=" << username
			<< ", pass=" << pass;

}

void ApplicationUI::sendBarsRequest() {
	this->barRequest()->execute(
			QString("/services/data/v27.0/query/?q=+SELECT+%NAMESPACE%__Account__r.Name,+%NAMESPACE%__Account__r.AccountNumber,+%NAMESPACE%__Account__r.%NAMESPACE%__BillingLatitude__c,+%NAMESPACE%__Account__r.%NAMESPACE%__BillingLongitude__c,+%NAMESPACE%__Account__r.%NAMESPACE%__Address__c,+%NAMESPACE%__Account__r.%NAMESPACE%__City__c+FROM+%NAMESPACE%__Bar_Reps__c+WHERE+%NAMESPACE%__Bar_Reps__c.Name+=+'%USERNAME%'"));
}

//+orlandobrew__Account__r.orlandobrew__beer_state__c,+
void ApplicationUI::authenticated() {
	qDebug() << "[brewmaster] ApplicationUI::authenticated";
	sendBarsRequest();

	// Create a notification for the push that will be added to the BlackBerry Hub
	QSettings settings;
	int notificationId = settings.value(SETTINGS_NEXT_NOTIFICATION_ID).isNull() == false ? settings.value(SETTINGS_NEXT_NOTIFICATION_ID).toInt() : 0;
	settings.setValue(SETTINGS_NEXT_NOTIFICATION_ID, QString::number(notificationId+1));
	Notification *notification = new Notification(NOTIFICATION_PREFIX+QString::number(notificationId), this);
	QStringList bodies;
	QStringList ids;
	
	srand (time(NULL));
	
	//Sample test notifications
	bodies << "Peabody Orlando's Olde Pelican tap is running low.";
	bodies << "Delta Sky Club has requested a new shipment of Blonde Ale.";
	bodies << "Renaissance Orlando Resort's needs more beer.";
	bodies << "Brick House Tavern & Tap did not receive their last Red Ale shipment and their tap is now empty.";
	bodies << "Caribe Royale's Brown Ale tap is running low.";

	ids << "0001";
	ids << "0002";
	ids << "0008";
	ids << "0000";	
	ids << "0006";

	int randx = rand() % bodies.size();
	notification->setTitle("Orlando Brewing");
	notification->setBody(bodies.at(randx));
	
	InvokeRequest invokeRequest;
	invokeRequest.setTarget(INVOKE_TARGET_KEY_OPEN);
	invokeRequest.setAction(BB_OPEN_INVOCATION_ACTION);
	invokeRequest.setMimeType("text/plain");
    invokeRequest.setData(ids.at(randx).toUtf8());
	notification->setInvokeRequest(invokeRequest);

	// Add the notification for the push to the BlackBerry Hub
	// Calling this method will add a "splat" to the application icon, indicating that a new push has been received
	notification->notify();
}

void ApplicationUI::refreshBars() {
	this->sendBarsRequest();
}
void ApplicationUI::barDataReturned(QVariant result) {
	qDebug() << "ApplicationUI::barDataReturned = " << result;

	QVariant list = result;
	QVariantMap listMap = list.toMap();
	QVariant dataList = listMap["records"];

	// Add the data to the model
	m_barsDataModel->clear();
	m_barsDataModel->append(dataList.toList());
	qDebug() << "\t m_barsDataModel size=" << m_barsDataModel->size();

	emit loggedIn();
	emit dataModelChanged();
}

void ApplicationUI::requestContact(QVariant number){
	this->contactRequest()->execute(
	QString("/services/data/v27.0/query/?q=SELECT+Name,+Phone,+" SF_NAMESPACE "__bbmpin__c+FROM+Contact+WHERE+Account.AccountNumber='" + number.toString() + "'"));
}

void ApplicationUI::contactReturned(QVariant result) {
	qDebug() << "ApplicationUI::contactReturned = " << result;

	QVariant list = result;
	QVariantMap listMap = list.toMap();
	QVariant dataList = listMap["records"];
	m_contactMap = dataList.toList().at(0).toMap();

	emit contactReturned();

	qDebug() << "\t contactReturned dataList=" << dataList;
	qDebug() << "\t contactReturned size=" << m_contactMap;
}

Q_INVOKABLE void ApplicationUI::launchMail(const QString &url) {
	qDebug() << "[brewmaster] composing mail" << url;

	InvokeManager* invokeManager = new InvokeManager(this);
	InvokeRequest request;

	request.setAction("bb.action.OPEN");
	request.setMimeType("text/plain");
	request.setUri(url);

	invokeManager->invoke(request);
}

Q_INVOKABLE void ApplicationUI::launchPhone(const QString &phoneNumber) {
	qDebug() << "[brewmaster] phoning #" << phoneNumber;

	InvokeManager* invokeManager = new InvokeManager(this);
	InvokeRequest request;
	QVariantMap map;

	map.insert("number", phoneNumber); // required
	QByteArray requestData = bb::PpsObject::encode(map, NULL);

	request.setAction("bb.action.DIAL");
	request.setMimeType("application/vnd.blackberry.phone.startcall");
	request.setData(requestData);

	invokeManager->invoke(request);
}

Q_INVOKABLE void ApplicationUI::launchBBMChat(QVariant pin) {
	qDebug() << "[brewmaster] launchBBMChat #" << pin;

	InvokeManager* invokeManager = new InvokeManager(this);
	InvokeRequest request;

	request.setAction("bb.action.BBMCHAT");
	request.setTarget("sys.bbm.sharehandler");
	request.setUri("pin:" + pin.toString());

	invokeManager->invoke(request);
}

DataModel* ApplicationUI::getDataModel() {
	return m_barsDataModel;
}
DataRequest* ApplicationUI::barRequest() {
	return m_barRequest;
}
DataRequest* ApplicationUI::contactRequest() {
	return m_contactRequest;
}
QVariantMap ApplicationUI::contactMap(){
	return m_contactMap;
}

void ApplicationUI::showMapAll(QObject *obj) {

	qDebug() << "ApplicationUI::showMapAll";

	bb::cascades::maps::MapView* mapview =
			dynamic_cast<bb::cascades::maps::MapView*>(obj);
	if (mapview) {
		//Clear the map data
		mapview->mapData()->clear();

		int count = 0;
		int size = m_barsDataModel->size();

		double minLat = 0;
		double maxLat = 0;
		double minLon = 0;
		double maxLon = 0;
		double lat = 0;
		double lon = 0;

		//Iterate over the data model and add locations to the map view
		for (int i = 0; i < size; i++) {

			QVariantMap map = m_barsDataModel->value(i).toMap();

			qDebug() << "CJ Whole thing: " << map;

			qDebug() << "map to string " << map[REL_PRE_BAR].toMap();

			QVariantMap barList = map[REL_PRE_BAR].toMap();
			QString latS = barList[BAR_LAT].toString();
			QString lonS = barList[BAR_LONG].toString();

			if (!latS.isEmpty() && !lonS.isEmpty()) {

				lat = barList[BAR_LAT].toDouble();
				lon = barList[BAR_LONG].toDouble();

				if (count == 0) {
					minLat = lat;
					maxLat = lat;
					minLon = lon;
					maxLon = lon;
				}

				bb::platform::geo::GeoLocation* location =
						new bb::platform::geo::GeoLocation();
				location->setParent(mapview);
				location->setAltitude(1000.0);
				location->setAltitudeMode(
						bb::platform::geo::AltitudeMode::ClampToGround);
				location->setId(QString::number(i));
				location->setName(barList[BAR_NAME].toString());
				location->setDescription(
						barList[BAR_ADDRESS].toString() + ", "
								+ barList[BAR_CITY].toString());
				bb::platform::geo::Point gp;
				gp.setLatitude(lat);
				gp.setLongitude(lon);
				location->setPoint(gp);

				bool status = mapview->mapData()->add(location);
				count++;
				qDebug() << "Adding point: " << lat << " " << lon << " " << status;

				if (lat < minLat)
					minLat = lat;
				if (lat > maxLat)
					maxLat = lat;
				if (lon < minLon)
					minLon = lon;
				if (lon > maxLon)
					maxLon = lon;
			} else {
				qDebug() << "No gps found...";
			}
		}

		//Set the altitude of the map view
		qDebug() << "MINLAT: " << minLat << maxLat << minLon << maxLon;
		mapview->setLatitude((minLat + maxLat) / 2.0);
		mapview->setLongitude((maxLon + minLon) / 2.0);
		double diffLat = (maxLat - minLat) / 2.0;
		double diffLon = (maxLon - minLon) / 2.0;
		if (diffLat < 0.0) {
			diffLat *= -1.0;
		}
		if (diffLon < 0.0) {
			diffLon *= 1.0;
		}
		double maxDiff = 0.01;
		if (diffLat > maxDiff) {
			maxDiff = diffLat;
		}
		if (diffLon > maxDiff) {
			maxDiff = diffLon;
		}
		mapview->setAltitude(maxDiff * 300000.0);
	}
}

void ApplicationUI::showMap(QObject *obj, QVariant latV, QVariant lonV,
		QVariant name, QVariant desp) {
	bb::cascades::maps::MapView* mapview =
			dynamic_cast<bb::cascades::maps::MapView*>(obj);
	if (mapview) {
		double lat = 0;
		double lon = 0;

		//Clear the map data
		mapview->mapData()->clear();

		QString latS = latV.toString();
		QString lonS = lonV.toString();

		if (!latS.isEmpty() && !lonS.isEmpty()) {

			//Add point to the map
			lat = latV.toDouble();
			lon = lonV.toDouble();

			bb::platform::geo::GeoLocation* location =
					new bb::platform::geo::GeoLocation();
			location->setParent(mapview);
			location->setAltitude(1000.0);
			location->setAltitudeMode(
					bb::platform::geo::AltitudeMode::ClampToGround);
			location->setName(name.toString());
			location->setDescription(desp.toString());
			bb::platform::geo::Point gp;
			gp.setLatitude(lat);
			gp.setLongitude(lon);
			location->setPoint(gp);

			mapview->mapData()->add(location);

			mapview->setLatitude(lat);
			mapview->setLongitude(lon);
		}
		mapview->setAltitude(2000);
	}
}

/**
 * Webview navigation
 */
void ApplicationUI::navigationRequested(QUrl url) {
	qDebug() << "ApplicationUI::navigationRequested url = " << url.toString();
	 QMap<QString, QString> map;

	if(url.hasFragment()){
		QString itemStr = url.toString().remove("sfdc://success#");
		QStringList items = itemStr.split("&");
		QStringList item;
		for(int i=0; i<items.length(); i++){
			item = items.at(i).split("=");
			QString key = item.at(0);
			QString value = item.at(1);
			Settings::getInstance().saveValueFor(key, value);
			qDebug() << "ApplicationUI::navigationRequested ITEM " <<  key << " = " << value;
		}

		authenticated();
	}
}

/**
 * Log the user out and clear all internal authentication values from store.
 */
void ApplicationUI::clearAuth() {

	if(m_progressdialog == NULL){
		m_progressdialog = new SystemProgressToast();
	}

	m_progressdialog->setBody("Logging out...");
	m_progressdialog->setProgress(-1);
	m_progressdialog->setState(SystemUiProgressState::Active);

	bool success = connect(m_logoutManager, SIGNAL(loggedOut()), this,
			SLOT( finishLogout()));

	//Logout from salesforce
	m_logoutManager->logout();
	m_progressdialog->show();
}

void ApplicationUI::finishLogout(){
	qDebug() << "ApplicationUI::finishLogout";
	Settings::getInstance().clearValueFor(AUTH_TOKEN);
	Settings::getInstance().clearValueFor(AUTH_URL);
	Settings::getInstance().clearValueFor(AUTH_ID);
	Settings::getInstance().clearValueFor(AUTH_ISSUE);
	Settings::getInstance().clearValueFor(AUTH_SIGNATURE);
	m_progressdialog->cancel();
	emit finishLoggingOut();
}

/**
 * Show a system toast message
 */
void ApplicationUI::showToast(QVariant body) {
	if (m_toast == NULL) {
		m_toast = new bb::system::SystemToast(this);
	}
	m_toast->setBody(body.toString());
	m_toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
	m_toast->show();
}

/**
 * Show a system dialog message
 */
void ApplicationUI::showDialog(QString title, QString message) {
	//Dialog with message and OK button
	if (m_dialog == NULL) {
		m_dialog = new bb::system::SystemDialog(tr("OK"), this);
	}
	m_dialog->setTitle(title);
	m_dialog->setBody(message);
	m_dialog->setDismissAutomatically(true);
	m_dialog->show();
}
