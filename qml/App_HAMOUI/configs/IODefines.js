.pragma library

var IO_TYPE_INPUT  = 0;
var IO_TYPE_OUTPUT = 1;

var IO_BOARD_0 = 0;
var IO_BOARD_1 = 1;
var IO_BOARD_2 = 2;
var IO_BOARD_3 = 3;

var M_BOARD_0 = 4;
var M_BOARD_1 = 5;
var M_BOARD_2 = 6;

var EUIO_BOARD = 7;
var VALVE_BOARD = 8;

var IO_TYPE_NORMAL_Y = 0;
var IO_TYPE_SINGLE_Y = 1;
var IO_TYPE_HOLD_DOUBLE_Y = 2;
var IO_TYPE_UNHOLD_DOUBLE_Y = 3;

var IO_DIR_PP = 1;
var IO_DIR_RP = 0;

var IOItem = function(pointName, descr)
{
    this.pointName = pointName;
    this.descr = descr;
}

function ValveItem(id, descr, type, time,
                   y1Board, y1Point, x1Board, x1Point, x1Dir,
                   y2Board, y2Point, x2Board, x2Point, x2Dir
                   ){
    this.id = id;
    this.descr = descr;
    this.type = type;
    this.y1Board = y1Board;
    this.y1Point = y1Point;
    this.y2Board = y2Board || 0;
    this.y2Point = y2Point || 0;
    this.x1Board = x1Board || 0;
    this.x1Point = x1Point || 0;
    this.x2Board = x2Board || 0;
    this.x2Point = x2Point || 0;
    this.x1Dir = x1Dir || 0;
    this.x2Dir = x2Dir || 0;
    this.time = time || 0.5;
}

function yInit(){
    return  [
                new IOItem("Y010", qsTr("Y010")),
                new IOItem("Y011", qsTr("Y011")),
                new IOItem("Y012", qsTr("Y012")),
                new IOItem("Y013", qsTr("Y013")),
                new IOItem("Y014", qsTr("Y014")),
                new IOItem("Y015", qsTr("Y015")),
                new IOItem("Y016", qsTr("Y016")),
                new IOItem("Y017", qsTr("Y017")),
                new IOItem("Y020", qsTr("Y020")),
                new IOItem("Y021", qsTr("Y021")),
                new IOItem("Y022", qsTr("Y022")),
                new IOItem("Y023", qsTr("Y023")),
                new IOItem("Y024", qsTr("Y024")),
                new IOItem("Y025", qsTr("Y025")),
                new IOItem("Y026", qsTr("Y026")),
                new IOItem("Y027", qsTr("Y027")),
                new IOItem("Y030", qsTr("Y030")),
                new IOItem("Y031", qsTr("Y031")),
                new IOItem("Y032", qsTr("Y032")),
                new IOItem("Y033", qsTr("Y033")),
                new IOItem("Y034", qsTr("Y034")),
                new IOItem("Y035", qsTr("Y035")),
                new IOItem("Y036", qsTr("Y036")),
                new IOItem("Y037", qsTr("Y037")),
                new IOItem("Y040", qsTr("Y040")),
                new IOItem("Y041", qsTr("Y041")),
                new IOItem("Y042", qsTr("Y042")),
                new IOItem("Y043", qsTr("Y043")),
                new IOItem("Y044", qsTr("Y044")),
                new IOItem("Y045", qsTr("Y045")),
                new IOItem("Y046", qsTr("Y046")),
                new IOItem("Y047", qsTr("Y047"))
            ];
}

var yDefines = yInit();

