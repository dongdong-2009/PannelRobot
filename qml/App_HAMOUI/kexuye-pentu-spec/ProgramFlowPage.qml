import QtQuick 1.1
import "../teach"
import "KeXuYePentuRecord.js" as KXYRecord
import "../teach/ProgramFlowPage.js" as BasePData
import "Teach.js" as LocalTeach
import "../teach/Teach.js" as BaseTeach
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
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.startPos2, actionObject.startPosSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.rotateSpeed));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.rotateSpeed));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.rotateSpeed));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        ret.push(LocalTeach.generateClearCounterAction(actionObject.dirCounterID));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.repeateCounterID));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.rotateCounterID));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag0, "mojuxuanzhuan"));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.startPos2, actionObject.startPosSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.zleength, actionObject.startPosSpeed2));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag1, "ycundong"));

        ret.push(LocalTeach.generateOutputAction(0, 0, 1, 0, actionObject.fixtureDelay));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag2, "xcercle"));
        if(actionObject.mode == 0){
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_LINEXY_MOVE_POINT + actionObject.plane,
                  [{"pointName":"", "pos":{"m0":actionObject.point1.pos.m0,"m1":actionObject.point1.pos.m1}}],actionObject.repeatSpeed, 0.0));
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_LINEXY_MOVE_POINT + actionObject.plane,
                  [{"pointName":"", "pos":{"m0":actionObject.startPos.pos.m0,"m1":actionObject.startPos.pos.m1}}],actionObject.repeatSpeed, 0.0));
        }
        else if(actionObject.mode == 1){
            if(actionObject.rpeateAxis == 0){
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARCXY_MOVE_POINT + actionObject.plane,
                      [{"pointName":"", "pos":{"m0":actionObject.point1.pos.m0,"m2":actionObject.startPos.pos.m2}},{"pointName":"", "pos":{"m0":actionObject.point2.pos.m0,"m2":actionObject.zleength}}],
                      actionObject.repeatSpeed, 0.0));
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARCXY_MOVE_POINT + actionObject.plane,
                      [{"pointName":"", "pos":{"m0":actionObject.point1.pos.m0,"m2":actionObject.startPos.pos.m2}},{"pointName":"", "pos":{"m0":actionObject.startPos.pos.m0,"m2":actionObject.zleength}}],
                      actionObject.repeatSpeed, 0.0));
            }
            else if(actionObject.rpeateAxis == 1){
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARCXY_MOVE_POINT + actionObject.plane,
                      [{"pointName":"", "pos":{"m1":actionObject.point1.pos.m1,"m2":actionObject.startPos.pos.m2}},{"pointName":"", "pos":{"m1":actionObject.point2.pos.m1,"m2":actionObject.zleength}}],
                      actionObject.repeatSpeed, 0.0));
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARCXY_MOVE_POINT + actionObject.plane,
                      [{"pointName":"", "pos":{"m1":actionObject.point1.pos.m1,"m2":actionObject.startPos.pos.m2}},{"pointName":"", "pos":{"m1":actionObject.startPos.pos.m1,"m2":actionObject.zleength}}],
                      actionObject.repeatSpeed, 0.0));
                }
            }
        ret.push(LocalTeach.generateCounterAction(actionObject.repeateCounterID));
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag2, actionObject.repeateCounterID, 0, 1));

        ret.push(LocalTeach.generateOutputAction(0, 0, 0, 0, 0));

        if(actionObject.rpeateAxis == 0)
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION, [{"pointName":"", "pos":{"m0":"0.000","m1":actionObject.dirLength,"m2":"0.000"}}], actionObject.dirSpeed, 0.0));
        else if(actionObject.rpeateAxis == 1)
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION, [{"pointName":"", "pos":{"m0":actionObject.dirLength,"m1":"0.000","m2":"0.000"}}], actionObject.dirSpeed, 0.0));
        ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag1, actionObject.dirCounterID, 0, 1));


        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE, [{"pointName":"", "pos":{"m0":"0.000","m1":"0.000","m2":"0.000","m3":"0.000","m4":actionObject.rotate,"m5":"0.000"}}], actionObject.rotateSpeed, 0.0));
        ret.push(LocalTeach.generateCounterAction(actionObject.rotateCounterID));
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag0, actionObject.rotateCounterID, 0, 1));



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
            originText = BaseTeach.actionToStringNoCusomName(actionObject);
        if(actionObject.customName){
            var styledCN = ICString.icStrformat('<font size="4" color="#0000FF">{0}</font>', actionObject.customName);
            originText = styledCN + " " + originText;
        }
        return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + originText.replace("\n                            ", "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    }

    KexuYeActionEdit{
        id:kexuyeActionEdit
        visible: false
    }

    Component.onCompleted: {
        registerEditableAction(LocalTeach.actions.F_CMD_PENTU, kexuyeActionEdit, "kexuyeaction", [{"item":"kexuyeaction"}, {"item":"customName"}]);
    }

    onActionLineDeleted: {
        BaseTeach.counterManager.delCounter(actionObject.repeateCounterID);
        panelRobotController.delCounterDef(actionObject.repeateCounterID);
        BaseTeach.counterManager.delCounter(actionObject.dirCounterID);
        panelRobotController.delCounterDef(actionObject.dirCounterID);
        BaseTeach.counterManager.delCounter(actionObject.rotateCounterID);
        panelRobotController.delCounterDef(actionObject.rotateCounterID);
    }
}
