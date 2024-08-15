#include "CustomNetworkAccessManager.h"

CustomNetworkAccessManager::CustomNetworkAccessManager(QObject *parent) {}

QNetworkReply *CustomNetworkAccessManager::createRequest(
    QNetworkAccessManager::Operation op, const QNetworkRequest &req,
    QIODevice *outgoingData) {
    QNetworkRequest new_req(req);
    new_req.setRawHeader("User-Agent", "welkweer/1.0.0");

    QNetworkReply *reply =
        QNetworkAccessManager::createRequest(op, new_req, outgoingData);
    return reply;
}
