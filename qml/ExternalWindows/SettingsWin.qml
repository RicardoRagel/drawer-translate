import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Window 2.3

// Import other project QML scripts
import "../CustomWidgets"

Window
{
    id: root

    // Remove window frame and make it always on top
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint

    // Disable the parent window edition
    modality: Qt.WindowModal

    property int buttonSize: 15
    property int fontPixelSize: 10
    property color fontColor: "white"
    property color backgroundColor: "white"
    property color comboBoxColor: "black"
    property color editableSpaceColor: "black"
    property color buttonUnpressedColor: "lightgray"
    property color buttonPressedColor: "yellow"
    property int margins: 30

    property int widthColum1: 250
    property int widthColum2: 250
    property int heightColumns: 30

    // This color will be backwards the user selected background color
    color: Qt.rgba(30/255, 30/255, 30/255, 0.9)

    // On openned set the first TAB as visible
    onVisibleChanged:
    {
        if(visible)
        {
            settingsTabButton.selected = true
            appearanceTabButton.selected = false
        }
    }

    // Content
    Rectangle
    {
        id: background
        color: backgroundColor
        anchors.fill: parent
        anchors.centerIn: parent

        Column
        {
            id: mainColumn
            anchors.centerIn: parent
            width: background.width - 2*margins
            height: background.height - 2*margins
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
                    id: tabControls
                    spacing: 0
                    height: header.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                    CustomButton2
                    {
                        property bool selected: false

                        id: settingsTabButton
                        text: "Settings"
                        anchors.verticalCenter: parent.verticalCenter
                        width: 100
                        height: parent.height
                        textSize: selected? root.fontPixelSize * 1.2 : root.fontPixelSize * 1.1
                        textColor: root.fontColor
                        textBold: selected

                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                selected = true
                                appearanceTabButton.selected = false
                                clicked = false
                            }
                        }
                    }

                    CustomButton2
                    {
                        property bool selected: false

                        id: appearanceTabButton
                        text: "Appearance"
                        anchors.verticalCenter: parent.verticalCenter
                        width: 125
                        height: parent.height
                        textSize: selected? root.fontPixelSize * 1.2 : root.fontPixelSize * 1.1
                        textColor: root.fontColor
                        textBold: selected

                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                selected = true
                                settingsTabButton.selected = false
                                clicked = false
                            }
                        }
                    }
                }
            }

            // content
            Rectangle
            {
                id: tabView
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height - 2 * heightColumns - 2 * parent.spacing
                color: "transparent"

                // Tab 1
                SettingsTab
                {
                    id: settingsTab
                    visible: settingsTabButton.selected

                    anchors.fill: parent
                    color: "transparent"
                    buttonSize: root.buttonSize
                    heightColumns: root.heightColumns
                    widthColum1: root.widthColum1
                    widthColum2: root.widthColum2
                    fontPixelSize: root.fontPixelSize
                    fontColor: root.fontColor
                    comboBoxColor: root.comboBoxColor
                    editableSpaceColor: root.editableSpaceColor
                }

                // Tab 2
                AppearanceTab
                {
                    id: appearanceTab
                    visible: appearanceTabButton.selected

                    anchors.fill: parent
                    color: "transparent"
                    buttonSize: root.buttonSize
                    heightColumns: root.heightColumns
                    widthColum1: root.widthColum1
                    widthColum2: root.widthColum2
                    fontPixelSize: root.fontPixelSize
                    fontColor: root.fontColor
                    comboBoxColor: root.comboBoxColor
                    buttonPressedColor: root.buttonPressedColor
                    buttonUnpressedColor: root.buttonUnpressedColor

                }
            }//content

            // Footer
            Rectangle
            {
                id: footer
                anchors.horizontalCenter: parent.horizontalCenter
                width: widthColum1 + widthColum2 + 75
                height: heightColumns
                color: "transparent"

                // About Button
                CustomButton2
                {
                    id: aboutButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    width: 75
                    height: 20
                    text: "About ..."
                    textItalic: true
                    textColor: fontColor
                    textSize: fontPixelSize
                    imgOpacity: hovered? 1.0 : 0.5
                    color: "transparent"

                    onClickedChanged:
                    {
                        if(clicked)
                        {
                            clicked = false
                            aboutWin.open()
                        }
                    }
                }

                // Accept/Decline buttons
                Row
                {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    spacing: 5

                    CustomButton
                    {
                        id: acceptButton
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonSize
                        height: buttonSize
                        imgSizeFactor: 0.7

                        pressedColor: buttonPressedColor
                        unpressedColor: buttonUnpressedColor
                        hoveredColor: comboBoxColor
                        image_url: "qrc:/resources/accept.svg"

                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                console.log("Setting new configuration")
                                if(settingsTab.saveAll() && appearanceTab.saveAll())
                                    root.visible = false
                            }
                        }
                    }
                    CustomButton
                    {
                        id: cancelButton
                        anchors.verticalCenter: parent.verticalCenter
                        width: buttonSize
                        height: buttonSize
                        imgSizeFactor: 0.5

                        pressedColor: buttonPressedColor
                        unpressedColor: buttonUnpressedColor
                        hoveredColor: comboBoxColor
                        image_url: "qrc:/resources/cancel.svg"

                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                console.log("Canceling settings change")
                                settingsTab.cancelAll()
                                appearanceTab.cancelAll()
                                root.visible = false
                            }
                        }
                    }
                }//row
            }//buttonsRect
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
                cancelButton.clicked= true
                event.accepted = true;
            }
            if (event.key === Qt.Key_Enter)
            {
                acceptButton.clicked = true
                event.accepted = true;
            }
        }
    }

    // About window
    AboutWin
    {
        id: aboutWin
        visible: false
        anchors.centerIn: parent
        finalWidth: parent.width - 4*root.margins
        finalHeight: parent.height - 4*root.margins
        backgroundColor: buttonPressedColor
        fontColor: root.fontColor
        fontPixelSize: root.fontPixelSize
        buttonUnpressedColor: root.buttonUnpressedColor
        buttonPressedColor: root.buttonPressedColor
    }
}//win
