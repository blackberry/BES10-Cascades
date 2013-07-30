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


// Navigation pane project template
#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>
#include <bb/cascades/DataModel>
#include <bb/cascades/XmlDataModel>
#include <bb/cascades/GroupDataModel>
#include <bb/system/SystemToast>
#include <bb/system/SystemDialog>
#include <bb/system/SystemProgressDialog>
#include <bb/system/SystemProgressToast>
#include <bb/cascades/ArrayDataModel>
#include "salesforce/DataRequest.h"
#include <bb/system/InvokeRequest.hpp>
#include <bb/system/InvokeManager>
#include "salesforce/LogoutManager.h"
#include <QUrl>

namespace bb { namespace cascades { class Application; }}

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class ApplicationUI : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bb::cascades::DataModel* dataModel READ getDataModel NOTIFY dataModelChanged)
    Q_PROPERTY(DataRequest* barRequest READ barRequest)
    Q_PROPERTY(DataRequest* contactRequest READ contactRequest)
    Q_PROPERTY(QVariantMap contactMap READ contactMap NOTIFY contactReturned)


public:
    ApplicationUI(bb::cascades::Application *app);
    virtual ~ApplicationUI() {}
    
    Q_INVOKABLE void launchMail(const QString &url);
    Q_INVOKABLE void launchPhone(const QString &phoneNumber);
    Q_INVOKABLE void launchBBMChat(QVariant pin);
    Q_INVOKABLE void showMapAll(QObject *obj);
    Q_INVOKABLE void showMap(QObject *obj,  QVariant latV, QVariant lonV, QVariant name, QVariant desp);
    Q_INVOKABLE void showToast(QVariant body);
    Q_INVOKABLE void showDialog(QString title, QString message);
    Q_INVOKABLE void login(QString username, QString pass);
    Q_INVOKABLE void refreshBars();
    void sendBarsRequest();
    Q_SLOT void onInvoked(const bb::system::InvokeRequest &request);
    
    bb::cascades::DataModel* getDataModel();
    DataRequest* barRequest();
    DataRequest* contactRequest();
    QVariantMap contactMap();

    Q_INVOKABLE void navigationRequested(QUrl str);
    Q_INVOKABLE void requestContact(QVariant accountName);
    Q_INVOKABLE void clearAuth();

    Q_SLOT void finishLogout();

    Q_SIGNALS:
    	void dataModelChanged();
    	void loggedIn();
    	void gotoDetails(QString barId);
    	void contactReturned();
    	void finishLoggingOut();

private:

    void authenticated();
    Q_SLOT void barDataReturned(QVariant result);
    Q_SLOT void contactReturned(QVariant result);
    bb::cascades::XmlDataModel* m_dataModel;
    bb::cascades::ArrayDataModel* m_barsDataModel;
    DataRequest* m_barRequest;
    DataRequest* m_contactRequest;

	bb::system::InvokeManager *m_invokeManager;

	LogoutManager* m_logoutManager;

	QVariantMap m_contactMap;

	bb::system::SystemDialog *m_dialog;
	bb::system::SystemToast *m_toast;
	bb::system::SystemProgressToast *m_progressdialog;
};

#endif /* ApplicationUI_HPP_ */
