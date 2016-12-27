import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../configs/IOConfigs.js" as IOConfigs


Item {
    id:container

    function createActionObjects(){
        var ret = [];
        var mD;
        var data;
        if(normalY.isChecked){
            mD = yModel;

        }else if(euY.isChecked){
            mD = euYModel;
        }
        else if(mY.isChecked)
            mD = mYModel;
        else if(singleY.isChecked)
            mD = singleYModel;
        else if(holdDoubleY.isChecked)
            mD = holdDoubleYModel;
        else
            mD = timeYModel;
        for(var i = 0; i < mD.count; ++i)
        {
            data = mD.get(i);
            if(data.isSel){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateOutputAction(data.hwPoint, data.board, isOn, data.valveID, delay.configValue));
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
            mustChecked: true
            checkedIndex: 0
            ICCheckBox{
                id:normalY
                text: qsTr("Y")
                isChecked: true
            }
            ICCheckBox{
                id:euY
                text: qsTr("EUY")
            }
            ICCheckBox{
                id:mY
                text: qsTr("M")
            }
            ICCheckBox{
                id:singleY
                text: qsTr("Single Y")
            }
            ICCheckBox{
                id:holdDoubleY
                text: qsTr("Hold Double Y")
            }
            ICCheckBox{
                id:timeY
                text: qsTr("Time Y")
                visible: timeYs.length > 0
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
            ListModel{
                id:timeYModel
            }

            GridView{
                id:yView
                function createMoldItem(ioDefine, hwPoint, board){
                    return {"isSel":false,
                        "pointNum":ioDefine.pointName,
                        "pointDescr":ioDefine.descr,
                        "hwPoint":hwPoint,
                        "board":board,
                        "isOn": false,
                        "valveID":-1,
                        "valve":null
                    };
                }

                function createValveMoldItem(pointNum, valve, board){
                    var pN = IODefines.getYDefineFromHWPoint(valve.y1Point, valve.y1Board).yDefine.pointName;
                    return {"isSel":false,
                        "pointNum":pN,
                        "pointDescr":valve.descr,
                        "hwPoint":board == IODefines.VALVE_BOARD ? valve.id: valve.y1Point,
                                                                   "board":board + parseInt(valve.y1Point / 32),
                                                                   "isOn": false,
                                                                   "valveID":valve.id,
                                                                   "valve":valve
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
                    if(timeY.isChecked) return timeYModel;
                    return null;
                }

                delegate: Row{
                    spacing: 2
                    height: 26
                    ICCheckBox{
                        text:pointNum
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
                            if(valve != null)
                                panelRobotController.setYStatus(JSON.stringify(valve), !isOn);
                            //                            panelRobotController.setYStatus(board, hwPoint, !isOn);
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
                layoutMode: 0
                isAutoSize: true
                mustChecked: true
                spacing: 20
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

            ICConfigEdit{
                id:delay
                configName: timeY.isChecked ? qsTr("Act Time:"): qsTr("Delay:")
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

        var yDefines = IOConfigs.teachYOut;
        var yDefine;
        var i, l;
        normalY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
//            yDefine = yDefines[i];
            yModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.VALVE_BOARD));
        }

        euY.visible = false;
//        yDefines = [];
//        for(i = 0, l = yDefines.length; i < l; ++i){
//            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
//            euYModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.EUIO_BOARD));
//        }

        yDefines = IOConfigs.teachMy;
        mY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            mYModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.M_BOARD_0));
        }

        yDefines = IOConfigs.teachSingleY
        singleY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            singleYModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.VALVE_BOARD));

        }

        yDefines = IOConfigs.teachHoldDoubleY
        holdDoubleY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            holdDoubleYModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.VALVE_BOARD));
        }

        yDefines = IOConfigs.teachTy;
        timeY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            timeYModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.TIMEY_BOARD_START));
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
                var toFix = 0;
                if(timeY.isChecked)
                {
                    toFix = IODefines.TIMEY_BOARD_START;
                }

                for(i = 0; i < currentModel.count; ++i){
                    modelItem =  currentModel.get(i);
                    currentModel.setProperty(i, "isOn", panelRobotController.isOutputOn(modelItem.hwPoint, modelItem.board - toFix));
                }
            }
        }
    }

}
