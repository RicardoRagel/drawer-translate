#ifndef TRANSLATORAPP_H
#define TRANSLATORAPP_H

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlEngine>
#include <QtQml>
#include <QIcon>

#include "Constants.h"
#include "DataManager.h"
#include "CursorPosProvider.h"

using namespace std;

class TranslatorApp : public QApplication
{
  Q_OBJECT

public:

  TranslatorApp(int& argc, char* argv[]);

  ~TranslatorApp();

  void initCommon(void);

  Constants* constants() { return _constants; }
  DataManager* dataManager() { return _dataManager; }
  CursorPosProvider* cursorPosProvider() { return _cursorPosProvider; }
  QQmlApplicationEngine* qmlEngine() { return _qmlAppEngine; }

  bool loadQmlEngine(void);

  static TranslatorApp* _app;

private:

  Constants* _constants;                 // Constant Manager (accesible from C++ and QML)
  DataManager* _dataManager;             // Data Manager ((accesible from C++ and QML))
  CursorPosProvider* _cursorPosProvider; // Data Manager ((accesible from C++ and QML))
  QQmlApplicationEngine* _qmlAppEngine;  // QML Engine Handler
  QObject* _rootQmlObject(void);
};

#endif // TRANSLATORAPP_H