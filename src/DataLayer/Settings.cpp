#include "Settings.h"

/** *********************************
 *  DataManager Initizalization
 ** ********************************/

Settings::Settings()
{
    qDebug() << "(Settings) Creating new object ...";
}

Settings::~Settings()
{

}

void Settings::init()
{
    _settingsHandler = new QSettings(QSettings::IniFormat, QSettings::UserScope, "TranslatorMinimalApp", "TranslatorApp");
    qDebug() << "(Settings) Initialization of settings to/from " << _settingsHandler->fileName();

    // Initialize QSettings to the current values or to defaults if they don't exist yet
    if(!_settingsHandler->contains("Window/frameLess"))
    {
        qDebug() << "(Settings) Initializing FrameLess Window to" << DEFAULT_FRAMELESS_WIN;
        setFramelessWin(DEFAULT_FRAMELESS_WIN);
    }
    else
    {
        setFramelessWin(_settingsHandler->value("Window/frameLess").toBool());
        qDebug() << "(Settings) FrameLess Window:" << framelessWin();
    }

    if(!_settingsHandler->contains("Window/autoHide"))
    {
        qDebug() << "(Settings) Initializing AutoHide Window to" << DEFAULT_AUTOHIDE_WIN;
        setAutoHideWin(DEFAULT_AUTOHIDE_WIN);
    }
    else
    {
        setAutoHideWin(_settingsHandler->value("Window/autoHide").toBool());
        qDebug() << "(Settings) AutoHide Window:" << autoHideWin();
    }

    if(!_settingsHandler->contains("Input/translateOnSelection"))
    {
        qDebug() << "(Settings) Initializing Translate on Selection to" << DEFAULT_TRANSLATE_ON_SELECTION;
        setTranslateOnSelection(DEFAULT_TRANSLATE_ON_SELECTION);
    }
    else
    {
        setTranslateOnSelection(_settingsHandler->value("Input/translateOnSelection").toBool());
        qDebug() << "(Settings) Translate on Selection:" << translateOnSelection();
    }

    if(!_settingsHandler->contains("Input/translateOnCopy"))
    {
        qDebug() << "(Settings) Initializing Translate on Copy to" << DEFAULT_TRANSLATE_ON_COPY;
        setTranslateOnCopy(DEFAULT_TRANSLATE_ON_COPY);
    }
    else
    {
        setTranslateOnCopy(_settingsHandler->value("Input/translateOnCopy").toBool());
        qDebug() << "(Settings) Translate on Copy:" << translateOnCopy();
    }

    if(!_settingsHandler->contains("Translator/engine"))
    {
        qDebug() << "(Settings) Initializing Translator Engine to" << DEFAULT_TRANSLATOR_ENGINE;
        setTranslatorEngine(DEFAULT_TRANSLATOR_ENGINE);
    }
    else
    {
        setTranslatorEngine(_settingsHandler->value("Translator/engine").toString());
        qDebug() << "(Settings) Translator Engine:" << translatorEngine();
    }

    if(!_settingsHandler->contains("Translator/googleApiKey"))
    {
        qDebug() << "(Settings) Initializing API Key to" << DEFAULT_GOOGLE_API_KEY;
        setGoogleApiKey(DEFAULT_GOOGLE_API_KEY);
    }
    else
    {
        setGoogleApiKey(_settingsHandler->value("Translator/googleApiKey").toString());
        qDebug() << "(Settings) API Key:" << googleApiKey();
    }

    if(!_settingsHandler->contains("Translator/sourceLang"))
    {
        qDebug() << "(Settings) Initializing Source Language to" << DEFAULT_SOURCE_LANG;
        setSourceLang(DEFAULT_SOURCE_LANG);
    }
    else
    {
        setSourceLang(_settingsHandler->value("Translator/sourceLang").toString());
        qDebug() << "(Settings) Source Lang:" << sourceLang();
    }

    if(!_settingsHandler->contains("Translator/targetLang"))
    {
        qDebug() << "(Settings) Initializing Target Language to" << DEFAULT_TARGET_LANG;
        setTargetLang(DEFAULT_TARGET_LANG);
    }
    else
    {
        setTargetLang(_settingsHandler->value("Translator/targetLang").toString());
        qDebug() << "(Settings) Target Lang:" << targetLang();
    }
}

/** *********************************
 *  QML Invokable properties setters
 ** ********************************/
void Settings::setFramelessWin(bool frameless_win)
{
    _settingsHandler->setValue("Window/frameLess", frameless_win);
    _frameless_win = frameless_win;
    emit framelessWinChanged();
}

void Settings::setAutoHideWin(bool autohide_win)
{
    _settingsHandler->setValue("Window/autoHide", autohide_win);
    _autohide_win = autohide_win;
    emit autoHideWinChanged();
}

void Settings::setTranslateOnSelection(bool translate_on_selection)
{
    _settingsHandler->setValue("Input/translateOnSelection", translate_on_selection);
    _translate_on_selection = translate_on_selection;
    emit translateOnSelectionChanged();
}

void Settings::setTranslateOnCopy(bool translate_on_copy)
{
    _settingsHandler->setValue("Input/translateOnCopy", translate_on_copy);
    _translate_on_copy = translate_on_copy;
    emit translateOnCopyChanged();
}

void Settings::setTranslatorEngine(QString translator_engine)
{
    _settingsHandler->setValue("Translator/engine", translator_engine);
    _translator_engine = translator_engine;
    emit translatorEngineChanged();
}

void Settings::setGoogleApiKey(QString api_key)
{
    _settingsHandler->setValue("Translator/googleApiKey", api_key);
    _google_api_key = api_key;
    emit googleApiKeyChanged();
}

void Settings::setSourceLang(QString source_lang)
{
    _settingsHandler->setValue("Translator/sourceLang", source_lang);
    _source_lang = source_lang;
    emit sourceLangChanged();
}

void Settings::setTargetLang(QString target_lang)
{
    _settingsHandler->setValue("Translator/targetLang", target_lang);
    _target_lang = target_lang;
    emit targetLangChanged();
}

/** *********************************
 *  Static and constant Settings
 ** ********************************/
QStringList Settings::default_language_list = {"en", "es", "fr", "it", "jp", "de"};
