#!/bin/bash
USAGE="./release_appimage.sh <PATH_TO_YOUR_APP_BUILD_FOLDER> <PATH_TO_QMAKE>"
# example: ./release_appimage.sh ~/Libraries/build-drawer_translate-Desktop_Qt_5_14_1_GCC_64bit-Release/ ~/Libraries/Qt5.14.1/5.14.1/gcc_64/bin/

# Echo Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NOCOLOR='\033[0m'

# Check this script is being executed from its current folder location
THIS_SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ "$PWD" != "$THIS_SCRIPT_PATH" ]; then 
    echo -e "${RED}This script must be executed only from its own folder ${NOCOLOR}" 
    exit 2
fi

# Project Configuration
LINUXDEPLOYQT=linuxdeployqt-7-x86_64.AppImage
DESKTOP_FILE_NAME=drawer_translate.desktop
DESKTOP_FILE_ICON=../../resources/icon_app.png
QML_FOLDER=../../qml
#QT_EXTRA_PLUGINS=iconengines,imageformats,renderplugins,sceneparsers,geometryloaders

# Check QML folder, desktop file and app icon exist
if [ ! -d $QML_FOLDER ]; then
    echo -e "${RED}Directory $QML_FOLDER does NOT exist. Modify this script in case you are using a different qml folder. ${NOCOLOR}" 
    exit 2
fi
if [ ! -f $DESKTOP_FILE_NAME ]; then
    echo -e "${RED}Desktop file $DESKTOP_FILE_NAME does NOT exists. Modify this script in case you are using a different desktop file. ${NOCOLOR}" 
    exit 2
fi
if [ ! -f $DESKTOP_FILE_ICON ]; then
    echo -e "${RED}App icon $DESKTOP_FILE_ICON does NOT exists. Modify this script in case you are using a different icon image file. ${NOCOLOR}" 
    exit 2
fi

