#include "DataManager.h"

/** *********************************
 *  DataManager Initizalization
 ** ********************************/

DataManager::DataManager()
{
  qDebug() << "(DataManager) Initialization ...";

  // Init settings
  _settings = new Settings();
  _settings->init();

  // Init clipboard handler
  _clipboard = QApplication::clipboard();

  // Connect clipboard to this app
  connect(_clipboard, SIGNAL(dataChanged()), this, SLOT(onClipboardDataChanged()));
  connect(_clipboard, SIGNAL(selectionChanged()), this, SLOT(onClipboardSelectionChanged()));

  // Init one-shot timer
  _translate_timer = new QTimer();
  _translate_timer->setSingleShot(true);
  _translate_timer->setInterval(TRIGGER_TRANSLATION_DELAY);
  connect(_translate_timer, SIGNAL(timeout()), this, SLOT(translateTimerCallback()));

  // Init network manager to Google Translate API
  _network_manager = new QNetworkAccessManager(this);
  connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onTranslationNetworkAnswer(QNetworkReply*)));

  ///TODO: Check if it is actually necessary or it is enough calling it from QML
  // Update available languages
  updateAvailableLanguageCode();
}

DataManager::~DataManager()
{

}

/** *********************************
 *  QML Invokable properties setters
 ** ********************************/
void DataManager::setSettings(Settings *settings)
{
    _settings = settings;
}

void DataManager::setInputText(QString input_text)
{
    qDebug() << "(DataManager) Input Text: " << input_text;

    _input_text = input_text;
    emit inputTextChanged();

    _translate_timer->stop();
    _translate_timer->start();
}

void DataManager::setOutputText(QString output_text)
{
    qDebug() << "(DataManager) Output Text: " << output_text;

    _output_text = output_text;
    emit outputTextChanged();
}

/** *********************************
 *  QML Invokable functions
 ** ********************************/

void DataManager::updateAvailableLanguageCode()
{
    // Trigger network available language request
    sendLanguagesNetworkRequest();
}

/** *********************************
 *  Slots
 ** ********************************/
void DataManager::onClipboardDataChanged()
{
    qDebug() << "(DataManager) Clipboard Data Changed: " << _clipboard->text();

    // Set selection to input text only if translate on copy is enabled
    if(_settings->translateOnCopy())
        setInputText(_clipboard->text());
}

void DataManager::onClipboardSelectionChanged()
{
    qDebug() << "(DataManager) Clipboard Selection Changed: " << _clipboard->text(QClipboard::Selection);

    // Set selection to input text only if text doesn't belong to this app and translate on selection is enabled
    if(_settings->translateOnSelection() && !_clipboard->ownsSelection())
        setInputText(_clipboard->text(QClipboard::Selection));
}

void DataManager::translateTimerCallback()
{
     qDebug() << "(DataManager) Translation Timer callback";

     sendTranslationNetworkRequest(_input_text);
}

void DataManager::onTranslationNetworkAnswer(QNetworkReply *reply)
{
    // Clear previous results
    _translations.clear();

    // Read result
    QByteArray result = reply->readAll();
    //qDebug() << "(DataManager) Network reply: " << result;
    // (DataManager) Network reply:  "{\n  \"data\": {\n    \"translations\": [\n      {\n        \"translatedText\": \"Hola\",\n        \"model\": \"nmt\"\n      }\n    ]\n  }\n}\n"
    // (DataManager) Network reply:  "{\n  \"data\": {\n    \"languages\": [\n      {\n        \"language\": \"af\"\n      },\n      {\n        \"language\": \"am\"\n      },\n      {\n        \"language\": \"ar\"\n      },\n      {\n        \"language\": \"az\"\n      },\n      {\n        \"language\": \"be\"\n      },\n      {\n        \"language\": \"bg\"\n      },\n      {\n        \"language\": \"bn\"\n

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
            _translations.append(obj["translatedText"].toString());
        }
        qDebug() << "(DataManager) Translation result:" << _translations[0];
        setOutputText(_translations[0]);
    }
    else if(data.find("languages") != data.end())
    {
        QJsonArray languages_array = data["languages"].toArray();
        QStringList tmp_lang_codes;
        for(const auto value : languages_array)
        {
            QJsonObject obj = value.toObject();
            tmp_lang_codes.append(QString(obj["language"].toString()));
            //qDebug() << "(DataManager) Lang Code: " << obj["language"].toString();
        }

        // Update to QML access
        setLanguageCodes(tmp_lang_codes);
        setLanguageNamesAndCodes(tmp_lang_codes);
    }
    else
    {
        setOutputText(TRANSLATION_ERROR_MSG);
    }
}

/** *********************************
 *  Auxiliar function
 ** ********************************/
void DataManager::sendTranslationNetworkRequest(QString input_text)
{
    // Reference: https://cloud.google.com/translate/docs/reference/rest/v2/translate
    QUrl serviceUrl = QUrl("https://translation.googleapis.com/language/translate/v2");

    QUrlQuery query;
    query.addQueryItem("q", input_text.toStdString().c_str());  // the text to be translated
    query.addQueryItem("source", _settings->sourceLang());      // the language of the source text
    query.addQueryItem("target", _settings->targetLang());      // the language we want to translate the input text
    query.addQueryItem("format","text");                        // the format of the source text (html or text)
    query.addQueryItem("model","nmt");                          // the translation model (base or nmt)
    query.addQueryItem("key", _settings->apiKey());             // a valid API key to handle requests for this API

    QByteArray postData;
    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(networkRequest,postData);
}

void DataManager::sendLanguagesNetworkRequest(QString target)
{
    // Reference: https://cloud.google.com/translate/docs/reference/rest/v2/languages
    QUrl serviceUrl = QUrl("https://translation.googleapis.com/language/translate/v2/languages");

    QUrlQuery query;
    query.addQueryItem("target", target);                           // the language we want to translate the input text
    query.addQueryItem("model","nmt");                          // the translation model (base or nmt)
    query.addQueryItem("key", _settings->apiKey());             // a valid API key to handle requests for this API

    QByteArray postData;
    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(networkRequest,postData);
}

void DataManager::setLanguageCodes(QStringList language_codes)
{
    _language_codes.setStringList(language_codes);
    emit languageCodesChanged();
}

void DataManager::setLanguageNamesAndCodes(QStringList language_codes)
{
    QStringList language_names_and_codes;
    for(QString code : language_codes)
    {
        QString name = QString(LanguageISOCodes::getLanguageName(code.toStdString()).c_str());
        language_names_and_codes.append(name + " [" + code + "]");
    }

    _language_names_and_codes.setStringList(language_names_and_codes);
    emit languageNamesAndCodesChanged();
}
