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
        onPressed: {
            if(text.text.length == 0) return;
            container.color = "#D0D0D0";
        }
        onReleased: {
            container.color = "#A0A0F0";
        }
    }
}
