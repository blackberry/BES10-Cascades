/* Copyright (c) 2013, 2014  BlackBerry Limited.
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
 *
 */

#include "SubmitExpense.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include <bb/platform/Notification>
#include <bb/platform/NotificationError>
#include <bb/platform/NotificationResult>

using namespace bb::cascades;
using namespace bb::platform;

QString NOTIFICATION_PREFIX_EXPENSE = "ExpenseReport";

// The content types that Push Collector can display (images, HTML/XML, and plain text)
#define CONTENT_TYPE_IMAGE   "image"
#define CONTENT_TYPE_XML     "xml"
#define CONTENT_TYPE_TEXT    "text"

// The various file extensions that are supported
#define FILE_EXTENSION_XML  ".xml"
#define FILE_EXTENSION_HTML ".html"
#define FILE_EXTENSION_TEXT ".txt"
#define FILE_EXTENSION_JPEG ".jpg"
#define FILE_EXTENSION_GIF  ".gif"
#define FILE_EXTENSION_PNG  ".png"

SubmitExpense::SubmitExpense(bb::cascades::Application *app)
        : QObject(app) {
    // create scene document from main.qml asset
    // set parent to created document to ensure it exists for the whole application lifetime
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    qml->setContextProperty("cppSubmitExpense", this);

    // create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();
    // set created root object as a scene
    app->setScene(root);
}

QString SubmitExpense::pushContentFileExtension(const QString &contentTypeHeaderValue) const {
    if (contentTypeHeaderValue.startsWith("application/xml")) {
        return FILE_EXTENSION_XML;
    }
    else if (contentTypeHeaderValue.startsWith("text/html")) {
        return FILE_EXTENSION_HTML;
    }
    else if (contentTypeHeaderValue.startsWith("image/jpeg")) {
        return FILE_EXTENSION_JPEG;
    }
    else if (contentTypeHeaderValue.startsWith("image/gif")) {
        return FILE_EXTENSION_GIF;
    }
    else if (contentTypeHeaderValue.startsWith("image/png")) {
        return FILE_EXTENSION_PNG;
    }
    else if (contentTypeHeaderValue.startsWith("text/plain")) {
        return FILE_EXTENSION_TEXT;
    }
    else {
        qWarning() << "File extension is unknown for Content-Type header value: " << contentTypeHeaderValue << ".";
        return "";
    }
}

void SubmitExpense::sendNotificationForExpenses() {
    // Create a notification for the push that will be added to the BlackBerry Hub
    Notification *notification = new Notification(NOTIFICATION_PREFIX_EXPENSE + QString::number(333), this);
    notification->setTitle("Expenses from John Smith");

    notification->setBody(QString("Receipts for: Must Buy  \n\nExpenses Total: $35.02").arg(FILE_EXTENSION_TEXT));

    InvokeRequest invokeRequest;
    invokeRequest.setTarget("com.example.ExpenseReport.invoke.open"); //INVOKE_TARGET_KEY_OPEN);
    invokeRequest.setAction("bb.action.OPEN"); //BB_OPEN_INVOCATION_ACTION);
    invokeRequest.setMimeType("text/plain");
    invokeRequest.setData(QByteArray::number(333));
    notification->setInvokeRequest(invokeRequest);

    notification->notify();
}

void SubmitExpense::sendNotificationForCRM(int iVal) {
}

QString SubmitExpense::getHomeDir() {
    return QDir::homePath();
}