function xInit(){
    return [
                new IOItem("X010", qsTr("X010")),
                new IOItem("X011", qsTr("X011")),
                new IOItem("X012", qsTr("X012")),
                new IOItem("X013", qsTr("X013")),
                new IOItem("X014", qsTr("X014")),
                new IOItem("X015", qsTr("X015")),
                new IOItem("X016", qsTr("X016")),
                new IOItem("X017", qsTr("X017")),
                new IOItem("X020", qsTr("X020")),
                new IOItem("X021", qsTr("X021")),
                new IOItem("X022", qsTr("X022")),
                new IOItem("X023", qsTr("X023")),
                new IOItem("X024", qsTr("X024")),
                new IOItem("X025", qsTr("X025")),
                new IOItem("X026", qsTr("X026")),
                new IOItem("X027", qsTr("X027")),
                new IOItem("X030", qsTr("X030")),
                new IOItem("X031", qsTr("X031")),
                new IOItem("X032", qsTr("X032")),
                new IOItem("X033", qsTr("X033")),
                new IOItem("X034", qsTr("X034")),
                new IOItem("X035", qsTr("X035")),
                new IOItem("X036", qsTr("X036")),
                new IOItem("X037", qsTr("X037")),
                new IOItem("X040", qsTr("X040")),
                new IOItem("X041", qsTr("X041")),
                new IOItem("X042", qsTr("X042")),
                new IOItem("X043", qsTr("X043")),
                new IOItem("X044", qsTr("X044")),
                new IOItem("X045", qsTr("X045")),
                new IOItem("X046", qsTr("X046")),
                new IOItem("X047", qsTr("X047")),
                new IOItem("X050", qsTr("X050")),
                new IOItem("X051", qsTr("X051")),
                new IOItem("X052", qsTr("X052")),
                new IOItem("X053", qsTr("X053")),
                new IOItem("X054", qsTr("X054")),
                new IOItem("X055", qsTr("X055")),
                new IOItem("X056", qsTr("X056")),
                new IOItem("X057", qsTr("X057")),
            ];
}

var xDefines = xInit();

function euXInit(){
    return [
                new IOItem("EuX010", qsTr("EuX010")),
                new IOItem("EuX011", qsTr("EuX011")),
                new IOItem("EuX012", qsTr("EuX012")),
                new IOItem("EuX013", qsTr("EuX013")),
                new IOItem("EuX014", qsTr("EuX014")),
                new IOItem("EuX015", qsTr("EuX015")),
                new IOItem("EuX016", qsTr("EuX016")),
                new IOItem("EuX017", qsTr("EuX017")),
                new IOItem("EuX020", qsTr("EuX020")),
                new IOItem("EuX021", qsTr("EuX021")),
                new IOItem("EuX022", qsTr("EuX022")),
                new IOItem("EuX023", qsTr("EuX023")),
                new IOItem("EuX024", qsTr("EuX024")),
                new IOItem("EuX025", qsTr("EuX025")),
                new IOItem("EuX026", qsTr("EuX026")),
                new IOItem("EuX027", qsTr("EuX027")),
            ];
}

var euxDefines = euXInit();


function euYInit(){
    return [
                new IOItem("EuY010", qsTr("EuY010")),
                new IOItem("EuY011", qsTr("EuY011")),
                new IOItem("EuY012", qsTr("EuY012")),
                new IOItem("EuY013", qsTr("EuY013")),
                new IOItem("EuY014", qsTr("EuY014")),
                new IOItem("EuY015", qsTr("EuY015")),
                new IOItem("EuY016", qsTr("EuY016")),
                new IOItem("EuY017", qsTr("EuY017")),
                new IOItem("EuY020", qsTr("EuY020")),
                new IOItem("EuY021", qsTr("EuY021")),
                new IOItem("EuY022", qsTr("EuY022")),
                new IOItem("EuY023", qsTr("EuY023")),
                new IOItem("EuY024", qsTr("EuY024")),
                new IOItem("EuY025", qsTr("EuY025")),
                new IOItem("EuY026", qsTr("EuY026")),
                new IOItem("EuY027", qsTr("EuY027")),
            ];
}

var euyDefines = euYInit();

