#ifndef ABSTRACTTRANSLATEAPI_H
#define ABSTRACTTRANSLATEAPI_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QUrlQuery>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

using namespace std;

/*!
 * \brief The AbstractTranslateApi class provides the Network methods to send
 * POST and GET request to the derived translate API classes, that just need to
 * fill the URL and POST data for the request and override the function
 * onTranslationNetworkAnswer() to receive the API reply and emit the corresponding
 * signals.
 */

class AbstractTranslateApi : public QObject
{
  Q_OBJECT

public:

  /*! Constructor */
  AbstractTranslateApi();

  /*! Destuctor */
  ~AbstractTranslateApi();

  /*! Send a translation POST request */
  void translationPostNetworkRequest(QUrl url, QByteArray post_data);

  /*! Send a GET request of the available language list */
  void languagesGetNetworkRequest(QUrl url);

  /*! Send a POST request of the available language list */
  void languagesPostNetworkRequest(QUrl url, QByteArray post_data);

signals:

  /*! Emit this signal with a successful translation result */
  void newTranslationResult(QString result);

  /*! Emit this signal with a successful list of available languages */
  void newLanguagesResult(QStringList result);

  /*! Emit this signal with an error message from the API */
  void newError(QString error);

private slots:

  /*! Pure Virtual Method.Receive QNetworkAccessManager replies. This method
   * must be override by the derived class depending on the results given by the API
   * and emiting the corresponding AbstracTranslateApi signals
  */
  virtual void onTranslationNetworkAnswer(QNetworkReply* reply) = 0;

private:

  /*! System network handler to send post/get requests to the online translator */
  QNetworkAccessManager *_network_manager;
};

#endif // ABSTRACTTRANSLATEAPI_H