# Get and check arguments
if [ $# -eq 0 ]; then
    echo -e "${RED}Not enough arguments supplied. Please specify the folder where you have built your app ${NOCOLOR}"
    echo "USAGE: $USAGE"
    exit 2
else
    BUILD_FOLDER=$1
fi
echo -e "${BLUE}-- Selected to release the AppImage of the build folder: $BUILD_FOLDER ${NOCOLOR}"
if [ ! -d $BUILD_FOLDER ]; then
    echo -e "${RED}Directory $BUILD_FOLDER does NOT exist. ${NOCOLOR}" 
    exit 2
fi
if [ $# -ge 2 ]; then
    QMAKE_PATH=$2
else
    echo -e "${RED}Not enough arguments supplied. Please specify also the path to the qmake executable of your Qt version ${NOCOLOR}"
    echo "USAGE: $USAGE"
    exit 2
fi
echo -e "${BLUE}-- Selected to use qmake executable from path $QMAKE_PATH ${NOCOLOR}"
if [ ! -d $QMAKE_PATH ]; then
    echo -e "${RED}Directory $QMAKE_PATH does NOT exist ${NOCOLOR}" 
    exit 2
fi
if [ ! -f $QMAKE_PATH/qmake ]; then
    echo -e "${RED}No qmake executable found at $QMAKE_PATH ${NOCOLOR}" 
    exit 2
fi

# Set desired Qt version
export PATH=$QMAKE_PATH:$PATH
echo "Make sure that the following qmake version matches with the Qt version of your build folder"
qmake --version

# Download LinuxDeployQt tool
echo -e "${BLUE}-- Downloading linuxDeployQt ... ${NOCOLOR}"
if test -f "$LINUXDEPLOYQT"; then
    echo "$LINUXDEPLOYQT already downloaded."
else
    wget https://github.com/probonopd/linuxdeployqt/releases/download/7/linuxdeployqt-7-x86_64.AppImage
fi
chmod a+x $LINUXDEPLOYQT

# Copy desktop file and icon to build folder
echo -e "${BLUE}-- Copying $DESKTOP_FILE_NAME and $DESKTOP_FILE_ICON to the build folder... ${NOCOLOR}"
cp $DESKTOP_FILE_NAME $BUILD_FOLDER
cp $DESKTOP_FILE_ICON $BUILD_FOLDER

# ThirdParty libs
echo -e "${BLUE}-- Setting up 3rdParty libs... ${NOCOLOR}"
echo -e "${BLUE}   * OpenSSL ${NOCOLOR}"
export LD_LIBRARY_PATH="$BUILD_FOLDER/3rdparty/openssl1.1.1:$LD_LIBRARY_PATH"
mkdir -p $BUILD_FOLDER/lib
cp -R $BUILD_FOLDER/3rdparty/openssl1.1.1/* $BUILD_FOLDER/lib

# Deploy the AppImage
# echo "${BLUE}-- Deploying your App ... ${NOCOLOR}"
# COMMAND="$LINUXDEPLOYQT $BUILD_FOLDER/$DESKTOP_FILE_NAME -qmldir=$QML_FOLDER -appimage -extra-plugins=$QT_EXTRA_PLUGINS"
# echo "Executing command: $COMMAND"
# ./$COMMAND
# echo -e "${GREEN} Releasing script finished correctly. If the last command also finished with 'Success', the AppImage should have been placed at $THIS_SCRIPT_PATH ${NOCOLOR}"

##### Custom Deploy for the AppImage:
##### In case of QMediaPlayer usage, GStreamer libraries must be added to the release
##### In addition, the AppImage AppRun script must re-created adding some GStreamer enviroment variables:

# Including GStreamer libs
echo -e "${BLUE}-- Copying GStreamer 1.0 to the build folder... ${NOCOLOR}"
GST_PLUGIN_SRC_DIR=/usr/lib/x86_64-linux-gnu/
mkdir -p $BUILD_FOLDER/usr/lib/x86_64-linux-gnu
GST_LIB_DEST_DIR=$BUILD_FOLDER/usr/lib/x86_64-linux-gnu/gstreamer1.0
mkdir -p $GST_LIB_DEST_DIR
GST_PLUGIN_DEST_DIR=$BUILD_FOLDER/usr/lib/x86_64-linux-gnu/gstreamer1.0/gstreamer-1.0
mkdir -p $GST_PLUGIN_DEST_DIR
cp $GST_PLUGIN_SRC_DIR/gstreamer1.0/gstreamer-1.0/gst-plugin-scanner $GST_PLUGIN_DEST_DIR
cp -R $GST_PLUGIN_SRC_DIR/gstreamer-1.0/* $GST_LIB_DEST_DIR

# Packing for the AppImage (removing the flag -appimage to only pack and create the AppRun, not the AppImage)
echo -e "${BLUE}-- Packing App ... ${NOCOLOR}"
COMMAND="$LINUXDEPLOYQT $BUILD_FOLDER/$DESKTOP_FILE_NAME -qmldir=$QML_FOLDER -extra-plugins=$QT_EXTRA_PLUGINS"
echo "Executing command: $COMMAND"
./$COMMAND

# Adding GStreamer enviroment variables -> Re-create AppRun including them
echo -e "${BLUE}-- Replacing AppRun by a custom one ... ${NOCOLOR}"
rm  $BUILD_FOLDER/AppRun

cat > $BUILD_FOLDER/AppRun << EOF
#!/bin/bash

DIR="\`dirname \"\$0\"\`" 
DIR="\`( cd \"\$DIR\" && pwd )\`"
export APPDIR=\$DIR
export LD_LIBRARY_PATH=\$DIR/lib/:\$DIR/usr/lib/:\$LD_LIBRARY_PATH
export PATH=\$DIR/usr/bin:\$PATH
export GST_PLUGIN_SCANNER=\$DIR/usr/lib/x86_64-linux-gnu/gstreamer1.0/gstreamer-1.0/gst-plugin-scanner
export GST_PLUGIN_PATH=\$DIR/usr/lib/x86_64-linux-gnu/gstreamer1.0/

exec \$DIR/drawer_translate \$@
EOF
chmod +x $BUILD_FOLDER/AppRun

# Deploying the AppImage
echo -e "${BLUE}-- Releasing AppImage ... ${NOCOLOR}"
COMMAND="$LINUXDEPLOYQT $BUILD_FOLDER/$DESKTOP_FILE_NAME -appimage"
echo "Executing command: $COMMAND"
./$COMMAND
echo -e "${GREEN} Releasing script finished correctly. If the last command also finished with 'Success', the AppImage should have been placed at $THIS_SCRIPT_PATH ${NOCOLOR}"