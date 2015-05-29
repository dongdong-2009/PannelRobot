import QtQuick 1.1
import '.'

Rectangle {
    id:mainWindow
    width: 800
    height: 600
    TopHeader{
        id:mainHeader
        width: mainWindow.width
        height: mainWindow.height * 0.08
        onSystemItemTriggered: console.log("system clicked")
        onIoItemTriggered: console.log("IO clicked")
    }
    Rectangle{
        id:container
        width: mainWindow.width
        height: mainWindow.height * 0.85
        anchors.top: mainHeader.bottom
        anchors.bottom: parent.bottom
        Loader{
            source: "SettingsPage.qml"
            anchors.fill: parent
        }
    }
}
