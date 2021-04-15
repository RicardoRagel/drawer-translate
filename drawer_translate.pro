QT += widgets qml quick network multimedia # Others usual: 3dinput positioning svg multimedia gamepad
CONFIG += c++17         # C++ Version
CONFIG += qml_debug     # Enable QML console debug
#CONFIG += resources_big # Set this flag if your resources are big and cause compilation errors

VERSION = 1.0.0         # App version as major.minor.patch
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

INCLUDEPATH += include/Core \
               include/DataLayer \
               include/Utils

HEADERS += \
    include/Core/TranslatorApp.h \
    include/DataLayer/DataManager.h \
    include/DataLayer/Constants.h \
    include/DataLayer/Settings.h \
    include/DataLayer/TranslatorAPIs/AbstractTranslateApi.h \
    include/DataLayer/TranslatorAPIs/ApertiumTranslateApi.h \
    include/DataLayer/TranslatorAPIs/GoogleTranslateApi.h \
    include/DataLayer/TranslatorAPIs/LibreTranslateApi.h \
    include/DataLayer/TranslatorAPIs/MyMemoryTranslateApi.h \
    include/DataLayer/TranslatorAPIs/TranslationExtraInfo.h \
    include/DataLayer/TextToSpeechAPIs/SoundOfTextApi.h \
    include/Utils/DownloadManager.h \
    include/Utils/LanguageISOCodes.h \
    include/Utils/CursorPosProvider.h

SOURCES += \
    src/Core/TranslatorApp.cpp \
    src/DataLayer/DataManager.cpp \
    src/DataLayer/Settings.cpp \
    src/DataLayer/TranslatorAPIs/AbstractTranslateApi.cpp \
    src/DataLayer/TranslatorAPIs/ApertiumTranslateApi.cpp \
    src/DataLayer/TranslatorAPIs/GoogleTranslateApi.cpp \
    src/DataLayer/TranslatorAPIs/LibreTranslateApi.cpp \
    src/DataLayer/TranslatorAPIs/MyMemoryTranslateApi.cpp \
    src/DataLayer/TranslatorAPIs/TranslationExtraInfo.cpp \
    src/DataLayer/TextToSpeechAPIs/SoundOfTextApi.cpp \
    src/Utils/DownloadManager.cpp \
    src/Utils/LanguageISOCodes.cpp \
    src/main.cpp

OTHER_FILES += \
    qml/CustomWidgets/CustomButton.qml \
    qml/CustomWidgets/CustomButton2.qml \
    qml/CustomWidgets/CustomCheckBox.qml \
    qml/CustomWidgets/CustomComboBox.qml \
    qml/CustomWidgets/CustomScrollView.qml \
    qml/CustomWidgets/CustomFontSizeSwitch.qml \
    qml/CustomWidgets/CustomContextMenu.qml \
    qml/CustomWidgets/CustomColorDialog.qml \
    qml/CustomWidgets/CustomColorDialogContent/Checkboard.qml \
    qml/CustomWidgets/CustomColorDialogContent/ColorSlider.qml \
    qml/CustomWidgets/CustomColorDialogContent/NumberBox.qml \
    qml/CustomWidgets/CustomColorDialogContent/PanelBorder.qml \
    qml/CustomWidgets/CustomColorDialogContent/SBPicker.qml \
    qml/ExternalWindows/WelcomeWin.qml \
    qml/ExternalWindows/SettingsWin.qml \
    qml/ExternalWindows/SettingsTab.qml \
    qml/ExternalWindows/AppearanceTab.qml \
    qml/ExternalWindows/AboutWin.qml \
    qml/ExtraInfoPannel.qml \
    qml/Content.qml \
    qml/Header.qml \
    qml/main.qml

RESOURCES += \
    resources_media.qrc \
    resources_qml.qrc

# Linux THIRD PARTY Libs
# Add custom openssl 1.1.1 libraries to the build to avoid QNetworkManager issues
# in case system has an older 1.0.X version
unix {
    INCLUDEPATH += 3rdparty/openssl1.1.1
    LIBS += -L"3rdparty/openssl1.1.1" -lcrypto -lssl
    copydata.commands = $(COPY_DIR) $$PWD/3rdparty/ $$OUT_PWD
    first.depends = $(first) copydata
    export(first.depends)
    export(copydata.commands)
    message("DEBUG: Folder" $$PWD/3rdparty/openssl1.1.1 "will be copied to" $$OUT_PWD)
    QMAKE_EXTRA_TARGETS += first copydata
}

# Win Icon
win32:RC_ICONS += resources/Drawer.ico
