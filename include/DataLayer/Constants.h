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
#define TRANSLATION_ERROR_MSG "Something went wrong..."
/*
 *
 * C++ DEFINES TO QML
 *
*/

#include <QObject>
#include <QtQml>

class Constants : public QObject
{
    Q_OBJECT

public:

    double deg2rad = DEG2RAD;
    Q_PROPERTY(double degToRad READ degToRad NOTIFY degToRadChanged)
    double degToRad(){return deg2rad;}

    double rad2deg = DEG2RAD;
    Q_PROPERTY(double radToDeg READ radToDeg NOTIFY radToDegChanged)
    double radToDeg(){return rad2deg;}

    QString app_title = APP_TITLE;
    Q_PROPERTY(QString appTitle READ appTitle NOTIFY appTitleChanged)
    QString appTitle(){return app_title;}

signals:
  void degToRadChanged();
  void radToDegChanged();
  void appTitleChanged();
};


#endif

