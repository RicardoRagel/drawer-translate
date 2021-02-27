#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QtQml>
#include <QSettings>
#include <Constants.h>

#define DEFAULT_AUTOHIDE_WIN false                          // AutoHide App Window flag
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
    Q_PROPERTY(bool autoHideWin READ autoHideWin WRITE setAutoHideWin NOTIFY autoHideWinChanged)
    Q_PROPERTY(bool translateOnSelection READ translateOnSelection WRITE setTranslateOnSelection NOTIFY translateOnSelectionChanged)
    Q_PROPERTY(bool translateOnCopy READ translateOnCopy WRITE setTranslateOnCopy NOTIFY translateOnCopyChanged)
    Q_PROPERTY(QString translatorEngine READ translatorEngine WRITE setTranslatorEngine NOTIFY translatorEngineChanged)
    Q_PROPERTY(QString googleApiKey READ googleApiKey WRITE setGoogleApiKey NOTIFY googleApiKeyChanged)
    Q_PROPERTY(QString sourceLang READ sourceLang WRITE setSourceLang NOTIFY sourceLangChanged)
    Q_PROPERTY(QString targetLang READ targetLang WRITE setTargetLang NOTIFY targetLangChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)

    // QML properties getters
    bool autoHideWin()          {return _autohide_win;}
    bool translateOnSelection() {return _translate_on_selection;}
    bool translateOnCopy()      {return _translate_on_copy;}
    QString googleApiKey()      {return _google_api_key;}
    QString translatorEngine()  {return _translator_engine;}
    QString sourceLang()        {return _source_lang;}
    QString targetLang()        {return _target_lang;}
    QString email()             {return _email;}

    // QML Invokable properties setters
    Q_INVOKABLE void setAutoHideWin(bool autohide_win);
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
    void autoHideWinChanged();
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
    bool _autohide_win;
    bool _translate_on_selection;
    bool _translate_on_copy;
    QString _translator_engine;
    QString _google_api_key;
    QString _source_lang;
    QString _target_lang;
    QString _email;
};


#endif

