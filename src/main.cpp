#include "TranslatorApp.h"

int main(int argc, char **argv)
{
    // Use OpenGL emulation by software. It fixes FrameLess jittering window issues
    // Ref: https://stackoverflow.com/questions/30818886/qml-window-resize-move-flicker
#ifdef _WIN32
    qDebug() << "(TranslatorApp) Using OpenGL emulation by software";
    QApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);
#elif __linux__
    qDebug() << "(TranslatorApp) Using system default graphics redered";
#endif
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
