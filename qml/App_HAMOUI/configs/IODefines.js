.pragma library
Qt.include("IOConfigs.js");
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

var IO_DIR_PP = 1;
var IO_DIR_RP = 0;

var IOItem = function(pointName, descr)
{
    this.pointName = pointName;
    this.descr = descr;
}

function ioItemName(ioItem){
    return ioItem.pointName + ":" + ioItem.descr;
}

var valveTypeToItems = {"0":[], "1":[], "2":[], "3":[], "4":[], "100":[]};

function ValveItem(id, descr, type, time,
                   y1Board, y1Point, x1Board, x1Point, x1Dir,
                   y2Board, y2Point, x2Board, x2Point, x2Dir,
                   autoCheck){
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
    this.autoCheck = (autoCheck == undefined ? false : autoCheck);
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
                new IOItem("Y047", qsTr("Y047")),

                new IOItem("Y110", qsTr("Y110")),
                new IOItem("Y111", qsTr("Y111")),
                new IOItem("Y112", qsTr("Y112")),
                new IOItem("Y113", qsTr("Y113")),
                new IOItem("Y114", qsTr("Y114")),
                new IOItem("Y115", qsTr("Y115")),
                new IOItem("Y116", qsTr("Y116")),
                new IOItem("Y117", qsTr("Y117")),
                new IOItem("Y120", qsTr("Y120")),
                new IOItem("Y121", qsTr("Y121")),
                new IOItem("Y122", qsTr("Y122")),
                new IOItem("Y123", qsTr("Y123")),
                new IOItem("Y124", qsTr("Y124")),
                new IOItem("Y125", qsTr("Y125")),
                new IOItem("Y126", qsTr("Y126")),
                new IOItem("Y127", qsTr("Y127")),
                new IOItem("Y130", qsTr("Y130")),
                new IOItem("Y131", qsTr("Y131")),
                new IOItem("Y132", qsTr("Y132")),
                new IOItem("Y133", qsTr("Y133")),
                new IOItem("Y134", qsTr("Y134")),
                new IOItem("Y135", qsTr("Y135")),
                new IOItem("Y136", qsTr("Y136")),
                new IOItem("Y137", qsTr("Y137")),
                new IOItem("Y140", qsTr("Y140")),
                new IOItem("Y141", qsTr("Y141")),
                new IOItem("Y142", qsTr("Y142")),
                new IOItem("Y143", qsTr("Y143")),
                new IOItem("Y144", qsTr("Y144")),
                new IOItem("Y145", qsTr("Y145")),
                new IOItem("Y146", qsTr("Y146")),
                new IOItem("Y147", qsTr("Y147")),

                new IOItem("Y210", qsTr("Y210")),
                new IOItem("Y211", qsTr("Y211")),
                new IOItem("Y212", qsTr("Y212")),
                new IOItem("Y213", qsTr("Y213")),
                new IOItem("Y214", qsTr("Y214")),
                new IOItem("Y215", qsTr("Y215")),
                new IOItem("Y216", qsTr("Y216")),
                new IOItem("Y217", qsTr("Y217")),
                new IOItem("Y220", qsTr("Y220")),
                new IOItem("Y221", qsTr("Y221")),
                new IOItem("Y222", qsTr("Y222")),
                new IOItem("Y223", qsTr("Y223")),
                new IOItem("Y224", qsTr("Y224")),
                new IOItem("Y225", qsTr("Y225")),
                new IOItem("Y226", qsTr("Y226")),
                new IOItem("Y227", qsTr("Y227")),
                new IOItem("Y230", qsTr("Y230")),
                new IOItem("Y231", qsTr("Y231")),
                new IOItem("Y232", qsTr("Y232")),
                new IOItem("Y233", qsTr("Y233")),
                new IOItem("Y234", qsTr("Y234")),
                new IOItem("Y235", qsTr("Y235")),
                new IOItem("Y236", qsTr("Y236")),
                new IOItem("Y237", qsTr("Y237")),
                new IOItem("Y240", qsTr("Y240")),
                new IOItem("Y241", qsTr("Y241")),
                new IOItem("Y242", qsTr("Y242")),
                new IOItem("Y243", qsTr("Y243")),
                new IOItem("Y244", qsTr("Y244")),
                new IOItem("Y245", qsTr("Y245")),
                new IOItem("Y246", qsTr("Y246")),
                new IOItem("Y247", qsTr("Y247")),

                new IOItem("Y310", qsTr("Y310")),
                new IOItem("Y311", qsTr("Y311")),
                new IOItem("Y312", qsTr("Y312")),
                new IOItem("Y313", qsTr("Y313")),
                new IOItem("Y314", qsTr("Y314")),
                new IOItem("Y315", qsTr("Y315")),
                new IOItem("Y316", qsTr("Y316")),
                new IOItem("Y317", qsTr("Y317")),
                new IOItem("Y320", qsTr("Y320")),
                new IOItem("Y321", qsTr("Y321")),
                new IOItem("Y322", qsTr("Y322")),
                new IOItem("Y323", qsTr("Y323")),
                new IOItem("Y324", qsTr("Y324")),
                new IOItem("Y325", qsTr("Y325")),
                new IOItem("Y326", qsTr("Y326")),
                new IOItem("Y327", qsTr("Y327")),
                new IOItem("Y330", qsTr("Y330")),
                new IOItem("Y331", qsTr("Y331")),
                new IOItem("Y332", qsTr("Y332")),
                new IOItem("Y333", qsTr("Y333")),
                new IOItem("Y334", qsTr("Y334")),
                new IOItem("Y335", qsTr("Y335")),
                new IOItem("Y336", qsTr("Y336")),
                new IOItem("Y337", qsTr("Y337")),
                new IOItem("Y340", qsTr("Y340")),
                new IOItem("Y341", qsTr("Y341")),
                new IOItem("Y342", qsTr("Y342")),
                new IOItem("Y343", qsTr("Y343")),
                new IOItem("Y344", qsTr("Y344")),
                new IOItem("Y345", qsTr("Y345")),
                new IOItem("Y346", qsTr("Y346")),
                new IOItem("Y347", qsTr("Y347")),
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

                new IOItem("X110", qsTr("X110")),
                new IOItem("X111", qsTr("X111")),
                new IOItem("X112", qsTr("X112")),
                new IOItem("X113", qsTr("X113")),
                new IOItem("X114", qsTr("X114")),
                new IOItem("X115", qsTr("X115")),
                new IOItem("X116", qsTr("X116")),
                new IOItem("X117", qsTr("X117")),
                new IOItem("X120", qsTr("X120")),
                new IOItem("X121", qsTr("X121")),
                new IOItem("X122", qsTr("X122")),
                new IOItem("X123", qsTr("X123")),
                new IOItem("X124", qsTr("X124")),
                new IOItem("X125", qsTr("X125")),
                new IOItem("X126", qsTr("X126")),
                new IOItem("X127", qsTr("X127")),
                new IOItem("X130", qsTr("X130")),
                new IOItem("X131", qsTr("X131")),
                new IOItem("X132", qsTr("X132")),
                new IOItem("X133", qsTr("X133")),
                new IOItem("X134", qsTr("X134")),
                new IOItem("X135", qsTr("X135")),
                new IOItem("X136", qsTr("X136")),
                new IOItem("X137", qsTr("X137")),
                new IOItem("X140", qsTr("X140")),
                new IOItem("X141", qsTr("X141")),
                new IOItem("X142", qsTr("X142")),
                new IOItem("X143", qsTr("X143")),
                new IOItem("X144", qsTr("X144")),
                new IOItem("X145", qsTr("X145")),
                new IOItem("X146", qsTr("X146")),
                new IOItem("X147", qsTr("X147")),

                new IOItem("X210", qsTr("X210")),
                new IOItem("X211", qsTr("X211")),
                new IOItem("X212", qsTr("X212")),
                new IOItem("X213", qsTr("X213")),
                new IOItem("X214", qsTr("X214")),
                new IOItem("X215", qsTr("X215")),
                new IOItem("X216", qsTr("X216")),
                new IOItem("X217", qsTr("X217")),
                new IOItem("X220", qsTr("X220")),
                new IOItem("X221", qsTr("X221")),
                new IOItem("X222", qsTr("X222")),
                new IOItem("X223", qsTr("X223")),
                new IOItem("X224", qsTr("X224")),
                new IOItem("X225", qsTr("X225")),
                new IOItem("X226", qsTr("X226")),
                new IOItem("X227", qsTr("X227")),
                new IOItem("X230", qsTr("X230")),
                new IOItem("X231", qsTr("X231")),
                new IOItem("X232", qsTr("X232")),
                new IOItem("X233", qsTr("X233")),
                new IOItem("X234", qsTr("X234")),
                new IOItem("X235", qsTr("X235")),
                new IOItem("X236", qsTr("X236")),
                new IOItem("X237", qsTr("X237")),
                new IOItem("X240", qsTr("X240")),
                new IOItem("X241", qsTr("X241")),
                new IOItem("X242", qsTr("X242")),
                new IOItem("X243", qsTr("X243")),
                new IOItem("X244", qsTr("X244")),
                new IOItem("X245", qsTr("X245")),
                new IOItem("X246", qsTr("X246")),
                new IOItem("X247", qsTr("X247")),

                new IOItem("X310", qsTr("X310")),
                new IOItem("X311", qsTr("X311")),
                new IOItem("X312", qsTr("X312")),
                new IOItem("X313", qsTr("X313")),
                new IOItem("X314", qsTr("X314")),
                new IOItem("X315", qsTr("X315")),
                new IOItem("X316", qsTr("X316")),
                new IOItem("X317", qsTr("X317")),
                new IOItem("X320", qsTr("X320")),
                new IOItem("X321", qsTr("X321")),
                new IOItem("X322", qsTr("X322")),
                new IOItem("X323", qsTr("X323")),
                new IOItem("X324", qsTr("X324")),
                new IOItem("X325", qsTr("X325")),
                new IOItem("X326", qsTr("X326")),
                new IOItem("X327", qsTr("X327")),
                new IOItem("X330", qsTr("X330")),
                new IOItem("X331", qsTr("X331")),
                new IOItem("X332", qsTr("X332")),
                new IOItem("X333", qsTr("X333")),
                new IOItem("X334", qsTr("X334")),
                new IOItem("X335", qsTr("X335")),
                new IOItem("X336", qsTr("X336")),
                new IOItem("X337", qsTr("X337")),
                new IOItem("X340", qsTr("X340")),
                new IOItem("X341", qsTr("X341")),
                new IOItem("X342", qsTr("X342")),
                new IOItem("X343", qsTr("X343")),
                new IOItem("X344", qsTr("X344")),
                new IOItem("X345", qsTr("X345")),
                new IOItem("X346", qsTr("X346")),
                new IOItem("X347", qsTr("X347")),
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
    "getValves": function(type){
        return valveTypeToItems[type];
    },
};

