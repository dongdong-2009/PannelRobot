import QtQuick 1.1
import "../teach"
import "KeXuYePentuRecord.js" as KXYRecord
import "../teach/ProgramFlowPage.js" as BasePData
import "ProgramFlowPage.js" as LocalPData
import "Teach.js" as LocalTeach
import "../teach/Teach.js" as BaseTeach
import "../../utils/stringhelper.js" as ICString
import "../ShareData.js" as ShareData
import "../configs/Keymap.js" as Keymap
import "../configs/IODefines.js" as IODefines
import "../../utils/utils.js" as Utils
import "../teach/ManualProgramManager.js" as ManualProgramManager



ProgramFlowPage {
    id:base
    actionMenuFrameSource: "ProgramActionMenuFrame.qml"
    property int rows: 0


    function getRecordContent(which){
        if(which == 0){
            var lineInfo = JSON.parse(KXYRecord.keXuyePentuRecord.getLineInfo(panelRobotController.currentRecordName()));
            LocalPData.stepToKeXuYeRowMap = lineInfo[0];
            LocalPData.kexueyeRowToStepMap = lineInfo[1];
            var ret = JSON.parse(KXYRecord.keXuyePentuRecord.getRecordContent(panelRobotController.currentRecordName()));
            for(var i = 0;i < ret.length;i++){
                if(ret[i].action == LocalTeach.actions.F_CMD_PENTU){
                    for(var j = 0;j < 16;j++){
                        var a = "flag" + j;
                        LocalTeach.flagsDefine.pushFlag(0,new LocalTeach.FlagItem(ret[i][a],""));
                    }
                }
            }
            return ret;
        }
        else
            return JSON.parse(panelRobotController.programs(which));
    }
    function mappedModelRunningActionInfo(baseRunningInfo){
        if(baseRunningInfo.programIndex != 0) return baseRunningInfo;
        var uiSteps = baseRunningInfo.steps;
        for(var i = 0, len = uiSteps.length; i < len; ++i){
            baseRunningInfo.steps[i] = LocalPData.stepToKeXuYeRowMap[uiSteps[i]];
        }
        return baseRunningInfo;
    }

    function copyLine(){
        var currentLine =  Utils.cloneObject(currentModelData().mI_ActionObject);
        if(currentLine.action == LocalTeach.actions.F_CMD_PENTU){
            var ret =  kexuyeActionEdit.createActionObj(currentLine)[0];
            return ret;
        }
        else return currentLine;
    }
    function calcSingleStepLine(currentSel){
        return LocalPData.kexueyeRowToStepMap[currentSel];
    }


    function axischange(actionObject){
            switch(actionObject.plane){
                case 0:
                    if(actionObject.dirAxis == 0){
                        actionObject.rpeateAxis = 1;
                        actionObject.startPos0 = actionObject.startPos.pos.m1;
                        actionObject.startPos1 = actionObject.startPos.pos.m0;
                        actionObject.startSpeed0 = actionObject.startPosSpeed1;
                        actionObject.startSpeed1 = actionObject.startPosSpeed0;
                        actionObject.point1_m0 = actionObject.point1.pos.m1;
                        actionObject.point1_m1 = actionObject.point1.pos.m0;
                    }
                    else if(actionObject.dirAxis == 1){
                        actionObject.rpeateAxis = 0;
                        actionObject.startPos0 = actionObject.startPos.pos.m0;
                        actionObject.startPos1 = actionObject.startPos.pos.m1;
                        actionObject.startSpeed0 = actionObject.startPosSpeed0;
                        actionObject.startSpeed1 = actionObject.startPosSpeed1;
                        actionObject.point1_m0 = actionObject.point1.pos.m0;
                        actionObject.point1_m1 = actionObject.point1.pos.m1;
                    }
                    actionObject.deepAxis = 2;
                    actionObject.startPos2 = actionObject.startPos.pos.m2;
                    actionObject.startSpeed2 = actionObject.startPosSpeed2;
                    break;
                case 1:
                    if(actionObject.dirAxis == 0){
                        actionObject.rpeateAxis = 2;
                        actionObject.startPos0 = actionObject.startPos.pos.m2;
                        actionObject.startPos1 = actionObject.startPos.pos.m0;
                        actionObject.startSpeed0 = actionObject.startPosSpeed2;
                        actionObject.startSpeed1 = actionObject.startPosSpeed0;
                        actionObject.point1_m0 = actionObject.point1.pos.m2;
                        actionObject.point1_m1 = actionObject.point1.pos.m0;
                    }
                    else {
                        actionObject.dirAxis += 1;
                        actionObject.rpeateAxis = 0;
                        actionObject.startPos0 = actionObject.startPos.pos.m0;
                        actionObject.startPos1 = actionObject.startPos.pos.m2;
                        actionObject.startSpeed0 = actionObject.startPosSpeed0;
                        actionObject.startSpeed1 = actionObject.startPosSpeed2;
                        actionObject.point1_m0 = actionObject.point1.pos.m0;
                        actionObject.point1_m1 = actionObject.point1.pos.m2;
                    }
                    actionObject.deepAxis = 1;
                    actionObject.startPos2 = actionObject.startPos.pos.m1;
                    actionObject.startSpeed2 = actionObject.startPosSpeed1;
                    break;
                case 2:
                    actionObject.dirAxis += 1;
                    if(actionObject.dirAxis == 1){
                        actionObject.rpeateAxis = 2;
                        actionObject.startPos0 = actionObject.startPos.pos.m2;
                        actionObject.startPos1 = actionObject.startPos.pos.m1;
                        actionObject.startSpeed0 = actionObject.startPosSpeed2;
                        actionObject.startSpeed1 = actionObject.startPosSpeed1;
                        actionObject.point1_m0 = actionObject.point1.pos.m2;
                        actionObject.point1_m1 = actionObject.point1.pos.m1;
                    }
                    else {
                        actionObject.rpeateAxis = 1;
                        actionObject.startPos0 = actionObject.startPos.pos.m1;
                        actionObject.startPos1 = actionObject.startPos.pos.m2;
                        actionObject.startSpeed0 = actionObject.startPosSpeed1;
                        actionObject.startSpeed1 = actionObject.startPosSpeed2;
                        actionObject.point1_m0 = actionObject.point1.pos.m1;
                        actionObject.point1_m1 = actionObject.point1.pos.m2;
                    }
                    actionObject.deepAxis = 0;
                    actionObject.startPos2 = actionObject.startPos.pos.m0;
                    actionObject.startSpeed2 = actionObject.startPosSpeed0;
                    break;
            }

//        switch(actionObject.plane){
//            case 0:
//                if(actionObject.dirAxis == 0){
//                    actionObject.rpeateAxis = 1;
//                    var tmp = actionObject.startPos0;
//                    actionObject.startPos0 = actionObject.startPos1;
//                    actionObject.startPos1 = tmp;
//                    tmp = actionObject.startSpeed0;
//                    actionObject.startSpeed0 = actionObject.startSpeed1;
//                    actionObject.startSpeed1 = tmp;
//                    tmp = actionObject.point1_m0;
//                    actionObject.point1_m0 = actionObject.point1_m1;
//                    actionObject.point1_m1 = tmp;
//                }
//                else if(actionObject.dirAxis == 1){
//                    actionObject.rpeateAxis = 0;
////                    startPos0 = startPos.pos.m0;
////                    startPos1 = startPos.pos.m1;
////                    startSpeed0 = startPosSpeed0;
////                    startSpeed1 = startPosSpeed1;
////                    point1_m0 = point1.pos.m0;
////                    point1_m1 = point1.pos.m1;
//                }
//                actionObject.deepAxis = 2;
////                var startPos2 = startPos.pos.m2;
////                var startSpeed2 = startPosSpeed2;
//                break;
//            case 1:
//                if(actionObject.dirAxis == 0){
//                    actionObject.rpeateAxis = 2;
//                    tmp = actionObject.startPos0;
//                    actionObject.startPos0 = actionObject.startPos2;
//                    actionObject.startPos2 = tmp;
//                    tmp = actionObject.startSpeed0;
//                    actionObject.startSpeed0 = actionObject.startSpeed2;
//                    actionObject.startSpeed2 = tmp;
//                    tmp = actionObject.point1_m0;
//                    actionObject.point1_m0 = actionObject.point1_m2;
//                    actionObject.point1_m2 = tmp;
//                }
//                else {
//                    actionObject.rpeateAxis = 0;
//                    actionObject.startPos1 = actionObject.startPos2;
//                    actionObject.startSpeed1 = actionObject.startSpeed2;
//                    actionObject.point1_m1 = point1_m2;
//                }
//                actionObject.deepAxis = 1;
//                actionObject.startPos2 = actionObject.startPos1;
//                actionObject.startSpeed2 = actionObject.startSpeed1;
//                break;
//            case 2:
//                if(actionObject.dirAxis == 1){
//                    actionObject.rpeateAxis = 2;
//                    actionObject.startPos0 = actionObject.startPos2;
//                    actionObject.startSpeed0 = actionObject.startSpeed2;
//                    actionObject.point1_m0 = actionObject.point1_m2;
//                }
//                else {
//                    actionObject.rpeateAxis = 1;
//                    actionObject.startPos0 = actionObject.startPos1;
//                    actionObject.startPos1 = actionObject.startPos2;
//                    actionObject.startSpeed0 = actionObject.startSpeed1;
//                    actionObject.startSpeed1 = actionObject.startSpeed2;
//                    actionObject.point1_m0 = actionObject.point1_m1;
//                    actionObject.point1_m1 = actionObject.point1_m2;
//                }
//                actionObject.deepAxis = 0;
//                actionObject.startPos2 = actionObject.startPos0;
//                actionObject.startSpeed2 = actionObject.startSpeed0;
//                break;
//        }
    }
    function getready(ret,actionObject){
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 2, 0, actionObject.startPosSpeed2,0.1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 0, actionObject.startPos.pos.m0, actionObject.startPosSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 1, actionObject.startPos.pos.m1, actionObject.startPosSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startPosSpeed4));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startPosSpeed5));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
    }
    function guncloseAction(ret,actionObject){
        if(actionObject.gun1use2 && actionObject.gun2use2)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use2)
            ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0));
        if(actionObject.gun2use2)
            ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0));
        if(actionObject.gun1use2 && actionObject.gun2use2)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

