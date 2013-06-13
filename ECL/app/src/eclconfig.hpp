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
 * This files defines EclConfig class, which contains all the enums used in
 * the application. This also contains enum to string mapping functions for
 * the field names and display strings
 ****************************************************************************/

#ifndef ECLCONFIG_HPP_
#define ECLCONFIG_HPP_

#include <QObject>

class EclConfig: public QObject {
    Q_OBJECT
    Q_ENUMS (jsonFields)
    Q_ENUMS (fieldIcons)
    Q_ENUMS (eclString)
    Q_ENUMS (action)

public:
    enum jsonFields {
        Title,
        Name,
        Role,
        CellPhone,
        OfficePhone,
        Email,
        BBPin,
        Backup,
        JSonList
    };

    enum action {
        None,
        Call,
        SendSMS,
        SendEmail
    };

    enum fieldIcons {
        OfficeIcon,
        CellIcon,
        EmailIcon,
        SMSIcon,
        BBMIcon,
        BackupIcon
    };

    Q_INVOKABLE static QString jsonFieldName(const jsonFields& field) {
        QString fieldName;
        switch (field) {
        case Title:
            fieldName = tr("Title");
            break;
        case Name:
            fieldName = tr("Name");
            break;
        case Role:
            fieldName = tr("Role");
            break;
        case CellPhone:
            fieldName = tr("CellPhone");
            break;
        case OfficePhone:
            fieldName = tr("OfficePhone");
            break;
        case Email:
            fieldName = tr("Email");
            break;
        case Backup:
            fieldName = tr("Backup");
            break;
        case BBPin:
            fieldName = tr("BBPin");
            break;
        case JSonList:
            fieldName = tr("list");
            break;
        }
        return fieldName;
    }

    Q_INVOKABLE static QString displayString(const jsonFields& field,
            QString strAdditional = "") {
        QString fieldName;
        switch (field) {
        case OfficePhone:
            fieldName = tr("Work");
            break;
        case CellPhone:
            fieldName = tr("Mobile");
            break;
        case Email:
            fieldName = tr("email");
            break;
        case Backup:
            fieldName = tr("Backup");
            break;
        case BBPin:
            fieldName = tr("BBM");
            break;
        default:
            break;
        }
        return strAdditional + fieldName;
    }

    Q_INVOKABLE static QString fieldIcon(const fieldIcons& field) {
        QString fieldName;
        switch (field) {
        case OfficeIcon:
            fieldName = "asset:///images/office.png";
            break;
        case CellIcon:
            fieldName = "asset:///images/cell.png";
            break;
        case EmailIcon:
            fieldName = "asset:///images/email.png";
            break;
        case SMSIcon:
            fieldName = "asset:///images/sms.png";
            break;
        case BBMIcon:
            fieldName = "asset:///images/bbm.png";
            break;
        case BackupIcon:
            fieldName = "asset:///images/backup.png";
            break;
        }
        return fieldName;
    }
};

#endif /* ECLCONFIG_HPP_ */

