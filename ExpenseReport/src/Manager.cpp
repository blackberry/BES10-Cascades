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

#include "Manager.h"

Manager::Manager(QString firstName, QString lastName, QString id, QString title)
        : Employee(firstName, lastName, id, title, true) {
    // TODO Auto-generated constructor stub
}

Manager::~Manager() {
    // TODO Auto-generated destructor stub
}

void Manager::addWorker(Employee* wrk) {
    QSharedPointer < Employee > sp = Employee::getEmployeeAsSharePtr(wrk->getEmployeeID());

    QVariant vt = QVariant::fromValue(sp);
    if (!vt.isNull())
        m_mapWorkers.insert(wrk->getEmployeeID(), vt);
}

void Manager::assignWorkers() {
    int sz = Employee::getEmployeeCount();

    for (int i = 0; i < sz; i++) {
        Employee* e = Employee::getEmployee(i);

        // Reminder ... a manager can be supervised by a higher rank manager e.g. CEO
        // so cannot cast to Worker object
        if (e->hasManager(m_id))
            addWorker(e);
    }
}

