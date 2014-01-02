/* Copyright (c) 2013 BlackBerry Limited.
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

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include <bb/system/SystemDialog>
#include <bb/system/phone/Phone>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeManager>
#include <bb/PpsObject>

using namespace bb::cascades;
using namespace bb::system;

BlaqService::BlaqService(bb::cascades::Application *app) :
        QObject(app)
	,	m_dataSource(new CustomSqlDataSource(this))
{
	m_photoQuery = QLatin1String("INSERT INTO Photos (ClaimNo, OriginalPath,Created,Modified) VALUES (:ClaimNo, :OPath, :Created, :Modified)");

	m_dataSource->setSource("sql/data_r5.db");
	connect(m_dataSource, SIGNAL(reply(bb::data::DataAccessReply)), this, SLOT(onDataSourceReply(bb::data::DataAccessReply)));

    bool firstRun = getValueFor("firstRun", false).toBool();

    if (!firstRun) {
    	loadPhotos();
    	saveValueFor("firstRun", true);
    }

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

    qmlRegisterType < CustomSqlDataSource > ("autotrak.data", 1, 0, "CustomSqlDataSource");

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    QmlDocument::defaultDeclarativeEngine()->rootContext()->setContextProperty("_app", this);

    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    app->setScene(root);
}

QString BlaqService::copyToData(const QString& path) const {
	QFile sourceFile(path);

	qDebug() << "Exists: " << sourceFile.exists();

	if (sourceFile.open(QFile::ReadOnly)) {

		QByteArray base64Encoded  = sourceFile.readAll();
		QByteArray a = base64Encoded.toBase64();

		qDebug() << QString::fromLatin1(a);

		sourceFile.close();
		return QString(a);
	}
	return QLatin1String("");
}

void BlaqService::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("AutoTrak_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}

QString BlaqService::formatDate(const QString& dateStr) {
	QDateTime dt = QDateTime::fromString(dateStr, Qt::ISODate);

	return dt.toString("dddd, MMMM d, yyyy");
}

QDateTime BlaqService::strToDate(const QString& dateStr) {
	QDateTime dt = QDateTime::fromString(dateStr, Qt::ISODate);

	return dt;
}

void BlaqService::callNumber(const QString& number) {
	SystemDialog d;
	d.setTitle("Phone Call");
	d.setBody(QString("Call %1?").arg(number));

	SystemUiResult::Type result = d.exec();

	if (result == SystemUiResult::ConfirmButtonSelection) {
		bb::system::phone::Phone phone;
		phone.initiateCellularCall(number);
	}
}

void BlaqService::composeEmail(const QString& sendTo) {
	InvokeManager im;
	InvokeRequest request;
	request.setAction("bb.action.COMPOSE");
	request.setTarget("sys.pim.text_messaging.composer");
	request.setMimeType("application/text_messaging");
	QVariantMap map;
	map.insert("to", QVariantList() << sendTo);
	//map.insert("body", body);
	//map.insert("send", sendNow);
	QByteArray requestData = bb::PpsObject::encode(map, NULL);
	request.setData(requestData);
	im.invoke(request);
}

QVariant BlaqService::getValueFor(const QString &objectName, const QVariant &defaultValue)
{
    QSettings settings;

    // If no value has been saved return the value.
    if (settings.value(objectName).isNull()) {
        return defaultValue;
    }

    // Otherwise return the value stored in the settings object.
    return settings.value(objectName);
}

void BlaqService::saveValueFor(const QString &objectName, const QVariant &inputValue)
{
    // A new value is saved to the application settings object.
    QSettings settings;
    settings.setValue(objectName, inputValue);
}

void BlaqService::loadPhotos() {
	qDebug() << QDir::homePath();
	QString appFolder(QDir::homePath());
	appFolder.chop(4);

	QString photoDir = appFolder + "app/native/assets/img/samples/";

	QStringList filter = QStringList() << "*.jpg";

	QDir dir(photoDir);
	QFileInfoList files = dir.entryInfoList(filter);

	QVariantList values;

	for (int i=0; i < files.size(); ++i) {
		QFileInfo fi = files.value(i);

		QString claimNo = fi.fileName().split("_",QString::SkipEmptyParts).value(0);

		QVariantMap row;
		row["ClaimNo"] = claimNo;
		row["OPath"] = fi.filePath();
		row["Created"] = QDateTime::currentDateTime().toString(Qt::ISODate);
		row["Modified"] = QDateTime::currentDateTime().toString(Qt::ISODate);

		values.append(row);
	}
	m_dataSource->beginTransaction();
	m_dataSource->executeBatch(m_photoQuery, values, 1);
	m_dataSource->endTransaction();
	//qDebug() << files;
}

void BlaqService::onDataSourceReply(const bb::data::DataAccessReply& reply) {
    QString dataFolder = QDir::homePath();
    QString newFileName = dataFolder + QLatin1String("/photos/");

	QDir dir;

	switch (reply.id()) {
	case 1:
		QTimer::singleShot(1500, this, SLOT(movePhotos()));
		break;
	case 2:{
		QVariantList resultList = reply.result().value<QVariantList>();
		//qDebug() << resultList;

		int count = resultList.size();

		dir.mkpath(newFileName);
		for (int i=0; i < count; ++i) {
			QVariantMap map = resultList.value(i).toMap();
			QFile file(map.value("OriginalPath").toString());
			QFileInfo fileInfo(file);
			QString f = QString(newFileName).append(QString("%1.%2").arg(map.value("ID").toString()).arg(fileInfo.suffix()));

			qDebug() << f;
			//if (!file.exists()) {
				if (!file.copy(fileInfo.filePath(), f)) {
					qDebug() << file.errorString();
				}
			//}
		}
		break;
	}
	case 3:
	{
		QVariantMap map;
		map["OPath"] = m_importedPhotoPath;

		m_dataSource->execute("SELECT * FROM photos WHERE OriginalPath = :OPath", map, 4);
		break;
	}
	case 4:
	{
		dir.mkpath(newFileName);
		qDebug() << reply.result();

		QVariantMap map = reply.result().value<QVariantList>().at(0).toMap();
		QFile file(m_importedPhotoPath);
		QFileInfo fileInfo(file);
		QString f = QString(newFileName).append(QString("%1.%2").arg(map.value("ID").toString()).arg(fileInfo.suffix()));

		qDebug() << f;
		//if (!file.exists()) {
			if (!file.copy(fileInfo.filePath(), f)) {
				qDebug() << file.errorString();
			}
		//}
		emit photoImported();
		break;
	}
	}
}

void BlaqService::movePhotos() {
	QVariantMap map;
	m_dataSource->execute("SELECT * FROM Photos", map, 2);
}

QString BlaqService::dataPath() const {
	return QDir::homePath();
}

void BlaqService::importPhoto(const QString& claimNo, const QString& path) {
	m_importedPhotoPath = path;

	qDebug() << "Importing photo...";
	qDebug() << path;

	QVariantMap row;
	row["ClaimNo"] = claimNo;
	row["OPath"] = path;
	row["Created"] = QDateTime::currentDateTime().toString(Qt::ISODate);
	row["Modified"] = QDateTime::currentDateTime().toString(Qt::ISODate);

	m_dataSource->execute(m_photoQuery, row, 3);
}
