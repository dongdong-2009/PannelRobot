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

//    function getRecordContent(which){
//        if(which == 0)
//            return JSON.parse(KXYRecord.keXuyePentuRecord.getRecordContent(panelRobotController.currentRecordName()));
//        else
//            return JSON.parse(panelRobotController.programs(which));
//    }

    function pentuActionToProgram(actionObject){
        var ret = [];
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, 0, actionObject.startSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startSpeed3));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startSpeed4));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startSpeed5));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        ret.push(LocalTeach.generateClearCounterAction(actionObject.dirCounterID));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.repeateCounterID));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.rotateCounterID));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag0, qsTr("Fixture Rotation")));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, 0, actionObject.startSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.zlength, actionObject.startSpeed2));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag1, qsTr("Dir Move")));

        ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
        ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
        ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay3));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag2, qsTr("Repeate")));
        if(actionObject.mode == 0){
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.point1_m0, actionObject.repeatSpeed));
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.repeatSpeed));
//            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_LINEXY_MOVE_POINT + actionObject.plane,
//                     [{"pointName":"", "pos":actionObject.point1.pos}],actionObject.repeatSpeed, 0.0));
//            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_LINEXY_MOVE_POINT + actionObject.plane,
//                     [{"pointName":"", "pos":actionObject.startPos.pos}],actionObject.repeatSpeed, 0.0));
        }
        else if(actionObject.mode == 1){
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARCXY_MOVE_POINT + actionObject.plane,
                  [{"pointName":"", "pos":actionObject.point1.pos},{"pointName":"", "pos":actionObject.point2.pos}],
                  actionObject.repeatSpeed, 0.0));
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARCXY_MOVE_POINT + actionObject.plane,
                  [{"pointName":"", "pos":actionObject.point1.pos},{"pointName":"", "pos":actionObject.startPos.pos}],
                  actionObject.repeatSpeed, 0.0));
        }
        ret.push(LocalTeach.generateCounterAction(actionObject.repeateCounterID));
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag2, actionObject.repeateCounterID, 0, 1));

        ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
        ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
        ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));

        if(actionObject.dirAxis == 0)
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION, [{"pointName":"", "pos":{"m0":actionObject.dirLength,"m1":"0.000","m2":"0.000"}}], actionObject.dirSpeed, 0.0));
        else if(actionObject.dirAxis == 1)
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION, [{"pointName":"", "pos":{"m0":"0.000","m1":actionObject.dirLength,"m2":"0.000"}}], actionObject.dirSpeed, 0.0));
        else if(actionObject.dirAxis == 2)
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION, [{"pointName":"", "pos":{"m0":"0.000","m1":"0.000","m2":actionObject.dirLength}}], actionObject.dirSpeed, 0.0));
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
        if(actionObject.action == LocalTeach.actions.F_CMD_PENTU){
            originText = LocalTeach.pentuActionToStringHandler(actionObject);
        }
        else
            originText = BaseTeach.actionToStringNoCusomName(actionObject);
        if(actionObject.customName){
            var styledCN = ICString.icStrformat('<font size="4" color="#0000FF">{0}</font>', actionObject.customName);
            originText = styledCN + " " + originText;
        }
        return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + originText.replace(/\n                            /g, "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    }

    Rectangle{
        id:mask
        color: "#D0D0D0"
        height: 28
        width: 600
        x:2
        MouseArea{
            anchors.fill: parent
        }
    }

    KexuYeActionEdit{
        id:kexuyeActionEdit
        visible: false
        width: menuFrame().width - 20
        height: menuFrame().height - 50
    }
    KexuYeAxisSpeed{
        id:kexuyeDetailEdit
        visible: false
        width: menuFrame().width - 20
        height: 80
    }

    Component.onCompleted: {
        registerEditableAction(LocalTeach.actions.F_CMD_PENTU,
                               [{"editor":kexuyeActionEdit, "itemName":"kexuyeaction"},
                                {"editor":kexuyeDetailEdit, "itemName":"kexuyedetail"}
                               ],
                               [{"item":"kexuyeaction"}, {"item":"kexuyedetail"},{"item":"customName"}]);
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
