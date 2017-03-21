import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../configs/IODefines.js" as IODefines

Item {
    id:container
    width: parent.width
    height: parent.height
    QtObject{
        id:pData
        property int editorWidth: 80
        property variant axisDefine: panelRobotController.axisDefine()
        property variant axisEditors: []
        property variant axisVisible: [m0Axis.visible,m1Axis.visible,m2Axis.visible,m3Axis.visible,
                                    m3Axis.visible,m5Axis.visible,m6Axis.visible,m7Axis.visible,]
    }

    function createActionObjects(){
        var ret = [];
        var axis = pData.axisEditors;
        var axisActionInfo;
        var editor;
        if(isSyncBox.getChecked()){
            ret.push(Teach.generateSyncBeginAction());
        }
        for(var i = 0; i < axis.length; ++i){
            editor = axis[i];
            if(editor.axisItem.visible){
                axisActionInfo = editor.axisItem.getAxisActionInfo();
                if(axisActionInfo == null)
                    continue;
                if(axisActionInfo.hasOwnProperty("pos")){
                    var speedMode = 0;
                    if(speedPPStart.isChecked) speedMode = 1;
                    if(speedRPStart.isChecked) speedMode = 2;
                    ret.push(Teach.generateAxisServoAction(editor.servoAction,
                                                           i,
                                                           relPoint.isChecked ? axisActionInfo.point.pos["m" + i] : axisActionInfo.pos,
                                                           axisActionInfo.speed,
                                                           axisActionInfo.delay,
                                                           false,
                                                           earlyEnd.isChecked,
                                                           earlyEnd.configValue,
                                                           earlyEndSpeedPos.isChecked,
                                                           earlyEndSpeedPos.configValue,
                                                           earlyEndSpeed.configValue,
                                                           signalStop.isChecked,
                                                           signalStop.configValue,
                                                           signalOnOff.currentIndex,
                                                           fastStop.isChecked,
                                                            onPosOutput.isChecked,
                                                            onPosOutput.configValue,
                                                            ySignalOnOff.currentIndex,
                                                            posOut.configValue,
                                                           speedMode,
                                                           stop.isChecked,
                                                           rel.isChecked,
                                                           relPoint.isChecked ? axisActionInfo.point : null));
                }
                else{
                    ret.push(Teach.generateAxisPneumaticAction(axisActionInfo.ps == 0 ? editor.psOFF : editor.psON,
                                                                                        axisActionInfo.delay));
                }
            }
        }
        if(isSyncBox.getChecked()){
            ret.push(Teach.generateSyncEndAction());
        }
        return ret;
    }

    Rectangle{
        id:splitLine
        width: 1
        height: parent.height -3
        color: "gray"
        x:336
    }

    Column{
        spacing: 4
        Row{
            spacing: 15
            ICButton{
                id:setIn
                text: qsTr("Set In")
                bgColor: "lime"
                onButtonClicked: {
                    m0Axis.angle = (panelRobotController.statusValue("c_ro_0_32_0_901") / 1000).toFixed(3);
                    m1Axis.angle = (panelRobotController.statusValue("c_ro_0_32_0_905") / 1000).toFixed(3);
                    m2Axis.angle = (panelRobotController.statusValue("c_ro_0_32_0_909") / 1000).toFixed(3);
                    m3Axis.angle = (panelRobotController.statusValue("c_ro_0_32_0_913") / 1000).toFixed(3);
                    m4Axis.angle = (panelRobotController.statusValue("c_ro_0_32_0_917") / 1000).toFixed(3);
                    m5Axis.angle = (panelRobotController.statusValue("c_ro_0_32_0_921") / 1000).toFixed(3);
                }
            }

            ICCheckBox{
                id:isSyncBox
                text: qsTr("Sync");
            }
            ICCheckBox{
                id:relPoint
                text: qsTr("Rel Point")
            }
        }

        Flow{
            id:content
            //            columns: 2
            //            rows: 5
            height: 165
            width: 500
            spacing: 10
            flow: Grid.TopToBottom

            AxisActionEditorAxisComponent{
                id:m0Axis
                axisName: AxisDefine.axisInfos[0].name
                psName: [qsTr("X1 ON"), qsTr("X1 OFF")]
                axisDefine: pData.axisDefine.s1Axis
                rangeAddr: "s_rw_0_32_3_1000"
                mode: relPoint.isChecked ? "relPointMode" : ""
                z:1
            }

            AxisActionEditorAxisComponent{
                id:m1Axis
                axisName: AxisDefine.axisInfos[1].name
                psName: [qsTr("Y1 ON"), qsTr("Y1 OFF")]
                axisDefine: pData.axisDefine.s2Axis
                rangeAddr: "s_rw_0_32_3_1001"
                mode: m0Axis.mode
                relPoints: m0Axis.relPoints
                z:2
            }
            AxisActionEditorAxisComponent{
                id:m2Axis
                axisName: AxisDefine.axisInfos[2].name
                psName: [qsTr("Z ON"), qsTr("Z OFF")]
                axisDefine: pData.axisDefine.s3Axis
                rangeAddr: "s_rw_0_32_3_1002"
                mode: m0Axis.mode
                relPoints: m0Axis.relPoints
                z:3
            }
            AxisActionEditorAxisComponent{
                id:m3Axis
                axisName: AxisDefine.axisInfos[3].name
                psName: [qsTr("X2 ON"), qsTr("X2 OFF")]
                axisDefine: pData.axisDefine.s4Axis
                rangeAddr: "s_rw_0_32_3_1003"
                mode: m0Axis.mode
                relPoints: m0Axis.relPoints
                z:4
            }
            AxisActionEditorAxisComponent{
                id:m4Axis
                axisName: AxisDefine.axisInfos[4].name
                psName: [qsTr("Y2 ON"), qsTr("Y2 OFF")]
                axisDefine: pData.axisDefine.s5Axis
                rangeAddr: "s_rw_0_32_3_1004"
                mode: m0Axis.mode
                relPoints: m0Axis.relPoints
                z:5
            }
            AxisActionEditorAxisComponent{
                id:m5Axis
                axisName: AxisDefine.axisInfos[5].name
                psName: [qsTr("A ON"), qsTr("A OFF")]
                axisDefine: pData.axisDefine.s6Axis
                rangeAddr: "s_rw_0_32_3_1005"
                mode: m0Axis.mode
                relPoints: m0Axis.relPoints
                z:6
            }
            AxisActionEditorAxisComponent{
                id:m6Axis
                axisName: AxisDefine.axisInfos[6].name
                psName: [qsTr("B ON"), qsTr("B OFF")]
                axisDefine: pData.axisDefine.s6Axis
                rangeAddr: "s_rw_0_32_3_1006"
                mode: m0Axis.mode
                relPoints: m0Axis.relPoints
                z:7
            }
            AxisActionEditorAxisComponent{
                id:m7Axis
                axisName: AxisDefine.axisInfos[7].name
                psName: [qsTr("C ON"), qsTr("C OFF")]
                axisDefine: pData.axisDefine.s6Axis
                rangeAddr: "s_rw_0_32_3_1007"
                mode: m0Axis.mode
                relPoints: m0Axis.relPoints
                z:8
            }
            Row{
                z:10
                spacing: 6
                ICCheckableComboboxEdit{
                    id:signalStop
                    configName: qsTr("Input")
                    configValue: -1
                    inputWidth: 60
                    z:2
                    enabled: !(onPosOutput.isChecked || earlyEnd.isChecked || earlyEndSpeedPos.isChecked || speedPPStart.isChecked || speedRPStart.isChecked || stop.isChecked)
//                    configNameWidth: earlyEnd.configNameWidth
                    Component.onCompleted: {
                        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
                        if(ioBoardCount == 0)
                            ioBoardCount = 1;
                        var len = ioBoardCount * 32;
                        var ioItems = [];
                        for(var i = 0; i < len; ++i){
                            ioItems.push(IODefines.xDefines[i].pointName);
                        }
                        items = ioItems;
                        configValue = 0;
                    }
                }
                ICComboBox{
                    id:signalOnOff
                    enabled:signalStop.isChecked
                    width: 40
                    items:[qsTr("on"),qsTr("off")]
                    Component.onCompleted: {
                        currentIndex = 0;
                    }
                }
                Text {
                    id: sTip
                    height: signalOnOff.height
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("TStop")
                }
                ICCheckBox{
                    id:fastStop
                    text: qsTr("Fast Stop")
                }
            }
            Row{
                z:10
                spacing: 6
                ICCheckableComboboxEdit{
                    id:onPosOutput
                    configName: qsTr("Output")
                    configValue: -1
                    inputWidth: 60
                    z:2
                    enabled: !(signalStop.isChecked || earlyEnd.isChecked || speedPPStart.isChecked || speedRPStart.isChecked || stop.isChecked)
                    Component.onCompleted: {
                        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
                        if(ioBoardCount == 0)
                            ioBoardCount = 1;
                        var len = ioBoardCount * 32;
                        var ioItems = [];
                        for(var i = 0; i < len; ++i){
                            ioItems.push(IODefines.yDefines[i].pointName);
                        }
                        items = ioItems;
                        configValue = 0;
                    }
                }
                ICComboBox{
                    id:ySignalOnOff
                    enabled:onPosOutput.isChecked
                    width: 40
                    items:[qsTr("on"),qsTr("off")]
                    Component.onCompleted: {
                        currentIndex = 0;
                    }
                }
                ICConfigEdit{
                    id:posOut
                    enabled:onPosOutput.isChecked
                    configName: qsTr("On pos")
                    configValue: "0"
                }
            }

            Rectangle{
                width: 340
                height: {
                    var ac = 0;
                    for(var i=0;i<8;++i){
                        if(pData.axisVisible[i]){
                            ac++;
                        }
                    }
                    var ret;
                    if(ac <= 3) ret =  parent.height -parent.spacing;
                    else ret =  parent.height - (ac - 3) * (m1Axis.height + parent.spacing);
                    return ret;
                }
//                border.width: 1
//                border.color: "black"
                ICFlickable{
                    z:10
                    boundsBehavior:Flickable.DragOverBounds
                    width: parent.width
                    height: parent.height
                    contentWidth: width
                    contentHeight:advanceContent.height + 5
                    clip: true
                    Column{
                        id:advanceContent
                        spacing: 4
                        ICCheckableLineEdit{
                            id:earlyEnd
                            configName: qsTr("Early End Pos")
                            configValue: "0"
                            inputWidth: 60
                            configNameWidth: 140
                            enabled: !(onPosOutput.isChecked || signalStop.isChecked || speedPPStart.isChecked || speedRPStart.isChecked || stop.isChecked)
                        }
                        Row{
                            spacing: 4
                            ICCheckableLineEdit{
                                id:earlyEndSpeedPos
                                configName: qsTr("ESD Pos")
                                configValue: "0"
                                inputWidth: 60
                                configNameWidth: earlyEnd.configNameWidth
                                enabled: !(signalStop.isChecked || speedPPStart.isChecked || speedRPStart.isChecked || stop.isChecked)
                            }

                            ICConfigEdit{
                                id:earlyEndSpeed
                                configName: qsTr("ESD")
                                unit: qsTr("%")
                                configAddr: "s_rw_0_32_1_1200"
                                enabled: earlyEndSpeedPos.isChecked
                                configValue: "10.0"
                                inputWidth: 60
                            }
                        }
                        ICCheckBox{
                            id:rel
                            text: qsTr("Rel")
                            enabled: earlyEnd.enabled
                        }

                        ICButtonGroup{
                            id:speedControlGroup
                            spacing: 4
                            layoutMode: 1

                            ICCheckBox{
                                id:speedPPStart
                                text: qsTr("Speed PP Start")
                                enabled: !(onPosOutput.isChecked || earlyEnd.isChecked || earlyEndSpeedPos.isChecked || signalStop.isChecked || rel.isChecked)
                            }
                            ICCheckBox{
                                id:speedRPStart
                                text: qsTr("Speed RP Start")
                                enabled: speedPPStart.enabled
                            }

                            ICCheckBox{
                                id:stop
                                text:qsTr("Stop")
                                enabled: speedPPStart.enabled
                            }
                        }
                    }
                    Component.onCompleted: {
                        isshowhint = true;
                    }

                }
            }
        }

    }
    onVisibleChanged: {
        if(visible)
        {
            pData.axisDefine = panelRobotController.axisDefine();
            //            console.log(pData.axisDefine.s1Axis);
            //            console.log(pData.axisDefine.s2Axis);
            //            console.log(pData.axisDefine.s3Axis);
            //            console.log(pData.axisDefine.s4Axis);
            //            console.log(pData.axisDefine.s5Axis);
            //            console.log(pData.axisDefine.s6Axis);
            //            console.log(pData.axisDefine.s7Axis);
            //            console.log(pData.axisDefine.s8Axis);

        }
    }

    Component.onCompleted: {
        var axis = [];
        var actions = Teach.actions;
        axis.push({"axisItem":m0Axis, "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS1_1, "psOFF":actions.ACT_PS1_2});
        axis.push({"axisItem":m1Axis, "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS2_1, "psOFF":actions.ACT_PS2_2});
        axis.push({"axisItem":m2Axis,  "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS3_1, "psOFF":actions.ACT_PS3_2});
        axis.push({"axisItem":m3Axis, "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS4_1, "psOFF":actions.ACT_PS4_2});
        axis.push({"axisItem":m4Axis, "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS5_1, "psOFF":actions.ACT_PS5_2});
        axis.push({"axisItem":m5Axis,  "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS6_1, "psOFF":actions.ACT_PS6_2});
        axis.push({"axisItem":m6Axis,  "servoAction":actions.F_CMD_SINGLE, "psON":null, "psOFF":null});
        axis.push({"axisItem":m7Axis,  "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS8_1, "psOFF":actions.ACT_PS8_2});
        pData.axisEditors = axis;
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
        Teach.definedPoints.registerPointsMonitor(container);
        onPointAdded(null);
    }
    function onAxisDefinesChanged(){
        m0Axis.visible = AxisDefine.axisInfos[0].visiable;
        m1Axis.visible = AxisDefine.axisInfos[1].visiable;
        m2Axis.visible = AxisDefine.axisInfos[2].visiable;
        m3Axis.visible = AxisDefine.axisInfos[3].visiable;
        m4Axis.visible = AxisDefine.axisInfos[4].visiable;
        m5Axis.visible = AxisDefine.axisInfos[5].visiable;
        m6Axis.visible = AxisDefine.axisInfos[6].visiable;
        m7Axis.visible = AxisDefine.axisInfos[7].visiable;

        m0Axis.unit = AxisDefine.axisInfos[0].unit;
        m1Axis.unit = AxisDefine.axisInfos[1].unit;
        m2Axis.unit = AxisDefine.axisInfos[2].unit;
        m3Axis.unit = AxisDefine.axisInfos[3].unit;
        m4Axis.unit = AxisDefine.axisInfos[4].unit;
        m5Axis.unit = AxisDefine.axisInfos[5].unit;
        m6Axis.unit = AxisDefine.axisInfos[6].unit;
        m7Axis.unit = AxisDefine.axisInfos[7].unit;

    }

    function onPointAdded(point){
        var pNL = Teach.definedPoints.pointNameList();
        var type;
        var fPNs = [];
        for(var i = 0; i < pNL.length; ++i){
            type = pNL[i][0];
            if(type === Teach.DefinePoints.kPT_Free){
                fPNs.push(pNL[i]);
            }
        }
        m0Axis.relPoints = fPNs;

    }

    function onPointChanged(point){
        onPointAdded(point);
    }

    function onPointDeleted(point){
        onPointAdded(point);
    }

    function onPointsCleared(){
        onPointAdded(null);
    }
}
