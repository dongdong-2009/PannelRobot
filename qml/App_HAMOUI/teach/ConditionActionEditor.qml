import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../../utils/stringhelper.js" as ICString
import "ProgramFlowPage.js" as ProgramFlowPage
import "../configs/IOConfigs.js" as IOConfigs


Item {
    id:container

    property variant xs: [
        "X010",
        "X011",
        "X012",
        "X013",
        "X014",
        "X015",
        "X016",
        "X017",
        "X020",
        "X021",
        "X022",
        "X023",
        "X024",
        "X025",
        "X026",
        "X027",
        "X030",
        "X031",
        "X032",
        "X033",
        "X034",
        "X035",
        "X036",
        "X037",
        "X040",
        "X041",
        "X042",
        "X043",
        "X044",
        "X045",
        "X046",
        "X047"
    ]
    property variant counters: []

    function createActionObjects(){
        var ret = [];
        if(defineFlag.isChecked){
            var dflag = Teach.flagsDefine.createFlag(ProgramFlowPage.currentEditingProgram, flagDescr.configValue);
            //            Teach.flagsDefine.pushFlag(ProgramFlowPage.currentEditingProgram, flag);
            ret.push(Teach.generateFlagAction(dflag.flagID, dflag.descr));
            return ret;
        }

        var mD;
        var data;
        var ui;
        var inout = 0;
        var flagStr = flag.configText();
        if(flag.configValue < 0) return ret;
        var begin = flagStr.indexOf('[') + 1;
        var end = flagStr.indexOf(']');
        if(normalY.isChecked){
            mD = yModel;
            inout = 1;

        }else if(euY.isChecked){
            mD = euYModel;
            inout = 1;
        }else if(mY.isChecked){
            mD = mYModel;
            inout = 1;
        }else if(normalX.isChecked){
            mD = xModel;

        }else if(euX.isChecked){
            mD = euXModel;
        }else if(counter.isChecked){
            mD = counterModel;
            for(var c = 0; mD.count; ++c){
                data = mD.get(c);
                if(data.isSel){
                    data = counters[c];
                    ret.push(Teach.generateCounterJumpAction(parseInt(flagStr.slice(begin,end)),
                                                             data.id,
                                                             onBox.isChecked ? 1 : 0,
                                                                               autoClear.isChecked ? 1 : 0));
                    break
                }
            }
            return ret;

        }else if(memData.isChecked){
            ret.push(Teach.generateMemCmpJumpAction(parseInt(flagStr.slice(begin,end)),
                                                    lAddr.addr(), addrData.isChecked ? rAddr.addr() : rData.configValue, memCmpGroup.checkedIndex,
                                                    constData.isChecked ? 0 : 1));
            return ret;
        }else{
            ret.push(Teach.generateJumpAction(parseInt(flagStr.slice(begin,end))));
            return ret;
        }

        for(var i = 0; i < mD.count; ++i){
            data = mD.get(i);
            if(data.isSel){
                var pStatus;
                if(statusBGroup.checkedItem == onBox)
                    pStatus = 1;
                else if(statusBGroup.checkedItem == offBox)
                    pStatus = 0;
                else if(statusBGroup.checkedItem == risingEdgeBox)
                    pStatus = 2;
                else if(statusBGroup.checkedItem == fallingEdgeBox)
                    pStatus = 3;
                ret.push(Teach.generateConditionAction(
                             data.board,
                             data.hwPoint,
                             inout,
                             pStatus,
                             limit.configValue,
                             parseInt(flagStr.slice(begin,end))));
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
            id:flagPageSel
            spacing: 10
            ICCheckBox{
                id:defineFlag
                text: qsTr("Define Flag")
                isChecked: true
            }
            ICCheckBox{
                id:useFlag
                text: qsTr("Use Flag")
            }
        }

        Column{
            id:useFlagPage
            spacing: 4
            visible: useFlag.isChecked
            ICButtonGroup{
                id:typeGroup
                spacing: 20
                ICFlickable{
                    width: 650
                    height: parent.height + 10
                    contentWidth: parent.width
                    contentHeight: parent.height
                    flickDeceleration: Flickable.HorizontalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    ICCheckBox{
                        id:normalY
                        text: qsTr("Y")
                        isChecked: true
                    }
                    ICCheckBox{
                        id:mY
                        text: qsTr("MY")
                    }
                    ICCheckBox{
                        id:normalX
                        text: qsTr("X")
                        visible: xs.length > 0
                    }
                    ICCheckBox{
                        id:counter
                        text: qsTr("Counter")
                        visible: counters.length > 0
                    }
                    ICCheckBox{
                        id:memData
                        text: qsTr("Mem")
                    }

                    ICCheckBox{
                        id:jump
                        text: qsTr("Jump")
                    }
                    ICCheckBox{
                        id:euX
                        text: qsTr("EUX")
                    }
                    ICCheckBox{
                        id:euY
                        text: qsTr("EUY")
                    }
                }
            }
            Rectangle{
                id:yContainer
                width: 690
                height: container.height - typeGroup.height - statusGroup.height - flagPageSel.height - anchors.topMargin - parent.spacing * 4
                color: "#A0A0F0"
                border.width: 1
                border.color: "black"
                visible: !memData.isChecked
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
                    id:xModel
                }
                ListModel{
                    id:euXModel
                }
                ListModel{
                    id:counterModel
                }


                GridView{
                    id:ioView
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
                    cellWidth: counter.isChecked ? 280 : 226
                    cellHeight: 32
                    clip: true
                    model: {
                        if(normalY.isChecked) return yModel;
                        if(euY.isChecked) return euYModel;
                        if(mY.isChecked) return mYModel;
                        if(normalX.isChecked) return xModel;
                        if(euX.isChecked) return euXModel;
                        if(counter.isChecked) return counterModel;
                        return null;
                    }

                    delegate: Row{
                        spacing: 2
                        height: 26
                        ICCheckBox{
                            text: pointNum + ":" + pointDescr
                            isChecked: isSel
                            width: ioView.cellWidth * 0.35
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    var m = ioView.model;
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
                    }
                }

            }
            Rectangle{
                id:memDataConfigsContainer
                width: yContainer.width
                height: yContainer.height
                visible: memData.isChecked
                color: "#A0A0F0"
                border.width: 1
                border.color: "black"
                Column{
                    spacing: 6
                    x:6
                    y:4
                    ICButtonGroup{
                        spacing: 24
                        mustChecked: true
                        checkedIndex: 0
                        ICCheckBox{
                            id:constData
                            text:qsTr("Const Data")
                            isChecked: true
                        }
                        ICCheckBox{
                            id:addrData
                            text:qsTr("Addr Data")
                        }
                    }

                    Column{
                        spacing: 4
                        ICHCAddrEdit{
                            id:lAddr
                            configName: qsTr("Left Addr:")
                        }
                        ICHCAddrEdit{
                            id:rAddr
                            configName: qsTr("Right Addr:")
                            visible: addrData.isChecked
                        }
                        ICConfigEdit{
                            id:rData
                            configName: qsTr("Right Data:")
                            visible: constData.isChecked
                        }
                    }
                    ICButtonGroup{
                        spacing: 24
                        id:memCmpGroup
                        mustChecked: true
                        checkedIndex: 0
                        ICCheckBox{
                            id: largerThan
                            text: qsTr(">")
                            isChecked: true
                        }
                        ICCheckBox{
                            id:largerEqual
                            text: qsTr(">=")
                        }
                        ICCheckBox{
                            id: lessThan
                            text: qsTr("<")
                        }
                        ICCheckBox{
                            id:lessEqual
                            text: qsTr("<=")
                        }
                        ICCheckBox{
                            id:equal
                            text: qsTr("==")
                        }
                        ICCheckBox{
                            id:notEqual
                            text: qsTr("!=")
                        }
                    }
                }
            }



            Row{
                spacing: 20
                Row{
                    id:statusGroup
                    spacing: 10
                    visible: !memData.isChecked
                    ICCheckBox{
                        id:onBox
                        text: counter.isChecked ? qsTr(">=T") : qsTr("ON")
                        width:counter.isChecked ? 80:44
                        isChecked: true
                    }
                    ICCheckBox{
                        id:offBox
                        text: counter.isChecked ? qsTr("<T") :qsTr("OFF")
                        width:counter.isChecked ? 80:44
                    }
                    ICCheckBox{
                        id:risingEdgeBox
                        visible: normalX.isChecked
                        text: qsTr("Rising Edge")
                    }
                    ICCheckBox{
                        id:fallingEdgeBox
                        visible: normalX.isChecked
                        text: qsTr("Falling Edge")
                    }

                    Component.onCompleted: {
                        statusBGroup.addButton(onBox);
                        statusBGroup.addButton(offBox);
                        statusBGroup.addButton(risingEdgeBox);
                        statusBGroup.addButton(fallingEdgeBox);
                    }
                }

                ICButtonGroup{
                    id:statusBGroup
                    checkedItem: onBox
                    mustChecked: true
                    layoutMode: 2
//                    visible: statusGroup.visible
                }

                ICCheckBox{
                    id:autoClear
                    text: qsTr("Auto Clear")
                    visible: counter.isChecked
                }

                ICConfigEdit{
                    id:limit
                    configName: qsTr("Limit:")
                    unit: qsTr("s")
                    inputWidth: 80
                    height: 24
                    visible: !counter.isChecked
                    z:1
                    configAddr: "s_rw_0_32_1_1201"
                    configValue: "0.0"
                }

                ICComboBoxConfigEdit{
                    id: flag
                    configName: qsTr("Flag")
                    popupMode: 1
                    inputWidth:  180
                    popupHeight: 200

                    onVisibleChanged: {
                        if(visible){
                            configValue = -1;
                            items = Teach.flagsDefine.flagNameList(ProgramFlowPage.currentEditingProgram);
                        }
                    }
                }
            }
        }


        ICConfigEdit{
            id:flagDescr
            visible: !flag.visible
            configName: qsTr("Flag")
            isNumberOnly: false
            inputWidth: 200
        }
    }

    function onMoldChanged(){
        counters = Teach.counterManager.counters;
        var cs = counters;
        counterModel.clear();
        for(var i = 0; i < cs.length; ++i){
            counterModel.append(ioView.createValveMoldItem(Teach.counterManager.counterToString(cs[i].id) + ":", cs[i].name, 0, 0));
        }

    }

    onVisibleChanged: {
        if(visible){
            onMoldChanged();
        }
    }

    Component.onCompleted: {
        panelRobotController.moldChanged.connect(onMoldChanged);
        onMoldChanged();
        var i;
        var l;
        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
        if(ioBoardCount == 0)
            ioBoardCount = 1;

        xs = IODefines.generateIOBaseBoardCount("X", ioBoardCount);

        var yDefines = IOConfigs.teachYOut;
        var yDefine;
        normalY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            yDefine = IODefines.getYDefineFromHWPoint(yDefine.y1Point, yDefine.y1Board);
            yModel.append(ioView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
        }

        euY.visible = false;
//        yDefines = euYs;
//        for(i = 0, l = yDefines.length; i < l; ++i){
//            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
//            euYModel.append(ioView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
//        }

        yDefines = IOConfigs.teachMy;
        mY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            yDefine = IODefines.getYDefineFromHWPoint(yDefine.y1Point, yDefine.y1Board);
            mYModel.append(ioView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
        }

        var xDefines = xs;
        var xDefine;
        for(i = 0, l = xDefines.length; i < l; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            xModel.append(ioView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
        }

        euX.visible = false;
//        xDefines = euXs;
//        for(i = 0, l = xDefines.length; i < l; ++i){
//            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
//            euXModel.append(ioView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
//        }

    }


}
