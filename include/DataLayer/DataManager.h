#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QDir>
#include <QTimer>
#include <QClipboard>
#include <QApplication>

#include "Constants.h"
#include "Settings.h"
#include "LanguageISOCodes.h"
#include "TranslatorAPIs/GoogleTranslateApi.h"
#include "TranslatorAPIs/MyMemoryTranslateApi.h"
#include "TranslatorAPIs/LibreTranslateApi.h"
#include "TranslatorAPIs/TranslationExtraInfo.h"
#include "TextToSpeechAPIs/SoundOfTextApi.h"

#include <sstream>

using namespace std;

class DataManager : public QObject
{
  Q_OBJECT

public:

  // Constructor
  DataManager();

  // Destuctor
  ~DataManager();

  // Initialization (needed for things that must be done after QML is initialised)
  void init();

  // QML properties declarations
  Q_PROPERTY(Settings* settings READ settings WRITE setSettings NOTIFY settingsChanged)
  Q_PROPERTY(QString inputText READ inputText WRITE setInputText NOTIFY inputTextChanged)
  Q_PROPERTY(QString outputText READ outputText WRITE setOutputText NOTIFY outputTextChanged)
  Q_PROPERTY(QStringListModel* languageCodes READ languageCodes NOTIFY languageCodesChanged)
  Q_PROPERTY(QStringListModel* languageNamesAndCodes READ languageNamesAndCodes NOTIFY languageNamesAndCodesChanged)
  Q_PROPERTY(QStringListModel* translatorEngines READ translatorEngines NOTIFY translatorEnginesChanged)
  Q_PROPERTY(TranslationExtraInfo* translationExtraInfo READ translationExtraInfo NOTIFY translationExtraInfoChanged)
  Q_PROPERTY(bool translationExtraInfoVisible READ translationExtraInfoVisible NOTIFY translationExtraInfoVisibleChanged)

  // QML Invokable properties getters
  Settings* settings() {return _settings;}
  QString inputText() {return _input_text;}
  QString outputText() {return _output_text;}
  QStringListModel* languageCodes() {return &_language_codes;}
  QStringListModel* languageNamesAndCodes() {return &_language_names_and_codes;}
  QStringListModel* translatorEngines() {return &_translator_engines;}
  TranslationExtraInfo* translationExtraInfo() {return &_translation_extra_info;}
  bool translationExtraInfoVisible() {return _translation_extra_info_visible;}

  // QML Invokable properties setters
  Q_INVOKABLE void setSettings(Settings* settings);
  Q_INVOKABLE void setInputText(QString input_text);
  Q_INVOKABLE void setOutputText(QString output_text);

  // QML Invokable functions
  Q_INVOKABLE void updateAvailableLanguageCode(QString translator_engine);
  Q_INVOKABLE void setSourceLanguage(QString source_lang);
  Q_INVOKABLE void setTargetLanguage(QString target_lang);
  Q_INVOKABLE void interchangeSourceAndTargetLanguages();
  Q_INVOKABLE void hearInputText();
  Q_INVOKABLE void hearOutputText();

signals:

  // QML properties signals
  void settingsChanged();
  void inputTextChanged();
  void outputTextChanged();
  void languageCodesChanged();
  void languageNamesAndCodesChanged();
  void translatorEnginesChanged();
  void translationExtraInfoChanged();
  void translationExtraInfoVisibleChanged();

private slots:

  // Receive settings changes
  void onTranslatorEngineChanged();

  // Receive system clipboard changes
  void onClipboardDataChanged();
  void onClipboardSelectionChanged();

  // Timer callback to trigger the translateText()
  void translateTimerCallback();

  // Receive Translator APIs Results
  void onTranslationApiResult(QString result);
  void onTranslationApiLanguagesResult(QStringList result);
  void onTranslationApiError(QString error);

  // Special slot for MyMemory results info
  void onMyMemoryTranslationResultInfo(MyMemoryResultInfo info);

private:

  // Variables
  Settings *_settings;                              // App Settings from .ini file
  QString _input_text;                              // User input text to be translated
  QString _output_text;                             // Translated text to be shown
  QClipboard *_clipboard;                           // System clipboard handler
  QTimer *_translate_timer;                         // Timer to post the translation
  QStringListModel _language_codes;                 // List of available language codes
  QStringListModel _language_names_and_codes;       // List of available language names and codes as "<NAME> [<CODE>]"
  QStringListModel _translator_engines;             // List of available translator engines

  GoogleTranslateApi *_translator_api_google;       // Google Translator API Handler
  MyMemoryTranslateApi *_translator_api_mymemory;   // MyMemory Translator API Handler
  LibreTranslateApi *_translator_api_libre;         // Libre Translator API Handler

  TranslationExtraInfo _translation_extra_info;     // Extra info about the translation result
  bool _translation_extra_info_visible;             // Set true to show the Extra info pannel

  SoundOfTextApi *_tts_api_soundoftext;             // Sound of text TTS API Handler

  // Functions
  void setLanguageCodes(QStringList language_codes);            // Set the available language codes
  void setLanguageNamesAndCodes(QStringList language_codes);    // Set the available language codes and names
  QString extractLanguageCode(QString language_name_and_code);  // Extract the language code from a human-readable string "Name [code]"
  void setTranslatorEngines(QStringList translator_engines);    // Set the available translator engines list
  void setTTSRequest(QString text, QString lang);               // Set new request to the Text-to-speech engine
};

#endif // DATAMANAGER_H
