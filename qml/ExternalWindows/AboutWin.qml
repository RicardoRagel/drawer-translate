import QtQuick 2.14
import QtQuick.Window 2.3
import QtQuick.Controls 2.14

// Import other project QML scripts
import "../CustomWidgets"

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0

Popup
{
    id: root

    property int buttonSize: 15
    property int fontPixelSize: 10
    property color fontColor: "white"
    property color backgroundColor: "white"
    property color buttonUnpressedColor: "lightgray"
    property color buttonPressedColor: "yellow"

    property int finalWidth: 250
    property int finalHeight: 250

    modal: true
    focus: true
    background: Rectangle
    {
        anchors.fill: parent
        color: backgroundColor
    }

    function open()
    {
        content.opacity = 0
        width = 1
        height = 4
        visible = true
        showThisWin.start()
    }

    // Show Animation
    SequentialAnimation
    {
        id: showThisWin
        running: false
        NumberAnimation
        {
            target: root
            property: "width"
            to: finalWidth
            duration: Qt.platform.os === "windows"? 2000 : 500
        }
        NumberAnimation
        {
            target: root
            property: "height"
            to: finalHeight
            duration: Qt.platform.os === "windows"? 500 : 500
        }
        NumberAnimation
        {
            target: content
            property: "opacity"
            to: 1.0
            duration: Qt.platform.os === "windows"? 500 : 500
        }
    }

    onVisibleChanged:
    {
        if(!visible)
        {
            showThisWin.stop()
            width = 1
            height = 4
            content.opacity = 0
        }
    }

    // Content (Caution: Popups have margins by default)
    Rectangle
    {
        id: content
        anchors.fill: parent
        color: "transparent"
    }
}//win
