.pragma library

Qt.include("../../utils/HashTable.js")
Qt.include("../../utils/stringhelper.js")
Qt.include("../configs/AxisDefine.js")
Qt.include("../configs/IODefines.js")
Qt.include("../configs/AlarmInfo.js")
Qt.include("../../utils/utils.js")

var DefinePoints = {
    kPT_Locus: "L",
    kPT_Free:"F",
    kPT_Offset:"D",
    createNew: function(){        
        var definePoints = {};
        definePoints.pointsMonitors = [];
        definePoints.definedPoints = [];

        definePoints.registerPointsMonitor = function(obj){
            definePoints.pointsMonitors.push(obj);
        }

        definePoints.informMonitorsHelper = function(event, point){
            var monitors = definePoints.pointsMonitors;
            for(var i = 0; i < monitors.length; ++i){
                if(monitors[i].hasOwnProperty(event))
                    monitors[i][event](point);
            }
        }

        definePoints.informPointDataChanged = function(point){
            definePoints.informMonitorsHelper("onPointChanged", point);
        }

        definePoints.informPointAdded = function(point){
            definePoints.informMonitorsHelper("onPointAdded", point);
        }

        definePoints.informPointDeleted = function(point){
            definePoints.informMonitorsHelper("onPointDeleted", point);
        }

        definePoints.informPointsCleared = function(){
            definePoints.informMonitorsHelper("onPointsCleared");
        }

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

        definePoints.pushPoint = function(pID, point){
            for(var i = 0, len = definePoints.definedPoints.length; i < len; ++i){
                if(pID < definePoints.definedPoints[i].index){
                    definePoints.definedPoints.splice(i, 0, point);
                    return;
                }
            }
            definePoints.definedPoints.push(point);
        }

        definePoints.addNewPoint = function(name, point, type){
            var pID = definePoints.createPointID();
            var t = type || DefinePoints.kPT_Free
            name = t + "P" + pID + ":" + name;
            var iPoint = definePoints.createPointObject(pID, name, point);
//            definePoints.definedPoints.splice(pID, 0, iPoint);
            definePoints.pushPoint(pID, iPoint);
            definePoints.informPointAdded(iPoint);
            return iPoint;
        }
        definePoints.updatePoint = function(pointID, point){
            var ps = definePoints.definedPoints;
            for(var i = 0;i<ps.length;i++){
                if(pointID === ps[i].index){
                    definePoints.definedPoints[i].point = point.point;
                    definePoints.informPointDataChanged(definePoints.definedPoints[i]);
                    break;
                }
            }
//            return definePoints.definedPoints;
        }

        definePoints.deletePoint = function(pointID){
            var ps = definePoints.definedPoints;
            for(var i = 0; i < ps.length; ++i){
                if(pointID == ps[i].index){
                    definePoints.definedPoints.splice(i,1);
                    definePoints.informPointDeleted(ps[i]);
                }
            }
//            return definePoints.definedPoints;
        }

        //{"m0":123, "m1":}
        definePoints.getPoint = function(name){
            var pID = definePoints.extractPointIDFromPointName(name);
            var ps = definedPoints.definedPoints;
            for(var i = 0; i < ps.length; ++i){
                if(ps[i].index == pID)
                    return definedPoints.definedPoints[i];
            }
            return null;

        }

        definePoints.extractPointIDFromPointName = function(name){
            var nI = name.indexOf(":");
            return parseInt(name.substring(2, nI));
        }
        definePoints.isPointExist = function(pointID){
            for(var i = 0, len = definePoints.definedPoints.length; i < len; ++i){
                if(pointID == definePoints.definedPoints[i].index)
                    return true;
            }
            return false;
        }
        definePoints.pointNameList = function(){
            var ret = [];
            for(var i = 0, len = definePoints.definedPoints.length; i < len; ++i){
                ret.push(definePoints.definedPoints[i].name);
            }
            return ret;
        }
        definePoints.pointDescr = function(point, axisDefine){
            if(point == undefined)
            {
                console.log("err");
            }

            var ret = "";
            if(point.name.length !== 0){
                ret = point.name + "(";
            }

            var m;
            var pointPos = point.point;
            for(var i = 0; i < 6; ++i){
                m = "m" + i;
                if(pointPos.hasOwnProperty(m)){
                    if(axisDefine[i].visiable)
                        ret += axisDefine[i].name + ":" + pointPos[m] + ","
                }
            }
            ret = ret.substr(0, ret.length - 1);
            if(point.name.length !== 0){
                ret += ")";
            }
            return ret;
        }

        definePoints.getPointName = function(point){
            return point.name.substr(point.name.indexOf(":") + 1);
        }

        definePoints.clear = function(){
            definePoints.definedPoints.length = 0;
            definePoints.informPointsCleared();
        }
        definePoints.parseActionPointsHelper = function(actionObject){
            if(!actionObject.hasOwnProperty("points"))
                return [];
            var points = actionObject.points;
            var name;
            var pID;
            var ret = [];
            for(var i = 0; i < points.length; ++i){
                name = points[i].pointName || "";
                if(name === "")
                    continue;
                pID = definePoints.extractPointIDFromPointName(name);
                ret.push(definePoints.createPointObject(pID, name, points[i].pos))
            }
            return ret;
        }

        definePoints.parseActionPoints = function(actionObject){
            var points = definePoints.parseActionPointsHelper(actionObject);
            for(var i = 0; i < points.length; ++i){
                if(!definePoints.isPointExist(points[i].index)){
                    definePoints.pushPoint(points[i].index, points[i]);
                    definePoints.informPointAdded(points[i]);
                }
            }
        }

        definePoints.parseProgram = function(program){
            for(var i = 0; i < program.length; ++i){
                definePoints.parseActionPoints(program[i]);
            }
        }

        return definePoints;
    }

};

