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

#ifndef ExpenseReport_HPP_
#define ExpenseReport_HPP_

#include <QObject>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeManager>
#include <bb/network/PushService>

#include "Push.hpp"

#include <bb/network/PushStatus>

namespace bb {
    namespace cascades {
        class Application;
    }
}

using namespace bb::system;
using namespace bb::network;

/**
 * Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class ExpenseReport: public QObject {
    Q_OBJECT

    // not used
    Q_PROPERTY(int value READ value WRITE setValue NOTIFY valueChanged)

public:
    ExpenseReport(bb::cascades::Application *app);
    virtual ~ExpenseReport();

    /**
     * Returns the value
     */
    int value();

    /**
     * Sets the value
     *
     * @param i The new value of the parameter value
     */
    void setValue(int i);

signals:
    /**
     * The value as been changed
     */
    void valueChanged(int);

public Q_SLOTS:
    /**
     * ExpenseReport has been invoked
     */
    void onInvoked(const InvokeRequest &request);

private:
    Push m_push;
    InvokeManager* m_invokeManager;
    int m_iValue; // not used
};

#endif /* ExpenseReport_HPP_ */
