/*Copyright (c) 2013 BlackBerry Limited.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*/

#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include <bb/cascades/Button>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeTargetReply>
#include <bb/system/InvokeReplyError>
#include <bb/system/InvokeRequest>
#include <bb/cascades/Invocation>
#include <bb/cascades/InvokeQuery>
#include <bb/system/InvokeRequest>
#include <iostream>
#include <bb/PpsObject>

using namespace std;
using namespace bb::cascades;
using namespace bb::system;

ApplicationUI::ApplicationUI(bb::cascades::Application *app) :
        QObject(app)
{
    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);
    if(!QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()))) {
        // This is an abnormal situation! Something went wrong!
        // Add own code to recover here
        qWarning() << "Recovering from a failed connect()";
    }
    // initial load
    onSystemLanguageChanged();

    //check status of slot/signal connection (assert during debug build if connectd fails)
    bool connectResult;

    Q_UNUSED(connectResult)

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

	// Set created root object as the application scene
    app->setScene(root);

    bb::cascades::Button* btnAdobe = root->findChild<Button*>("invokeAdobe");

   	// Connect the button signal to the slot
   	connectResult = QObject::connect(btnAdobe, SIGNAL(clicked()), this,
   			SLOT(invokeAdobe()));

    bb::cascades::Button* btnBrowser = root->findChild<Button*>("launchBrowser");

   	// Connect the button signal to the slot
   	connectResult = QObject::connect(btnBrowser, SIGNAL(clicked()), this,
   			SLOT(invokeBrowser()));

   	bb::cascades::Button* btnPhone = root->findChild<Button*>("launchPhone");

	// Connect the button signal to the slot
	connectResult = QObject::connect(btnPhone, SIGNAL(clicked()), this,
			SLOT(invokePhone()));

	bb::cascades::Button* btnEIM = root->findChild<Button*>("launchEIM");

	// Connect the button signal to the slot
	connectResult = QObject::connect(btnEIM, SIGNAL(clicked()), this,
			SLOT(invokeEIM()));

	//fired during debug builds only if connect fails
   	Q_ASSERT(connectResult);

}

//invoke adobe reader application as a card
void ApplicationUI::invokeAdobe() {
	InvokeManager invokeManager;
	InvokeRequest request;

	QString uri = "file:" + QDir::currentPath() + "/app/native/assets/docs/panther.pdf";

	// Target ID for app we're invoking
	request.setTarget("com.rim.bb.app.adobeReader.viewer");

	// Action we want target application to perform
	request.setAction("bb.action.VIEW");

	// Type of data we're sending
	request.setMimeType("application/pdf");

	// The actual data
	request.setUri(uri);

	InvokeTargetReply *reply = invokeManager.invoke(request);
}

//invoke the blakcberry browser
void ApplicationUI::invokeBrowser() {
	InvokeManager invokeManager;
	InvokeRequest request;
	QString uri = "http://bizblog.blackberry.com";

	cout << "uri for browser = $" << uri.toStdString() << endl;


	// Target ID for app we're invoking
	request.setTarget("sys.browser");

	// Action we want target application to perform
	request.setAction("bb.action.OPEN");

	// The actual data
	request.setUri(uri);

	InvokeTargetReply *reply = invokeManager.invoke(request);
}

//invoke the phone with a number prepoulated
void ApplicationUI::invokePhone() {
	InvokeManager invokeManager;
	InvokeRequest request;

	// What do we want the target application to do with it?
	request.setAction("bb.action.DIAL");

	// What are we sending?
	request.setMimeType("application/vnd.blackberry.phone.startcall");

    // Where is the data?
    QVariantMap map;
    map.insert("number", "15559223145"); // required
    map.insert("line_id", "cellular"); // optional
    QByteArray requestData = bb::PpsObject::encode(map, NULL);
    request.setData(requestData);

    InvokeTargetReply *reply = invokeManager.invoke(request);

}

//invoke Enterprise Instant Messenger
void ApplicationUI::invokeEIM() {
	InvokeManager invokeManager;
	InvokeRequest request;

	// Who do we want to send the invoke request to?
	request.setTarget("com.rim.bb.app.eimclient");

	// What do we want the target application to do with it?
	request.setAction("bb.action.VIEW");

	InvokeTargetReply *reply = invokeManager.invoke(request);
}


void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("InvokeWorkCoreApps_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}
