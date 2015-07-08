import QtQuick 1.1
import "."
import "Theme.js" as Theme

Rectangle {

    color: Theme.defaultTheme.BASE_BG
    IOComponent{
        id:left
        anchors.left: parent.left
        width: parent.width >> 1
//        anchors.bottom: parent.bottom
//        anchors.top: parent.top

//        height: parent.height
    }
    IOComponent{
        id:right
        anchors.right: parent.right
        width: parent.width >> 1
//        height: parent.height
    }
}
