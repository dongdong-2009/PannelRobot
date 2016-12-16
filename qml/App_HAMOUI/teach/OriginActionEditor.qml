import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine

Rectangle {
    id: continer
    width: 100
    height: 62
    QtObject{
        id:pData
        property variant axisDefine: panelRobotController.axisDefine()
        property variant axisEditors: []
    }

    function createActionObjects(){
        var ret = [];
        var axis = pData.axisEditors;
        var axisActionInfo;
        var editor
        for(var i = 0; i < axis.length; ++i){
            editor = axis[i];
            if(editor.axisItem.visible){
                axisActionInfo = editor.axisItem.getAxisActionInfo();
                if(axisActionInfo == null)
                    continue;
                if(axisActionInfo.hasOwnProperty("ps")){
                    ret.push(Teach.generateOriginAction(editor.servoAction,
                                                           i,
                                                           axisActionInfo.ps,
                                                           axisActionInfo.speed,
                                                           axisActionInfo.delay));
                }
            }
        }
        return ret;
    }

    Rectangle{
        id:splitLine
        width: 1
        height: parent.height
        color: "gray"
        x:310
    }

    Grid{
        id:axisView
        columns: 2
        rows: 5
        spacing: 10
        flow: Grid.TopToBottom
        OriginActionEditorAxisComponent{
            id:m0Axis
            axisName: AxisDefine.axisInfos[0].name
            psName: [qsTr("Type1"), qsTr("Type2"), qsTr("Type3"), qsTr("Type4")]
            axisDefine: pData.axisDefine.s1Axis
            rangeAddr: "s_rw_0_32_3_1000"
            z: 1
        }
        OriginActionEditorAxisComponent{
            id:m1Axis
            axisName: AxisDefine.axisInfos[1].name
            psName: m0Axis.psName
            axisDefine: pData.axisDefine.s2Axis
            rangeAddr: "s_rw_0_32_3_1001"
            z: 2
        }
        OriginActionEditorAxisComponent{
            id:m2Axis
            axisName: AxisDefine.axisInfos[2].name
            psName: m0Axis.psName
            axisDefine: pData.axisDefine.s3Axis
            rangeAddr: "s_rw_0_32_3_1002"
            z: 3
        }
        OriginActionEditorAxisComponent{
            id:m3Axis
            axisName: AxisDefine.axisInfos[3].name
            psName: m0Axis.psName
            axisDefine: pData.axisDefine.s4Axis
            rangeAddr: "s_rw_0_32_3_1003"
            z: 4
        }
        OriginActionEditorAxisComponent{
            id:m4Axis
            axisName: AxisDefine.axisInfos[4].name
            psName: m0Axis.psName
            axisDefine: pData.axisDefine.s5Axis
            rangeAddr: "s_rw_0_32_3_1004"
            z: 5
        }
        OriginActionEditorAxisComponent{
            id:m5Axis
            axisName: AxisDefine.axisInfos[5].name
            psName: m0Axis.psName
            axisDefine: pData.axisDefine.s6Axis
            rangeAddr: "s_rw_0_32_3_1005"
            z: 6
        }
        OriginActionEditorAxisComponent{
            id:m6Axis
            axisName: AxisDefine.axisInfos[6].name
            psName: m0Axis.psName
            axisDefine: pData.axisDefine.s6Axis
            rangeAddr: "s_rw_0_32_3_1005"
            z: 7
        }
        OriginActionEditorAxisComponent{
            id:m7Axis
            axisName: AxisDefine.axisInfos[7].name
            psName: m0Axis.psName
            axisDefine: pData.axisDefine.s6Axis
            rangeAddr: "s_rw_0_32_3_1005"
            z: 8
        }
    }
    Component.onCompleted: {
        var axis = [];
        var actions = Teach.actions;
        axis.push({"axisItem":m0Axis, "servoAction":actions.F_CMD_FINE_ZERO});
        axis.push({"axisItem":m1Axis, "servoAction":actions.F_CMD_FINE_ZERO});
        axis.push({"axisItem":m2Axis,  "servoAction":actions.F_CMD_FINE_ZERO});
        axis.push({"axisItem":m3Axis, "servoAction":actions.F_CMD_FINE_ZERO});
        axis.push({"axisItem":m4Axis, "servoAction":actions.F_CMD_FINE_ZERO});
        axis.push({"axisItem":m5Axis,  "servoAction":actions.F_CMD_FINE_ZERO});
        axis.push({"axisItem":m6Axis,  "servoAction":actions.F_CMD_FINE_ZERO});
        axis.push({"axisItem":m7Axis,  "servoAction":actions.F_CMD_FINE_ZERO});


        for(var i=0;i<7;++i){
            axis[i].axisItem.setTypeVisible(0,false);
            axis[i].axisItem.setTypeVisible(1,false);
        }

        pData.axisEditors = axis;
        AxisDefine.registerMonitors(continer);
        onAxisDefinesChanged();

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
    }
}