//        if(actionObject.gun1use1 && actionObject.gun2use1)
//            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
//        if(actionObject.gun1use1)
//            ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, actionObject.fixtureDelay1));
//        if(actionObject.gun2use1)
//            ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//        if(actionObject.gun1use1 && actionObject.gun2use1)
//            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

//        if(actionObject.gun1use0 && actionObject.gun2use0)
//            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
//        if(actionObject.gun1use0)
//            ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, actionObject.fixtureDelay0));
//        if(actionObject.gun2use0)
//            ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//        if(actionObject.gun1use0 && actionObject.gun2use0)
//            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
    }
    function allcloseAction(ret,actionObject){
        if(actionObject.gun1use2 && actionObject.gun2use2)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use2)
            ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, actionObject.fixtureDelay2));
        if(actionObject.gun2use2)
            ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
        if(actionObject.gun1use2 && actionObject.gun2use2)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        if(actionObject.gun1use1 && actionObject.gun2use1)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use1)
            ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, actionObject.fixtureDelay1));
        if(actionObject.gun2use1)
            ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
        if(actionObject.gun1use1 && actionObject.gun2use1)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        if(actionObject.gun1use0 && actionObject.gun2use0)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use0)
            ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, actionObject.fixtureDelay0));
        if(actionObject.gun2use0)
            ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
        if(actionObject.gun1use0 && actionObject.gun2use0)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
    }
    function gun1openAction(ret,actionObject){
        if(actionObject.gun1use0 && actionObject.gun2use0)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use0)
            ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
        if(actionObject.gun2use0)
            ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
        if(actionObject.gun1use0 && actionObject.gun2use0)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        if(actionObject.gun1use1 && actionObject.gun2use1)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use1)
            ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
        if(actionObject.gun2use1)
            ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
        if(actionObject.gun1use1 && actionObject.gun2use1)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        if(actionObject.gun1use2 && actionObject.gun2use2)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use2)
            ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, 0.05));
        if(actionObject.gun2use2)
            ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, 0.05));
        if(actionObject.gun1use2 && actionObject.gun2use2)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
    }
    function gunopenAction(ret,actionObject){
        if(actionObject.gun1use0 && actionObject.gun2use0)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use0)
            ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
        if(actionObject.gun2use0)
            ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
        if(actionObject.gun1use0 && actionObject.gun2use0)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        if(actionObject.gun1use1 && actionObject.gun2use1)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use1)
            ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
        if(actionObject.gun2use1)
            ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
        if(actionObject.gun1use1 && actionObject.gun2use1)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        if(actionObject.gun1use2 && actionObject.gun2use2)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        if(actionObject.gun1use2)
            ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay2));
        if(actionObject.gun2use2)
            ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
        if(actionObject.gun1use2 && actionObject.gun2use2)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
    }

    function getActionProperties(action,axisID,sPos,ePos,spd,ceycle,delay){
        return {
            "action":action,
            "axis":axisID,
            "pos1":sPos||0.000,
            "pos2":ePos||0.000,
            "speed":spd||80.0,
            "num":ceycle||0,
            "delay":delay||0.00};
    }
    function pentuActionHead(actionObject1){
        var actionObject = Utils.cloneObject(actionObject1);
        axischange(actionObject);
        var ret = [];
//        ret.push(BaseTeach.generateCustomAction(getActionProperties(1000,0,200,500,80,2)));       //喷枪摇摆

//        ret.push(LocalTeach.generateOutputAction(16,0,0,16,0));     //Y30 close
//        ret.push(LocalTeach.generateOutputAction(17,0,0,17,0));     //close
//        ret.push(LocalTeach.generateOutputAction(18,0,0,18,0));     //close
//        ret.push(LocalTeach.generateOutputAction(19,0,0,19,0));     //close
        ret.push(LocalTeach.generateOutputAction(10,0,0,10,0));     //Y34 close
        ret.push(LocalTeach.generateOutputAction(11,0,0,11,0));     //close
        ret.push(LocalTeach.generateOutputAction(0,IODefines.M_BOARD_0,0,0,0));     //m0 close
        ret.push(LocalTeach.generateOutputAction(1,IODefines.M_BOARD_0,0,1,0));     //m1 close
        ret.push(LocalTeach.generateOutputAction(2,IODefines.M_BOARD_0,0,1,0));     //m2 close

//        ret.push(LocalTeach.generateOutputAction(12,100,1,12,1));     //Y24 close
//        ret.push(LocalTeach.generateOutputAction(13,100,1,13,1));     //Y25 close

        getready(ret,actionObject);
        ret.push(LocalTeach.generateConditionAction(0, 10, 0, 1, 0,actionObject.flag8));
        ret.push(LocalTeach.generateConditionAction(0, 11, 0, 1, 0,actionObject.flag9));
        ret.push(LocalTeach.generateJumpAction(actionObject.flag5));
        ret.push(LocalTeach.generateFlagAction(actionObject.flag8, qsTr("Negitv En")));
        ret.push(LocalTeach.generateOutputAction(0,IODefines.M_BOARD_0,1,0,0));     //m0 open
        ret.push(LocalTeach.generateJumpAction(actionObject.flag13));
        ret.push(LocalTeach.generateFlagAction(actionObject.flag9, qsTr("Postv En")));
        ret.push(LocalTeach.generateOutputAction(0,IODefines.M_BOARD_0,0,0,0));     //m0 close
        ret.push(LocalTeach.generateJumpAction(actionObject.flag13));
        ret.push(LocalTeach.generateFlagAction(actionObject.flag5, qsTr("gongzhuan Not OK")));
        ret.push(LocalTeach.generateOutputAction(11,0,1,11,0));     //gongzhuanhuiyuan
        ret.push(LocalTeach.generateWaitAction(11,0,1,10));
        ret.push(LocalTeach.generateOutputAction(11,0,0,11,0));
        ret.push(LocalTeach.generateFlagAction(actionObject.flag13, qsTr("gongzhuan OK")));

//        ret.push(LocalTeach.generateOutputAction(16,0,1,16,0));     //mujuhuiyuan
//        ret.push(LocalTeach.generateWaitAction(18,0,1,100));
//        ret.push(LocalTeach.generateOutputAction(16,0,0,16,0));

//        ret.push(LocalTeach.generateOutputAction(18,0,1,18,0));
//        ret.push(LocalTeach.generateWaitAction(19,0,1,100));
//        ret.push(LocalTeach.generateOutputAction(18,0,0,18,0));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag11, qsTr("gongzhuan Postv OK")));
//        ret.push(LocalTeach.generateOutputAction(2,IODefines.M_BOARD_0,0,1,0));     //m2 close
//        ret.push(LocalTeach.generateDataAction(819206,0,1));          //clear up all counters
//        ret.push(LocalTeach.generateWaitAction(4,0,1,10));
//        ret.push(LocalTeach.generateWaitAction(5,0,1,10));
//        ret.push(LocalTeach.generateClearCounterAction(actionObject.dirCounterID));
//        ret.push(LocalTeach.generateClearCounterAction(actionObject.repeateCounterID));
//        ret.push(LocalTeach.generateClearCounterAction(actionObject.rotateCounterID));
//        ret.push(LocalTeach.generateClearCounterAction(actionObject.rotateOKCID));
//        ret.push(LocalTeach.generateClearCounterAction(actionObject.aaaa));
//        ret.push(LocalTeach.generateClearCounterAction(actionObject.bbbb));

//        ret.push(LocalTeach.generateFlagAction(actionObject.flag0, qsTr("Fixture Rotation")));
//        ret.push(LocalTeach.generateOutputAction(2,IODefines.M_BOARD_0,0,1,0));     //m2 close
        return ret;
    }
    function pentuActionEnd(actionObject1){
        var actionObject = Utils.cloneObject(actionObject1);
        axischange(actionObject);
        var ret = [];
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag13, qsTr("UselessRotation")));
//        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag0, actionObject.rotateCounterID, 0, 1));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startSpeed4));

        ret.push(LocalTeach.generateCounterAction(actionObject.rotateCounterID));               //products count++
        ret.push(LocalTeach.generateConditionAction(4, 0, 1, 1, 0,actionObject.flag4));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 2, 0, actionObject.startPosSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateOutputAction(10,0,1,10,0));   //gongzhuangzhengzhuang open
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 0, actionObject.startPos.pos.m0, actionObject.startPosSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 1, actionObject.startPos.pos.m1, actionObject.startPosSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
//        generateAxisServoAction = function(action,axis,pos,speed,delay,isBadEn,isEarlyEnd,earlyEndPos,isEarlySpd,earlySpdPos,earlySpd,signalStopEn,signalStopPoint,signalStopMode,speedMode,stop)
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startPosSpeed5,0,false,true,3600));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        ret.push(LocalTeach.generateWaitAction(11,0,0,10));
        ret.push(LocalTeach.generateWaitAction(10,0,1,100));
        ret.push(LocalTeach.generateOutputAction(10,0,0,10,0));     //close
        ret.push(LocalTeach.generateOutputAction(0,IODefines.M_BOARD_0,1,0,0));     //m0 poen
        ret.push(LocalTeach.generateWaitAction(4,0,1,10));
        ret.push(LocalTeach.generateWaitAction(5,0,1,10));
        ret.push(LocalTeach.generateConditionAction(4, 0, 1, 1, 0,actionObject.flag11));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag4, qsTr("negative")));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 2, 0, actionObject.startPosSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateOutputAction(11,0,1,11,0));   //gongzhuangfanzhuang open
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 0, actionObject.startPos.pos.m0, actionObject.startPosSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 1, actionObject.startPos.pos.m1, actionObject.startPosSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startPosSpeed4,0,false,true,3600));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        ret.push(LocalTeach.generateWaitAction(10,0,0,10));
        ret.push(LocalTeach.generateWaitAction(11,0,1,100));
        ret.push(LocalTeach.generateOutputAction(11,0,0,11,0));                         //close
        ret.push(LocalTeach.generateOutputAction(0,IODefines.M_BOARD_0,0,0,0));     //m0 close
        ret.push(LocalTeach.generateWaitAction(4,0,1,10));
        ret.push(LocalTeach.generateWaitAction(5,0,1,10));
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag5, qsTr("positive")));

        return ret;
    }

    function pentuActionToProgram(actionObject1,actionObject2){
        var actionObject = Utils.cloneObject(actionObject1);
        axischange(actionObject);
        var ret = [];

        ret.push(LocalTeach.generateConditionAction(4, 0, 1, 1, 0,actionObject.flag14));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.rotate, actionObject.rotateSpeed));
