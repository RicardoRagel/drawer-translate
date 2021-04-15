import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Window 2.3
import Qt.labs.qmlmodels 1.0

// Import other project QML scripts
import "../CustomWidgets"

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0

Window
{
    id: root
    color: "transparent"

    // Remove window frame and make it always on top
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint

    // Disable the parent window edition
    modality: Qt.ApplicationModal

    property int fontPixelSize: 10
    property color fontColor: "white"
    property color backgroundColor: Qt.rgba(30/255, 30/255, 30/255, 1.0)
    property color sectionColor:    Qt.rgba(40/255, 40/255, 40/255, 1.0)
    property int margins: 20
    property int heightColumns: 30

    // Content
    Rectangle
    {
        id: background
        color: backgroundColor
        radius: 10
        anchors.fill: parent
        anchors.centerIn: parent

        // Exit button
        CustomButton2
        {
            id: exitButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: margins
            anchors.rightMargin: margins
            width: 20
            height: 20
            imgSizeFactor: 0.5
            imgOpacity: 1.0
            image_url: "qrc:/resources/cancel.svg"
            onClickedChanged:
            {
                if(clicked)
                {
                    clicked = false
                    root.saveAndClose()
                }
            }
        }

        Column
        {
            id: mainColumn
            anchors.centerIn: parent
            width: background.width - 3*margins
            height: background.height - 3*margins
            spacing: 5

            //Header
            Rectangle
            {
                id: header
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: heightColumns
                color: "transparent"
                Row
                {
                    id: headerRow
                    spacing: margins
                    height: header.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                    Image
                    {
                        id: drawerTranslateLogo
                        anchors.verticalCenter: parent.verticalCenter
                        sourceSize.height: 40
                        sourceSize.width: 40
                        fillMode: Image.PreserveAspectFit
                        antialiasing: true
                        source: "qrc:/resources/icon_app.png"
                        property bool hovered: false
                        HoverHandler{onHoveredChanged: {parent.hovered = hovered}}
                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: {Qt.openUrlExternally("https://ricardoragel.github.io/drawer-translate/");}
                            cursorShape: parent.hovered? Qt.PointingHandCursor : Qt.ArrowCursor
                        }
                    }

                    Text
                    {
                        id: headerText
                        text: "Welcome to Drawer Translate!"
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                        font.pixelSize: 25
                        color: fontColor
                    }
                }
            }

            // content
            Rectangle
            {
                id: content
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height - 2 * heightColumns - 2 * parent.spacing
                color: "transparent"

                // Shortcuts
                Rectangle
                {
                    id: shortcuts
                    anchors.centerIn: parent
                    width: parent.width - 10 * margins
                    height: parent.height - 5 * margins
                    color: sectionColor
                    border.color: Qt.rgba(1.0, 1.0, 1.0, 0.9)
                    border.width: 2
                    radius: 20

                    // Title
                    Text
                    {
                        id: shortcutsText
                        text: "Shortcuts"
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 20
                        color: fontColor
                    }

                    // TableView
                    Rectangle
                    {
                        id: tableViewBb
                        anchors.centerIn: parent
                        width: 300
                        height: 150
                        color: "transparent"

                        TableView
                        {
                            anchors.fill: parent
                            columnSpacing: 1
                            rowSpacing: 1
                            clip: true

                            model: TableModel {
                                TableModelColumn { display: "name" }
                                TableModelColumn { display: "shortcut" }

                                rows: [
                                    {
                                        "name": "Open settings",
                                        "shortcut": Constants.shortcutOpenSettings
                                    },
                                    {
                                        "name": "Switch monitor",
                                        "shortcut": Constants.shortcutSwitchMonitor
                                    },
                                    {
                                        "name": "Hide/Unhide app",
                                        "shortcut": Constants.shortcutSwitchHidden
                                    },
                                    {
                                        "name": "Swap Languages",
                                        "shortcut": Constants.shortcutExchangeLangs
                                    }
                                ]
                            }

                            delegate: Rectangle {
                                implicitWidth: tableViewBb.width/2
                                implicitHeight: tableViewBb.height/4
                                color: "transparent"

                                Text {
                                    text: display
                                    anchors.centerIn: parent
                                    color: fontColor
                                }
                            }
                        }
                    }
                }


            }//content

            // Footer
            Rectangle
            {
                id: footer
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: heightColumns
                color: "transparent"

                Row
                {
                    id: footerRow
                    spacing: margins
                    height: header.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text
                    {
                        id: footerText
                        text: "Don't show again this window"
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                        font.pixelSize: fontPixelSize
                        color: fontColor
                    }

                    CustomCheckBox
                    {
                        id: footerCbox
                        box_color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        border_color: hovered? "black" : "transparent"
                        border_width: 1
                        tool_tip:  "Next time you run the app this window will not be shown"
                    }
                }

            }//footer
        }//cloumn
    }//background

    // Keyboard Control
    Item
    {
        anchors.fill: parent
        focus: true
        Keys.onPressed:
        {
            if (event.key === Qt.Key_Escape)
            {
                root.saveAndClose()
                event.accepted = true;
            }
            if (event.key === Qt.Key_Enter)
            {
                root.saveAndClose()
                event.accepted = true;
            }
        }
    }

    // Save settings and close
    function saveAndClose()
    {
        DataManager.settings.setWelcomeWinVisible(!footerCbox.checked)
        root.close()
    }
}//win
