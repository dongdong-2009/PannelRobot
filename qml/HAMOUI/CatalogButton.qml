import QtQuick 1.1

Item {
    property alias text: text.text
    property alias icon: icon.source
    width: 100
    height: 62

    signal buttonClicked()
    Image {
        id: icon
        source: ""
        width: 48
        height: 48
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        id: text
        text: "CatalogButton"
        anchors.top: icon.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {buttonClicked()}
    }
}
