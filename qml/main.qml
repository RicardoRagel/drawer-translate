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
    property int fontPixelSize: DataManager.settings.fontSize
    property int buttonSize:    20
    property int buttonSize2:   30
    property color fontColor:               Qt.rgba(242/255, 242/255, 242/255, 1)
    property color appWindowColor:          DataManager.settings.backgroundColor
    property color appSectionColor:         Qt.rgba(93/255, 99/255, 99/255, 1)
    property color appSectionBorderColor:   Qt.rgba(150/255, 150/255, 150/255, 1)
    property color appEditableSpaceColor:   Qt.rgba(93/255, 99/255, 99/255, 1)
    property color appEditableSpaceColor2:  Qt.rgba(50/255, 50/255, 50/255, 1)
    property color appButtonUnpressedColor: Qt.rgba(110/255, 110/255, 110/255, 1)
    property color appButtonPressedColor:   Qt.rgba(80/255, 80/255, 80/255, 1)
    property real heightFactor: 0.15
    property int margins: 10
    property int forceMinimumHeight: buttonSize
    property int resizingMinimumHeight: buttonSize + 2 * margins

    // Windows Configuration
    title: qsTr(Constants.appTitle)
    visible: false
    color: "transparent"
    x: Screen.width - Screen.desktopAvailableWidth > 0? Screen.width - Screen.desktopAvailableWidth : 0
    width: Screen.desktopAvailableWidth
    property int targetHeight       // y and height are controlled by this property
    minimumHeight: forceMinimumHeight
    minimumWidth: 400
    menuBar: MenuBar{ visible: false }  // Remove MenuBar
    flags: Qt.Window
           | Qt.FramelessWindowHint        // Frameless window
           | Qt.WindowStaysOnTopHint       // Always on top
           //| Qt.X11BypassWindowManagerHint // Avoid flickering in Linux, but it disables keyboard inputs

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

        targetHeight = Qt.platform.os === "windows"?Screen.desktopAvailableHeight * (heightFactor):Screen.height * (heightFactor)
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
        hoverEnabled: true
        anchors
        {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        // We set the shape of the cursor so that it is clear that this resizing
        cursorShape: !appHidden? Qt.SizeVerCursor : Qt.ArrowCursor

        // When changing a position, we recalculate the position of the window, and its height
        onMouseYChanged:
        {
            if(pressed && !appHidden)
            {
                var tmptargetHeight = Qt.platform.os === "windows"? Screen.desktopAvailableHeight - MouseProvider.cursorPos().y : Screen.height - MouseProvider.cursorPos().y
                if(tmptargetHeight > resizingMinimumHeight)
                    targetHeight = tmptargetHeight
            }
        }

        onHoveredChanged:
        {
            // unhide
            if(DataManager.settings.autoHideWin && appHidden)
                showHide()

            // stop and start autoHide
            if(DataManager.settings.autoHideWin)
            {
                if(containsMouse)
                    autoHideTimer.running = false
                else
                    autoHideTimer.running = true
            }
        }
    }

    // Height controller
    onTargetHeightChanged:
    {
        // If the OS is Linux, check a minimum displacemnt to avoid flickering and/or flashing
        if(Qt.platform.os === "windows" || Math.abs(root.height - targetHeight) > 10)
        {
            if(targetHeight > forceMinimumHeight)
            {
                root.height = targetHeight
                root.y = Qt.platform.os === "windows"? Screen.desktopAvailableHeight - targetHeight : Screen.height - targetHeight
            }
        }
    }

    // AutoHide controller
    Timer
    {
        id: autoHideTimer
        interval: 5000
        running: DataManager.settings.autoHideWin
        repeat: true
        onTriggered:
        {
            console.log("AutoHide triggered!")
            if(!appHidden)
                showHide()
        }
    }
    Connections
    {
        target: DataManager.settings
        onAutoHideWinChanged:
        {
            if(DataManager.settings.autoHideWin)
            {
                autoHideTimer.running = true
            }
            else
            {
                autoHideTimer.running = false
            }
        }
    }

    // Hide App Functions
    property bool appHidden: false
    property int  unhideLastHeight
    property int hideAnimationDuration: 1000
    function showHide()
    {
        console.log("showHide() called")
        if(appHidden)
        {
            hideAnimationDuration = Math.abs(5 * (root.height - unhideLastHeight))
            unhideAnimation.running = true
            appHidden = false
        }
        else
        {
            unhideLastHeight = root.height
            hideAnimationDuration = Math.abs(5 * (root.height - root.minimumHeight))
            hideAnimation.running = true
            appHidden = true
        }
    }

    // Hide App Animations
    SequentialAnimation
    {
        id: hideAnimation
        running: false

        NumberAnimation
        {
            target: root;
            property: "contentsOpacity";
            to: 0.0;
            duration: 500
        }

        ParallelAnimation
        {
            NumberAnimation
            {
                target: headerRect;
                property: "top_margin";
                to: 0.0;
                duration: hideAnimationDuration
            }

            NumberAnimation
            {
                target: root;
                property: "targetHeight";
                to: root.minimumHeight;
                duration: hideAnimationDuration
            }
        }
    }
    SequentialAnimation
    {
        id: unhideAnimation
        running: false

        ParallelAnimation
        {
            NumberAnimation
            {
                target: root;
                property: "targetHeight";
                to: root.unhideLastHeight;
                duration: hideAnimationDuration
            }

            NumberAnimation
            {
                target: headerRect;
                property: "top_margin";
                to: root.margins;
                duration: hideAnimationDuration
            }
        }

        NumberAnimation
        {
            target: root;
            property: "contentsOpacity";
            to: 1.0;
            duration: 500
        }
    }

    // Contents opacity controller
    property double contentsOpacity: 1.0
