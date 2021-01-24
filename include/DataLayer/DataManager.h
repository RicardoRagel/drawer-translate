#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QDir>
#include <QClipboard>
#include <QApplication>
#include <QNetworkAccessManager>

#include "Constants.h"

using namespace std;

class DataManager : public QObject
{
  Q_OBJECT

public:

  // Constructor
  DataManager();

  // Destuctor
  ~DataManager();

  // QML properties declarations
  Q_PROPERTY(QString inputText READ inputText WRITE setInputText NOTIFY inputTextChanged)
  Q_PROPERTY(QString outputText READ outputText WRITE setOutputText NOTIFY outputTextChanged)

  // QML properties getters
  QString inputText() {return _input_text;}
  QString outputText() {return _output_text;}

  // QML Invokable properties setters
  Q_INVOKABLE void setInputText(QString input_text);
  Q_INVOKABLE void setOutputText(QString output_text);

signals:

  // QML properties signals
  void inputTextChanged();
  void outputTextChanged();

private slots:

  // Receive selection changes
  void clipboardDataChanged();
  void clipboardSelectionChanged();

private:

  // Variables
  QString _input_text;
  QString _output_text;
  QClipboard *_clipboard;
  QNetworkAccessManager *_network_manager;
};

#endif // DATAMANAGER_H
