// Original ComboBox.qml: https://github.com/qt/qtquickcontrols2/blob/5.14/src/imports/controls/ComboBox.qml
// modified with custom properties

import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.impl 2.14
import QtQuick.Templates 2.14 as T

T.ComboBox {

    property color backgroundColor: "black"
    property color textColor: "white"
    property int fontSize: 12
    property int dropDownMaxHeight: 1000000
    property color dropDownArrowColor: "gray"

    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    delegate: ItemDelegate {
        width: parent.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        palette.text: control.palette.text
        palette.highlightedText: control.palette.highlightedText
        font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
        font.pixelSize: fontSize
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    indicator: ColorImage {
        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: control.topPadding + (control.availableHeight - height) / 2
        color: dropDownArrowColor
        defaultColor: "#353637"
        source: "qrc:/qt-project.org/imports/QtQuick/Controls.2/images/double-arrow.png"
        opacity: enabled ? 1 : 0.3
    }

    contentItem: T.TextField {
        leftPadding: !control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        rightPadding: control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        topPadding: 6 - control.padding
        bottomPadding: 6 - control.padding

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator

        font.pixelSize: fontSize
        color: textColor
        selectionColor: control.palette.highlight
        selectedTextColor: control.palette.highlightedText
        verticalAlignment: Text.AlignVCenter

        background: Rectangle {
            visible: control.enabled && control.editable && !control.flat
            border.width: parent && parent.activeFocus ? 2 : 1
            border.color: parent && parent.activeFocus ? control.palette.highlight : control.palette.button
            color: control.palette.base
        }
    }

    background: Rectangle {
        implicitWidth: 140
        implicitHeight: 40

        color: backgroundColor
        border.color: control.palette.highlight
        border.width: !control.editable && control.visualFocus ? 2 : 0
        visible: !control.flat || control.down
    }

    popup: T.Popup {
        y: control.height
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin, dropDownMaxHeight)
        topMargin: 6
        bottomMargin: 6

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0

            Rectangle {
                z: 10
                width: parent.width
                height: parent.height
                color: "transparent"
                border.color: backgroundColor
            }

//            T.ScrollIndicator.vertical: ScrollIndicator { }
            T.ScrollBar.vertical: ScrollBar
            {
                id: control2
                size: 0.3
                position: 0.2
                //active: true
                orientation: Qt.Vertical
                visible: handle.height < parent.height - 4

                contentItem: Rectangle
                {
                    id: handle
                    implicitWidth: 10
                    implicitHeight: 100
                    radius: width / 2
                    color: control2.pressed ? "gray" : "darkGray"
                }
            }
        }

        background: Rectangle {
            color: control.palette.window
        }
    }
}
