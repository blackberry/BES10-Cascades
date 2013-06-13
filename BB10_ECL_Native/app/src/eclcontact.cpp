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
 * This is EclContact class, that is used to save the contact details to the
 * address book
 ****************************************************************************/

#include "eclcontact.hpp"
#include "eclconfig.hpp"
#include <bb/pim/contacts/Contact>
#include <bb/pim/contacts/ContactAttributeBuilder>
#include <bb/pim/contacts/ContactBuilder>

#include<QString>

using namespace bb::pim::contacts;

EclContact::EclContact(QObject *parent) :
        QObject(parent), m_contactService(new ContactService(this)) {

}

/****************************************************************************
 * This function is used to store the contact details to the phone address
 * book.
 ****************************************************************************/
bool EclContact::saveToAddressBook(QVariant eclData) {

    if (!eclData.isValid() || eclData.isNull()) {
        return false;
    }

    QVariantMap contactData = eclData.value<QVariantMap>();
    QMapIterator<QString, QVariant> contactItr(contactData);
    QString key = "";

    while (contactItr.hasNext()) {
        contactItr.next();
        key = contactItr.key();

        if (EclConfig::jsonFieldName(EclConfig::Name) == key) {
            m_name = contactItr.value().value<QString>();
        }
        if (EclConfig::jsonFieldName(EclConfig::Title) == key) {
            m_title = contactItr.value().value<QString>();
        }
        if (EclConfig::jsonFieldName(EclConfig::CellPhone) == key) {
            m_cellPhone = contactItr.value().value<QString>();
        }
        if (EclConfig::jsonFieldName(EclConfig::OfficePhone) == key) {
            m_officePhone = contactItr.value().value<QString>();
        }
        if (EclConfig::jsonFieldName(EclConfig::Email) == key) {
            m_email = contactItr.value().value<QString>();
        }
        if (EclConfig::jsonFieldName(EclConfig::BBPin) == key) {
            m_bbPin = contactItr.value().value<QString>();
        }
        if (EclConfig::jsonFieldName(EclConfig::Backup) == key) {
            m_backup = contactItr.value().value<QString>();
        }
    }

    // Create a builder to assemble the new contact
    ContactBuilder builder;

    // Set the name
    builder.addAttribute(
            ContactAttributeBuilder().setKind(AttributeKind::Name).setSubKind(
                    AttributeSubKind::NameGiven).setValue(m_name));

    // Set the Cell Phone
    builder.addAttribute(
            ContactAttributeBuilder().setKind(AttributeKind::Phone).setSubKind(
                    AttributeSubKind::PhoneMobile).setValue(m_cellPhone));

    // Set the office Phone
    builder.addAttribute(
            ContactAttributeBuilder().setKind(AttributeKind::Phone).setSubKind(
                    AttributeSubKind::Work).setValue(m_officePhone));

    // Set the email address
    builder.addAttribute(
            ContactAttributeBuilder().setKind(AttributeKind::Email).setSubKind(
                    AttributeSubKind::Other).setValue(m_email));

    // Set the bbPin
    builder.addAttribute(
            ContactAttributeBuilder().setKind(AttributeKind::Hidden).setSubKind(
                    AttributeSubKind::Other).setValue(m_bbPin));

    // Save the contact to persistent storage
    Contact createdContact = m_contactService->createContact(builder, false);

    return true;
}
