#include "TranslatorApp.h"

TranslatorApp* TranslatorApp::_app = nullptr;

TranslatorApp::TranslatorApp(int& argc, char* argv[]) : QApplication(argc, argv),
                                                _constants(nullptr),
                                                _dataManager(nullptr),
                                                _qmlAppEngine(nullptr)
{
  //qDebug()<< "(TranslatorApp) Constructor";
  Q_ASSERT(_app == nullptr);
  _app = this;

  // Constants Manager Class
  _constants = new Constants();

  // Main Data Manager Class
  _dataManager = new DataManager();

  // Cursor Position Provider Class
  _cursorPosProvider = new CursorPosProvider();

  // Set Application Icon
  _app->setWindowIcon(QIcon(":/resources/icon_app.png"));

  // Set Application Version
  _app->setApplicationVersion(APP_VERSION);
}

TranslatorApp::~TranslatorApp()
{

}

QObject* TranslatorApp::_rootQmlObject(void)
{
  return _qmlAppEngine->rootObjects()[0];
}

QObject* dataManagerQmlGlobalSingletonFactory(QQmlEngine*, QJSEngine*)
{
  return TranslatorApp::_app->dataManager();
}

QObject* constantsQmlGlobalSingletonFactory(QQmlEngine*, QJSEngine*)
{
  return TranslatorApp::_app->constants();
}

QObject* cursorPosProviderQmlGlobalSingletonFactory(QQmlEngine*, QJSEngine*)
{
  return TranslatorApp::_app->cursorPosProvider();
}

void TranslatorApp::initCommon(void)
{
  qDebug() << "(TranslatorApp) Init Common functionalities..";

  // Register Classes to be accesible from QML
  qmlRegisterSingletonType<Constants>("Constants", 1, 0, "Constants", constantsQmlGlobalSingletonFactory);
  qmlRegisterSingletonType<DataManager>("DataManager", 1, 0, "DataManager", dataManagerQmlGlobalSingletonFactory);
  qmlRegisterSingletonType<CursorPosProvider>("MouseProvider", 1, 0, "MouseProvider", cursorPosProviderQmlGlobalSingletonFactory);
}

bool TranslatorApp::loadQmlEngine(void)
{
  qDebug() << "(TranslatorApp) Init QML engine";

  _qmlAppEngine = new QQmlApplicationEngine(this);

  qDebug() << "(TranslatorApp).. registering qml files";

  _qmlAppEngine->addImportPath("qrc:/qml");
  _qmlAppEngine->load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

  return true;
}
