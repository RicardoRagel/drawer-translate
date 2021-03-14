#include "TranslatorAPIs/GoogleTranslateApi.h"

GoogleTranslateApi::GoogleTranslateApi()
{
  qDebug() << "(GoogleTranslateApi) Initialization ...";
}

GoogleTranslateApi::~GoogleTranslateApi()
{

}

// Reference: https://cloud.google.com/translate/docs/reference/rest/v2/translate
void GoogleTranslateApi::sendTranslationNetworkRequest(QString input_text, QString key, QString source_lang, QString target_lang, QString model)
{
    // Generate POST data
    QByteArray post_data;
    QUrlQuery query;
    query.addQueryItem("q", input_text);        // the text to be translated
    query.addQueryItem("source", source_lang);  // the language of the source text
    query.addQueryItem("target", target_lang);  // the language we want to translate the input text
    query.addQueryItem("format","text");        // the format of the source text (html or text)
    query.addQueryItem("model", model);         // the translation model (base or nmt)
    query.addQueryItem("key", key);             // a valid API key to handle requests for this API
    post_data = query.toString(QUrl::FullyEncoded).toUtf8();

    // Send POST
    translationPostNetworkRequest(_translation_url, post_data);
}

// Reference: https://cloud.google.com/translate/docs/reference/rest/v2/languages
void GoogleTranslateApi::sendLanguagesNetworkRequest(QString key, QString target_lang, QString model)
{
    QByteArray post_data;
    QUrlQuery query;
    query.addQueryItem("target", target_lang);  // the language we want to translate the input text
    query.addQueryItem("model",model);          // the translation model (base or nmt)
    query.addQueryItem("key", key);             // a valid API key to handle requests for this API
    post_data = query.toString(QUrl::FullyEncoded).toUtf8();

    languagesPostNetworkRequest(_languages_url, post_data);
}

void GoogleTranslateApi::onTranslationNetworkAnswer(QNetworkReply *reply)
{
    // Read result
    QByteArray result = reply->readAll();
    qDebug() << "(GoogleTranslateApi) Network reply: " << result;
    // (GoogleTranslateApi) Network reply:  "{\n  \"data\": {\n    \"translations\": [\n      {\n        \"translatedText\": \"Hola\",\n        \"model\": \"nmt\"\n      }\n    ]\n  }\n}\n"
    // (GoogleTranslateApi) Network reply:  "{\n  \"data\": {\n    \"languages\": [\n      {\n        \"language\": \"af\"\n      },\n      {\n        \"language\": \"am\"\n      },\n      {\n        \"language\": \"ar\"\n      },\n      {\n        \"language\": \"az\"\n      },\n      {\n        \"language\": \"be\"\n      },\n      {\n        \"language\": \"bg\"\n      },\n      {\n        \"language\": \"bn\"\n

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
            qDebug() << "(GoogleTranslateApi) Translation result:" << obj["translatedText"].toString();

            emit newTranslationResult(obj["translatedText"].toString());
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
            //qDebug() << "(GoogleTranslateApi) Lang Code: " << obj["language"].toString();
        }

        emit newLanguagesResult(tmp_lang_codes);
    }
    else
    {
        emit newError("Google Translation API answers with an unexpected reply");
    }
}
