#ifndef LIBRETRANSLATEAPI_H
#define LIBRETRANSLATEAPI_H

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

class LibreTranslateApi : public QObject
{
  Q_OBJECT

public:

  // Constructor
  LibreTranslateApi();

  // Destuctor
  ~LibreTranslateApi();

  // Send available language list request
  void sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang);

  // Send available language list request
  void sendLanguagesNetworkRequest();

signals:
  void onTranslationResult(QString result);
  void onLanguagesResult(QStringList result);
  void onErrorResult(QString error);

private slots:

  // Receive QNetworkAccessManager replies
  void onTranslationNetworkAnswer(QNetworkReply* reply);

private:

  // Variables
  QNetworkAccessManager *_network_manager;      // System network handler to post request to the online translator
  QString _translation_url { "https://libretranslate.com/translate" };
  QString _languages_url   { "https://libretranslate.com/languages"};
};

#endif // LIBRETRANSLATEAPI_H
