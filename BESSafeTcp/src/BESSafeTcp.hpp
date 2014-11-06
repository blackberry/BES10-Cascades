// Default empty project template
#ifndef BESSafeTcp_HPP_
#define BESSafeTcp_HPP_

#include <QObject>

#include <bb/cascades/TextArea>

/*
 * Copyright (c) 2012-2014 Research In Motion Limited.
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
 */

namespace bb { namespace cascades { class Application; }}

using namespace bb::cascades;

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class BESSafeTcp : public QObject
{
    Q_OBJECT

public:
    BESSafeTcp(bb::cascades::Application *app);
    virtual ~BESSafeTcp() {}

    static void consoleLog(const char* text);
    static void consoleLog(const QString text);

public Q_SLOTS:
    void updateConsole();

private:
    static QString m_consoleText;
    static QTimer *m_timer;

	static TextArea *m_console;

	static BESSafeTcp *m_singleton;
};


#endif /* BESSafeTcp_HPP_ */
