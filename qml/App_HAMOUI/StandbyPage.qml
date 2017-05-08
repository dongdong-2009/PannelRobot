import QtQuick 1.1
import "../ICCustomElement"
import "./Theme.js" as Theme
import "ShareData.js" as ShareData

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
        onVisibleChanged: {
            if(visible)
                setCurrentState(ShareData.barStatus);
        }
    }
    content: standbyPageContainer
    statusSection: posDisplayBar

//    Component.onCompleted: {
//        posDisplayBar.setJogPosVisible(false);
//    }

}
