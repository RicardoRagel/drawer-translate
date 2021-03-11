import QtQuick 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Row
{
    id: root
    spacing: 1

    property int buttonSize: 20
    property color fontColor: "white"
    property string text: "Aa"
    property int sizeSelected: opt1.textSize

    function selectBySize(font_size)
    {
        unSelectAll()
        if(opt1.textSize >= font_size)      { opt1.selected = true; sizeSelected = opt1.textSize }
        else if(opt2.textSize >= font_size) { opt2.selected = true; sizeSelected = opt2.textSize }
        else if(opt3.textSize >= font_size) { opt3.selected = true; sizeSelected = opt3.textSize }
        else                                { opt4.selected = true; sizeSelected = opt4.textSize }
    }

    function unSelectAll()
    {
        opt1.selected = false
        opt2.selected = false
        opt3.selected = false
        opt4.selected = false
    }

    CustomButton2
    {
        id: opt1
        property bool selected: true

        text: root.text
        textSize: 12
        textColor: fontColor
        width: buttonSize
        height: buttonSize
        anchors.verticalCenter: parent.verticalCenter
        border.color: fontColor
        border.width: selected? 1 : 0
        radius: 4
        onClickedChanged:
        {
            if(clicked)
            {
                clicked = false
                unSelectAll()
                selected = true
                sizeSelected = textSize
            }
        }
    }
    CustomButton2
    {
        id: opt2
        property bool selected: false

        text: root.text
        textSize: 14
        textColor: fontColor
        width: buttonSize
        height: buttonSize
        anchors.verticalCenter: parent.verticalCenter
        border.color: fontColor
        border.width: selected? 1 : 0
        radius: 4
        onClickedChanged:
        {
            if(clicked)
            {
                clicked = false
                unSelectAll()
                selected = true
                sizeSelected = textSize
            }
        }
    }
    CustomButton2
    {
        id: opt3
        property bool selected: false

        text: root.text
        textSize: 16
        textColor: fontColor
        width: buttonSize
        height: buttonSize
        anchors.verticalCenter: parent.verticalCenter
        border.color: fontColor
        border.width: selected? 1 : 0
        radius: 4
        onClickedChanged:
        {
            if(clicked)
            {
                clicked = false
                unSelectAll()
                selected = true
                sizeSelected = textSize
            }
        }
    }
    CustomButton2
    {
        id: opt4
        property bool selected: false

        text: root.text
        textSize: 18
        textColor: fontColor
        width: buttonSize
        height: buttonSize
        anchors.verticalCenter: parent.verticalCenter
        border.color: fontColor
        border.width: selected? 1 : 0
        radius: 4
        onClickedChanged:
        {
            if(clicked)
            {
                clicked = false
                unSelectAll()
                selected = true
                sizeSelected = textSize
            }
        }
    }
}
