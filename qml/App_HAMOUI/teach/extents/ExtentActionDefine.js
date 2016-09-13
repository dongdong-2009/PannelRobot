.pragma library
Qt.include("../../configs/AxisDefine.js")

var counterManager;

function init(cManager){
    counterManager = cManager;
}

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
    "canActionUsePoint": true,
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
        return qsTr("Safe Control") + ":" + qsTr("if") + " " + axisInfos[id1].name + (allow ? qsTr("out pos fange:") : qsTr("in pos fange:") ) +
                "("+actionObject.pos1+"," +actionObject.pos2+")"+"\n                            " +
                axisInfos[id2].name+
                qsTr("out pos fange:") +"("+actionObject.lpos1+"," +actionObject.lpos2+")"+"\n                            " +
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
    "editableItems":{"editor":Qt.createComponent("SingleStackAction.qml"), "itemDef":{"item":"SingleStackAction"}},
    "toStringHandler":function(actionObject){
        var configs = actionObject.configs;
        var axisID = configs & 0x1F;
        var dir = configs >> 5 & 1;
        var bindingCounter = (configs >> 16) & 1;
        var counterID = (configs >>17);
        return qsTr("Single Stack") + "-" +  axisInfos[axisID].name + ":" + (dir == 0 ? qsTr("RP") : qsTr("PP")) + " " +
                qsTr("space:") + actionObject.space + " " + qsTr("count:") + actionObject.count + "\n                            " +
                (bindingCounter ? counterManager.counterToString(counterID, true) :  qsTr("Counter:Self")) + " " +
                qsTr("speed:") + actionObject.speed;
    }
};

var extentActions = [extentPENQIANGAction,
                     extentAnalogControlAction,
                     extentDeltaJumpAction,
                     extentSafeRangeAction,
        extentSingleStackAction];
