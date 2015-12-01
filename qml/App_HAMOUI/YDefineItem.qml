import QtQuick 1.1
import "../ICCustomElement"
import "configs/IODefines.js" as IODefines



Item {
    property bool isOn: false
    property int board: 0
    property int hwPoint: 0
    width: layout.width
    height: layout.height
    Row{
        id:layout
        spacing: 12
        Text {
            id: pointDescr
            text: {
                var iod = IODefines.getYDefineFromHWPoint(hwPoint, board).yDefine;
                return iod.pointName + ":" + iod.descr
            }

            anchors.verticalCenter: parent.verticalCenter
        }

        ICButton{
            id:actionButton
            width: 80
            height: 32
            text: qsTr("On")
            onButtonClicked: {
                panelRobotController.setYStatus(board, hwPoint, !isOn);
            }
        }

        Rectangle{
            id:yLed
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
        }

        Rectangle{
            id:xLed
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
            visible: {
                var iod = IODefines.getYDefineFromHWPoint(hwPoint, board).yDefine;
                return IODefines.yCheckedX(iod.pointName) !== -1;
            }
        }
    }

    onIsOnChanged: {
        if(isOn){
            yLed.color = "lime" ;
            actionButton.text = qsTr("Off");
        }else{
            yLed.color = "gray"
            actionButton.text = qsTr("On");
        }
    }
}