//        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE, [{"pointName":"", "pos":{"m0":"0.000","m1":"0.000","m2":"0.000","m3":"0.000","m4":"0.000","m5":actionObject.rotate}}], actionObject.rotateSpeed, 0.0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
        if(actionObject.mode == 9 && actionObject.isRotateCycle)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, 0,
                                actionObject.rotateSpeed,0,false,false,0,false,0,0,false,0,0,1,false,0));

        ret.push(LocalTeach.generateConditionAction(4, 0, 1, 0, 0,actionObject.flag15));
        ret.push(LocalTeach.generateFlagAction(actionObject.flag14, qsTr("Rotate1")));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.rotate, actionObject.rotateSpeed));
//        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE, [{"pointName":"", "pos":{"m0":"0.000","m1":"0.000","m2":"0.000","m3":"0.000","m4":actionObject.rotate,"m5":"0.000"}}], actionObject.rotateSpeed, 0.0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
        if(actionObject.mode == 9 && actionObject.isRotateCycle)
            ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, 0,
                                actionObject.rotateSpeed,0,false,false,0,false,0,0,false,0,0,1,false,0));
        ret.push(LocalTeach.generateFlagAction(actionObject.flag15, qsTr("Rotate2")));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.startPos2, actionObject.startPosSpeed2));


        if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
            gunopenAction(ret,actionObject);
        if(actionObject.fixture1Switch == 4)
            gunopenAction(ret,actionObject);
        else if(actionObject.fixture1Switch == 3)
            allcloseAction(ret,actionObject);
        if(actionObject.useStack){
            ret.push(LocalTeach.generateFlagAction(actionObject.flag10, qsTr("Stack Mark")));
            ret.push(LocalTeach.generateStackAction(actionObject.stack1,actionObject.stackSpeed));
        }

        ret.push(LocalTeach.generateFlagAction(actionObject.flag1, qsTr("Dir Move")));


//        ret.push(LocalTeach.generateOutputAction(16, 0, 0, 16, 0));
//        if(actionObject.fixture1Switch == 4)
//            gun1openAction(ret,actionObject);
//        else if(actionObject.fixture1Switch == 3)
//            guncloseAction(ret,actionObject);
//        if(actionObject.fixture2Switch == 4){
//            ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
//            ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
//            ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
//        }
//        else if(actionObject.fixture2Switch == 3){
//            ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//            ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//            ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//        }
        if(actionObject.mode == 3 || actionObject.mode == 7)
            ret.push(LocalTeach.generateFlagAction(actionObject.flag2, qsTr("Repeate")));

        if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
            gun1openAction(ret,actionObject);
//        if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
//            ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
//            ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
//            ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
//        }


        var pos = {};
        var pos1 = {};
        var tmp = {};
        var tmp1 = {};
        var dirpos = {};
        var repeatEPos = actionObject.point1.pos;
        var dirEPos = actionObject.point2.pos;
        pos["m" + 0] = actionObject.point1.pos.m0 - actionObject.startPos.pos.m0;
        pos["m" + 1] = actionObject.point1.pos.m1 - actionObject.startPos.pos.m1;
        pos["m" + 2] = actionObject.point1.pos.m2 - actionObject.startPos.pos.m2;
//        if(actionObject.mode > 3){
            pos["m" + 3] = actionObject.point1.pos.m3 - actionObject.startPos.pos.m3;
            tmp["m" + 3] = pos["m" + 3] / 2;
            tmp1["m" + 3] = -tmp["m" + 3];
            pos1["m" + 3] = -pos["m" + 3];

            pos["m" + 4] = pos["m" + 5] = pos["m" + 6] = 0;
            pos1["m" + 4] = pos1["m" + 5] = pos1["m" + 6] = 0;
            tmp["m" + 4] = tmp["m" + 5] = tmp["m" + 6] = 0;
            tmp1["m" + 4] = tmp1["m" + 5] = tmp1["m" + 6] = 0;
//        }
        if(actionObject.mode == 0 || actionObject.mode == 4){
            tmp["m" + 0] = pos["m" + 0] / 2;
            tmp["m" + 1] = pos["m" + 1] / 2;
            tmp["m" + 2] = pos["m" + 2] / 2;
            tmp1["m" + 0] = -tmp["m" + 0];
            tmp1["m" + 1] = -tmp["m" + 1];
            tmp1["m" + 2] = -tmp["m" + 2];
            if(actionObject.plane == 0){
                if(actionObject.dirAxis == 0){
                    dirpos["m" + 1] = tmp["m" + 0] = tmp1["m" + 0] = pos["m" + 0] = 0;
                    dirpos["m" + 0] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else{
                    dirpos["m" + 0] = tmp["m" + 1] = tmp1["m" + 1] = pos["m" + 1] = 0;
                    dirpos["m" + 1] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
                dirpos["m" + 2] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            else if(actionObject.plane == 1){
                if(actionObject.dirAxis == 0){
                    dirpos["m" + 2] = tmp["m" + 0] = tmp1["m" + 0] = pos["m" + 0] = 0;
                    dirpos["m" + 0] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else{
                    dirpos["m" + 0] = tmp["m" + 2] = tmp1["m" + 2] = pos["m" + 2] = 0;
                    dirpos["m" + 2] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
                dirpos["m" + 1] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            else if(actionObject.plane == 2){
                if(actionObject.dirAxis == 1){
                    dirpos["m" + 2] = tmp["m" + 1] = tmp1["m" + 1] = pos["m" + 1] = 0;
                    dirpos["m" + 1] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else{
                    dirpos["m" + 1] = tmp["m" + 2] = tmp1["m" + 2] = pos["m" + 2] = 0;
                    dirpos["m" + 2] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
                dirpos["m" + 0] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            pos1["m" + 0] = -pos["m" + 0];
            pos1["m" + 1] = -pos["m" + 1];
            pos1["m" + 2] = -pos["m" + 2];

//            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,       //Ydir
//                     [{"pointName":"", "pos":dirpos}], actionObject.dirSpeed, 0.0));

            if(actionObject.mode == 0)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                         [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
//                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE,
//                         [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
//            var tmpcount = 0;
//            if(actionObject.mode == 0){
//                var tmpret = ManualProgramManager.manualProgramManager.getProgram(actionObject.editaction).program;
//                for(var i = 0, len =  tmpret.length; i < len; ++i){
//                    if(tmpret[i].action == LocalTeach.actions.ACT_END)
//                        break;
//                    ret.push(tmpret[i]);
//                }
//            }

            else if(actionObject.mode == 4){
//                ret.push(LocalTeach.generateSpeedAction(0,actionObject.repeateSpeed));
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp},
                          {"pointName":"", "pos":pos}],
                          actionObject.repeateSpeed, 0.0));

//                if(actionObject.plane == 1){
//                    if(actionObject.dirAxis == 0){
//                        ////////////////////add hu
//                        var temp111 = {},pos111 = {};
//                        temp111["m" + 0] = 0;
//                        temp111["m" + 1] = 3;
//                        temp111["m" + 2] = 1;
//                        temp111["m" + 3] = 0;
//                        temp111["m" + 4] = 0;
//                        temp111["m" + 5] = 0;

//                        pos111["m" + 0] = 0;
//                        pos111["m" + 1] = 4;
//                        pos111["m" + 2] = 4;
//                        pos111["m" + 3] = 0;
//                        pos111["m" + 4] = 0;
//                        pos111["m" + 5] = 0;
//                        ret.push(LocalTeach.generateSpeedAction(actionObject.repeateSpeed,actionObject.repeateSpeed));
//                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
//                                 [{"pointName":"", "pos":temp111},
//                                  {"pointName":"", "pos":pos111}],
//                                  actionObject.repeateSpeed, 0.0));
//                        ////////////////////add hu

//                        ////////////////////add line

//                        var pos_line1 = {};
//                        pos_line1["m" + 0] = 0;
//                        pos_line1["m" + 1] = 0;
//                        pos_line1["m" + 2] = 100;
//                        ret.push(LocalTeach.generateSpeedAction(actionObject.repeateSpeed,0));
//                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
//                                 [{"pointName":"", "pos":pos_line1}], actionObject.repeateSpeed, 0.0));
//                        ////////////////////add line
//                    }
//                }
            }
            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2)
                guncloseAction(ret,actionObject);
//            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
//                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//            }

            ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag12, actionObject.dirCounterID, 1, 0));
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                     [{"pointName":"", "pos":dirpos}], actionObject.dirSpeed, 0.0));

           if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2)
               gun1openAction(ret,actionObject);
//            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
//                ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
//            }
            if(actionObject.mode == 0)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
//                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE,
//                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
//            if(actionObject.mode == 0){
//                tmpret = ManualProgramManager.manualProgramManager.getProgram(actionObject.editaction);
//                if(tmpret[0].action == LocalTeach.actions.ACT_FLAG && tmpret[0].flag == 0){
//                    for(i = tmpcount ; i < tmpret.length; ++i){
//                        if(tmpret[i].action == LocalTeach.actions.ACT_END){
//                            break;
//                        }
//                        ret.push(tmpret[i]);
//                    }
//                }
//            }
            else if(actionObject.mode == 4){
//                if(actionObject.plane == 1){
//                    if(actionObject.dirAxis == 0){
//                        ////////////////////add line
//                        var pos_line2 = {};
//                        pos_line2["m" + 0] = 0;
//                        pos_line2["m" + 1] = 0;
//                        pos_line2["m" + 2] = -100;
////                        ret.push(LocalTeach.generateSpeedAction(0,actionObject.repeateSpeed));
////                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
////                                 [{"pointName":"", "pos":pos_line2}], actionObject.repeateSpeed, 0.0));
//                        ////////////////////add line

//                        ////////////////////add hu
//                        var temp2222 = {},pos2222 = {};
//                        temp2222["m" + 0] = 0;
//                        temp2222["m" + 1] = -1;
//                        temp2222["m" + 2] = -3;
//                        temp2222["m" + 3] = 0;
//                        temp2222["m" + 4] = 0;
//                        temp2222["m" + 5] = 0;

//                        pos2222["m" + 0] = 0;
//                        pos2222["m" + 1] = -4;
//                        pos2222["m" + 2] = -4;
//                        pos2222["m" + 3] = 0;
//                        pos2222["m" + 4] = 0;
//                        pos2222["m" + 5] = 0;
//                        ret.push(LocalTeach.generateSpeedAction(actionObject.repeateSpeed,actionObject.repeateSpeed));
//                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
//                                 [{"pointName":"", "pos":temp2222},
//                                  {"pointName":"", "pos":pos2222}],
//                                  actionObject.repeateSpeed, 0.0));
//                        ////////////////////add hu
//                    }
//                }
//                ret.push(LocalTeach.generateSpeedAction(actionObject.repeateSpeed,0));
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp1},
                          {"pointName":"", "pos":pos1}],
                          actionObject.repeateSpeed, 0.0));
            }
            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
                guncloseAction(ret,actionObject);
