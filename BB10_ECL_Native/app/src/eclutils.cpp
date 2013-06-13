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
/*
 * This is EclUtils class, contains all the utility functions which are used
 * by the application
 *
 ****************************************************************************/

#include "eclutils.hpp"
#include "eclconfig.hpp"
#include <bb/system/phone/Phone>
#include <bb/data/JsonDataAccess>

#include <bb/system/SystemDialog>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeReply>
#include <bb/system/InvokeManager>

#include <bb/PpsObject>

using namespace bb::system;

EclUtils::EclUtils(QObject *parent) {
    m_parent = parent;
}

EclUtils::~EclUtils() {

}

/****************************************************************************
 * Converts the QVariantMap to QVariantList.
 * Returns QVariantList
 ****************************************************************************/
QVariantList EclUtils::mapToList(const QVariantMap& map) {

    QMapIterator<QString, QVariant> it(map);
    QVariantMap displayMap;
    QVariantList displayList;

    while (it.hasNext()) {
        it.next();

        displayMap.insert("fieldName", it.key());
        displayMap.insert("fieldValue", it.value());
        displayList.append(displayMap);
    }

    return displayList;
}

/****************************************************************************
 * Gets the Phone field list from the passed QVariantMap.
 * Returns QVariantList of phone field entries
 ***************************************************************************/

QVariantList EclUtils::getPhoneList(const QVariant& variant) {

    QVariantMap mainMap = variant.value<QVariantMap>();
    QVariantList lst;
    QVariantMap subMap;
    QMap<QString, QVariant>::const_iterator it = mainMap.begin();
    while (it != mainMap.end()) {

        if (it.key() == EclConfig::jsonFieldName(EclConfig::OfficePhone)
                || it.key() == EclConfig::jsonFieldName(EclConfig::CellPhone)) {
            subMap.insert("fieldName", it.key());
            subMap.insert("fieldValue", it.value());
            lst.append(subMap);
        }
        it++;
    }

    return lst;
}

/****************************************************************************
 * Get email address for the selected contact
 ****************************************************************************/

QVariantMap EclUtils::getEmailAddress(const QVariant& variant) {

    QVariantMap mainMap = variant.value<QVariantMap>();
    QVariantMap subMap;
    QMap<QString, QVariant>::const_iterator it = mainMap.begin();
    while (it != mainMap.end()) {

        if (it.key() == EclConfig::jsonFieldName(EclConfig::Email)) {
            subMap.insert("fieldValue", it.value());
        }
        it++;
    }
    return subMap;
}

/****************************************************************************
 * Invokes the platform phone API to make a call.
 ****************************************************************************/
void EclUtils::makeCall(const QString& phNumber) {

    //bb::system::phone::Phone phone;
    //phone.initiateCellularCall(number);
    // this is not working in work side
    /*
     * making call is not working on the work side, tried using the above
     * commented code (using bb::system::phone::Phone phone) and the below
     * code, both are working on personal side without any problem
     */

    // Create a new invocation request
    InvokeRequest request;

    request.setMimeType("application/vnd.blackberry.phone.startcall");
    request.setAction("bb.action.DIAL");

    QVariantMap map;
    map.insert("number", phNumber);
    QByteArray requestData = bb::PpsObject::encode(map, NULL);
    request.setData(requestData);

    // Start the invocation
    InvokeManager *m_invokeManager = new InvokeManager(this);
    const InvokeTargetReply *reply = m_invokeManager->invoke(request);
    if (!reply) {
        qDebug() << "EclUtils::makeCall-error";
    }
}

/****************************************************************************
 * Invokes the platform email composer.
 ****************************************************************************/
bool EclUtils::sendEmail(const QString& email) {

    qDebug() << "EclUtils::sendEmail " << email;
    // Create a new invocation request
    InvokeRequest request;

    request.setTarget("sys.pim.uib.email.hybridcomposer");
    request.setAction("bb.action.OPEN");
    QString strUri("mailto:");
    strUri.append(email);
    QUrl uri(strUri);
    request.setUri(uri);
    // Start the invocation
    InvokeManager *m_invokeManager = new InvokeManager(this);
    const InvokeTargetReply *reply = m_invokeManager->invoke(request);
    if (!reply) {
        qDebug() << "EclUtils::sendEmail-error invoking email client ";
        return false;
    }
    return true;
}

/****************************************************************************
 * Invokes the platform SMS composer.
 ****************************************************************************/
void EclUtils::sendSMS(const QString& number) {
    Q_UNUSED(number)
    showDialog("SMS feature not supported");
}

/****************************************************************************
 * Updates the destination file with the source file.
 * Returns true on successful update, otherwise returns false
 ****************************************************************************/
bool EclUtils::updateFile(const QString& srcFile, const QString& destFile) {

    bool flag = true;
    QFileInfo fi(destFile);
    QString tempFile = fi.dir().path() + "/";
    tempFile = tempFile + "ecltest.json";

    if (QFile::exists(destFile)) {
        if (QFile::rename(destFile, tempFile)) {
            qDebug() << "EclUtils::  File Renamed ";
            if (QFile::copy(srcFile, destFile)) {
                qDebug() << "EclUtils::  File Copied ";
                QFile::remove(tempFile);
            } else {
                flag = false;
                QFile::rename(tempFile, destFile);
                qDebug() << "EclUtils::  File Copy Error ";
            }
        } else {
            flag = false;
            qDebug() << "EclUtils::  File Copy Error ";
        }
    } else {

        if (QFile::copy(srcFile, destFile)) {
            qDebug() << "EclUtils::  File Copied ";
        } else {
            flag = false;
            qDebug() << "EclUtils::  File Copy Error ";
        }
    }

    return flag;
}

