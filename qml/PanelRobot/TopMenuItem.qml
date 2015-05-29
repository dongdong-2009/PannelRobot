import QtQuick 1.1
import "Theme.js" as Theme

Rectangle {
    property alias itemText: text.text
    signal itemTriggered()
    id:container
    color:Theme.defaultTheme.TopHeader.menuItemBG
    Text {
        id: text
        text: qsTr("item")
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    MouseArea{
        anchors.fill: parent
        onClicked: itemTriggered()
    }
}
