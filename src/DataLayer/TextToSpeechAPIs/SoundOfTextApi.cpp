#include "TextToSpeechAPIs/SoundOfTextApi.h"

SoundOfTextApi::SoundOfTextApi()
{
  qDebug() << "(SoundOfTextApi) Initialization ...";

  // Init network manager to Libre Translate API
  _network_manager = new QNetworkAccessManager(this);
  connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onSoundOfTextNetworkAnswer(QNetworkReply*)));
}

SoundOfTextApi::~SoundOfTextApi()
{

}

void SoundOfTextApi::sendTextToSpeechNetworkRequest(QString input_text, QString source_lang, QString source_lang_sufix)
{
//    QUrl serviceUrl = QUrl(_sound_of_text_url);

//    QUrlQuery query;
//    query.addQueryItem("q", input_text);        // the text to be translated
//    query.addQueryItem("source", source_lang);  // the language of the source text
//    query.addQueryItem("target", target_lang);  // the language we want to translate the input text

//    QByteArray postData;
//    postData = query.toString(QUrl::FullyEncoded).toUtf8();

//    QNetworkRequest networkRequest(serviceUrl);
//    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

//    _network_manager->post(networkRequest,postData);
}

void SoundOfTextApi::onSoundOfTextNetworkAnswer(QNetworkReply *reply)
{
//    // Read result
//    QByteArray result = reply->readAll();
//    qDebug() << "(SoundOfTextApi) Network reply: " << result;
//    //  (SoundOfTextApi) Network reply:  "[{\"code\":\"en\",\"name\":\"English\"},{\"code\":\"ar\",\"name\":\"Arabic\"},{\"code\":\"zh\",\"name\":\"Chinese\"},{\"code\":\"fr\",\"name\":\"French\"},{\"code\":\"de\",\"name\":\"German\"},{\"code\":\"it\",\"name\":\"Italian\"},{\"code\":\"pt\",\"name\":\"Portuguese\"},{\"code\":\"ru\",\"name\":\"Russian\"},{\"code\":\"es\",\"name\":\"Spanish\"}]\n"

//    // Parse to JSON and get translations
//    QJsonDocument document = QJsonDocument::fromJson(result);
//    QJsonObject object = document.object();
//    QJsonArray array = document.array();
//    qDebug() << "(SoundOfTextApi) Object: " << object.isEmpty();
//    qDebug() << "(SoundOfTextApi) Array: " << array.isEmpty();

//    // Check if it is a translation result or a languages list request
//    if(object.find("translatedText") != object.end())
//    {
//        qDebug() << "(SoundOfTextApi) Translation result:" << object["translatedText"].toString();

//        emit onTranslationResult(object["translatedText"].toString());
//    }
//    else
//    {
//        if(array.size() > 0)
//        {
//            QStringList tmp_lang_codes;
//            for(const auto value : array)
//            {
//                QJsonObject obj = value.toObject();
//                tmp_lang_codes.append(QString(obj["code"].toString()));
//                qDebug() << "(SoundOfTextApi) Lang Code: " << obj["code"].toString();
//            }

//            emit onLanguagesResult(tmp_lang_codes);
//        }
//        else
//        {
//            emit onErrorResult("LibreTranslate API answers with an unexpected reply");
//        }
//    }
}

void SoundOfTextApi::sendGetSoundNetworkRequest(QString sound_id)
{
    QUrl serviceUrl = QUrl(_sound_of_text_url + "/" + sound_id);

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

    _network_manager->get(networkRequest);
}