//            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
//                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//            }

            ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag12, actionObject.dirCounterID, 1, 0));

            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                     [{"pointName":"", "pos":dirpos}], actionObject.dirSpeed, 0.0));
            ret.push(LocalTeach.generateFlagAction(actionObject.flag12, qsTr("duoyu dir")));
        }

        else if(actionObject.mode == 1 || actionObject.mode == 5){
            pos1["m" + 0] = -pos["m" + 0];
            pos1["m" + 1] = -pos["m" + 1];
            pos1["m" + 2] = -pos["m" + 2];
            tmp["m" + 0] = pos["m" + 0] / 2;
            tmp["m" + 1] = pos["m" + 1] / 2;
            tmp["m" + 2] = pos["m" + 2] / 2;
            tmp1["m" + 0] = -tmp["m" + 0];
            tmp1["m" + 1] = -tmp["m" + 1];
            tmp1["m" + 2] = -tmp["m" + 2];
            if(actionObject.plane == 0){
                if(actionObject.dirAxis == 0){
                    tmp["m" + 0] = pos["m" + 0] = 0;
                    tmp1["m" + 0] = actionObject.dirLength / 2;
                    pos1["m" + 0] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else {
                    tmp["m" + 1] = pos["m" + 1] = 0;
                    tmp1["m" + 1] = actionObject.dirLength / 2;
                    pos1["m" + 1] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
                pos1["m" + 2] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            else if(actionObject.plane == 1){
                if(actionObject.dirAxis == 0){
                    tmp["m" + 0] = pos["m" + 0] = 0;
                    tmp1["m" + 0] = actionObject.dirLength / 2;
                    pos1["m" + 0] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else {
                    tmp["m" + 2] = pos["m" + 2] = 0;
                    tmp1["m" + 2] = actionObject.dirLength / 2;
                    pos1["m" + 2] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
                pos1["m" + 1] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            else if(actionObject.plane == 2){
                if(actionObject.dirAxis == 1){
                    tmp["m" + 1] = pos["m" + 1] = 0;
                    tmp1["m" + 1] = actionObject.dirLength / 2;
                    pos1["m" + 1] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else {
                    tmp["m" + 2] = pos["m" + 2] = 0;
                    tmp1["m" + 2] = actionObject.dirLength / 2;
                    pos1["m" + 2] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
                pos1["m" + 0] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            if(actionObject.mode == 1)
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                     [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
            else if(actionObject.mode == 5)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp},
                          {"pointName":"", "pos":pos}],
                          actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
                guncloseAction(ret,actionObject);
                gun1openAction(ret,actionObject);
            }
//            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
//                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//                ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
//            }
            if(actionObject.mode == 1)
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                     [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
            else if(actionObject.mode == 5)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp1},
                          {"pointName":"", "pos":pos1}],
                          actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
                guncloseAction(ret,actionObject);
//            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
//                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//            }
            ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
        }

        else if(actionObject.mode == 2 || actionObject.mode == 6){
            pos1["m" + 0] = -pos["m" + 0];
            pos1["m" + 1] = -pos["m" + 1];
            pos1["m" + 2] = -pos["m" + 2];
            tmp["m" + 0] = pos["m" + 0] / 2;
            tmp["m" + 1] = pos["m" + 1] / 2;
            tmp["m" + 2] = pos["m" + 2] / 2;
            tmp1["m" + 0] = -tmp["m" + 0];
            tmp1["m" + 1] = -tmp["m" + 1];
            tmp1["m" + 2] = -tmp["m" + 2];
            var ceycle,dirlength;
            if(actionObject.plane == 0){
                if(actionObject.dirAxis == 0){
                    if(actionObject.mode == 2){
                        dirlength = dirEPos.m0;
                        ceycle = Math.ceil(((dirEPos.m0 - actionObject.startPos.pos.m0) * actionObject.repeateSpeed) / ((repeatEPos.m1 - actionObject.startPos.pos.m1) * actionObject.dirSpeed));
                        pos1["m" + 0] = pos["m" + 0] = 0;
                    }
                    else{
                        pos1.m0 = pos.m0;
                        tmp1.m0 = tmp.m0;
                    }
                }
                else {
                    if(actionObject.mode == 2){
                        dirlength = dirEPos.m1;
                        ceycle = Math.ceil(((dirEPos.m1 - actionObject.startPos.pos.m1) * actionObject.repeateSpeed) / ((repeatEPos.m0 - actionObject.startPos.pos.m0) * actionObject.dirSpeed));
                        pos1["m" + 1] = pos["m" + 1] = 0;
                    }
                    else{
                        pos1.m1 = pos.m1;
                        tmp1.m1 = tmp.m1;
                    }
                }
                tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
            }
            else if(actionObject.plane == 1){
                if(actionObject.dirAxis == 0){
                    if(actionObject.mode == 2){
                        dirlength = dirEPos.m0;
                        ceycle = Math.ceil(((dirEPos.m0 - actionObject.startPos.pos.m0) * actionObject.repeateSpeed) / ((repeatEPos.m2 - actionObject.startPos.pos.m2) * actionObject.dirSpeed));
                        pos1["m" + 0] = pos["m" + 0] = 0;
                    }
                    else{
                        pos1.m0 = pos.m0;
                        tmp1.m0 = tmp.m0;
                    }
                }
                else {
                    if(actionObject.mode == 2){
                        dirlength = dirEPos.m2;
                        ceycle = Math.ceil(((dirEPos.m2 - actionObject.startPos.pos.m2) * actionObject.repeateSpeed) / ((repeatEPos.m0 - actionObject.startPos.pos.m0) * actionObject.dirSpeed));
                        pos1["m" + 2] = pos["m" + 2] = 0;
                    }
                    else{
                        pos1.m2 = pos.m2;
                        tmp1.m2 = tmp.m2;
                    }
                }
                tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
            }
            else if(actionObject.plane == 2){
                if(actionObject.dirAxis == 1){
                    if(actionObject.mode == 2){
                        dirlength = dirEPos.m1;
                        ceycle = Math.ceil(((dirEPos.m1 - actionObject.startPos.pos.m1) * actionObject.repeateSpeed) / ((repeatEPos.m2 - actionObject.startPos.pos.m2) * actionObject.dirSpeed));
                        pos1["m" + 1] = pos["m" + 1] = 0;
                    }
                    else{
                        pos1.m1 = pos.m1;
                        tmp1.m1 = tmp.m1;
                    }
                }
                else {
                    if(actionObject.mode == 2){
                        dirlength = dirEPos.m2;
                        ceycle = Math.ceil(((dirEPos.m2 - actionObject.startPos.pos.m2) * actionObject.repeateSpeed) / ((repeatEPos.m1 - actionObject.startPos.pos.m1) * actionObject.dirSpeed));
                        pos1["m" + 2] = pos["m" + 2] = 0;
                    }
                    else{
                        pos1.m2 = pos.m2;
                        tmp1.m2 = tmp.m2;
                    }
                }
                tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
            }
            if(actionObject.mode == 2){
                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, dirlength, actionObject.dirSpeed,0,false,true,10000000));
//                generateDataAction = function(addr, type, data, op)
//                ret.push(LocalTeach.generateDataAction(52461568,0,));
                var add = [3280240649,3280502793,3280764937];
                ret.push(LocalTeach.generateFlagAction(actionObject.flag3, qsTr("Ceycle")));
                if(parseFloat(dirlength)>=parseFloat(actionObject.startPos1)){
                    ret.push(LocalTeach.generateDataAction(52461568,0,(parseFloat(dirlength)-0.1)*1000));
                    ret.push(LocalTeach.generateMemCmpJumpAction(actionObject.flag16,add[actionObject.dirAxis],52461568,1,1));
                }
                else{
                    ret.push(LocalTeach.generateDataAction(52461568,0,(parseFloat(dirlength)+0.1)*1000));
                    ret.push(LocalTeach.generateMemCmpJumpAction(actionObject.flag16,add[actionObject.dirAxis],52461568,3,1));
                }
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                                                           [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
            }
            else if(actionObject.mode == 6)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                                                       [{"pointName":"", "pos":tmp},
                                                        {"pointName":"", "pos":pos}],
                                                       actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
                guncloseAction(ret,actionObject);
                gun1openAction(ret,actionObject);
            }
//            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
//                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//                ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
//            }
            if(actionObject.mode == 2){
                if(parseFloat(dirlength)>=parseFloat(actionObject.startPos1))
                    ret.push(LocalTeach.generateMemCmpJumpAction(actionObject.flag16,add[actionObject.dirAxis],52461568,1,1));
                else
                    ret.push(LocalTeach.generateMemCmpJumpAction(actionObject.flag16,add[actionObject.dirAxis],52461568,3,1));
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                                                           [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
            }
            else if(actionObject.mode == 6)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                                                       [{"pointName":"", "pos":tmp1},
                                                        {"pointName":"", "pos":pos1}],
                                                       actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
                guncloseAction(ret,actionObject);
                gun1openAction(ret,actionObject);
            }
//            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
//                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//            }
            if(actionObject.mode == 2){
                ret.push(LocalTeach.generateJumpAction(actionObject.flag3));
                ret.push(LocalTeach.generateFlagAction(actionObject.flag16, qsTr("Ceycle Over")));
            }
            guncloseAction(ret,actionObject);
//            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
//                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//            }
//            }
//            if(ceycle % 2 == 1){
//                if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
//                    ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
//                    ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
//                    ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay2));
//                }
//                if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
//                    ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
//                    ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
//                    ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
//                }
//                if(actionObject.mode == 2)
//                    ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
//                                                           [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
//                else if(actionObject.mode == 6)
//                    ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
//                                                           [{"pointName":"", "pos":tmp},
//                                                            {"pointName":"", "pos":pos}],
//                                                           actionObject.repeateSpeed, 0.0));
//                if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
//                    ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, actionObject.fixtureDelay0));
//                    ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, actionObject.fixtureDelay1));
//                    ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, actionObject.fixtureDelay2));
//                }
//                if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
//                    ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
//                    ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
//                    ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
//                }
//            }

            if(actionObject.mode == 6)
                ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
        }

        else if(actionObject.mode == 3 || actionObject.mode == 7){
            tmp["m" + 0] = pos["m" + 0] / 2;
            tmp["m" + 1] = pos["m" + 1] / 2;
            tmp["m" + 2] = pos["m" + 2] / 2;
            tmp1["m" + 0] = -tmp["m" + 0];
            tmp1["m" + 1] = -tmp["m" + 1];
            tmp1["m" + 2] = -tmp["m" + 2];
            var repeatlength,repeataxis;
            if(actionObject.plane == 0){
                if(actionObject.dirAxis == 0){
                    repeataxis = 1;
                    repeatlength = pos.m1;
                    if(actionObject.forward){
                        tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
                        tmp["m" + 2] = tmp1["m" + 2] = 0;
                    }
                    else{
                        tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
                        tmp["m" + 0] = tmp1["m" + 0] = 0;
                    }
                    dirpos["m" + 1] = pos["m" + 0] = 0;
                    dirpos["m" + 0] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else{
                    repeataxis = 0;
                    repeatlength = pos.m0;
                    if(actionObject.forward){
                        tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
                        tmp["m" + 2] = tmp1["m" + 2] = 0;
                    }
                    else{
                        tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
                        tmp["m" + 1] = tmp1["m" + 1] = 0;
                    }
                    dirpos["m" + 0] = pos["m" + 1] = 0;
                    dirpos["m" + 1] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                dirpos["m" + 2] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            else if(actionObject.plane == 1){
                if(actionObject.dirAxis == 0){
                    repeataxis = 2;
                    repeatlength = pos.m2;
                    if(actionObject.forward){
                        tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
                        tmp["m" + 1] = tmp1["m" + 1] = 0;
                    }
                    else{
                        tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
                        tmp["m" + 0] = tmp1["m" + 0] = 0;
                    }
                    dirpos["m" + 2] = pos["m" + 0] = 0;
                    dirpos["m" + 0] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else{
                    repeataxis = 0;
                    repeatlength = pos.m0;
                    if(actionObject.forward){
                        tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
                        tmp["m" + 1] = tmp1["m" + 1] = 0;
                    }
                    else{
                        tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
                        tmp["m" + 2] = tmp1["m" + 2] = 0;
                    }
                    dirpos["m" + 0] = pos["m" + 2] = 0;
                    dirpos["m" + 2] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                dirpos["m" + 1] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            else if(actionObject.plane == 2){
                if(actionObject.dirAxis == 1){
                    repeataxis = 2;
                    repeatlength = pos.m2;
                    if(actionObject.forward){
                        tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
                        tmp["m" + 0] = tmp1["m" + 0] = 0;
                    }
                    else{
                        tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
                        tmp["m" + 1] = tmp1["m" + 1] = 0;
                    }
                    dirpos["m" + 2] = pos["m" + 1] = 0;
                    dirpos["m" + 1] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                else{
                    repeataxis = 1;
                    repeatlength = pos.m1;
                    if(actionObject.forward){
                        tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
                        tmp["m" + 0] = tmp1["m" + 0] = 0;
                    }
                    else{
                        tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
                        tmp["m" + 2] = tmp1["m" + 2] = 0;
                    }
                    dirpos["m" + 1] = pos["m" + 2] = 0;
                    dirpos["m" + 2] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
                }
                dirpos["m" + 0] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
            }
            pos1["m" + 0] = -pos["m" + 0];
            pos1["m" + 1] = -pos["m" + 1];
            pos1["m" + 2] = -pos["m" + 2];

            var overlength = pos.m0;
            if(overlength > actionObject.dirLength)
                overlength = actionObject.dirLength;
            if(Math.abs(parseFloat(overlength)) > 80)
                overlength = 80;
//            if(parseFloat(overlength) < 0)
//                overlength = -overlength;
            if(parseInt(actionObject.repeateCount) % 2 == 0)
                var repeatC = parseInt(actionObject.repeateCount) / 2;
            else
                repeatC = (parseInt(actionObject.repeateCount) - 1) / 2;
            for(var i = 0;i < repeatC;i++){
                if(actionObject.mode == 3){
                    ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                             [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
                    if(parseInt(actionObject.repeateCount) % 2 == 0 && i == repeatC - 1)
                        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, repeataxis,
                                 -repeatlength, actionObject.repeateSpeed,0,false,true,Math.abs(overlength)/2,false,0,0,false,0,0,0,false,1));
                    else ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                             [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
                }
                else if(actionObject.mode == 7){
                    ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                             [{"pointName":"", "pos":tmp},
                              {"pointName":"", "pos":pos}],
                              actionObject.repeateSpeed, 0.0));
                    ret.push(LocalTeach.generateCounterAction(actionObject.repeateCounterID));
                    ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                             [{"pointName":"", "pos":tmp1},
                              {"pointName":"", "pos":pos1}],
                              actionObject.repeateSpeed, 0.0));
                }
            }
            if(parseInt(actionObject.repeateCount) % 2 == 1){
                if(actionObject.mode == 3)
                    ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, repeataxis,
                             repeatlength, actionObject.repeateSpeed,0,false,true,Math.abs(overlength)/2,false,0,0,false,0,0,0,false,1));
                if(actionObject.mode == 7)
                    ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                             [{"pointName":"", "pos":tmp},
                              {"pointName":"", "pos":pos}],
                              actionObject.repeateSpeed, 0.0));
            }
            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
                guncloseAction(ret,actionObject);

            ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag12, actionObject.dirCounterID, 1, 0));

            if(actionObject.mode == 3)
                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis,
                         actionObject.dirLength, actionObject.dirSpeed,0,false,true,Math.abs(overlength)/2,false,0,0,false,0,0,0,false,1));
            else
                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis,
                         actionObject.dirLength, actionObject.dirSpeed,0,false,false,Math.abs(overlength)/2,false,0,0,false,0,0,0,false,1));
            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
                gun1openAction(ret,actionObject);


            if(parseInt(actionObject.repeateCount) % 2 == 1){
                for(i = 0;i < repeatC;i++){
                    if(actionObject.mode == 3){
                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                                 [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                                 [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
                    }
                    else if(actionObject.mode == 7){
                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                                 [{"pointName":"", "pos":tmp1},
                                  {"pointName":"", "pos":pos1}],
                                  actionObject.repeateSpeed, 0.0));
                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                                 [{"pointName":"", "pos":tmp},
                                  {"pointName":"", "pos":pos}],
                                  actionObject.repeateSpeed, 0.0));
                    }
                }
                if(actionObject.mode == 3)
                    ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, repeataxis,
                             -repeatlength, actionObject.repeateSpeed,0,false,true,Math.abs(overlength)/2,false,0,0,false,0,0,0,false,1));
                if(actionObject.mode == 7)
                    ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                             [{"pointName":"", "pos":tmp1},
                              {"pointName":"", "pos":pos1}],
                              actionObject.repeateSpeed, 0.0));
                if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
                    guncloseAction(ret,actionObject);

                ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
                ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag12, actionObject.dirCounterID, 1, 0));

                if(actionObject.mode == 3)
                    ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis,
                             actionObject.dirLength, actionObject.dirSpeed,0,false,true,Math.abs(overlength)/2,false,0,0,false,0,0,0,false,1));
                else
                    ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis,
                             actionObject.dirLength, actionObject.dirSpeed,0,false,false,Math.abs(overlength)/2,false,0,0,false,0,0,0,false,1));
                if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
                    gun1openAction(ret,actionObject);
            }

            ret.push(LocalTeach.generateFlagAction(actionObject.flag12, qsTr("duoyu dir")));


