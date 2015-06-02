import QtQuick 1.1
import "Theme.js" as Theme

Rectangle {
    property alias text: input.text
    border.color: Theme.defaultTheme.LineEdit.borderColor
    border.width: Theme.defaultTheme.LineEdit.borderWidth
    TextInput{
        id:input
        color: "black"
        anchors.verticalCenter: parent.verticalCenter
    }
}
