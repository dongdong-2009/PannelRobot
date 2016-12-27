import QtQuick 1.1
import "../ICCustomElement"
import "./Theme.js" as Theme

ContentPageBase
{
    Rectangle {
        id:standbyPageContainer
        color: Theme.defaultTheme.BASE_BG
        width: parent.width
        height: parent.height
        Image {
            id: standbyImg
            source: "images/" + panelRobotController.getCustomSettings("StandbyPicName", "Standby.png");
        }
        onVisibleChanged: {
            if(visible)
                standbyImg.source = "images/" + panelRobotController.getCustomSettings("StandbyPicName", "Standby.png");
        }
    }
    AxisPosDisplayBar{
        id:posDisplayBar
    }
    content: standbyPageContainer
    statusSection: posDisplayBar

    Component.onCompleted: {
        posDisplayBar.setJogPosVisible(false);
    }

}
