import QtQuick 2.14
import QtQuick.Window 2.3

import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.0

import QtQuick.Layouts 1.3

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0
import MouseProvider 1.0

// Import other project QML scripts
import "CustomWidgets"

// App Window
ApplicationWindow
{
    id: root

    // Design
    property int fontPixelSize:         14
    property color fontColor:           Qt.rgba(242/255, 242/255, 242/255, 1)
    property color appWindowColor:      Qt.rgba(30/255, 30/255, 30/255, 1)
    property color appSectionColor:     Qt.rgba(93/255, 99/255, 99/255, 1)
    property int buttonSize: 15
    property real heightFactor: 0.10
    property int margins: 10

    // Windows Configuration
    x: 0
    y:  Screen.height * (1.0 - heightFactor)
    width: Screen.width
    height: Screen.height - y
    color: "transparent"
    visible: true
    title: qsTr(Constants.appTitle)
    menuBar: MenuBar{ visible: false }  // Remove MenuBar
    flags:   Qt.Window                  // Force app to be a Window and not a Popup
           | Qt.FramelessWindowHint     // Remove TitleBar
           | Qt.WindowStaysOnTopHint    // Always on top

    // Manage the app starup
    Component.onCompleted:
    {
        // nothing for now
        //console.log("verticalMargin: " + verticalMargin)
        //console.log("horizontalMargin: " + horizontalMargin)
    }

    // A FramelessWindow has not handlers to resize it. Adding one at the top
    // Reference: https://evileg.com/en/post/280/
    property int previousX
    property int previousY
    MouseArea
    {
        id: topArea
        height: 20
        anchors
        {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        // We set the shape of the cursor so that it is clear that this resizing
        cursorShape: Qt.SizeVerCursor

        onPressed:
        {
            // We memorize the position along the Y axis
            previousY = mouseY
        }

        // When changing a position, we recalculate the position of the window, and its height
        onMouseYChanged:
        {
            //var dy = mouseY - previousY
            //root.y = root.y + dy
            //root.height = Screen.height - root.y

            root.y = MouseProvider.cursorPos().y
            root.height = Screen.height - root.y
        }
    }

    /*
        CONTENTS
    */
    Rectangle
    {
        id: appBackground
        visible: true
        anchors.fill: parent
        color: appWindowColor
        radius: 10

        // Window Buttons
        Rectangle
        {
            id: winButtonsRect
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: margins
            anchors.rightMargin: margins
            color: "transparent"
            width: buttonSize * 3 + margins*2
            height: buttonSize
            Row
            {
                id: winButtonsRow
                spacing: margins
                anchors.centerIn: parent

                // Settings
                CustomButton2
                {
                    id: winButtonMinimize
                    anchors.verticalCenter: parent.verticalCenter
                    width: buttonSize
                    height: buttonSize
                    imgSizeFactor: 1.0
                    imgOpacity: 1.0
                    image_url: "qrc:/resources/decrement.svg"
                    onClickedChanged:
                    {
                        if(clicked)
                        {
                            clicked = false
                            root.showMinimized()
                        }
                    }
                }

                // Settings
                CustomButton2
                {
                    id: winButtonSettings
                    anchors.verticalCenter: parent.verticalCenter
                    width: buttonSize
                    height: buttonSize
                    imgSizeFactor: 1.0
                    imgOpacity: 1.0
                    image_url: "qrc:/resources/settings.svg"
                    onClickedChanged:
                    {
                        if(clicked)
                        {
                            clicked = false
                            //fileDialog.visible = true
                        }
                    }
                }

                // Exit
                CustomButton2
                {
                    id: winButtonsExit
                    anchors.verticalCenter: parent.verticalCenter
                    width: buttonSize
                    height: buttonSize
                    imgSizeFactor: 1.0
                    imgOpacity: 1.0
                    image_url: "qrc:/resources/cancel.svg"
                    onClickedChanged:
                    {
                        if(clicked)
                        {
                            clicked = false
                            root.close()    // close the entire app
                        }
                    }
                }
            }//row
        }//window buttons

        //  Window Content
        Rectangle
        {
            id: contentRect
            anchors.top: winButtonsRect.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: margins
            anchors.bottomMargin: margins
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2*margins
            color: "transparent"

            Row
            {
                id: contentRow
                anchors.centerIn: parent
                spacing: 10

                Rectangle
                {
                    id: inputTextRect
                    width: contentRect.width/2 - contentRow.spacing/2
                    height: contentRect.height
                    color: appSectionColor
                    radius: 10

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

                        text: DataManager.inputText

                        onTextChanged:
                        {
                            if(text !== DataManager.inputText)
                                DataManager.setInputText(text)
                        }

                        //placeholderText: 'Write here your text ...' // It seems doesn't work properly on Win10
                        property string placeholderTextFixed: 'Write here your text ...'
                        Text
                        {
                            id: placeHolderInputText
                            anchors.centerIn: parent
                            font.pixelSize: fontPixelSize
                            font.italic: true
                            color: fontColor
                            opacity: parent.opacity * 0.5
                            text: inputText.placeholderTextFixed
                            visible: !inputText.text
                        }
                    }
                }

                Rectangle
                {
                    id: outputTextRect
                    width: contentRect.width/2 - contentRow.spacing/2
                    height: contentRect.height
                    color: appSectionColor
                    radius: 10

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

                        //placeholderText: 'Write here your text ...' // It seems doesn't work properly on Win10
                        property string placeholderTextFixed: 'Translation result will be shown here ...'
                        Text
                        {
                            id: placeHolderOutputText
                            anchors.centerIn: parent
                            font.pixelSize: fontPixelSize
                            font.italic: true
                            color: fontColor
                            opacity: parent.opacity * 0.5
                            text: outputText.placeholderTextFixed
                            visible: !outputText.text
                        }
                    }
                }
            }
        }
    }//background

    /*
        EXTERNAL WINDOWS
    */
}
