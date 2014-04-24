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

#ifndef EMPLOYEE_H_
#define EMPLOYEE_H_

#include <QObject>
#include <QSharedPointer>
#include <QVariantList>

/**
 * Keeps the information about each employee, provides employee objects as requested
 */
class Employee: public QObject {
    Q_OBJECT

public:
    Employee(QString firstName, QString lastName, QString id, QString title, bool isManager, QObject* p = 0);
    virtual ~Employee();

    /**
     * Returns the employee ID
     */
    QString getEmployeeID() const {
        return m_id;
    };

    /**
     * Returns true if the employee is a manager, otherwise returns false
     */
    bool isManager() const {
        return m_isManager;
    };

    /**
     * Returns true if the employee with the given ID has a manager
     *
     * @param id The ID of the employee
     */
    bool hasManager(const QString& id) const;

    /**
     * Returns the employee
     *
     * @param id The ID of the employee
     */
    static Employee* getEmployee(const QString& id);

    /**
     * Returns the Shared Pointer of an Employee object
     *
     * @param id The ID of the employee
     */
    static QSharedPointer<Employee> getEmployeeAsSharePtr(const QString& id);

    /**
     * Returns the employee with the given index
     *
     * @param nIndex The index of the employee in the database
     */
    static Employee* getEmployee(int nIndex);

    /**
     * Returns the entire count of the employees
     */
    static int getEmployeeCount() {
        return m_listEmployees.size();
    };

    /**
     * Adds an employee to the employees list
     *
     * @param e The employee to be added
     */
    static void addEmployee(Employee* e);

    /**
     * Adds the manager with the given ID to the managers list
     *
     * @parame id The ID of the manager to be added
     */
    void addManager(const QString& id) {
        m_listManagers.append(id);
    };

protected:
    static QVariantMap m_listEmployees; // The list of employees
    QList<QString> m_listManagers; // The list of managers

protected:
    QString m_firstName; // The first name of the employee
    QString m_lastName; // The last name of the employee
    QString m_id; // The ID of the employee
    QString m_title; // The title of the employee
    QString m_workPhone; // The work phone of the employee
    bool m_isManager; // True if the employee is a manager, otherwise it is false
};

Q_DECLARE_METATYPE( QSharedPointer<Employee> )

#endif /* EMPLOYEE_H_ */
