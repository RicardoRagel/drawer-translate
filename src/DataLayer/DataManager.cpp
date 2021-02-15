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
  setFramelessWinOnStartup(_settings->framelessWin());

  // Init clipboard handler
  _clipboard = QApplication::clipboard();

  // Connect clipboard to this app
  connect(_clipboard, SIGNAL(dataChanged()), this, SLOT(onClipboardDataChanged()));
  connect(_clipboard, SIGNAL(selectionChanged()), this, SLOT(onClipboardSelectionChanged()));

  // Init one-shot timer and connect to this app
  _translate_timer = new QTimer();
  _translate_timer->setSingleShot(true);
  _translate_timer->setInterval(TRIGGER_TRANSLATION_DELAY);
  connect(_translate_timer, SIGNAL(timeout()), this, SLOT(translateTimerCallback()));

  // Init available translation engines
  QStringList translator_engines_list;
  translator_engines_list.append(GOOGLE_TRANSLATE_API_NAME);
  translator_engines_list.append(MY_MEMORY_TRANSLATE_API_NAME);
  setTranslatorEngines(translator_engines_list);

  // Init Google API and connect results to this app
  _translator_api_google = new GoogleTranslatorApi();
  connect(_translator_api_google, SIGNAL(onTranslationResult(QString)), this, SLOT(onTranslationApiResult(QString)));
  connect(_translator_api_google, SIGNAL(onLanguagesResult(QStringList)), this, SLOT(onTranslationApiLanguagesResult(QStringList)));
  connect(_translator_api_google, SIGNAL(onErrorResult(QString)), this, SLOT(onTranslationApiError(QString)));

  // Init MyMemory API and connect results to this app
  _translator_api_mymemory = new MyMemoryTranslatorApi();
  connect(_translator_api_mymemory, SIGNAL(onTranslationResult(QString)), this, SLOT(onTranslationApiResult(QString)));
  connect(_translator_api_mymemory, SIGNAL(onLanguagesResult(QStringList)), this, SLOT(onTranslationApiLanguagesResult(QStringList)));
  connect(_translator_api_mymemory, SIGNAL(onErrorResult(QString)), this, SLOT(onTranslationApiError(QString)));

  // Update available languages
  updateAvailableLanguageCode(_settings->translatorEngine());
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

void DataManager::setFramelessWinOnStartup(bool frameless_win_on_startup)
{
    _frameless_win_on_startup = frameless_win_on_startup;
    emit framelessWinOnStartupChanged();
}

void DataManager::setInputText(QString input_text)
{
    qDebug() << "(DataManager) Input Text: " << input_text;

    _input_text = input_text;
    emit inputTextChanged();

    _translate_timer->stop();

    if(_input_text != "")
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
void DataManager::updateAvailableLanguageCode(QString translator_engine)
{
    // Trigger network available language request for the selected engine
    if(translator_engine == GOOGLE_TRANSLATE_API_NAME)
    {
        qDebug() << "(DataManager) Available languages using Google API...";
        _translator_api_google->sendLanguagesNetworkRequest(_settings->googleApiKey());
    }
    else if(translator_engine == MY_MEMORY_TRANSLATE_API_NAME)
    {
        qDebug() << "(DataManager) Available languages using MyMemory API...";
        _translator_api_mymemory->sendLanguagesNetworkRequest();
    }
    else
    {
        // In case the translator engine has not provide an available language
        // request, set the default list
        setLanguageCodes(Settings::default_language_list);
        setLanguageNamesAndCodes(Settings::default_language_list);
    }
}

void DataManager::setSourceLanguage(QString source_lang)
{
    qDebug() << "(DataManager) Setting source Language: " << source_lang;

   QString code = extractLanguageCode(source_lang);
   if(code != "")
       _settings->setSourceLang(code);
}

void DataManager::setTargetLanguage(QString target_lang)
{
    qDebug() << "(DataManager) Setting target Language: " << target_lang;

    QString code = extractLanguageCode(target_lang);
    if(code != "")
        _settings->setTargetLang(code);
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

     if(_settings->translatorEngine() == GOOGLE_TRANSLATE_API_NAME)
     {
         qDebug() << "(DataManager) Translation using Google API...";
         _translator_api_google->sendTranslationNetworkRequest(_input_text, _settings->googleApiKey(), _settings->sourceLang(), _settings->targetLang());
     }
     else if(_settings->translatorEngine() == MY_MEMORY_TRANSLATE_API_NAME)
     {
         qDebug() << "(DataManager) Translation using MyMemory API...";
         _translator_api_mymemory->sendTranslationNetworkRequest(_input_text, "", _settings->sourceLang(), _settings->targetLang());
     }
}

void DataManager::onTranslationApiResult(QString result)
{
    setOutputText(result);
}

void DataManager::onTranslationApiLanguagesResult(QStringList result)
{
    setLanguageCodes(result);
    setLanguageNamesAndCodes(result);
}

void DataManager::onTranslationApiError(QString error)
{
    setOutputText(QString(TRANSLATION_ERROR_MSG) + ": " + error);
}

/** *********************************
 *  Auxiliar function
 ** ********************************/
void DataManager::setLanguageCodes(QStringList language_codes)
{
    _language_codes.setStringList(language_codes);
    emit languageCodesChanged();
}

void DataManager::setLanguageNamesAndCodes(QStringList language_codes)
{
    // Get names by codes and generate "Names [codes]" list
    QStringList language_names_and_codes;
    for(QString code : language_codes)
    {
        QString name = QString(LanguageISOCodes::getLanguageName(code.toStdString()).c_str());
        language_names_and_codes.append(name + " [" + code + "]");
    }

    // Order it alphabetically
    language_names_and_codes.sort();

    // Set to the model var
    _language_names_and_codes.setStringList(language_names_and_codes);
    emit languageNamesAndCodesChanged();
}

QString DataManager::extractLanguageCode(QString language_name_and_code)
{
    QString code = "";

    // Extract code from "Name [Code]" strings
    QStringList split1 = language_name_and_code.split("[");
    if(split1.size() > 1)
    {
        QStringList split2 = split1[1].split("]");
        if(split2.size() > 0)
        {
            code = split2[0];
        }
    }
    qDebug() << "(DataManager) Extracted code: " << code;

    return code;
}

void DataManager::setTranslatorEngines(QStringList translator_engines)
{
    _translator_engines.setStringList(translator_engines);
    emit translatorEnginesChanged();
}
