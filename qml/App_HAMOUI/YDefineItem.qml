import QtQuick 1.1
import "../ICCustomElement"
import "configs/IODefines.js" as IODefines



Item {
//    property bool isOn: false
//    property int board: 0
//    property int hwPoint: 0
    property string valveName: ""
    property variant valveStatus: {"y1":false, "x1":false, "y2":false, "x2":false}
    property variant valve: null
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
            color: valveStatus.y1 ? "lime": "gray"
        }

        Rectangle{
            id:x1Led
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: valveStatus.x1 ? "red": "gray"
        }

        ICButton{
            id:actionButton
            width: 80
            height: 32
            text: qsTr("On")
            onButtonClicked: {
                var toSend = IODefines.valveItemJSON(valveName);
                panelRobotController.setYStatus(toSend, !valveStatus.y1);
            }
        }

        Rectangle{
            id:y2Led
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: valveStatus.y2 ? "lime": "gray"
        }

        Rectangle{
            id:x2Led
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: valveStatus.x2 ? "red": "gray"
        }

    }

    Component.onCompleted: {
        var valveItem = IODefines.getValveItemFromValveName(valveName);
        if(valveItem === null) return;
        pointDescr.text = valveItem.descr;
        x1Led.visible = !IODefines.isNormalYType(valveItem);
        y2Led.visible = IODefines.isDoubleYType(valveItem);
        x2Led.visible = IODefines.isDoubleYType(valveItem);
        valve = valveItem;
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
