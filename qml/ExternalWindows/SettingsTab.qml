import QtQuick 2.14
import QtQuick.Controls 2.14

// Import other project QML scripts
import "../CustomWidgets"

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0

Rectangle
{
    id: root
    color: "transparent"

    property int buttonSize: 15
    property int heightColumns: 10
    property int widthColum1: 100
    property int widthColum2: 100
    property int fontPixelSize: 12
    property color fontColor: "white"
    property color comboBoxColor: "black"
    property color editableSpaceColor: "black"

    property string lastSourceLanguage: ""
    property string lastTargetLanguage: ""

    property double unhoveredOpacity: 0.75

    // Restore values from settings backend
    function cancelAll()
    {
        translatorEngine.currentIndex = translatorEngine.find(DataManager.settings.translatorEngine)
        sourceLang.currentIndex = sourceLang.find("[" + DataManager.settings.sourceLang + "]", Qt.MatchContains)
        targetLang.currentIndex = targetLang.find("[" + DataManager.settings.targetLang + "]", Qt.MatchContains)
        googleApiKey.text = DataManager.settings.googleApiKey
        email.text = DataManager.settings.email
        onSelection.checked = DataManager.settings.translateOnSelection
        onCopy.checked = DataManager.settings.translateOnCopy
        autoHide.checked = DataManager.settings.autoHideWin
        welcomeWin.checked = DataManager.settings.welcomeWinVisible
    }

    // Set values to settings backend
    function saveAll()
    {
        if(translatorEngine.currentText !== DataManager.settings.translatorEngine)
            DataManager.settings.setTranslatorEngine(translatorEngine.currentText)

        DataManager.setSourceLanguage(sourceLang.currentText)
        DataManager.setTargetLanguage(targetLang.currentText)

        if(googleApiKey.text !== DataManager.settings.googleApiKey)
            DataManager.settings.setGoogleApiKey(googleApiKey.text)
        if(email.text !== DataManager.settings.email)
            DataManager.settings.setEmail(email.text)
        if(onSelection.checked !== DataManager.settings.translateOnSelection)
            DataManager.settings.setTranslateOnSelection(onSelection.checked)
        if(onCopy.checked !== DataManager.settings.translateOnCopy)
            DataManager.settings.setTranslateOnCopy(onCopy.checked)
        if(autoHide.checked !== DataManager.settings.autoHideWin)
            DataManager.settings.setAutoHideWin(autoHide.checked)
        if(welcomeWin.checked !== DataManager.settings.welcomeWinVisible)
            DataManager.settings.setWelcomeWinVisible(welcomeWin.checked)
    }

    // Column of settings
    Column
    {
        id: columnSettings
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: heightColumns/2
        spacing: 5

        // SECTION - Translation
        Rectangle
        {
            anchors.left: parent.left
            width: widthColum1 + widthColum2
            height: heightColumns
            color: "transparent"

            Text
            {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: fontPixelSize * 1.1
                font.bold: true
                color: fontColor
                text: "Translation"
            }
        }

        // Translator Engines
        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    Engine:"
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: comboBoxColor
                opacity: unhoveredOpacity

                CustomComboBox
                {
                    id: translatorEngine
                    height: parent.height
                    width: parent.width
                    anchors.centerIn: parent
                    backgroundColor: "transparent"
                    textColor: fontColor
                    fontSize: fontPixelSize
                    dropDownMaxHeight: root.height/2
                    dropDownArrowColor: backgroundColor
                    currentIndex: 0
                    textRole: "display"
                    model: DataManager.translatorEngines
                    Connections
                    {
                        target: DataManager.settings

                        onTranslatorEngineChanged:
                        {
                            translatorEngine.currentIndex = translatorEngine.find(DataManager.settings.translatorEngine)
                            console.log("Updating translation engine to: " + DataManager.settings.translatorEngine + ", " + translatorEngine.currentIndex)
                        }
                    }

                    onCurrentTextChanged:
                    {
                        // Save last languages to set the same if the languages lists are updated (engine changed)
                        lastSourceLanguage = sourceLang.currentText
                        lastTargetLanguage = targetLang.currentText

                        // Call to update available languages
                        if(root.visible)
                            DataManager.updateAvailableLanguageCode(translatorEngine.currentText)
                    }
                    onHoveredChanged:
                    {
                        parent.opacity = hovered? 1.0 : unhoveredOpacity
                    }
                }

                // Info button
                CustomButton2
                {
                    id: infoButton
                    visible: translatorEngine.currentIndex >= 0? true : false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    width: parent.height
                    height: parent.height
                    radius: width
                    imgSizeFactor: 0.5
                    imgOpacity: hovered? 1.0 : 0.5
                    image_url: "qrc:/resources/info.svg"
                    onClickedChanged:
                    {
                        if(clicked)
                        {
                            clicked = false

                            if(translatorEngine.currentText === Constants.googleTranslateApiName)
                                Qt.openUrlExternally("https://cloud.google.com/translate");
                            else if(translatorEngine.currentText === Constants.libreTranslateApiName)
                                Qt.openUrlExternally("https://github.com/uav4geo/LibreTranslate/blob/main/README.md");
                            else if(translatorEngine.currentText === Constants.myMemoryTranslateApiName)
                                Qt.openUrlExternally("https://mymemory.translated.net/");
                            else if(translatorEngine.currentText === Constants.apertiumTranslateApiName)
                                Qt.openUrlExternally("https://wiki.apertium.org/wiki/Main_Page");
                        }
                    }
                }
            }
        }

        // Source Language
        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    Source Language:"
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: comboBoxColor
                opacity: unhoveredOpacity

                CustomComboBox
                {
                    id: sourceLang
                    height: parent.height
                    width: parent.width
                    anchors.centerIn: parent
                    backgroundColor: "transparent"
                    textColor: fontColor
                    fontSize: fontPixelSize
                    dropDownMaxHeight: root.height/2
                    dropDownArrowColor: backgroundColor
                    currentIndex: 0
                    textRole: "display"
                    model: DataManager.languageNamesAndCodes
                    onHoveredChanged:
                    {
                        parent.opacity = hovered? 1.0 : unhoveredOpacity
                    }
                }
                Connections
                {
                    target: DataManager.settings

                    onSourceLangChanged:
                    {
                        sourceLang.currentIndex = sourceLang.find("[" + DataManager.settings.sourceLang + "]", Qt.MatchContains)
                        console.log("Updating Source Language to: " + DataManager.settings.sourceLang + ", " + sourceLang.currentIndex)
                    }
                }
                Connections
                {
                    target: DataManager
                    onLanguageNamesAndCodesChanged:
                    {
                        console.log("Setting source Language to the previous one: " + lastSourceLanguage)
                        sourceLang.currentIndex = sourceLang.find(lastSourceLanguage)
                    }
                }
            }
        }

        // Target Language
        Row
        {
            id: targetLangRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    Target Language:"
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: comboBoxColor
                opacity: unhoveredOpacity

                CustomComboBox
                {
                    id: targetLang
                    height: parent.height
                    width: parent.width
                    anchors.centerIn: parent
                    backgroundColor: "transparent"
                    textColor: fontColor
                    fontSize: fontPixelSize
                    dropDownMaxHeight: root.height/2
                    dropDownArrowColor: backgroundColor
                    currentIndex: 0
                    textRole: "display"
                    model: DataManager.languageNamesAndCodes
                    onHoveredChanged:
                    {
                        parent.opacity = hovered? 1.0 : unhoveredOpacity
                    }
                }
                Connections
                {
                    target: DataManager.settings

                    onTargetLangChanged:
                    {
                        targetLang.currentIndex = targetLang.find("[" + DataManager.settings.targetLang + "]", Qt.MatchContains)
                        console.log("Updating Target Language to: " + DataManager.settings.targetLang + ", " + targetLang.currentIndex)
                    }
                }
                Connections
                {
                    target: DataManager
                    onLanguageNamesAndCodesChanged:
                    {
                        console.log("Setting target Language to the previous one: " + lastTargetLanguage)
                        targetLang.currentIndex = targetLang.find(lastTargetLanguage)
                    }
                }
            }
        }

        // API Key (Google Only)
        Row
        {
            visible: translatorEngine.currentText === Constants.googleTranslateApiName
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    API Key (required):"
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: editableSpaceColor
                opacity: unhoveredOpacity

                TextField
                {
                    id: googleApiKey
                    anchors.fill: parent
                    background: Rectangle { color: "transparent"}
                    font.pixelSize: fontPixelSize
                    color: fontColor
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true

                    onHoveredChanged:
                    {
                        parent.opacity = hovered? 1.0 : unhoveredOpacity
                    }
                }
                Connections
                {
                    target: DataManager.settings

                    onGoogleApiKeyChanged:
                    {
                        googleApiKey.text = DataManager.settings.googleApiKey
                        console.log("Updating Google API Key to: " + googleApiKey.text)
                    }
                }
            }
        }

        // Email (MyMemory Only)
        Row
        {
            visible: translatorEngine.currentText === Constants.myMemoryTranslateApiName
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    E-mail (Optional):"
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: editableSpaceColor
                opacity: unhoveredOpacity

                TextField
                {
                    id: email
                    anchors.fill: parent
                    background: Rectangle { color: "transparent"}
                    font.pixelSize: fontPixelSize
                    color: fontColor
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true

                    onHoveredChanged:
                    {
                        parent.opacity = hovered? 1.0 : unhoveredOpacity
                    }
                }
                Connections
                {
                    target: DataManager.settings

                    onEmailChanged:
                    {
                        email.text = DataManager.settings.email
                        console.log("Updating email to: " + email.text)
                    }
                }
            }
        }

        // SECTION - Input
        Rectangle
        {
            anchors.left: parent.left
            width: widthColum1 + widthColum2
            height: heightColumns
            color: "transparent"

            Text
            {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: fontPixelSize * 1.1
                font.bold: true
                color: fontColor
                text: "Input"
            }
        }

        // OnSelection
        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    On selection: "
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                CustomCheckBox
                {
                    id: onSelection
                    enabled: DataManager.clipboardSelectionSupported
                    box_color: enabled? "white" : "gray"
                    anchors.centerIn: parent
                    box_width: buttonSize/2
                    border_color: hovered? "black" : "transparent"
                    border_width: 1
                    tool_tip:  "Enable translate selected text directly"
                }
                Connections
                {
                    target: DataManager.settings

                    onTranslateOnSelectionChanged:
                    {
                        onSelection.checked = DataManager.settings.translateOnSelection
                        console.log("Updating onSelection: " + DataManager.settings.translateOnSelection)
                    }
                }
            }

        }

        // OnCopy
        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    On copy: "
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                CustomCheckBox
                {
                    id: onCopy
                    anchors.centerIn: parent
                    box_width: buttonSize/2
                    border_color: hovered? "black" : "transparent"
                    border_width: 1
                    tool_tip:  "Enable translate copied text directly"
                }
                Connections
                {
                    target: DataManager.settings

                    onTranslateOnCopyChanged:
                    {
                        onCopy.checked = DataManager.settings.translateOnCopy
                        console.log("Updating onCopy: " + DataManager.settings.translateOnCopy)
                    }
                }
            }
        }

        // SECTION - Window
        Rectangle
        {
            anchors.left: parent.left
            width: widthColum1 + widthColum2
            height: heightColumns
            color: "transparent"

            Text
            {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: fontPixelSize * 1.1
                font.bold: true
                color: fontColor
                text: "Window"
            }
        }

        // AutoHide
        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    Auto-hide: "
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                CustomCheckBox
                {
                    id: autoHide
                    anchors.centerIn: parent
                    box_width: buttonSize/2
                    border_color: hovered? "black" : "transparent"
                    border_width: 1
                    tool_tip:  "Auto-hide window in case of non-interaction"
                }
                Connections
                {
                    target: DataManager.settings

                    onAutoHideWinChanged:
                    {
                        autoHide.checked = DataManager.settings.autoHideWin
                        console.log("Updating Auto-Hide: " + DataManager.settings.autoHideWin)
                    }
                }
            }
        }

        // Welcome Window
        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum1
                height: heightColumns
                color: "transparent"

                Text
                {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontPixelSize
                    font.bold: false
                    color: fontColor
                    text: "    Show welcome window: "
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                CustomCheckBox
                {
                    id: welcomeWin
                    anchors.centerIn: parent
                    box_width: buttonSize/2
                    border_color: hovered? "black" : "transparent"
                    border_width: 1
                    tool_tip:  "Show the welcome window at startup"
                }
                Connections
                {
                    target: DataManager.settings

                    onWelcomeWinVisibleChanged:
                    {
                        welcomeWin.checked = DataManager.settings.welcomeWinVisible
                        console.log("Updating welcome win: " + DataManager.settings.welcomeWinVisible)
                    }
                }
            }
        }
    }//column
}
