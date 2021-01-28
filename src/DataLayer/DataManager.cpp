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
  connect(_clipboard, SIGNAL(dataChanged()), this, SLOT(clipboardDataChanged()));
  connect(_clipboard, SIGNAL(selectionChanged()), this, SLOT(clipboardSelectionChanged()));

  // Init one-shot timer
  _translate_timer = new QTimer();
  _translate_timer->setSingleShot(true);
  _translate_timer->setInterval(TRIGGER_TRANSLATION_DELAY);
  connect(_translate_timer, SIGNAL(timeout()), this, SLOT(translateTimerCallback()));

  // Init network manager to Google Translate API
  _network_manager = new QNetworkAccessManager(this);
  connect(_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onNetworkAnswerReceived(QNetworkReply*)));
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
 *  Slots
 ** ********************************/
void DataManager::clipboardDataChanged()
{
    qDebug() << "(DataManager) Clipboard Data Changed: " << _clipboard->text();

    setInputText(_clipboard->text());
}

void DataManager::clipboardSelectionChanged()
{
    qDebug() << "(DataManager) Clipboard Selection Changed: " << _clipboard->text(QClipboard::Selection);

    // Set selection to input text only if text doesn't belong to this app
    if(!_clipboard->ownsSelection())
        setInputText(_clipboard->text(QClipboard::Selection));
}

void DataManager::translateTimerCallback()
{
     qDebug() << "(DataManager) Translation Timer callback";
    sendTranslationNetworkRequest(_input_text);
}

void DataManager::onNetworkAnswerReceived(QNetworkReply *reply)
{
    // Clear previous results
    _translations.clear();

    // Read result
    QByteArray result = reply->readAll();
    qDebug() << "(DataManager) Network reply: " << result;

    // Parse to JSON and get translations
    QJsonDocument document = QJsonDocument::fromJson(result);
    QJsonObject object = document.object();
    QJsonArray translations_array = object["data"].toObject()["translations"].toArray();
    for(const auto value : translations_array)
    {
        QJsonObject obj = value.toObject();
        _translations.append(obj["translatedText"].toString());
    }

    // Update output text with the last results
    if(_translations.size() > 0)
        setOutputText(_translations[0]);
    else
        setOutputText(TRANSLATION_ERROR_MSG);
}

/** *********************************
 *  Auxiliar function
 ** ********************************/
void DataManager::sendTranslationNetworkRequest(QString input_text)
{
    // Reference: https://cloud.google.com/translate/docs/reference/rest/v2/translate?hl=es
    QUrl serviceUrl = QUrl("https://translation.googleapis.com/language/translate/v2");

    QUrlQuery query;
    query.addQueryItem("q", input_text.toStdString().c_str());  // the text to be translated
    query.addQueryItem("source", _settings->sourceLang());      // The language of the source text
    query.addQueryItem("target", _settings->targetLang());      // the language to use for translation of the input text
    query.addQueryItem("format","text");                        // the format of the source text (html or text)
    query.addQueryItem("model","nmt");                          // the translation model (base or nmt)
    query.addQueryItem("key", _settings->apiKey());             // a valid API key to handle requests for this API

    QByteArray postData;
    postData = query.toString(QUrl::FullyEncoded).toUtf8();

    QNetworkRequest networkRequest(serviceUrl);
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _network_manager->post(networkRequest,postData);
}
