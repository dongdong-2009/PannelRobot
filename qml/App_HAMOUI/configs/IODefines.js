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

var IODefine = function(pointName, descr)
{
    this.pointName = pointName;
    this.descr = descr;
}

function yInit(){
    return  [
                new IODefine("Y010", qsTr("Y010")),
                new IODefine("Y011", qsTr("Y011")),
                new IODefine("Y012", qsTr("Y012")),
                new IODefine("Y013", qsTr("Y013")),
                new IODefine("Y014", qsTr("Y014")),
                new IODefine("Y015", qsTr("Y015")),
                new IODefine("Y016", qsTr("Y016")),
                new IODefine("Y017", qsTr("Y017")),
                new IODefine("Y020", qsTr("Y020")),
                new IODefine("Y021", qsTr("Y021")),
                new IODefine("Y022", qsTr("Y022")),
                new IODefine("Y023", qsTr("Y023")),
                new IODefine("Y024", qsTr("Y024")),
                new IODefine("Y025", qsTr("Y025")),
                new IODefine("Y026", qsTr("Y026")),
                new IODefine("Y027", qsTr("Y027")),
                new IODefine("Y030", qsTr("Y030")),
                new IODefine("Y031", qsTr("Y031")),
                new IODefine("Y032", qsTr("Y032")),
                new IODefine("Y033", qsTr("Y033")),
                new IODefine("Y034", qsTr("Y034")),
                new IODefine("Y035", qsTr("Y035")),
                new IODefine("Y036", qsTr("Y036")),
                new IODefine("Y037", qsTr("Y037")),
                new IODefine("Y040", qsTr("Y040")),
                new IODefine("Y041", qsTr("Y041")),
                new IODefine("Y042", qsTr("Y042")),
                new IODefine("Y043", qsTr("Y043")),
                new IODefine("Y044", qsTr("Y044")),
                new IODefine("Y045", qsTr("Y045")),
                new IODefine("Y046", qsTr("Y046")),
                new IODefine("Y047", qsTr("Y047"))
            ];
}

var yDefines = yInit();

function xInit(){
    return [
                new IODefine("X010", qsTr("X010")),
                new IODefine("X011", qsTr("X011")),
                new IODefine("X012", qsTr("X012")),
                new IODefine("X013", qsTr("X013")),
                new IODefine("X014", qsTr("X014")),
                new IODefine("X015", qsTr("X015")),
                new IODefine("X016", qsTr("X016")),
                new IODefine("X017", qsTr("X017")),
                new IODefine("X020", qsTr("X020")),
                new IODefine("X021", qsTr("X021")),
                new IODefine("X022", qsTr("X022")),
                new IODefine("X023", qsTr("X023")),
                new IODefine("X024", qsTr("X024")),
                new IODefine("X025", qsTr("X025")),
                new IODefine("X026", qsTr("X026")),
                new IODefine("X027", qsTr("X027")),
                new IODefine("X030", qsTr("X030")),
                new IODefine("X031", qsTr("X031")),
                new IODefine("X032", qsTr("X032")),
                new IODefine("X033", qsTr("X033")),
                new IODefine("X034", qsTr("X034")),
                new IODefine("X035", qsTr("X035")),
                new IODefine("X036", qsTr("X036")),
                new IODefine("X037", qsTr("X037")),
                new IODefine("X040", qsTr("X040")),
                new IODefine("X041", qsTr("X041")),
                new IODefine("X042", qsTr("X042")),
                new IODefine("X043", qsTr("X043")),
                new IODefine("X044", qsTr("X044")),
                new IODefine("X045", qsTr("X045")),
                new IODefine("X046", qsTr("X046")),
                new IODefine("X047", qsTr("X047")),
                new IODefine("X050", qsTr("X050")),
                new IODefine("X051", qsTr("X051")),
                new IODefine("X052", qsTr("X052")),
                new IODefine("X053", qsTr("X053")),
                new IODefine("X054", qsTr("X054")),
                new IODefine("X055", qsTr("X055")),
                new IODefine("X056", qsTr("X056")),
                new IODefine("X057", qsTr("X057")),
            ];
}

var xDefines = xInit();

function euXInit(){
    return [
                new IODefine("EuX010", qsTr("EuX010")),
                new IODefine("EuX011", qsTr("EuX011")),
                new IODefine("EuX012", qsTr("EuX012")),
                new IODefine("EuX013", qsTr("EuX013")),
                new IODefine("EuX014", qsTr("EuX014")),
                new IODefine("EuX015", qsTr("EuX015")),
                new IODefine("EuX016", qsTr("EuX016")),
                new IODefine("EuX017", qsTr("EuX017")),
                new IODefine("EuX020", qsTr("EuX020")),
                new IODefine("EuX021", qsTr("EuX021")),
                new IODefine("EuX022", qsTr("EuX022")),
                new IODefine("EuX023", qsTr("EuX023")),
                new IODefine("EuX024", qsTr("EuX024")),
                new IODefine("EuX025", qsTr("EuX025")),
                new IODefine("EuX026", qsTr("EuX026")),
                new IODefine("EuX027", qsTr("EuX027")),
            ];
}

