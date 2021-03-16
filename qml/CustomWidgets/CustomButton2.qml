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
    property bool textAllUppercase: false
    property bool textBold: false
    property bool textItalic: false

    property color buttonColor: "transparent"
    property color buttonHoveredColor: Qt.rgba(255/255, 255/255, 255/255, 0.1)
    property color buttonPresedColor:  Qt.rgba(255/255, 255/255, 255/255, 0.2)

    property bool clicked: false
    property bool hovered: false

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
            color: button.pressed? buttonPresedColor : button.hovered? buttonHoveredColor : buttonColor
            radius: root.radius
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
            font.capitalization: textAllUppercase? Font.AllUppercase: Font.MixedCase
            font.bold: textBold
            font.italic: textItalic
            opacity: imgOpacity
        }

        onClicked:
        {
            //console.log("clicked")
            root.clicked = true
        }

        onHoveredChanged:
        {
            root.hovered = hovered
        }
    }
}
