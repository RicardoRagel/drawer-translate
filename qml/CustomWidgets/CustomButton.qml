import QtQuick 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle
{
    id: root
    property color unpressedColor: "white"
    property color pressedColor: "gray"
    property color hoveredColor: "yellow"
    property string image_url: ""
    property real imgSizeFactor: 1.0
    property real imgOpacity: 1.0
    property bool shadowEnabled: true

    property string text: ""
    property color textColor: "black"
    property int textSize: 12

    property bool clicked: false

    width: 50
    height: 50
    color: "transparent"

    clip: true

    // Shadow
    Rectangle
    {
        id: shadow
        visible: shadowEnabled
        width: root.width * 0.95
        height: root.height * 0.95
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: Qt.rgba(100/255,100/255,100/255,0.5)
    }

    // Button
    Button
    {
        id: button
        width: shadowEnabled?root.width * 0.95 : root.width
        height: shadowEnabled?root.height * 0.95 : root.height
        anchors.top: parent.top
        anchors.right: parent.right
        style: ButtonStyle
        {
            background: Rectangle
            {
                color: control.pressed ? pressedColor : control.hovered? hoveredColor : unpressedColor
                radius: 1
            }
        }

        Image
        {
            id: img
            sourceSize.height: parent.height*imgSizeFactor
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            source: image_url
            opacity: imgOpacity
        }

        Text
        {
            id: txt
            anchors.centerIn: parent
            text: root.text
            color: textColor
            font.pixelSize: textSize
        }

        onClicked:
        {
            root.clicked = true
        }
    }

}
