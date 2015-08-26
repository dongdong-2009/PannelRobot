import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach

Item {
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

    Column{
        spacing: 4
        ICButton{
            id:backToMenu
            text: qsTr("Back to Menu")
            onButtonClicked: backToMenuTriggered()
        }

        Column{
            spacing: 6
            ICCheckBox{
                id:isSyncBox
                text: qsTr("Sync");
            }
            AxisActionEditorAxisComponent{
                id:x1Axis
                axisName: qsTr("X1")
                psName: [qsTr("X1 ON"), qsTr("X1 OFF")]
                axisDefine: pData.axisDefine.s1Axis
                rangeAddr: "s_rw_0_32_3_1000"
            }

            AxisActionEditorAxisComponent{
                id:y1Axis
                axisName: qsTr("Y1")
                psName: [qsTr("Y1 ON"), qsTr("Y1 OFF")]
                axisDefine: pData.axisDefine.s2Axis
                rangeAddr: "s_rw_0_32_3_1001"
            }
            AxisActionEditorAxisComponent{
                id:zAxis
                axisName: qsTr("Z")
                psName: [qsTr("Z ON"), qsTr("Z OFF")]
                axisDefine: pData.axisDefine.s3Axis
                rangeAddr: "s_rw_0_32_3_1002"
            }
            AxisActionEditorAxisComponent{
                id:x2Axis
                axisName: qsTr("X2")
                psName: [qsTr("X2 ON"), qsTr("X2 OFF")]
                axisDefine: pData.axisDefine.s4Axis
                rangeAddr: "s_rw_0_32_3_1003"
            }
            AxisActionEditorAxisComponent{
                id:y2Axis
                axisName: qsTr("Y2")
                psName: [qsTr("Y2 ON"), qsTr("Y2 OFF")]
                axisDefine: pData.axisDefine.s5Axis
                rangeAddr: "s_rw_0_32_3_1004"
            }
            AxisActionEditorAxisComponent{
                id:aAxis
                axisName: qsTr("A")
                psName: [qsTr("A ON"), qsTr("A OFF")]
                axisDefine: pData.axisDefine.s6Axis
                rangeAddr: "s_rw_0_32_3_1005"
            }
            AxisActionEditorAxisComponent{
                id:bAxis
                axisName: qsTr("B")
                psName: [qsTr("B ON"), qsTr("B OFF")]
                axisDefine: pData.axisDefine.s7Axis
            }
            AxisActionEditorAxisComponent{
                id:cAxis
                axisName: qsTr("C")
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
        axis.push({"axisItem":x1Axis, "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS1_1, "psOFF":actions.ACT_PS1_2});
        axis.push({"axisItem":y1Axis, "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS2_1, "psOFF":actions.ACT_PS2_2});
        axis.push({"axisItem":zAxis,  "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS3_1, "psOFF":actions.ACT_PS3_2});
        axis.push({"axisItem":x2Axis, "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS4_1, "psOFF":actions.ACT_PS4_2});
        axis.push({"axisItem":y2Axis, "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS5_1, "psOFF":actions.ACT_PS5_2});
        axis.push({"axisItem":aAxis,  "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS6_1, "psOFF":actions.ACT_PS6_2});
        axis.push({"axisItem":bAxis,  "servoAction":actions.F_CMD_SINGLE, "psON":null, "psOFF":null});
        axis.push({"axisItem":cAxis,  "servoAction":actions.F_CMD_SINGLE, "psON":actions.ACT_PS8_1, "psOFF":actions.ACT_PS8_2});
        pData.axisEditors = axis;
    }
}