var definedPoints = DefinePoints.createNew();

var actionTypes = {
    "kAT_Normal":0,
    "kAT_SyncStart":1,
    "kAT_SyncEnd":2,
    "kAT_Flag":3,
    "kAT_Wait":4
};

var stackTypes = {
    "kST_Normal":0,
    "kST_Box":1
};


function FlagItem(flagID, descr){
    this.flagID = flagID;
    this.descr = descr || "";
}

var flagsDefine = {
    "flags":[[],[],[],[],[],[],[],[],[],[],[]],
    "clear":function(programIndex){
        this.flags[programIndex].length = 0;
    },

    "createFlag":function(programIndex, flagName){
        if(programIndex >= this.flags.length)
            return null;
        var pFlags = this.flags[programIndex];
        var fID = -1;
        for(var i = 0; i < pFlags.length; ++i){
            if(i < pFlags[i].flagID){
                fID = i;
                break;
            }
        }
        if(fID < 0)
            fID = pFlags.length;
        return new FlagItem(fID, flagName);
    },

    "getFlag" :function(programIndex, flagID){
        if(programIndex >= this.flags.length)
            return null;
        var pFlags = this.flags[programIndex];
        for(var i = 0;i < pFlags.length; ++i){
            if(flagID == pFlags[i].flagID)
                return pFlags[i];
        }
        return null;
    },

    "pushFlag" :function(programIndex, flag){
        if(programIndex >= this.flags.length)
            return;
        var pFlags = this.flags[programIndex];
        for(var i = 0; i < pFlags.length; ++i){
            if(flag.flagID < pFlags[i].flagID){
                this.flags[programIndex].splice(i, 0, flag);
                return;
            }
        }
        this.flags[programIndex].push(flag);
    },

    "delFlag" : function(programIndex, flagID){
        if(programIndex >= this.flags.length)
            return;
        var pFlags = this.flags[programIndex];
        for(var i = 0; i < pFlags.length; ++i){
            if(flagID == pFlags[i].flagID){
                this.flags[programIndex].splice(i, 1);
                break;
            }
        }
    },

    "flagName" : function(programIndex, flagID){
        var flag = this.getFlag(programIndex, flagID);
        if(flag == null) return qsTr("Invalid Flag");
        return qsTr("Flag") + "[" + flag.flagID + "]" + ":" + flag.descr;
    },

    "flagNameList": function(programIndex){
        if(programIndex >= this.flags.length)
            return [];
        var ret = [];
        var pFlags = this.flags[programIndex];
        for(var i = 0; i < pFlags.length; ++i){
            ret.push(qsTr("Flag") + "[" + pFlags[i].flagID + "]" + ":" + pFlags[i].descr);
        }
        return ret;
    }
}

function StackItem(m0pos, m1pos, m2pos, m3pos, m4pos, m5pos,
                   space0, space1, space2, count0, count1, count2,
                   sequence, dir0, dir1, dir2, doesBindingCounter, counterID ,
                   isOffsetEn, offsetX, offsetY, offsetZ, dataSourceName, dataSourceID){
    this.m0pos = m0pos || 0;
    this.m1pos = m1pos || 0;
    this.m2pos = m2pos || 0;
    this.m3pos = m3pos || 0;
    this.m4pos = m4pos || 0;
    this.m5pos = m5pos || 0;
    this.space0 = space0 || 0;
    this.space1 = space1 || 0;
    this.space2 = space2 || 0;
    this.count0 = count0 || 0;
    this.count1 = count1 || 0;
    this.count2 = count2 || 0;
    this.sequence = sequence || 0;
    this.dir0 = dir0 || 0;
    this.dir1 = dir1 || 0;
    this.dir2 = dir2 || 0;
    this.doesBindingCounter = doesBindingCounter || 0;
    this.counterID = counterID || 0;
    this.isOffsetEn = isOffsetEn || false;
    this.offsetX = offsetX || 0;
    this.offsetY = offsetY || 0;
    this.offsetZ = offsetZ || 0;
    this.dataSourceName = dataSourceName || "";
    this.dataSourceID = dataSourceID || -1;
}

function StackInfo(si0, si1, type, descr, dsName, dsHostID, posData){
    this.si0 = si0;
    this.si1 = si1;
    this.type = type || 0;
    this.descr = descr;
    this.dsName = dsName || "";
    this.dsHostID = dsHostID>=0?dsHostID:-1;
    this.posData = posData || [];
}


var stackIDs = [];
var stackInfos = [];

function appendStackInfo(stackInfo){
    var id = useableStack();
    pushStack(id, stackInfo);
    return id;
}

function updateStackInfo(which, stackInfo){
    for(var i = 0; i < stackIDs.length; ++i){
        if(stackIDs[i] == which){
            stackInfos[i] = stackInfo;
            break;
        }
    }
    return which;
}

function getStackInfoFromID(stackID){
    for(var i = 0; i < stackIDs.length; ++i){
        if(stackIDs[i] == stackID){
            return stackInfos[i];
        }
    }
    return null;
}

var pushStack = function(stack, info){
    for(var i = 0; i < stackIDs.length; ++i){
        if(stack < stackIDs[i]){
            stackIDs.splice(i, 0, stack);
            stackInfos.splice(i, 0, info);
            return;
        }
    }
    stackIDs.push(stack);
    stackInfos.push(info);
    return;
}

var delStack = function(stack){
    for(var i = 0; i < stackIDs.length; ++i){
        if(stack === stackIDs[i]){
            stackIDs.splice(i, 1);
            stackInfos.splice(i, 1);
            break;
        }
    }
    return stack;
}

