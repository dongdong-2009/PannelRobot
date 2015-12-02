import QtQuick 1.1
import "../ICCustomElement"
import "configs/IODefines.js" as IODefines



Item {
//    property bool isOn: false
//    property int board: 0
//    property int hwPoint: 0
    property string valveName: ""
    property bool isOn: false
    width: layout.width
    height: layout.height
    Row{
        id:layout
        spacing: 12
        Text {
            id: pointDescr
//            text: {

//            }

            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle{
            id:y1Led
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
        }

        Rectangle{
            id:x1Led
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
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
            id:y2Led
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
        }

        Rectangle{
            id:x2Led
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
        }

    }

    Component.onCompleted: {
        var valveItem = IODefines.getValveItemFromValveName(valveName);
        if(valveItem === null) return;
        pointDescr.text = valveItem.descr;
        x1Led.visible = !IODefines.isNormalYType(valveItem);
        y2Led.visible = IODefines.isDoubleYType(valveItem);
        x2Led.visible = IODefines.isDoubleYType(valveItem);
    }

//    onIsOnChanged: {
//        if(isOn){
//            yLed.color = "lime" ;
//            actionButton.text = qsTr("Off");
//        }else{
//            yLed.color = "gray"
//            actionButton.text = qsTr("On");
//        }
//    }
}
