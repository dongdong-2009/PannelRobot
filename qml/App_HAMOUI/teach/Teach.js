.pragma library

Qt.include("../../utils/HashTable.js")
Qt.include("../../utils/stringhelper.js")
Qt.include("../configs/AxisDefine.js")
Qt.include("../configs/IODefines.js")

//var motorText = [qsTr("M1:"), qsTr("M2:"), qsTr("M3:"), qsTr("M4:"), qsTr("M5:"), qsTr("M6:")];


var DefinePoints = {
    createNew: function(){
        var definePoints = {};
        definePoints.definedPoints = [];
        definePoints.createPointID = function(){
            var definedPoints = definePoints.definedPoints;
            for(var i = 0; i < definedPoints.length; ++i){
                if(i !== definedPoints[i].index)
                    return i;
            }
            return definedPoints.length;
        }
        definePoints.createPointObject = function(pID, name, point){
            return {"index":pID, "name":name, "point":point};
        }

        definePoints.addNewPoint = function(name, point){
            var pID = definePoints.createPointID();
            name = "P" + pID + ":" + name;
            var iPoint = definePoints.createPointObject(pID, name, point);
            definePoints.definedPoints.splice(pID, 0, iPoint);
            return iPoint;
        }

        definePoints.getPoint = function(name){
            var pID = definePoints.extractPointIDFromPointName(name);
            return definedPoints.definedPoints[pID];
        }

        definePoints.extractPointIDFromPointName = function(name){
            return parseInt(name.substring(1, name.indexOf(":")));
        }
        definePoints.isPointExist = function(pointID){
            if(pointID >= definePoints.definedPoints.length) return false;
            return definePoints.definedPoints[pointID].index === pointID;
        }
        definePoints.pointNameList = function(){
            var ret = [];
            for(var i = 0; i < definePoints.definedPoints.length; ++i){
                ret.push(definePoints.definedPoints[i].name);
            }
            return ret;
        }
        definePoints.clear = function(){
            definePoints.definedPoints.length = 0;
        }
        definePoints.parseActionPoints = function(actionObject){
            if(!actionObject.hasOwnProperty("points"))
                return
            var points = actionObject.points;
            var name;
            var pID;
            for(var i = 0; i < points.length; ++i){
                name = points[i].pointName || "";
                if(name === "")
                    continue;
                pID = definePoints.extractPointIDFromPointName(name);
                if(!definePoints.isPointExist(pID)){
                    definePoints.definedPoints.splice(pID, 0, definePoints.createPointObject(pID, name, points[i].pos));
                }
            }
        }

        return definePoints;
    }

};

var definedPoints = DefinePoints.createNew();

var actionTypes = {
    "kAT_Normal":0,
    "kAT_SyncStart":1,
    "kAT_SyncEnd":2
};

var isSyncAction = function(actionObject){
    return actionObject.action === actionTypes.kAT_SyncStart ||
            actionObject.action === actionTypes.kAT_SyncEnd;
}

var motorRangeAddr = function(which){
    return "s_rw_0_32_3_100" + which;
}

var actHelper = 0;
var actions = {

};
actions.F_CMD_NULL = actHelper++;
actions.F_CMD_SYNC_START = actHelper++;
actions.F_CMD_SYNC_END = actHelper++;
actions.F_CMD_SINGLE = actHelper++;
actions.F_CMD_CoordinatePoint = actHelper++;
actions.F_CMD_SINGLE_POINT = actHelper++;
actions.F_CMD_LINE2D_MOVE_POINT = actHelper++;
actions.F_CMD_LINE3D_MOVE_POINT = actHelper++;
actions.F_CMD_ARC3D_MOVE_POINT = actHelper++;   //< 按点位弧线运动 目标坐标（X，Y，Z）经过点（X，Y，Z） 速度  延时
actions.F_CMD_MOVE_POSE = actHelper++;
actions.F_CMD_LINE3D_MOVE_POSE = actHelper++;

actions.F_CMD_IO_INPUT = 100;   //< IO点输入等待 IO点 等待 等待时间
actions.F_CMD_IO_OUTPUT = 200;   //< IO点输出 IO点 输出状态 输出延时


