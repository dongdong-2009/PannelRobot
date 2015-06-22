import QtQuick 1.1

Rectangle {
    property alias text: text.text

    signal buttonClicked()
    width: 100
    height: 32
    border.width: 1
    border.color: "gray"
    Text {
        id: text
        text: "ICButton"
        anchors.centerIn: parent
    }
    MouseArea{
        anchors.fill: parent
        onPressed: {
            parent.color = "lightsteelblue";
        }
        onReleased: {
            parent.color = "white";
        }

        onClicked: {
            buttonClicked()
        }
    }
}
