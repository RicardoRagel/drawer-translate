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

    if(!_settingsHandler->contains("Translator/apiKey"))
    {
        qDebug() << "(Settings) Initializing API Key to" << DEFAULT_API_KEY;
        setApiKey(DEFAULT_API_KEY);
    }
    else
    {
        setApiKey(_settingsHandler->value("Translator/apiKey").toString());
        qDebug() << "(Settings) API KEY:" << apiKey();
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

void Settings::setApiKey(QString api_key)
{
    _settingsHandler->setValue("Translator/apiKey", api_key);
    _api_key = api_key;
    emit apiKeyChanged();
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
