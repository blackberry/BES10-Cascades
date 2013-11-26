/* Copyright (c) 2012, 2013  BlackBerry Limited.
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

#ifndef Carousel_HPP_
#define Carousel_HPP_

#include <QObject>
#include <QEasingCurve>
#include <QVariant>

#include <bb/system/InvokeManager>
#include <bb/system/SystemDialog.hpp>
#include <bb/cascades/Invocation>


namespace bb { namespace cascades { class Application; }}

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class Carousel : public QObject
{
    Q_OBJECT

    // The current error message
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)


public:
    Carousel(bb::cascades::Application *app);
    virtual ~Carousel() {}

    Q_INVOKABLE QByteArray getBytes(QString str);
    Q_INVOKABLE QEasingCurve getEase();
    Q_INVOKABLE QVariant createMirrorImage(QString inputFName);

    Q_INVOKABLE QString getValueFor(const QString &objectName, const QString &defaultValue);
    Q_INVOKABLE void saveValueFor(const QString &objectName, const QString &inputValue);


public Q_SLOTS:
	// This method is called to invoke another application with the current configuration
	void invokeEmail();

	// This method is called to invoke a specific application with the given URL
	void invokeBrowser(const QString &target);

	// This method shows an error dialog with he current error message
	void showErrorDialog();

	Q_SIGNALS:
		void errorMessageChanged();

private Q_SLOTS:
		// This slot handles the result of an invocation
		void processInvokeReply();

private:

	QString errorMessage() const;
	QString m_errorMessage;

	// The error dialog
	bb::system::SystemDialog* m_dialog;

	// The central object to manage invocations
	bb::system::InvokeManager* m_invokeManager;

	// The Invocation object for platform invocations
	bb::cascades::Invocation* m_invocation;

};


#endif /* Carousel_HPP_ */
