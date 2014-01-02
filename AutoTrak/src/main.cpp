/* Copyright (c) 2013 BlackBerry Limited.
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

#include <QLocale>
#include <QTranslator>
#include "applicationui.hpp"
#include <bb/cascades/pickers/FilePicker>
#include <Qt/qdeclarativedebug.h>

using namespace bb::cascades;
using namespace bb::cascades::pickers;

void myMessageOutput(QtMsgType type, const char *msg)
{
	//return;
 //in this function, you can write the message to any stream!
 switch (type) {
 case QtDebugMsg: {
	 QString qmsg(msg);
	 if (!qmsg.contains("PPS", Qt::CaseInsensitive) &&
		 !qmsg.contains("bbm", Qt::CaseInsensitive) &&
		 !qmsg.contains("getPersonalMessage()")) {
		//fprintf(logFile, "Debug: %s\n", msg);
		 fprintf(stdout, "Debug: %s\n", msg);
		 fflush(stdout);
		 //fflush(logFile);
	 }
	 break;
 }
 case QtWarningMsg:
	 //fprintf(logFile, "Warning: %s\n", msg);
	 fprintf(stdout, "Warning: %s\n", msg);
	 fflush(stdout);
	 //fflush(logFile);
	 break;
 case QtCriticalMsg:
	 //fprintf(logFile, "Critical: %s\n", msg);
	 fprintf(stdout, "Critical: %s\n", msg);
	 fflush(stdout);
	 //fflush(logFile);
	 break;
 case QtFatalMsg:
	 //fprintf(logFile, "Fatal: %s\n", msg);
	 fprintf(stdout, "Fatal: %s\n", msg);
	 fflush(stdout);
	 //fflush(logFile);
	 abort();
	 break;
 }
}

Q_DECL_EXPORT int main(int argc, char **argv)
{
    Application app(argc, argv);

	#ifndef QT_NO_DEBUG
	qInstallMsgHandler(myMessageOutput);
	#endif

	QCoreApplication::setOrganizationName("Kisai Labs");
	QCoreApplication::setOrganizationDomain("kisailabs.com");
	QCoreApplication::setApplicationName("AutoTrak");

    qmlRegisterType<FilePicker>("bb.cascades.pickers", 1, 0, "FilePicker");
    // Create the Application UI object, this is where the main.qml file
    // is loaded and the application scene is set.
    new BlaqService(&app);

    // Enter the application main event loop.
    return Application::exec();
}
