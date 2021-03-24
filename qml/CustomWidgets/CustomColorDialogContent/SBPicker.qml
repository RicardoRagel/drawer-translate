//  Saturation/brightness picking box
import QtQuick 2.11

Item {
    id: root
    property color hueColor : "blue"
    property real saturation : pickerCursor.x/width
    property real brightness : 1 - pickerCursor.y/height
    property int r : colorHandleRadius
    width: 200; height: 200
    Rectangle {
        anchors.fill: parent;
        rotation: -90
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFFFFF" }
            GradientStop { position: 1.0; color: root.hueColor }
        }
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#FF000000" }
            GradientStop { position: 0.0; color: "#00000000" }
        }
    }
    Item {
        id: pickerCursor
        Rectangle {
            x: -r; y: -r
            width: r*2; height: r*2
            radius: r
            border.color: "black"; border.width: 2
            color: "transparent"
            Rectangle {
                anchors.fill: parent; anchors.margins: 2;
                border.color: "white"; border.width: 2
                radius: width/2
                color: "transparent"
            }
        }
    }
    MouseArea {
        x: -r
        y: -r
        width: parent.width + r
        height: parent.height + r
        function handleMouse(mouse) {
            if (mouse.buttons & Qt.LeftButton) {
                pickerCursor.x = Math.max(0, Math.min(width,  mouse.x) - r);
                pickerCursor.y = Math.max(0, Math.min(height, mouse.y) - r);
            }
        }
        onPositionChanged: handleMouse(mouse)
        onPressed: handleMouse(mouse)
    }
}