bool EclUtils::writeToJson(const QString filename, const QByteArray jsonContents) {

    QFile datafile(filename);

    if (datafile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&datafile);
        out << jsonContents;
        datafile.close();
        return true;
    }

    return false;
}

/****************************************************************************
 * Loads the json file and returns the QVariant with the contents of
 * the json.
 ****************************************************************************/
QVariant EclUtils::load(const QString& file_name) {
    bb::data::JsonDataAccess jda;

    QVariant variant = jda.load(file_name).value<QVariantMap>();
    if (jda.hasError()) {
        bb::data::DataAccessError error = jda.error();
    }

    return variant;
}

/****************************************************************************
 * This function reads the ECL text file and generates the JSON file, which
 * is used by the application UI. This was created to support the format
 * in which the server is sending the ECL list to the BB7 ECL application
 * shared with developer.
 * To demo this there is a text file packaged with application. On selection
 * of 'Demo with Text File' option this function is called and it generates
 * the JSON file using the text file
 * Returns true on successful conversion, otherwise returns false
 ****************************************************************************/

bool EclUtils::textFileToJson(const QString& txtFile, const QString& jsonFile) {

    QFile file(txtFile);
    QFile jfile(jsonFile);

    if (!file.open(QFile::ReadOnly)) {
        qDebug() << "Unable to open file : " << txtFile;
        return false;
    }

    if (!jfile.open(QFile::WriteOnly)) {
        qDebug() << "Unable to open file : " << jsonFile;
        return false;
    }

    QVariantMap map;

    QVariant variant = load("app/native/assets/data/config.json");
    if (variant.isValid()) {
        map = variant.value<QVariantMap>();
    }
    QTextStream ts(&file);
    QTextStream out(&jfile);

    QChar ch;
    int groupCount = 0;
    int contactCount = 0;
    int cfieldCount = 0;
    bool gFlag = false;
    QString element = "";

    out << "[\n";
    do {
        ts >> ch;
        if (ch == '\n')
            continue;

        if (ch == ';') {
            if (element == "NEXT_GROUP") {
                groupCount++;
                gFlag = true;
                if (groupCount > 1) {
                    out << "\n} \n] \n}, \n";
                    groupCount--;
                    contactCount = 0;
                }
                out << "{ \"" << EclConfig::jsonFieldName(EclConfig::Title)
                        << "\" : ";
                element = "";
            } else if (element == "NEW_CONTACT") {
                contactCount++;
                if (contactCount > 1) {
                    out << "\n}, \n";
                    contactCount--;
                }

                // Start of the new contact
                out << "\n{ \n";
                // to indicate the first 2 fields are not having fieldname
                cfieldCount = 2;
                element = "";
            } else {
                if (cfieldCount >= 1) {
                    // First two field names are not specified in text file, so handling that
                    switch (cfieldCount) {
                    case 2:
                        out << " \"" << EclConfig::jsonFieldName(EclConfig::Name)
                                << "\" : \"" << element << "\" ";
                        cfieldCount--;
                        break;
                    case 1:
                        out << ",\n \"" << EclConfig::jsonFieldName(EclConfig::Role)
                                << "\" : \"" << element << "\" ";
                        cfieldCount--;
                        break;
                    default:
                        break;
                    }
                    element = "";
                } else {
                    if (gFlag) {
                        // Only if it is the start of new group
                        out << "\"" << element << "\",\n \"list\": [ ";
                        gFlag = false;
                    } else {
                        out << "\"" << element << "\"";
                    }

                    element = "";
                }
            }
        } else if (ch == ':') {
            // Writes all keys by referring the config.json
            out << ",\n \""<< (map[element].isValid() ?  map[element].value<QString>() : element) << "\" : ";
            element = "";
        } else {
            element += ch;
        }

    } while (!ts.atEnd());

    out << "\n} \n] \n} \n]";

    file.close();
    jfile.close();

    qDebug() << "Json Conversion done";

    return true;
}

/****************************************************************************
 * A public function to display a SystemDialog.
 ****************************************************************************/
void EclUtils::showDialog(const QString msg) {

    SystemDialog *dialog = new SystemDialog("OK");

    dialog->setTitle("Information");
    dialog->setBody(msg);

    //make a blocking call so we can delete the dialog once its responded by user
    dialog->exec();
    dialog->deleteLater();
}

/****************************************************************************
 * A public function to display a SystemDialog for confirmation.
 ****************************************************************************/
int EclUtils::showConfirmDialog(const QString msg) {

    SystemDialog *dialog = new SystemDialog();

    dialog->setTitle("Information");
    dialog->setBody(msg);
    dialog->confirmButton()->setLabel(tr("Continue"));
    dialog->cancelButton()->setLabel(tr("Cancel"));

    //make a blocking call so we can delete the dialog once its responded by user
    int retValue = dialog->exec();
    dialog->deleteLater();
    return retValue;
}
