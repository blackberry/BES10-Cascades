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

#include "Employee.h"

QVariantMap Employee::m_listEmployees;

Employee::Employee(QString firstName, QString lastName, QString id, QString title, bool isManager, QObject *parent)
        : QObject(parent),
          m_firstName(firstName),
          m_lastName(lastName),
          m_id(id),
          m_isManager(isManager),
          m_title(title) {
			m_workPhone = "1-111-111-1111";
		  }

Employee::~Employee() {
    // TODO Auto-generated destructor stub
}

Employee* Employee::getEmployee(const QString& id) {
    QVariant vt = m_listEmployees[id];
    if (!vt.isNull()) {
        QSharedPointer < Employee > p = vt.value<QSharedPointer<Employee> >();
        return p.data();
    }
    return NULL;
}

QSharedPointer<Employee> Employee::getEmployeeAsSharePtr(const QString& id) {
    QVariant vt = m_listEmployees[id];
    return vt.value<QSharedPointer<Employee> >();
}

Employee* Employee::getEmployee(int nIndex) {
    int nLoop = 0;

    for (QVariantMap::const_iterator iter = m_listEmployees.begin(); iter != m_listEmployees.end(); ++iter) {
        QVariant vt = iter.value();
        if (nLoop == nIndex) {
            QSharedPointer < Employee > p = vt.value<QSharedPointer<Employee> >();
            return p.data();
        }
        nLoop++;
    }
    return NULL;
}

bool Employee::hasManager(const QString& id) const {
    for (int i = 0; i < m_listManagers.length(); i++) {
        QString idMgr = m_listManagers.at(i);
        if (idMgr == id)
            return true;
    }
    return false;
}

void Employee::addEmployee(Employee* e) {
    QVariant vt = m_listEmployees[e->getEmployeeID()];
    if (vt.isNull()) {
        QSharedPointer < Employee > newEmpl(e);
        QVariant vtTmp = QVariant::fromValue(newEmpl);
        m_listEmployees[e->getEmployeeID()] = vtTmp;
    }
}

