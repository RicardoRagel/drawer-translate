﻿import QtQuick 2.14
import QtQuick.Controls 2.14

// Import C++ data handlers
import DataManager 1.0

// Import other project QML scripts
import "CustomWidgets"

// Extra Info
Rectangle
{
    id: root

    property int fontPixelSize: 14
    property color fontColor: "black"
    property int margins: 10
    property bool shown: false
    property double topMarginFactor: 1.0
    property double widthReductionFactor: 1.0
    property bool hovered: false

    // Manage hover
    HoverHandler { onHoveredChanged: { parent.hovered = hovered } }

    // Manage visibility changes
    onVisibleChanged:
    {
        // If visibility changes, get down this pannel
        hideExtraInfo.running = true
    }

    // Show/hide Button
    CustomButton2
    {
        id: extraInfoButton
        visible: true //TODO change by a DataManager variable true when extra info
        width: 50
        height: 7
        radius: 5
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        image_url: root.shown? "qrc:/resources/arrow_down.svg":"qrc:/resources/arrow_up.svg"
        buttonColor: Qt.rgba(200/255, 200/255, 200/255, 1.0)
        buttonHoveredColor:  Qt.rgba(220/255, 220/255, 220/255, 1.0)
        buttonPresedColor: Qt.rgba(240/255, 240/255, 240/255, 1.0)
        onClickedChanged:
        {
            if(clicked)
            {
                if(!root.shown)
                {
                    console.log("Showing extra info")
                    showExtraInfo.running = true
                }
                else
                {
                    console.log("Hidding extra info")
                    hideExtraInfo.running = true
                }
                root.shown = !root.shown
                clicked = false
            }
        }
    }

    // Show Animation
    SequentialAnimation
    {
        id: showExtraInfo
        running: false
        NumberAnimation
        {
            target: root
            property: "topMarginFactor"
            to: 0.0
            duration: Qt.platform.os === "windows"? 2000 : 1000
        }
        NumberAnimation
        {
            target: root
            property: "widthReductionFactor"
            to: 0.0
            duration: Qt.platform.os === "windows"? 500 : 250
        }
    }

    // Hide Animation
    SequentialAnimation
    {
        id: hideExtraInfo
        running: false
        NumberAnimation
        {
            target: root
            property: "widthReductionFactor"
            to: 1.0
            duration: Qt.platform.os === "windows"? 500 : 250
        }
        NumberAnimation
        {
            target: root
            property: "topMarginFactor"
            to: 1.0
            duration: Qt.platform.os === "windows"? 2000 : 1000
        }
    }


    // Content
    ScrollView
    {
        id: sv
        anchors.centerIn: parent
        height: parent.height - 2 * margins
        width: parent.width - 2 * margins
        clip: true
        Column
        {
            id: col
            spacing: margins

            // Translation result
            Row
            {
                id: resultRow
                spacing: margins
                anchors.left: parent.left

                Text
                {
                    id: translationTitle
                    text: qsTr("Translation: ")
                    color: root.fontColor
                    font.pixelSize: root.fontPixelSize
                    font.bold: true
                }
                Text
                {
                    id: translation
                    color: root.fontColor
                    font.pixelSize: root.fontPixelSize
                    text: DataManager.translationExtraInfo.result
                    //elide: Text.ElideRight
                    //width: sv.width - translationTitle.width - resultRow.spacing
                }
            }

            // Translation confidence
            Row
            {
                id: confidenceRow
                spacing: margins
                anchors.left: parent.left

                Text
                {
                    id: confidenceTitle
                    text: qsTr("Confidence: ")
                    color: root.fontColor
                    font.pixelSize: root.fontPixelSize
                    font.bold: true
                }
                Text
                {
                    id: confidence
                    color: root.fontColor
                    font.pixelSize: root.fontPixelSize
                    text: DataManager.translationExtraInfo.confidence.toFixed(2)
                    //elide: Text.ElideRight
                    //width: sv.width - confidenceTitle.width - confidenceRow.spacing
                }
            }

            // Matches
            Text
            {
                id: matchesTitle
                text: qsTr("Matches: ")
                color: root.fontColor
                font.pixelSize: root.fontPixelSize
                font.bold: true
            }
            Row
            {

                id: matchesRowl
                spacing: col.spacing

                // Sources
                Column
                {
                    id: sourcesCol
                    spacing: col.spacing/2
                    Text
                    {
                        id: matchesSourceTitle
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Source")
                        color: root.fontColor
                        font.pixelSize: root.fontPixelSize
                        font.italic: true
                        font.bold: true
                    }
                    Repeater
                    {
                        model: DataManager.translationExtraInfo.matchesSources
                        delegate: Text
                        {
                            id: matchSource
                            color: root.fontColor
                            font.pixelSize: root.fontPixelSize
                            text: display
                        }
                    }
                }
                // Translations
                Column
                {
                    id: translationsCol
                    spacing: col.spacing/2
                    Text
                    {
                        id: matchesTranslationsTitle
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Translation")
                        color: root.fontColor
                        font.pixelSize: root.fontPixelSize
                        font.italic: true
                        font.bold: true
                    }
                    Repeater
                    {
                        model: DataManager.translationExtraInfo.matchesTranslations
                        delegate: Text
                        {
                            id: matchTranslations
                            color: root.fontColor
                            font.pixelSize: root.fontPixelSize
                            text: display
                        }
                    }
                }

                // Confidences
                Column
                {
                    id: confidencesCol
                    spacing: col.spacing/2
                    Text
                    {
                        id: matchesConfidencesTitle
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Match")
                        color: root.fontColor
                        font.pixelSize: root.fontPixelSize
                        font.italic: true
                        font.bold: true
                    }
                    Repeater
                    {
                        model: DataManager.translationExtraInfo.matchesConfidences
                        delegate: Text
                        {
                            id: matchConfidence
                            color: root.fontColor
                            font.pixelSize: root.fontPixelSize
                            text: display
                        }
                    }
                }
            }
        }
    }
}

