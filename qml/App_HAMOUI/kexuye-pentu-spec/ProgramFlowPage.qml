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



ProgramFlowPage {
    id:base
    actionMenuFrameSource: "ProgramActionMenuFrame.qml"


    function getRecordContent(which){
        if(which == 0){
            LocalPData.stepToKeXuYeRowMap = JSON.parse(KXYRecord.keXuyePentuRecord.getLineInfo(panelRobotController.currentRecordName()));
            return JSON.parse(KXYRecord.keXuyePentuRecord.getRecordContent(panelRobotController.currentRecordName()));
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

    function pentuActionHead(actionObject){
        var ret = [];
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.startPos2, actionObject.startSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startSpeed3));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 4, actionObject.startPos.pos.m4, actionObject.startSpeed4));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 5, actionObject.startPos.pos.m5, actionObject.startSpeed5));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));

        ret.push(LocalTeach.generateOutputAction(16,0,0,16,0));     //close
        ret.push(LocalTeach.generateOutputAction(17,0,0,17,0));     //close
        ret.push(LocalTeach.generateOutputAction(18,0,0,18,0));     //close
        ret.push(LocalTeach.generateOutputAction(19,0,0,19,0));     //close
        ret.push(LocalTeach.generateOutputAction(20,0,0,20,0));     //close
        ret.push(LocalTeach.generateOutputAction(21,0,0,21,0));     //close
        ret.push(LocalTeach.generateOutputAction(0,IODefines.M_BOARD_0,0,0,0));     //m0 close
        ret.push(LocalTeach.generateOutputAction(1,IODefines.M_BOARD_0,0,1,0));     //m1 close

        ret.push(LocalTeach.generateOutputAction(21,0,1,21,0));     //gongzhuanhuiyuan
        ret.push(LocalTeach.generateWaitAction(21,0,1,10));
        ret.push(LocalTeach.generateOutputAction(21,0,0,21,0));

        ret.push(LocalTeach.generateOutputAction(16,0,1,16,0));     //mujuhuiyuan
        ret.push(LocalTeach.generateWaitAction(18,0,1,100));
        ret.push(LocalTeach.generateOutputAction(16,0,0,16,0));

        ret.push(LocalTeach.generateOutputAction(18,0,1,18,0));
        ret.push(LocalTeach.generateWaitAction(19,0,1,100));
        ret.push(LocalTeach.generateOutputAction(18,0,0,18,0));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag11, qsTr("gongzhuan Postv OK")));

        ret.push(LocalTeach.generateClearCounterAction(actionObject.dirCounterID));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.repeateCounterID));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.rotateCounterID));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.rotateOKCID));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.aaaa));
        ret.push(LocalTeach.generateClearCounterAction(actionObject.bbbb));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag0, qsTr("Fixture Rotation")));
        return ret;
    }
    function pentuActionEnd(actionObject){
        var ret = [];

        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag0, actionObject.rotateCounterID, 0, 1));

//         generateConditionAction = function(type, point, inout, status, limit, flag)      //type:0 XY, 4 zhongjianbianliang
        ret.push(LocalTeach.generateConditionAction(4, 0, 1, 1, 0,actionObject.flag4));
//        ret.push(LocalTeach.generateConditionAction(0, 20, 1, 1, 0,actionObject.flag4));  //Y034

        ret.push(LocalTeach.generateOutputAction(20,0,1,20,0));   //gongzhuangzhengzhuang open
        ret.push(LocalTeach.generateWaitAction(21,0,0,10));
        ret.push(LocalTeach.generateWaitAction(20,0,1,100));
        ret.push(LocalTeach.generateOutputAction(20,0,0,20,0));     //close
        ret.push(LocalTeach.generateOutputAction(0,IODefines.M_BOARD_0,1,0,0));     //m0 poen
//        ret.push(LocalTeach.generateOutputAction(20,0,1,20,0));                       //Y034 poen
        ret.push(LocalTeach.generateConditionAction(4, 0, 1, 1, 0,actionObject.flag11));