var useableStack = function(){
    if(stackIDs.length === 0) return 0;
    //    if(stackIDs.length < 3)
    //        return stackIDs[stackIDs.length - 1] + 1;
    if(stackIDs[0] !== 0) return 0;
    for(var i = 1; i < stackIDs.length; ++i){
        if(stackIDs[i] - stackIDs[i - 1] > 1){
            return stackIDs[i - 1] + 1;
        }
    }
    return stackIDs[i - 1] + 1;
}

function parseStacks(stacks){
    if(stacks.length < 4) {
        stacks = "{}";
    }
    console.log("Teach.js.parseStacks", stacks);
    var statckInfos = JSON.parse(stacks);
    stackIDs.length = 0;
    stackInfos.length = 0;
    for(var s in statckInfos){
        pushStack(parseInt(s), statckInfos[s]);
    }
}


function statcksToJSON(){
    var ret = {};
    for(var i = 0; i < stackIDs.length; ++i){
        ret[stackIDs[i].toString()] = stackInfos[i];
    }
    return JSON.stringify(ret);
}

function stackInfosDescr(){
    var ret = [];
    for(var i = 0; i < stackIDs.length; ++i){
        ret.push(qsTr("Stack") + "[" + stackIDs[i] + "]:" + stackInfos[i].descr);
    }
    return ret;
}

function CounterInfo(id, name, current, target){
    this.id = id || 0;
    this.name = name || "Counter-" + this.id;
    this.current = current || 0;
    this.target = target || 0;
    this.toString = function(){
       return qsTr("Counter") + "[" + this.id + "][T:" + this.target + "][C:" + this.current + "]";

    }
}

function VariableInfo(id, name, unit, val, decimal){
    this.id = id || 0;
    this.name = name || "Variable-" + this.id;
    this.unit = unit || "";
    this.val = val || 0;
    this.decimal = decimal || 0;
    this.toString = function(){
       return this.name;

    }
}

function VariableManager(){
    this.variables = [];
    this.init = function(bareVariables){
        this.variables.length = 0;
        for(var c in bareVariables){
            var variable = bareVariables[c];
            this.push(new VariableInfo(variable[0], variable[1], variable[2], variable[3], variable[4]));
        }
    }
    this.push = function(variable){
        for(var i = 0; i < this.variables.length; ++i){
            if(variable.id < this.variables[i].id){
                this.variables.splice(i, 0, variable);
                return i;
            }
        }
        this.variables.push(variable);
        return i;
    }

    this.usableID = function(){
        var cs = this.variables;
        if(cs.length === 0) return 0;
        if(cs[0].id != 0) return 0;
        for(var i = 1; i < cs.length; ++i){
            if(cs[i].id - cs[i - 1].id > 1){
                return cs[i - 1].id + 1;
            }
        }
        return cs[i - 1].id + 1;
    }

    this.getVariable = function(id){
        for(var c in this.variables){
            if(this.variables[c].id == id)
                return this.variables[c];
        }
        return null;
    }
    this.variableToString = function(id){
        var cs = this.getVariable(id);
        if(cs == null) return "Invalid Variable";
        return cs.toString();
    }

    this.variablesStrList = function(){
        var ret = [];
        for(var i = 0; i < this.variables.length; ++i){
            ret.push(this.variables[i].toString() + ":" + this.variables[i].name);
        }
        return ret;
    }

    this.newVariable = function(name, unit, val, decimal){
        var newID = this.usableID();
        var toAdd = new VariableInfo(newID, name, unit, val, decimal);
        this.push(toAdd);

        return toAdd;
    }
    this.updateVariable = function(id, name, unit, val, decimal){
        var c = this.getVariable(id);
        c.name = name;
        c.unit = unit;
        c.val = val;
        c.decimal = decimal
    }
    this.delVariable = function(id){
        for(var c in this.variables){
            if(this.variables[c].id == id){
                this.variables.splice(c, 1);
                break;
            }
        }
    }
}


function CounterManager(){
    this.counters = [];
    this.init = function(bareCounters){
        this.counters.length = 0;
        for(var c in bareCounters){
            var counter = bareCounters[c];
            this.push(new CounterInfo(counter[0], counter[1], counter[2], counter[3]));
        }
    }

    this.push = function(counter){
        for(var i = 0; i < this.counters.length; ++i){
            if(counter.id < this.counters[i].id){
                this.counters.splice(i, 0, counter);
                return i
            }
        }
        this.counters.push(counter);
        return i;
    }

    this.usableID = function(){
        var cs = this.counters;
        if(cs.length === 0) return 0;
        if(cs[0].id != 0) return 0;
        for(var i = 1; i < cs.length; ++i){
            if(cs[i].id - cs[i - 1].id > 1){
                return cs[i - 1].id + 1;
            }
        }
        return cs[i - 1].id + 1;
    }

    this.getCounter = function(id){
        for(var c in this.counters){
            if(this.counters[c].id == id)
                return this.counters[c];
        }
        return null;
    }
    this.counterToString = function(id){
        var cs = this.getCounter(id);
        if(cs == null) return "Invalid Counter";
        return cs.toString();
    }

    this.countersStrList = function(){
        var ret = [];
        for(var i = 0; i < this.counters.length; ++i){
            ret.push(this.counters[i].toString() + ":" + this.counters[i].name);
        }
        return ret;
    }

    this.newCounter = function(name, current, target){
        var newID = this.usableID();
        var toAdd = new CounterInfo(newID, name, current, target);
        this.push(toAdd);
        return toAdd;
    }
    this.updateCounter = function(id, name, current, target){
        var c = this.getCounter(id);
        c.name = name;
        c.current = current;
        c.target = target;
    }
    this.delCounter = function(id){
        for(var c in this.counters){
            if(this.counters[c].id == id){
                this.counters.splice(c, 1);
                break;
            }
        }
    }
}

function FunctionInfo(id, name, program){
    this.id = id;
    this.name = name || ("Fun" + id);
    this.program = program || [{"action":actions.F_CMD_PROGRAM_CALL_BACK}];

    definedPoints.parseProgram(this.program);

    this.toString = function(){
        return qsTr("Fun") + "[" + id + "]:" + this.name;
    }
}

