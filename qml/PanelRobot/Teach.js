.pragma library

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
