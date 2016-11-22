import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/IODefines.js" as IODefines
ICGridView{
    id:instance
    border.width: 1
    border.color: "black"

    cellWidth: (width >> 1) - 6
    cellHeight: 32
    height: (cellHeight << 1) + 16
    clip: true
    property variant valvesToSel: []
    ListModel{
        id:valveModel
    }
    model: valveModel
    onValvesToSelChanged:{
        valveModel.clear();
        var v;
        for(var i = 0, len = valvesToSel.length; i < len; ++i){
            v = IODefines.getValveItemFromValveName(valvesToSel[i]);
            valveModel.append({"pointNum":IODefines.getYDefinePointNameFromValve(v),
                              "pointDescr":v.descr,
                              "isSel":false,
                              "isOn":false});
        }
    }

    delegate: Row{
        spacing: 2
        height: 26
        ICCheckBox{
            text:pointNum
            isChecked: isSel
            width: instance.cellWidth * 0.35
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var m = valveModel;
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
            width:instance.cellWidth * 0.6
            bgColor: isOn ? "lime" : "white"
            onButtonClicked: {
                if(valve != null)
                    panelRobotController.setYStatus(JSON.stringify(valve), !isOn);
            }
        }
    }

    Timer{
        id:refreshTimer
        interval: 50; running: visible; repeat: true
        onTriggered: {

        }
    }

}
