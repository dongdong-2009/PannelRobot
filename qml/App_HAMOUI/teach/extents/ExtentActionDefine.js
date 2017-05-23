.pragma library
Qt.include("../../configs/AxisDefine.js")
Qt.include("../../configs/IODefines.js")
Qt.include("../Teach.js")
Qt.include("../../ToolsCalibration.js")
Qt.include("../../ToolCoordManager.js")

function ActionDefineItem(name, decimal){
    this.item = name;
    this.decimal = decimal;
}

var extentPENQIANGAction = {
    "action":1000,
    "properties":[new ActionDefineItem("axis", 0),
        new ActionDefineItem("pos1", 3),
        new ActionDefineItem("pos2", 3),
        new ActionDefineItem("speed", 1),
        new ActionDefineItem("num", 0),
        new ActionDefineItem("delay",2)],
    "canTestRun":true,
    "canActionUsePoint": false,
    "editableItems":{"editor":Qt.createComponent("PENQIANEditor.qml"), "itemDef":{"item":"PENQIANEditor"}},
    "toStringHandler":function(actionObject){
        return qsTr("PENQIANG") + "-" + axisInfos[actionObject.axis].name + ":" +
                qsTr("Pos1:") + actionObject.pos1 + " " +
                qsTr("Pos2:") + actionObject.pos2 + " " +
                qsTr("Speed:") + actionObject.speed + " " +
                qsTr("Num:") + actionObject.num + " " +
                qsTr("Delay:") + actionObject.delay;
    },

};

var extentAnalogControlAction = {
    "action":250,
    "properties":[new ActionDefineItem("chanel", 0),
        new ActionDefineItem("analog", 1),
        new ActionDefineItem("delay", 1)
    ],
    "canTestRun":true,
    "canActionUsePoint": false,
    "editableItems":{"editor":Qt.createComponent("AnalogControlEditor.qml"), "itemDef":{"item":"AnalogControlEditor"}},
    "toStringHandler":function(actionObject){
        return qsTr("Analog Control") + "-" + actionObject.chanel + ":" +
                qsTr("Analog:") + actionObject.analog + " " +
                qsTr("Delay:") + actionObject.delay;
    }
};

var extentDeltaJumpAction = {
    "action":700,
    "properties":[
        new ActionDefineItem("xpos1", 3),
        new ActionDefineItem("ypos1", 3),
        new ActionDefineItem("zpos1", 3),
        new ActionDefineItem("upos1", 3),
        new ActionDefineItem("vpos1", 3),
        new ActionDefineItem("wpos1", 3),
        new ActionDefineItem("xpos2", 3),
        new ActionDefineItem("ypos2", 3),
        new ActionDefineItem("zpos2", 3),
        new ActionDefineItem("upos2", 3),
        new ActionDefineItem("vpos2", 3),
        new ActionDefineItem("wpos2", 3),
        new ActionDefineItem("lh", 3),
        new ActionDefineItem("mh", 3),
        new ActionDefineItem("rh", 3),
        new ActionDefineItem("speed", 1),
        new ActionDefineItem("delay", 1)
    ],
    "canTestRun":true,
    "canActionUsePoint": false,
    "editableItems":{"editor":Qt.createComponent("DeltaJumpEditor.qml"), "itemDef":{"item":"DeltaJumpEditor"}},
    "toStringHandler":function(actionObject){
        return qsTr("Delta Jumpl") + ":" + qsTr("start pos:")+
                axisInfos[0].name + ":" +actionObject.xpos1 + "," +
                axisInfos[1].name + ":" +actionObject.ypos1 + "," +
                axisInfos[2].name + ":" +actionObject.zpos1 + "," +
                axisInfos[3].name + ":" +actionObject.upos1 + "," +
                axisInfos[4].name + ":" +actionObject.vpos1 + "," +
                axisInfos[5].name + ":" +actionObject.wpos1 + "\n                            " +
                qsTr("LH:")+actionObject.lh+","+
                qsTr("MH:")+actionObject.mh+","+
                qsTr("RH:")+actionObject.rh+"\n                            "+
                qsTr("end pos:")+
                axisInfos[0].name + ":" +actionObject.xpos2 + "," +
                axisInfos[1].name + ":" +actionObject.ypos2 + "," +
                axisInfos[2].name + ":" +actionObject.zpos2 + "," +
                axisInfos[3].name + ":" +actionObject.upos2 + "," +
                axisInfos[4].name + ":" +actionObject.vpos2 + "," +
                axisInfos[5].name + ":" +actionObject.wpos2 + "\n                            " +
                qsTr("speed:") + actionObject.speed + " " +
                qsTr("Delay:") + actionObject.delay;
    }
};

