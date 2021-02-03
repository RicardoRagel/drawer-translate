import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

CheckBox
{
    id: checkbox
    checked: false

    property int box_width: 10
    property int box_height: box_width
    property int box_radius: 3
    property int border_width: 1
    property color box_color: "white"
    property color tick_color: "black"
    property color border_color: "black"
    property double tick_size_factor: 0.75
    property url tick_image: "qrc:/resources/accept.svg"
    property string tool_tip: ""

    width: box_width

    indicator: Rectangle
    {
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: box_width
        implicitHeight: box_height
        radius: box_radius
        color: box_color
        border.color: border_color
        border.width: border_width
        Image
        {
            visible: checkbox.checked
            anchors.centerIn: parent
            width: parent.width * tick_size_factor
            fillMode: Image.PreserveAspectFit
            source: tick_image
            ColorOverlay
            {
                anchors.fill: parent
                source: parent
                color: tick_color
            }
        }
    }

    ToolTip.text: tool_tip
    ToolTip.visible: tool_tip !== ""? hovered : false
    ToolTip.delay: 500
}
