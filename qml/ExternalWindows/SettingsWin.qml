import QtQuick 2.14
import QtQuick.Window 2.3
import QtQuick.Controls 2.14

// Import other project QML scripts
import "../CustomWidgets"

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0

Window
{
    id: root

    // Disable the parent window edition
    modality: Qt.WindowModal

    property int buttonSize: 15
    property int fontPixelSize: 10
    property color fontColor: "white"
    property color backgroundColor: "white"
    property color editableSpaceColor: "black"
    property color buttonUnpressedColor: "lightgray"
    property color buttonPressedColor: "yellow"
    property int margins: 30

    property int widthColum1: 250
    property int widthColum2: 250
    property int heightColumns: 30

    // Set the current settings values
    onVisibleChanged:
    {
        if(visible)
        {
            apiKey.text = DataManager.settings.apiKey
        }
    }

    // Content
    Rectangle
    {
        id: background
        color: backgroundColor
        anchors.fill: parent
        anchors.centerIn: parent

        Rectangle
        {
            id: contentItem
            color: "transparent"
            anchors.centerIn: parent
            width: background.width - 2*margins
            height: background.height - 2*margins

            Column
            {
                anchors.centerIn: parent
                spacing: margins/4

                // API Key
                Row
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 2

                    Rectangle
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        width: widthColum1
                        height: heightColumns
                        color: "transparent"

                        Text
                        {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: fontPixelSize
                            font.bold: true
                            color: fontColor
                            text: "API Key: "
                        }
                    }
                    Rectangle
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        width: widthColum2
                        height: heightColumns
                        color: "transparent"

                        TextField
                        {
                            id: apiKey
                            anchors.fill: parent
                            background: Rectangle { color: editableSpaceColor }
                            font.pixelSize: fontPixelSize
                            color: fontColor
                            horizontalAlignment: TextInput.AlignHCenter
                            verticalAlignment: TextInput.AlignVCenter
                            selectByMouse: false
                        }
                    }

                }

                // Some Space
                Rectangle
                {
                    id: whiteSpace
                    height: 1
                    width: 1
                    color: "transparent"
                }

                // Accept/Decline buttons
                Row
                {
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
                        image_url: "qrc:/resources/accept.svg"

                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                console.log("Setting new configuration")
                                DataManager.settings.setApiKey(apiKey.text)
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
                        image_url: "qrc:/resources/cancel.svg"

                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                console.log("Canceling settings change")
                                root.visible = false
                            }
                        }
                    }
                }//row
            }//column
        }//contentItem

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
}//win
