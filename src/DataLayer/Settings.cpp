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
    _settingsHandler = new QSettings(QSettings::IniFormat, QSettings::UserScope, "DrawerTranslate", "DrawerTranslate");
    qDebug() << "(Settings) Initialization of settings to/from " << _settingsHandler->fileName();


    // Welcome window visible
    if(!_settingsHandler->contains("WelcomeWin/visible"))
    {
        qDebug() << "(Settings) Initializing Welcome Window visible to" << DEFAULT_WELCOME_WIN_VISIBLE;
        setWelcomeWinVisible(DEFAULT_WELCOME_WIN_VISIBLE);
    }
    else
    {
        setWelcomeWinVisible(_settingsHandler->value("WelcomeWin/visible").toBool());
        qDebug() << "(Settings) Welcome Window visible:" << welcomeWinVisible();
    }

    // Font Size
    if(!_settingsHandler->contains("Window/fontSize"))
    {
        qDebug() << "(Settings) Initializing FontSize to" << DEFAULT_FONT_SIZE;
        setFontSize(DEFAULT_FONT_SIZE);
    }
    else
    {
        setFontSize(_settingsHandler->value("Window/fontSize").toInt());
        qDebug() << "(Settings) FontSize:" << fontSize();
    }

    // Background Color
    if(!_settingsHandler->contains("Window/backgroundColor"))
    {
        QColor bkgcolor(DEFAULT_BACKGROUND_COLOR_R, DEFAULT_BACKGROUND_COLOR_G, DEFAULT_BACKGROUND_COLOR_B, DEFAULT_BACKGROUND_COLOR_A);
        qDebug() << "(Settings) Initializing Background Color to" << bkgcolor;
        setBackgroundColor(bkgcolor);
    }
    else
    {
        setBackgroundColor(_settingsHandler->value("Window/backgroundColor").value<QColor>());
        qDebug() << "(Settings) Background color:" << backgroundColor();
    }

    // Foreground Color
    if(!_settingsHandler->contains("Window/foregroundColor"))
    {
        QColor frgcolor(DEFAULT_FOREGROUND_COLOR_R, DEFAULT_FOREGROUND_COLOR_G, DEFAULT_FOREGROUND_COLOR_B, DEFAULT_FOREGROUND_COLOR_A);
        qDebug() << "(Settings) Initializing Foreground Color to" << frgcolor;
        setForegroundColor(frgcolor);
    }
    else
    {
        setForegroundColor(_settingsHandler->value("Window/foregroundColor").value<QColor>());
        qDebug() << "(Settings) Foreground color:" << foregroundColor();
    }

    // Text Color
    if(!_settingsHandler->contains("Window/textColor"))
    {
        QColor txtcolor(DEFAULT_TEXT_COLOR_R, DEFAULT_TEXT_COLOR_G, DEFAULT_TEXT_COLOR_B, DEFAULT_TEXT_COLOR_A);
        qDebug() << "(Settings) Initializing Text Color to" << txtcolor;
        setTextColor(txtcolor);
    }
    else
    {
        setTextColor(_settingsHandler->value("Window/textColor").value<QColor>());
        qDebug() << "(Settings) Text color:" << textColor();
    }

    // Auto-hide window
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

    // Monitor where place the app
    if(!_settingsHandler->contains("Window/monitor"))
    {
        qDebug() << "(Settings) Initializing monitor " << DEFAULT_MONITOR;
        setMonitor(DEFAULT_MONITOR);
    }
    else
    {
        setMonitor(_settingsHandler->value("Window/monitor").toInt());
        qDebug() << "(Settings) Monitor: " << monitor();
    }

    // Translate on selection
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

    // Translate on copy
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

    // Translation Engine
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

    // Google Translate API Key
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

    // Translation Source Language
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

    // Translation Target Language
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

    // User email
    if(!_settingsHandler->contains("Translator/email"))
    {
        qDebug() << "(Settings) Initializing Email to" << DEFAULT_EMAIL;
        setEmail(DEFAULT_EMAIL);
    }
    else
    {
        setEmail(_settingsHandler->value("Translator/email").toString());
        qDebug() << "(Settings) Email:" << email();
    }
}


/** *********************************
 *  QML Invokable properties setters
 ** ********************************/
void Settings::setWelcomeWinVisible(bool welcome_win_visible)
{
    _settingsHandler->setValue("WelcomeWin/visible", welcome_win_visible);
    _welcome_win_visible = welcome_win_visible;
    emit welcomeWinVisibleChanged();
}

void Settings::setFontSize(int font_size)
{
    _settingsHandler->setValue("Window/fontSize", font_size);
    _font_size = font_size;
    emit fontSizeChanged();
}

void Settings::setBackgroundColor(QColor background_color)
{
    _settingsHandler->setValue("Window/backgroundColor", background_color);
    _background_color = background_color;
    emit backgroundColorChanged();
}

void Settings::setForegroundColor(QColor foreground_color)
{
    _settingsHandler->setValue("Window/foregroundColor", foreground_color);
    _foreground_color = foreground_color;
    emit foregroundColorChanged();
}

void Settings::setTextColor(QColor text_color)
{
    _settingsHandler->setValue("Window/textColor", text_color);
    _text_color = text_color;
    emit textColorChanged();
}

void Settings::setAutoHideWin(bool autohide_win)
{
    _settingsHandler->setValue("Window/autoHide", autohide_win);
    _autohide_win = autohide_win;
    emit autoHideWinChanged();
}

void Settings::setMonitor(int monitor)
{
    _settingsHandler->setValue("Window/monitor", monitor);
    _monitor = monitor;
    emit monitorChanged();
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

void Settings::setEmail(QString email)
{
    _settingsHandler->setValue("Translator/email", email);
    _email = email;
    emit emailChanged();
}

/** *********************************
 *  Static and constant Settings
 ** ********************************/
QStringList Settings::default_language_list = {"en", "es", "fr", "it", "jp", "de"};
