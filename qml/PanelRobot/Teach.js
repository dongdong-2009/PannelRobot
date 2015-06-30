.pragma library

Qt.include("../utils/HashTable.js")
Qt.include("../utils/stringhelper.js")

var actHelper = 0;
var actions = {

};
actions.ACT_GS8 = actHelper++;
actions.ACT_GS1 = actHelper++;
actions.ACT_GS2 = actHelper++;
actions.ACT_GS3 = actHelper++;
actions.ACT_GS4 = actHelper++;
actions.ACT_GS5 = actHelper++;
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
actions.ACT_END        = actHelper++;
actions.ACT_COMMENT    = actHelper;
actions.ACT_OUTPUT     = 0x80;

var kAxisType_NoUse = 0;
var kAxisType_Servo = 1;
var kAxisType_Pneumatic = 2;
var kAxisType_Reserve = 3;

var generateAxisServoAction = function(action,
                                  pos,
                                  speed,
                                  delay,
                                  isBadEn,
                                  isEarlyEnd,
                                  earlyEndPos){
    return {
        "action":action,
        "pos": pos||0.00,
        "speed":speed||80,
        "delay":delay||0.00,
        "isBadEn":isBadEn||false,
        "isEarlyEnd":isEarlyEnd||false,
        "earlyEndPos":earlyEndPos||0.00
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

var generateWaitAction = function(which, limit){
    return {
        "action":actions.ACT_Wait,
        "point":which,
        "limit":limit || 0.50
    };
}

var generateInitProgram = function(axisDefine){

    var initStep = {}
    initStep = axisDefine.s8Axis == kAxisType_Reserve ? generateAxisServoAction(actions.ACT_GS8) :
                                                        generateAxisPneumaticAction(actions.ACT_PS8_1);
    var aT;
    var synsActions = [];
    synsActions.push(initStep);
    for(var i = 1; i < 8; ++i){
        aT = axisDefine["s"+ i + "Axis"];
        if(aT == kAxisType_Servo){
            synsActions.push(generateAxisServoAction(actions["ACT_GS" + i]));
        }else if(aT == kAxisType_Pneumatic){
            synsActions.push(generateAxisPneumaticAction(actions["ACT_PS" + i + "_1"]));
        }
    }

    return JSON.stringify([synsActions, [generateWaitAction(1)], [generteEndAction()]]);

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

var gs1ToStringHandler = function(actionObject){

}

var gs1ToStringHandler = function(actionObject){

}

var gs1ToStringHandler = function(actionObject){

}

var gs2ToStringHandler = function(actionObject){

}

var gs3ToStringHandler = function(actionObject){

}

var gs4ToStringHandler = function(actionObject){

}

var gs5ToStringHandler = function(actionObject){

}

var gs6ToStringHandler = function(actionObject){

}

var gs7ToStringHandler = function(actionObject){

}

var gs8ToStringHandler = function(actionObject){

}

var ps1_1ToStringHandler = function(actionObject){

}
var ps1_2ToStringHandler = function(actionObject){

}

var ps2_1ToStringHandler = function(actionObject){

}
var ps2_2ToStringHandler = function(actionObject){

}

var ps3_1ToStringHandler = function(actionObject){

}
var ps3_2ToStringHandler = function(actionObject){

}

var ps4_1ToStringHandler = function(actionObject){

}
var ps4_2ToStringHandler = function(actionObject){

}

var ps5_1ToStringHandler = function(actionObject){

}
var ps5_2ToStringHandler = function(actionObject){

}

var ps6_1ToStringHandler = function(actionObject){

}
var ps6_2ToStringHandler = function(actionObject){

}

var ps8_1ToStringHandler = function(actionObject){

}
var ps8_2ToStringHandler = function(actionObject){

}

var otherActionToStringHandler = function(actionObject){

}

var conditionActionToStringHandler = function(actionObject){

}

var waitActionToStringHandler = function(actionObject){

}

var checkActionToStringHandler = function(actionObject){

}

var parallelActionToStringHandler = function(actionObject){

}

var endActionToStringHandler = function(actionObject){

}

var commentActionToStringHandler = function(actionObject){

}

var outputActionToStringHandler = function(actionObject){

}


var actionToStringHandlerMap = new HashTable();
actionToStringHandlerMap.put(actions.ACT_GS8, gs8ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_GS1, gs1ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_GS2, gs2ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_GS3, gs3ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_GS4, gs4ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_GS5, gs5ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_GS6, gs6ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_GS7, gs7ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS1_1, ps1_1ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS1_2, ps1_2ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS2_1, ps2_1ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS2_2, ps2_2ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS3_1, ps3_1ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS3_2, ps3_2ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS4_1, ps4_1ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS4_2, ps4_2ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS5_1, ps5_1ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS5_2, ps5_2ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS6_1, ps6_1ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS6_2, ps6_2ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS8_1, ps8_1ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PS8_2, ps8_2ToStringHandler);
actionToStringHandlerMap.put(actions.ACT_OTHER, otherActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_CONDITION, conditionActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_Wait, waitActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_CHECK, checkActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_PARALLEL, parallelActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_END, endActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_COMMENT, commentActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_OUTPUT, outputActionToStringHandler);



var actionToString = function(actionObject){
    return actionToStringHandlerMap.get(actionObject.action)(actionObject);
}
