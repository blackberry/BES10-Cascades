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



#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/system/SystemToast>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeReplyError>
#include <bb/system/InvokeRequest>
#include <bb/cascades/Invocation>
#include <bb/cascades/InvokeQuery>
#include <bb/system/InvokeRequest>
#include <bb/system/SystemDialog>

#include <QPropertyAnimation>

#include <bb/ImageData>
#include <bb/cascades/Image>

#include <unistd.h>
#include "Carousel.hpp"
#include "Dialog.hpp"

using namespace bb::cascades;
using namespace bb::system;

Carousel::Carousel(bb::cascades::Application *app) :
    QObject(app)
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

// Let's not have all the images mirrored, let's do that in code, and some alpha on them as well
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

//Invite a user, via the BBM pin to chat over BBM
void Carousel::invokeBBMInvite()
{
	InvokeManager invokeManager;
	InvokeRequest request;

	// Who do we want to send the invoke request to?
	request.setTarget("sys.bbm.sharehandler");

	// What do we want the target application to do with it?
	request.setAction("bb.action.BBMCHAT");

	// Where is the data?
	request.setUri(QUrl("pin:2AB00000"));

	InvokeTargetReply *reply = invokeManager.invoke(request);
}

//Share text to individual contact over BBM, contact picker will be displayed and BBM contact can be selected
void Carousel::invokeBBMShareText()
{
	InvokeManager invokeManager;
	InvokeRequest request;

	QString text = "Sharing this text over BBM :-)";
	QByteArray data = text.toAscii();

	// Who do we want to send the invoke request to?
	request.setTarget("sys.bbm.sharehandler");

	// What do we want the target application to do with it?
	request.setAction("bb.action.SHARE");

	// What are we sending?
	request.setMimeType("text/plain");

	// Where is the data?
	request.setData(data);

	InvokeTargetReply *reply = invokeManager.invoke(request);
}

//Share text to group over BBM, group picker will be displayed and BBM group can be selected
void Carousel::invokeBBMShareTextGrp()
{
	InvokeManager invokeManager;
	InvokeRequest request;

	QString text = "Group share of this text :-)";
	QByteArray data = text.toAscii();


	// Who do we want to send the invoke request to?
	request.setTarget("sys.bbgroups.sharehandler");

	// What do we want the target application to do with it?
	request.setAction("bb.action.SHARE");

	// What are we sending?
	request.setMimeType("text/plain");

	// Where is the data?
	request.setData(data);

	InvokeTargetReply *reply = invokeManager.invoke(request);
}

//Share an image to an individual contact over BBM, contact picker will be displayed and BBM contact can be selected
void Carousel::invokeBBMShareImage()
{
	InvokeManager invokeManager;
	InvokeRequest request;

	// Who do we want to send the invoke request to?
	request.setTarget("sys.bbm.sharehandler");

	// What do we want the target application to do with it?
	request.setAction("bb.action.SHARE");

	//where is the data
	request.setUri ("file:" + QDir::currentPath() + "/app/native/assets/images/pSmall.png");

	InvokeTargetReply *invokeReply = invokeManager.invoke(request);

	if(invokeReply) {
		invokeReply->setParent(this);
		connect(invokeReply, SIGNAL(finished()), this, SLOT(onInvokeResult()));
		_invokeTargetReply = invokeReply;
	}
}

//Share an image to a group over BBM, contact picker will be displayed and BBM group can be selected
void Carousel::invokeBBMShareImageGrp()
{
	InvokeManager invokeManager;
	InvokeRequest request;

	// Who do we want to send the invoke request to?
	request.setTarget("sys.bbgroups.sharehandler");

	// What do we want the target application to do with it?
	request.setAction("bb.action.SHARE");

	//where is the data
	request.setUri ("file:" + QDir::currentPath() + "/app/native/assets/images/pSmall.png");

		InvokeTargetReply *invokeReply = invokeManager.invoke(request);

		if(invokeReply) {
			invokeReply->setParent(this);
			connect(invokeReply, SIGNAL(finished()), this, SLOT(onInvokeResult()));
			_invokeTargetReply = invokeReply;
		}
}

//SLOT to handle the result of the invocation request
void Carousel::onInvokeResult()
{

	// Check for errors
	    switch(_invokeTargetReply->error()) {
	        // Invocation could not find the target
	        // did we use the right target ID?
	    case InvokeReplyError::NoTarget: {
	            //out << "invokeFinished(): Error: no target" << endl;
	    		//alertDialog.show()
	    		showDialog(QString("invokeFinished(): Error: no target"));
	            break;
	        }
	        // There was a problem with the invoke request
	        // did we set all the values correctly?
	    case InvokeReplyError::BadRequest: {
	            //cout << "invokeFinished(): Error: bad request" << endl;
	    		showDialog(QString("invokeFinished(): Error: bad  sssrequest"));

	            break;
	        }
	        // Something went completely
	        // wrong inside the invocation request
	        // Find an alternate route :(
	    case InvokeReplyError::Internal: {
	            //cout << "invokeFinished(): Error: internal" << endl;
	    		showDialog(QString("invokeFinished(): Error: internal"));
	            break;
	        }
	        //Message received if the invoke request is successful
	    default:
	        //cout << "invokeFinished(): Invoke Succeeded" << endl;
	        break;
	    }

	    // A little house keeping never hurts...
	    delete _invokeTargetReply;
}

// A public function to display a SystemDialog in your UI
void Carousel::showDialog(QString errMsg)
{
	SystemDialog *dialog = new SystemDialog("OK");

    dialog->setTitle("Problem!");

    dialog->setBody(errMsg);

    dialog->setEmoticonsEnabled(true);

    // Connect the finished() signal to the onDialogFinished() slot.
    // The slot will check the SystemUiResult to see which button was tapped.

    bool success = connect(dialog,
        SIGNAL(finished(bb::system::SystemUiResult::Type)),
        this,
        SLOT(onDialogFinished(bb::system::SystemUiResult::Type)));

    if (success) {
        // Signal was successfully connected.
        // Now show the dialog box in your UI.

        dialog->show();
    } else {
        // Failed to connect to signal.
        dialog->deleteLater();
    }
}

void Carousel::onDialogFinished(bb::system::SystemUiResult::Type type)
{

}
