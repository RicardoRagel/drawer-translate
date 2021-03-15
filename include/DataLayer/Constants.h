#ifndef CONSTANTS_H
#define CONSTANTS_H

/*
 *
 * C++ DEFINES
 *
*/

#define DEG2RAD M_PI/180
#define RAD2DEG 180/M_PI
#define APP_TITLE "Translator App"
#define TRIGGER_TRANSLATION_DELAY 1000 // Delay in ms to trigger the translation [integer]
#define TRANSLATION_ERROR_MSG "Error"
#define GOOGLE_TRANSLATE_API_NAME "Google Translate"
#define MY_MEMORY_TRANSLATE_API_NAME "MyMemory"
#define LIBRE_TRANSLATE_API_NAME "Libre Translate"
#define APERTIUM_TRANSLATE_API_NAME "Apertium"

/*
 *
 * C++ DEFINES TO QML
 * and other constants
 *
*/

#include <QObject>
#include <QtQml>

class Constants : public QObject
{
    Q_OBJECT

public:

    QString app_title = APP_TITLE;
    Q_PROPERTY(QString appTitle READ appTitle NOTIFY appTitleChanged)
    QString appTitle(){return app_title;}

    QString google_translate_api_name = GOOGLE_TRANSLATE_API_NAME;
    Q_PROPERTY(QString googleTranslateApiName READ googleTranslateApiName NOTIFY googleTranslateApiNameChanged)
    QString googleTranslateApiName(){return google_translate_api_name;}

    QString my_memory_translate_api_name = MY_MEMORY_TRANSLATE_API_NAME;
    Q_PROPERTY(QString myMemoryTranslateApiName READ myMemoryTranslateApiName NOTIFY myMemoryTranslateApiNameChanged)
    QString myMemoryTranslateApiName(){return my_memory_translate_api_name;}

    QString libre_translate_api_name = LIBRE_TRANSLATE_API_NAME;
    Q_PROPERTY(QString libreTranslateApiName READ libreTranslateApiName NOTIFY libreTranslateApiNameChanged)
    QString libreTranslateApiName(){return libre_translate_api_name;}

    QString apertium_translate_api_name = APERTIUM_TRANSLATE_API_NAME;
    Q_PROPERTY(QString apertiumTranslateApiName READ apertiumTranslateApiName NOTIFY apertiumTranslateApiNameChanged)
    QString apertiumTranslateApiName(){return apertium_translate_api_name;}

signals:

  void appTitleChanged();
  void googleTranslateApiNameChanged();
  void myMemoryTranslateApiNameChanged();
  void libreTranslateApiNameChanged();
  void apertiumTranslateApiNameChanged();
};

#endif

