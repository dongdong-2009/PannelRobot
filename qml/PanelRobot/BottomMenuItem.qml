import QtQuick 1.1

Rectangle {
    property alias itemText: text.text
    signal itemTriggered()
    id:container
    color: "#A0A0F0"
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