actions.F_CMD_PROGRAM_JUMP0 = 10000;
actions.F_CMD_PROGRAM_JUMP1 = 10001;
actions.F_CMD_PROGRAM_JUMP2 = 10002;
actions.ACT_GS6 = actHelper++;
actions.ACT_GS7 = actHelper++;

actions.ACT_PS2_1 = actHelper++;
actions.ACT_PS2_2 = actHelper++;
actions.ACT_PS1_2 = actHelper++;
actions.ACT_PS1_1 = actHelper++;

actions.ACT_PS8_2 = actHelper++;
actions.ACT_PS8_1 = actHelper++;
actions.ACT_PS5_1 = actHelper++;
actions.ACT_PS5_2 = actHelper++;

actions.ACT_PS4_2 = actHelper++;
actions.ACT_PS4_1 = actHelper++;
actions.ACT_PS3_2 = actHelper++;
actions.ACT_PS3_1 = actHelper++;

actions.ACT_PS6_2 = actHelper++;
actions.ACT_PS6_1 = actHelper++;

actHelper = 27;
actions.ACT_OTHER      = actHelper++;
actions.ACT_CONDITION  = actHelper++;
actions.ACT_Wait       = actHelper++;
actions.ACT_CHECK      = actHelper++;
actions.ACT_PARALLEL   = actHelper++;
actions.ACT_END        = 60000;
actions.ACT_COMMENT    = 50000;
actions.ACT_OUTPUT     = 0x80;
actions.ACT_SYNC_BEGIN = 126;
actions.ACT_SYNC_END   = 127;
actions.ACT_GROUP_END  = 125;
actions.ACT_FLAG       = 100;

var kCCErr_Invalid = 1;
var kCCErr_Sync_Nesting = 2;
var kCCErr_Sync_NoBegin = 3;
var kCCErr_Sync_NoEnd = 4;
var kCCErr_Group_Nesting = 5;
var kCCErr_Group_NoBegin = 6;
var kCCErr_Group_NoEnd = 7;
var kCCErr_Last_Is_Not_End_Action = 8;

var kAxisType_NoUse = 0;
var kAxisType_Servo = 1;
var kAxisType_Pneumatic = 2;
var kAxisType_Reserve = 3;

var generateAxisServoAction = function(action,
                                       axis,
                                       pos,
                                       speed,
                                       delay,
                                       isBadEn,
                                       isEarlyEnd,
                                       earlyEndPos){
    return {
        "action":action,
        "axis":axis,
        "pos": pos||0.000,
        "speed":speed||80.0,
        "delay":delay||0.00,
        //        "isBadEn":isBadEn||false,
        //        "isEarlyEnd":isEarlyEnd||false,
        //        "earlyEndPos":earlyEndPos||0.00
    };
}

var generatePathAction = function(action,
                                  points,
                                  speed,
                                  delay
                                  ){

    return {
        "action":action,
        "points":points,
        "speed":speed||80.0,
        "delay":delay||0.00,
    };
}

var generateAxisPneumaticAction = function(action,delay){
    return {
        "action":action,
        "delay": delay||0.00
    }
}

var generteEndAction = function(){
    return {
        "action":actions.ACT_END
    };
}

var generateOutputAction = function(point, type, status, delay){
    return {
        "action":actions.F_CMD_IO_OUTPUT,
        "type":type,
        "point":point,
        "pointStatus": status,
        "delay":delay
    };
}


var generateWaitAction = function(which, type, status, limit){
    return {
        "action":actions.F_CMD_IO_INPUT,
        "type": type,
        "point":which,
        "pointStatus":status,
        "limit":limit || 0.50
    };
}

var generateCheckAction = function(which, status, limit){
    return {
        "action":actions.ACT_CHECK,
        "point":which,
        "pointStatus":status,
        "limit":limit || 0.50
    };
}

var generateConditionAction = function(which, status, limit, flag){
    return {
        "action":actions.ACT_CONDITION,
        "point":which,
        "pointStatus":status,
        "limit":limit || 0.50,
        "flag": flag || 0,
    };
}

var generateFlagAction = function(flag,descr){
    return {
        "action":actions.ACT_FLAG,
        "flag":flag,
        "comment":descr
    };
}

