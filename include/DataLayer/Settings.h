#ifndef SETTINGS_H
#define SETTINGS_H

#define DEFAULT_FRAMELESS_WIN true          // FrameLess App Window flag
#define DEFAULT_AUTOHIDE_WIN false          // AutoHide App Window flag
#define DEFAULT_TRANSLATE_ON_SELECTION true // Enable input text from clipboard selection
#define DEFAULT_TRANSLATE_ON_COPY true      // Enable input text from clipboard copy
#define DEFAULT_API_KEY ""                  // Google Translate API Key. Get one from https://cloud.google.com/translate/docs/setup
#define DEFAULT_SOURCE_LANG "en"            // Input text language code from https://cloud.google.com/translate/docs/languages
#define DEFAULT_TARGET_LANG "es"            // Output text language code from https://cloud.google.com/translate/docs/languages

#include <QObject>
#include <QtQml>
#include <QSettings>

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
    Q_PROPERTY(bool framelessWin READ framelessWin WRITE setFramelessWin NOTIFY framelessWinChanged)
    Q_PROPERTY(bool autoHideWin READ autoHideWin WRITE setAutoHideWin NOTIFY autoHideWinChanged)
    Q_PROPERTY(bool translateOnSelection READ translateOnSelection WRITE setTranslateOnSelection NOTIFY translateOnSelectionChanged)
    Q_PROPERTY(bool translateOnCopy READ translateOnCopy WRITE setTranslateOnCopy NOTIFY translateOnCopyChanged)
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged)
    Q_PROPERTY(QString sourceLang READ sourceLang WRITE setSourceLang NOTIFY sourceLangChanged)
    Q_PROPERTY(QString targetLang READ targetLang WRITE setTargetLang NOTIFY targetLangChanged)

    // QML properties getters
    bool framelessWin()         {return _frameless_win;}
    bool autoHideWin()          {return _autohide_win;}
    bool translateOnSelection() {return _translate_on_selection;}
    bool translateOnCopy()      {return _translate_on_copy;}
    QString apiKey()            {return _api_key;}
    QString sourceLang()        {return _source_lang;}
    QString targetLang()        {return _target_lang;}

    // QML Invokable properties setters
    Q_INVOKABLE void setFramelessWin(bool frameless_win);
    Q_INVOKABLE void setAutoHideWin(bool autohide_win);
    Q_INVOKABLE void setTranslateOnSelection(bool translate_on_selection);
    Q_INVOKABLE void setTranslateOnCopy(bool translate_on_copy);
    Q_INVOKABLE void setApiKey(QString api_key);
    Q_INVOKABLE void setSourceLang(QString source_lang);
    Q_INVOKABLE void setTargetLang(QString target_lang);

signals:

    // QML properties signals
    void framelessWinChanged();
    void autoHideWinChanged();
    void translateOnSelectionChanged();
    void translateOnCopyChanged();
    void apiKeyChanged();
    void sourceLangChanged();
    void targetLangChanged();

private:

    // Settings file handler
    QSettings *_settingsHandler;

    // Settings variables
    bool _frameless_win;
    bool _autohide_win;
    bool _translate_on_selection;
    bool _translate_on_copy;
    QString _api_key;
    QString _source_lang;
    QString _target_lang;
};


#endif

