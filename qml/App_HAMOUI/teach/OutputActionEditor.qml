import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../configs/IOConfigs.js" as IOConfigs
import "../../utils/utils.js" as Utils
import "extents/ExtentActionDefine.js" as ExtentActionDefine
import "extents/ExtentActionEditorBase.js" as PData
import "extents"


ExtentActionEditorBase {
    id:container
    width: 700
    height: 209
    property bool isAutoMode: false
    property int type:pdata == undefined? -1:pdata.board
    property int point: pdata == undefined? -1:pdata.hwPoint
    property int valveID:pdata == undefined? -1:pdata.valveID
    property bool pointStatus: statusGroup.checkedItem == onBox ? true : false
    property alias delay: delayEdit.configValue

    property alias intervalType: always.isChecked
    property bool isBindingCount: count.configValue == 0?false:true
    property string counterID: count.configValue==0 ? 0 : Utils.getValueFromBrackets(count.configText())
    property alias cnt: interval.configValue

    property variant pdata

    onIsAutoModeChanged: {
        var notAutoMode = !isAutoMode;
        typeGroup.enabled = notAutoMode;
        yContainer.enabled = notAutoMode;
        statusGroup.enabled = notAutoMode;
        always.enabled = notAutoMode;
        interval.enabled = notAutoMode;
        count.enabled = notAutoMode;
    }

    onActionObjectChanged: {
        if(actionObject == null) return;
        console.log("actionObject",JSON.stringify(actionObject));
        var action = actionObject.action;
        var isOn = actionObject.pointStatus;
        var m,i,len;
        if(isOn)
            onBox.isChecked = true;
        else offBox.isChecked = true;
        delayEdit.configValue = actionObject.acTime!=undefined?actionObject.acTime:actionObject.delay;
        if(action === 200){
            if(actionObject.type == 0){
                normalY.isChecked =true;
                for(i=0,len=yModel.count;i<len;++i){
                    if(actionObject.point == yModel.get(i).hwPoint){
                        yModel.setProperty(i,"isSel",true);
                        pdata = yModel.get(i);
                    }
                    else{
                        yModel.setProperty(i,"isSel",false);
                    }
                }
            }
            else if(actionObject.type == 4){
                mY.isChecked =true;
                for(i=0,len=mYModel.count;i<len;++i){
                    if(actionObject.point == mYModel.get(i).hwPoint){
                        mYModel.setProperty(i,"isSel",true);
                        pdata = mYModel.get(i);
                    }
                    else{
                        mYModel.setProperty(i,"isSel",false);
                    }
                }
            }
            else if(actionObject.type == 8){
                for(i=0,len=singleYModel.count;i<len;++i){
                    if(actionObject.point == singleYModel.get(i).hwPoint){
                        singleY.isChecked =true;
                        singleYModel.setProperty(i,"isSel",true);
                        pdata = singleYModel.get(i);
                    }
                    else{
                        singleYModel.setProperty(i,"isSel",false);
                    }

                }
                for(i=0,len=holdDoubleYModel.count;i<len;++i){
                    if(actionObject.point == holdDoubleYModel.get(i).hwPoint){
                        holdDoubleY.isChecked =true;
                        holdDoubleYModel.setProperty(i,"isSel",true);
                        pdata = holdDoubleYModel.get(i);
                    }
                    else{
                        holdDoubleYModel.setProperty(i,"isSel",false);
                    }
                }
            }
            else if(actionObject.type == 100){
                timeY.isChecked =true;
                for(i=0,len=timeYModel.count;i<len;++i){
                    if(actionObject.point == timeYModel.get(i).hwPoint){
                        timeYModel.setProperty(i,"isSel",true);
                        pdata = timeYModel.get(i);
                    }
                    else{
                        timeYModel.setProperty(i,"isSel",false);
                    }
                }
            }
        }
        else if(action === 201){
            if(actionObject.type == 0){
                intervalY.isChecked =true;
                for(i=0,len=intervalYModel.count;i<len;++i){
                    if(actionObject.point == intervalYModel.get(i).hwPoint){
                        intervalYModel.setProperty(i,"isSel",true);
                        pdata = intervalYModel.get(i);
                    }
                    else{
                        intervalYModel.setProperty(i,"isSel",false);
                    }
                }
            }
            else if(actionObject.type == 4){
                intervalM.isChecked =true;
                for(i=0,len=intervalMModel.count;i<len;++i){
                    if(actionObject.point == intervalMModel.get(i).hwPoint){
                        intervalMModel.setProperty(i,"isSel",true);
                        pdata = intervalMModel.get(i);
                    }
                    else{
                        intervalMModel.setProperty(i,"isSel",false);
                    }
                }
            }
            interval.configValue = actionObject.cnt;
            always.isChecked = actionObject.intervalType;
        }
    }

    function createActionObjects(){
        var ret = [];
        var m = yView.model;
        for(var i=0;i<m.count;++i){
            if(m.get(i).isSel){
                pdata = m.get(i);
                ret.push(Teach.generateCustomAction(container.getActionProperties()));
            }
        }
        return ret;
    }

//    function createActionObjects(){
//        var ret = [];
//        var mD;
//        var data;
//        if(normalY.isChecked) mD = yModel;
//        else if(euY.isChecked) mD = euYModel;
//        else if(mY.isChecked) mD = mYModel;
//        else if(singleY.isChecked) mD = singleYModel;
//        else if(holdDoubleY.isChecked) mD = holdDoubleYModel;
//        else if(timeY.isChecked) mD = timeYModel;
//        else if(intervalY.isChecked) mD = intervalYModel;
//        else mD = intervalMModel
//        for(var i = 0; i < mD.count; ++i)
//        {
//            data = mD.get(i);
//            if(data.isSel){
//                var isOn = statusGroup.checkedItem == onBox ? true : false;
//                if(mD==intervalYModel||mD==intervalMModel)
//                ret.push(Teach.generateIntervalOutputAction(always.isChecked,
//                                                            count.configValue == 0?false:true,
//                                                            isOn,
//                                                            data.hwPoint,
//                                                            data.board,
//                                                            count.configValue==0 ? 0 : Utils.getValueFromBrackets(count.configText()),
//                                                            interval.configValue,
//                                                            delayEdit.configValue));
//                else ret.push(Teach.generateOutputAction(data.hwPoint, data.board, isOn, data.valveID, delayEdit.configValue));
//                break;
//            }
//        }
//        return ret;
//    }
    function updateCounters(){
        count.configValue = -1;
        var countersStrList = Teach.counterManager.countersStrList();
        countersStrList.splice(0, 0, qsTr("Self"));
        count.items = countersStrList;
        if(actionObject != null){
            if(actionObject.action = 201)
                if(actionObject.isBindingCount){
                    for(var i=1,len=count.items.length;i<len;++i){
                        if(actionObject.counterID == Utils.getValueFromBrackets(count.items[i])){
                            count.configValue = i;
                    }
                }
            }
            else count.configValue =0;
        }
    }
    onVisibleChanged: {
        if(visible)
            updateCounters();
    }

    Column{
        spacing: 4
        ICButtonGroup{
            id:typeGroup
            spacing: 2
            mustChecked: true
            checkedIndex: 0
            ICCheckBox{
                id:normalY
                text: qsTr("Y")
                isChecked: true
            }
            ICCheckBox{
                id:mY
                text: qsTr("M")
            }
            ICCheckBox{
                id:timeY
                text: qsTr("Time Y")
                visible: timeYs.length > 0
            }
            ICCheckBox{
                id:intervalY
                text: qsTr("Interval Y")
                visible: timeYs.length > 0
            }
            ICCheckBox{
                id:intervalM
                text: qsTr("Interval M")
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
                id:euY
                text: qsTr("EUY")
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
            ListModel{
                id:intervalYModel
            }
            ListModel{
                id:intervalMModel
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
                    if(intervalY.isChecked) return intervalYModel;
                    if(intervalM.isChecked) return intervalMModel;
                    return null;
                }
                onModelChanged: {
                    var m = yView.model;
                    for(var i=0;i<m.count;++i){
                        if(m.get(i).isSel){
                            pdata = m.get(i);
                        }
                    }
                    if(yView.model ===intervalYModel || yView.model ===intervalMModel){
                        bindActionDefine(ExtentActionDefine.extentIntervalOutputAction);
                    }else{
                        bindActionDefine(ExtentActionDefine.extentOutputAction);
                    }

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
                                pdata = m.get(index);
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
                                console.log("valve",JSON.stringify(valve));
                                panelRobotController.setYStatus(JSON.stringify(valve), !isOn);
                            //                            panelRobotController.setYStatus(board, hwPoint, !isOn);
                        }
                    }
                }
            }
        }

        Row{
            spacing: 5
            ICButtonGroup{
                id:statusGroup
                checkedItem: onBox
                layoutMode: 0
                isAutoSize: true
                mustChecked: true
                spacing: 3
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
            ICCheckBox{
                id:always
                text: qsTr("always out")
                visible: intervalY.isChecked||intervalM.isChecked
            }

            ICConfigEdit{
                id:delayEdit
                configName: (timeY.isChecked||
                             intervalY.isChecked||
                             intervalM.isChecked) ? qsTr("Act Time:"): qsTr("Delay:")
                unit: qsTr("s")
                inputWidth: 50
                height: 24
                visible: true
                z:1
                configAddr: "s_rw_0_32_1_1201"
                configValue: "0.0"
            }
            ICConfigEdit{
                id:interval
                configName: qsTr("interval number:")
                inputWidth: 50
                height: 24
                visible: intervalY.isChecked||intervalM.isChecked
                z:1
                configValue: "10"
            }
            ICComboBoxConfigEdit{
                id:count
                visible: intervalY.isChecked||intervalM.isChecked
                configName: qsTr("Count Binding")
                configValue: -1
                z:1
            }
        }
    }


    Component.onCompleted: {
        bindActionDefine(ExtentActionDefine.extentOutputAction);
        var yDefines = IOConfigs.teachYOut;
        var yDefine;
        var i, l;
        normalY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
//            yDefine = yDefines[i];
            yModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.IO_BOARD_0 + parseInt(yDefine.y1Point / 32)));
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

        yDefines = IOConfigs.teachTy;
        intervalY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            intervalYModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.IO_BOARD_0 + parseInt(yDefine.y1Point / 32)));
        }

        yDefines = IOConfigs.teachMy;
        intervalM.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            intervalMModel.append(yView.createValveMoldItem(yDefines[i], yDefine, IODefines.M_BOARD_0));
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
