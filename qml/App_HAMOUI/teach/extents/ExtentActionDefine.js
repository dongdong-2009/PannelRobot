.pragma library

Qt.include("../../configs/AxisDefine.js")

function ActionDefineItem(name, decimal){
    this.item = name;
    this.decimal = decimal;
}

var extentPENQIANGAction = { //< 喷涂摆枪命令
    /*
     *  id: 轴ID
     *  pos1:起始位置
     *  pos2:终止位置
     *  speed:速度
     *  num:次数
     */
    "action":1000,
    "generate":function(axisID, pos1, pos2, speed, num){
        return {
            "action":this.action,
            "axis":axisID,
            "pos1":pos1,
            "pos2":pos2,
            "speed":speed,
            "num":num
        };
    },
    "toStringHandler":function(actionObject){
        return qsTr("PENQIANG") + "-" + axisInfos[actionObject.axis].name + ":" +
                qsTr("Pos1:") + actionObject.pos1 + " " +
                qsTr("Pos2:") + actionObject.pos2 + " " +
                qsTr("Speed") + actionObject.speed + " " +
                qsTr("Num") + actionObject.num;

    },
    "canTestRun":true,
    "canActionUsePoint": false,
    "editableItems":{"editor":Qt.createComponent("PENQIANEditor.qml"), "itemDef":{"item":"PENQIANEditor"}},
    "parseDefine":{"actionID":1000,
        "seq":[
            new ActionDefineItem("action", 0),
            new ActionDefineItem("axis", 0),
            new ActionDefineItem("pos1", 3),
            new ActionDefineItem("pos2", 3),
            new ActionDefineItem("speed", 1),
            new ActionDefineItem("num", 0)
        ]},
};
