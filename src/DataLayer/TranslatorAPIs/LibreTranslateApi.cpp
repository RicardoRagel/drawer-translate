#include "TranslatorAPIs/LibreTranslateApi.h"

LibreTranslateApi::LibreTranslateApi()
{
  qDebug() << "(LibreTranslateApi) Initialization ...";

  // Init network manager to Libre Translate API
  _network_manager = new QNetworkAccessManager(this);
  connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onTranslationNetworkAnswer(QNetworkReply*)));
}

LibreTranslateApi::~LibreTranslateApi()
{

}

void LibreTranslateApi::sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang)
{
    // Reference: https://libretranslate.com/docs/#/translate/post_translate
    // Test: curl -X POST "https://libretranslate.com/translate" -H  "accept: application/json" -H  "Content-Type: application/x-www-form-urlencoded" -d "q=You are not my enemy&source=en&target=es"
    // {"translatedText":"No eres mi enemigo."}
    QUrl serviceUrl = QUrl(_translation_url);

    QUrlQuery query;
    query.addQueryItem("q", input_text);        // the text to be translated
    query.addQueryItem("source", source_lang);  // the language of the source text
    query.addQueryItem("target", target_lang);  // the language we want to translate the input text

    QByteArray postData;
    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(networkRequest,postData);
}

void LibreTranslateApi::sendLanguagesNetworkRequest()
{
    // Reference: https://libretranslate.com/docs/#/translate/get_languages
    QUrl serviceUrl = QUrl(_languages_url);

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->get(networkRequest);
}

void LibreTranslateApi::onTranslationNetworkAnswer(QNetworkReply *reply)
{
    // Read result
    QByteArray result = reply->readAll();
    qDebug() << "(LibreTranslateApi) Network reply: " << result;
    //  (LibreTranslateApi) Network reply:  "[{\"code\":\"en\",\"name\":\"English\"},{\"code\":\"ar\",\"name\":\"Arabic\"},{\"code\":\"zh\",\"name\":\"Chinese\"},{\"code\":\"fr\",\"name\":\"French\"},{\"code\":\"de\",\"name\":\"German\"},{\"code\":\"it\",\"name\":\"Italian\"},{\"code\":\"pt\",\"name\":\"Portuguese\"},{\"code\":\"ru\",\"name\":\"Russian\"},{\"code\":\"es\",\"name\":\"Spanish\"}]\n"

    // Parse to JSON and get translations
    QJsonDocument document = QJsonDocument::fromJson(result);
    QJsonObject object = document.object();
    QJsonArray array = document.array();
    qDebug() << "(LibreTranslateApi) Object: " << object.isEmpty();
    qDebug() << "(LibreTranslateApi) Array: " << array.isEmpty();

    // Check if it is a translation result or a languages list request
    if(object.find("translatedText") != object.end())
    {
        qDebug() << "(LibreTranslateApi) Translation result:" << object["translatedText"].toString();

        emit onTranslationResult(object["translatedText"].toString());
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

            emit onLanguagesResult(tmp_lang_codes);
        }
        else
        {
            emit onErrorResult("LibreTranslate API answers with an unexpected reply");
        }
    }
}
