#include "DataManager.h"

/** *********************************
 *  DataManager Initizalization
 ** ********************************/

DataManager::DataManager()
{
    qDebug() << "(DataManager) Created ...";

    // App settings handler
    _settings = new Settings();

    // Init clipboard handler
    _clipboard = QApplication::clipboard();

    // Init sound player
    _sound_player = new QMediaPlayer();

    // Init avalilable translation engines
    QStringList translator_engines_list;
    translator_engines_list.append(GOOGLE_TRANSLATE_API_NAME);
    translator_engines_list.append(MY_MEMORY_TRANSLATE_API_NAME);
    translator_engines_list.append(LIBRE_TRANSLATE_API_NAME);
    setTranslatorEngines(translator_engines_list);
}

DataManager::~DataManager()
{

}

void DataManager::init()
{
    qDebug() << "(DataManager) Initialization ...";

    // Connect clipboard to this app
    connect(_clipboard, SIGNAL(dataChanged()), this, SLOT(onClipboardDataChanged()));
    connect(_clipboard, SIGNAL(selectionChanged()), this, SLOT(onClipboardSelectionChanged()));

    // Init one-shot timer and connect to this app
    _translate_timer = new QTimer();
    _translate_timer->setSingleShot(true);
    _translate_timer->setInterval(TRIGGER_TRANSLATION_DELAY);
    connect(_translate_timer, SIGNAL(timeout()), this, SLOT(translateTimerCallback()));

    // Init Google API and connect results to this app
    _translator_api_google = new GoogleTranslateApi();
    connect(_translator_api_google, SIGNAL(onTranslationResult(QString)), this, SLOT(onTranslationApiResult(QString)));
    connect(_translator_api_google, SIGNAL(onLanguagesResult(QStringList)), this, SLOT(onTranslationApiLanguagesResult(QStringList)));
    connect(_translator_api_google, SIGNAL(onErrorResult(QString)), this, SLOT(onTranslationApiError(QString)));

    // Init MyMemory API and connect results to this app
    _translator_api_mymemory = new MyMemoryTranslateApi(true); // arg: enable use the local language list
    connect(_translator_api_mymemory, SIGNAL(onTranslationResult(QString)), this, SLOT(onTranslationApiResult(QString)));
    connect(_translator_api_mymemory, SIGNAL(onLanguagesResult(QStringList)), this, SLOT(onTranslationApiLanguagesResult(QStringList)));
    connect(_translator_api_mymemory, SIGNAL(onErrorResult(QString)), this, SLOT(onTranslationApiError(QString)));
    connect(_translator_api_mymemory, SIGNAL(onTranslationResultInfo(MyMemoryResultInfo)), this, SLOT(onMyMemoryTranslationResultInfo(MyMemoryResultInfo)));

    // Init LibreTranslate API and connect results to this app
    _translator_api_libre = new LibreTranslateApi();
    connect(_translator_api_libre, SIGNAL(onTranslationResult(QString)), this, SLOT(onTranslationApiResult(QString)));
    connect(_translator_api_libre, SIGNAL(onLanguagesResult(QStringList)), this, SLOT(onTranslationApiLanguagesResult(QStringList)));
    connect(_translator_api_libre, SIGNAL(onErrorResult(QString)), this, SLOT(onTranslationApiError(QString)));

    // Init TTS SoundOfText API and connect the audio file result to play it
    _tts_api_soundoftext = new SoundOfTextApi();
    connect(_tts_api_soundoftext, SIGNAL(textToSpeechResult(QString)), this, SLOT(onTextToSpeechResult(QString)));

    // Init settings and connect to this app
    connect(_settings, SIGNAL(translatorEngineChanged()), this, SLOT(onTranslatorEngineChanged()));
    connect(_settings, SIGNAL(sourceLangChanged()), this, SLOT(onSourceLangChanged()));
    connect(_settings, SIGNAL(targetLangChanged()), this, SLOT(onTargetLangChanged()));
    _settings->init();

    // Update available languages
    updateAvailableLanguageCode(_settings->translatorEngine());
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

    if(_input_text != "")
        _translate_timer->start();
}

void DataManager::setOutputText(QString output_text)
{
    qDebug() << "(DataManager) Output Text: " << output_text;

    _output_text = output_text;
    emit outputTextChanged();
}

void DataManager::setTtsAvailableForSourceLang(bool enable)
{
    _tts_available_for_source_lang = enable;
    emit ttsAvailableForSourceLangChanged();
}

void DataManager::setTtsAvailableForTargetLang(bool enable)
{
    _tts_available_for_target_lang = enable;
    emit ttsAvailableForTargetLangChanged();
}

/** *********************************
 *  QML Invokable functions
 ** ********************************/
