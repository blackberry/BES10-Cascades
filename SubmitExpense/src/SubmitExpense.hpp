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

#ifndef SubmitExpense_HPP_
#define SubmitExpense_HPP_

#include <QObject>

#include <bb/system/InvokeRequest>
#include <bb/system/InvokeManager>

using namespace bb::system;

namespace bb {
    namespace cascades {
        class Application;
    }
}

/**
 * @brief Application pane object
 *
 * Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class SubmitExpense: public QObject {
    Q_OBJECT

public:
    SubmitExpense(bb::cascades::Application *app);
    virtual ~SubmitExpense() {
    }

    Q_INVOKABLE
    void sendNotificationForExpenses();

    Q_INVOKABLE
    void sendNotificationForCRM(int iVal);

    Q_INVOKABLE
    QString getHomeDir();

    QString pushContentFileExtension(const QString &contentTypeHeaderValue) const;
};

#endif /* SubmitExpense_HPP_ */