//        ret.push(LocalTeach.generateConditionAction(0, 20, 1, 0, 0,actionObject.flag5));  //Y034

        ret.push(LocalTeach.generateFlagAction(actionObject.flag4, qsTr("negative")));
        ret.push(LocalTeach.generateOutputAction(21,0,1,21,0));   //gongzhuangfanzhuang open
        ret.push(LocalTeach.generateWaitAction(20,0,0,10));
        ret.push(LocalTeach.generateWaitAction(21,0,1,100));
        ret.push(LocalTeach.generateOutputAction(21,0,0,21,0));                         //close
        ret.push(LocalTeach.generateOutputAction(0,IODefines.M_BOARD_0,0,0,0));     //m0 close
//        ret.push(LocalTeach.generateOutputAction(20,0,0,20,0));                     //Y034 poen
//        ret.push(LocalTeach.generateFlagAction(actionObject.flag5, qsTr("positive")));

        return ret;
    }

    function pentuActionToProgram(actionObject){
        var ret = [];
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.startPos2, actionObject.startSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startSpeed3));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
//        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.zlength, actionObject.startSpeed2));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag1, qsTr("Dir Move")));
        if(actionObject.fixture1Switch == 4){
            ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
            ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
            ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay2));
        }
        else if(actionObject.fixture1Switch == 3){
            ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
            ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
            ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
        }
        if(actionObject.fixture2Switch == 4){
            ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
            ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
            ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
        }
        else if(actionObject.fixture2Switch == 3){
            ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
            ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
            ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
        }
        ret.push(LocalTeach.generateFlagAction(actionObject.flag2, qsTr("Repeate")));

        if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
            ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
            ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
            ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay2));
        }
        if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
            ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
            ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
            ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
        }


        var pos = {};
        var pos1 = {};
        var tmp = {};
        var tmp1 = {};
        var dirpos = {};
        pos["m" + 0] = actionObject.point1.pos.m0 - actionObject.startPos.pos.m0;
        pos["m" + 1] = actionObject.point1.pos.m1 - actionObject.startPos.pos.m1;
        pos["m" + 2] = actionObject.point1.pos.m2 - actionObject.startPos.pos.m2;
        if(actionObject.mode > 3){
            pos["m" + 3] = actionObject.point1.pos.m3 - actionObject.startPos.pos.m3;
            tmp["m" + 3] = pos["m" + 3] / 2;
            tmp1["m" + 3] = -tmp["m" + 3];
            pos1["m" + 3] = -pos["m" + 3];

            pos["m" + 4] = pos["m" + 5] = pos["m" + 6] = 0;
            pos1["m" + 4] = pos1["m" + 5] = pos1["m" + 6] = 0;
            tmp["m" + 4] = tmp["m" + 5] = tmp["m" + 6] = 0;
            tmp1["m" + 4] = tmp1["m" + 5] = tmp1["m" + 6] = 0;
        }
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
            else if(actionObject.mode == 4){
                ret.push(LocalTeach.generateSpeedAction(0,actionObject.repeateSpeed));
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp},
                          {"pointName":"", "pos":pos}],
                          actionObject.repeateSpeed, 0.0));

                if(actionObject.plane == 1){
                    if(actionObject.dirAxis == 0){
                        ////////////////////add hu
                        var temp111 = {},pos111 = {};
                        temp111["m" + 0] = 0;
                        temp111["m" + 1] = 3;
                        temp111["m" + 2] = 1;
                        temp111["m" + 3] = 0;
                        temp111["m" + 4] = 0;
                        temp111["m" + 5] = 0;

                        pos111["m" + 0] = 0;
                        pos111["m" + 1] = 4;
                        pos111["m" + 2] = 4;
                        pos111["m" + 3] = 0;
                        pos111["m" + 4] = 0;
                        pos111["m" + 5] = 0;
                        ret.push(LocalTeach.generateSpeedAction(actionObject.repeateSpeed,actionObject.repeateSpeed));
                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                                 [{"pointName":"", "pos":temp111},
                                  {"pointName":"", "pos":pos111}],
                                  actionObject.repeateSpeed, 0.0));
                        ////////////////////add hu

                        ////////////////////add line

                        var pos_line1 = {};
                        pos_line1["m" + 0] = 0;
                        pos_line1["m" + 1] = 0;
                        pos_line1["m" + 2] = 100;
                        ret.push(LocalTeach.generateSpeedAction(actionObject.repeateSpeed,0));
                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                                 [{"pointName":"", "pos":pos_line1}], actionObject.repeateSpeed, 0.0));
                        ////////////////////add line
                    }
                }
            }
            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
                ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
            }

            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                     [{"pointName":"", "pos":dirpos}], actionObject.dirSpeed, 0.0));

           if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
                ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
            }
            if(actionObject.mode == 0)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
            else if(actionObject.mode == 4){
                if(actionObject.plane == 1){
                    if(actionObject.dirAxis == 0){
                        ////////////////////add line
                        var pos_line2 = {};
                        pos_line2["m" + 0] = 0;
                        pos_line2["m" + 1] = 0;
                        pos_line2["m" + 2] = -100;
                        ret.push(LocalTeach.generateSpeedAction(0,actionObject.repeateSpeed));
                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                                 [{"pointName":"", "pos":pos_line2}], actionObject.repeateSpeed, 0.0));
                        ////////////////////add line

                        ////////////////////add hu
                        var temp2222 = {},pos2222 = {};
                        temp2222["m" + 0] = 0;
                        temp2222["m" + 1] = -1;
                        temp2222["m" + 2] = -3;
                        temp2222["m" + 3] = 0;
                        temp2222["m" + 4] = 0;
                        temp2222["m" + 5] = 0;

                        pos2222["m" + 0] = 0;
                        pos2222["m" + 1] = -4;
                        pos2222["m" + 2] = -4;
                        pos2222["m" + 3] = 0;
                        pos2222["m" + 4] = 0;
                        pos2222["m" + 5] = 0;
                        ret.push(LocalTeach.generateSpeedAction(actionObject.repeateSpeed,actionObject.repeateSpeed));
                        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                                 [{"pointName":"", "pos":temp2222},
                                  {"pointName":"", "pos":pos2222}],
                                  actionObject.repeateSpeed, 0.0));
                        ////////////////////add hu
                    }
                }
                ret.push(LocalTeach.generateSpeedAction(actionObject.repeateSpeed,0));
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp1},
                          {"pointName":"", "pos":pos1}],
                          actionObject.repeateSpeed, 0.0));
            }
            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
                ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
            }

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
                ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
                ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
                ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
            }
            if(actionObject.mode == 1)
            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                     [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
            else if(actionObject.mode == 5)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp1},
                          {"pointName":"", "pos":pos1}],
                          actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
                ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
            }
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
            if(actionObject.plane == 0){
                if(actionObject.dirAxis == 0){
                    if(actionObject.mode == 2){
                        pos["m" + 0] = (pos["m" + 0] * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3)
                        pos1["m" + 2] = pos["m" + 2] = (pos["m" + 0] * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
                    }
                    pos1["m" + 0] = pos["m" + 0];
                    tmp1["m" + 0] = tmp["m" + 0];
                }
                else {
                    if(actionObject.mode == 2){
                        pos["m" + 1] = (pos["m" + 1] * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3)
                        pos1["m" + 2] = pos["m" + 2] = (pos["m" + 1] * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
                    }
                    pos1["m" + 1] = pos["m" + 1];
                    tmp1["m" + 1] = tmp["m" + 1] ;
                }
                tmp["m" + 2] = tmp1["m" + 2] = actionObject.zlength;
            }
            else if(actionObject.plane == 1){
                if(actionObject.dirAxis == 0){
                    if(actionObject.mode == 2){
                        pos["m" + 0] = (pos["m" + 0] * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3)
                        pos1["m" + 1] = pos["m" + 1] = (pos["m" + 0] * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
                    }
                    pos1["m" + 0] = pos["m" + 0];
                    tmp1["m" + 0] = tmp["m" + 0];
                }
                else {
                    if(actionObject.mode == 2){
                        pos["m" + 2] = (pos["m" + 2] * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3)
                        pos1["m" + 1] = pos["m" + 1] = (pos["m" + 2] * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
                    }
                    pos1["m" + 2] = pos["m" + 2];
                    tmp1["m" + 2] = tmp["m" + 2];
                }
                tmp["m" + 1] = tmp1["m" + 1] = actionObject.zlength;
            }
            else if(actionObject.plane == 2){
                if(actionObject.dirAxis == 1){
                    if(actionObject.mode == 2){
                        pos["m" + 1] = (pos["m" + 1] * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3)
                        pos1["m" + 0] = pos["m" + 0] = (pos["m" + 1] * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
                    }
                    pos1["m" + 1] = pos["m" + 1];
                    tmp1["m" + 1] = tmp["m" + 1];
                }
                else {
                    if(actionObject.mode == 2){
                        pos["m" + 2] = (pos["m" + 2] * Math.cos(actionObject.slope * Math.PI / 180)).toFixed(3)
                        pos1["m" + 0] = pos["m" + 0] = (pos["m" + 2] * Math.sin(actionObject.slope * Math.PI / 180)).toFixed(3);
                    }
                    pos1["m" + 2] = pos["m" + 2];
                    tmp1["m" + 2] = tmp["m" + 2];
                }
                tmp["m" + 0] = tmp1["m" + 0] = actionObject.zlength;
            }
            if(actionObject.mode == 2)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                         [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
            else if(actionObject.mode == 6)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp},
                          {"pointName":"", "pos":pos}],
                          actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
                ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
                ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
                ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
            }
            if(actionObject.mode == 2)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
            else if(actionObject.mode == 6)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp1},
                          {"pointName":"", "pos":pos1}],
                          actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
                ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
            }
        }

        else if(actionObject.mode == 3 || actionObject.mode == 7){
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

            if(actionObject.mode == 3)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                         [{"pointName":"", "pos":pos}], actionObject.repeateSpeed, 0.0));
            else if(actionObject.mode == 7)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp},
                          {"pointName":"", "pos":pos}],
                          actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 0 || actionObject.fixture1Switch == 2){
                ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
                ret.push(LocalTeach.generateOutputAction(4, 0, 1, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 1, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 1, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 0 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
                ret.push(LocalTeach.generateOutputAction(7, 0, 1, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 1, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 1, 0, actionObject.fixture2Delay2));
            }
            if(actionObject.mode == 3)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                         [{"pointName":"", "pos":pos1}], actionObject.repeateSpeed, 0.0));
            else if(actionObject.mode == 7)
                ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_ARC_RELATIVE_POSE,
                         [{"pointName":"", "pos":tmp1},
                          {"pointName":"", "pos":pos1}],
                          actionObject.repeateSpeed, 0.0));
            if(actionObject.fixture1Switch == 1 || actionObject.fixture1Switch == 2){
                ret.push(LocalTeach.generateOutputAction(4, 0, 0, 0, 0, actionObject.fixtureDelay0));
                ret.push(LocalTeach.generateOutputAction(5, 0, 0, 0, 0, actionObject.fixtureDelay1));
                ret.push(LocalTeach.generateOutputAction(6, 0, 0, 0, 0, actionObject.fixtureDelay2));
            }
            if(actionObject.fixture2Switch == 1 || actionObject.fixture2Switch == 2){
                ret.push(LocalTeach.generateOutputAction(7, 0, 0, 0, 0, actionObject.fixture2Delay0));
                ret.push(LocalTeach.generateOutputAction(8, 0, 0, 0, 0, actionObject.fixture2Delay1));
                ret.push(LocalTeach.generateOutputAction(9, 0, 0, 0, 0, actionObject.fixture2Delay2));
            }
            ret.push(LocalTeach.generateCounterAction(actionObject.repeateCounterID));
            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag2, actionObject.repeateCounterID, 0, 1));

            ret.push(LocalTeach.generateCounterAction(actionObject.dirCounterID));
            ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag12, actionObject.dirCounterID, 1, 0));

            ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_COORDINATE_DEVIATION,
                     [{"pointName":"", "pos":dirpos}], actionObject.dirSpeed, 0.0));

            ret.push(LocalTeach.generateFlagAction(actionObject.flag12, qsTr("duoyu dir")));

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
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag1, actionObject.dirCounterID, 0, 1));

        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_START));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.deepAxis, actionObject.startPos2, actionObject.startSpeed2));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.rpeateAxis, actionObject.startPos0, actionObject.startSpeed0));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, actionObject.dirAxis, actionObject.startPos1, actionObject.startSpeed1));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SINGLE, 3, actionObject.startPos.pos.m3, actionObject.startSpeed3));
        ret.push(LocalTeach.generateAxisServoAction(LocalTeach.actions.F_CMD_SYNC_END));