function FunctionManager(){
    this.functions = [];
    this.init = function(functionsJSON){
        this.functions.length = 0;
        if(functionsJSON.length == 0){
            return;
        }
        var functinos = JSON.parse(functionsJSON);
        var i;
        for(i = 0; i < functinos.length; ++i){
            this.push(new FunctionInfo(functinos[i].id, functinos[i].name, JSON.parse(functinos[i].program)));
        }

    }
    this.toJSON = function(){
        var ret = [];
        var fun;
        for(var i = 0; i < this.functions.length; ++i){
            fun = this.functions[i];
            ret.push({"id":fun.id, "name":fun.name, "program":JSON.stringify(fun.program)});
        }

        return JSON.stringify(ret);
    }

    this.push = function(fun){
        for(var i = 0; i < this.functions.length; ++i){
            if(fun.id < this.functions[i].id){
                this.functions.splice(i, 0, fun);
                return i
            }
        }
        this.functions.push(fun);
        return i;
    }

    this.usableID = function(){
        var cs = this.functions;
        if(cs.length === 0) return 0;
        if(cs[0].id != 0) return 0;
        for(var i = 1; i < cs.length; ++i){
            if(cs[i].id - cs[i - 1].id > 1){
                return cs[i - 1].id + 1;
            }
        }
        return cs[i - 1].id + 1;
    }

    this.getFunction = function(id){
        for(var c in this.functions){
            if(this.functions[c].id == id)
                return this.functions[c];
        }
        return null;
    }
    this.getFunctionByName = function(name){
        var id = getValueFromBrackets(name);
        return this.getFunction(id);
    }

    this.functionToString = function(id){
        var cs = this.getFunction(id);
        if(cs == null) return "Invalid Variable";
        return qsTr("Fun") + "[" + id + "]:" + cs.name;
    }

    this.functionsStrList = function(){
        var ret = [];
        for(var i = 0; i < this.functions.length; ++i){
            ret.push(this.functions[i].toString());
        }
        return ret;
    }

    this.newFunction = function(name, program){
        var newID = this.usableID();
        var toAdd = new FunctionInfo(newID, name, program)
        this.push(toAdd);
        return toAdd;
    }
    this.updateFunction = function(id, name, program){
        var c = this.getFunction(id);
        c.name = name || ("Fun" + id);
        c.program = program || [{"action":actions.F_CMD_PROGRAM_CALL_BACK}];
    }
    this.delFunction = function(id){
        for(var c in this.functions){
            if(this.functions[c].id == id){
                this.functions.splice(c, 1);
                break;
            }
        }
    }
}

var counterManager = new CounterManager();

var variableManager = new VariableManager();

var functionManager = new FunctionManager();

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

var VALVE_CHECK_START = 10;
var VALVE_CHECK_END = 9;
actions.F_CMD_NULL = actHelper++;
actions.F_CMD_SYNC_START = actHelper++;
actions.F_CMD_SYNC_END = actHelper++;
actions.F_CMD_SINGLE = actHelper++;
actions.F_CMD_JOINTCOORDINATE = actHelper++;
actions.F_CMD_COORDINATE_DEVIATION = actHelper++;
actions.F_CMD_LINE2D_MOVE_POINT = actHelper++;
actions.F_CMD_LINEXY_MOVE_POINT = actions.F_CMD_LINE2D_MOVE_POINT + 52000;
actions.F_CMD_LINEXZ_MOVE_POINT = actions.F_CMD_LINE2D_MOVE_POINT + 52001;
actions.F_CMD_LINEYZ_MOVE_POINT = actions.F_CMD_LINE2D_MOVE_POINT + 52002;
actions.F_CMD_LINE3D_MOVE_POINT = actHelper++;
actions.F_CMD_ARC3D_MOVE_POINT = actHelper++;   //< 按点位弧线运动 目标坐标（X，Y，Z）经过点（X，Y，Z） 速度  延时
actions.F_CMD_ARCXY_MOVE_POINT = actions.F_CMD_ARC3D_MOVE_POINT + 51000
actions.F_CMD_ARCXZ_MOVE_POINT = actions.F_CMD_ARC3D_MOVE_POINT + 51001
actions.F_CMD_ARCYZ_MOVE_POINT = actions.F_CMD_ARC3D_MOVE_POINT + 51002
actions.F_CMD_MOVE_POSE = actHelper++;
actions.F_CMD_LINE3D_MOVE_POSE = actHelper++;
actions.F_CMD_JOINT_RELATIVE = actHelper++;  //< 关节坐标偏移位置（X，Y，Z,U,V,W） 速度  延时
actions.F_CMD_ARC3D_MOVE = actHelper++;   //< 整圆运动 目标坐标（X，Y，Z）经过点（X，Y，Z） 速度  延时

actions.F_CMD_IO_INPUT = 100;   //< IO点输入等待 IO点 等待 等待时间
actions.F_CMD_WATIT_VISION_DATA = 101;
actions.F_CMD_IO_OUTPUT = 200;   //< IO点输出 IO点 输出状态 输出延时
actions.F_CMD_STACK0 = 300;
actions.F_CMD_COUNTER = 400; //< 计数器
actions.F_CMD_COUNTER_CLEAR = 401;
actions.F_CMD_TEACH_ALARM = 500;
actions.F_CMD_VISION_CATCH = 501;