//            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag7, actionObject.repeateCounterID, 1, 0));

//            ret.push(LocalTeach.generateCounterAction(actionObject.repeateCounterID));
//            if(actionObject.mode == 3){
//                ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag6, actionObject.repeateCounterID, 1, 0));
//                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
//                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
//                ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag7, actionObject.repeateCounterID, 0, 0));
//                ret.push(LocalTeach.generateFlagAction(actionObject.flag6, qsTr("over elar")));
//                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, repeataxis,
//                         -repeatlength, actionObject.repeateSpeed,0,false,true,overlength/2,false,0,0,false,0,0,0,false,1));
//            }
//            else if(actionObject.mode == 7)
//                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
//                         [{"pointName":"", "pos":tmp1},
//                          {"pointName":"", "pos":pos1}],
//                          actionObject.repeateSpeed, 0.0));
//            ret.push(LocalTeach.generateFlagAction(actionObject.flag7, qsTr("over done")));
//            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
//                guncloseAction(ret,actionObject);
//                gun1openAction(ret,actionObject);
//            }
//            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag2, actionObject.repeateCounterID, 0, 1));
//            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
//                guncloseAction(ret,actionObject);

//            ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
//            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag12, actionObject.dirCounterID, 1, 0));

//            if(actionObject.mode == 3)
//                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis,
//                         actionObject.dirLength, actionObject.dirSpeed,0,false,true,overlength/2,false,0,0,false,0,0,0,false,1));
//            else
//                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis,
//                         actionObject.dirLength, actionObject.dirSpeed,0,false,false,overlength/2,false,0,0,false,0,0,0,false,1));


