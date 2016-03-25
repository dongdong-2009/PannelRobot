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
var TIMEY_BOARD_START = 100;

var IO_TYPE_NORMAL_Y = 0;
var IO_TYPE_SINGLE_Y = 1;
var IO_TYPE_HOLD_DOUBLE_Y = 2;
var IO_TYPE_UNHOLD_DOUBLE_Y = 3;
var IO_TYPE_M = 100;
var IO_TYPE_EUY = 101;
var IO_TYPE_TIMEY = 102;

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

function mYInit(){
    return  [
                new IOItem("M010", qsTr("M010")),
                new IOItem("M011", qsTr("M011")),
                new IOItem("M012", qsTr("M012")),
                new IOItem("M013", qsTr("M013")),
                new IOItem("M014", qsTr("M014")),
                new IOItem("M015", qsTr("M015")),
                new IOItem("M016", qsTr("M016")),
                new IOItem("M017", qsTr("M017")),
                new IOItem("M020", qsTr("M020")),
                new IOItem("M021", qsTr("M021")),
                new IOItem("M022", qsTr("M022")),
                new IOItem("M023", qsTr("M023")),
                new IOItem("M024", qsTr("M024")),
                new IOItem("M025", qsTr("M025")),
                new IOItem("M026", qsTr("M026")),
                new IOItem("M027", qsTr("M027")),
                new IOItem("M030", qsTr("M030")),
                new IOItem("M031", qsTr("M031")),
                new IOItem("M032", qsTr("M032")),
                new IOItem("M033", qsTr("M033")),
                new IOItem("M034", qsTr("M034")),
                new IOItem("M035", qsTr("M035")),
                new IOItem("M036", qsTr("M036")),
                new IOItem("M037", qsTr("M037")),
                new IOItem("M040", qsTr("M040")),
                new IOItem("M041", qsTr("M041")),
                new IOItem("M042", qsTr("M042")),
                new IOItem("M043", qsTr("M043")),
                new IOItem("M044", qsTr("M044")),
                new IOItem("M045", qsTr("M045")),
                new IOItem("M046", qsTr("M046")),
                new IOItem("M047", qsTr("M047")),
            ];
}

