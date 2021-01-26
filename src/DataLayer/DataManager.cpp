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

  // Init network manager to Google Translate API
  _network_manager = new QNetworkAccessManager(this);
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
