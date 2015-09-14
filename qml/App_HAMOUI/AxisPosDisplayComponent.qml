import QtQuick 1.1
import "Theme.js" as Theme


Item {
    property alias name: name_.text
    property alias axisPos: pos_.text
    property alias unit: unit_.text
    property alias text: pos_.text
    property string bindStatus: ""
    property string textColor: Theme.defaultTheme.Content.tipTextColor

    height: 20
    width: name_.width + pos_.width + unit_.width
    Row{
        spacing: 2
        Text {
            id: name_
            width: 60
            color: textColor
        }
        Text {
            id: pos_
            width: 80
            color: textColor

        }
        Text {
            id:unit_
            width: 40
            color: textColor

        }
    }
}
