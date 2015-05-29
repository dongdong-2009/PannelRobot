import QtQuick 1.1
import '.'

Rectangle {
    id:mainWindow
    width: 800
    height: 600
    Column{
        TopHeader{
            id:mainHeader
            width: mainWindow.width
            height: mainWindow.height * 0.05
        }
        Rectangle{
            id:container
            width: mainWindow.width
            height: mainWindow.height * 0.85
            color: "red"
        }

        Rectangle{
            id:mainMenu
            width: mainWindow.width
            height: mainWindow.height * 0.1
            color: "yellow"
        }
    }
}
