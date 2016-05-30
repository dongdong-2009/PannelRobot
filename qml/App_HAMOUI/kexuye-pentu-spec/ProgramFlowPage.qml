import QtQuick 1.1
import "../teach"
import "KeXuYePentuRecord.js" as KXYRecord
import "../teach/ProgramFlowPage.js" as BasePData
import "Teach.js" as LocalTeach
import "../../utils/stringhelper.js" as ICString


ProgramFlowPage {

    id:base
    actionMenuFrameSource: "ProgramActionMenuFrame.qml"

    function getRecordContent(which){
        if(which == 0)
            return JSON.parse(KXYRecord.keXuyePentuRecord.getRecordContent(panelRobotController.currentRecordName()));
        else
            return JSON.parse(panelRobotController.programs(which));
    }

    function pentuActionToProgram(actionObject){
        var ret = [];
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 2, actionObject.startPos.pos.m2, actionObject.startPosSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 0, actionObject.startPos.pos.m0, actionObject.startPosSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 1, actionObject.startPos.pos.m1, actionObject.startPosSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startPosSpeed4));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startPosSpeed5));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
        ret.push(LocalTeach.generateCounterAction(repeateSpeed));

        return ret;
    }

    function modelToProgram(which){
        var model = BasePData.programs[which];
        var ret = [];
        for(var i = 0; i < model.count; ++i){
            if(model.get(i).mI_ActionObject.action == LocalTeach.actions.F_CMD_PENTU){
                var ps = pentuActionToProgram(model.get(i).mI_ActionObject);
                for(var j = 0, len = ps.length; j < len; ++j){
                    ret.push(ps[j]);
                }
            }else
                ret.push(model.get(i).mI_ActionObject);
        }
        return JSON.stringify(ret);
    }

    function afterSaveProgram(which){
        var p = modelToProgramHelper(which);
        KXYRecord.keXuyePentuRecord.updateRecord(panelRobotController.currentRecordName(), JSON.stringify(p));
    }

    function actionObjectToText(actionObject){
        var originText;
        if(actionObject.action == LocalTeach.actions.F_CMD_PENTU)
            originText = LocalTeach.pentuActionToStringHandler(actionObject);
        else
            originText = LocalTeach.actionToStringNoCusomName(actionObject);
        if(actionObject.customName){
            var styledCN = ICString.icStrformat('<font size="4" color="#0000FF">{0}</font>', actionObject.customName);
            originText = styledCN + " " + originText;
        }
        return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + originText.replace("\n                            ", "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    }

}
