/*
 * Copyright (c) 2012-2014 Research In Motion Limited.
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

#include "BESSafeTcp.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

using namespace bb::cascades;

TextArea *BESSafeTcp::m_console = NULL;
QString BESSafeTcp::m_consoleText;
QTimer *BESSafeTcp::m_timer = NULL;
BESSafeTcp *BESSafeTcp::m_singleton = NULL;

BESSafeTcp::BESSafeTcp(bb::cascades::Application *app)
: QObject(app)
{
    // create scene document from main.qml asset
    // set parent to created document to ensure it exists for the whole application lifetime
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    // create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    m_console = root->findChild<TextArea *>("console");

    // set created root object as a scene
    app->setScene(root);

    m_singleton = this;

    m_timer = new QTimer();
    m_timer->setSingleShot(true);
    m_timer->setInterval(1000);
	connect(m_timer, SIGNAL(timeout()), m_singleton, SLOT(updateConsole()));
}


void BESSafeTcp::consoleLog(const char* text) {
	consoleLog(QString(text));
}

void BESSafeTcp::consoleLog(const QString text) {
	qDebug() << text;

	if (m_consoleText.length() > 300) {
	    m_consoleText = "";
	}
	m_consoleText.append(text);

	m_timer->start();
}

void BESSafeTcp::updateConsole() {
	m_console->setText(m_consoleText);
}
