#include "TranslatorAPIs/AbstractTranslateApi.h"

AbstractTranslateApi::AbstractTranslateApi()
{
  qDebug() << "(AbstractTranslateApi) Initialization ...";

  // Init network manager to receive the reply at onTranslationNetworkAnswer()
  _network_manager = new QNetworkAccessManager(this);
  connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onTranslationNetworkAnswer(QNetworkReply*)));
}

AbstractTranslateApi::~AbstractTranslateApi()
{

}

void AbstractTranslateApi::translationPostNetworkRequest(QUrl url, QByteArray post_data)
{
    QUrl serviceUrl = QUrl(url);

    QNetworkRequest network_request(serviceUrl);
    network_request.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(network_request,post_data);
}

void AbstractTranslateApi::languagesGetNetworkRequest(QUrl url)
{
    QUrl serviceUrl = QUrl(url);

    QNetworkRequest network_request(serviceUrl);
    network_request.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->get(network_request);
}

void AbstractTranslateApi::languagesPostNetworkRequest(QUrl url, QByteArray post_data)
{
    QUrl serviceUrl = QUrl(url);

    QNetworkRequest network_request(serviceUrl);
    network_request.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(network_request,post_data);
}
