import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines


Item {
    id:container
    property variant ys: [
        "Y010",
        "Y011",
        "Y012",
        "Y013",
        "Y014",
        "Y015",
        "Y016",
        "Y017",
        "Y020",
    ]
    property  variant euYs : ["EuY010", "EuY011", "EuY012"]
    property variant mYs: ["INY010"]
    property variant singleYs: ["valve1"]
    property variant holdDoubleYs: ["valve2"]
    //    QtObject{
    //        id:pData

    ////        property variant yModel: []
    ////        property variant euYModel: []
    ////        property variant mYModel: []
    //    }

    function createActionObjects(){
        var ret = [];
        var mD;
        var data;
        var ui;
        if(normalY.isChecked){
            mD = yModel;

        }else if(euY.isChecked){
            mD = euYModel;
        }
        else if(mY.isChecked)
            mD = mYModel;
        else if(singleY.isChecked)
            mD = singleYModel;
        else
            mD = holdDoubleYModel;
        for(var i = 0; i < mD.count; ++i)
        {
            data = mD.get(i);
            if(data.isSel){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateOutputAction(data.hwPoint, data.board, isOn, delay.configValue));
                break;
            }
        }
        return ret;
    }
    width: parent.width
    height: parent.height

    Column{
        spacing: 4
        ICButtonGroup{
            id:typeGroup
            spacing: 20
            ICCheckBox{
                id:normalY
                text: qsTr("Y")
                isChecked: true
                visible:ys.length > 0
            }
            ICCheckBox{
                id:euY
                text: qsTr("EUY")
                visible: euYs.length > 0
            }
            ICCheckBox{
                id:mY
                text: qsTr("M")
                visible: mYs.length > 0
            }
            ICCheckBox{
                id:singleY
                text: qsTr("Single Y")
                visible: singleYs.length > 0
            }
            ICCheckBox{
                id:holdDoubleY
                text: qsTr("Hold Double Y")
                visible: holdDoubleYs.length > 0
            }
        }
        Rectangle{
            id:yContainer
            width: 690
            height: container.height - typeGroup.height - statusGroup.height - parent.spacing * 4
            color: "#A0A0F0"
            border.width: 1
            border.color: "black"
            //            visible: normalY.isChecked
            ListModel{
                id:yModel
            }
            ListModel{
                id:euYModel
            }
            ListModel{
                id:mYModel
            }
            ListModel{
                id:singleYModel
            }
            ListModel{
                id:holdDoubleYModel
            }

            GridView{
                id:yView
                function createMoldItem(ioDefine, hwPoint, board){
                    return {"isSel":false,
                        "pointNum":ioDefine.pointName,
                        "pointDescr":ioDefine.descr,
                        "hwPoint":hwPoint,
                        "board":board,
                        "isOn": false
                    };
                }

                function createValveMoldItem(pointNum, pointDescr, hwPoint, board){
                    return {"isSel":false,
                        "pointNum":pointNum,
                        "pointDescr":pointDescr,
                        "hwPoint":hwPoint,
                        "board":board,
                        "isOn": false
                    };
                }

                width: parent.width - 4
                height: parent.height - 4
                anchors.centerIn: parent
                cellWidth: 226
                cellHeight: 32
                clip: true
                model: {
                    if(normalY.isChecked) return yModel;
                    if(euY.isChecked) return euYModel;
                    if(mY.isChecked) return mYModel;
                    if(singleY.isChecked) return singleYModel;
                    if(holdDoubleY.isChecked) return holdDoubleYModel;
                    return null;
                }

                delegate: Row{
                    spacing: 2
                    height: 26
                    ICCheckBox{
                        text: pointNum
                        isChecked: isSel
                        width: yView.cellWidth * 0.35
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var m = yView.model;
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
                        width:yView.cellWidth * 0.6
                        bgColor: isOn ? "lime" : "white"
                        onButtonClicked: {
                            panelRobotController.setYStatus(board, hwPoint, !isOn);
                        }
                    }
                }
            }
        }

        Row{
            spacing: 20
            ICButtonGroup{
                id:statusGroup
                checkedItem: onBox
                Row{
                    spacing: 10
                    ICCheckBox{
                        id:onBox
                        text: qsTr("ON")
                        isChecked: true
                    }
                    ICCheckBox{
                        id:offBox
                        text: qsTr("OFF")
                    }
                }
                height: 32
            }

            ICConfigEdit{
                id:delay
                configName: qsTr("Delay:")
                unit: qsTr("s")
                width: 100
                height: 24
                visible: true
                z:1
                configAddr: "s_rw_0_32_1_1201"
                configValue: "0.0"
            }
        }
    }


    Component.onCompleted: {

        var yDefines = ys;
        var yDefine;
        var i;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            yModel.append(yView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
        }

        yDefines = euYs;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            euYModel.append(yView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
        }

        yDefines = mYs;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            mYModel.append(yView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
        }

        yDefines = singleYs;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            singleYModel.append(yView.createValveMoldItem(yDefines[i], yDefine.descr, yDefine.id, IODefines.VALVE_BOARD));
        }

        yDefines = holdDoubleYs;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            holdDoubleYModel.append(yView.createValveMoldItem(yDefines[i], yDefine.descr, yDefine.id, IODefines.VALVE_BOARD));
        }

    }
    Timer{
        id:refreshTimer
        interval: 50; running: visible; repeat: true
        onTriggered: {
            var currentModel = yView.model;
            var modelItem;
            var i;
            if(singleY.isChecked ||
                    holdDoubleY.isChecked)
            {
                var valveDefine;
                for(i = 0; i < currentModel.count; ++i){
                    modelItem =  currentModel.get(i);
                    valveDefine = IODefines.getValveItemFromValveID(modelItem.hwPoint);
                    currentModel.setProperty(i, "isOn", panelRobotController.isOutputOn(valveDefine.y1Point, valveDefine.y1Board));
                }
            }else{

                for(i = 0; i < currentModel.count; ++i){
                    modelItem =  currentModel.get(i);
                    currentModel.setProperty(i, "isOn", panelRobotController.isOutputOn(modelItem.hwPoint, modelItem.board));
                }
            }
        }
    }

}
