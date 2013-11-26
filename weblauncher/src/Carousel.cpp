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

#include "Carousel.hpp"
#include "Dialog.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/system/SystemToast>

#include <QPropertyAnimation>

#include <bb/ImageData>
#include <bb/cascades/Image>

#include <unistd.h>

#include <QSettings>

#include <bb/system/InvokeReply>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeTarget>
#include <bb/system/InvokeTargetReply>


using namespace bb::cascades;
using namespace bb::system;

Carousel::Carousel(bb::cascades::Application *app) :
    QObject(app)
, m_invokeManager(new InvokeManager(this))
, m_dialog(new SystemDialog(this))
{
  qmlRegisterType<QTimer>("utils", 1, 0, "QTimer");
  qmlRegisterType<QPropertyAnimation>("bb.cascades", 1, 0,
      "QPropertyAnimation");
  // create scene document from main.qml asset
  // set parent to created document to ensure it exists for the whole application lifetime
  QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

  qml->setContextProperty("app", this);

  // create root object for the UI
  AbstractPane *root = qml->createRootObject<AbstractPane>();
  // set created root object as a scene
  app->setScene(root);
}

// Getting the byte array of the string
QByteArray Carousel::getBytes(QString str)
{
  return str.toAscii();
}

// We only want the OutCubic easing-curve, try others,  dare you!
QEasingCurve Carousel::getEase()
{
  return QEasingCurve::OutCubic;
}

// This function is needed by the mirroring algo.
static bb::cascades::Image fromQImage(const QImage &origQImage,
    const QImage &mirroredQImage)
{

  bb::ImageData imageData(bb::PixelFormat::RGBA_Premultiplied,
      origQImage.width(), (origQImage.height() * 1.25) + 2);
  int y = 0;

  unsigned char *dstLine = imageData.pixels();

  for (y = 0; y < origQImage.height(); y++)
  {
    unsigned char * dst = dstLine;
    for (int x = 0; x < imageData.width(); x++)
    {
      QRgb srcPixel = origQImage.pixel(x, y);

      *dst++ = qRed(srcPixel) * qAlpha(srcPixel) / 255;
      *dst++ = qGreen(srcPixel) * qAlpha(srcPixel) / 255;
      *dst++ = qBlue(srcPixel) * qAlpha(srcPixel) / 255;
      *dst++ = qAlpha(srcPixel);
    }
    dstLine += imageData.bytesPerLine();
  }

  for (; y < origQImage.height() + 2; y++)
  {
    unsigned char * dst = dstLine;
    for (int x = 0; x < imageData.width(); x++)
    {
      *dst++ = 0;
      *dst++ = 0;
      *dst++ = 0;
      *dst++ = 0;
    }
    dstLine += imageData.bytesPerLine();
  }

  for (; y < imageData.height(); y++)
  {
    unsigned char * dst = dstLine;
    for (int x = 0; x < imageData.width(); x++)
    {
      QRgb srcPixel = mirroredQImage.pixel(x, (y - 2 - origQImage.height()));
      *dst++ = qRed(srcPixel);
      *dst++ = qGreen(srcPixel);
      *dst++ = qBlue(srcPixel);
      *dst++ = qAlpha(srcPixel);

    }
    dstLine += imageData.bytesPerLine();
  }

  return Image(imageData);

}

// Let's not have all the images mirrored, let's do that in code, and some alpha on them aswell
QVariant Carousel::createMirrorImage(QString inputFName)
{

  if (inputFName.isEmpty())
    return QVariant::fromValue(0);

  char buff[1024];
  QString prefix = QString(getcwd(buff, 1024));
  inputFName = prefix + "/app/native/assets/" + inputFName;

  QImage inputQImage(inputFName);
  QImage mirrored_part = inputQImage.mirrored(false, true);
  QPoint start(0, 0);
  QPoint end(0, mirrored_part.height());
  QLinearGradient gradient(start, end);

  gradient.setColorAt(0.0, Qt::gray);
  gradient.setColorAt(0.22, Qt::black);
  gradient.setColorAt(1.0, Qt::black);
  QImage mask = mirrored_part;
  QPainter painter(&mask);
  painter.fillRect(mirrored_part.rect(), gradient);
  painter.end();

  mirrored_part.setAlphaChannel(mask);
  bb::cascades::Image mirrored_image = fromQImage(inputQImage, mirrored_part);
  return QVariant::fromValue(mirrored_image);

}

