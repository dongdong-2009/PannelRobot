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

var extentActions = [extentPENQIANGAction, extentAnalogControlAction];
