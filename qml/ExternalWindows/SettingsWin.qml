import QtQuick 2.14
import QtQuick.Window 2.3
import QtQuick.Controls 2.14

// Import other project QML scripts
import "../CustomWidgets"

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0

Window
{
    id: root

    // Disable the parent window edition
    modality: Qt.WindowModal

    property int buttonSize: 15
    property int fontPixelSize: 10
    property color fontColor: "white"
    property color backgroundColor: "white"
    property color comboBoxColor: "black"
    property color editableSpaceColor: "black"
    property color buttonUnpressedColor: "lightgray"
    property color buttonPressedColor: "yellow"
    property int margins: 30

    property int widthColum1: 250
    property int widthColum2: 250
    property int heightColumns: 30

    property double unhoveredOpacity: 0.75

    // Set the current settings values
    onVisibleChanged:
    {
        if(visible)
        {
            // Update current settings
            translatorEngine.currentIndex = translatorEngine.find(DataManager.settings.translatorEngine)
            googleApiKey.text = DataManager.settings.googleApiKey
            sourceLang.currentIndex = sourceLang.find("[" + DataManager.settings.sourceLang + "]", Qt.MatchContains)
            targetLang.currentIndex = targetLang.find("[" + DataManager.settings.targetLang + "]", Qt.MatchContains)
            onSelection.checked = DataManager.settings.translateOnSelection
            onCopy.checked = DataManager.settings.translateOnCopy
            borderLess.checked = DataManager.settings.framelessWin
            autoHide.checked = DataManager.settings.autoHideWin
        }
    }

    // Content
    Rectangle
    {
        id: background
        color: backgroundColor
        anchors.fill: parent
        anchors.centerIn: parent

        Rectangle
        {
            id: contentItem
            color: "transparent"
            anchors.centerIn: parent
            width: background.width - 2*margins
            height: background.height - 2*margins


            Column
            {
                id: column
                anchors.centerIn: parent
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
                        font.pixelSize: fontPixelSize * 1.2
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
                            onCurrentTextChanged:
                            {
                                // Call to update available languages
                                DataManager.updateAvailableLanguageCode(translatorEngine.currentText)
                            }
                            onHoveredChanged:
                            {
                                parent.opacity = hovered? 1.0 : unhoveredOpacity
                            }
                        }
                    }
                }

                // API Key
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
                            text: "    API Key:"
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
                        font.pixelSize: fontPixelSize * 1.2
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
                            anchors.centerIn: parent
                            box_width: buttonSize/2
                            border_color: hovered? "black" : "transparent"
                            border_width: 1
                            tool_tip:  "Enable translate selected text directly"
                        }
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
                        font.pixelSize: fontPixelSize * 1.2
                        font.bold: true
                        color: fontColor
                        text: "Window"
                    }
                }

                // FrameLess
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
                            text: "    Borderless (restart required): "
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
                            id: borderLess
                            anchors.centerIn: parent
                            box_width: buttonSize/2
                            border_color: hovered? "black" : "transparent"
                            border_width: 1
                            tool_tip:  "Disable the OS window frame"
                        }
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
                    }
                }

                // Some Space
                Rectangle
                {
                    id: whiteSpace
                    height: 10
                    width: 1
                    color: "transparent"
                }

                // Accept/Decline buttons
                Row
                {
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    spacing: 5

                    CustomButton
                    {
                        id: acceptButton
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonSize
                        height: buttonSize
                        imgSizeFactor: 0.7

                        pressedColor: buttonPressedColor
                        unpressedColor: buttonUnpressedColor
                        hoveredColor: comboBoxColor
                        image_url: "qrc:/resources/accept.svg"

                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                console.log("Setting new configuration")
                                DataManager.settings.setTranslatorEngine(translatorEngine.currentText)
                                DataManager.settings.setGoogleApiKey(googleApiKey.text)
                                DataManager.settings.setTranslateOnSelection(onSelection.checked)
                                DataManager.settings.setTranslateOnCopy(onCopy.checked)
                                DataManager.setSourceLanguage(sourceLang.currentText)
                                DataManager.setTargetLanguage(targetLang.currentText)
                                DataManager.settings.setFramelessWin(borderLess.checked)
                                DataManager.settings.setAutoHideWin(autoHide.checked)
                                root.visible = false
                            }
                        }
                    }
                    CustomButton
                    {
                        id: cancelButton
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonSize
                        height: buttonSize
                        imgSizeFactor: 0.5

                        pressedColor: buttonPressedColor
                        unpressedColor: buttonUnpressedColor
                        hoveredColor: comboBoxColor
                        image_url: "qrc:/resources/cancel.svg"

                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                console.log("Canceling settings change")
                                root.visible = false
                            }
                        }
                    }
                }//row
            }//column
        }//contentItem

    }//background

    // Keyboard Control
    Item
    {
        anchors.fill: parent
        focus: true
        Keys.onPressed:
        {
            if (event.key === Qt.Key_Escape)
            {
                cancelButton.clicked= true
                event.accepted = true;
            }
            if (event.key === Qt.Key_Enter)
            {
                acceptButton.clicked = true
                event.accepted = true;
            }
        }
    }
}//win
