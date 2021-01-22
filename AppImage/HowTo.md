
# Deploying *deepl-app* AppImage

## Overview
This document describe how to create an AppImage self-contained executable of the *deepl-app* app. 

We are going to supposse the usual case that you are not running the pre-installed Qt version of your OS. In this particular case, I am using Ubuntu 16.04 and Qt 5.14.2.

## Instructions

* Check that your Qt version is the same that you have used to compile the *haru-routines-creator* repository:
    
    ``` qmake --version ```

    If it is not the case, set the following enviroment var:

    ``` export PATH=/<PATH_TO_YOUR_QT_LIBS>/Qt/<QT_VERSION>/gcc_64/bin/:$PATH ```

    For example, in my case this command is: 
    
    ```export PATH=/home/ricardo/Libraries/Qt/5.14.2/gcc_64/bin/:$PATH``` 
    
    Repeat the previous command and check that your Qt version appears correctly.

* Get **linuxdeployqt** App from its [Github page](https://github.com/probonopd/linuxdeployqt) downloading the AppImage from the release section. In this case, the [stable release number 6](https://github.com/probonopd/linuxdeployqt/releases/tag/6) has been used. Do not forget set execution persmissions to this AppImage:

    ``` chmod a+x linuxdeployqt-6-x86_64.AppImage ```

* If you have not do it yet, compile the **app-deepl** app using QtCreator and copy the path of the folder where it has been built, we are going to call it as <PATH_TO_YOUR_BUILD_FOLDER> in the following steps. In my case, this path is: */home/ricardo/Libraries/build-deepl_app-Desktop_Qt_5_14_2_GCC_64bit-Debug*

* Copy the *deepl_app.desktop* and *icon.png* files of the [AppImage](AppImage) folder of this repository into the previous build folder. They will be neccessary to deploy the app.

* Finally execute the **linuxdeployqt** AppImage with the following arguments:

    ```./linuxdeployqt-6-x86_64.AppImage /<PATH_TO_YOUR_BUILD_FOLDER>/deepl_app.desktop -qmldir=/<PATH_TO_THIS_REPO>/deepl_app/qml -extra-plugins=<QT_EXTRA_PLUGINS_COMMA_SEPARATED> -appimage```

    In my case, this command looks like this:

    ```./linuxdeployqt-6-x86_64.AppImage /home/ricardo/Libraries/build-deepl_app-Desktop_Qt_5_14_2_GCC_64bit3-Debug/deepl_app.desktop -qmldir=/home/ricardo/Libraries/qt-qml-deepl-app/qml -extra-plugins=iconengines,imageformats -appimage```

    iconengines,imageformats,renderplugins,sceneparsers,geometryloaders,gamepads

* When the self-contained executable (*.AppImage) is generated, you will find it together the folder <PATH_TO_YOUR_BUILD_FOLDER>.