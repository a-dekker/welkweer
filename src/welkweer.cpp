/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include "CustomNetworkAccessManager.h"
#include "notificationhelper.h"
#include "settings.h"
#include <QDBusConnection>
#include <QNetworkAccessManager>
#include <QQmlEngine>
#include <QQmlNetworkAccessManagerFactory>
#include <QQuickItem>
#include <QQuickView>
#include <QtGui>
#include <QtQml>
#include <qqml.h>
#include <sailfishapp.h>

class MyNetworkAccessManagerFactory : public QQmlNetworkAccessManagerFactory {
public:
  virtual QNetworkAccessManager *create(QObject *parent);
};

QNetworkAccessManager *MyNetworkAccessManagerFactory::create(QObject *parent) {

  CustomNetworkAccessManager *nam = new CustomNetworkAccessManager(parent);

  return nam;
}

int main(int argc, char *argv[]) {
  // SailfishApp::main() will display "qml/template.qml", if you need more
  // control over initialization, you can use:
  //
  //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
  //   - SailfishApp::createView() to get a new QQuickView * instance
  //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
  //
  // To display the view, call "show()" (will show fullscreen on device).
  qmlRegisterType<Settings>("harbour.welkweer.Settings", 1, 0, "MySettings");

  QGuiApplication *app = SailfishApp::application(argc, argv);
  QCoreApplication::setApplicationName("welkweer");
  QCoreApplication::setApplicationVersion(APP_VERSION);

  QQmlApplicationEngine engine;
  MyNetworkAccessManagerFactory manager;

  QQuickView *view = SailfishApp::createView();
  view->rootContext()->setContextProperty("version", APP_VERSION);
  view->rootContext()->setContextProperty("buildyear", BUILD_YEAR);
  view->engine()->setNetworkAccessManagerFactory(&manager);
  view->setSource(SailfishApp::pathTo("qml/welkweer.qml"));
  view->show();

  QDBusConnection connection = QDBusConnection::sessionBus();
  if (!connection.registerService("org.adekker.welkweer")) {
    qWarning("Unable to register D-Bus service org.adekker.welkweer");
  }
  // if (!connection.registerObject("/", this, QDBusConnection::ExportAllSlots))
  // {
  //     qWarning("Unable to register D-Bus object at /");
  // }

  return app->exec();
}

notificationhelper::~notificationhelper() { delete view; }

void notificationhelper::bringToFront() {
  view->showFullScreen();
  view->raise();
}

void notificationhelper::actionInvoked(const QString &text) {
  QQuickItem *rootObject = view->rootObject();
  rootObject->metaObject()->invokeMethod(rootObject, "actionInvoked",
                                         Q_ARG(QVariant, text));
}
