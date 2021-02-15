#include "TranslatorAPIs/MyMemoryTranslatorApi.h"

MyMemoryTranslatorApi::MyMemoryTranslatorApi()
{
  qDebug() << "(MyMemoryTranslatorApi) Initialization ...";

  // Init network manager to MyMemory Translate API
  _network_manager = new QNetworkAccessManager(this);
  connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onTranslationNetworkAnswer(QNetworkReply*)));

  // Init local language code list
  initLocalLanguageCodes();
}

MyMemoryTranslatorApi::~MyMemoryTranslatorApi()
{

}

void MyMemoryTranslatorApi::sendTranslationNetworkRequest(QString input_text, QString key, QString source_lang, QString target_lang, QString model)
{
    // Reference https://mymemory.translated.net/doc/spec.php -> GET
    // * Free, anonymous usage is limited to 1000 words/day.
    // * Provide a valid email ('de' parameter), where we can reach you in case of troubles, and enjoy 10000 words/day.
    QUrl serviceUrl = QUrl(_translation_url);

    QUrlQuery query;
    query.addQueryItem("q", input_text.toStdString().c_str());          // the text to be translated
    query.addQueryItem("langpair", source_lang + "|" + target_lang);    // the language of the source text

    QByteArray postData;
    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(networkRequest,postData);
}

void MyMemoryTranslatorApi::sendLanguagesNetworkRequest()
{
    // MyMemory API doesn't provide a network request to get the available language codes
    // so, we return here the local list directly:
    emit onLanguagesResult(_languages_codes);
}

void MyMemoryTranslatorApi::onTranslationNetworkAnswer(QNetworkReply *reply)
{
    // Read result
    QByteArray result = reply->readAll();
    qDebug() << "(MyMemoryTranslatorApi) Network reply: " << result;
    //(MyMemoryTranslatorApi) Network reply:  "{\"responseData\":{\"translatedText\":\"Hola\",\"match\":1},\"quotaFinished\":false,\"mtLangSupported\":null,\"responseDetails\":\"\",\"responseStatus\":200,\"responderId\":\"45\",\"exception_code\":null,\"matches\":[{\"id\":\"659225237\",\"segment\":\"Hello\",\"translation\":\"Hola\",\"source\":\"en-GB\",\"target\":\"es-ES\",\"quality\":\"74\",\"reference\":null,\"usage-count\":81,\"subject\":\"All\",\"created-by\":\"MateCat\",\"last-updated-by\":\"MateCat\",\"create-date\":\"2020-11-08 18:45:51\",\"last-update-date\":\"2020-11-08 18:45:51\",\"match\":1},{\"id\":\"644686192\",\"segment\":\"Hello\",\"translation\":\"Hello\",\"source\":\"en-US\",\"target\":\"es-ES\",\"quality\":\"74\",\"reference\":null,\"usage-count\":5,\"subject\":\"All\",\"created-by\":\"MateCat\",\"last-updated-by\":\"MateCat\",\"create-date\":\"2020-04-19 14:22:35\",\"last-update-date\":\"2020-04-19 14:22:35\",\"match\":0.99},{\"id\":\"654051149\",\"segment\":\"Hello\",\"translation\":\"Buenas tardes\",\"source\":\"en-US\",\"target\":\"es-419\",\"quality\":\"74\",\"reference\":null,\"usage-count\":1,\"subject\":\"All\",\"created-by\":\"MateCat\",\"last-updated-by\":\"MateCat\",\"create-date\":\"2020-09-29 16:16:06\",\"last-update-date\":\"2020-09-29 16:16:06\",\"match\":0.98}]}"

    // Parse to JSON and get translations
    QJsonDocument document = QJsonDocument::fromJson(result);
    QJsonObject object = document.object();
    QJsonObject data = object["responseData"].toObject();

    // Check if it is a translation result or a languages list request
    if(data.find("translatedText") != data.end())
    {
        qDebug() << "(MyMemoryTranslatorApi) Translation result:" << data["translatedText"].toString();

        emit onTranslationResult(data["translatedText"].toString());
    }
    else
    {
        emit onErrorResult("MyMemory Translation API answers with an unexpected reply");
    }
}

void MyMemoryTranslatorApi::initLocalLanguageCodes()
{
    _languages_codes << "af" << "sq" << "am" << "ar" << "hy" << "az" << "bjs"
                     << "rm" << "eu" << "bem" << "bn" << "be" << "bi" << "bs"
                     << "br" << "bg" << "my" << "ca" << "cb" << "cha" << "zh-CN"
                     << "zh-TW" << "zdj" << "cop" << "aig" << "bah" << "gcl" << "gyn"
                     << "jam" << "svc" << "vic" << "ht" << "acf" << "crs" << "pov"
                     << "hr" << "cs" << "da" << "nl" << "dzo" << "en" << "eo" << "et"
                     << "fn" << "fo" << "fi" << "fr" << "gl" << "ka" << "de" << "el"
                     << "grc" << "gu" << "ha" << "haw" << "he" << "hi" << "hu" << "is"
                     << "id" << "kal" << "ga" << "it" << "ja" << "jv" << "kea" << "kab"
                     << "kn" << "kk" << "km" << "rw" << "run" << "ko" << "ku" << "ku"
                     << "ky" << "lo" << "la" << "lv" << "lt" << "lb" << "mk" << "mg"
                     << "ms" << "div" << "mt" << "gv" << "mi" << "mh" << "men" << "mn"
                     << "mfe" << "ne" << "niu" << "no" << "ny" << "ur" << "pau" << "pa"
                     << "pap" << "ps" << "fa" << "pis" << "pl" << "pt" << "pot" << "qu"
                     << "ro" << "ru" << "smo" << "sg" << "gd" << "sr" << "sna" << "si"
                     << "sk" << "sl" << "so" << "nso" << "es" << "srn" << "sw" << "sv"
                     << "de" << "syc" << "tl" << "tg" << "tmh" << "ta" << "te" << "tet"
                     << "th" << "bod" << "ti" << "tpi" << "tkl" << "ton" << "tn" << "tr"
                     << "tk" << "tvl" << "uk" << "ppk" << "uz" << "vi" << "wls" << "cy"
                     << "wo" << "xh" << "yi" << "zu";
}
