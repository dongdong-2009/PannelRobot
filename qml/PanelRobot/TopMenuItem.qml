import QtQuick 1.1
import "Theme.js" as Theme

Rectangle {
    property alias itemText: text.text
    property bool isChecked: false
    signal itemTriggered()
    id:container
    color:isChecked ? "yellow" : Theme.defaultTheme.TopHeader.menuItemBG
    Text {
        id: text
        text: qsTr("item")
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            isChecked = !isChecked
            itemTriggered()
        }

    }
}
