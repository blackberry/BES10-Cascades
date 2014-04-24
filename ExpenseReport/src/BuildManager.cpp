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

#include "BuildManager.h"
#include "Employee.h"
#include "Manager.h"
#include "Worker.h"
#include "LOGGER.H"

#include <QVariantList>
#include <QList>

#include <bb/data/XmlDataAccess>

using namespace bb::data;

int g_Depth = 4;

void logMap(QVariantMap & map, int level);

void logList(QVariantList & list, int level) {
    // add space to make the level indented
    LOGGER::log_indent("LIST level:  ", level, level);

    // Traverse the list... just for debug purposes
    foreach (QVariant vt, list) {
        if (vt.type() == QVariant::Map)
        {
            QVariantMap toPass = vt.value<QVariantMap>();
            if (level < g_Depth)
                logMap(toPass, level+1);
        }
        else if (vt.type() == QVariant::List)
        {
            QVariantList toPass = vt.value<QVariantList>();
            if (level < g_Depth)
                logList(toPass, level+1);
        }
        else if (vt.type() == QVariant::String)
        {
            LOGGER::log_indent("list value : ", vt.toString(), level);
        }
        else
        {
            LOGGER::log_indent("** list type : ", (int) vt.type(), level); // TODO
        }
    }
    LOGGER::log_indent("exiting LIST level:  ", level, level);
}

void logMap(QVariantMap & map, int level) {
    LOGGER::log_indent("MAP level:  ", level, level);

    for (QVariantMap::const_iterator iter = map.begin(); iter != map.end(); ++iter) {

        QVariant vt_key = iter.key();
        QString vt_string = vt_key.toString();

        LOGGER::log_indent("map key       : ", vt_string, level);
        LOGGER::log_indent("map key type  : ", (int) vt_key.type(), level);

        QVariant vt_val = iter.value();
        QString tvt_string2 = vt_val.toString();

        LOGGER::log_indent("map value     : ", tvt_string2, level);
        LOGGER::log_indent("map value type: ", (int) vt_val.type(), level);

        if (vt_val.type() == QVariant::Map) {
            QVariantMap toPass = vt_val.value<QVariantMap>();

            if (level < g_Depth)
                logMap(toPass, level + 1);
        }

        if (vt_val.type() == QVariant::List) {
            QVariantList toPass = vt_val.value<QVariantList>();
            if (level < g_Depth)
                logList(toPass, level + 1);
        }
        else if (vt_val.type() == QVariant::String) {
            LOGGER::log_indent("** map value : ", vt_val.toString(), level); // TODO
        }
        else {
            LOGGER::log_indent("map type : ", (int) vt_val.type(), level);
        }
    }
    LOGGER::log_indent("exiting MAP level:  ", level, level);
}

BuildManager::~BuildManager() {
    // TODO Auto-generated destructor stub
}

QVariantMap BuildManager::buildXMLElements(const QString& path) {

    // Then we have XML
    XmlDataAccess xda;
    QVariantMap ret;
    QVariant xmlContent = xda.load(path);

    if (xda.hasError()) {
        bb::data::DataAccessError error = xda.error();
        qCritical() << "failed to load XML with error: " << error.errorType();
        qCritical() << "message is: " << error.errorMessage();

        return QVariantMap();
    }

    if (xmlContent.type() != QVariant::Map) {
        qCritical() << "failed to parse byte array into QVarianMap.";
        qCritical() << "qvariant is of type : ", (int) xmlContent.type();
        return QVariantMap();
    }

    // We have a Map
    return xmlContent.value<QVariantMap>();
}

void BuildManager::parseEmployees() {
    LOGGER::log("Parsing the employees data...");

    // For the mean time we use a hard coded source file
    // Get a map from the XML data
    QVariantMap variantRootMap = buildXMLElements("app/native/assets/Employees.xml");

    QVariant vtObject = variantRootMap["employee"];
    if (vtObject.type() == QVariant::List) {
        QVariantList listEmployees = vtObject.value<QVariantList>();

        QList<QString> listManagers;
        foreach (QVariant vt, listEmployees) {
            if (vt.type() == QVariant::Map)
            {
                QVariantMap vtEmployee = vt.value<QVariantMap>();
                for (QVariantMap::const_iterator iter = vtEmployee.begin(); iter != vtEmployee.end(); ++iter) {

                    QString lastName = vtEmployee["lastname"].toString();
                    QString firstName = vtEmployee["firstname"].toString();
                    QString empID = vtEmployee["employeeID"].toString();
                    QString title = vtEmployee["title"].toString();
                    QString isManager = vtEmployee["isManager"].toString();

                    Employee* newEmp;
                    // TODO keyword "manager" should be labeled as a const
                    if (isManager.contains("yes")) {
                        newEmp = dynamic_cast<Employee*>(new Manager(firstName, lastName, empID, title));
                    }
                    else {
                        newEmp = dynamic_cast<Employee*>(new Worker(firstName, lastName, empID, title));
                    }

                    vtObject = vtEmployee["managers"];
                    //QVariantMap m = vtObject.value<QVariantMap>();
                    //logMap(m, 6);
                    // QVariantMap vtManagers = vtObject.value<QVariantMap>();

                    if (vtObject.type() == QVariant::Map) {
                        QVariantMap listManagers = vtObject.value<QVariantMap>();

                        // this list is temporary... could be destroyed after
                        for (QVariantMap::const_iterator iter = listManagers.begin(); iter != listManagers.end(); ++iter) {
                            QString managerID = iter.value().toString();
                            newEmp->addManager(managerID);
                        }
                    }

                    Employee::addEmployee(newEmp);
                }
            }
        }

        int sz = Employee::getEmployeeCount();

        // Since we cannot guarantee that Manager objects are created in the previous loop,
        // we have to loop again to assign workers for each manager.
        for (int i = 0; i < sz; i++) {
            Employee* e = Employee::getEmployee(i);
            if (e) {
                if (e->isManager()) {
                    Manager* mngr = dynamic_cast<Manager*>(e);
                    mngr->assignWorkers();
                }
            }
        }
    }
}
