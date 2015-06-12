import QtQuick 1.1

Rectangle {
    property alias text: text.text

    signal buttonClicked()
    width: 100
    height: 32
    Text {
        id: text
        text: "ICButton"
        anchors.centerIn: parent
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {buttonClicked()}
    }
}
