import QtQuick 1.1
import "../ICCustomElement"

Item {
    property alias text: text.text
    property alias icon: icon.source
    property alias iconwidth: icon.width
    property alias iconheight: icon.height
    width: Math.max(icon.width, text.width)
    height: icon.height + text.height

    signal buttonClicked()
    signal triggered()
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
        color: enabled ? "black" : "gray"
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {buttonClicked();triggered()}
    }
}
