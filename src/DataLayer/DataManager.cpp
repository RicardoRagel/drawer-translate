#include "DataManager.h"

/** *********************************
 *  DataManager Initizalization
 ** ********************************/

DataManager::DataManager()
{

  qDebug() << "(DataManager) Initialization ...";

  // Init vars
  _clipboard = QApplication::clipboard();

  // Connect clipboard to this app
  connect(_clipboard, SIGNAL(dataChanged()), this, SLOT(clipboardDataChanged()));
  connect(_clipboard, SIGNAL(selectionChanged()), this, SLOT(clipboardSelectionChanged()));
}

DataManager::~DataManager()
{

}

/** *********************************
 *  QML Invokable properties setters
 ** ********************************/
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
    qDebug() << "(DataManager) Clipboard Selection Changed: " << _clipboard->text();

    setInputText(_clipboard->text());
}