var generateSyncBeginAction = function(){
    return {
        "action":actions.F_CMD_SYNC_START
    };
}

var generateSyncEndAction = function(){
    return {
        "action":actions.F_CMD_SYNC_END
    };
}


var generateCommentAction = function(comment, commentdAction){
    return {
        "action": actions.ACT_COMMENT,
        "comment":comment,
        "commentAction":commentdAction || null
    };
}

var generateInitProgram = function(axisDefine){

    var initStep = [];
    initStep.push(generateSyncBeginAction());
    //    initStep.push(axisDefine.s8Axis == kAxisType_Reserve ? generateAxisServoAction(actions.ACT_GS8) :
    //                                                           generateAxisPneumaticAction(actions.ACT_PS8_1));
    var aT;
    for(var i = 1; i < 8; ++i){
        aT = axisDefine["s"+ i + "Axis"];
        if(aT == kAxisType_Servo){
            initStep.push(generateAxisServoAction(actions.F_CMD_SINGLE, i - 1));
        }else if(aT == kAxisType_Pneumatic){
            initStep.push(generateAxisPneumaticAction(actions["ACT_PS" + i + "_1"]));
        }
    }

    initStep.push(generateSyncEndAction());
    initStep.push(generateWaitAction(1));
    initStep.push(generteEndAction());

    return JSON.stringify(initStep);

}

var gsActionToStringHelper = function(actionStr, actionObject){
    var ret =  actionStr + ":" +  actionObject.pos + " " +
            qsTr("Speed:") + actionObject.speed + " " +
            qsTr("Delay:") + actionObject.delay;
    if(actionObject.isBadEn)
        ret += " " + qsTr("Bad En");
    if(actionObject.isEarlyEnd){
        ret += " " + qsTr("Early End Pos:") + actionObject.earlyEndPos;
    }
    return ret;
}

var psActionToStringHelper = function(actionStr, actionObject){
    var ret =  actionStr + " " +
            qsTranslate("Teach","Delay:") + actionObject.delay;
    return ret;
}

var f_CMD_SINGLEToStringHandler = function(actionObject){
    var ret =  axisInfos[actionObject.axis].name + ":" +  actionObject.pos + " " +
            qsTranslate("Teach","Speed:") + actionObject.speed + " " +
            qsTr("Delay:") + actionObject.delay;
    if(actionObject.isBadEn)
        ret += " " + qsTr("Bad En");
    if(actionObject.isEarlyEnd){
        ret += " " + qsTr("Early End Pos:") + actionObject.earlyEndPos;
    }
    return ret;
}


var ps1_1ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("X1 OFF"), actionObject)
}
var ps1_2ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("X1 ON"), actionObject)

}

var ps2_1ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("Y1 OFF"), actionObject)

}
var ps2_2ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("Y1 ON"), actionObject)

}

var ps3_1ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("Z OFF"), actionObject)

}
var ps3_2ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("Z ON"), actionObject)

}

var ps4_1ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("X2 OFF"), actionObject)

}
var ps4_2ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("X2 ON"), actionObject)

}

var ps5_1ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("A OFF"),actionObject)

}
var ps5_2ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("A ON"),actionObject)

}

var ps6_1ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("B OFF"), actionObject)

}
var ps6_2ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("B ON"), actionObject)
}

var ps8_1ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("C OFF"), actionObject)
}
var ps8_2ToStringHandler = function(actionObject){
    return psActionToStringHelper(qsTr("C ON"), actionObject)

}

var otherActionToStringHandler = function(actionObject){

}

var conditionActionToStringHandler = function(actionObject){
    return qsTr("IF:") + actionObject.point +
            (actionObject.pointStatus ? qsTr("ON") : qsTr("OFF")) + " "
            + qsTr("Limit:") + actionObject.limit + " " +
            qsTr("Go to flag") +"[" + actionObject.flag + "]";
}

var waitActionToStringHandler = function(actionObject){
    return qsTr("Wait:") + getXDefineFromHWPoint(actionObject.point, actionObject.type).xDefine.descr +
            (actionObject.pointStatus ? qsTr("ON") : qsTr("OFF")) + " " +
            qsTr("Limit:") + actionObject.limit;
}

