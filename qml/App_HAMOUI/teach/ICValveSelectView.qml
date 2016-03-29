import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/IODefines.js" as IODefines

ICGridView {
    id:container
    property variant valves: []
    property int boardType: IODefines.IO_BOARD_0
    isshowviewborder: true
    ListModel{
        id:viewModel
        function createValveMoldItem(pointNum, valve, board){
            var pN = IODefines.getYDefineFromHWPoint(valve.y1Point, valve.y1Board).yDefine.pointName;
            return {"isSel":false,
                "pointNum":pN,
                "pointDescr":valve.descr,
                "hwPoint":board == IODefines.VALVE_BOARD ? valve.id: valve.y1Point,
                                                           "board":board,
                                                           "isOn": false,
                                                           "valveID":valve.id,
                                                           "valve":valve
            };
        }
    }

    delegate: Row{
        spacing: 2
        height: 26
        ICCheckBox{
            text:pointNum
            isChecked: isSel
            width: container.cellWidth * 0.35
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var m = container.model;
                    var toSetSel = !isSel;
                    m.setProperty(index, "isSel", toSetSel);
                    for(var i = 0; i < m.count; ++i){
                        if( i !== index){
                            m.setProperty(i, "isSel", false);
                        }
                    }
                }
            }
        }
        ICButton{
            height: parent.height
            text: pointDescr
            width:container.cellWidth * 0.6
            bgColor: isOn ? "lime" : "white"
            onButtonClicked: {
                if(valve != null)
                    panelRobotController.setYStatus(JSON.stringify(valve), !isOn);
                //                            panelRobotController.setYStatus(board, hwPoint, !isOn);
            }
        }
    }
    onValvesChanged: {
        var yDefine;
        var yDefines = valves;
        for(var i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            viewModel.append(viewModel.createValveMoldItem(yDefines[i], yDefine, boardType));
        }
    }

    Timer{
        id:refreshTimer
        interval: 50; running: visible; repeat: true
        onTriggered: {
            var currentModel = viewModel;
            var modelItem;
            var i;
            var valveDefine;
            for(i = 0; i < currentModel.count; ++i){
                modelItem =  currentModel.get(i);
                valveDefine = IODefines.getValveItemFromValveID(modelItem.hwPoint);
                currentModel.setProperty(i, "isOn", panelRobotController.isOutputOn(valveDefine.y1Point, valveDefine.y1Board));
            }
        }
    }
}