//            ret.push(LocalTeach.generateFlagAction(actionObject.flag12, qsTr("duoyu dir")));

        }

//        else if(actionObject.mode == 3 || actionObject.mode == 7){
//            tmp["m" + 0] = pos["m" + 0] / 2;
//            tmp["m" + 1] = pos["m" + 1] / 2;
//            tmp["m" + 2] = pos["m" + 2] / 2;
//            tmp1["m" + 0] = -tmp["m" + 0];
//            tmp1["m" + 1] = -tmp["m" + 1];
//            tmp1["m" + 2] = -tmp["m" + 2];
//            var repeatlength,repeataxis;
//            if(actionObject.plane == 0){
//                if(actionObject.dirAxis == 0){
//                    repeataxis = 1;
//                    repeatlength = pos.m1;
//                    dirpos["m" + 1] = tmp["m" + 0] = tmp1["m" + 0] = pos["m" + 0] = 0;
//                    dirpos["m" + 0] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
//                }
//                else{
//                    repeataxis = 0;
//                    repeatlength = pos.m0;
//                    dirpos["m" + 0] = tmp["m" + 1] = tmp1["m" + 1] = pos["m" + 1] = 0;
//                    dirpos["m" + 1] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
//                }
//                tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
//                dirpos["m" + 2] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
//            }
//            else if(actionObject.plane == 1){
//                if(actionObject.dirAxis == 0){
//                    repeataxis = 2;
//                    repeatlength = pos.m2;
//                    dirpos["m" + 2] = tmp["m" + 0] = tmp1["m" + 0] = pos["m" + 0] = 0;
//                    dirpos["m" + 0] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
//                }
//                else{
//                    repeataxis = 0;
//                    repeatlength = pos.m0;
//                    dirpos["m" + 0] = tmp["m" + 2] = tmp1["m" + 2] = pos["m" + 2] = 0;
//                    dirpos["m" + 2] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
//                }
//                tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
//                dirpos["m" + 1] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
//            }
//            else if(actionObject.plane == 2){
//                if(actionObject.dirAxis == 1){
//                    repeataxis = 2;
//                    repeatlength = pos.m2;
//                    dirpos["m" + 2] = tmp["m" + 1] = tmp1["m" + 1] = pos["m" + 1] = 0;
//                    dirpos["m" + 1] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
//                }
//                else{
//                    repeataxis = 1;
//                    repeatlength = pos.m1;
//                    dirpos["m" + 1] = tmp["m" + 2] = tmp1["m" + 2] = pos["m" + 2] = 0;
//                    dirpos["m" + 2] = (actionObject.dirLength * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3);
//                }
//                tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
//                dirpos["m" + 0] = (actionObject.dirLength * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
//            }
//            pos1["m" + 0] = -pos["m" + 0];
//            pos1["m" + 1] = -pos["m" + 1];
//            pos1["m" + 2] = -pos["m" + 2];

////            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,       //Ydir
////                     [{"pointName":"", "pos":dirpos}], actionObject.dirSpeed, 0.0));

//            if(actionObject.mode == 3)
//                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
//                         [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
////                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE,
////                         [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
//            else if(actionObject.mode == 7)
//                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
//                         [{"pointName":"", "pos":tmp},
//                          {"pointName":"", "pos":pos}],
//                          actionObject.repeateSpeed, 0.0));
//            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
//                guncloseAction(ret,actionObject);
//                gun1openAction(ret,actionObject);
//            }
////            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
////                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
////                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
////                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
////                ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
////                ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
////                ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
////            }
//            ret.push(LocalTeach.generateCounterAction(actionObject.repeateCounterID));

//            var overlength = pos.m0;
//            if(overlength > actionObject.dirLength)
//                overlength = actionObject.dirLength;
//            if(parseFloat(overlength) < 0)
//                overlength = -overlength;
//            if(actionObject.mode == 3){
//                ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag6, actionObject.repeateCounterID, 1, 0));
//                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
//                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
//                ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag7, actionObject.repeateCounterID, 0, 0));
//                ret.push(LocalTeach.generateFlagAction(actionObject.flag6, qsTr("over elar")));
//                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, repeataxis,
//                         -repeatlength, actionObject.repeateSpeed,0,false,true,overlength/2,false,0,0,false,0,0,0,false,1));
//                ret.push(LocalTeach.generateFlagAction(actionObject.flag7, qsTr("over done")));
////                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
////                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
////                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE,
////                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
//            }
//            else if(actionObject.mode == 7)
//                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
//                         [{"pointName":"", "pos":tmp1},
//                          {"pointName":"", "pos":pos1}],
//                          actionObject.repeateSpeed, 0.0));
//            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
//                guncloseAction(ret,actionObject);
//                gun1openAction(ret,actionObject);
//            }
////            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
////                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, actionObject.fixture2Delay0));
////                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, actionObject.fixture2Delay1));
////                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, actionObject.fixture2Delay2));
////            }
//            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag2, actionObject.repeateCounterID, 0, 1));
//            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
//                guncloseAction(ret,actionObject);

//            ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
//            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag12, actionObject.dirCounterID, 1, 0));

//            if(actionObject.mode == 3)
//                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis,
//                         actionObject.dirLength, actionObject.dirSpeed,0,false,true,overlength/2,false,0,0,false,0,0,0,false,1));
//            else
//                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis,
//                         actionObject.dirLength, actionObject.dirSpeed,0,false,false,overlength/2,false,0,0,false,0,0,0,false,1));
////            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
////                     [{"pointName":"", "pos":dirpos}], actionObject.dirSpeed, 0.0));
////            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
////                     [{"pointName":"", "pos":dirpos}], actionObject.dirSpeed, 0.0));

//            ret.push(LocalTeach.generateFlagAction(actionObject.flag12, qsTr("duoyu dir")));