var euxDefines = euXInit();


function euYInit(){
    return [
                new IODefine("EuY010", qsTr("EuY010")),
                new IODefine("EuY011", qsTr("EuY011")),
                new IODefine("EuY012", qsTr("EuY012")),
                new IODefine("EuY013", qsTr("EuY013")),
                new IODefine("EuY014", qsTr("EuY014")),
                new IODefine("EuY015", qsTr("EuY015")),
                new IODefine("EuY016", qsTr("EuY016")),
                new IODefine("EuY017", qsTr("EuY017")),
                new IODefine("EuY020", qsTr("EuY020")),
                new IODefine("EuY021", qsTr("EuY021")),
                new IODefine("EuY022", qsTr("EuY022")),
                new IODefine("EuY023", qsTr("EuY023")),
                new IODefine("EuY024", qsTr("EuY024")),
                new IODefine("EuY025", qsTr("EuY025")),
                new IODefine("EuY026", qsTr("EuY026")),
                new IODefine("EuY027", qsTr("EuY027")),
            ];
}

var euyDefines = euYInit();

function mXInit(){
    return  [
                new IODefine("INX010", qsTr("INX010")),
                new IODefine("INX011", qsTr("INX011")),
                new IODefine("INX012", qsTr("INX012")),
                new IODefine("INX013", qsTr("INX013")),
                new IODefine("INX014", qsTr("INX014")),
                new IODefine("INX015", qsTr("INX015")),
                new IODefine("INX016", qsTr("INX016")),
                new IODefine("INX017", qsTr("INX017")),
                new IODefine("INX020", qsTr("INX020")),
                new IODefine("INX021", qsTr("INX021")),
                new IODefine("INX022", qsTr("INX022")),
                new IODefine("INX023", qsTr("INX023")),
                new IODefine("INX024", qsTr("INX024")),
                new IODefine("INX025", qsTr("INX025")),
                new IODefine("INX026", qsTr("INX026")),
                new IODefine("INX027", qsTr("INX027")),
                new IODefine("INX030", qsTr("INX030")),
                new IODefine("INX031", qsTr("INX031")),
                new IODefine("INX032", qsTr("INX032")),
                new IODefine("INX033", qsTr("INX033")),
                new IODefine("INX034", qsTr("INX034")),
                new IODefine("INX035", qsTr("INX035")),
                new IODefine("INX036", qsTr("INX036")),
                new IODefine("INX037", qsTr("INX037")),
                new IODefine("INX040", qsTr("INX040")),
                new IODefine("INX041", qsTr("INX041")),
                new IODefine("INX042", qsTr("INX042")),
                new IODefine("INX043", qsTr("INX043")),
                new IODefine("INX044", qsTr("INX044")),
                new IODefine("INX045", qsTr("INX045")),
                new IODefine("INX046", qsTr("INX046")),
                new IODefine("INX047", qsTr("INX047")),
            ];
}

var mXDefines = mXInit();

function mYInit(){
    return  [
                new IODefine("INY010", qsTr("INY010")),
                new IODefine("INY011", qsTr("INY011")),
                new IODefine("INY012", qsTr("INY012")),
                new IODefine("INY013", qsTr("INY013")),
                new IODefine("INY014", qsTr("INY014")),
                new IODefine("INY015", qsTr("INY015")),
                new IODefine("INY016", qsTr("INY016")),
                new IODefine("INY017", qsTr("INY017")),
                new IODefine("INY020", qsTr("INY020")),
                new IODefine("INY021", qsTr("INY021")),
                new IODefine("INY022", qsTr("INY022")),
                new IODefine("INY023", qsTr("INY023")),
                new IODefine("INY024", qsTr("INY024")),
                new IODefine("INY025", qsTr("INY025")),
                new IODefine("INY026", qsTr("INY026")),
                new IODefine("INY027", qsTr("INY027")),
                new IODefine("INY030", qsTr("INY030")),
                new IODefine("INY031", qsTr("INY031")),
                new IODefine("INY032", qsTr("INY032")),
                new IODefine("INY033", qsTr("INY033")),
                new IODefine("INY034", qsTr("INY034")),
                new IODefine("INY035", qsTr("INY035")),
                new IODefine("INY036", qsTr("INY036")),
                new IODefine("INY037", qsTr("INY037")),
                new IODefine("INY040", qsTr("INY040")),
                new IODefine("INY041", qsTr("INY041")),
                new IODefine("INY042", qsTr("INY042")),
                new IODefine("INY043", qsTr("INY043")),
                new IODefine("INY044", qsTr("INY044")),
                new IODefine("INY045", qsTr("INY045")),
                new IODefine("INY046", qsTr("INY046")),
                new IODefine("INY047", qsTr("INY047")),
            ];
}

var mYDefines = mYInit();

var yChecksMap = {
    "Y010": "X010",
    "Y011": "X011"
}

function yCheckedX(y){
    if(!yChecksMap.hasOwnProperty(y)) return -1;
    var xStr = yChecksMap[y];
    for(var i = 0; xDefines.length; ++i){
        if(xDefines[i].pointName == xStr)
            return i;
    }
    return -1;
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