//    property double maxHop: 2.25 * root.minimumHeight
//    property double minHop: 1.5 * root.minimumHeight
//    onHeightChanged:
//    {
//        contentsOpacity = root.height > maxHop? 1.0 : (root.height - minHop)/ (maxHop - minHop)
//    }

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
        Header
        {
            id: headerRect
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            width: parent.width
            height: buttonSize
            buttonsWidth: buttonSize2
            buttonsHeight: buttonSize
            top_margin: root.margins
            anchors.topMargin: top_margin
            fontColor: root.fontColor
            fontPixelSize: root.fontPixelSize
            contentsOpacity: root.contentsOpacity
            isHidden: appHidden

            onSeetingsButtonPressed: { settingsWindow.visible = true }
            onExitButtonPressed: { root.close() }
            onMinimizeButtonPressed: { root.showMinimized() }
            onHideButtonPressed: { root.showHide() }
        }//header

        //  Window Content
        Content
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
            sectionsColor: appSectionColor
            sectionsBordersColor: appSectionBorderColor
            fontColor: root.fontColor
            fontPixelSize: root.fontPixelSize
            buttonsWidth: buttonSize2
            buttonsHeight: buttonSize2
            margins: root.margins

            onInputTextChanged:
            {
                // Control autoHide
                if(appHidden)
                {
                    showHide()
                }
                if(DataManager.settings.autoHideWin && autoHideTimer.running)
                    autoHideTimer.restart()
            }

            onSectionHoveredChanged:
            {
                // Control autoHide
                if(DataManager.settings.autoHideWin)
                {
                    if(hovered)
                        autoHideTimer.running = false
                    else
                        autoHideTimer.running = true
                }
            }

            onSectionPressed:
            {
                // stop the dummy timer
                fixMultipleMonitorIssueTimer.running = false
            }
        }//content

        // Do not round app at the bottom
        Rectangle
        {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.radius
            z: parent.z - 1
            color: parent.color
        }
    }//appBackground

    /*
        EXTERNAL WINDOWS
    */
    SettingsWin
    {
        id: settingsWindow
        visible: false
        title: root.title + " - Settings"
        buttonSize: root.buttonSize2
        fontPixelSize: root.fontPixelSize
        fontColor: root.fontColor
        backgroundColor: root.appWindowColor
        comboBoxColor: root.appEditableSpaceColor
        editableSpaceColor: root.appEditableSpaceColor2
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

        onVisibleChanged:
        {
            // Control autoHide
            if(DataManager.settings.autoHideWin)
            {
                if(visible)
                    autoHideTimer.running = false
                else
                    autoHideTimer.running = true
            }
        }
    }
}
