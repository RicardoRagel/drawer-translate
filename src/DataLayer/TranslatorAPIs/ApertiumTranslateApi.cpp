#include "TranslatorAPIs/ApertiumTranslateApi.h"

ApertiumTranslateApi::ApertiumTranslateApi()
{
  qDebug() << "(ApertiumTranslateApi) Initialization ...";
}

ApertiumTranslateApi::~ApertiumTranslateApi()
{

}

// Reference: https://wiki.apertium.org/wiki/Apertium-apy
void ApertiumTranslateApi::sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang)
{
    // Generate POST data
    QByteArray post_data;
    QUrlQuery query;
    query.addQueryItem("q", input_text);        // the text to be translated
    query.addQueryItem("langpair", source_lang + "|" + target_lang);    // the language of the source | target text
    post_data = query.toString(QUrl::FullyEncoded).toUtf8();

    // Send POST
    translationPostNetworkRequest(_translation_url, post_data);
}

// Reference: https://wiki.apertium.org/wiki/Apertium-apy
// Test: $ curl -X GET https://beta.apertium.org/apy/listPairs
void ApertiumTranslateApi::sendLanguagesNetworkRequest()
{
    // Generate POST data
    QByteArray post_data;
    QUrlQuery query;
    query.addQueryItem("include_deprecated_codes", "true");        // the text to be translated
    post_data = query.toString(QUrl::FullyEncoded).toUtf8();

    // Send GET
    languagesPostNetworkRequest(_languages_url, post_data);
}

void ApertiumTranslateApi::onTranslationNetworkAnswer(QNetworkReply *reply)
{
    // Read result
    QByteArray result = reply->readAll();
    //qDebug() << "(ApertiumTranslateApi) Network reply: " << result;
    // (ApertiumTranslateApi) Network reply:  "{\"responseData\": [{\"sourceLanguage\": \"afr\", \"targetLanguage\": \"deu\"}, {\"sourceLanguage\": \"afr\", \"targetLanguage\": \"nld\"}, ...]}
    // (ApertiumTranslateApi) Network reply:  "{\"responseData\": {\"translatedText\": \"Hola\"}, \"responseDetails\": null, \"responseStatus\": 200}"
    // (ApertiumTranslateApi) Network reply:  "{\"status\": \"error\", \"code\": 400, \"message\": \"Bad Request\", \"explanation\": \"That pair is not installed\"}"

    // Parse to JSON and get translations
    QJsonDocument document = QJsonDocument::fromJson(result);
    QJsonObject object = document.object();

    // Check if it is a translation result or a languages list request
    if(object.find("responseData") != object.end())
    {
        // Translation result
        QJsonObject data = object["responseData"].toObject();
        if(data.find("translatedText") != data.end())
        {
            //qDebug() << "(ApertiumTranslateApi) Getting translation result... ";
            QString translated_text = data["translatedText"].toString();
            QString escaped_text = removeUnexpectedTags(translated_text);
            emit newTranslationResult(escaped_text);
        }

        // Language Codes
        QStringList lang_codes;
        QJsonArray array = object["responseData"].toArray();
        if(!array.isEmpty())
        {
            //qDebug() << "(ApertiumTranslateApi) Getting language codes result... ";
            for(const auto language_pair : array)
            {
                QString source_lang = language_pair.toObject()["sourceLanguage"].toString();

                if(!lang_codes.contains(source_lang))
                {
                    //qDebug() << "(ApertiumTranslateApi) Language code: " + source_lang;
                    lang_codes.append(source_lang);
                }
            }

            emit newLanguagesResult(lang_codes);
        }
    }
    else
    {
        // If no responseData, it is an error message
        QString error_msg = "Apertium replies with an error";
        if(object.find("status") != object.end())
        {
            if(object["status"] == "error")
            {
                if(object.find("explanation") != object.end())
                {
                    error_msg = object["explanation"].toString();
                }
            }
        }

        emit newError(error_msg);
    }
}

QString ApertiumTranslateApi::removeUnexpectedTags(QString original_text)
{
    return original_text.remove("#").remove("@");
}
