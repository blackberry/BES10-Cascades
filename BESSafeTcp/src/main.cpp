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

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include <QLocale>
#include <QTranslator>
#include <Qt/qdeclarativedebug.h>
#include "BESConnect.hpp"
#include "BESSafeTcp.hpp"

using namespace bb::cascades;


void myMessageOutput(QtMsgType type, const char* msg) {
    //fprintf(stderr, "%s\n", msg);

    // setup shared logs folder
    QString logFilePath = (new QDir())->absoluteFilePath("shared/documents/logs");
    QDir sharedDir(logFilePath);

    if (!sharedDir.exists()) {
    sharedDir.mkpath (logFilePath);
    }

    QFileInfo fileInfo((new QDir())->absoluteFilePath(logFilePath + "/BESSafeTcp.txt"));
    QFile file((new QDir())->absoluteFilePath(logFilePath + "/BESSafeTcp.txt"));

    // Open the file that was created
    if (!file.exists()) {
        QDir().mkpath (fileInfo.dir().path());
        // Open the file that was created
        if (file.open(QIODevice::WriteOnly | QIODevice::Append)) {
            file.write(msg);
            file.write("\n");
            file.flush();
            file.close();
        }
    } else {
        if (file.open(QIODevice::WriteOnly | QIODevice::Append)) {
            file.write(msg);
            file.write("\n");
            file.flush();
            file.close();
        }
    }
}

Q_DECL_EXPORT int main(int argc, char **argv)
{
    // This is where the server is started etc.
    Application app(argc, argv);

	// The NetworkImageTracler is registered so that it can be used in QML
	qmlRegisterType<BESConnect>("bb.besutil", 1, 0, "BESConnect");

	qInstallMsgHandler(myMessageOutput);

    // localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    QString filename = QString( "BESSafeTcp_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }

    new BESSafeTcp(&app);

    // we complete the transaction started in the app constructor and start the client event loop here
    return Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