var extentSafeRangeAction = {
    "action":550,
    "properties":[
        new ActionDefineItem("para1", 0),
        new ActionDefineItem("pos1", 0),
        new ActionDefineItem("pos2", 0),
        new ActionDefineItem("lpos1", 0),
        new ActionDefineItem("lpos2", 0),
        new ActionDefineItem("aid", 0)
    ],
    "canTestRun":false,
    "canActionUsePoint": false,
    "editableItems":{"editor":Qt.createComponent("SafeRangeEditor.qml"), "itemDef":{"item":"SafeRangeEditor"}},
    "toStringHandler":function(actionObject){
        var id1 = actionObject.para1&0xf;
        var id2 = (actionObject.para1>>4)&0xf;
        var allow = (actionObject.para1>>8)&1;
        var type = (actionObject.para1>>9)&1;
        var coor = (actionObject.para1>>10)&1;
        var whenChangeType = actionObject.para1 >> 11;
        return qsTr("Safe Control") + ":" + qsTr("if") + " " + axisInfos[id1].name + (allow ? qsTr("out pos fange:") : qsTr("in pos fange:") ) +
                "("+actionObject.pos1+"," +actionObject.pos2+")"+"\n                            " +
                axisInfos[id2].name+ " " + (whenChangeType ? qsTr("When Changed") :
                qsTr("out pos fange:") +"("+actionObject.lpos1+"," +actionObject.lpos2+")" ) +"\n                            " +
                qsTr("will alarm:") + actionObject.aid;
    },
    "actionObjectChangedHelper":function(editor, actionObject){
    }
};

var extentSingleStackAction = {
    "action":301,
    "properties":[new ActionDefineItem("startPos", 3),
        new ActionDefineItem("space", 3),
        new ActionDefineItem("count", 0),
        new ActionDefineItem("speed", 1),
        new ActionDefineItem("configs", 0)
    ],
    "canTestRun":true,
    "canActionUsePoint": true,
    "pointsReplace":function(generatedAction){
        var pts = generatedAction.points;
        if(pts.length == 0) return;
        generatedAction.startPos = pts[0].pos["m" + (generatedAction.configs & 0x1F)];
    },

    "hasCounter":true,
    "getCountersID":function(actionObject){
        return [actionObject.configs >> 17];
    },

    "editableItems":{"editor":Qt.createComponent("SingleStackAction.qml"), "itemDef":{"item":"SingleStackAction"}},
    "toStringHandler":function(actionObject, record){
        var configs = actionObject.configs;
        var axisID = configs & 0x1F;
        var dir = (configs >> 5) & 1;
        var bindingCounter = (configs >> 16) & 1;
        var counterID = (configs >>17);
        var points = (actionObject.points == undefined ? [] : actionObject.points);
        var startPos = actionObject.startPos;
        var isAddr = (configs >> 8) & 0xFF;
        if(points.length !== 0){
            startPos = points[0].pointName + "(" + points[0].pos["m" + axisID] + ")";
        }

        return qsTr("Single Stack") + "-" +  axisInfos[axisID].name + ":" + (dir == 0 ? qsTr("RP") : qsTr("PP")) + " " +
                qsTr("Start Pos:") + startPos + " " +
                qsTr("space:") + (isAddr ? qsTr("Addr:") : "") + actionObject.space + " " + qsTr("count:") + actionObject.count + "\n                            " +
                (bindingCounter ? record.counterManager.counterToString(counterID, true) :  qsTr("Counter:Self")) + " " +
                qsTr("speed:") + actionObject.speed;
    }
};

var extentSwitchCoordAction = {
        "action":800,
        "properties":[new ActionDefineItem("coordID", 0)],
        "canTestRun":false,
        "canActionUsePoint": false,
        "editableItems":{"editor":Qt.createComponent("SwitchCoordEditor.qml"), "itemDef":{"item":"SwitchCoordEditor"}},
        "toStringHandler":function(actionObject){
            return qsTr("Switch Coord") + ":" +"["+ qsTr("CoordID")+actionObject.coordID+"]"+ (actionObject.coordID==0?qsTr("world coord"):toolCoordManager.getToolCoord(actionObject.coordID).name);
        },
        "actionObjectChangedHelper":function(editor, actionObject){
        }
    };

