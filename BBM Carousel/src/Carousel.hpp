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

#ifndef Carousel_HPP_
#define Carousel_HPP_

#include <QObject>
#include <QEasingCurve>
#include <QVariant>
#include <bb/system/InvokeTargetReply>
#include <bb/system/SystemUiResult>

namespace bb { namespace cascades { class Application; }}
/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class Carousel : public QObject
{
    Q_OBJECT
public:
    Carousel(bb::cascades::Application *app);
    virtual ~Carousel() {};

    bb::system::InvokeTargetReply *_invokeTargetReply;

    void showDialog(QString errMsg);
    Q_INVOKABLE void invokeBBMInvite();
    Q_INVOKABLE void invokeBBMShareText();
    Q_INVOKABLE void invokeBBMShareTextGrp();
    Q_INVOKABLE void invokeBBMShareImage();
    Q_INVOKABLE void invokeBBMShareImageGrp();
    Q_INVOKABLE QByteArray getBytes(QString str);
    Q_INVOKABLE QEasingCurve getEase();
    Q_INVOKABLE QVariant createMirrorImage(QString inputFName);

public slots:
	void onDialogFinished(bb::system::SystemUiResult::Type type);
	void onInvokeResult();
};


#endif /* Carousel_HPP_ */
