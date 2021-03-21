import QtQuick 2.14
import QtQuick.Window 2.3
import QtQuick.Controls 2.14

// Import other project QML scripts
import "../CustomWidgets"

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0

Popup
{
    id: root

    property int buttonSize: 15
    property int fontPixelSize: 10
    property color fontColor: "white"
    property color backgroundColor: "white"
    property color buttonUnpressedColor: "lightgray"
    property color buttonPressedColor: "yellow"

    property int finalWidth: 250
    property int finalHeight: 250

    modal: true
    focus: true
    background: Rectangle
    {
        anchors.fill: parent
        color: backgroundColor
    }

    function open()
    {
        content.opacity = 0
        width = 1
        height = 4
        visible = true
        showThisWin.start()
    }

    // Show Animation
    SequentialAnimation
    {
        id: showThisWin
        running: false
        NumberAnimation
        {
            target: root
            property: "width"
            to: finalWidth
            duration: Qt.platform.os === "windows"? 1000 : 500
        }
        NumberAnimation
        {
            target: root
            property: "height"
            to: finalHeight
            duration: Qt.platform.os === "windows"? 1000 : 500
        }
        NumberAnimation
        {
            target: content
            property: "opacity"
            to: 1.0
            duration: Qt.platform.os === "windows"? 1000 : 500
        }
    }

    onVisibleChanged:
    {
        if(!visible)
        {
            showThisWin.stop()
            width = 1
            height = 4
            content.opacity = 0
        }
    }

    // Content (Caution: Popups have margins by default)

    Rectangle
    {
        id: content
        anchors.fill: parent
        color: "transparent"

        // Exit button
        CustomButton2
        {
            id: exitButton
            anchors.top: parent.top
            anchors.right: parent.right
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
                    root.close()
                }
            }
        }

        // Centered Text
        Rectangle
        {
            id: textSpace
            width: parent.width * 0.9
            height: parent.height - iconsSpace.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            color: "transparent"

            Column
            {
                anchors.centerIn: parent
                width: parent.width
                spacing: 20

                Text
                {
                    id: description
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: fontPixelSize
                    color: fontColor
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    width: parent.width
                    wrapMode: TextEdit.Wrap
                    text: "<p><b>" + Constants.appTitle + "</b> (v" + Qt.application.version + ") is an open-source and multi-platform application designed as a hub for translation engines that provide an open (and mainly free) API.</p>
                            <p>As an open-source application, fell free to ask for the integration of a new translation engine, writting an issue or creating a pull request in the Github repository.</p>"
                }

                Image
                {
                    id: githubLogo
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 60
                    width: 60
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/logos/GitHub-Mark-Light-120px-plus.png"
                    property bool hovered: false
                    HoverHandler{onHoveredChanged: {parent.hovered = hovered}}
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {Qt.openUrlExternally("https://github.com/RicardoRagel/translator-minimal-app");}
                        cursorShape: parent.hovered? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
            }
        }
        // Logos at the bottom
        Rectangle
        {
            id: iconsSpace
            width: parent.width * 0.8
            height: parent.height * 0.15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            color: "transparent"

            Row
            {
                spacing: 0
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width

                Image
                {
                    id: myMemoryLogo
                    anchors.verticalCenter: parent.verticalCenter
                    height: iconsSpace.height
                    width: iconsSpace.width/5
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/logos/mymemory.svg"
                    property bool hovered: false
                    HoverHandler{onHoveredChanged: {parent.hovered = hovered}}
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {Qt.openUrlExternally("https://mymemory.translated.net/");}
                        cursorShape: parent.hovered? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
                Image
                {
                    id: apertiumLogo
                    anchors.verticalCenter: parent.verticalCenter
                    height: iconsSpace.height
                    width: iconsSpace.width/5
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/logos/apertium.png"
                    property bool hovered: false
                    HoverHandler{onHoveredChanged: {parent.hovered = hovered}}
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {Qt.openUrlExternally("https://wiki.apertium.org/wiki/Main_Page");}
                        cursorShape: parent.hovered? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
                Image
                {
                    id: googleLogo
                    anchors.verticalCenter: parent.verticalCenter
                    height: iconsSpace.height * 0.75
                    width: iconsSpace.width/5
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/logos/google.png"
                    property bool hovered: false
                    HoverHandler{onHoveredChanged: {parent.hovered = hovered}}
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {Qt.openUrlExternally("https://cloud.google.com/translate");}
                        cursorShape: parent.hovered? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
                Image
                {
                    id: hearlingLogo
                    anchors.verticalCenter: parent.verticalCenter
                    height: iconsSpace.height * 0.75
                    width: iconsSpace.width/5
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/logos/hearling.png"
                    property bool hovered: false
                    HoverHandler{onHoveredChanged: {parent.hovered = hovered}}
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {Qt.openUrlExternally("https://hearling.com/");}
                        cursorShape: parent.hovered? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
                Image
                {
                    id: libreTranslateLogo
                    anchors.verticalCenter: parent.verticalCenter
                    height: iconsSpace.height
                    width: iconsSpace.width/5
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/logos/libretranslate.svg"
                    property bool hovered: false
                    HoverHandler{onHoveredChanged: {parent.hovered = hovered}}
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {Qt.openUrlExternally("https://github.com/uav4geo/LibreTranslate/blob/main/README.md");}
                        cursorShape: parent.hovered? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
            }
        }
    }
}//win