var speedAction = {
        "action":16,
        "properties":[new ActionDefineItem("startSpeed", 1),
                    new ActionDefineItem("endSpeed", 1)],
        "canTestRun":false,
        "canActionUsePoint": false,
        "editableItems":{"editor":Qt.createComponent("../SpeedActionEditor.qml"), "itemDef":{"item":"SpeedActionEditor"}},
        "toStringHandler":function(actionObject){
            return qsTr("Path Speed:") + " " + qsTr("Start Speed:") + actionObject.startSpeed + " " + qsTr("End Speed:") + actionObject.endSpeed;
        }
    };

var extentSingleMemposAction = {
        "action":24,
        "properties":[new ActionDefineItem("id", 0),
        new ActionDefineItem("tpos", 3),
        new ActionDefineItem("speed", 1),
        new ActionDefineItem("delay", 2),
        new ActionDefineItem("stopEn", 0),
        new ActionDefineItem("point", 0),
        new ActionDefineItem("pStatus", 0),
        new ActionDefineItem("immStop", 0),
        new ActionDefineItem("devPos", 0),
        new ActionDefineItem("devLen", 3),
        new ActionDefineItem("decSpeed", 1),
        new ActionDefineItem("memAddr", 0),],
        "canTestRun":false,
        "canActionUsePoint": false,
        "editableItems":{"editor":Qt.createComponent("AxisMemposEditor.qml"), "itemDef":{"item":"AxisMemposEditor"}},
        "toStringHandler":function(actionObject){
            var ret =  axisInfos[actionObject.id].name + ":";
            ret +=  (actionObject.tpos == ""?0:actionObject.tpos);
            ret +=  " " + qsTr("Speed:") + actionObject.speed + " " +
                    qsTr("Delay:") + actionObject.delay;
            ret += "\n                            ";
            ret += " " + qsTr("Early dec dev len:") + actionObject.devLen;
            ret += " " + qsTr("dev pos:") + actionObject.devPos;
            ret += " " + qsTr("Early dec Spd:") + actionObject.decSpeed;
            ret += " " + qsTr("mem addr:") + actionObject.memAddr;
            if(actionObject.stopEn){
                ret += "\n                            ";
                ret += " " + qsTr("When ") + ioItemName(xDefines[actionObject.point]) + " " + (actionObject.pStatus == 1? qsTr("is Off"):qsTr("is On"));
                ret += " " + (actionObject.immStop == 0 ? qsTr("slow stop") : qsTr("fast stop"));
            }
            return ret;
        }
    };

