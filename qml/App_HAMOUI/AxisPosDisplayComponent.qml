import QtQuick 1.1
import "Theme.js" as Theme


Item {
    id:con
    property alias name: name_.text
    property alias axisPos: pos_.text
    property alias unit: unit_.text
    property double mode: 1
    property string text: ""
    property string bindStatus: ""
    property string textColor: Theme.defaultTheme.Content.tipTextColor

    height: 20
    width: name_.width + pos_.width + unit_.width
    Row{
        spacing: 2
        Text {
            id: name_
            width: 20
            color: textColor
        }
        Text {
            id: pos_
            width: 70
            color: textColor
            text:(con.text*mode).toFixed(3)
            horizontalAlignment: Text.AlignRight
        }
        Text {
            id:unit_
            width: 20
            color: textColor

        }
    }
}