void DataManager::updateAvailableLanguageCode(QString translator_engine)
{
    // Clear Language Codes
    _language_codes.setStringList(QStringList{});
    _language_names_and_codes.setStringList(QStringList{});

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
    else if(translator_engine == LIBRE_TRANSLATE_API_NAME)
    {
        qDebug() << "(DataManager) Available languages using LibreTranslate API...";
        _translator_api_libre->sendLanguagesNetworkRequest();
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
   if(code != "" && _settings->sourceLang() != code)
   {
       _settings->setSourceLang(code);
   }
}

void DataManager::setTargetLanguage(QString target_lang)
{
    qDebug() << "(DataManager) Setting target Language: " << target_lang;

    QString code = extractLanguageCode(target_lang);
    if(code != "" && _settings->targetLang() != code)
    {
        _settings->setTargetLang(code);
    }
}

void DataManager::interchangeSourceAndTargetLanguages()
{
    QString tmp_source_lang = _settings->sourceLang();
    QString tmp_target_lang = _settings->targetLang();
    _settings->setSourceLang(tmp_target_lang);
    _settings->setTargetLang(tmp_source_lang);
}

void DataManager::hearInputText(QString tts_code)
{
    //setTTSRequest(_input_text, _settings->sourceLang());
    setTTSRequest(_input_text, tts_code);
}

void DataManager::hearOutputText(QString tts_code)
{
    //setTTSRequest(_output_text, _settings->targetLang());
    setTTSRequest(_output_text, tts_code);
}

/** *********************************
 *  Slots
 ** ********************************/
void DataManager::onTranslatorEngineChanged()
{
    qDebug() << "(DataManager) Translation Engine changed: " << _settings->translatorEngine();

    // Show extra info pannel only for MyMemory engine
    if(_settings->translatorEngine() == MY_MEMORY_TRANSLATE_API_NAME)
    {
        _translation_extra_info_visible = true;
    }
    else
    {
        _translation_extra_info_visible = false;
    }

    translationExtraInfoVisibleChanged();
}

void DataManager::onSourceLangChanged()
{
    // Update TTS Available Flag
    if(_tts_api_soundoftext->checkValidLang(_settings->sourceLang()))
    {
        setTtsAvailableForSourceLang(true);
        _tts_source_language_codes.setStringList(_tts_api_soundoftext->getAllValidLandCodes(_settings->sourceLang()));
        emit ttsSourceLanguageCodesChanged();
        qDebug() << "(DataManager) Current TTS valid source language codes: " << _tts_source_language_codes.stringList();
    }
    else
    {
        setTtsAvailableForSourceLang(false);
        _tts_source_language_codes.setStringList(QStringList{});
        emit ttsSourceLanguageCodesChanged();
    }

    // Clean translation
    setInputText("");
}

void DataManager::onTargetLangChanged()
{
    // Update TTS Available Flag
    if(_tts_api_soundoftext->checkValidLang(_settings->targetLang()))
    {
        setTtsAvailableForTargetLang(true);
        _tts_target_language_codes.setStringList(_tts_api_soundoftext->getAllValidLandCodes(_settings->targetLang()));
        emit ttsTargetLanguageCodesChanged();
        qDebug() << "(DataManager) Current TTS valid target language codes: " << _tts_target_language_codes.stringList();
    }
    else
    {
        setTtsAvailableForTargetLang(false);
        _tts_target_language_codes.setStringList(QStringList{});
        emit ttsTargetLanguageCodesChanged();
    }

    // Update translation
    setInputText(_input_text);
}

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
         _translator_api_mymemory->sendTranslationNetworkRequest(_input_text, _settings->sourceLang(), _settings->targetLang(), _settings->email());
     }
     else if(_settings->translatorEngine() == LIBRE_TRANSLATE_API_NAME)
     {
         qDebug() << "(DataManager) Translation using Libre API...";
         _translator_api_libre->sendTranslationNetworkRequest(_input_text, _settings->sourceLang(), _settings->targetLang());
     }
}

void DataManager::onTranslationApiResult(QString result)
{
    setOutputText(result);
}

void DataManager::onTranslationApiLanguagesResult(QStringList result)
{
    qDebug() << "(DataManager) Updating languages";
    setLanguageCodes(result);
    setLanguageNamesAndCodes(result);

    // Force refresh source and target language
    _settings->sourceLangChanged();
    _settings->targetLangChanged();
}

void DataManager::onTranslationApiError(QString error)
{
    setOutputText(QString(TRANSLATION_ERROR_MSG) + ": " + error);
}

void DataManager::onMyMemoryTranslationResultInfo(MyMemoryResultInfo info)
{
    qDebug() << "(DataManager) MyMemory result Info received";
    _translation_extra_info.setResult(QString(info.result.c_str()));
    _translation_extra_info.setConfidence(info.confidence);
    _translation_extra_info.setQuotaFinished(info.quota_finished);
    QStringList matches_sources, matches_translations, matches_confidences;
    for(const auto match : info.matches)
    {
        matches_sources.push_back(QString(match.source_text.c_str()));
        matches_translations.push_back(QString(match.translated_text.c_str()));
        std::ostringstream out;
        out.precision(2);
        out << std::fixed << match.confidence;
        matches_confidences.push_back(QString(out.str().c_str()));
    }
    _translation_extra_info.setMatchesSources(matches_sources);
    _translation_extra_info.setMatchesTranslations(matches_translations);
    _translation_extra_info.setMatchesConfidences(matches_confidences);

    emit translationExtraInfoChanged();
}

void DataManager::onTextToSpeechResult(QString file_path)
{
    qDebug() << "(DataManager) Playing " << file_path;

    // Play audio file
    //Test on Ubuntu: system(("ffplay " + file_path.toStdString()).c_str());
    _sound_player->setMedia(QUrl::fromLocalFile(file_path));
    _sound_player->play();
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

void DataManager::setTTSRequest(QString text, QString lang)
{
    qDebug() << "(DataManager) Setting TTS request for: " << text << " [" << lang << "]";

    //QString tts_lang_code = _tts_api_soundoftext->getFirstValidLangCode(lang);
    //if(tts_lang_code != "")
    //    _tts_api_soundoftext->sendTextToSpeechNetworkRequest(text, tts_lang_code);

    _tts_api_soundoftext->sendTextToSpeechNetworkRequest(text, lang);
}
