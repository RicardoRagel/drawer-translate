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
import "ExternalWindows"

// App Window
ApplicationWindow
{
    id: root

    // Design
    property int fontPixelSize: 14
    property int buttonSize:    20
    property int buttonSize2:   30
    property color fontColor:               Qt.rgba(242/255, 242/255, 242/255, 1)
    property color appWindowColor:          Qt.rgba(30/255, 30/255, 30/255, 1)
    property color appSectionColor:         Qt.rgba(93/255, 99/255, 99/255, 1)
    property color appSectionBorderColor:   Qt.rgba(150/255, 150/255, 150/255, 1)
    property color appEditableSpaceColor:   Qt.rgba(93/255, 99/255, 99/255, 1)
    property color appButtonUnpressedColor: Qt.rgba(110/255, 110/255, 110/255, 1)
    property color appButtonPressedColor:   Qt.rgba(80/255, 80/255, 80/255, 1)
    property real heightFactor: 0.10
    property int margins: 10
    property int forceMinimumHeight: buttonSize + margins * 2

    // Windows Configuration
    x: Screen.width - Screen.desktopAvailableWidth > 0? Screen.width - Screen.desktopAvailableWidth : 0
    //x: 0
    width: Screen.desktopAvailableWidth
    y:  Qt.platform.os === "windows"?Screen.desktopAvailableHeight * (1.0 - heightFactor):Screen.height * (1.0 - heightFactor)
    height: Qt.platform.os === "windows"?Screen.desktopAvailableHeight * (heightFactor):Screen.height * (heightFactor)
    minimumHeight: forceMinimumHeight
    color: "transparent"
    visible: false
    title: qsTr(Constants.appTitle)
    menuBar: MenuBar{ visible: false }  // Remove MenuBar
    flags:  DataManager.framelessWinOnStartup?
                Qt.Window
                | Qt.FramelessWindowHint        // Frameless window
                | Qt.WindowStaysOnTopHint       // Always on top
                | Qt.X11BypassWindowManagerHint // Avoid flickering in Linux
            :   flags

    // Manage the app starup, fixing some issues found for multiple monitors:
    // the problem is Screen.desktopAvailableWidth doesn't take in account the
    // lateral taskbar width if multiple monitors are present and the app window
    // is Qt.FramelessWindowHint. This timer will be stopped as soon as user presses
    // on the input text field
    Component.onCompleted:
    {
        if(Screen.desktopAvailableWidth > Screen.width)
        {
            fixMultipleMonitorIssueTimer.running = true
        }
        else
            root.visible = true
    }
    Timer
    {
        id: fixMultipleMonitorIssueTimer
        interval: 100
        running: false
        repeat: true
        onTriggered:
        {
            if(!root.visible)
            {
                root.visible = true
            }
            else
            {
                if(root.width > Screen.width)
                {
                    root.width = root.width - Screen.width
                }
            }
        }
    }

    // A FramelessWindow has not handlers to resize it. Adding one at the top
    // Reference: https://evileg.com/en/post/280/
    property int previousX
    property int previousY
    MouseArea
    {
        id: topArea
        height: 20
        enabled: DataManager.framelessWinOnStartup

        anchors
        {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        // We set the shape of the cursor so that it is clear that this resizing
        cursorShape: enabled?Qt.SizeVerCursor:Qt.ArrowCursor

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

            var new_height = Qt.platform.os === "windows"?Screen.desktopAvailableHeight - MouseProvider.cursorPos().y:Screen.height - MouseProvider.cursorPos().y

            if(new_height > forceMinimumHeight)
            {
                root.y = MouseProvider.cursorPos().y
                root.height = new_height
            }
        }
    }

    // Some contents opacity controller
    property double contentsOpacity: 1.0
    property double maxHop: 2.25 * root.minimumHeight
    property double minHop: 1.25 * root.minimumHeight
    onHeightChanged:
    {
        contentsOpacity = root.height > maxHop? 1.0 : (root.height - minHop)/ (maxHop - minHop)
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


        // Window Header
        Rectangle
        {
            id: headerRect
            anchors.top: parent.top
            anchors.topMargin: margins
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            width: parent.width - 2*margins
            height: buttonSize

            // Source Language Indicator and button
            CustomButton2
            {
                id: sourceLangTagButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: margins
                width: buttonSize2
                height: buttonSize
                text: DataManager.settings.sourceLang
                textColor: fontColor
                textSize: fontPixelSize
                textAllUppercase: true
                textBold: true
                opacity: contentsOpacity
                onClickedChanged:
                {
                    if(clicked)
                    {
                        clicked = false
                        settingsWindow.visible = true
                    }
                }
            }

            // Target Language Indicator and button
            CustomButton2
            {
                id: targetLangTagButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: margins + headerRect.width/2
                width: buttonSize2
                height: buttonSize
                text: DataManager.settings.targetLang
                textColor: fontColor
                textSize: fontPixelSize
                textAllUppercase: true
                textBold: true
                opacity: contentsOpacity
                onClickedChanged:
                {
                    if(clicked)
                    {
                        clicked = false
                        settingsWindow.visible = true
                    }
                }
            }

            // Buttons
            Rectangle
            {
                id: buttonsRect
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: margins
                color: "transparent"
                width: buttonSize2 * 3
                height: parent.height
                Row
                {
                    id: winButtonsRow
                    spacing: 0
                    anchors.centerIn: parent

                    // Settings
                    CustomButton2
                    {
                        id: winButtonMinimize
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonSize2
                        height: buttonSize
                        imgSizeFactor: 0.6
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
                        width: buttonSize2
                        height: buttonSize
                        imgSizeFactor: 0.6
                        imgOpacity: 1.0
                        image_url: "qrc:/resources/settings.svg"
                        onClickedChanged:
                        {
                            console.log("Width " + root.width)
                            if(clicked)
                            {
                                clicked = false
                                settingsWindow.visible = true
                            }
                        }
                    }

                    // Exit
                    CustomButton2
                    {
                        id: winButtonsExit
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonSize2
                        height: buttonSize
                        imgSizeFactor: 0.6
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
        }
        //  Window Content
        Rectangle
        {
            id: contentRect
            anchors.top: headerRect.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: margins
            anchors.bottomMargin: margins
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2*margins
            color: "transparent"
            clip: true
            opacity: contentsOpacity

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
                    color: appSectionColor
                    radius: 10
                    clip: true
                    border.width: inputText.hovered?1:0
                    border.color: appSectionBorderColor

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
                        }

                        onPressed:
                        {
                            // stop the dummy timer
                            fixMultipleMonitorIssueTimer.running = false
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
                    color: appSectionColor
                    radius: 10
                    clip: true

                    border.width: outputText.hovered?1:0
                    border.color: appSectionBorderColor

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
    }//background

    /*
        EXTERNAL WINDOWS
    */
    SettingsWin
    {
        id: settingsWindow
        visible: false
        flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
        title: root.title + " - Settings"
        buttonSize: root.buttonSize2
        fontPixelSize: root.fontPixelSize
        fontColor: root.fontColor
        backgroundColor: root.appWindowColor
        editableSpaceColor: root.appEditableSpaceColor
        buttonUnpressedColor: root.appButtonUnpressedColor
        buttonPressedColor: root.appButtonPressedColor
        margins: root.margins
        Component.onCompleted:
        {
            width = 700
            height = 500
            x = Screen.width/2 - width/2
            y = Screen.height/2 - height/2
            minimumHeight = height
            maximumHeight = height
            minimumWidth = width
            maximumWidth = width
        }
    }
}
