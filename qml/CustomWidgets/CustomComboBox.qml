import QtQuick 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

ComboBox
{
    id: cb

    property color backgroundColor: "black"
    property color text_color: "white"
    property color selection_color: "blue"
    property int font_size: 12
    property bool text_centered: false

    style: ComboBoxStyle
    {
      font.pixelSize: font_size
      background: Rectangle
      {
        id: rectCategory
        width: cb.width
        height: cb.height
        color: backgroundColor
      }

      label: Item
      {
        anchors.fill: parent

        Rectangle
        {
            id: item_background
            anchors.fill: parent
            color: "transparent"

            Row
            {
                id: row
                anchors.fill: parent
                spacing: 2*arrow.width

                Text
                {
                  anchors.verticalCenter: parent.verticalCenter
                  font.pixelSize: font_size
                  color: text_color
                  text: control.currentText
                  width: parent.width - arrow.width - row.spacing
                  horizontalAlignment: text_centered?Text.AlignHCenter:Text.AlignLeft
                  maximumLineCount: 1
                  elide: Text.ElideRight
                }

                Image
                {
                    id: arrow
                    anchors.verticalCenter: parent.verticalCenter
                    sourceSize.height: parent.height*0.5
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/arrow_down.svg"

                    ColorOverlay
                    {
                        anchors.fill: arrow
                        source: arrow
                        color: text_color
                    }
                }
            }
        }
      }
      selectionColor: selection_color
    }
}
