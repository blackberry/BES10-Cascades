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

#ifndef MANAGER_H_
#define MANAGER_H_

#include "Employee.h"
#include "Worker.h"

/**
 * Keeps the information about managers,
 * provides functionality to assign and add employees to a manager as requested
 */
class Manager: public Employee {

public:
    Manager(QString firstName, QString lastName, QString id, QString title);
    virtual ~Manager();

    /**
     * Assigns workers to the concrete manager
     */
    void assignWorkers();

private:
    /**
     * Adds workers to the list of employees of the concrete manager
     *
     * @param e The worker to be assigned to the manager
     */
    void addWorker(Employee* e);

    QVariantMap m_mapWorkers;
};

#endif /* MANAGER_H_ */
