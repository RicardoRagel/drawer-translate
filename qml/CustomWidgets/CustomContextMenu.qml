import QtQuick 2.14
import QtQuick.Controls 2.14

MouseArea
{
    property bool cutEnabled: true
    property bool copyEnabled: true
    property bool pasteEnabled: true
    property int itemsHeight: 30

    signal copy()
    signal paste()
    signal cut()

    acceptedButtons: Qt.RightButton
    onClicked:
    {
        contextMenu.x = mouse.x;
        contextMenu.y = mouse.y;
        contextMenu.open();
    }

    Menu
    {
        id: contextMenu
        visible: parent.height > 10 && opened
        width: 100

        MenuItem
        {
            text: "Copy"
            enabled: copyEnabled
            icon.source: "qrc:/resources/copy.svg"
            height: itemsHeight
            onTriggered:
            {
                copy()
            }
        }
        MenuItem
        {
            text: "Paste"
            enabled: pasteEnabled
            icon.source: "qrc:/resources/paste.svg"
            height: itemsHeight
            onTriggered:
            {
                paste()
            }
        }
        MenuItem
        {
            text: "Cut"
            enabled: cutEnabled
            icon.source: "qrc:/resources/cut.svg"
            height: itemsHeight
            onTriggered:
            {
                cut()
            }
        }
    }
}
