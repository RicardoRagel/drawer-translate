#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QDir>
#include <QTimer>
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

  // Timer callback to trigger the translateText()
  void translateTimerCallback();

  // Receive QNetworkAccessManager replies
  void onNetworkAnswerReceived(QNetworkReply* reply);

private:

  // Variables
  Settings *_settings;                      // App Settings from .ini file
  QString _input_text;                      // User input text to be translated
  QStringList _translations;                // List of translated text results
  QString _output_text;                     // Translated text to be shown
  QClipboard *_clipboard;                   // System clipboard handler
  QNetworkAccessManager *_network_manager;  // System network handler to post request to the online translator
  QTimer *_translate_timer;                 // Timer to post the translation

  // Functions
  void sendTranslationNetworkRequest(QString input_text);   // Send the text to the Network translation API. It answer will be received by onNetworkAnswerReceived()
};

#endif // DATAMANAGER_H
