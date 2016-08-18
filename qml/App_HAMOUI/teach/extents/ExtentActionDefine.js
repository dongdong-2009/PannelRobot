.pragma library

Qt.include("../../configs/AxisDefine.js")

function ActionDefineItem(name, decimal){
    this.item = name;
    this.decimal = decimal;
}

//var extentPENGQIANGAction = {
//    "action":1000,

//};

//function customActionGenerator(actionDefine){
//    var ret = {};
//}

var extentPENQIANGAction = { //< 喷涂摆枪命令
    /*
     *  id: 轴ID
     *  pos1:起始位置
     *  pos2:终止位置
     *  speed:速度
     *  num:次数
     *  delay:
     */
    "action":1000,
    "generate":function(properties){
        return {
            "action":properties.action,
            "axis":properties.axis,
            "pos1":properties.pos1,
            "pos2":properties.pos2,
            "speed":properties.speed,
            "num":properties.num,
            "delay":properties.delay
        };
    },
    "toStringHandler":function(actionObject){
        return qsTr("PENQIANG") + "-" + axisInfos[actionObject.axis].name + ":" +
                qsTr("Pos1:") + actionObject.pos1 + " " +
                qsTr("Pos2:") + actionObject.pos2 + " " +
                qsTr("Speed:") + actionObject.speed + " " +
                qsTr("Num:") + actionObject.num + " " +
                qsTr("Delay:") + actionObject.delay;

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
            new ActionDefineItem("num", 0),
            new ActionDefineItem("delay",2)
        ]},
};
