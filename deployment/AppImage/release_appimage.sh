#!/bin/bash
USAGE="./release_appimage.sh <PATH_TO_YOUR_APP_BUILD_FOLDER> <PATH_TO_QMAKE>"
# example: ./release_appimage.sh ~/Libraries/build-translator_app-Desktop_Qt_5_14_1_GCC_64bit-Debug/ ~/Libraries/Qt5.14.1/5.14.1/gcc_64/bin/

# Project Configuration
LINUXDEPLOYQT=linuxdeployqt-7-x86_64.AppImage
DESKTOP_FILE_NAME=translator_minimal_app.desktop
DESKTOP_FILE_ICON=icon_app.png
QML_FOLDER=../../qml
#QT_EXTRA_PLUGINS=iconengines,imageformats,renderplugins,sceneparsers,geometryloaders

# Get and parse arguments
if [ $# -eq 0 ]; then
    echo "Not enough arguments supplied. Please specify the folder where you have built your app"
    echo "USAGE: $USAGE"
    exit 2
else
    BUILD_FOLDER=$1
fi
echo "-- Selected to release the AppImage of $BUILD_FOLDER"
if [ ! -d $BUILD_FOLDER ] 
then
    echo "Directory $BUILD_FOLDER DOES NOT exists." 
    exit 2
fi

if [ $# -ge 2 ]; then
    QMAKE_PATH=$2
else
    echo "Not enough arguments supplied. Please specify also the path to the qmake executable of your Qt version"
    echo "USAGE: $USAGE"
    exit 2
fi
echo "-- Selected to use qmake on path $QMAKE_PATH"
if [ ! -d $QMAKE_PATH ] 
then
    echo "Directory $QMAKE_PATH DOES NOT exists." 
    exit 2
fi

# Set desired Qt version
export PATH=$QMAKE_PATH:$PATH
echo "Make sure the following match with your desired qmake version:"
qmake --version

# Download LinuxDeployQt tool
echo "-- Downloading linuxDeployQt ..."
if test -f "$LINUXDEPLOYQT"; then
    echo "$LINUXDEPLOYQT already downloaded."
else
    wget https://github.com/probonopd/linuxdeployqt/releases/download/7/linuxdeployqt-7-x86_64.AppImage
fi
chmod a+x $LINUXDEPLOYQT

# ThirdParty libs
echo "-- Setting up 3rdParty libs .."
echo "   * OpenSSL"
export LD_LIBRARY_PATH="$BUILD_FOLDER/3rdparty/openssl1.1.1:$LD_LIBRARY_PATH"
mkdir -p $BUILD_FOLDER/lib
cp -R $BUILD_FOLDER/3rdparty/openssl1.1.1/* $BUILD_FOLDER/lib

# # Copy desktop file and icon to build folder
cp $DESKTOP_FILE_NAME $BUILD_FOLDER
cp $DESKTOP_FILE_ICON $BUILD_FOLDER

# Deploy your AppImage
echo "-- Deploying your App ..."
COMMAND="$LINUXDEPLOYQT $BUILD_FOLDER/$DESKTOP_FILE_NAME -qmldir=$QML_FOLDER -appimage -extra-plugins=$QT_EXTRA_PLUGINS"
echo "Executing command: $COMMAND"
./$COMMAND