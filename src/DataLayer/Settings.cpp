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
