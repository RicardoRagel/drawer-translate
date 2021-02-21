import QtQuick 2.14
import QtQuick.Controls 2.14

// Import C++ data handlers
import DataManager 1.0

// Import other project QML scripts
import "CustomWidgets"

// Extra Info
Rectangle
{
    id: root

    property int fontPixelSize: 14
    property color fontColor: "black"
    property bool shown: false
    property double topMarginFactor: 1.0
    property double widthReductionFactor: 1.0
    property bool hovered: false

    // Manage hover
    HoverHandler { onHoveredChanged: { parent.hovered = hovered } }

    // Show/hide Button
    CustomButton2
    {
        id: extraInfoButton
        visible: true //TODO change by a DataManager variable true when extra info
        width: 50
        height: 7
        radius: 5
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        image_url: root.shown? "qrc:/resources/arrow_down.svg":"qrc:/resources/arrow_up.svg"
        buttonColor: Qt.rgba(200/255, 200/255, 200/255, 1.0)
        buttonHoveredColor:  Qt.rgba(220/255, 220/255, 220/255, 1.0)
        buttonPresedColor: Qt.rgba(240/255, 240/255, 240/255, 1.0)
        onClickedChanged:
        {
            if(clicked)
            {
                if(!root.shown)
                {
                    console.log("Showing extra info")
                    showExtraInfo.running = true
                }
                else
                {
                    console.log("Hidding extra info")
                    hideExtraInfo.running = true
                }
                root.shown = !root.shown
                clicked = false
            }
        }
    }

    // Show Animation
    SequentialAnimation
    {
        id: showExtraInfo
        running: false
        NumberAnimation
        {
            target: root
            property: "topMarginFactor"
            to: 0.0
            duration: 2000
        }
        NumberAnimation
        {
            target: root
            property: "widthReductionFactor"
            to: 0.0
            duration: 500
        }
    }

    // Hide Animation
    SequentialAnimation
    {
        id: hideExtraInfo
        running: false
        NumberAnimation
        {
            target: root
            property: "widthReductionFactor"
            to: 1.0
            duration: 500
        }
        NumberAnimation
        {
            target: root
            property: "topMarginFactor"
            to: 1.0
            duration: 2000
        }
    }


    // Content
    Text
    {
        id: translation
        anchors.centerIn: parent
        color: root.fontColor
        font.pixelSize: root.fontPixelSize
        text: qsTr("text")
    }
}