(function initValveDefines(ioConfigs){
    var v;
    var type, y1Board, y1Point, x1Board = 0, x1Point = 0, x1Dir = 0,
        y2Board = 0, y2Point = 0, x2Board = 0, x2Point = 0, x2Dir = 0,
                       autoCheck = 0;
    function pointBoardHelper(p, b){
        return [p % 32, b + parseInt(p / 32)];
    }

    for(var i = 0, len = ioConfigs.length; i < len; ++i){
        v = ioConfigs[i];
        var pbH = pointBoardHelper(v.y1Point, IO_BOARD_0);
        y1Point = pbH[0];
        y1Board = pbH[1];
        type = v.type;
        if(v.type === kIO_TYPE.mY){
            type = IO_TYPE_NORMAL_Y;
            pbH = pointBoardHelper(v.y1Point, M_BOARD_0);
            y1Point = pbH[0];
            y1Board = pbH[1];
        }else if(v.type === kIO_TYPE.tY){
            type = IO_TYPE_NORMAL_Y;
        }else if(v.type === kIO_TYPE.singleY){
            type = v.type;
            pbH = pointBoardHelper(v.x1Point, IO_BOARD_0);
            x1Point = pbH[0];
            x1Board = pbH[1];
            x1Dir = v.x1Dir;
            autoCheck = v.autoCheck;
        }else if(v.type === kIO_TYPE.holdDoubleY || v.type === kIO_TYPE.unholdDoubleY){
            type = v.type;
            pbH = pointBoardHelper(v.x1Point, IO_BOARD_0);
            x1Point = pbH[0];
            x1Board = pbH[1];
            x1Dir = v.x1Dir;
            pbH = pointBoardHelper(v.y2Point, IO_BOARD_0);
            y2Point = pbH[0];
            y2Board = pbH[1];
            pbH = pointBoardHelper(v.x2Point, IO_BOARD_0);
            x2Point = pbH[0];
            x2Board = pbH[1];
            x2Dir = v.x2Dir;
            autoCheck = v.autoCheck;
        }

        valveDefines[v.id] = new ValveItem(v.id, v.name, type, v.time, y1Board, y1Point, x1Board, x1Point, x1Dir,y2Board, y2Point, x2Board, x2Point, x2Dir,autoCheck);
        valveTypeToItems[v.type].push(valveDefines[v.id]);
    }
})(valveConfigs);