//        }

        else if(actionObject.mode == 8){        //DIY MOD
            var tmpMap = {};
            var tmpret = ManualProgramManager.manualProgramManager.getProgram(actionObject.editaction).program;
            var actionLine;
            var len;
            for(i = 0, len =  tmpret.length; i < len; ++i){
                if(tmpret[i].action == LocalTeach.actions.ACT_END)
                    break;
                actionLine = Utils.cloneObject(tmpret[i]);
                if(LocalTeach.isJumpAction(actionLine.action) ||
                   actionLine.action == LocalTeach.actions.ACT_FLAG){
                    if(!tmpMap.hasOwnProperty(actionLine.flag)){
                        var f = LocalTeach.flagsDefine.createFlag(0, actionLine.flag);
                        LocalTeach.flagsDefine.pushFlag(0, f);
                        tmpMap[actionLine.flag] =  f.flagID;
                    }
                    actionLine.flag = tmpMap[actionLine.flag];
                    console.log(JSON.stringify(actionLine), "dfdf:", JSON.stringify(tmpret[i]));
                }
                ret.push(actionLine);
            }
            ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
        }

        else if(actionObject.mode == 9){
            if(actionObject.plane == 0){
                if(actionObject.dirAxis == 0){
                    repeataxis = 0;
                    repeatlength = pos.m0;
                }
                else{
                    repeataxis = 1;
                    repeatlength = pos.m1;
                }
            }
            else if(actionObject.plane == 1){
                if(actionObject.dirAxis == 0){
                    repeataxis = 0;
                    repeatlength = pos.m0;
                }
                else{
                    repeataxis = 2;
                    repeatlength = pos.m2;
                }
            }
            else if(actionObject.plane == 2){
                if(actionObject.dirAxis == 1){
                    repeataxis = 1;
                    repeatlength = pos.m1;
                }
                else{
                    repeataxis = 2;
                    repeatlength = pos.m2;
                }
            }
            pos1["m" + 0] = -pos["m" + 0];
            pos1["m" + 1] = -pos["m" + 1];
            pos1["m" + 2] = -pos["m" + 2];

            if(parseInt(actionObject.repeateCount) % 2 == 0)
                repeatC = parseInt(actionObject.repeateCount) / 2;
            else
                repeatC = (parseInt(actionObject.repeateCount) - 1) / 2;
            for(i = 0;i < repeatC;i++){
                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, repeataxis,
                         repeatlength, actionObject.repeateSpeed,0,false,false,overlength/2,false,0,0,false,0,0,0,false,1));
                if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
                    guncloseAction(ret,actionObject);
                    gun1openAction(ret,actionObject);
                }
                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, repeataxis,
                         -repeatlength, actionObject.repeateSpeed,0,false,false,overlength/2,false,0,0,false,0,0,0,false,1));
                if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
                    guncloseAction(ret,actionObject);
                    gun1openAction(ret,actionObject);
                }
            }
            if(parseInt(actionObject.repeateCount) % 2 == 1){
                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, repeataxis,
                         repeatlength, actionObject.repeateSpeed,0,false,false,overlength/2,false,0,0,false,0,0,0,false,1));
                if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2)
                    guncloseAction(ret,actionObject);
            }
            if(actionObject.mode == 9 && actionObject.isRotateCycle){
                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, 0,
                                    actionObject.rotateSpeed,0,false,false,0,false,0,0,false,0,0,0,true,0));
                ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, 0,
                                    actionObject.rotateSpeed,0,false,false,0,false,0,0,false,0,0,0,true,0));
            }
        }

//        else if(actionObject.mode == 1){
//            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARCXY_MOVE_POINT + actionObject.plane,
//                  [{"pointName":"", "pos":actionObject.point1.pos},{"pointName":"", "pos":actionObject.point2.pos}],
//                  actionObject.repeateSpeed, 0.0));
//            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARCXY_MOVE_POINT + actionObject.plane,
//                  [{"pointName":"", "pos":actionObject.point1.pos},{"pointName":"", "pos":actionObject.startPos.pos}],
//                  actionObject.repeateSpeed, 0.0));
//        }

//        ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
        var zDelay = 0;
        if(actionObject.mode !== 2 && actionObject.mode !== 9){
            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag1, actionObject.dirCounterID, 0, 1));
        }
//        if(actionObject.fixture1Switch != 4)
        allcloseAction(ret,actionObject);
        var gunBack = 0;
        if(!actionObject.isGunBack){
            if(actionObject.mode == 9 && actionObject.dirAxis == 2)
                gunBack = actionObject.point1.pos.m2;
            else gunBack = actionObject.startPos.pos.m2;
            if(actionObject.mode === 2 || actionObject.mode === 3)
                zDelay = 0.2;
        }
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 2, gunBack, actionObject.startPosSpeed2,zDelay));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
////        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startPosSpeed3));
////        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startPosSpeed5));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        ret.push(LocalTeach.generateOutputAction(2,IODefines.M_BOARD_0,0,1,0));     //m2 close
        if(actionObject.useStack){
            ret.push(LocalTeach.generateCounterAction(actionObject.aaaa));
            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag10, actionObject.aaaa, 0, 1));
        }
//        ret.push(LocalTeach.generateCounterAction(actionObject.rotateCounterID));
//        ret.push(LocalTeach.generateConditionAction(4, 0, 1, 1, 0,actionObject.flag14));
//        ret.push(LocalTeach.generateOutputAction(14,100,0,14,2));     //Y30 close
//        ret.push(LocalTeach.generateOutputAction(4,100,1,4,1));     //Y14 open
//        ret.push(LocalTeach.generateOutputAction(4,0,0,4,3));     //Y14 close

//        ret.push(LocalTeach.generateCounterJumpAction(actionObject2.flag6, actionObject.rotateCounterID, 0, 0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
////        generateAxisServoAction = function(action,axis,pos,speed,delay,isBadEn,isEarlyEnd,earlyEndPos,isEarlySpd,earlySpdPos,earlySpd,signalStopEn,signalStopPoint,signalStopMode,speedMode,stop)
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startPosSpeed5,0,false,true,3600));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
//        ret.push(LocalTeach.generateCounterJumpAction(actionObject2.flag7, actionObject.rotateCounterID, 1, 0));
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag6, qsTr("Return Zero")));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
////        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startPosSpeed3));
////        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startPosSpeed5));
//        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE, [{"pointName":"", "pos":{"m0":"0.000","m1":"0.000","m2":"0.000","m3":"0.000","m4":"0.000","m5":actionObject.rotate}}], actionObject.rotateSpeed, 0.0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag7, qsTr("Go On Rotating")));
//        ret.push(LocalTeach.generateConditionAction(4, 0, 1, 0, 0,actionObject.flag15));
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag14, qsTr("Rotate1")));
////        ret.push(LocalTeach.generateOutputAction(6,100,1,6,1));     //Y16 open
////        ret.push(LocalTeach.generateOutputAction(6,0,0,6,3));     //Y16 close
//        ret.push(LocalTeach.generateCounterJumpAction(actionObject2.flag8, actionObject.rotateCounterID, 0, 0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startPosSpeed4,0,false,true,3600));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
//        ret.push(LocalTeach.generateCounterJumpAction(actionObject2.flag9, actionObject.rotateCounterID, 1, 0));
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag8, qsTr("Return Zero")));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startPosSpeed0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startPosSpeed1));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startPosSpeed3));
////        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startPosSpeed3));
////        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startPosSpeed5));
//        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE, [{"pointName":"", "pos":{"m0":"0.000","m1":"0.000","m2":"0.000","m3":"0.000","m4":actionObject.rotate,"m5":"0.000"}}], actionObject.rotateSpeed, 0.0));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag9, qsTr("Go On Rotating")));
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag15, qsTr("Rotate2")));

//        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE, [{"pointName":"", "pos":{"m0":"0.000","m1":"0.000","m2":"0.000","m3":"0.000","m4":actionObject.rotate,"m5":"0.000"}}], actionObject.rotateSpeed, 0.0));

