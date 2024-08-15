#ifndef CUSTOMNETWORKACCESSMANAGER_H
#define CUSTOMNETWORKACCESSMANAGER_H

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QObject>

class CustomNetworkAccessManager : public QNetworkAccessManager {
   public:
    explicit CustomNetworkAccessManager(QObject *parent = 0);

   protected:
    QNetworkReply *createRequest(Operation op, const QNetworkRequest &req,
                                 QIODevice *outgoingData = 0);
};

#endif  // CUSTOMNETWORKACCESSMANAGER_H
