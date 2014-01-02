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



#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>
#include <QDateTime>
#include <QVariantMap>
#include <QFileInfoList>
#include <QFileInfo>
#include <QDebug>

#include "customsqldatasource.h"

namespace bb
{
    namespace cascades
    {
        class Application;
        class LocaleHandler;
    }
}

class QTranslator;

/*!
 * @brief Application object
 *
 *
 */

class BlaqService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString dataPath READ dataPath CONSTANT)
public:
    BlaqService(bb::cascades::Application *app);
    virtual ~BlaqService() { }

    Q_INVOKABLE QString copyToData(const QString& path) const;

    Q_INVOKABLE QString formatDate(const QString& dateStr);
    Q_INVOKABLE QDateTime strToDate(const QString& dateStr);

    Q_INVOKABLE void callNumber(const QString& number);
    Q_INVOKABLE void composeEmail(const QString& to);

    Q_INVOKABLE void importPhoto(const QString& claimNo, const QString& path);

    /**
     * Invokable functions that we can call from QML.
     * This function get's a value from the QSettings,
     * if that value does not exist in the QSettings database, that data will be added.
     *
     * @param objectName Index path to the item.
     * @param defaultValue is used to create that data in the database when created.
     */
    Q_INVOKABLE static QVariant getValueFor(const QString &objectName, const QVariant &defaultValue);

    /**
       * Invokable functions that we can call from QML.
       * This function sets a value in the QSettings database, it's supposed to be called
       * when a datavalue has been updated from QML
       *
       * @param objectName Index path to the item.
       * @param inputValue new value to the QSettings database.
       */

    Q_INVOKABLE static void saveValueFor(const QString &objectName, const QVariant &inputValue);

    void loadPhotos();

    QString dataPath() const;

private slots:
	Q_INVOKABLE void movePhotos();
    void onSystemLanguageChanged();
    void onDataSourceReply(const bb::data::DataAccessReply &reply);

signals:
	void photoImported();

private:
    QTranslator* m_pTranslator;
    bb::cascades::LocaleHandler* m_pLocaleHandler;

    CustomSqlDataSource *m_dataSource;
    QString m_photoQuery;
    QString m_importedPhotoPath;
};

#endif /* ApplicationUI_HPP_ */
