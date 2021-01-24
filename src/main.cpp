#include "TranslatorApp.h"

int main(int argc, char **argv)
{
    // Init our QApplication
    TranslatorApp* app = new TranslatorApp(argc,argv);

    // Init the app's data managers
    app->initCommon();

    // Load the QML front-end
    if (!app->loadQmlEngine())
    {
      return -1;
    }

    // Execute App
    int exitCode = 0;
    exitCode = app->exec();

    // Once the app is closed, free memory and exit
    delete app;

    qDebug() << "App closed, exit code "<< exitCode;
    return exitCode;
}
