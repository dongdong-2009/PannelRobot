import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../../utils/stringhelper.js" as ICString
import "ProgramFlowPage.js" as ProgramFlowPage
import "../configs/IOConfigs.js" as IOConfigs
import "../configs/AxisDefine.js" as AxisDefine


Item {
    id:container
    property variant counters: []
    property int old_mD: 0
    function toHcAddr(addr){
        return (parseInt(0)<<5) | (parseInt(32)<<10) | (parseInt(addr)<<16) | (parseInt(0)<<30) ;
    }
    function createActionObjects(){
        var ret = [];
        if(defineFlag.isChecked){
            var dflag = Teach.currentRecord.flagsDefine.createFlag(ProgramFlowPage.currentEditingProgram, flagDescr.configValue);
            //            Teach.currentRecord.flagsDefine.pushFlag(ProgramFlowPage.currentEditingProgram, flag);
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
            for(var c = 0; c < mD.count; ++c){
                data = mD.get(c);
                if(data.isSel){
                    data = counters[c];
                    ret.push(Teach.generateCounterJumpAction(parseInt(flagStr.slice(begin,end)),
                                                             data.id,
                                                             compareID.currentIndex,
                                                             compareTarget.configValue,
                                                             autoClear.isChecked ? 1 : 0));
                    break;
                }
            }
            return ret;

        }else if(memData.isChecked){
            var leftAddr,immValue;
            if(constData.isChecked){
                leftAddr = lAddr.addr();
                immValue = rData.configValue;
            }
            else if(addrData.isChecked){
                leftAddr = lAddr.addr();
                immValue = rAddr.addr() ;
            }
            else if(modeData.isChecked){
                leftAddr = toHcAddr(modeArea.modeAddr);
                immValue = whichMode.checkedItem.cmd;
            }
            else if(coordData.isChecked){
                leftAddr = toHcAddr(posArea.posAddr);
                immValue = comparePos.configValue*1000;
            }
            else if(alarmData.isChecked){
                leftAddr = toHcAddr(alarmArea.alarmAddr);
                immValue = alarmNum.configValue;
            }
            else if(visionData.isChecked){
                leftAddr = toHcAddr(whichVision.checkedIndex + 896);
                immValue = visionValue.configValue;
            }
            ret.push(Teach.generateMemCmpJumpAction(parseInt(flagStr.slice(begin,end)),
                                                    leftAddr,
                                                    immValue,
                                                    modeData.isChecked ? 4 : memCmpGroup.checkedIndex,
                                                    addrData.isChecked ? 1 : 0,
                                                    whichData.checkedIndex,
                                                    whichMode.checkedIndex,
                                                    comparePos.configValue,
                                                    alarmNum.configValue,
                                                    axis.configValue,
                                                    selcoord.checkedIndex));
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
                                    if(m == counterModel)
                                    {
                                        if(toSetSel)
                                        {
                                            compareTarget.configValue = counters[index].target;
                                        }
                                        else compareTarget.configValue = 0;
                                    }

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
                        id:whichData
                        spacing: 24
                        mustChecked: true
                        checkedIndex: 0
                        ICCheckBox{
                            id:modeData
                            text:qsTr("Mode Data")
                            isChecked: true
                        }
                        ICCheckBox{
                            id:coordData
                            text:qsTr("Coord Data")
                        }
                        ICCheckBox{
                            id:alarmData
                            text:qsTr("Alarm Data")
                        }
                        ICCheckBox{
                            id:visionData
                            text:qsTr("Vision Data")
                        }
                        ICCheckBox{
                            id:constData
                            text:qsTr("Const Data")
                        }
                        ICCheckBox{
                            id:addrData
                            text:qsTr("Addr Data")
                        }
                    }

                    Column{
                        id:modeArea
                        property int modeAddr: 1
                        visible: modeData.isChecked
                        spacing: 4
                        Text{
                            text: qsTr("when current mode is:")
                        }
                        Flow{
                            width: memDataConfigsContainer.width-10
                            spacing: 8
                            ICCheckBox{
                                id:manualMode
                                property int cmd: 1
                                text: qsTr("ManualMode")
                                isChecked: true
                            }
                            ICCheckBox{
                                id:stopMode
                                property int cmd: 3
                                text: qsTr("StopMode")
                            }
                            ICCheckBox{
                                id:autoMode
                                property int cmd: 2
                                text: qsTr("AutoMode")
                            }
                            ICCheckBox{
                                id:runningMode
                                property int cmd: 7
                                text: qsTr("RunningMode")
                            }
                            ICCheckBox{
                                id:singleMode
                                property int cmd: 8
                                text: qsTr("SingleMode")
                            }
                            ICCheckBox{
                                id:oneCycleMode
                                property int cmd: 9
                                text: qsTr("OneCycleMode")
                            }
                            Component.onCompleted: {
                                whichMode.addButton(manualMode);
                                whichMode.addButton(stopMode);
                                whichMode.addButton(autoMode);
                                whichMode.addButton(runningMode);
                                whichMode.addButton(singleMode);
                                whichMode.addButton(oneCycleMode);
                            }
                        }
                        ICButtonGroup{
                            id: whichMode
                            mustChecked: true
                            checkedIndex: 0
                            checkedItem: manualMode
                            layoutMode: 2
                        }
                    }

                    Column{
                        id:posArea
                        property int posAddr : 900+(axis.configValue*4)+(jogPos.isChecked?1:0)
                        visible: coordData.isChecked
                        spacing: 4
                        Row{
                            spacing: 12
                            ICComboBoxConfigEdit{
                                id:axis
                                z:2
                                configName: qsTr("Axis")
                                configValue: -1
                                function onAxisDefinesChanged(){
                                    var axis = AxisDefine.usedAxisNameList();
                                    items = axis;
                                    if(items.length>0)configValue = 0;
                                }
                                Component.onCompleted: {
                                    AxisDefine.registerMonitors(axis);
                                }
                            }
                            ICButtonGroup{
                                id:selcoord
                                spacing: 12
                                mustChecked: true
                                checkedIndex: 0
                                ICCheckBox{
                                    id:worldPos
                                    text: qsTr("worldPos")
                                    isChecked: true
                                }
                                ICCheckBox{
                                    id:jogPos
                                    text: qsTr("JogPos")
                                }
                            }
                        }
                        ICConfigEdit{
                            id:comparePos
                            configName: qsTr("posValue")
                            configValue:"0.000"
                            decimal: 3
                            min:-10000
                            max:10000
                        }
                    }
                    Column{
                        id:alarmArea
                        property int alarmAddr: 932
                        visible: alarmData.isChecked
                        spacing: 4
                        Text{
                            text: qsTr("when current alarm num")
                        }
                        ICConfigEdit{
                            id:alarmNum
                            visible: alarmData.isChecked
                            configName: qsTr("alarmNum")
                            configValue: "0"
                        }
                    }

                    Column{
                        id:visionArea
                        visible: visionData.isChecked
                        spacing: 4
                        ICButtonGroup{
                            id:whichVision
                            spacing: 12
                            mustChecked: true
                            checkedIndex: 0
                            ICCheckBox{
                                id:templetNumber
                                text: qsTr("templet number")
                                isChecked: true
                            }
                            ICCheckBox{
                                id:colorNumber
                                text: qsTr("color number")
                            }
                            ICCheckBox{
                                id:simiValue
                                text:qsTr("simi value")
                            }
                        }
                        ICConfigEdit{
                            id:visionValue
                            configName: qsTr("vision Value")
                            configValue:"0"
                        }
                    }

                    Column{
                        id:hcAddr
                        visible: ((constData.isChecked) ||(addrData.isChecked))
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
                        visible: (!modeData.isChecked)
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
                        visible: !counter.isChecked
                        text:  qsTr("ON")
                        width: 44
                        isChecked: true
                    }
                    ICCheckBox{
                        id:offBox
                        visible: !counter.isChecked
                        text: qsTr("OFF")
                        width:44
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
                    ICComboBox{
                        id:compareID
                        width: 150
                        items:[">",">=","<","<=","==","!=",qsTr("larger Equal Than Taarget"),qsTr("less Than Taarget")]
                        currentIndex: 6
                        visible: counter.isChecked
                        onCurrentIndexChanged:
                        {
                            if(compareID.currentIndex<6)compareID.width=50;
                            else compareID.width = 150;
                        }
                    }
                    ICConfigEdit{
                        id:compareTarget
                        configName: qsTr("value")
                        configValue: "0"
                        visible: counter.isChecked&&(compareID.currentIndex<6)
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
                    inputWidth:  180

                    onVisibleChanged: {
                        if(visible){
                            configValue = -1;
                            items = Teach.currentRecord.flagsDefine.flagNameList(ProgramFlowPage.currentEditingProgram);
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
        counters = Teach.currentRecord.counterManager.counters;
        var cs = counters;
        counterModel.clear();
        for(var i = 0; i < cs.length; ++i){
            counterModel.append(ioView.createValveMoldItem(Teach.currentRecord.counterManager.counterToString(cs[i].id) + ":", cs[i].name, 0, 0));
        }

    }

    onVisibleChanged: {
        if(visible){
            onMoldChanged();
        }
    }

    Component.onCompleted: {
        panelRobotController.moldChanged.connect(onMoldChanged);
//        onMoldChanged();
        var i;
        var l;
        var yDefines=[],xDefines=[];
        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
        if(ioBoardCount == 0)
            ioBoardCount = 1;
        l = ioBoardCount * 32;
        for(i = 0; i < l; ++i){
            xDefines.push(IODefines.xDefines[i]);
            yDefines.push(IODefines.yDefines[i]);
        }

        var yDefine;
        normalY.visible = yDefines.length > 0;
        for(i = 0, l = yDefines.length; i < l; ++i){
            yModel.append(ioView.createMoldItem(yDefines[i], i%32 , parseInt(i/32)));
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

        var xDefine;
        for(i = 0, l = xDefines.length; i < l; ++i){
            xModel.append(ioView.createMoldItem(xDefines[i], i%32, parseInt(i/32)));
        }

        euX.visible = false;
//        xDefines = euXs;
//        for(i = 0, l = xDefines.length; i < l; ++i){
//            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
//            euXModel.append(ioView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
//        }

    }
}
