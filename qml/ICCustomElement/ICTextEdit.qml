import QtQuick 1.1

Rectangle {
    property alias text: input.text
    border.color: "gray"
    border.width: 1
    TextInput{
        id:input
        color: "black"
        anchors.verticalCenter: parent.verticalCenter
    }
}
