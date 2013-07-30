/* Copyright (c) 2012 Research In Motion Limited.
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


// Navigation pane project template
#include "applicationui.hpp"

#include <bb/cascades/Application>

#include <QLocale>
#include <QTranslator>
#include <bb/data/DataSource>

// include JS Debugger / CS Profiler enabler
// this feature is enabled by default in the debug build only
#include <Qt/qdeclarativedebug.h>

using namespace bb::cascades;

void myMessageOutput(QtMsgType type, const char *msg) {
	// In this function, you can write the message to any stream!
	switch (type) {
	case QtDebugMsg:
		fprintf(stderr, "Debug: %s %s\n", QDateTime::currentDateTime().toString("MMM dd hh:mm:ss.zzz").toAscii().data(), msg);
		break;
	case QtWarningMsg:
		fprintf(stderr, "Warning: %s %s\n", QDateTime::currentDateTime().toString("MMM dd hh:mm:ss.zzz").toAscii().data(), msg);
		break;
	case QtCriticalMsg:
		fprintf(stderr, "Critical: %s %s\n", QDateTime::currentDateTime().toString("MMM dd hh:mm:ss.zzz").toAscii().data(), msg);
		break;
	case QtFatalMsg:
		fprintf(stderr, "Fatal: %s %s\n", QDateTime::currentDateTime().toString("MMM dd hh:mm:ss.zzz").toAscii().data(), msg);
		abort();
		break;
	}
}

Q_DECL_EXPORT int main(int argc, char **argv)
{
	// install our log handler
#ifndef NO_DEBUG
	qInstallMsgHandler(myMessageOutput);
#endif

    bb::data::DataSource::registerQmlTypes();
    // this is where the server is started etc
    Application app(argc, argv);

    // localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    QString filename = QString( "brewmaster_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }

    // create the application pane object to init UI etc.
    new ApplicationUI(&app);

    // we complete the transaction started in the app constructor and start the client event loop here
    return Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
