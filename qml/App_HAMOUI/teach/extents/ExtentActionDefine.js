.pragma library

Qt.include("../../configs/AxisDefine.js")

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
}

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
                axisInfos[5].name + ":" +actionObject.wpos1 + "\n" +
                qsTr("LH:")+actionObject.lh+","+
                qsTr("MH:")+actionObject.mh+","+
                qsTr("RH:")+actionObject.rh+"\n"+
                qsTr("end pos:")+
                axisInfos[0].name + ":" +actionObject.xpos2 + "," +
                axisInfos[1].name + ":" +actionObject.ypos2 + "," +
                axisInfos[2].name + ":" +actionObject.zpos2 + "," +
                axisInfos[3].name + ":" +actionObject.upos2 + "," +
                axisInfos[4].name + ":" +actionObject.vpos2 + "," +
                axisInfos[5].name + ":" +actionObject.wpos2 + "\n" +
                qsTr("speed:") + actionObject.speed + " " +
                qsTr("Delay:") + actionObject.delay;
    }
}

var extentActions = [extentPENQIANGAction, extentAnalogControlAction,extentDeltaJumpAction];
