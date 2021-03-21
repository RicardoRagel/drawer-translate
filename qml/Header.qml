import QtQuick 2.14

// Import C++ data handlers
import DataManager 1.0

// Import other project QML scripts
import "CustomWidgets"

Rectangle
{
    id: root

    property int buttonsWidth: 50
    property int buttonsHeight: 50
    property int top_margin: 10
    property color fontColor: "black"
    property int fontPixelSize: 14
    property double contentsOpacity: 1.0
    property bool isHidden: false

    // Signals to be processed by parent
    signal seetingsButtonPressed()
    signal exitButtonPressed()
    signal minimizeButtonPressed()
    signal hideButtonPressed()

    // Languages Buttons
    Row
    {
        id: languagesButtonsRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 0

        // Source Language Indicator and button
        CustomButton2
        {
            id: sourceLangTagButton
            anchors.verticalCenter: parent.verticalCenter
            width: buttonsWidth * 1.5
            height: buttonsHeight
            text: DataManager.settings.sourceLang
            textColor: fontColor
            textSize: fontPixelSize
            textAllUppercase: true
            textBold: true
            opacity: contentsOpacity
            onClickedChanged:
            {
                if(clicked)
                {
                    clicked = false
                    seetingsButtonPressed()
                }
            }
        }

        // Exchange languages button
        CustomButton2
        {
            id: exchangeLanguagesButton
            anchors.verticalCenter: parent.verticalCenter
            width: buttonsHeight
            height: buttonsHeight
            imgSizeFactor: 0.6
            imgOpacity: 1.0
            image_url: "qrc:/resources/interchange.svg"
            opacity: contentsOpacity
            onClickedChanged:
            {
                if(clicked)
                {
                    clicked = false
                    DataManager.interchangeSourceAndTargetLanguages()
                }
            }
        }

        // Target Language Indicator and button
        CustomButton2
        {
            id: targetLangTagButton
            anchors.verticalCenter: parent.verticalCenter
            width: buttonsWidth * 1.5
            height: buttonsHeight
            text: DataManager.settings.targetLang
            textColor: fontColor
            textSize: fontPixelSize
            textAllUppercase: true
            textBold: true
            opacity: contentsOpacity
            onClickedChanged:
            {
                if(clicked)
                {
                    clicked = false
                    seetingsButtonPressed()
                }
            }
        }
    }//languages buttons

    // Window Buttons
    Rectangle
    {
        id: buttonsRect
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        color: "transparent"
        width:  DataManager.settings.autoHideWin? buttonsWidth * 3 : buttonsWidth * 4
        height: parent.height
        Row
        {
            id: winButtonsRow
            spacing: 0
            anchors.verticalCenter: parent.verticalCenter
            layoutDirection: "RightToLeft"

            // Exit
            CustomButton2
            {
                id: winButtonsExit
                anchors.verticalCenter: parent.verticalCenter
                width: buttonsWidth
                height: buttonsHeight
                imgSizeFactor: 0.6
                imgOpacity: 1.0
                image_url: "qrc:/resources/cancel.svg"
                onClickedChanged:
                {
                    if(clicked)
                    {
                        clicked = false
                        exitButtonPressed()
                    }
                }
            }

            // Settings
            CustomButton2
            {
                id: winButtonSettings
                anchors.verticalCenter: parent.verticalCenter
                width: buttonsWidth
                height: buttonsHeight
                imgSizeFactor: 0.6
                imgOpacity: 1.0
                image_url: "qrc:/resources/settings.svg"
                onClickedChanged:
                {
                    if(clicked)
                    {
                        clicked = false
                        seetingsButtonPressed()
                    }
                }
            }

            // Minimize
            CustomButton2
            {
                id: winButtonMinimize
                anchors.verticalCenter: parent.verticalCenter
                width: buttonsWidth
                height: buttonsHeight
                imgSizeFactor: 0.6
                imgOpacity: 1.0
                image_url: "qrc:/resources/decrement.svg"
                onClickedChanged:
                {
                    if(clicked)
                    {
                        clicked = false
                        minimizeButtonPressed()
                    }
                }
            }

            // Hide
            CustomButton2
            {
                id: winButtonHide
                visible: DataManager.settings.autoHideWin? false: true
                anchors.verticalCenter: parent.verticalCenter
                width: buttonsWidth
                height: buttonsHeight
                imgSizeFactor: 0.6
                imgOpacity: 1.0
                image_url: isHidden? "qrc:/resources/arrow_up_white.svg" : "qrc:/resources/arrow_down_white.svg"
                onClickedChanged:
                {
                    if(clicked)
                    {
                        clicked = false
                        hideButtonPressed()
                    }
                }
            }
        }//row
    }//window buttons
}
