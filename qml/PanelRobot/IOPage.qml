import QtQuick 1.1
import "."
import "Theme.js" as Theme

Rectangle {

    IOComponent{
        id:left
        anchors.left: parent.left
        width: parent.width >> 1
    }
    IOComponent{
        id:right
        anchors.right: parent.right
        width: parent.width >> 1
    }
    color: Theme.defaultTheme.BASE_BG
}