//        ret.push(LocalTeach.generateCounterJumpAction(actionObject2.flag13, actionObject.rotateCounterID, 1, 0));

        return ret;
    }

    function creatflags(actionObject){
        if(actionObject.action == LocalTeach.actions.F_CMD_PENTU){
            var f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag0 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag1 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag2 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag3 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag4 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag5 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag6 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag7 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag8 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag9 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag10 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag11 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag12 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag13 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag14 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag15 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag16 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag17 = f.flagID;
            f = BaseTeach.flagsDefine.createFlag(0, "");
            BaseTeach.flagsDefine.pushFlag(0, f);
            actionObject.flag18 = f.flagID;
        }
    }
    function creatcounters(actionObject,counter_currt){
        var rc = BaseTeach.counterManager.getCounter(0);
        if(rc == null){
            rc= BaseTeach.counterManager.newCounter("111", counter_currt, panelRobotController.getConfigValue("s_rw_16_16_0_849"));
            panelRobotController.saveCounterDef(rc.id, rc.name, rc.current, rc.target);
            actionObject.rotateCounterID = rc.id;
        }

        var c = BaseTeach.counterManager.newCounter("222", 0, actionObject.repeateCount);
        actionObject.repeateCounterID = c.id;
        var mm = panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);
        c = BaseTeach.counterManager.newCounter("333", 0, actionObject.dirCount);
        actionObject.dirCounterID = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);

        c = BaseTeach.counterManager.newCounter("444", 0, actionObject.xcount * actionObject.ycount);
        actionObject.aaaa = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);

        c = BaseTeach.counterManager.newCounter("555", 0, actionObject.rotateCount);
        actionObject.bbbb = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);
    }

    function modelToProgram(which){
        var counter0 = BaseTeach.counterManager.getCounter(0);
        if(counter0 == null)
            var counter_currt = 0;
        else counter_currt = counter0.current;
        BaseTeach.counterManager.delAllCounter();
        panelRobotController.delAllCounterDef();
        var model = BasePData.programs[which];
        LocalPData.programtoStep = [];
        LocalPData.stepToKeXuYeRowMap = {};
        LocalPData.kexueyeRowToStepMap = {};
        var count = -1;
        var headObj = null;
        for(var i = 0; i < model.count; ++i){
            if(model.get(i).mI_ActionObject.action == LocalTeach.actions.F_CMD_PENTU){
                var tmpActionObj = model.get(i).mI_ActionObject;
                creatflags(tmpActionObj);
                creatcounters(tmpActionObj,counter_currt);
                model.setProperty(i,"mI_ActionObject",tmpActionObj);
                if(count == -1){
                    var rs = pentuActionHead(tmpActionObj);
                    count = i;
                    headObj = tmpActionObj;
                    LocalPData.kexueyeRowToStepMap[i] = LocalPData.programtoStep.length;
                    for(var j = 0, len = rs.length; j < len; ++j){
                        LocalPData.stepToKeXuYeRowMap[LocalPData.programtoStep.length] = count;
                        LocalPData.programtoStep.splice(j, 0, rs[j]);
//                        LocalPData.programtoStep.push(rs[j]);
                    }
                }
                var ps = pentuActionToProgram(tmpActionObj,headObj);
                if(count != i)
                    LocalPData.kexueyeRowToStepMap[i] = LocalPData.programtoStep.length;
                for(j = 0, len = ps.length; j < len; ++j){
                    LocalPData.stepToKeXuYeRowMap[LocalPData.programtoStep.length] = i;

                    LocalPData.programtoStep.push(ps[j]);
                }
            }else{
                if(model.get(i).mI_ActionObject.action == LocalTeach.actions.ACT_END && count != -1){
                    rs = pentuActionEnd(headObj);
                    for(j = 0, len = rs.length; j < len; ++j){
                        LocalPData.stepToKeXuYeRowMap[LocalPData.programtoStep.length] = count;
//                        LocalPData.kexueyeRowToStepMap[count] = LocalPData.programtoStep.length;
                        LocalPData.programtoStep.push(rs[j]);
                    }
                }
                LocalPData.stepToKeXuYeRowMap[LocalPData.programtoStep.length] = i;
                LocalPData.kexueyeRowToStepMap[i] = LocalPData.programtoStep.length;
                LocalPData.programtoStep.push(model.get(i).mI_ActionObject);
            }
        }
        return JSON.stringify(LocalPData.programtoStep);
    }

    function autoEditFinish(row){
//        var mID = moduleSel.currentIndex == 0 ? -1: Utils.getValueFromBrackets(moduleSel.currentText());
//        if(panelRobotController.fixProgramOnAutoMode(editing.currentIndex,
//                                                     mID,
//                                                     row,
//                                                     JSON.stringify(actionObject))){
//            if(mID >=0){
//                saveModules(false);
//            }else if(editing.currentIndex === 0)
//                panelRobotController.saveMainProgram(pentuActionToProgram(model.get(row).mI_ActionObject,model.get(count).mI_ActionObject));
//            else
//                panelRobotController.saveSubProgram(editing.currentIndex, modelToProgram(editing.currentIndex));
//        }
        rows = row;
        volewsChange.running = true;
//        var model = BasePData.programs[0];
//        var rs = pentuActionHead(model.get(row).mI_ActionObject);
//        if(row == 0)
//            var ps = rs.concat(pentuActionToProgram(model.get(row).mI_ActionObject,model.get(row).mI_ActionObject));
//        else
//            ps = pentuActionToProgram(model.get(row).mI_ActionObject,model.get(row).mI_ActionObject);
//        for(var i = 0;i < ps.length;i++){
//            if(ps[i].action !== LocalTeach.actions.ACT_FLAG &&
//               ps[i].action !== LocalTeach.actions.F_CMD_PROGRAM_JUMP0 &&
//               ps[i].action !== LocalTeach.actions.F_CMD_PROGRAM_JUMP1 &&
//               ps[i].action !== LocalTeach.actions.F_CMD_PROGRAM_JUMP2 &&
//               ps[i].action !== LocalTeach.actions.F_CMD_COUNTER&&
//               ps[i].action !== LocalTeach.actions.F_CMD_SYNC_START&&
//               ps[i].action !== LocalTeach.actions.F_CMD_SYNC_END)
//                var ppp = panelRobotController.fixProgramOnAutoMode(0,-1,LocalPData.kexueyeRowToStepMap[row]+i,JSON.stringify(ps[i]));
//        }
//            afterSaveProgram(0);
//        panelRobotController.saveMainProgram(modelToProgram(0));
    }

    Timer {
        id: volewsChange
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            var ret = panelRobotController.currentRunningActionInfo(0);
            var info = JSON.parse(ret);
            info.steps = JSON.parse(info.steps);
            if(LocalPData.stepToKeXuYeRowMap[info.steps] != rows){
                running = false;
                var model = BasePData.programs[0];
                var rs = pentuActionHead(model.get(rows).mI_ActionObject);
                if(rows == 0)
                    var ps = rs.concat(pentuActionToProgram(model.get(rows).mI_ActionObject,model.get(rows).mI_ActionObject));
                else
                    ps = pentuActionToProgram(model.get(rows).mI_ActionObject,model.get(rows).mI_ActionObject);
                for(var i = 0;i < ps.length;i++){
                    if(ps[i].action !== LocalTeach.actions.ACT_FLAG &&
//                            ps[i].action !== LocalTeach.actions.F_CMD_MEMCOMPARE_CMD &&
                            ps[i].action !== LocalTeach.actions.F_CMD_PROGRAM_JUMP0 &&
                            ps[i].action !== LocalTeach.actions.F_CMD_PROGRAM_JUMP1 &&
                            ps[i].action !== LocalTeach.actions.F_CMD_PROGRAM_JUMP2 &&
                            ps[i].action !== LocalTeach.actions.F_CMD_PROGRAM_CALL0 &&
                            ps[i].action !== LocalTeach.actions.F_CMD_PROGRAM_CALL_BACK &&
                            ps[i].action !== LocalTeach.actions.F_CMD_COUNTER&&
                            ps[i].action !== LocalTeach.actions.F_CMD_SYNC_START&&
                            ps[i].action !== LocalTeach.actions.F_CMD_SYNC_END){
                        if(ps[i].action == LocalTeach.actions.F_CMD_MEMCOMPARE_CMD)
                            ps[i].flag = model.get(rows).mI_ActionObject.flag16;
                        panelRobotController.fixProgramOnAutoMode(0,-1,LocalPData.kexueyeRowToStepMap[rows]+i,JSON.stringify(ps[i]));
                        LocalPData.programtoStep[LocalPData.kexueyeRowToStepMap[rows]+i] = ps[i];
                    }
                }
                afterSaveProgram(0);
                panelRobotController.saveMainProgram(JSON.stringify(LocalPData.programtoStep));
            }
        }
    }

    function afterSaveProgram(which){
        if(which == 0){
            var p = modelToProgramHelper(which);
            KXYRecord.keXuyePentuRecord.updateRecord(panelRobotController.currentRecordName(), JSON.stringify(p));
            KXYRecord.keXuyePentuRecord.updateLineInfo(panelRobotController.currentRecordName(),JSON.stringify([LocalPData.stepToKeXuYeRowMap, LocalPData.kexueyeRowToStepMap]));
        }
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
        visible: false
        color: "#D0D0D0"
        height: 28
        width: 315
        x:2

        function onKnobChanged(knobStatus){
            mask.width = knobStatus == Keymap.KNOB_AUTO ? 315 : 550;
        }

        Component.onCompleted: {
            ShareData.GlobalStatusCenter.registeKnobChangedEvent(mask);
        }

        MouseArea{
            anchors.fill: parent
        }
    }

    KexuYeActionEdit{
        id:kexuyeActionEdit
        visible: false
        width: menuFrame().width - 90
        height: menuFrame().height - 20
    }
    KexuYeAxisSpeed{
        id:kexuyeDetailEdit
        visible: false
        width: menuFrame().width - 90
        height: 200
    }
    KXYStackAction{
        id:kxyStackActionEdit
        visible: false
        width: menuFrame().width - 90
        height: 200
    }

    Component.onCompleted: {
        registerEditableAction(LocalTeach.actions.F_CMD_PENTU,
                               [{"editor":kexuyeActionEdit, "itemName":"kexuyeaction"},
                                {"editor":kexuyeDetailEdit, "itemName":"kexuyedetail"},
                                {"editor":kxyStackActionEdit, "itemName":"kxystackaction"}
                               ],
                               [{"item":"kexuyeaction"}, {"item":"kexuyedetail"}, {"item":"kxystackaction"},{"item":"customName"}]);

        actionModifyEditor().maxHeight = 240;
    }

    onActionLineDeleted: {
        if(actionObject.action == LocalTeach.actions.F_CMD_PENTU){
            BaseTeach.delStack(actionObject.stack1);
            panelRobotController.saveStacks(BaseTeach.stacksToJSON());
        }
    }
}
