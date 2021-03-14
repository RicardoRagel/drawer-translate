#ifndef MYMEMORYTRANSLATEAPI_H
#define MYMEMORYTRANSLATEAPI_H

#include <TranslatorAPIs/AbstractTranslateApi.h>

#include <string.h>
#include <vector>
#include <QRegularExpression>

using namespace std;

struct MyMemoryResultMatch
{
    string source_text;
    string translated_text;
    string source_lang;
    string translated_lang;
    float confidence;   // translation confidence (0.0 to 1.0)
    float quality;      // Valuation given by the users (0.0 to 100.0)
    string reference;   // Reference from this translation
    string created_by;  // User that add this translation
};

struct MyMemoryResultInfo
{
    string result;      // translation result
    float confidence;   // translation confidence (0.0 to 1.0)
    bool quota_finished; // true in case the max number of request has been reached
    std::vector<MyMemoryResultMatch> matches; // Database matches for the result
};

class MyMemoryTranslateApi : public AbstractTranslateApi
{
  Q_OBJECT

public:

  // Constructor
  MyMemoryTranslateApi(bool use_local_lang_codes = false);

  // Destuctor
  ~MyMemoryTranslateApi();

  // Send translation request
  void sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang, QString email = "", QString model = "1");

  // Send available language list request
  void sendLanguagesNetworkRequest();

signals:
  void newTranslationResultInfo(MyMemoryResultInfo info);

private slots:

  // Receive replies
  void onTranslationNetworkAnswer(QNetworkReply* reply);

private:

  // URLs
  QString _translation_url  { "https://api.mymemory.translated.net/get" };
  QString _languages_url    { "https://api.mymemory.translated.net/languages" };

  // Local languages codes list. MyMemory provides ~400 languages and most of them are not working yet
  QStringList _local_languages_codes;
  bool _use_local_language_codes;

  // Functions
  void initLocalLanguageCodes();
  QString parseHtmlUnicodes(QString input);
};

#endif // MYMEMORYTRANSLATEAPI_H
