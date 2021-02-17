import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
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

    // Signals to be processed by parent
    signal inputTextChanged()
    signal sectionHoveredChanged(bool hovered)
    signal sectionPressed()

    Row
    {
        id: contentRow
        anchors.centerIn: parent
        spacing: 10
        clip: true

        Rectangle
        {
            id: inputTextRect
            width: contentRect.width/2 - contentRow.spacing/2
            height: contentRect.height
            color: sectionsColor
            radius: 10
            clip: true
            border.width: inputText.hovered?1:0
            border.color: sectionsBordersColor

            TextArea
            {
                id: inputText
                anchors.fill: parent
                background: Rectangle { color: "transparent" }
                color: fontColor
                font.pixelSize: fontPixelSize
                horizontalAlignment: TextInput.AlignHCenter
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
                width: parent.width
                anchors.centerIn: parent
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
        }

        Rectangle
        {
            id: outputTextRect
            width: contentRect.width/2 - contentRow.spacing/2
            height: contentRect.height
            color: sectionsColor
            radius: 10
            clip: true

            border.width: outputText.hovered?1:0
            border.color: sectionsBordersColor

            TextArea
            {
                id: outputText
                anchors.fill: parent
                background: Rectangle { color: "transparent" }
                color: fontColor
                font.pixelSize: fontPixelSize
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                selectByMouse: true
                wrapMode: TextEdit.Wrap

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
                width: parent.width
                anchors.centerIn: parent
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
        }
    }
}

