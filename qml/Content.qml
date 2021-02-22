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
                border.width: inputTextSv.hovered || inputText.hovered? 2 : 0
                border.color: sectionsBordersColor

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

                // Extra Info
                ExtraInfoPannel
                {
                    id: extraInfoRect
                    visible: DataManager.translationExtraInfoVisible
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
                }
            }//outputTextRect

            // Force Border Overlay
            Rectangle
            {
                id: outputTextRectBorders
                visible: !extraInfoRect.shown
                anchors.fill: outputTextRect
                border.width: outputTextSv.hovered || outputText.hovered || extraInfoRect.hovered ? 2 : 0
                border.color: sectionsBordersColor
                color: "transparent"
                radius: outputTextRect.radius
            }
        }//view2
    }//splitview
}