void Carousel::invokeEmail(){
	// Create a new invocation request
		InvokeRequest request;

		// Setup the request properties according to the current configuration
			request.setTarget("sys.pim.uib.email.hybridcomposer");
			request.setAction("bb.action.OPEN, bb.action.SENDEMAIL");
			request.setMimeType("message/rfc822");
			request.setUri("mailto:SETEMAIL@SETDOMAIN.com?subject=More%20Links%20Please!!!!");

		// Start the invocation
		const InvokeReply *reply = m_invokeManager->invoke(request);
		if (reply) {
			// Ensure that processInvokeReply() is called when the invocation has finished
			QObject::connect(reply, SIGNAL(finished()), this,
					SLOT(processInvokeReply()));
		} else {
			m_errorMessage = tr("Invoke Failed! Reply object is empty.");
			showErrorDialog();
			return;
		}
}

void Carousel::invokeBrowser(const QString &target){
	// Create a new invocation request
		InvokeRequest request;

		// Setup the request properties according to the current configuration
			request.setTarget("sys.browser");
			request.setAction("bb.action.OPEN");
			request.setMimeType("application/xhtml+xml");
			request.setUri(target);

		// Start the invocation
		const InvokeReply *reply = m_invokeManager->invoke(request);
		if (reply) {
			// Ensure that processInvokeReply() is called when the invocation has finished
			QObject::connect(reply, SIGNAL(finished()), this,
					SLOT(processInvokeReply()));
		} else {
			m_errorMessage = tr("Invoke Failed! Reply object is empty.");
			showErrorDialog();
			return;
		}
}



//! [4]
void Carousel::processInvokeReply() {
	// Get the reply from the sender object
	InvokeReply *reply = qobject_cast<InvokeReply*>(sender());

	// Check for errors during invocation
	switch (reply->error()) {
	case InvokeReplyError::BadRequest:
		m_errorMessage = tr("[ErrorBadRequest] Invoke Failed!");
		showErrorDialog();
		break;
	case InvokeReplyError::Internal:
		m_errorMessage = tr("[ErrorInternal] Invoke Failed!");
		showErrorDialog();
		break;
	case InvokeReplyError::NoTarget:
		m_errorMessage = tr("[ErrorNoTarget] Invoke Failed!");
		showErrorDialog();
		break;
	case InvokeReplyError::TargetNotOwned:
		m_errorMessage = tr("[ErrorTargetNotOwned] Invoke Failed.");
		showErrorDialog();
		break;
	default:
		break;
	}

	// Delete the reply later on
	reply->deleteLater();
}



void Carousel::showErrorDialog() {
	m_dialog->setTitle("Error");
	m_dialog->setBody(m_errorMessage);
	m_dialog->show();
}

QString Carousel::errorMessage() const {
	return m_errorMessage;
}


QString Carousel::getValueFor(const QString &objectName, const QString &defaultValue)
{
    QSettings settings;

    qDebug() << "Any Saving Values for object name = " << objectName << " and default value = " << defaultValue;

    // If no value has been saved, return the default value.
    if (settings.value(objectName).isNull()) {
        return defaultValue;
    }

    // Otherwise, return the value stored in the settings object.
	   qDebug() << " Settings Values " << settings.value(objectName).toString();
	   return settings.value(objectName).toString();

}

void Carousel::saveValueFor(const QString &objectName, const QString &inputValue)
{
    // A new value is saved to the application settings object.
    QSettings settings;
    settings.setValue(objectName, QVariant(inputValue));
}


