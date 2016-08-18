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
    }
};

function customActionGenerator(actionDefine){
    actionDefine.generate = function(properties){
        var ret = {"action":actionDefine.action};
        for(var i = 0, len = actionDefine.properties.length; i< len; ++i){
            ret[actionDefine.properties[i].item] = properties[actionDefine.properties[i].item];
        }
        return ret;
    }
    actionDefine.toRegisterString = function(){
        var ret = {"actionID":actionDefine.action, "seq":[]};
        ret.seq.push(new ActionDefineItem("action", 0));
        for(var i = 0, len = actionDefine.properties.length; i< len; ++i){
            ret.seq.push(actionDefine.properties[i]);
        }
        return JSON.stringify(ret);
    }
    actionDefine.editableItems.editor = actionDefine.editableItems.editor.createObject(null);
}

