#include "TranslatorAPIs/GoogleTranslatorApi.h"

GoogleTranslatorApi::GoogleTranslatorApi()
{
  qDebug() << "(GoogleTranslatorApi) Initialization ...";

  // Init network manager to Google Translate API
  _network_manager = new QNetworkAccessManager(this);
  connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onTranslationNetworkAnswer(QNetworkReply*)));
}

GoogleTranslatorApi::~GoogleTranslatorApi()
{

}

void GoogleTranslatorApi::sendTranslationNetworkRequest(QString input_text, QString key, QString source_lang, QString target_lang, QString model)
{
    // Reference: https://cloud.google.com/translate/docs/reference/rest/v2/translate
    QUrl serviceUrl = QUrl(_translation_url);

    QUrlQuery query;
    query.addQueryItem("q", input_text);        // the text to be translated
    query.addQueryItem("source", source_lang);  // the language of the source text
    query.addQueryItem("target", target_lang);  // the language we want to translate the input text
    query.addQueryItem("format","text");        // the format of the source text (html or text)
    query.addQueryItem("model", model);         // the translation model (base or nmt)
    query.addQueryItem("key", key);             // a valid API key to handle requests for this API

    QByteArray postData;
    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(networkRequest,postData);

    ///DEBUG https://mymemory.translated.net/doc/spec.php -> GET
    /// Free, anonymous usage is limited to 1000 words/day.
    /// Provide a valid email ('de' parameter), where we can reach you in case of troubles, and enjoy 10000 words/day.
    //    QUrl serviceUrl = QUrl("https://api.mymemory.translated.net/get");

    //    QUrlQuery query;
    //    query.addQueryItem("q", input_text.toStdString().c_str());  // the text to be translated
    //    query.addQueryItem("langpair", "en|es");      // the language of the source text

    //    QByteArray postData;
    //    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    //    QNetworkRequest networkRequest(serviceUrl);
    //    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    //    _network_manager->post(networkRequest,postData);
}

void GoogleTranslatorApi::sendLanguagesNetworkRequest(QString key, QString target_lang, QString model)
{
    // Reference: https://cloud.google.com/translate/docs/reference/rest/v2/languages
    QUrl serviceUrl = QUrl(_languages_url);

    QUrlQuery query;
    query.addQueryItem("target", target_lang);  // the language we want to translate the input text
    query.addQueryItem("model",model);          // the translation model (base or nmt)
    query.addQueryItem("key", key);             // a valid API key to handle requests for this API

    QByteArray postData;
    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(networkRequest,postData);
}

void GoogleTranslatorApi::onTranslationNetworkAnswer(QNetworkReply *reply)
{
    // Read result
    QByteArray result = reply->readAll();
    qDebug() << "(GoogleTranslatorApi) Network reply: " << result;
    // (GoogleTranslatorApi) Network reply:  "{\n  \"data\": {\n    \"translations\": [\n      {\n        \"translatedText\": \"Hola\",\n        \"model\": \"nmt\"\n      }\n    ]\n  }\n}\n"
    // (GoogleTranslatorApi) Network reply:  "{\n  \"data\": {\n    \"languages\": [\n      {\n        \"language\": \"af\"\n      },\n      {\n        \"language\": \"am\"\n      },\n      {\n        \"language\": \"ar\"\n      },\n      {\n        \"language\": \"az\"\n      },\n      {\n        \"language\": \"be\"\n      },\n      {\n        \"language\": \"bg\"\n      },\n      {\n        \"language\": \"bn\"\n

    // Parse to JSON and get translations
    QJsonDocument document = QJsonDocument::fromJson(result);
    QJsonObject object = document.object();
    QJsonObject data = object["data"].toObject();

    // Check if it is a translation result or a languages list request
    if(data.find("translations") != data.end())
    {
        QJsonArray translations_array = data["translations"].toArray();
        for(const auto value : translations_array)
        {
            QJsonObject obj = value.toObject();
            qDebug() << "(GoogleTranslatorApi) Translation result:" << obj["translatedText"].toString();

            emit onTranslationResult(obj["translatedText"].toString());
        }
    }
    else if(data.find("languages") != data.end())
    {
        QJsonArray languages_array = data["languages"].toArray();
        QStringList tmp_lang_codes;
        for(const auto value : languages_array)
        {
            QJsonObject obj = value.toObject();
            tmp_lang_codes.append(QString(obj["language"].toString()));
            //qDebug() << "(GoogleTranslatorApi) Lang Code: " << obj["language"].toString();
        }

        emit onLanguagesResult(tmp_lang_codes);
    }
    else
    {
        emit onErrorResult("Google Translation API answers with an unexpected reply");
    }
}
