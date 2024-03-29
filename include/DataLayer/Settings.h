#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QtQml>
#include <QSettings>
#include <QColor>
#include <Constants.h>

#define DEFAULT_WELCOME_WIN_VISIBLE true                    // welcome windows visible flag
#define DEFAULT_FONT_SIZE 14                                // App Font Size
#define DEFAULT_AUTOHIDE_WIN false                          // AutoHide App Window flag
#define DEFAULT_MONITOR 0                                   // Monitor where place the app
#define DEFAULT_TRANSLATE_ON_SELECTION true                 // Enable input text from clipboard selection
#define DEFAULT_TRANSLATE_ON_COPY true                      // Enable input text from clipboard copy
#define DEFAULT_TRANSLATOR_ENGINE LIBRE_TRANSLATE_API_NAME  // Select the default Translation engine
#define DEFAULT_GOOGLE_API_KEY ""                           // Google Translate API Key. Get one from https://cloud.google.com/translate/docs/setup
#define DEFAULT_SOURCE_LANG "en"                            // Input text language code from https://cloud.google.com/translate/docs/languages
#define DEFAULT_TARGET_LANG "es"                            // Output text language code from https://cloud.google.com/translate/docs/languages
#define DEFAULT_EMAIL ""                                    // User email

class Settings : public QObject
{
    Q_OBJECT

public:

    // Constructor
    Settings();

    // Destuctor
    ~Settings();

    // Initialization
    void init();

    // QML properties declarations
    Q_PROPERTY(bool welcomeWinVisible READ welcomeWinVisible WRITE setWelcomeWinVisible NOTIFY welcomeWinVisibleChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(QColor foregroundColor READ foregroundColor WRITE setForegroundColor NOTIFY foregroundColorChanged)
    Q_PROPERTY(QColor textColor READ textColor WRITE setTextColor NOTIFY textColorChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(bool autoHideWin READ autoHideWin WRITE setAutoHideWin NOTIFY autoHideWinChanged)
    Q_PROPERTY(int monitor READ monitor WRITE setMonitor NOTIFY monitorChanged)
    Q_PROPERTY(bool translateOnSelection READ translateOnSelection WRITE setTranslateOnSelection NOTIFY translateOnSelectionChanged)
    Q_PROPERTY(bool translateOnCopy READ translateOnCopy WRITE setTranslateOnCopy NOTIFY translateOnCopyChanged)
    Q_PROPERTY(QString translatorEngine READ translatorEngine WRITE setTranslatorEngine NOTIFY translatorEngineChanged)
    Q_PROPERTY(QString googleApiKey READ googleApiKey WRITE setGoogleApiKey NOTIFY googleApiKeyChanged)
    Q_PROPERTY(QString sourceLang READ sourceLang WRITE setSourceLang NOTIFY sourceLangChanged)
    Q_PROPERTY(QString targetLang READ targetLang WRITE setTargetLang NOTIFY targetLangChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)

    // QML properties getters
    bool welcomeWinVisible()    {return _welcome_win_visible;}
    QColor backgroundColor()    {return _background_color;}
    QColor foregroundColor()    {return _foreground_color;}
    QColor textColor()          {return _text_color;}
    int fontSize()              {return _font_size;}
    bool autoHideWin()          {return _autohide_win;}
    int  monitor()              {return _monitor;}
    bool translateOnSelection() {return _translate_on_selection;}
    bool translateOnCopy()      {return _translate_on_copy;}
    QString googleApiKey()      {return _google_api_key;}
    QString translatorEngine()  {return _translator_engine;}
    QString sourceLang()        {return _source_lang;}
    QString targetLang()        {return _target_lang;}
    QString email()             {return _email;}

    // QML Invokable properties setters
    Q_INVOKABLE void setWelcomeWinVisible(bool welcome_win_visible);
    Q_INVOKABLE void setBackgroundColor(QColor background_color);
    Q_INVOKABLE void setForegroundColor(QColor foreground_color);
    Q_INVOKABLE void setTextColor(QColor text_color);
    Q_INVOKABLE void setFontSize(int font_size);
    Q_INVOKABLE void setAutoHideWin(bool autohide_win);
    Q_INVOKABLE void setMonitor(int monitor);
    Q_INVOKABLE void setTranslateOnSelection(bool translate_on_selection);
    Q_INVOKABLE void setTranslateOnCopy(bool translate_on_copy);
    Q_INVOKABLE void setTranslatorEngine(QString translator_engine);
    Q_INVOKABLE void setGoogleApiKey(QString api_key);
    Q_INVOKABLE void setSourceLang(QString source_lang);
    Q_INVOKABLE void setTargetLang(QString target_lang);
    Q_INVOKABLE void setEmail(QString email);

    // Static and constant settings
    static QStringList default_language_list;

signals:

    // QML properties signals
    void welcomeWinVisibleChanged();
    void backgroundColorChanged();
    void foregroundColorChanged();
    void textColorChanged();
    void fontSizeChanged();
    void autoHideWinChanged();
    void monitorChanged();
    void translateOnSelectionChanged();
    void translateOnCopyChanged();
    void translatorEngineChanged();
    void googleApiKeyChanged();
    void sourceLangChanged();
    void targetLangChanged();
    void emailChanged();

private:

    // Settings file handler
    QSettings *_settingsHandler;

    // Settings variables
    bool _welcome_win_visible;
    QColor _background_color;
    QColor _foreground_color;
    QColor _text_color;
    int _font_size;
    bool _autohide_win;
    int _monitor;
    bool _translate_on_selection;
    bool _translate_on_copy;
    QString _translator_engine;
    QString _google_api_key;
    QString _source_lang;
    QString _target_lang;
    QString _email;
};


#endif