//        Rotate  degree:
//         generateOutputAction = function(point, type, status, valveID, time)
//        generateWaitAction = function(which, type, status, limit)
        if(actionObject.rotate >= 0)
            var rotateO1 = 16;
        else rotateO1 = 17;
        var rotateO2 = rotateO1 + 2;
        var rotateI1 = 16;
        var rotateI2 = 17;
//         generateConditionAction = function(type, point, inout, status, limit, flag)      //type:0 XY, 4 zhongjianbianliang
        ret.push(LocalTeach.generateConditionAction(4, 1, 1, 1, 0,actionObject.flag6));
//        ret.push(LocalTeach.generateConditionAction(0, 20, 1, 1, 0,actionObject.flag4));  //Y034

//        ret.push(LocalTeach.generateCounterAction(actionObject.bbbb));
//        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag9, actionObject.bbbb, 1, 1));

//        ret.push(LocalTeach.generateOutputAction(16,0,1,16,0));     //muju1Huiyuan
//        ret.push(LocalTeach.generateWaitAction(18,0,1,10));
//        ret.push(LocalTeach.generateOutputAction(16,0,0,16,0));

        ret.push(LocalTeach.generateOutputAction(rotateO1,0,1,rotateO1,0));
        ret.push(LocalTeach.generateFlagAction(actionObject.flag3, qsTr("Rotate1 OK")));
        ret.push(LocalTeach.generateWaitAction(rotateI1,0,0,10));
        ret.push(LocalTeach.generateWaitAction(rotateI1,0,1,10));
        ret.push(LocalTeach.generateCounterAction(actionObject.rotateOKCID));
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag3, actionObject.rotateOKCID, 0, 1));
        ret.push(LocalTeach.generateOutputAction(rotateO1,0,0,rotateO1,0));

