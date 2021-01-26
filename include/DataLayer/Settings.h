#ifndef SETTINGS_H
#define SETTINGS_H

#define DEFAULT_API_KEY ""
#define DEFAULT_SOURCE_LANG "en" // Input text language code from https://cloud.google.com/translate/docs/languages
#define DEFAULT_TARGET_LANG "es"

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
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged)
    Q_PROPERTY(QString sourceLang READ sourceLang WRITE setSourceLang NOTIFY sourceLangChanged)
    Q_PROPERTY(QString targetLang READ targetLang WRITE setTargetLang NOTIFY targetLangChanged)

    // QML properties getters
    QString apiKey() {return _api_key;}
    QString sourceLang() {return _source_lang;}
    QString targetLang() {return _target_lang;}

    // QML Invokable properties setters
    Q_INVOKABLE void setApiKey(QString api_key);
    Q_INVOKABLE void setSourceLang(QString source_lang);
    Q_INVOKABLE void setTargetLang(QString target_lang);

signals:

    // QML properties signals
    void apiKeyChanged();
    void sourceLangChanged();
    void targetLangChanged();

private:

    // Settings file handler
    QSettings *_settingsHandler;

    // Settings variables
    QString _api_key;
    QString _source_lang;
    QString _target_lang;
};


#endif

