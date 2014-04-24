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

#ifndef WORKER_H_
#define WORKER_H_

#include "QList"
#include "Employee.h"

/**
 * Keeps the information about workers who are not managers
 */
class Worker: public Employee {

public:
    Worker(QString firstName, QString lastName, QString id, QString title);
    virtual ~Worker();
};

#endif /* WORKER_H_ */
