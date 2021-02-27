#ifndef MYMEMORYTRANSLATEAPI_H
#define MYMEMORYTRANSLATEAPI_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QRegularExpression>
#include <QUrlQuery>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <string.h>
#include <vector>

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

class MyMemoryTranslateApi : public QObject
{
  Q_OBJECT

public:

  // Constructor
  MyMemoryTranslateApi(bool use_local_lang_codes = false);

  // Destuctor
  ~MyMemoryTranslateApi();

  // Send available language list request
  void sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang, QString email = "", QString model = "1");

  // Send available language list request
  void sendLanguagesNetworkRequest();

signals:
  void onTranslationResult(QString result);
  void onTranslationResultInfo(MyMemoryResultInfo info);
  void onLanguagesResult(QStringList result);
  void onErrorResult(QString error);

private slots:

  // Receive QNetworkAccessManager replies
  void onTranslationNetworkAnswer(QNetworkReply* reply);

private:

  // Variables
  QNetworkAccessManager *_network_manager;      // System network handler to post request to the online translator
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