actions.F_CMD_PROGRAM_JUMP0 = 10000;
actions.F_CMD_PROGRAM_JUMP1 = 10001;
actions.F_CMD_PROGRAM_JUMP2 = 10002;  //< 计数器跳转 跳转步号 计数器ID 清零操作（0：不自动清零；1：到达计数时候自动清零）
actions.F_CMD_PROGRAM_CALL0 = 20000;   //< 程序调用 调用步号  返回步号
actions.F_CMD_PROGRAM_CALL_BACK = 20001;   //< 程序调用
actions.F_CMD_FINE_ZERO = 30000;//<  教导寻找原点： 轴ID 类型 速度 延时
actions.ACT_END        = 60000;
actions.ACT_COMMENT    = 50000;
actions.ACT_OUTPUT     = 0x80;
actions.ACT_SYNC_BEGIN = 126;
actions.ACT_SYNC_END   = 127;
actions.ACT_GROUP_END  = 125;
actions.ACT_FLAG       = 59999;

var kCCErr_Invalid = 1;
var kCCErr_Sync_Nesting = 2;
var kCCErr_Sync_NoBegin = 3;
var kCCErr_Sync_NoEnd = 4;
var kCCErr_Group_Nesting = 5;
var kCCErr_Group_NoBegin = 6;
var kCCErr_Group_NoEnd = 7;
var kCCErr_Last_Is_Not_End_Action = 8;
var kCCErr_Invaild_Program_Index = 9;
var kCCErr_Wrong_Action_Format = 10;
var kCCErr_Invaild_Flag = 11;
var kCCErr_Invaild_StackID = 12;
var kCCErr_Invaild_CounterID = 13;
var kCCErr_Invaild_ModuleID = 14;


var kAxisType_NoUse = 0;
var kAxisType_Servo = 1;
var kAxisType_Pneumatic = 2;
var kAxisType_Reserve = 3;

function isJumpAction(act){
    return act === actions.F_CMD_PROGRAM_JUMP0 ||
            act === actions.F_CMD_PROGRAM_JUMP1 ||
            act === actions.F_CMD_PROGRAM_JUMP3 ||
            act === actions.F_CMD_PROGRAM_CALL0;

}

function hasCounterIDAction(action){
    if(action.action == actions.F_CMD_STACK0){
        var si = getStackInfoFromID(action.stackID);
        if(si != null)
            return si.si0.doesBindingCounter || si.si1.doesBindingCounter;
    }

    return action.hasOwnProperty("counterID");
}

function hasStackIDAction(action){
    return action.hasOwnProperty("stackID");
}

function actionCounterIDs(action){
    if(action.action == actions.F_CMD_STACK0){
        var si = getStackInfoFromID(action.stackID);
        return [si.si0.counterID, si.si1.counterID];
    }
    return [action.counterID];
}

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

