import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls 1.4 as QQC14
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import QtQuick.Layouts 1.3

// Import C++ data handlers
import DataManager 1.0

// Import other project QML scripts
import "CustomWidgets"

Rectangle
{
    id: root

    property int fontPixelSize: 14
    property color fontColor: "black"
    property color sectionsColor: "white"
    property color sectionsBordersColor: "gray"
    property int buttonsWidth: 50
    property int buttonsHeight: 50
    property int margins: 10

    // Signals to be processed by parent
    signal inputTextChanged()
    signal sectionHoveredChanged(bool hovered)
    signal sectionPressed()

    // Horizontal Splitview
    QQC14.SplitView
    {
        id: appViews
        orientation: Qt.Horizontal
        anchors.fill: parent

        // Resize Handler
        handleDelegate: Rectangle
        {
            id: handle
            implicitWidth: 5
            implicitHeight: appViews.height
            color: "transparent"
            Rectangle
            {
                id: visual
                anchors.centerIn: parent
                width: 2; height: 10
                color: sectionsColor
                visible: false
            }
            HoverHandler
            {
                onHoveredChanged: { visual.visible = hovered }
            }
        }

        // Input Text View
        Rectangle
        {
            id: view1
            Layout.fillHeight: true
            Layout.minimumWidth: 250
            width: root.width/2

            color: "transparent"

            Rectangle
            {
                id: inputTextRect
                height: root.height
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - margins/2
                anchors.left: parent.left
                color: sectionsColor
                radius: 10
                clip: true
                border.width: inputTextSv.hovered || inputTextButtons.visible ? 2 : 0
                border.color: sectionsBordersColor

                // Translation on a Scrollview
                ScrollView
                {
                    id: inputTextSv
                    anchors.centerIn: parent
                    height: inputTextRect.height
                    width: inputTextRect.width
                    clip: true
                    TextArea
                    {
                        id: inputText
                        height: inputTextRect.height
                        width: inputTextRect.width
                        padding: 16
                        background: Rectangle { color: "transparent" }
                        color: fontColor
                        font.pixelSize: fontPixelSize
                        horizontalAlignment: lineCount > 1 ? TextInput.AlignLeft : TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        wrapMode: TextEdit.Wrap
                        clip: true

                        text: DataManager.inputText

                        onTextChanged:
                        {
                            if(text !== DataManager.inputText)
                                DataManager.setInputText(text)

                            inputTextChanged()
                        }

                        onHoveredChanged:
                        {
                            sectionHoveredChanged(hovered)
                        }

                        onPressed:
                        {
                            sectionPressed()
                        }

                        // It seems placeholderText doesn't work properly on Win10, adding placeHolderInputText
                        //placeholderText: 'Write here your text ...'
                        property string placeholderTextFixed: 'Write here your text ...'
                    }
                    Text
                    {
                        id: placeHolderInputText
                        width: inputTextRect.width
                        anchors.centerIn: inputText
                        font.pixelSize: fontPixelSize
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        font.italic: true
                        color: fontColor
                        opacity: inputText.opacity * 0.5
                        text: inputText.placeholderTextFixed
                        wrapMode: TextEdit.Wrap
                        //visible: !inputText.text
                        visible: !(inputText.text || inputText.activeFocus)
                    }
                }//scrollview

                // TTS Buttons
                Row
                {
                    id: inputTextButtons
                    visible: inputText.hovered || hearInputTextButton.hovered || hearInputShowCbBox.hovered || heartInputTextCbBox.enabled
                    spacing: 1
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: margins
                    anchors.bottomMargin: margins
                    z: parent.z + 10

                    CustomButton2
                    {
                        id: hearInputTextButton
                        visible: DataManager.ttsAvailableForSourceLang
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonsWidth
                        height: buttonsHeight
                        imgSizeFactor: 0.5
                        imgOpacity: hovered? 1.0 : 0.5
                        image_url: "qrc:/resources/speaker.svg"
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                DataManager.hearInputText(heartInputTextCbBox.currentText)
                            }
                        }
                    }

                    CustomButton2
                    {
                        id: hearInputShowCbBox
                        visible: DataManager.ttsAvailableForSourceLang
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonsHeight/2
                        height: buttonsHeight
                        imgSizeFactor: 0.5
                        imgOpacity: hovered? 1.0 : 0.5
                        image_url: "qrc:/resources/dots.svg"
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                heartInputTextCbBox.enabled = !heartInputTextCbBox.enabled
                            }
                        }
                    }

                    CustomComboBox
                    {
                        id: heartInputTextCbBox
                        enabled: false
                        visible: enabled && DataManager.ttsAvailableForSourceLang
                        height: buttonsHeight
                        width: buttonsWidth * 3
                        anchors.verticalCenter: parent.verticalCenter
                        backgroundColor: sectionsColor
                        textColor: fontColor
                        fontSize: fontPixelSize
                        dropDownMaxHeight: inputTextRect.height
                        dropDownArrowColor: fontColor
                        opacity: hovered? 1.0 : 0.5
                        handleWidth: 5
                        currentIndex: 0
                        textRole: "display"
                        model: DataManager.ttsSourceLanguageCodes
                        onHoveredChanged:
                        {
                            if(hovered)
                                backgroundColor = hearInputShowCbBox.buttonHoveredColor
                            else
                                backgroundColor = sectionsColor
                        }
                        Connections
                        {
                            target: DataManager
                            onTtsSourceLanguageCodesChanged: { heartInputTextCbBox.currentIndex = 0 }
                        }
                    }
                }
                Rectangle
                {
                    id: inputTextButtonsRowBkg
                    anchors.fill: inputTextButtons
                    z: inputTextButtons.z - 1
                    color: sectionsColor
                    visible: hearInputTextButton.hovered || hearInputShowCbBox.hovered || heartInputTextCbBox.enabled
                }
            }
        }

        // Output Text View
        Rectangle
        {
            id: view2

            Layout.fillHeight: true
            Layout.minimumWidth: 250
            Layout.fillWidth: true

            color: "transparent"

            Rectangle
            {
                id: outputTextRect
                height: root.height
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - margins/2
                anchors.right: parent.right
                color: sectionsColor
                radius: 10
                clip: true

                ScrollView
                {
                    id: outputTextSv
                    anchors.fill: parent
                    height: outputTextRect.height
                    width: outputTextRect.width
                    clip: true
                    TextArea
                    {
                        id: outputText
                        height: outputTextRect.height
                        width: outputTextRect.width
                        padding: 16
                        background: Rectangle { color: "transparent" }
                        color: fontColor
                        font.pixelSize: fontPixelSize
                        horizontalAlignment: lineCount > 1 ? TextInput.AlignLeft : TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        wrapMode: TextEdit.Wrap
                        clip: true
                        readOnly: true

                        text: DataManager.outputText

                        onHoveredChanged:
                        {
                            sectionHoveredChanged(hovered)
                        }

                        onPressed:
                        {
                            sectionPressed()
                        }

                        // It seems placeholderText doesn't work properly on Win10, adding placeHolderOutputText
                        //placeholderText: 'Write here your text ...
                        property string placeholderTextFixed: 'Translation result will be shown here ...'
                    }
                    Text
                    {
                        id: placeHolderOutputText
                        width: outputTextRect.width
                        anchors.centerIn: outputText
                        font.pixelSize: fontPixelSize
                        font.italic: true
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        color: fontColor
                        opacity: outputText.opacity * 0.5
                        text: outputText.placeholderTextFixed
                        wrapMode: TextEdit.Wrap
                        //visible: !outputText.text
                        visible: !(outputText.text || outputText.activeFocus)
                    }
                }//scrollview

                // TTS Buttons
                Row
                {
                    id: outputTextButtons
                    visible: outputText.hovered || hearOutputTextButton.hovered || hearOutputShowCbBox.hovered || heartOutputTextCbBox.enabled
                    spacing: 1
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: margins
                    anchors.bottomMargin: margins
                    z: parent.z + 10

                    CustomButton2
                    {
                        id: hearOutputTextButton
                        visible: DataManager.ttsAvailableForTargetLang
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonsWidth
                        height: buttonsHeight
                        imgSizeFactor: 0.5
                        imgOpacity: hovered? 1.0 : 0.5
                        image_url: "qrc:/resources/speaker.svg"
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                DataManager.hearOutputText(heartOutputTextCbBox.currentText)
                            }
                        }
                    }
                    CustomButton2
                    {
                        id: hearOutputShowCbBox
                        visible: DataManager.ttsAvailableForTargetLang
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonsHeight/2
                        height: buttonsHeight
                        imgSizeFactor: 0.5
                        imgOpacity: hovered? 1.0 : 0.5
                        image_url: "qrc:/resources/dots.svg"
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                heartOutputTextCbBox.enabled = !heartOutputTextCbBox.enabled
                            }
                        }
                    }

                    CustomComboBox
                    {
                        id: heartOutputTextCbBox
                        enabled: false
                        visible: enabled && DataManager.ttsAvailableForTargetLang
                        height: buttonsHeight
                        width: buttonsWidth * 3
                        anchors.verticalCenter: parent.verticalCenter
                        backgroundColor: sectionsColor
                        textColor: fontColor
                        fontSize: fontPixelSize
                        dropDownMaxHeight: outputTextRect.height
                        dropDownArrowColor: fontColor
                        opacity: hovered? 1.0 : 0.5
                        handleWidth: 5
                        currentIndex: 0
                        textRole: "display"
                        model: DataManager.ttsTargetLanguageCodes
                        onHoveredChanged:
                        {
                            if(hovered)
                                backgroundColor = hearOutputShowCbBox.buttonHoveredColor
                            else
                                backgroundColor = sectionsColor
                        }
                        Connections
                        {
                            target: DataManager
                            onTtsTargetLanguageCodesChanged: { heartOutputTextCbBox.currentIndex = 0 }
                        }
                    }
                }
                Rectangle
                {
                    id: outputTextButtonsRowBkg
                    anchors.fill: outputTextButtons
                    z: outputTextButtons.z - 1
                    color: sectionsColor
                    visible: hearOutputTextButton.hovered || hearOutputShowCbBox.hovered || heartOutputTextCbBox.enabled
                }

                // Extra Info
                ExtraInfoPannel
                {
                    id: extraInfoRect
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: (parent.height - 10) * topMarginFactor
                    height: parent.height
                    width: parent.width - (2 * parent.radius) * widthReductionFactor
                    radius: parent.radius
                    color: Qt.rgba(150/255, 150/255, 150/255, 1.0)
                    fontColor: "black"
                    fontPixelSize: root.fontPixelSize
                    margins: root.margins

                    // Visible if engine provides extra info and actually extra info exist
                    visible: DataManager.translationExtraInfoVisible && DataManager.translationExtraInfo.result !== ""

                    // Fordware app autohide hovering
                    onHoveredChanged:
                    {
                        sectionHoveredChanged(hovered)
                    }
                }
            }//outputTextRect

            // Force Border Overlay
            Rectangle
            {
                id: outputTextRectBorders
                visible: !extraInfoRect.shown
                anchors.fill: outputTextRect
                border.width: outputTextSv.hovered || outputText.hovered || extraInfoRect.hovered || hearOutputTextButton.hovered ? 2 : 0
                border.color: sectionsBordersColor
                color: "transparent"
                radius: outputTextRect.radius
            }
        }//view2
    }//splitview
}

