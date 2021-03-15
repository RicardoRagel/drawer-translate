#ifndef APERTIUMTRANSLATEAPI_H
#define APERTIUMTRANSLATEAPI_H

#include <TranslatorAPIs/AbstractTranslateApi.h>

using namespace std;

class ApertiumTranslateApi : public AbstractTranslateApi
{
  Q_OBJECT

public:

  // Constructor
  ApertiumTranslateApi();

  // Destuctor
  ~ApertiumTranslateApi();

  // Send translation request
  void sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang);

  // Send available language list request
  void sendLanguagesNetworkRequest();

private slots:

  // Receive replies
  void onTranslationNetworkAnswer(QNetworkReply* reply);

private:

  // URLs
  QString _translation_url { "https://beta.apertium.org/apy/translate" };
  QString _languages_url   { "https://beta.apertium.org/apy/listPairs"};

  // Remove some unexpected characters (tags)
  QString removeUnexpectedTags(QString original_text);
};

#endif // APERTIUMTRANSLATEAPI_H
