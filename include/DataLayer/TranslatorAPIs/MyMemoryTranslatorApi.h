#ifndef MYMEMORYTRANSLATORAPI_H
#define MYMEMORYTRANSLATORAPI_H

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

class MyMemoryTranslatorApi : public QObject
{
  Q_OBJECT

public:

  // Constructor
  MyMemoryTranslatorApi();

  // Destuctor
  ~MyMemoryTranslatorApi();

  // Send available language list request
  void sendTranslationNetworkRequest(QString input_text, QString key, QString source_lang, QString target_lang, QString model = "nmt");

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
  QStringList _languages_codes;                 // Languages Codes list. MyMemory doesn't provide a network request for it.
  QString _translation_url { "https://api.mymemory.translated.net/get" };

  // Functions
  void initLocalLanguageCodes();
};

#endif // MYMEMORYTRANSLATORAPI_H
