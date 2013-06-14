/****************************************************************************
 * Copyright 2012 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ****************************************************************************/

#ifndef ECLUTILS_HPP_
#define ECLUTILS_HPP_

#include <bb/cascades/ArrayDataModel>
#include <QtCore/qmap.h>


class EclUtils: public QObject{

    Q_OBJECT
public:
    EclUtils(QObject *parent);
    virtual ~EclUtils();
    QVariant load(const QString& file_name);

public:
    Q_INVOKABLE QVariantList mapToList(const QVariantMap& item);

    Q_INVOKABLE QVariantList getPhoneList(const QVariant& variant);
    Q_INVOKABLE QVariantMap getEmailAddress(const QVariant& variant);

    Q_INVOKABLE void makeCall(const QString& number);
    Q_INVOKABLE bool sendEmail(const QString& email);
    Q_INVOKABLE void sendSMS(const QString& number);

    Q_INVOKABLE bool updateFile(const QString& srcFile, const QString& destFile);

    Q_INVOKABLE bool textFileToJson(const QString& txtFile, const QString& jsonFile);

    bool writeToJson(const QString filename, const QByteArray jsonContents);

    Q_INVOKABLE void showDialog(const QString msg);
    int showConfirmDialog(const QString msg);

private:
    QObject *m_parent;

    Q_SIGNALS:
    void jsonUpdated();
};

#endif /* ECLUTILS_HPP_ */

