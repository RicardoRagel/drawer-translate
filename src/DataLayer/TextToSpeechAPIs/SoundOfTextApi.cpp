#include "TextToSpeechAPIs/SoundOfTextApi.h"

SoundOfTextApi::SoundOfTextApi()
{
    qDebug() << "(SoundOfTextApi) Initialization ...";

    // Initialize SoundOfText available language codes and names
    initAvailableLanguages();

    // Init network manager to Libre Translate API
    _network_manager = new QNetworkAccessManager(this);
    connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onSoundOfTextNetworkAnswer(QNetworkReply*)));
}

SoundOfTextApi::~SoundOfTextApi()
{

}

QString SoundOfTextApi::getFirstValidLangCode(QString code)
{
    QString valid_lang = "";

    map<string,string>::iterator it = _lang_map.lower_bound(code.toStdString());
    if(it != _lang_map.end())
        valid_lang = QString(it->first.c_str());

    return valid_lang;
}

void SoundOfTextApi::sendTextToSpeechNetworkRequest(QString input_text, QString source_lang)
{
    qDebug() << "(SoundOfTextApi) Requesting Speech of " << input_text << ", [" << source_lang << "]";

    QUrl serviceUrl = QUrl(_sound_of_text_url);

    QJsonObject obj;
    obj["engine"] = "Google";
    QJsonObject sub_obj;
    sub_obj["text"] = input_text;
    sub_obj["voice"] = source_lang;
    obj["data"] = sub_obj;
    QJsonDocument doc(obj);
    qDebug() << doc;

    QByteArray postData  = doc.toJson();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

    _network_manager->post(networkRequest,postData);
}

void SoundOfTextApi::onSoundOfTextNetworkAnswer(QNetworkReply *reply)
{
    // Read result
    QByteArray result = reply->readAll();
    qDebug() << "(SoundOfTextApi) Network reply: " << result;
    // (SoundOfTextApi) Network reply:  "{\"success\":true,\"id\":\"b6796220-c585-11e7-9fd8-273ecc13011d\"}"
    // (SoundOfTextApi) Network reply:  "{\"status\":\"Pending\"}"

    // Parse to JSON and get translations
    QJsonDocument document = QJsonDocument::fromJson(result);
    QJsonObject object = document.object();

    // Check if it is a sendTextToSpeechNetworkRequest() result
    if(object.find("success") != object.end())
    {
        if(object["success"].toBool())
        {
            if(object.find("id") != object.end())
            {
                _last_sound_id = object["id"].toString();
                sendGetSoundNetworkRequest(_last_sound_id);
            }
        }
        else
        {
            onErrorResult("Sound of Text API replied with error");
            return;
        }
    }

    if(object.find("status") != object.end())
    {
        if(object["status"].toString() == "Pending")
        {
            sendGetSoundNetworkRequest(_last_sound_id);
        }
        if(object["status"].toString() == "Done")
        {
            if(object.find("location") != object.end())
            {
                downloadSoundFile(object["location"].toString());
            }
        }
    }

    qDebug() << "END";
}

void SoundOfTextApi::sendGetSoundNetworkRequest(QString sound_id)
{
    qDebug() << "(SoundOfTextApi) Trying to get location of sound " + sound_id;

    QUrl serviceUrl = QUrl(_sound_of_text_url + "/" + sound_id);

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

    _network_manager->get(networkRequest);
}

QString SoundOfTextApi::downloadSoundFile(QString sound_url)
{
    qDebug() << "(SoundOfTextApi) Downloading sound from " + sound_url;
    //TODO: https://www.bogotobogo.com/Qt/Qt5_Network_Http_Files_Download_Example.php

    QString file_path;

    return file_path;
}

void SoundOfTextApi::initAvailableLanguages()
{
    _lang_map =
    {
        {"af-ZA",   "Afrikaans"},
        {"sq",      "Albanian"},
        {"ar-AE",   "Arabic"},
        {"hy",      "Armenian"},
        {"bn-BD",   "Bengali (Bangladesh)"},
        {"bn-IN",   "Bengali (India)"},
        {"bs",      "Bosnian"},
        {"my",      "Burmese (Myanmar)"},
        {"ca-ES",   "Catalan"},
        {"cmn-Hant-TW",	"Chinese"},
        {"hr-HR",   "Croatian"},
        {"cs-CZ",   "Czech"},
        {"da-DK",   "Danish"},
        {"nl-NL",   "Dutch"},
        {"en-AU",   "English (Australia)"},
        {"en-GB",   "English (United Kingdom)"},
        {"en-US",   "English (United States)"},
        {"eo",      "Esperanto"},
        {"et",      "Estonian"},
        {"fil-PH",	"Filipino"},
        {"fi-FI",	"Finnish"},
        {"fr-FR",	"French"},
        {"fr-CA",	"French (Canada)"},
        {"de-DE",	"German"},
        {"el-GR",	"Greek"},
        {"gu",      "Gujarati"},
        {"hi-IN",	"Hindi"},
        {"hu-HU",	"Hungarian"},
        {"is-IS",	"Icelandic"},
        {"id-ID",	"Indonesian"},
        {"it-IT",	"Italian"},
        {"ja-JP",	"Japanese (Japan)"},
        {"kn",	    "Kannada"},
        {"km",	    "Khmer"},
        {"ko-KR",	"Korean"},
        {"la",      "Latin"},
        {"lv",      "Latvian"},
        {"mk",      "Macedonian"},
        {"ml",      "Malayalam"},
        {"mr",      "Marathi"},
        {"ne",      "Nepali"},
        {"nb-NO",	"Norwegian"},
        {"pl-PL",	"Polish"},
        {"pt-BR",	"Portuguese"},
        {"ro-RO",	"Romanian"},
        {"ru-RU",	"Russian"},
        {"sr-RS",	"Serbian"},
        {"si",      "Sinhala"},
        {"sk-SK",	"Slovak"},
        {"es-MX",	"Spanish (Mexico)"},
        {"es-ES",	"Spanish (Spain)"},
        {"sw",      "Swahili"},
        {"sv-SE",   "Swedish"},
        {"ta",      "Tamil"},
        {"te",      "Telugu"},
        {"th-TH",	"Thai"},
        {"tr-TR",	"Turkish"},
        {"uk-UA",	"Ukrainian"},
        {"ur",      "Urdu"},
        {"vi-VN",	"Vietnamese"},
        {"cy",      "Welsh"}
    };
}