var generateOriginAction = function(action,
                                    axis,
                                    type,
                                    speed,
                                    delay
                                  ){

    return {
        "action":action,
        "axis":axis,
        "originType":type,
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

var generateOutputAction = function(point, type, status, valveID, time){
    var ret =
            {
        "action":actions.F_CMD_IO_OUTPUT,
        "type":type,
        "point":point,
        "pointStatus": status,
        "valveID":valveID || -1
    };
    if(type >= TIMEY_BOARD_START){
        ret.acTime = time || 0;
    }else{
        ret.delay = time || 0;
    }
    return ret;
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

var generateCheckAction = function(point, type, delay){
    return {
        "action":actions.F_CMD_IO_OUTPUT,
        "type":type,
        "point":point,
        "delay":delay
    };
}

var generateConditionAction = function(type, point, inout, status, limit, flag){
    return {
        "action":actions.F_CMD_PROGRAM_JUMP1,
        "type":type,
        "point":point,
        "pointStatus":status,
        "inout":inout || 0,
        "limit":limit || 0.50,
        "flag": flag || 0,
    };
}

var generateJumpAction = function(flag){
    return {
        "action":actions.F_CMD_PROGRAM_JUMP0,
        "flag": flag || 0,
    };
}

var generateCounterJumpAction = function(flag, counterID, status, autoClear){
    return {
        "action":actions.F_CMD_PROGRAM_JUMP2,
        "flag": flag || 0,
        "counterID":counterID,
        "pointStatus":status,
        "autoClear": autoClear || false
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
    var temp;
    if(commentdAction == undefined)temp = undefined;
    else temp = commentdAction.insertedIndex;
    return {
        "action": actions.ACT_COMMENT,
        "comment":comment,
        "insertedIndex": temp,
        "commentAction":commentdAction || null
    };
}

var generateStackAction = function(stackID, speed0, speed1){
    return {
        "action":actions.F_CMD_STACK0,
        "stackID":stackID,
        "speed0":speed0 || 80,
        "speed1":speed1 || 80,
    };
}

var generateCounterAction = function(counterID){
    return {
        "action":actions.F_CMD_COUNTER,
        "counterID":counterID,
    };
}

var generateClearCounterAction = function(counterID){
    return {
        "action":actions.F_CMD_COUNTER_CLEAR,
        "counterID":counterID,
    };
}

var generateCustomAlarmAction = function(alarmNum){
    return {
        "action":actions.F_CMD_TEACH_ALARM,
        "alarmNum":alarmNum
    };
}

var generateCallModuleAction = function(module, flag){
    return {
        "action":actions.F_CMD_PROGRAM_CALL0,
        "flag":flag || -1,
        "module":module
    };
}

var generateVisionCatchAction = function(point, type, status, acTime, dataSourceName){
    return {
        "action": actions.F_CMD_VISION_CATCH,
        "point":point,
        "type":type,
        "pointStatus": status,
        "acTime": acTime,
        "dataSource":dataSourceName
    }
}

var generateWaitVisionDataAction = function(waitTime, dataSourceName, hostID){
    return {
        "action": actions.F_CMD_WATIT_VISION_DATA,
        "limit": waitTime,
        "dataSource":dataSourceName,
        "hostID":hostID
    }
}

var generateInitProgram = function(axisDefine){

    var initStep = [];
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
    console.log("aaaaaa" + actionObject.axis);
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

var originType = [qsTr("Type 1"), qsTr("Type 2"), qsTr("Type 3")]

var f_CMD_FINE_ZEROToStringHandler = function(actionObject){
    var ret =  qsTr("origin") + "-" + axisInfos[actionObject.axis].name + ":" + " " +  originType[actionObject.originType] + " " +
            qsTranslate("Teach","Speed:") + actionObject.speed + " " +
            qsTr("Delay:") + actionObject.delay;
    if(actionObject.isBadEn)
        ret += " " + qsTr("Bad En");
    if(actionObject.isEarlyEnd){
        ret += " " + qsTr("Early End Pos:") + actionObject.earlyEndPos;
    }
    return ret;
}


var otherActionToStringHandler = function(actionObject){

}

var customAlarmActiontoStringHandler = function(actionObject){
    return qsTr("Alarm") + ":" + actionObject.alarmNum + ":" + getCustomAlarmDescr(actionObject.alarmNum);
}

var conditionActionToStringHandler = function(actionObject){
    if(actionObject.action === actions.F_CMD_PROGRAM_JUMP0){
        return qsTr("Jump To ") + flagsDefine.flagName(currentParsingProgram, actionObject.flag);
    }else if(actionObject.action === actions.F_CMD_PROGRAM_JUMP2){
        var c = counterManager.getCounter(actionObject.counterID);
        if(c == null){
            return qsTr("IF:") + qsTr("Invalid Counter");
        }

        return qsTr("IF:") + c.toString() + ":"  + c.name + " " +
                (actionObject.pointStatus == 1 ? qsTr("Arrive") : qsTr("No arrive")) + " " + qsTr("Go to ") + flagsDefine.flagName(currentParsingProgram, actionObject.flag) + "."
                + (actionObject.autoClear ? qsTr("Then clear counter") : "");
    }

    var pointDescr;
    if(actionObject.inout === 1){
        pointDescr = getYDefineFromHWPoint(actionObject.point, actionObject.type).yDefine.descr
    }else
        pointDescr = getXDefineFromHWPoint(actionObject.point, actionObject.type).xDefine.descr


    return qsTr("IF:") + pointDescr +
            (actionObject.pointStatus ? qsTr("ON") : qsTr("OFF")) + " "
            + qsTr("Limit:") + actionObject.limit + " " +
            qsTr("Go to ") + flagsDefine.flagName(currentParsingProgram, actionObject.flag);
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
    return qsTr("Program End");
}

var moduleCallBackActionToStringHandler = function(actionObject){
    return qsTr("Module End");
}

var callModuleActionToStringHandler = function(actionObject){
    var returnTo = (actionObject.flag == - 1 ? qsTr("next line") : flagsDefine.flagName(currentParsingProgram, actionObject.flag));
    return qsTr("Call") + " " + functionManager.functionToString(actionObject.module) + " " +
            qsTr("And then return to ") + returnTo;
}

var commentActionToStringHandler = function(actionObject){
    return actionObject.comment;
}

var flagActionToStringHandler = function(actionObject){
    return qsTr("Flag") + icStrformat("[{0}]", actionObject.flag) + ":"
            + actionObject.comment;
}

var valveTypeToString = [
    qsTr("Normal Y"),
    qsTr("Single Y"),
    qsTr("Hold Double Y"),
    qsTr("Unhold Double Y")];

function valveItemToString(valve){
    var ret = valveTypeToString[valve.type] + "-";
    ret += getYDefineFromHWPoint(valve.y1Point, valve.y1Board).yDefine.pointName;
    if(valve.type === IO_TYPE_HOLD_DOUBLE_Y ||
            valve.type === IO_TYPE_UNHOLD_DOUBLE_Y){
        ret += "," + getYDefineFromHWPoint(valve.y2Point, valve.y2Board).yDefine.pointName;
    }
    return ret +=":" + valve.descr;
}

var outputActionToStringHandler = function(actionObject){
    if((actionObject.valveID >= 0) && (actionObject.type == VALVE_BOARD)){
        var valve = getValveItemFromValveID(actionObject.valveID);
        return valveItemToString(valve)+ (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                + qsTr("Delay:") + actionObject.delay;

    }else if(actionObject.type === VALVE_CHECK_START){
        return qsTr("Check:") + getValveItemFromValveID(actionObject.point).descr + qsTr("Start") + " "
                + qsTr("Delay:") + actionObject.delay;
    }else if(actionObject.type === VALVE_CHECK_END){
        return qsTr("Check:") + getValveItemFromValveID(actionObject.point).descr + qsTr("End") + " "
                + qsTr("Delay:") + actionObject.delay;
    }else{
        if(actionObject.type >= TIMEY_BOARD_START){
            return qsTr("Time Output:") + getYDefineFromHWPoint(actionObject.point, actionObject.type - TIMEY_BOARD_START).yDefine.descr + (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                    + qsTr("Action Time:") + actionObject.acTime;
        }else{

            return qsTr("Output:") + getYDefineFromHWPoint(actionObject.point, actionObject.type).yDefine.descr + (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                    + qsTr("Delay:") + actionObject.delay;
        }
    }
}

var syncBeginActionToStringHandler = function(actionObject){
    return qsTr("Sync Begin");
}

var syncEndActionToStringHandler = function(actionObject){
    return qsTr("Sync End");
}

function stackTypeToString(type){
    switch(type){
    case stackTypes.kST_Box:
        return qsTr("Box");
    default:
        return "";
    }
}

var stackActionToStringHandler = function(actionObject){
    var si = getStackInfoFromID(actionObject.stackID);
    var descr = (si == null) ? qsTr("not exist") : si.descr;
    var isBoxStack = si.type == stackTypes.kST_Box;
    var spee1 = isBoxStack ? (qsTr("Speed1:") + actionObject.speed1):
                                                          "";
    var counterID1 = si.si0.doesBindingCounter ? counterManager.counterToString(si.si0.counterID) : qsTr("Counter:Self");
    var counterID2 = isBoxStack ? (si.si1.doesBindingCounter ? counterManager.counterToString(si.si1.counterID) : qsTr("Counter:Self"))
                                                             : "";
    return stackTypeToString(si.type) + qsTr("Stack") + "[" + actionObject.stackID + "]:" +
            descr + " " +
            (isBoxStack ? qsTr("Speed0:"): qsTr("Speed:")) + actionObject.speed0 + " " + spee1 + " " + counterID1 + " " + counterID2;
}

var counterActionToStringHandler = function(actionObject){
    console.log("counterActionToStringHandler", actionObject.counterID);
    var c = counterManager.getCounter(actionObject.counterID);
    var clearStr = actionObject.action == actions.F_CMD_COUNTER_CLEAR ? qsTr("Clear ") : qsTr("Plus 1");
    return clearStr + c.toString() + ":" + c.name;
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
    var needNewLine = false;
    if(actionObject.action === actions.F_CMD_LINEXY_MOVE_POINT){
        ret += qsTr("LineXY:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_LINEXZ_MOVE_POINT){
        ret += qsTr("LineXZ:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_LINEYZ_MOVE_POINT){
        ret += qsTr("LineYZ:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_LINE3D_MOVE_POINT){
        ret += qsTr("Line3D:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_ARC3D_MOVE_POINT){
        ret += qsTr("Arc3D:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_MOVE_POSE){
        ret += qsTr("Pose:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_LINE3D_MOVE_POSE){
        ret += qsTr("Line3D-Pose:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_JOINTCOORDINATE){
        ret += qsTr("Free Path:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_COORDINATE_DEVIATION){
        ret += qsTr("Offset Line:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_JOINT_RELATIVE){
        ret += qsTr("Offset Jog:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_ARC3D_MOVE){
        ret += qsTr("Circle:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_ARCXY_MOVE_POINT){
        ret += qsTr("ArcXY:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_ARCXZ_MOVE_POINT){
        ret += qsTr("ArcXZ:");
        needNewLine = true;
    }else if(actionObject.action === actions.F_CMD_ARCYZ_MOVE_POINT){
        ret += qsTr("ArcYZ:");
        needNewLine = true;
    }

    var points = actionObject.points;
    if(points.length > 0)
        ret += qsTr("Next:") + pointToString(points[0]) + " ";
    if(points.length > 1){
        ret += "\n                            ";
        ret += qsTr("End:") + pointToString(points[points.length - 1]) + " ";
    }
    if(needNewLine)
        ret += "\n                            ";
    ret += qsTr("Speed:") + actionObject.speed + " ";
    ret += qsTr("Delay:") + actionObject.delay;
    return ret;
}

var visionCatchActionToStringHandler = function(actionObject){
    var isCommunicate = actionObject.point < 0;
    var detailStr = "";
    if(!isCommunicate){
        detailStr += qsTr("Time Output:") + getYDefineFromHWPoint(actionObject.point, actionObject.type - TIMEY_BOARD_START).yDefine.descr + (actionObject.pointStatus ? qsTr("ON") :qsTr("OFF")) + " "
                + qsTr("Action Time:") + actionObject.acTime;
    }

    return qsTr("Vistion Catch Start:") + qsTr("Data Source:") + actionObject.dataSource + "\n                            "
            + qsTr("Catch Type:") + (isCommunicate ? qsTr("Communicate") : qsTr("O Point")) + " " + detailStr;
}

var waitVisionDataActionToStringHandler = function(actionObject){
    return qsTr("Wait Vision Data") + " " + qsTr("Data Source:") + actionObject.dataSource + "\n                            "
    + qsTr("Limit:") + actionObject.limit;
}



var actionToStringHandlerMap = new HashTable();
actionToStringHandlerMap.put(actions.F_CMD_SINGLE, f_CMD_SINGLEToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_FINE_ZERO, f_CMD_FINE_ZEROToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_LINEXY_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_LINEXZ_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_LINEYZ_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_LINE3D_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_ARC3D_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_ARCXY_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_ARCXZ_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_ARCYZ_MOVE_POINT, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_ARC3D_MOVE, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_MOVE_POSE, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_LINE3D_MOVE_POSE, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_JOINTCOORDINATE, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_COORDINATE_DEVIATION, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_JOINT_RELATIVE, pathActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_TEACH_ALARM, customAlarmActiontoStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_PROGRAM_JUMP0, conditionActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_PROGRAM_JUMP1, conditionActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_PROGRAM_JUMP2, conditionActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_IO_INPUT, waitActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_END, endActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_PROGRAM_CALL_BACK, moduleCallBackActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_PROGRAM_CALL0, callModuleActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_COMMENT, commentActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_IO_OUTPUT, outputActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_SYNC_START, syncBeginActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_SYNC_END, syncEndActionToStringHandler);
actionToStringHandlerMap.put(actions.ACT_FLAG, flagActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_STACK0, stackActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_COUNTER, counterActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_COUNTER_CLEAR, counterActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_VISION_CATCH, visionCatchActionToStringHandler);
actionToStringHandlerMap.put(actions.F_CMD_WATIT_VISION_DATA, waitVisionDataActionToStringHandler);

var actionObjectToEditableITems = function(actionObject){
    var ret = [];
    if(actionObject.action === actions.F_CMD_SINGLE){
        ret = [{"item":"pos", "range":motorRangeAddr(actionObject.axis)},
                {"item":"speed", "range":"s_rw_0_32_1_1200"},
                {"item":"delay", "range":"s_rw_0_32_2_1100"}];
    }else if(actionObject.action === actions.F_CMD_LINEXY_MOVE_POINT ||
             actionObject.action === actions.F_CMD_LINEXZ_MOVE_POINT ||
             actionObject.action === actions.F_CMD_LINEYZ_MOVE_POINT ||
             actionObject.action === actions.F_CMD_LINE3D_MOVE_POINT ||
             actionObject.action === actions.F_CMD_ARC3D_MOVE_POINT ||
             actionObject.action === actions.F_CMD_ARCXY_MOVE_POINT ||
             actionObject.action === actions.F_CMD_ARCXZ_MOVE_POINT ||
             actionObject.action === actions.F_CMD_ARCYZ_MOVE_POINT ||
             actionObject.action === actions.F_CMD_ARC3D_MOVE ||
             actionObject.action === actions.F_CMD_MOVE_POSE ||
             actionObject.action === actions.F_CMD_LINE3D_MOVE_POSE ||
             actionObject.action === actions.F_CMD_JOINTCOORDINATE ||
             actionObject.action === actions.F_CMD_COORDINATE_DEVIATION ||
             actionObject.action === actions.F_CMD_JOINT_RELATIVE){
        ret = [
                    {"item":"points"},
                    {"item":"speed", "range":"s_rw_0_32_1_1200"},
                    {"item":"delay", "range":"s_rw_0_32_2_1100"}
                ];
    }else if(actionObject.action === actions.F_CMD_IO_OUTPUT){
        if(actionObject.type >= TIMEY_BOARD_START)
            ret =  [{"item":"acTime", "range":"s_rw_0_32_1_1201"}];
        else
            ret = [{"item":"delay", "range":"s_rw_0_32_1_1201"}];
    }else if(actionObject.action === actions.F_CMD_IO_INPUT ||
             actionObject.action === actions.F_CMD_PROGRAM_JUMP1){
        ret = [{"item":"limit", "range":"s_rw_0_32_1_1201"}];
    }else if(actionObject.action === actions.F_CMD_STACK0){
        ret = [{"item":"speed0", "range":"s_rw_0_32_1_1200"},
                {"item":"speed1", "range":"s_rw_0_32_1_1200"}];
    }else if(actionObject.action === actions.F_CMD_FINE_ZERO){
        ret = [{"item":"speed", "range":"s_rw_0_32_1_1200"},
                {"item":"delay", "range":"s_rw_0_32_2_1100"}];
    }else if(actionObject.action === actions.F_CMD_VISION_CATCH){
        ret =  [{"item":"acTime", "range":"s_rw_0_32_1_1201"}];
    }else if(actionObject.action === actions.F_CMD_WATIT_VISION_DATA){
        ret = [{"item":"delay", "range":"s_rw_0_32_1_1201"}];
    }

    ret.push({"item":"customName"});
    return ret;
}

var actionToStringNoCusomName= function(actionObject){
    var  toStrHandler = actionToStringHandlerMap.get(actionObject.action);
    if(toStrHandler === undefined) {console.log(actionObject.action)}
    return toStrHandler(actionObject);
}

var actionToString = function(actionObject){
    var customName = actionObject.customName || "";
    return customName + " " + actionToStringNoCusomName(actionObject);
}

function ProgramModelItem(actionObject, at){
    this.mI_ActionObject = actionObject;
    this.mI_IsActionRunning = false;
    this.mI_ActionType = at;
    this.actionText = "";
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
    case kCCErr_Invaild_Program_Index:
        return qsTr("Invalid program index");
    case kCCErr_Wrong_Action_Format:
        return qsTr("Wrong action format");
    case kCCErr_Invaild_Flag:
        return qsTr("Invalid jump flag");
    case kCCErr_Invaild_StackID:
        return qsTr("Invalid stack");
    case kCCErr_Invaild_CounterID:
        return qsTr("Invalid counter");
    case kCCErr_Invaild_ModuleID:
        return qsTr("Invaild Moldule");
    }
    return qsTr("Unknow Error");
}


var canActionUsePoint = function(actionObject){
    return actionObject.action === actions.F_CMD_SINGLE ||
            actionObject.action === actions.F_CMD_CoordinatePoint ||
            actionObject.action === actions.F_CMD_COORDINATE_DEVIATION ||
            actionObject.action === actions.F_CMD_LINEXY_MOVE_POINT ||
            actionObject.action === actions.F_CMD_LINEXZ_MOVE_POINT ||
            actionObject.action === actions.F_CMD_LINEYZ_MOVE_POINT ||
            actionObject.action === actions.F_CMD_LINE3D_MOVE_POINT ||
            actionObject.action === actions.F_CMD_ARC3D_MOVE_POINT ||
            actionObject.action === actions.F_CMD_MOVE_POSE ||
            actionObject.action === actions.F_CMD_LINE3D_MOVE_POSE ||
            actionObject.action === actions.F_CMD_ARC3D_MOVE ||
            actionObject.action === actions.F_CMD_JOINTCOORDINATE ||
            actionObject.action === actions.F_CMD_ARCXY_MOVE_POINT ||
            actionObject.action === actions.F_CMD_ARCXZ_MOVE_POINT ||
            actionObject.action === actions.F_CMD_ARCYZ_MOVE_POINT;
}

var canActionTestRun = function(actionObject){
    return  actionObject.action === actions.F_CMD_CoordinatePoint ||
            actionObject.action === actions.F_CMD_COORDINATE_DEVIATION ||
            actionObject.action === actions.F_CMD_LINE3D_MOVE_POINT ||
            actionObject.action === actions.F_CMD_ARC3D_MOVE_POINT ||
            actionObject.action === actions.F_CMD_ARC3D_MOVE ||
            actionObject.action === actions.F_CMD_JOINTCOORDINATE ||
            actionObject.action === actions.F_CMD_JOINT_RELATIVE;
}


var currentParsingProgram = 0;
