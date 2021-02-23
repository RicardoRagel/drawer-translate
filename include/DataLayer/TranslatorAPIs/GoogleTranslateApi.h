#ifndef GOOGLETRANSLATEAPI_H
#define GOOGLETRANSLATEAPI_H

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

class GoogleTranslateApi : public QObject
{
  Q_OBJECT

public:

  // Constructor
  GoogleTranslateApi();

  // Destuctor
  ~GoogleTranslateApi();

  // Send available language list request
  void sendTranslationNetworkRequest(QString input_text, QString key, QString source_lang, QString target_lang, QString model = "nmt");

  // Send available language list request
  void sendLanguagesNetworkRequest(QString key, QString target_lang = "", QString model = "nmt");

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
  QString _translation_url { "https://translation.googleapis.com/language/translate/v2" };
  QString _languages_url   { "https://translation.googleapis.com/language/translate/v2/languages"};
};

#endif // GOOGLETRANSLATEAPI_H
