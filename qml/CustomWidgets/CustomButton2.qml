import QtQuick 2.14
import QtQuick.Controls 2.14

Rectangle
{
    id: root
    property string image_url: ""
    property real imgSizeFactor: 1.0
    property real imgOpacity: 1.0

    property string text: ""
    property color textColor: "black"
    property int textSize: 12

    property bool clicked: false

    width: 50
    height: 50
    color: "transparent"

    clip: true

    // Button
    Button
    {
        id: button
        width: root.width
        height: root.height
        anchors.top: parent.top
        anchors.right: parent.right
        background: Rectangle
        {
            color: "transparent"
            radius: 1
        }

        Image
        {
            id: img
            sourceSize.height: parent.height*imgSizeFactor
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            source: image_url
            opacity: button.pressed?imgOpacity*0.5:imgOpacity
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
            console.log("clicked")
            root.clicked = true
        }
    }
}
