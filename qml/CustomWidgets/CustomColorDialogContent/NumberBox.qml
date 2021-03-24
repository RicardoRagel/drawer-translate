//  Edit box (with caption), editing a number value
import QtQuick 2.11

Row
{
    id: root
    property int fontPixelSize: 10
    property color fontColor: "white"

    property alias  caption: captionBox.text
    property alias  value: inputBox.text
    property alias  min: numValidator.bottom
    property alias  max: numValidator.top
    property alias  decimals: numValidator.decimals

    width: 80;
    height: 15
    spacing: 4
    //anchors.margins: 2
    Text {
        id: captionBox
        width: 18;
        height: parent.height
        color: root.fontColor
        font.pixelSize: root.fontPixelSize
        font.bold: true
    }
    PanelBorder
    {
        height: parent.height
        TextInput
        {
            id: inputBox
            color: root.fontColor
            selectionColor: "#FF7777AA"
            font.pixelSize: root.fontPixelSize
            maximumLength: 10
            focus: false
            readOnly: true
            selectByMouse: true
            validator: DoubleValidator
            {
                id: numValidator
                bottom: 0; top: 1; decimals: 2
                notation: DoubleValidator.StandardNotation
            }
        }
    }
}