//        ret.push(LocalTeach.generateFlagAction(actionObject.flag9, qsTr("duoyurotate")));

        ret.push(LocalTeach.generateCounterAction(actionObject.aaaa));
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag7, actionObject.aaaa, 0, 1));

        ret.push(LocalTeach.generateOutputAction(1,IODefines.M_BOARD_0,1,1,0));     //m1 poen
        ret.push(LocalTeach.generateConditionAction(4, 1, 1, 1, 0,actionObject.flag7));

        ret.push(LocalTeach.generateFlagAction(actionObject.flag6, qsTr("negative1")));

//        ret.push(LocalTeach.generateCounterAction(actionObject.bbbb));
//        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag10, actionObject.bbbb, 1, 1));


//        ret.push(LocalTeach.generateOutputAction(18,0,1,18,0));     //muju2Huiyuan
//        ret.push(LocalTeach.generateWaitAction(19,0,1,10));
//        ret.push(LocalTeach.generateOutputAction(18,0,0,18,0));

        ret.push(LocalTeach.generateOutputAction(rotateO2,0,1,rotateO2,0));
        ret.push(LocalTeach.generateFlagAction(actionObject.flag8, qsTr("Rotate2 OK")));
        ret.push(LocalTeach.generateWaitAction(rotateI2,0,0,10));
        ret.push(LocalTeach.generateWaitAction(rotateI2,0,1,10));
        ret.push(LocalTeach.generateCounterAction(actionObject.rotateOKCID));
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag8, actionObject.rotateOKCID, 0, 1));
        ret.push(LocalTeach.generateOutputAction(rotateO2,0,0,rotateO2,0));

