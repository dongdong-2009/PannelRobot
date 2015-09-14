import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine

Item {
    width: parent.width
    height: parent.height
    QtObject{
        id:pData
        property int editorWidth: 80
        property variant axisDefine: panelRobotController.axisDefine()
        property variant axisEditors: []
    }
    signal backToMenuTriggered()

    function createActionObjects(){
        var ret = [];
        var axis = pData.axisEditors;
        var axisActionInfo;
        var editor
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
                    ret.push(Teach.generateAxisServoAction(editor.servoAction,
                                                           i,
                                                           axisActionInfo.pos,
                                                           axisActionInfo.speed,
                                                           axisActionInfo.delay));
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
                id:backToMenu
                text: qsTr("Back to Menu")
                onButtonClicked: backToMenuTriggered()
            }

            ICCheckBox{
                id:isSyncBox
                text: qsTr("Sync");
                anchors.verticalCenter: backToMenu.verticalCenter
            }
        }

        Grid{
            columns: 2
            rows: 5
            spacing: 10
            flow: Grid.TopToBottom

            AxisActionEditorAxisComponent{
                id:m0Axis
                axisName: AxisDefine.axisInfos[0].name
                psName: [qsTr("X1 ON"), qsTr("X1 OFF")]
                axisDefine: pData.axisDefine.s1Axis
                rangeAddr: "s_rw_0_32_3_1000"
            }

            AxisActionEditorAxisComponent{
                id:m1Axis
                axisName: AxisDefine.axisInfos[1].name
                psName: [qsTr("Y1 ON"), qsTr("Y1 OFF")]
                axisDefine: pData.axisDefine.s2Axis
                rangeAddr: "s_rw_0_32_3_1001"
            }
            AxisActionEditorAxisComponent{
                id:m2Axis
                axisName: AxisDefine.axisInfos[2].name
                psName: [qsTr("Z ON"), qsTr("Z OFF")]
                axisDefine: pData.axisDefine.s3Axis
                rangeAddr: "s_rw_0_32_3_1002"
            }
            AxisActionEditorAxisComponent{
                id:m3Axis
                axisName: AxisDefine.axisInfos[3].name
                psName: [qsTr("X2 ON"), qsTr("X2 OFF")]
                axisDefine: pData.axisDefine.s4Axis
                rangeAddr: "s_rw_0_32_3_1003"
            }
            AxisActionEditorAxisComponent{
                id:m4Axis
                axisName: AxisDefine.axisInfos[4].name
                psName: [qsTr("Y2 ON"), qsTr("Y2 OFF")]
                axisDefine: pData.axisDefine.s5Axis
                rangeAddr: "s_rw_0_32_3_1004"
            }
            AxisActionEditorAxisComponent{
                id:m5Axis
                axisName: AxisDefine.axisInfos[5].name
                psName: [qsTr("A ON"), qsTr("A OFF")]
                axisDefine: pData.axisDefine.s6Axis
                rangeAddr: "s_rw_0_32_3_1005"
            }
            AxisActionEditorAxisComponent{
                id:m6Axis
                axisName: AxisDefine.axisInfos[6].name
                psName: [qsTr("B ON"), qsTr("B OFF")]
                axisDefine: pData.axisDefine.s7Axis
            }
            AxisActionEditorAxisComponent{
                id:m7Axis
                axisName: AxisDefine.axisInfos[7].name
                psName: [qsTr("C ON"), qsTr("C OFF")]
                axisDefine: pData.axisDefine.s8Axis
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
    }
}
