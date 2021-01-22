import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ScrollView
{
    property bool enableHorizontalScroll: true
    property bool enableVerticalScroll: true
    property color buttonUnpressedColor: "white"
    property color buttonPressedColor: "gray"

    id: customScrollView

    horizontalScrollBarPolicy: enableHorizontalScroll?Qt.ScrollBarAlwaysOn:Qt.ScrollBarAlwaysOff
    verticalScrollBarPolicy: enableVerticalScroll?Qt.ScrollBarAlwaysOn:Qt.ScrollBarAlwaysOff

    property int customHandleWidth: 10

    style: ScrollViewStyle
    {
        property int handleWidth: customHandleWidth
        property int cornersRadius: handleWidth/2
        property string grooveColor: Qt.rgba( 1.0, 1.0, 1.0, 0.75 )
        property string handleColor: buttonUnpressedColor
        property string handlePressedColor: buttonPressedColor
        property string handleBorderColor: Qt.rgba( 0.35, 0.35, 0.35, 0.75 )

        frame: Rectangle
        {
            color: "transparent"
        }
        scrollBarBackground: Rectangle
        {
            implicitWidth: handleWidth
            color: grooveColor
            radius: cornersRadius
        }
        handle: Rectangle
        {
            implicitWidth: handleWidth
            color: styleData.pressed ? handlePressedColor :handleColor
            border.color: handleBorderColor
            border.width: 1
            radius: cornersRadius
        }
        decrementControl: Rectangle
        {
            color: "transparent"
        }
        incrementControl: Rectangle
        {
            color: "transparent"
        }
    }
}