function combineValveDefines(customValves){
    var vd;
    if(customValves.length === 0) return;
    customValves = JSON.parse(customValves);
    if(customValves.length === 0) return;
    for(var v in valveDefines){
        vd = valveDefines[v];
        if(isNormalYType(vd))
            continue;
        for(var i = 0, len = customValves.length; i < len; ++i){
            if(customValves[i] == null)continue;
            if(customValves[i].hasOwnProperty("id")){
                if(vd.id == customValves[i].id){
                    vd.x1Dir = customValves[i].x1Dir || 0;
                    vd.x2Dir = customValves[i].x2Dir || 0;
                    vd.time = customValves[i].time || 0.00;
                    vd.autoCheck = customValves[i].autoCheck || false;
                }
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
        return {"yDefine":yDefines[point + type * 32], "hwPoint":point, "type":type};
    }else if(type >= M_BOARD_0 && type <= M_BOARD_2){
        return {"yDefine":mYDefines[point], "hwPoint": point, "type":type};
    }
    else if(type == EUIO_BOARD)
        return {"yDefine":euyDefines[point], "hwPoint":point, "type":type};
    else if(type == TIMEY_BOARD_START){
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

function generateIOBaseBoardCount(prefix, boardCount){
    var l = boardCount * 32;
    var ret = [];
    var v;
    for(var i = 0; i < l; ++i){
        v = (i + 8).toString(8);
        if(v.length < 3)
            v = "0" + v;
        ret.push(prefix + v);
    }
    return ret;
}

function getYDefinePointNameFromValve(valve){
    var ret = getYDefineFromHWPoint(valve.y1Point, valve.y1Board).yDefine.pointName;
    if(valve.type === IO_TYPE_HOLD_DOUBLE_Y ||
            valve.type === IO_TYPE_UNHOLD_DOUBLE_Y){
        ret += "," + getYDefineFromHWPoint(valve.y2Point, valve.y2Board).yDefine.pointName;
    }
    return ret;
}