//        ret.push(LocalTeach.generateFlagAction(actionObject.flag10, qsTr("duoyurotate")));

        ret.push(LocalTeach.generateCounterAction(actionObject.aaaa));
        ret.push(LocalTeach.generateCounterJumpAction(actionObject.flag7, actionObject.aaaa, 0, 1));

        ret.push(LocalTeach.generateOutputAction(1,IODefines.M_BOARD_0,0,1,0));     //m0 close
        ret.push(LocalTeach.generateFlagAction(actionObject.flag7, qsTr("positive1")));

//        ret.push(LocalTeach.generatePathAction(LocalTeach.actions.F_CMD_JOINT_RELATIVE, [{"pointName":"", "pos":{"m0":"0.000","m1":"0.000","m2":"0.000","m3":"0.000","m4":actionObject.rotate,"m5":"0.000"}}], actionObject.rotateSpeed, 0.0));
        ret.push(LocalTeach.generateCounterAction(actionObject.rotateCounterID));

        return ret;
    }

    function modelToProgram(which){
        var model = BasePData.programs[which];
        var ret = [];
        LocalPData.stepToKeXuYeRowMap = {};
        var count = -1;
        for(var i = 0; i < model.count; ++i){
            if(model.get(i).mI_ActionObject.action == LocalTeach.actions.F_CMD_PENTU){
                if(count == -1){
                    var rs = pentuActionHead(model.get(i).mI_ActionObject);
                    count = i;
                    for(var j = 0, len = rs.length; j < len; ++j){
                        LocalPData.stepToKeXuYeRowMap[ret.length] = 0;
                        ret.splice(j, 0, rs[j]);
//                        ret.push(rs[j]);
                    }
                }
                var ps = pentuActionToProgram(model.get(i).mI_ActionObject);
                for(j = 0, len = ps.length; j < len; ++j){
                    LocalPData.stepToKeXuYeRowMap[ret.length] = i;
                    ret.push(ps[j]);
                }
            }else{
                if(model.get(i).mI_ActionObject.action == LocalTeach.actions.ACT_END && count != -1){
                    rs = pentuActionEnd(model.get(count).mI_ActionObject);
                    for(j = 0, len = rs.length; j < len; ++j){
                        LocalPData.stepToKeXuYeRowMap[ret.length] = i;
                        ret.push(rs[j]);
                    }
                }
                LocalPData.stepToKeXuYeRowMap[ret.length] = i;
                ret.push(model.get(i).mI_ActionObject);
            }
        }
        return JSON.stringify(ret);
    }

    function afterSaveProgram(which){
        var p = modelToProgramHelper(which);
        KXYRecord.keXuyePentuRecord.updateRecord(panelRobotController.currentRecordName(), JSON.stringify(p));
        KXYRecord.keXuyePentuRecord.updateLineInfo(panelRobotController.currentRecordName(),JSON.stringify(LocalPData.stepToKeXuYeRowMap));
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

    Component.onCompleted: {
        registerEditableAction(LocalTeach.actions.F_CMD_PENTU,
                               [{"editor":kexuyeActionEdit, "itemName":"kexuyeaction"},
                                {"editor":kexuyeDetailEdit, "itemName":"kexuyedetail"}
                               ],
                               [{"item":"kexuyeaction"}, {"item":"kexuyedetail"},{"item":"customName"}]);

        actionModifyEditor().maxHeight = 240;
    }

    onActionLineDeleted: {
        if(actionObject.action == LocalTeach.actions.F_CMD_PENTU){
            BaseTeach.counterManager.delCounter(actionObject.repeateCounterID);
            panelRobotController.delCounterDef(actionObject.repeateCounterID);
            BaseTeach.counterManager.delCounter(actionObject.dirCounterID);
            panelRobotController.delCounterDef(actionObject.dirCounterID);
//            BaseTeach.counterManager.delCounter(actionObject.rotateCounterID);
//            panelRobotController.delCounterDef(actionObject.rotateCounterID);
            BaseTeach.counterManager.delCounter(actionObject.rotateOKCID);
            panelRobotController.delCounterDef(actionObject.rotateOKCID);
            BaseTeach.counterManager.delCounter(actionObject.aaaa);
            panelRobotController.delCounterDef(actionObject.aaaa);
            BaseTeach.counterManager.delCounter(actionObject.bbbb);
            panelRobotController.delCounterDef(actionObject.bbbb);
        }
    }
}
