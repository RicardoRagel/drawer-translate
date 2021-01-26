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
#include "Settings.h"

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
  Q_PROPERTY(Settings* settings READ settings WRITE setSettings NOTIFY settingsChanged)
  Q_PROPERTY(QString inputText READ inputText WRITE setInputText NOTIFY inputTextChanged)
  Q_PROPERTY(QString outputText READ outputText WRITE setOutputText NOTIFY outputTextChanged)

  // QML properties getters
  Settings* settings() {return _settings;}
  QString inputText() {return _input_text;}
  QString outputText() {return _output_text;}

  // QML Invokable properties setters
  Q_INVOKABLE void setSettings(Settings* settings);
  Q_INVOKABLE void setInputText(QString input_text);
  Q_INVOKABLE void setOutputText(QString output_text);

signals:

  // QML properties signals
  void settingsChanged();
  void inputTextChanged();
  void outputTextChanged();

private slots:

  // Receive system clipboard changes
  void clipboardDataChanged();
  void clipboardSelectionChanged();

private:

  // Variables
  Settings *_settings;
  QString _input_text;
  QString _output_text;
  QClipboard *_clipboard;
  QNetworkAccessManager *_network_manager;

};

#endif // DATAMANAGER_H
