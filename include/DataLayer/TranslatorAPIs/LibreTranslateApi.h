#ifndef LIBRETRANSLATEAPI_H
#define LIBRETRANSLATEAPI_H

#include <TranslatorAPIs/AbstractTranslateApi.h>

using namespace std;

class LibreTranslateApi : public AbstractTranslateApi
{
  Q_OBJECT

public:

  // Constructor
  LibreTranslateApi();

  // Destuctor
  ~LibreTranslateApi();

  // Send translation request
  void sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang);

  // Send available language list request
  void sendLanguagesNetworkRequest();

private slots:

  // Receive replies
  void onTranslationNetworkAnswer(QNetworkReply* reply);

private:

  // URLs
  QString _translation_url { "https://libretranslate.com/translate" };
  QString _languages_url   { "https://libretranslate.com/languages"};
};

#endif // LIBRETRANSLATEAPI_H
