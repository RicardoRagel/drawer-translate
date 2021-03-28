#ifndef CONSTANTS_H
#define CONSTANTS_H

/*
 *
 * C++ DEFINES
 *
*/

#define APP_TITLE "Translator App"
#define TRIGGER_TRANSLATION_DELAY 1000 // Delay in ms to trigger the translation [integer]
#define TRANSLATION_ERROR_MSG "Error"
#define GOOGLE_TRANSLATE_API_NAME "Google Translate"
#define MY_MEMORY_TRANSLATE_API_NAME "MyMemory"
#define LIBRE_TRANSLATE_API_NAME "Libre Translate"
#define APERTIUM_TRANSLATE_API_NAME "Apertium"
#define DEFAULT_BACKGROUND_COLOR_R 30
#define DEFAULT_BACKGROUND_COLOR_G 30
#define DEFAULT_BACKGROUND_COLOR_B 30
#define DEFAULT_BACKGROUND_COLOR_A 255
#define DEFAULT_FOREGROUND_COLOR_R 93
#define DEFAULT_FOREGROUND_COLOR_G 99
#define DEFAULT_FOREGROUND_COLOR_B 99
#define DEFAULT_FOREGROUND_COLOR_A 255
#define DEFAULT_TEXT_COLOR_R 242
#define DEFAULT_TEXT_COLOR_G 242
#define DEFAULT_TEXT_COLOR_B 242
#define DEFAULT_TEXT_COLOR_A 255

/*
 *
 * C++ DEFINES TO QML
 * and other constants
 *
*/

#include <QObject>
#include <QtQml>
#include <QColor>

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

    QColor default_background_color = QColor(DEFAULT_BACKGROUND_COLOR_R, DEFAULT_BACKGROUND_COLOR_G, DEFAULT_BACKGROUND_COLOR_B, DEFAULT_BACKGROUND_COLOR_A);
    Q_PROPERTY(QColor defaultBackgroundColor READ defaultBackgroundColor NOTIFY defaultBackgroundColorChanged)
    QColor defaultBackgroundColor(){return default_background_color;}

    QColor default_foreground_color = QColor(DEFAULT_FOREGROUND_COLOR_R, DEFAULT_FOREGROUND_COLOR_G, DEFAULT_FOREGROUND_COLOR_B, DEFAULT_FOREGROUND_COLOR_A);
    Q_PROPERTY(QColor defaultForegroundColor READ defaultForegroundColor NOTIFY defaultForegroundColorChanged)
    QColor defaultForegroundColor(){return default_foreground_color;}

    QColor default_text_color = QColor(DEFAULT_TEXT_COLOR_R, DEFAULT_TEXT_COLOR_G, DEFAULT_TEXT_COLOR_B, DEFAULT_TEXT_COLOR_A);
    Q_PROPERTY(QColor defaultTextColor READ defaultTextColor NOTIFY defaultTextColorChanged)
    QColor defaultTextColor(){return default_text_color;}

signals:

  void appTitleChanged();
  void googleTranslateApiNameChanged();
  void myMemoryTranslateApiNameChanged();
  void libreTranslateApiNameChanged();
  void apertiumTranslateApiNameChanged();
  void defaultBackgroundColorChanged();
  void defaultForegroundColorChanged();
  void defaultTextColorChanged();
};

#endif

