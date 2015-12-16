import QtQuick 1.1
import "../ICCustomElement"
import "../utils/Storage.js" as Storage

Rectangle {
    id:container
    border.width: 2
    border.color: "red"
    color: "green"
    property alias tip: descr.text

    Text{
        id:descr
        width:780
        font.pixelSize: 24
        anchors.verticalCenter: parent.verticalCenter
        color: "yellow"
    }
}
