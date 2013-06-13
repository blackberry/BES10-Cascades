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

#ifndef ECLCONTACT_HPP
#define ECLCONTACT_HPP

#include <bb/pim/contacts/ContactService>
#include <QtCore/QObject>

class EclContact : public QObject
{
    Q_OBJECT
private:
    // The central object to access the contact service
    bb::pim::contacts::ContactService *m_contactService;

    QString m_name;
    QString m_title;
    QString m_officePhone;
    QString m_cellPhone;
    QString m_email;
    QString m_bbPin;
    QString m_backup;

public:
    EclContact(QObject *parent = 0);
    Q_INVOKABLE bool saveToAddressBook(QVariant eclData);
};

#endif //ECLCONTACT_HPP
