#include "TranslatorAPIs/MyMemoryTranslatorApi.h"

MyMemoryTranslatorApi::MyMemoryTranslatorApi(bool use_local_lang_codes)
{
  qDebug() << "(MyMemoryTranslatorApi) Initialization ...";

  // Init network manager to MyMemory Translate API
  _network_manager = new QNetworkAccessManager(this);
  connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onTranslationNetworkAnswer(QNetworkReply*)));

  // Init local language code list
  _use_local_language_codes = use_local_lang_codes;
  if(_use_local_language_codes)
    initLocalLanguageCodes();
}

MyMemoryTranslatorApi::~MyMemoryTranslatorApi()
{

}

void MyMemoryTranslatorApi::sendTranslationNetworkRequest(QString input_text, QString source_lang, QString target_lang, QString email, QString model)
{
    // Reference https://mymemory.translated.net/doc/spec.php -> GET
    // * Free, anonymous usage is limited to 1000 words/day.
    QUrl serviceUrl = QUrl(_translation_url);

    QUrlQuery query;
    query.addQueryItem("q", input_text.toStdString().c_str());          // the text to be translated
    query.addQueryItem("langpair", source_lang + "|" + target_lang);    // the language of the source text
    query.addQueryItem("mt", model);    // (1) Enables Machine Translation in results. (0) You can turn it off if you want just human segments

    // (Optional) Provide an email to enjoy 10000 words/day.
    if(email.trimmed() != "")
        query.addQueryItem("de", email.trimmed());

    QByteArray postData;
    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(networkRequest,postData);
}

void MyMemoryTranslatorApi::sendLanguagesNetworkRequest()
{
    // MyMemory provides ~400 languages and most of them are not working yet.
    // So, return here the local list directly in the appropriate case:
    if(_use_local_language_codes)
    {
        emit onLanguagesResult(_local_languages_codes);
    }
    else
    {
        // Reference: https://www.matecat.com/api/docs#Languages
        QUrl serviceUrl = QUrl(_languages_url);

        QNetworkRequest networkRequest(serviceUrl);
        networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

        _network_manager->get(networkRequest);
    }
}

void MyMemoryTranslatorApi::onTranslationNetworkAnswer(QNetworkReply *reply)
{
    // Read result
    QByteArray result = reply->readAll();
    qDebug() << "(MyMemoryTranslatorApi) Network reply: " << result;
    //(MyMemoryTranslatorApi) Network reply:  "{\"responseData\":{\"translatedText\":\"Hola\",\"match\":1},\"quotaFinished\":false,\"mtLangSupported\":null,\"responseDetails\":\"\",\"responseStatus\":200,\"responderId\":\"45\",\"exception_code\":null,\"matches\":[{\"id\":\"659225237\",\"segment\":\"Hello\",\"translation\":\"Hola\",\"source\":\"en-GB\",\"target\":\"es-ES\",\"quality\":\"74\",\"reference\":null,\"usage-count\":81,\"subject\":\"All\",\"created-by\":\"MateCat\",\"last-updated-by\":\"MateCat\",\"create-date\":\"2020-11-08 18:45:51\",\"last-update-date\":\"2020-11-08 18:45:51\",\"match\":1},{\"id\":\"644686192\",\"segment\":\"Hello\",\"translation\":\"Hello\",\"source\":\"en-US\",\"target\":\"es-ES\",\"quality\":\"74\",\"reference\":null,\"usage-count\":5,\"subject\":\"All\",\"created-by\":\"MateCat\",\"last-updated-by\":\"MateCat\",\"create-date\":\"2020-04-19 14:22:35\",\"last-update-date\":\"2020-04-19 14:22:35\",\"match\":0.99},{\"id\":\"654051149\",\"segment\":\"Hello\",\"translation\":\"Buenas tardes\",\"source\":\"en-US\",\"target\":\"es-419\",\"quality\":\"74\",\"reference\":null,\"usage-count\":1,\"subject\":\"All\",\"created-by\":\"MateCat\",\"last-updated-by\":\"MateCat\",\"create-date\":\"2020-09-29 16:16:06\",\"last-update-date\":\"2020-09-29 16:16:06\",\"match\":0.98}]}"
    //(MyMemoryTranslatorApi) Network reply:  "{\"Achinese\":{\"2\":\"ace\",\"3\":\"ace\",\"c\":\"ID\",\"3066\":\"ace-ID\"},\"Adyghe\":{\"2\":\"ady\",\"3\":\"ady\",\"c\":\"RU\",\"3066\":\"ady-RU\"},\"Afrikaans\":{\"2\":\"af\",\"3\":\"afr\",\"c\":\"ZA\",\"3066\":\"af-ZA\"},\"Ainu\":{\"2\":\"ain\",\"3\":\"ain\",\"c\":\"JA\",\"3066\":\"ain-JA\"},\"Akan\":{\"2\":\"aka\",\"3\":\"aka\",\"c\":\"RU\",\"3066\":\"aka-GH\"}, .....

    // Parse to JSON and get translations
    QJsonDocument document = QJsonDocument::fromJson(result);
    QJsonObject object = document.object();
    QJsonObject data = object["responseData"].toObject();
    // Check if it is a translation result or a languages list request
    if(data.find("translatedText") != data.end())
    {
        // Publish the translation result using the standard signal
        QString translated_text = data["translatedText"].toString();
        qDebug() << "(MyMemoryTranslatorApi) Translation result:" << translated_text;
        QString escaped_text = translated_text.replace("&#10;","\n");
        emit onTranslationResult(escaped_text);

        // Fill and publish the MyMemory extra info using the special signal
        MyMemoryResultInfo info;
        info.result = data["translatedText"].toString().toStdString();
        info.confidence = data["match"].toDouble();
        info.quotaFinished = object["quotaFinished"].toBool();
        QJsonArray matches_array = object["matches"].toArray();
        for(const auto match : matches_array)
        {
            QJsonObject obj = match.toObject();
            MyMemoryResultMatch new_match;
            new_match.source_text       = obj["segment"].toString().toStdString();
            new_match.translated_text   = obj["translation"].toString().toStdString();
            new_match.source_lang       = obj["source"].toString().toStdString();
            new_match.translated_lang   = obj["target"].toString().toStdString();
            new_match.confidence        = obj["confidence"].toDouble();
            new_match.quality           = obj["quality"].toDouble();
            new_match.reference         = obj["reference"].toString().toStdString();
            new_match.created_by        = obj["created-by"].toString().toStdString();
            info.matches.push_back(new_match);
        }

        emit onTranslationResultInfo(info);
    }
    else
    {
        if(object.size() > 0)
        {
            QStringList tmp_lang_codes;
            for(const auto value : object)
            {
                QJsonObject obj = value.toObject();
                tmp_lang_codes.append(QString(obj["2"].toString()));
                qDebug() << "(MyMemoryTranslatorApi) Lang Code: " << obj["2"].toString();
            }

            emit onLanguagesResult(tmp_lang_codes);
        }
        else
        {
            emit onErrorResult("MyMemory Translation API answers with an unexpected reply");
        }
    }
}

void MyMemoryTranslatorApi::initLocalLanguageCodes()
{
    _local_languages_codes   << "af" << "sq" << "am" << "ar" << "hy" << "az" << "bjs"
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
