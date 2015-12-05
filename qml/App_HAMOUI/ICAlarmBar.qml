import QtQuick 1.1
import "../ICCustomElement"
import "configs/AlarmInfo.js" as AlarmInfo
import "../utils/Storage.js" as Storage

Rectangle {
    id:container
    border.width: 2
    border.color: "red"
    color: "yellow"
    property int errID: 0
    property bool isShrinked: false
    visible: errID !== 0
    Row{
        id:errTextContainer
        height: parent.height - parent.parent.border.width * 6
        anchors.verticalCenter : parent.verticalCenter
        spacing: 4
        Text {
            width: 50
            font.pixelSize: 24
            text: "Err" + errID + ":"
            anchors.verticalCenter: parent.verticalCenter
            color: "red"
        }
        Text{
            id:descr
            width:670
            font.pixelSize: 24
            anchors.verticalCenter: parent.verticalCenter
            color: "red"
            text: AlarmInfo.getAlarmDescr(errID)

        }
        ICButton{
            id:details
            text: qsTr("i")
            height: parent.height
            width: 40
        }

    }
    ICButton{
        id:shrink
        text: ">"
        width: 20
        height: details.height
        onButtonClicked: {
            if(!isShrinked){
                errTextContainer.visible = false;
                shrinkAnimation.start();
                text = "<";
            }else{
                errTextContainer.visible = true;
                extentAnimation.start();
                text = ">"
            }
            isShrinked = !isShrinked;
        }
        anchors.right: parent.right
        anchors.rightMargin: parent.border.width
        anchors.verticalCenter : parent.verticalCenter

    }

    SequentialAnimation{
        id: flicker
        loops: 6
        PropertyAnimation{ target: container;properties: "color";to:"red";duration: 200}
        PropertyAnimation{ target: container;properties: "color";to:"yellow";duration: 200}
    }
    ParallelAnimation{
        id:shrinkAnimation;
        PropertyAnimation{ target: container; properties: "x"; to:771; duration: 100}
        PropertyAnimation{ target: container; properties: "width"; to:28;duration: 100}
    }
    ParallelAnimation{
        id:extentAnimation;
        PropertyAnimation{ target: container; properties: "x"; to:1; duration: 100}
        PropertyAnimation{ target: container; properties: "width"; to:798;duration: 100}
    }



    onVisibleChanged: {
        if(visible){
            flicker.start();
        }
    }
}
