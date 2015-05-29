import QtQuick 1.1

Rectangle {
    id:container
    property alias itemText: text.text
    Text {
        id: text
        text: qsTr("item")
        anchors.verticalCenter: parent.verticalCenter
    }
}
