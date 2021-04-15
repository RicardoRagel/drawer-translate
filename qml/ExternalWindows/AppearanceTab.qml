import QtQuick 2.14
import QtQuick.Controls 2.14

// Import other project QML scripts
import "../CustomWidgets"
import "../CustomWidgets/CustomColorDialogContent"

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0

Rectangle
{
    id: root
    color: "transparent"

    property int buttonSize: 15
    property int heightColumns: 10
    property int widthColum1: 100
    property int widthColum2: 100
    property int fontPixelSize: 12

    property color fontColor: "white"
    property color comboBoxColor: "black"
    property color buttonUnpressedColor: "gray"
    property color buttonPressedColor: "black"

    property double unhoveredOpacity: 0.75

    // Restore values from settings backend
    function cancelAll()
    {
        fontSizeSelector.selectBySize(DataManager.settings.fontSize)
        backgroundColorSelector.buttonColor = DataManager.settings.backgroundColor
        foregroundColorSelector.buttonColor = DataManager.settings.foregroundColor
        textColorSelector.buttonColor = DataManager.settings.textColor
        monitor.currentIndex = DataManager.settings.monitor
    }

    // Set values to settings backend
    function saveAll()
    {
        if(fontSizeSelector.sizeSelected !== DataManager.settings.fontSize)
            DataManager.settings.setFontSize(fontSizeSelector.sizeSelected)
        if(backgroundColorSelector.buttonColor !== DataManager.settings.backgroundColor)
            DataManager.settings.setBackgroundColor(backgroundColorSelector.buttonColor)
        if(foregroundColorSelector.buttonColor !== DataManager.settings.foregroundColor)
            DataManager.settings.setForegroundColor(foregroundColorSelector.buttonColor)
        if(textColorSelector.buttonColor !== DataManager.settings.textColor)
            DataManager.settings.setTextColor(textColorSelector.buttonColor)
        if(monitor.currentIndex !== DataManager.settings.monitor)
            DataManager.settings.setMonitor(monitor.currentIndex)
    }

    // Column of settings
    Column
    {
        id: columnAppearance
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: heightColumns/2
        spacing: 5

        // SECTION - GUI
        Rectangle
        {
            anchors.left: parent.left
            width: widthColum1 + widthColum2
            height: heightColumns
            color: "transparent"

            Text
            {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: fontPixelSize * 1.1
                font.bold: true
                color: fontColor
                text: "GUI"
            }
        }

        // Background Selector
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
                    font.bold: false
                    color: fontColor
                    text: "    Background Color: "
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                Rectangle
                {
                    anchors.centerIn: parent
                    width: buttonSize * 2
                    height: buttonSize / 2
                    border.color: "white"
                    border.width: 1

                    Checkerboard { cellSide: 4 }

                    CustomButton2
                    {
                        id: backgroundColorSelector
                        anchors.centerIn: parent
                        width: buttonSize * 2
                        height: buttonSize / 2
                        buttonColor: "white"
                        buttonHoveredColor: root.buttonUnpressedColor
                        buttonPresedColor: root.buttonPressedColor
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                backgroundColorDialog.visible = !backgroundColorDialog.visible
                            }
                        }
                    }
                    Rectangle
                    {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "white"
                        border.width: 1
                    }
                    Connections
                    {
                        target: DataManager.settings

                        onBackgroundColorChanged:
                        {
                            backgroundColorSelector.buttonColor = DataManager.settings.backgroundColor
                            console.log("Updating background color: " + DataManager.settings.backgroundColor)
                        }
                    }

                    // Reset color button
                    CustomButton2
                    {
                        id: backgroundResetColorButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        width: parent.height
                        height: parent.height
                        radius: 0
                        imgSizeFactor: 1.0
                        imgOpacity: hovered? 1.0 : 0.5
                        image_url: "qrc:/resources/refresh.svg"
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                backgroundColorSelector.buttonColor = Constants.defaultBackgroundColor
                            }
                        }
                    }
                }
            }
        }//backgroundColorSelector

        // Foreground Selector
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
                    font.bold: false
                    color: fontColor
                    text: "    Foreground Color: "
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                Rectangle
                {
                    anchors.centerIn: parent
                    width: buttonSize * 2
                    height: buttonSize / 2
                    border.color: "white"
                    border.width: 1

                    Checkerboard { cellSide: 4 }

                    CustomButton2
                    {
                        id: foregroundColorSelector
                        anchors.centerIn: parent
                        width: buttonSize * 2
                        height: buttonSize / 2
                        buttonColor: "white"
                        buttonHoveredColor: root.buttonUnpressedColor
                        buttonPresedColor: root.buttonPressedColor
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                foregroundColorDialog.visible = !foregroundColorDialog.visible
                            }
                        }
                    }
                    Rectangle
                    {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "white"
                        border.width: 1
                    }
                    Connections
                    {
                        target: DataManager.settings

                        onForegroundColorChanged:
                        {
                            foregroundColorSelector.buttonColor = DataManager.settings.foregroundColor
                            console.log("Updating foreground color: " + DataManager.settings.foregroundColor)
                        }
                    }

                    // Reset color button
                    CustomButton2
                    {
                        id: foregroundResetColorButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        width: parent.height
                        height: parent.height
                        radius: 0
                        imgSizeFactor: 1.0
                        imgOpacity: hovered? 1.0 : 0.5
                        image_url: "qrc:/resources/refresh.svg"
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                foregroundColorSelector.buttonColor = Constants.defaultForegroundColor
                            }
                        }
                    }
                }
            }
        }//foregroundColorSelector

        // Text Selector
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
                    font.bold: false
                    color: fontColor
                    text: "    Text Color: "
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                Rectangle
                {
                    anchors.centerIn: parent
                    width: buttonSize * 2
                    height: buttonSize / 2
                    border.color: "white"
                    border.width: 1

                    Checkerboard { cellSide: 4 }

                    CustomButton2
                    {
                        id: textColorSelector
                        anchors.centerIn: parent
                        width: buttonSize * 2
                        height: buttonSize / 2
                        buttonColor: "white"
                        buttonHoveredColor: root.buttonUnpressedColor
                        buttonPresedColor: root.buttonPressedColor
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                textColorDialog.visible = !textColorDialog.visible
                            }
                        }
                    }
                    Rectangle
                    {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "white"
                        border.width: 1
                    }
                    Connections
                    {
                        target: DataManager.settings

                        onTextColorChanged:
                        {
                            textColorSelector.buttonColor = DataManager.settings.textColor
                            console.log("Updating text color: " + DataManager.settings.textColor)
                        }
                    }

                    // Reset color button
                    CustomButton2
                    {
                        id: textResetColorButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        width: parent.height
                        height: parent.height
                        radius: 0
                        imgSizeFactor: 1.0
                        imgOpacity: hovered? 1.0 : 0.5
                        image_url: "qrc:/resources/refresh.svg"
                        onClickedChanged:
                        {
                            if(clicked)
                            {
                                clicked = false
                                textColorSelector.buttonColor = Constants.defaultTextColor
                            }
                        }
                    }
                }
            }
        }//textColorSelector

        // FontSize
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
                    font.bold: false
                    color: fontColor
                    text: "    Font size: "
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                CustomFontSizeSwitch
                {
                    id: fontSizeSelector
                    anchors.centerIn: parent
                    spacing: 4
                    fontColor: root.fontColor
                    buttonSize: root.buttonSize
                    text: "Aa"
                }
                Connections
                {
                    target: DataManager.settings

                    onFontSizeChanged:
                    {
                        fontSizeSelector.selectBySize(DataManager.settings.fontSize)
                        console.log("Updating fontSize: " + DataManager.settings.fontSize)
                    }
                }
            }
        }//fontSize

        // SECTION - Display
        Rectangle
        {
            anchors.left: parent.left
            width: widthColum1 + widthColum2
            height: heightColumns
            color: "transparent"

            Text
            {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: fontPixelSize * 1.1
                font.bold: true
                color: fontColor
                text: "Display"
            }
        }

        // Monitor
        Row
        {
            id: monitorRow
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
                    font.bold: false
                    color: fontColor
                    text: "    Monitor:"
                }
            }
            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: widthColum2
                height: heightColumns
                color: "transparent"

                Rectangle
                {
                    anchors.centerIn: parent
                    width: buttonSize * 2
                    height: parent.height
                    color: comboBoxColor
                    opacity: unhoveredOpacity

                    CustomComboBox
                    {
                        id: monitor
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        backgroundColor: "transparent"
                        textColor: fontColor
                        fontSize: fontPixelSize
                        dropDownMaxHeight: root.height/2
                        dropDownArrowColor: backgroundColor
                        currentIndex: 0
                        textRole: "index"
                        displayText: currentIndex
                        model: Qt.application.screens
                        onHoveredChanged:
                        {
                            parent.opacity = hovered? 1.0 : unhoveredOpacity
                        }
                    }
                    Connections
                    {
                        target: DataManager.settings

                        onMonitorChanged:
                        {
                            monitor.currentIndex = DataManager.settings.monitor
                            console.log("Updating Monitor to: " + DataManager.settings.monitor)
                        }
                    }
                }
            }
        }

    }//column

    // BKG Color selector popup
    CustomColorDialog
    {
        id: backgroundColorDialog
        visible: false
        enableDetails: false

        anchors.centerIn: parent

        width: 175
        height: 125

        fontPixelSize: 12
        fontColor: "white"
        backgroundColor: Qt.rgba(50/255, 50/255, 50/255, 1)
        buttonUnpressedColor: root.buttonPressedColor
        buttonPressedColor: root.buttonUnpressedColor

        onColorChanged:
        {
            if(visible)
                backgroundColorSelector.buttonColor = changedColor
        }
    }

    // FRG Color selector popup
    CustomColorDialog
    {
        id: foregroundColorDialog
        visible: false
        enableDetails: false

        anchors.centerIn: parent

        width: 175
        height: 125

        fontPixelSize: 12
        fontColor: "white"
        backgroundColor: Qt.rgba(50/255, 50/255, 50/255, 1)
        buttonUnpressedColor: root.buttonPressedColor
        buttonPressedColor: root.buttonUnpressedColor

        onColorChanged:
        {
            if(visible)
                foregroundColorSelector.buttonColor = changedColor
        }
    }

    // FRG Color selector popup
    CustomColorDialog
    {
        id: textColorDialog
        visible: false
        enableDetails: false

        anchors.centerIn: parent

        width: 175
        height: 125

        fontPixelSize: 12
        fontColor: "white"
        backgroundColor: Qt.rgba(50/255, 50/255, 50/255, 1)
        buttonUnpressedColor: root.buttonPressedColor
        buttonPressedColor: root.buttonUnpressedColor

        onColorChanged:
        {
            if(visible)
                textColorSelector.buttonColor = changedColor
        }
    }
}