function mXInit(){
    return  [
                new IOItem("INX010", qsTr("INX010")),
                new IOItem("INX011", qsTr("INX011")),
                new IOItem("INX012", qsTr("INX012")),
                new IOItem("INX013", qsTr("INX013")),
                new IOItem("INX014", qsTr("INX014")),
                new IOItem("INX015", qsTr("INX015")),
                new IOItem("INX016", qsTr("INX016")),
                new IOItem("INX017", qsTr("INX017")),
                new IOItem("INX020", qsTr("INX020")),
                new IOItem("INX021", qsTr("INX021")),
                new IOItem("INX022", qsTr("INX022")),
                new IOItem("INX023", qsTr("INX023")),
                new IOItem("INX024", qsTr("INX024")),
                new IOItem("INX025", qsTr("INX025")),
                new IOItem("INX026", qsTr("INX026")),
                new IOItem("INX027", qsTr("INX027")),
                new IOItem("INX030", qsTr("INX030")),
                new IOItem("INX031", qsTr("INX031")),
                new IOItem("INX032", qsTr("INX032")),
                new IOItem("INX033", qsTr("INX033")),
                new IOItem("INX034", qsTr("INX034")),
                new IOItem("INX035", qsTr("INX035")),
                new IOItem("INX036", qsTr("INX036")),
                new IOItem("INX037", qsTr("INX037")),
                new IOItem("INX040", qsTr("INX040")),
                new IOItem("INX041", qsTr("INX041")),
                new IOItem("INX042", qsTr("INX042")),
                new IOItem("INX043", qsTr("INX043")),
                new IOItem("INX044", qsTr("INX044")),
                new IOItem("INX045", qsTr("INX045")),
                new IOItem("INX046", qsTr("INX046")),
                new IOItem("INX047", qsTr("INX047")),
            ];
}

var mXDefines = mXInit();

function mYInit(){
    return  [
                new IOItem("INY010", qsTr("INY010")),
                new IOItem("INY011", qsTr("INY011")),
                new IOItem("INY012", qsTr("INY012")),
                new IOItem("INY013", qsTr("INY013")),
                new IOItem("INY014", qsTr("INY014")),
                new IOItem("INY015", qsTr("INY015")),
                new IOItem("INY016", qsTr("INY016")),
                new IOItem("INY017", qsTr("INY017")),
                new IOItem("INY020", qsTr("INY020")),
                new IOItem("INY021", qsTr("INY021")),
                new IOItem("INY022", qsTr("INY022")),
                new IOItem("INY023", qsTr("INY023")),
                new IOItem("INY024", qsTr("INY024")),
                new IOItem("INY025", qsTr("INY025")),
                new IOItem("INY026", qsTr("INY026")),
                new IOItem("INY027", qsTr("INY027")),
                new IOItem("INY030", qsTr("INY030")),
                new IOItem("INY031", qsTr("INY031")),
                new IOItem("INY032", qsTr("INY032")),
                new IOItem("INY033", qsTr("INY033")),
                new IOItem("INY034", qsTr("INY034")),
                new IOItem("INY035", qsTr("INY035")),
                new IOItem("INY036", qsTr("INY036")),
                new IOItem("INY037", qsTr("INY037")),
                new IOItem("INY040", qsTr("INY040")),
                new IOItem("INY041", qsTr("INY041")),
                new IOItem("INY042", qsTr("INY042")),
                new IOItem("INY043", qsTr("INY043")),
                new IOItem("INY044", qsTr("INY044")),
                new IOItem("INY045", qsTr("INY045")),
                new IOItem("INY046", qsTr("INY046")),
                new IOItem("INY047", qsTr("INY047")),
            ];
}

var mYDefines = mYInit();

