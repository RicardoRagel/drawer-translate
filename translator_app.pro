QT += widgets qml quick network # Others usual: 3dinput positioning svg multimedia gamepad
CONFIG += c++17         # C++ Version
CONFIG += qml_debug     # Enable QML console debug
#CONFIG += resources_big # Set this flag if your resources are big and cause a compilation error

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
    include/DataLayer/TranslationExtraInfo.h \
    include/DataLayer/TranslatorAPIs/GoogleTranslatorApi.h \
    include/DataLayer/TranslatorAPIs/MyMemoryTranslatorApi.h \
    include/Utils/CursorPosProvider.h \
    include/Utils/LanguageISOCodes.h

SOURCES += \
    src/Core/TranslatorApp.cpp \
    src/DataLayer/DataManager.cpp \
    src/DataLayer/Settings.cpp \
    src/DataLayer/TranslationExtraInfo.cpp \
    src/DataLayer/TranslatorAPIs/GoogleTranslatorApi.cpp \
    src/DataLayer/TranslatorAPIs/MyMemoryTranslatorApi.cpp \
    src/Utils/LanguageISOCodes.cpp \
    src/main.cpp

OTHER_FILES += \
    qml/CustomWidgets/CustomButton.qml \
    qml/CustomWidgets/CustomButton2.qml \
    qml/CustomWidgets/CustomCheckBox.qml \
    qml/CustomWidgets/CustomComboBox.qml \
    qml/CustomWidgets/CustomScrollView.qml \
    qml/ExternalWindows/SettingsWin.qml \
    qml/ExtraInfoPannel.qml \
    qml/Content.qml \
    qml/Header.qml \
    qml/main.qml

RESOURCES += \
    translator_app_media.qrc \
    translator_app_qml.qrc
