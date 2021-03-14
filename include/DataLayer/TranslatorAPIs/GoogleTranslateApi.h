#ifndef GOOGLETRANSLATEAPI_H
#define GOOGLETRANSLATEAPI_H

#include <TranslatorAPIs/AbstractTranslateApi.h>

using namespace std;

class GoogleTranslateApi : public AbstractTranslateApi
{
  Q_OBJECT

public:

  // Constructor
  GoogleTranslateApi();

  // Destuctor
  ~GoogleTranslateApi();

  // Send translation request
  void sendTranslationNetworkRequest(QString input_text, QString key, QString source_lang, QString target_lang, QString model = "nmt");

  // Send available language list request
  void sendLanguagesNetworkRequest(QString key, QString target_lang = "", QString model = "nmt");

private slots:

  // Receive replies
  void onTranslationNetworkAnswer(QNetworkReply* reply);

private:

  // URLs
  QString _translation_url { "https://translation.googleapis.com/language/translate/v2" };
  QString _languages_url   { "https://translation.googleapis.com/language/translate/v2/languages"};
};

#endif // GOOGLETRANSLATEAPI_H