var valveDefines = {
    "valve0": new ValveItem(0, qsTr("Normal Y"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 0),
    "valve1": new ValveItem(1, qsTr("Single Y"), IO_TYPE_SINGLE_Y, 1, IO_BOARD_0, 1, IO_BOARD_0, 1, IO_DIR_PP),
    "valve2": new ValveItem(2, qsTr("Hold Double Y"), IO_TYPE_HOLD_DOUBLE_Y, 1, IO_BOARD_0, 2, IO_BOARD_0, 2, IO_DIR_PP,
                                                                                IO_BOARD_0, 3, IO_BOARD_0, 3, IO_DIR_PP),
    "valve3": new ValveItem(3, qsTr("Unhold Double Y"), IO_TYPE_UNHOLD_DOUBLE_Y, 1, IO_BOARD_0, 4, IO_BOARD_0, 4, IO_DIR_PP,
                                                                                    IO_BOARD_0, 5, IO_BOARD_0, 5, IO_DIR_PP)
};

function combineValveDefines(customValves){
    var vd;
    if(customValves.length === 0) return;
    customValves = JSON.parse(customValves);
    if(customValves.length === 0) return;
    for(var v in valveDefines){
        vd = valveDefines[v];
        if(isNormalYType(vd))
            continue;
        for(var i = 0; i < customValves.length; ++i){
            if(vd.id == customValves[i].id){
                vd.x1Dir = customValves[i].x1Dir;
                vd.x2Dir = customValves[i].x2Dir;
                vd.time = customValves[i].time;
            }
        }
    }
}

var valveItemJSON = function(name){
    if(valveDefines.hasOwnProperty(name)){
        return JSON.stringify(valveDefines[name]);
    }
    return "";
}

var valveDefinesJSON = function(){
    var vI = [];
    for(var v in valveDefines){
        vI.push(valveDefines[v]);
    }
    return JSON.stringify(vI);
}

var isNormalYType = function(valve){
    return valve.type === IO_TYPE_NORMAL_Y;
}

var isDoubleYType = function(valve){
    return valve.type === IO_TYPE_UNHOLD_DOUBLE_Y ||
            valve.type === IO_TYPE_HOLD_DOUBLE_Y;
}

var getValveItemFromValveName = function(valve){
    if(valveDefines.hasOwnProperty(valve))
        return valveDefines[valve];
    return null;
}

var getValveItemFromValveID = function(id){
    for(var o in valveDefines){
        if(valveDefines[o].id === id)
            return valveDefines[o];
    }
    return null;
}

var getYDefineFromPointName = function(pointName){
    var i;
    for(i = 0; i < yDefines.length; ++i){
        if(pointName === yDefines[i].pointName)
            return {"yDefine":yDefines[i], "hwPoint":i, "type":IO_BOARD_0 + Math.floor(i / 32)};
    }
    for(i = 0; i < euyDefines.length; ++i){
        if(pointName === euyDefines[i].pointName)
            return {"yDefine":euyDefines[i], "hwPoint": i, "type":EUIO_BOARD};
    }
    for(i = 0; i < mYDefines.length; ++i ){
        if(pointName === mYDefines[i].pointName)
            return {"yDefine":mYDefines[i], "hwPoint": i, "type":M_BOARD_0 + Math.floor(i / 32)};
    }

    return null;
}

var getXDefineFromPointName = function(pointName){
    var i;
    for(i = 0; i < xDefines.length; ++i){
        if(pointName === xDefines[i].pointName)
            return {"xDefine":xDefines[i], "hwPoint":i, "type":IO_BOARD_0 + Math.floor(i / 32)};
    }
    for(i = 0; i < euxDefines.length; ++i){
        if(pointName === euxDefines[i].pointName)
            return {"xDefine":euxDefines[i], "hwPoint":i, "type":EUIO_BOARD};
    }
    for(i = 0; i < mXDefines.length; ++i){
        if(pointName === mXDefines[i].pointName)
            return {"xDefine":mXDefines[i], "hwPoint": i, "type":M_BOARD_0 + Math.floor(i / 32)};
    }

    return null;
}

var getYDefineFromHWPoint = function(point, type){
    if(type >= IO_BOARD_0 && type <= IO_BOARD_3){
        return {"yDefine":yDefines[point], "hwPoint":point, "type":type};
    }else if(type >= M_BOARD_0 && type <= M_BOARD_2){
        return {"yDefine":mYDefines[point], "hwPoint": point, "type":type};
    }
    else
        return {"yDefine":euyDefines[point], "hwPoint":point, "type":type};
}

var getXDefineFromHWPoint = function(point, type){
    if(type >= IO_BOARD_0 && type <= IO_BOARD_3){
        return {"xDefine":xDefines[point], "hwPoint":point, "type":type};
    }else if(type >= M_BOARD_0 && type <= M_BOARD_2){
        return {"xDefine":mXDefines[point], "hwPoint": point, "type":type};
    }
    else
        return {"xDefine":euxDefines[point], "hwPoint":point, "type":type};
}
