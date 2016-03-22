import QtQuick 1.1

MouseArea{
    id:container
    width: 800
    height: 600
    x:0
    y:0
    property alias hinttext: hinttext.text
    property alias msgtext: msgtext.text
    Rectangle {
        id: continer
        width: 360
        height: 60
        border.width: 1
        border.color: "black"
        anchors.centerIn: parent
        color: "#A0A0F0"


        Text {
            id: hinttext
            anchors.centerIn: parent
        }
        Text {
            id: msgtext
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 6
            anchors.rightMargin: 6
            visible: false
        }

    }
}
