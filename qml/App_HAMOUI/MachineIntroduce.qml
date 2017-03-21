import QtQuick 1.1
import "./Theme.js" as Theme
import "ShareData.js" as ShareData
import "../ICCustomElement"

Item {

    Rectangle {
        id:machine
        color: Theme.defaultTheme.BASE_BG
        width: parent.width
        height: parent.height
        Image {
            id: machineImg
            source: "images/" + panelRobotController.getCustomSettings("MachineImgPicName", "transparent.png");
        }
        onVisibleChanged: {
            if(visible)machineImg.source = "images/" + panelRobotController.getCustomSettings("MachineImgPicName", "machineImg.png");
        }
    }
}

