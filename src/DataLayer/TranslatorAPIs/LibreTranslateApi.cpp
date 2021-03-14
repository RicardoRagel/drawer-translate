#include "TranslatorAPIs/LibreTranslateApi.h"

LibreTranslateApi::LibreTranslateApi()
{
  qDebug() << "(LibreTranslateApi) Initialization ...";
}

LibreTranslateApi::~LibreTranslateApi()
{

}

// Reference: https://libretranslate.com/docs/#/translate/post_translate
// Test: curl -X POST "https://libretranslate.com/translate" -H  "accept: application/json" -H  "Content-Type: application/x-www-form-urlencoded" -d "q=You are not my enemy&source=en&target=es"
// {"translatedText":"No eres mi enemigo."}
void LibreTranslateApi::sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang)
{
    // Generate POST data
    QByteArray post_data;
    QUrlQuery query;
    query.addQueryItem("q", input_text);        // the text to be translated
    query.addQueryItem("source", source_lang);  // the language of the source text
    query.addQueryItem("target", target_lang);  // the language we want to translate the input text
    post_data = query.toString(QUrl::FullyEncoded).toUtf8();

    // Send POST
    translationPostNetworkRequest(_translation_url, post_data);
}

// Reference: https://libretranslate.com/docs/#/translate/get_languages
void LibreTranslateApi::sendLanguagesNetworkRequest()
{
    // Send GET
    languagesGetNetworkRequest(_languages_url);
}

void LibreTranslateApi::onTranslationNetworkAnswer(QNetworkReply *reply)
{
    // Read result
    QByteArray result = reply->readAll();
    //qDebug() << "(LibreTranslateApi) Network reply: " << result;
    // (LibreTranslateApi) Network reply:  "[{\"code\":\"en\",\"name\":\"English\"},{\"code\":\"ar\",\"name\":\"Arabic\"}, ...]\n"

    // Parse to JSON and get translations
    QJsonDocument document = QJsonDocument::fromJson(result);
    QJsonObject object = document.object();
    QJsonArray array = document.array();
    //qDebug() << "(LibreTranslateApi) Object: " << object.isEmpty();
    //qDebug() << "(LibreTranslateApi) Array: " << array.isEmpty();

    // Check if it is a translation result or a languages list request
    if(object.find("translatedText") != object.end())
    {
        qDebug() << "(LibreTranslateApi) Translation result:" << object["translatedText"].toString();

        emit newTranslationResult(object["translatedText"].toString());
    }
    else
    {
        if(array.size() > 0)
        {
            QStringList tmp_lang_codes;
            for(const auto value : array)
            {
                QJsonObject obj = value.toObject();
                tmp_lang_codes.append(QString(obj["code"].toString()));
                qDebug() << "(LibreTranslateApi) Lang Code: " << obj["code"].toString();
            }

            emit newLanguagesResult(tmp_lang_codes);
        }
        else
        {
            emit newError("LibreTranslate API answers with an unexpected reply");
        }
    }
}
