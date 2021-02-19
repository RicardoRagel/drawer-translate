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
    id: contentRect

    property int fontPixelSize: 14
    property color fontColor: "black"
    property color sectionsColor: "white"
    property color sectionsBordersColor: "gray"
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
            width: contentRect.width/2

            color: "transparent"

            Rectangle
            {
                id: inputTextRect
                height: contentRect.height
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - margins/2
                anchors.left: parent.left
                color: sectionsColor
                radius: 10
                clip: true
                border.width: inputText.hovered? 2 : 0
                border.color: sectionsBordersColor

                ScrollView
                {
                    anchors.centerIn: parent
                    height: inputTextRect.height
                    width: inputTextRect.width
                    clip: true
                    TextArea
                    {
                        id: inputText
                        height: inputTextRect.height
                        width: inputTextRect.width
                        padding: fontPixelSize
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
                height: contentRect.height
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - margins/2
                anchors.right: parent.right
                color: sectionsColor
                radius: 10
                clip: true
                border.width: outputText.hovered || extraInfoButton.hovered ? 2 : 0
                border.color: sectionsBordersColor

                ScrollView
                {
                    anchors.fill: parent
                    height: outputTextRect.height
                    width: outputTextRect.width
                    clip: true
                    TextArea
                    {
                        id: outputText
                        height: outputTextRect.height
                        width: outputTextRect.width
                        padding: fontPixelSize
                        background: Rectangle { color: "transparent" }
                        color: fontColor
                        font.pixelSize: fontPixelSize
                        horizontalAlignment: lineCount > 1 ? TextInput.AlignLeft : TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        wrapMode: TextEdit.Wrap
                        clip: true

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

                Rectangle
                {
                    id: extraInfoButtonRect
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    radius: parent.radius
                    height: 7
                    clip: true
                    color: Qt.rgba(150/255, 150/255, 150/255, 1.0)

                    CustomButton2
                    {
                        id: extraInfoButton
                        visible: true //TODO change by a DataManager variable true when extra info
                        width: 50
                        height: 7
                        radius: 5
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        image_url: "qrc:/resources/arrow_up.svg"
                        buttonColor: Qt.rgba(200/255, 200/255, 200/255, 1.0)
                        buttonHoveredColor:  Qt.rgba(220/255, 220/255, 220/255, 1.0)
                        buttonPresedColor: Qt.rgba(240/255, 240/255, 240/255, 1.0)
                    }
                }
            }
        }//view2
    }//splitview
}