var extentOutputAction = {
        "action":200,
        "properties":[new ActionDefineItem("type", 0),
                    new ActionDefineItem("point", 0),
                    new ActionDefineItem("pointStatus", 0),
                    new ActionDefineItem("delay", 1)],
        "canTestRun":false,
        "canActionUsePoint": false,
        "editableItems":{"editor":Qt.createComponent("../OutputActionEditor.qml"), "itemDef":{"item":"OutputActionEditor"}},
        "generate":function(properties){
            var ret = {"action":200};
            ret.type = properties.type;
            ret.point = properties.point;
            ret.pointStatus = properties.pointStatus;
            ret.valveID = properties.valveID;
            ret.delay = properties.delay || 0;
            return ret;
        },
        "toStringHandler":function(actionObject){
            var valve,valveStr;
            if((actionObject.valveID >= 0) && (actionObject.type == VALVE_BOARD)){
                valve = getValveItemFromValveID(actionObject.valveID);
                return valveItemToString(valve)+ (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                        + qsTr("Delay:") + actionObject.delay;

            }else if(actionObject.type === VALVE_CHECK_START){
                if(actionObject.isNormalX )
                    valveStr = qsTr("NormalX-")+xDefines[actionObject.point].pointName+":"+xDefines[actionObject.point].descr;
                else
                    valveStr = valveItemToString(getValveItemFromValveID(actionObject.point));
                return qsTr("Check:") + valveStr + " " + qsTr("Check Start") + " "
                        + (actionObject.isNormalX ?(actionObject.xDir?qsTr("Reverse "):qsTr("Forward ")):"")+" "+qsTr("Delay:") + actionObject.delay;
            }else if(actionObject.type === VALVE_CHECK_END){
                if(actionObject.isNormalX )
                    valveStr = qsTr("NormalX-")+xDefines[actionObject.point].pointName+":"+xDefines[actionObject.point].descr;
                else
                    valveStr = valveItemToString(getValveItemFromValveID(actionObject.point));
                return qsTr("Check:") + valveStr +  " " + qsTr("Check End") + " "
                        +qsTr("Delay:")+"" + actionObject.delay;
            }else{
                if(actionObject.type >= TIMEY_BOARD_START){
                    return qsTr("Time Output:") + getYDefineFromHWPoint(actionObject.point, actionObject.type - TIMEY_BOARD_START).yDefine.descr + (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                            + qsTr("Action Time:") + actionObject.delay;
                }else{
                    return qsTr("Output:") + getYDefineFromHWPoint(actionObject.point, actionObject.type).yDefine.descr + (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                            + qsTr("Delay:") + actionObject.delay;
                }
            }
        },
        "actionObjectChangedHelper":function(editor, actionObject){
        },
        "updateActionObjectHelper":function(editor,actionObject){
            actionObject.action = 200;
            actionObject.type = editor.type;
            actionObject.point = editor.point;
            actionObject.pointStatus = editor.pointStatus;
            actionObject.valveID = editor.valveID;
            actionObject.delay = editor.delay;
            if(actionObject.hasOwnProperty("acTime")){
                delete actionObject.acTime;
            }
        },
        "getActionPropertiesHelper":function(editor){
            var ret = {"action":200};
            ret.type = editor.type;
            ret.point = editor.point;
            ret.pointStatus = editor.pointStatus;
            ret.valveID = editor.valveID;
            ret.delay = editor.delay;
            return ret;
        }
    };

var extentIntervalOutputAction = {
        "action":201,
        "properties":[new ActionDefineItem("intervalType", 0),
                     new ActionDefineItem("isBindingCount", 0),
                     new ActionDefineItem("pointStatus", 0),
                     new ActionDefineItem("point", 0),
                     new ActionDefineItem("type", 0),
                     new ActionDefineItem("counterID", 0),
                     new ActionDefineItem("cnt", 0),
                     new ActionDefineItem("delay", 1)],

        "canTestRun":false,
        "canActionUsePoint": false,
        "editableItems":{"editor":Qt.createComponent("../OutputActionEditor.qml"), "itemDef":{"item":"OutputActionEditor"}},
        "generate":function(properties){
            var ret = {"action":201};
            ret.intervalType = properties.intervalType;
            ret.isBindingCount = properties.isBindingCount;
            ret.pointStatus = properties.pointStatus;
            ret.point = properties.point;
            ret.type = properties.type;
            ret.counterID = properties.counterID;
            ret.cnt = properties.cnt;
            ret.delay = properties.delay;
            return ret;
        },
        "toStringHandler":function(actionObject, record){
            if(actionObject.pointStatus == undefined) return "";
            var counterID1 = (actionObject.isBindingCount ? record.counterManager.counterToString(actionObject.counterID, true) : qsTr("Counter:Self"));
            return qsTr("IntervalOutput:") + qsTr("Interval")+actionObject.cnt+qsTr(",")+
                    getYDefineFromHWPoint(actionObject.point, actionObject.type).yDefine.descr + ""
                    + (actionObject.intervalType?qsTr("Always out"):qsTr("Time out")) +
                    actionObject.delay+"s" + (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF"))+"\n                            "
                    +counterID1;
        },
        "actionObjectChangedHelper":function(editor, actionObject){
        },
        "updateActionObjectHelper":function(editor,actionObject){
            actionObject.action = 201;
            actionObject.intervalType = editor.intervalType;
            actionObject.isBindingCount = editor.isBindingCount;
            actionObject.pointStatus = editor.pointStatus;
            actionObject.point = editor.point;
            actionObject.type = editor.type;
            actionObject.counterID = editor.counterID;
            actionObject.cnt = editor.cnt;
            actionObject.delay = editor.delay;
        },
    };

var extentParabolaAction = {
    "action":25,
    "properties":[new ActionDefineItem("ePos0", 3),
        new ActionDefineItem("ePos1", 3),
        new ActionDefineItem("endType", 0),
        new ActionDefineItem("surfaceType", 0),
        new ActionDefineItem("pL", 3),
        new ActionDefineItem("a", 3),
        new ActionDefineItem("speed", 1),
        new ActionDefineItem("delay", 2),
    ],
    "canTestRun":true,
    "canActionUsePoint": true,
    "pointsReplace":function(generatedAction){
        var pts = generatedAction.points;
        if(pts.length == 0) return;
        generatedAction.ePos0 = pts[0].pos["m"+(generatedAction.surfaceType == 2?1:0)];
        generatedAction.ePos1 = pts[0].pos["m"+(generatedAction.surfaceType == 0?1:2)];
    },

    "editableItems":{"editor":Qt.createComponent("ParabolaActionEditor.qml"), "itemDef":{"item":"ParabolaActionEditor"}},
    "toStringHandler":function(actionObject, record){
        var su,fir,sec,end;
        var pts = actionObject.points;
        if(actionObject.surfaceType == 0){
            su = "XY:";
            fir = "X:";
            sec = "Y:";
        }
        else if(actionObject.surfaceType == 1){
            su = "XZ:";
            fir = "X:";
            sec = "Z:"
        }
        else if(actionObject.surfaceType == 2){
            su = "YZ:";
            fir = "Y:";
            sec = "Z:";
        }
        if(actionObject.endType == 0){
            end = qsTr("On");
        }
        else if(actionObject.endType == 1){
            end = qsTr("Before");
        }
        else if(actionObject.endType == 2){
            end = qsTr("After");
        }

        return qsTr("Parabola Move")+su+end +qsTr("endPos:")+(pts.length >0?(pts[0].pointName+"("):"")+fir+actionObject.ePos0 +" " +sec+actionObject.ePos1+(pts.length >0?")":"")+"\n                            "+
                qsTr("period len:")+actionObject.pL+" "+ qsTr(" A")+ actionObject.a +"\n                            "+
                qsTr("speed:")+actionObject.speed + " " + qsTr("delay:")+actionObject.delay;
    }
};

var extentBarnLogicAction = {
        "action":203,
        "properties":[new ActionDefineItem("barnID", 0),
    new ActionDefineItem("start", 0),
    new ActionDefineItem("delay",1)],
        "canTestRun":true,
        "canActionUsePoint": false,
        "editableItems":{"editor":Qt.createComponent("BarnLogicEditor.qml"), "itemDef":{"item":"BarnLogicEditor"}},
        "generate":function(properties){
            var ret = {"action":203};
            ret.barnID = properties.barnID;
            ret.start = properties.start;
            ret.delay = properties.delay;
            ret.barnName = properties.barnName;
            return ret;
        },
        "getActionPropertiesHelper":function(editor){
            var ret = {"action":203};
            ret.barnID = editor.barnID;
            ret.start = editor.start;
            ret.delay = editor.delay;
            ret.barnName = editor.barnName;
            return ret;
        },
        "updateActionObjectHelper":function(editor,actionObject){
            actionObject.action = 203;
            actionObject.barnID = editor.barnID;
            actionObject.start = editor.start;
            actionObject.delay = editor.delay;
            actionObject.barnName = editor.barnName;
        },
        "actionObjectChangedHelper":function(editor, actionObject){
        },
        "toStringHandler":function(actionObject){
            var tmpStr = "";
            if(actionObject.start ==0)tmpStr = qsTr("Stop");
            else if(actionObject.start ==1)tmpStr = qsTr("Start");
            else if(actionObject.start ==2)tmpStr = qsTr("Up");
            else if(actionObject.start ==3)tmpStr = qsTr("Down");
            return qsTr("Barn")+qsTr("Ctrl") + ":" + actionObject.barnName + tmpStr+" "+qsTr("delay")+":"+actionObject.delay;
        }
    };
var extentSwitchToolAction = {
        "action":801,
        "properties":[new ActionDefineItem("toolID", 0)],
        "canTestRun":false,
        "canActionUsePoint": false,
        "editableItems":{"editor":Qt.createComponent("SwitchToolEditor.qml"), "itemDef":{"item":"SwitchToolEditor"}},
        "toStringHandler":function(actionObject){
            return qsTr("Switch Tool") + ":" +"["+ qsTr("toolID")+actionObject.toolID+"]"+ (actionObject.toolID==0?qsTr("None"):toolCalibrationManager.getToolCalibration(actionObject.toolID).name);
        },
        "actionObjectChangedHelper":function(editor, actionObject){
        }
    };


var extentActions = [extentPENQIANGAction,
                     extentAnalogControlAction,
                     extentDeltaJumpAction,
                     extentSafeRangeAction,
                     extentSingleStackAction,
                     extentSwitchCoordAction,
                     speedAction,
                     extentSingleMemposAction,
                     extentOutputAction,
                     extentIntervalOutputAction,
                     extentParabolaAction,
                     extentBarnLogicAction,
                     extentSwitchToolAction];
