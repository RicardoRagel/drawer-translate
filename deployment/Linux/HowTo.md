
# Deploying *drawer-translate* AppImage

## Overview
This document describes how to create an AppImage self-contained executable of the *drawer-translate* app for Linux. 

We are going to supposse the usual case that you are not running the pre-installed Qt version of your OS. In this particular case, I am using Ubuntu 16.04 and Qt 5.14.1.

## Usage

In case you want to release a new AppImage of this application, simply execute the provided script `release_appimage.sh` in the following way:

```bash
./release_appimage.sh <PATH_TO_YOUR_APP_BUILD_FOLDER> <PATH_TO_QMAKE>
```

selecting the correct folder where you have built the application (using QtCreator in Release mode) and the path to the Qt folder where is located the `qmake` executable of the same Qt version you used to compile the project. Example: 

`./release_appimage.sh ~/Libraries/build-drawer_translate-Desktop_Qt_5_14_1_GCC_64bit-Release/ ~/Libraries/Qt5.14.1/5.14.1/gcc_64/bin/`. 

Once the script finishes, you will find the resulting AppImage together that script.

In case you find any issue or you want to execute this process manually, take a look to the next section.

## Instructions

The previous releasing script executes basically the following steps:

1. Check that your Qt version is the same that you have used to compile the *drawer-translate* repository:

    ``` qmake --version ```

    Otherwise, set the following enviroment var:

    ``` export PATH=/<PATH_TO_YOUR_QT_LIBS>/Qt/<QT_VERSION>/gcc_64/bin/:$PATH ```

    In my case, this command is: `export PATH=/home/ricardo/Libraries/Qt5.14.1/5.14.1/gcc_64/bin/:$PATH` to use Qt 5.14.1. Repeat the previous command and check that your Qt version appears correctly.

2. Get **linuxdeployqt** App from his [Github page](https://github.com/probonopd/linuxdeployqt), downloading its AppImage from the release section. In our case, we have used the [stable release number 7](https://github.com/probonopd/linuxdeployqt/releases/tag/7). Set also execution persmissions to it:

    ``` chmod a+x linuxdeployqt-7-x86_64.AppImage ```

3. If you have not do it yet, compile the **drawer-translate** app using QtCreator and copy the path of the folder where it has been built, we are going to call it as <PATH_TO_YOUR_BUILD_FOLDER> in the following steps. In my case, this path is: */home/ricardo/Libraries/build-drawer_translate-Desktop_Qt_5_14_1_GCC_64bit-Release/*

4. Copy the [*drawer_translate.desktop*](drawer_translate.desktop) and [*icon_app.png*](../../icon_app.png) files into the previous build folder. They will be neccessary to deploy the app.

5. Finally execute the **linuxdeployqt** AppImage with the following arguments:

    ```./linuxdeployqt-7-x86_64.AppImage /<PATH_TO_YOUR_BUILD_FOLDER>/drawer_translate.desktop -qmldir=/<PATH_TO_THIS_REPO>/drawer-translate/qml -appimage```

    In my case, this command looks like this for Qt 5.14.1:

    ```./linuxdeployqt-7-x86_64.AppImage /home/ricardo/Libraries/build-drawer_translate-Desktop_Qt_5_14_1_GCC_64bit-Release/drawer_translate.desktop -qmldir=/home/ricardo/Libraries/drawer-translate/qml -appimage```

     When the self-contained executable (*.AppImage) is generated, you will find it together the folder <PATH_TO_YOUR_BUILD_FOLDER>.

6. Previous step doesn't package GStreamer into the AppImage and it could find issues running the AppImage on a Linux OS differnt of the used to release it. So, this step 5 should be divided in 2 `linuxdeployqt` steps: 
    * A first `linuxdeployqt` command to just package the resources into the build folder. It is the same command of point 5. but removing the `-appimage` flag.
    * A second `linuxdeployqt` to release it (exactly the same command that point 5.) but after include GStreamer 1.0 libs into the build folder <PATH_TO_YOUR_BUILD_FOLDER> and after modify the `AppRun` executable to include the setting of some GStreamer enviroment variables. Check the script [release_appimage.sh](release_appimage.sh) from line 102 to know more about how to do it on Ubuntu 16.04.

## References

* [LinuxDeployQt official repository](https://github.com/probonopd/linuxdeployqt).
* [AppImages Known Platform issues](https://gitlab.com/probono/platformissues).
* GStreamer-AppImage workarounds: [1. LinuxDeployQt Issues](https://github.com/probonopd/linuxdeployqt/issues/123), [2. KdenLive release script](https://invent.kde.org/multimedia/kdenlive/-/blob/0f6247405619486d9f217123791a9e87ff39e5e7/packaging/appimage/build-image.sh), [3. GTK3 apps bundle script and custom AppRun](https://github.com/AppImage/AppImageKit/wiki/Bundling-GTK3-apps), [4. Another GStreamer workaround non-tested](https://github.com/linuxdeploy/linuxdeploy-plugin-gstreamer/blob/master/linuxdeploy-plugin-gstreamer.sh)
* [AppRun Script Wrapper](https://github.com/probonopd/linuxdeployqt/wiki/Custom-wrapper-script-instead-of-AppRun)