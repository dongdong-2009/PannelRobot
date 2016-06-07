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
            source: "images/Standby.png"
            cache: false
        }
        onVisibleChanged: {
            standbyImg.source = "";
            standbyImg.source = "images/Standby.png";
        }
    }
    AxisPosDisplayBar{
        id:posDisplayBar
    }
    content: standbyPageContainer
    statusSection: posDisplayBar

}