var mYDefines = mYInit();
/*
ValveItem(id, descr, type, time,
                   y1Board, y1Point, x1Board, x1Point, x1Dir,
                   y2Board, y2Point, x2Board, x2Point, x2Dir
                   )
*/
var valveDefines = {
    "valve0": new ValveItem(0, qsTr("Normal Y010"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 0),
    "valve1": new ValveItem(1, qsTr("Normal Y011"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 1),
    "valve2": new ValveItem(2, qsTr("Normal Y012"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 2),
    "valve3": new ValveItem(3, qsTr("Normal Y013"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 3),
    "valve4": new ValveItem(4, qsTr("Normal Y014"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 4),
    "valve5": new ValveItem(5, qsTr("Normal Y015"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 5),
    "valve6": new ValveItem(6, qsTr("Normal Y016"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 6),
    "valve7": new ValveItem(7, qsTr("Normal Y017"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 7),
    "valve8": new ValveItem(8, qsTr("Normal Y020"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 8),
    "valve9": new ValveItem(9, qsTr("Normal Y021"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 9),
    "valve10": new ValveItem(10, qsTr("Normal Y022"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 10),
    "valve11": new ValveItem(11, qsTr("Normal Y023"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 11),
    "valve12": new ValveItem(12, qsTr("Normal Y024"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 12),
    "valve13": new ValveItem(13, qsTr("Normal Y025"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 13),
    "valve14": new ValveItem(14, qsTr("Normal Y026"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 14),
    "valve15": new ValveItem(15, qsTr("Normal Y027"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 15),
    "valve16": new ValveItem(16, qsTr("Normal Y030"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 16),
    "valve17": new ValveItem(17, qsTr("Normal Y031"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 17),
    "valve18": new ValveItem(18, qsTr("Normal Y032"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 18),
    "valve19": new ValveItem(19, qsTr("Normal Y033"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 19),
    "valve20": new ValveItem(20, qsTr("Normal Y034"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 20),
    "valve21": new ValveItem(21, qsTr("Normal Y035"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 21),
    "valve22": new ValveItem(22, qsTr("Normal Y036"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 22),
    "valve23": new ValveItem(23, qsTr("Normal Y037"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 23),
    "valve24": new ValveItem(24, qsTr("Normal Y040"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 24),
    "valve25": new ValveItem(25, qsTr("Normal Y041"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 25),
    "valve26": new ValveItem(26, qsTr("Normal Y042"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 26),
    "valve27": new ValveItem(27, qsTr("Normal Y043"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 27),
    "valve28": new ValveItem(28, qsTr("Normal Y044"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 28),
    "valve29": new ValveItem(29, qsTr("Normal Y045"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 29),
    "valve30": new ValveItem(30, qsTr("Normal Y046"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 30),
    "valve31": new ValveItem(31, qsTr("Normal Y047"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 31),

    "mValve0": new ValveItem(32, qsTr("M010"), IO_TYPE_M, 0, M_BOARD_0, 0),
    "mValve1": new ValveItem(33, qsTr("M011"), IO_TYPE_M, 0, M_BOARD_0, 1),
    "mValve2": new ValveItem(34, qsTr("M012"), IO_TYPE_M, 0, M_BOARD_0, 2),
    "mValve3": new ValveItem(35, qsTr("M013"), IO_TYPE_M, 0, M_BOARD_0, 3),
    "mValve4": new ValveItem(36, qsTr("M014"), IO_TYPE_M, 0, M_BOARD_0, 4),
    "mValve5": new ValveItem(37, qsTr("M015"), IO_TYPE_M, 0, M_BOARD_0, 5),
    "mValve6": new ValveItem(38, qsTr("M016"), IO_TYPE_M, 0, M_BOARD_0, 6),
    "mValve7": new ValveItem(39, qsTr("M017"), IO_TYPE_M, 0, M_BOARD_0, 7),
    "mValve8": new ValveItem(40, qsTr("M020"), IO_TYPE_M, 0, M_BOARD_0, 8),
    "mValve9": new ValveItem(41, qsTr("M021"), IO_TYPE_M, 0, M_BOARD_0, 9),
    "mValve10": new ValveItem(42, qsTr("M022"), IO_TYPE_M, 0, M_BOARD_0, 10),
    "mValve11": new ValveItem(43, qsTr("M023"), IO_TYPE_M, 0, M_BOARD_0, 11),
    "mValve12": new ValveItem(44, qsTr("M024"), IO_TYPE_M, 0, M_BOARD_0, 12),
    "mValve13": new ValveItem(45, qsTr("M025"), IO_TYPE_M, 0, M_BOARD_0, 13),
    "mValve14": new ValveItem(46, qsTr("M026"), IO_TYPE_M, 0, M_BOARD_0, 14),
    "mValve15": new ValveItem(47, qsTr("M027"), IO_TYPE_M, 0, M_BOARD_0, 15),

    "tValve0": new ValveItem(0, qsTr("Time Y010"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 0),
    "tValve1": new ValveItem(1, qsTr("Time Y011"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 1),
    "tValve2": new ValveItem(2, qsTr("Time Y012"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 2),
    "tValve3": new ValveItem(3, qsTr("Time Y013"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 3),
    "tValve4": new ValveItem(4, qsTr("Time Y014"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 4),
    "tValve5": new ValveItem(5, qsTr("Time Y015"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 5),
    "tValve6": new ValveItem(6, qsTr("Time Y016"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 6),
    "tValve7": new ValveItem(7, qsTr("Time Y017"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 7),
    "tValve8": new ValveItem(8, qsTr("Time Y020"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 8),
    "tValve9": new ValveItem(9, qsTr("Time Y021"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 9),
    "tValve10": new ValveItem(10, qsTr("Time Y022"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 10),
    "tValve11": new ValveItem(11, qsTr("Time Y023"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 11),
    "tValve12": new ValveItem(12, qsTr("Time Y024"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 12),
    "tValve13": new ValveItem(13, qsTr("Time Y025"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 13),
    "tValve14": new ValveItem(14, qsTr("Time Y026"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 14),
    "tValve15": new ValveItem(15, qsTr("Time Y027"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 15),
    "tValve16": new ValveItem(16, qsTr("Time Y030"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 16),
    "tValve17": new ValveItem(17, qsTr("Time Y031"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 17),
    "tValve18": new ValveItem(18, qsTr("Time Y032"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 18),
    "tValve19": new ValveItem(19, qsTr("Time Y033"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 19),
    "tValve20": new ValveItem(20, qsTr("Time Y034"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 20),
    "tValve21": new ValveItem(21, qsTr("Time Y035"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 21),
    "tValve22": new ValveItem(22, qsTr("Time Y036"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 22),
    "tValve23": new ValveItem(23, qsTr("Time Y037"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 23),
    "tValve24": new ValveItem(24, qsTr("Time Y040"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 24),
    "tValve25": new ValveItem(25, qsTr("Time Y041"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 25),
    "tValve26": new ValveItem(26, qsTr("Time Y042"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 26),
    "tValve27": new ValveItem(27, qsTr("Time Y043"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 27),
    "tValve28": new ValveItem(28, qsTr("Time Y044"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 28),
    "tValve29": new ValveItem(29, qsTr("Time Y045"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 29),
    "tValve30": new ValveItem(30, qsTr("Time Y046"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 30),
    "tValve31": new ValveItem(31, qsTr("Time Y047"), IO_TYPE_NORMAL_Y, 1, IO_TYPE_TIMEY, 31),

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
    for(i = 0; i < mYDefines.length; ++i){
        if(pointName === mYDefines[i].pointName)
            return {"xDefine":mYDefines[i], "hwPoint": i, "type":M_BOARD_0 + Math.floor(i / 32)};
    }

    return null;
}

var getYDefineFromHWPoint = function(point, type){
    if(type >= IO_BOARD_0 && type <= IO_BOARD_3){
        return {"yDefine":yDefines[point], "hwPoint":point, "type":type};
    }else if(type >= M_BOARD_0 && type <= M_BOARD_2){
        return {"yDefine":mYDefines[point], "hwPoint": point, "type":type};
    }
    else if(type == EUIO_BOARD)
        return {"yDefine":euyDefines[point], "hwPoint":point, "type":type};
    else if(type == IO_TYPE_TIMEY){
        return {"yDefine":yDefines[point], "hwPoint":point, "type":type};
    }
    return null;
}

var getXDefineFromHWPoint = function(point, type){
    if(type >= IO_BOARD_0 && type <= IO_BOARD_3){
        return {"xDefine":xDefines[point], "hwPoint":point, "type":type};
    }else if(type >= M_BOARD_0 && type <= M_BOARD_2){
        return {"xDefine":mYDefines[point], "hwPoint": point, "type":type};
    }
    else
        return {"xDefine":euxDefines[point], "hwPoint":point, "type":type};
}