var checkActionToStringHandler = function(actionObject){
    return qsTr("Check:") + actionObject.point +
            (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " " +
            qsTr("Limit:") + actionObject.limit;
}

var parallelActionToStringHandler = function(actionObject){

}

var endActionToStringHandler = function(actionObject){
    return qsTr("End");
}

var commentActionToStringHandler = function(actionObject){
    return actionObject.comment;
}

var flagActionToStringHandler = function(actionObject){
    return qsTr("Flag") + icStrformat("[{0}]", actionObject.flag) + ":"
            + actionObject.comment;
}

var outputActionToStringHandler = function(actionObject){
    if(actionObject.type !== VALVE_BOARD){
        return qsTr("Output:") + getYDefineFromHWPoint(actionObject.point, actionObject.type).yDefine.descr + (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                + qsTr("Delay:") + actionObject.delay;
    }else{
        return qsTr("Output:") + getValveItemFromValveID(actionObject.point).descr + (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                + qsTr("Delay:") + actionObject.delay;
    }
}

var syncBeginActionToStringHandler = function(actionObject){
    return qsTr("Sync Begin");
}

var syncEndActionToStringHandler = function(actionObject){
    return qsTr("Sync End");
}

var pointToString = function(point){
    var ret = "";
    if(point.pointName !== ""){
        ret = point.pointName + "(";
    }

    var m;
    for(var i = 0; i < 6; ++i){
        m = "m" + i;
        if(point.pos.hasOwnProperty(m)){
            ret += axisInfos[i].name + ":" + point.pos[m] + ","
        }
    }
    ret = ret.substr(0, ret.length - 1);
    if(point.pointName !== ""){
        ret += ")";
    }
    return ret;
}

var pathActionToStringHandler = function(actionObject){
    var ret = "";
    if(actionObject.action === actions.F_CMD_LINE2D_MOVE_POINT){
        ret += qsTr("Line2D:");
    }else if(actionObject.action === actions.F_CMD_LINE3D_MOVE_POINT){
        ret += qsTr("Line3D:");
    }
    else if(actionObject.action === actions.F_CMD_ARC3D_MOVE_POINT){
        ret += qsTr("Arc3D:");
    }
    else if(actionObject.action === actions.F_CMD_MOVE_POSE){
        ret += qsTr("Pose:");
    }
    else if(actionObject.action === actions.F_CMD_LINE3D_MOVE_POSE){
        ret += qsTr("Line3D-Pose:");
    }

    var points = actionObject.points;
    if(points.length > 0)
        ret += qsTr("Next:") + pointToString(points[0]) + " ";
    if(points.length > 1)
        ret += qsTr("End:") + pointToString(points[points.length - 1]) + " ";
    ret += qsTr("Speed:") + actionObject.speed + " ";
    ret += qsTr("Delay:") + actionObject.delay;
    return ret;
}



var actionToStringHandlerMap = new HashTable();
actionToStringHandlerMap.put(actions.F_CMD_SINGLE, f_CMD_SINGLEToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_LINE2D_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_LINE3D_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_ARC3D_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_MOVE_POSE, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_LINE3D_MOVE_POSE, pathActionToStringHandler);


//actionToStringHandlerMap.put(actions.ACT_GS1, gs1ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_GS2, gs2ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_GS3, gs3ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_GS4, gs4ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_GS5, gs5ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_GS6, gs6ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_GS7, gs7ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS1_1, ps1_1ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS1_2, ps1_2ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS2_1, ps2_1ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS2_2, ps2_2ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS3_1, ps3_1ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS3_2, ps3_2ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS4_1, ps4_1ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS4_2, ps4_2ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS5_1, ps5_1ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS5_2, ps5_2ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS6_1, ps6_1ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS6_2, ps6_2ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS8_1, ps8_1ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PS8_2, ps8_2ToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_OTHER, otherActionToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_CONDITION, conditionActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_IO_INPUT, waitActionToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_CHECK, checkActionToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_PARALLEL, parallelActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_END, endActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_COMMENT, commentActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_IO_OUTPUT, outputActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_SYNC_START, syncBeginActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_SYNC_END, syncEndActionToStringHandler);
//actionToStringHandlerMap.put(actions.ACT_FLAG, flagActionToStringHandler);

var actionObjectToEditableITems = function(actionObject){
    if(actionObject.action === actions.F_CMD_SINGLE){
        return [{"item":"pos", "range":motorRangeAddr(actionObject.axis)},
                {"item":"speed", "range":"s_rw_0_32_1_1200"},
                {"item":"delay", "range":"s_rw_0_32_2_1100"}];
    }else if(actionObject.action === actions.F_CMD_LINE2D_MOVE_POINT ||
             actionObject.action === actions.F_CMD_LINE3D_MOVE_POINT ||
             actionObject.action === actions.F_CMD_ARC3D_MOVE_POINT ||
             actionObject.action === actions.F_CMD_MOVE_POSE ||
             actionObject.action === actions.F_CMD_LINE3D_MOVE_POSE){
        return [
                    {"item":"points"},
                    {"item":"speed", "range":"s_rw_0_32_1_1200"},
                    {"item":"delay", "range":"s_rw_0_32_2_1100"}
                ];
    }else if(actionObject.action === actions.F_CMD_IO_OUTPUT){
        return [{"item":"delay", "range":"s_rw_0_32_1_1201"}];
    }else if(actionObject.action === actions.F_CMD_IO_INPUT){
        return [{"item":"limit", "range":"s_rw_0_32_1_1201"}];
    }

    return [];
}


var actionToString = function(actionObject){
    var  toStrHandler = actionToStringHandlerMap.get(actionObject.action);
    if(toStrHandler === undefined) {console.log(actionObject.action)}
    return toStrHandler(actionObject);
}

function ProgramModelItem(actionObject, at){
    this.mI_ActionObject = actionObject;
    this.mI_IsActionRunning = false;
    this.mI_ActionType = at;
}

function ccErrnoToString(errno){
    switch(errno){
    case -1:
        return qsTr("Sub program is out of ranged");
    case kCCErr_Invalid:
        return qsTr("Invalid program");
    case kCCErr_Group_NoBegin:
        return qsTr("Has not Group-Begin action but has Group-End action");
    case kCCErr_Group_Nesting:
        return qsTr("Group action is nesting");
    case kCCErr_Group_NoEnd:
        return qsTr("Has Group-Begin action but has not Group-End action");
    case kCCErr_Sync_NoBegin:
        return qsTr("Has not Sync-Begin action but has Sync-End action");
    case kCCErr_Sync_Nesting:
        return qsTr("Sync action is nesting");
    case kCCErr_Sync_NoEnd:
        return qsTr("Has Sync-Begin action but has not Sync-End action");
    case kCCErr_Last_Is_Not_End_Action:
        return qsTr("Last action is not End action");
    }
    return qsTr("Unknow Error");
}

var flags = [];
var pushFlag = function(flag){
    for(var i = 0; i < flags.length; ++i){
        if(flag < flags[i]){
            flags.splice(i, 0, flag);
            return;
        }
    }
    flags.push(flag);
    return;
}

var delFlag = function(flag){
    for(var i = 0; i < flags.length; ++i){
        if(flag === flags[i]){
            flags.splice(i, 1);
            break;
        }
    }
}

var useableFlag = function(){
    if(flags.length === 0) return 0;
    if(flags.length < 3)
        return flags[flags.length - 1] + 1;
    if(flags[0] != 0) return 0;
    for(var i = 1; i < flags.length; ++i){
        if(flags[i] - flags[i - 1] > 1){
            return flags[i - 1] + 1;
        }
    }
    return flags[i - 1] + 1;
}

var canActionUsePoint = function(actionObject){
    return actionObject.action === actions.F_CMD_SINGLE ||
            actionObject.action === actions.F_CMD_CoordinatePoint ||
            actionObject.action === actions.F_CMD_SINGLE_POINT ||
            actionObject.action === actions.F_CMD_LINE2D_MOVE_POINT ||
            actionObject.action === actions.F_CMD_LINE3D_MOVE_POINT ||
            actionObject.action === actions.F_CMD_ARC3D_MOVE_POINT;
}
