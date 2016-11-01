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

var valveTypeToItems = {"0":[], "1":[], "2":[], "3":[]};

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
    valveTypeToItems[type].push(this);
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

                new IOItem("Y050", qsTr("Y050")),
                new IOItem("Y051", qsTr("Y051")),
                new IOItem("Y052", qsTr("Y052")),
                new IOItem("Y053", qsTr("Y053")),
                new IOItem("Y054", qsTr("Y054")),
                new IOItem("Y055", qsTr("Y055")),
                new IOItem("Y056", qsTr("Y056")),
                new IOItem("Y057", qsTr("Y057")),
                new IOItem("Y060", qsTr("Y060")),
                new IOItem("Y061", qsTr("Y061")),
                new IOItem("Y062", qsTr("Y062")),
                new IOItem("Y063", qsTr("Y063")),
                new IOItem("Y064", qsTr("Y064")),
                new IOItem("Y065", qsTr("Y065")),
                new IOItem("Y066", qsTr("Y066")),
                new IOItem("Y067", qsTr("Y067")),
                new IOItem("Y070", qsTr("Y070")),
                new IOItem("Y071", qsTr("Y071")),
                new IOItem("Y072", qsTr("Y072")),
                new IOItem("Y073", qsTr("Y073")),
                new IOItem("Y074", qsTr("Y074")),
                new IOItem("Y075", qsTr("Y075")),
                new IOItem("Y076", qsTr("Y076")),
                new IOItem("Y077", qsTr("Y077")),
                new IOItem("Y100", qsTr("Y100")),
                new IOItem("Y101", qsTr("Y101")),
                new IOItem("Y102", qsTr("Y102")),
                new IOItem("Y103", qsTr("Y103")),
                new IOItem("Y104", qsTr("Y104")),
                new IOItem("Y105", qsTr("Y105")),
                new IOItem("Y106", qsTr("Y106")),
                new IOItem("Y107", qsTr("Y107")),

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

                new IOItem("Y150", qsTr("Y150")),
                new IOItem("Y151", qsTr("Y151")),
                new IOItem("Y152", qsTr("Y152")),
                new IOItem("Y153", qsTr("Y153")),
                new IOItem("Y154", qsTr("Y154")),
                new IOItem("Y155", qsTr("Y155")),
                new IOItem("Y156", qsTr("Y156")),
                new IOItem("Y157", qsTr("Y157")),
                new IOItem("Y160", qsTr("Y160")),
                new IOItem("Y161", qsTr("Y161")),
                new IOItem("Y162", qsTr("Y162")),
                new IOItem("Y163", qsTr("Y163")),
                new IOItem("Y164", qsTr("Y164")),
                new IOItem("Y165", qsTr("Y165")),
                new IOItem("Y166", qsTr("Y166")),
                new IOItem("Y167", qsTr("Y167")),
                new IOItem("Y170", qsTr("Y170")),
                new IOItem("Y171", qsTr("Y171")),
                new IOItem("Y172", qsTr("Y172")),
                new IOItem("Y173", qsTr("Y173")),
                new IOItem("Y174", qsTr("Y174")),
                new IOItem("Y175", qsTr("Y175")),
                new IOItem("Y176", qsTr("Y176")),
                new IOItem("Y177", qsTr("Y177")),
                new IOItem("Y200", qsTr("Y200")),
                new IOItem("Y201", qsTr("Y201")),
                new IOItem("Y202", qsTr("Y202")),
                new IOItem("Y203", qsTr("Y203")),
                new IOItem("Y204", qsTr("Y204")),
                new IOItem("Y205", qsTr("Y205")),
                new IOItem("Y206", qsTr("Y206")),
                new IOItem("Y207", qsTr("Y207")),
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
                new IOItem("X060", qsTr("X060")),
                new IOItem("X061", qsTr("X061")),
                new IOItem("X062", qsTr("X062")),
                new IOItem("X063", qsTr("X063")),
                new IOItem("X064", qsTr("X064")),
                new IOItem("X065", qsTr("X065")),
                new IOItem("X066", qsTr("X066")),
                new IOItem("X067", qsTr("X067")),
                new IOItem("X070", qsTr("X070")),
                new IOItem("X071", qsTr("X071")),
                new IOItem("X072", qsTr("X072")),
                new IOItem("X073", qsTr("X073")),
                new IOItem("X074", qsTr("X074")),
                new IOItem("X075", qsTr("X075")),
                new IOItem("X076", qsTr("X076")),
                new IOItem("X077", qsTr("X077")),
                new IOItem("X100", qsTr("X100")),
                new IOItem("X101", qsTr("X101")),
                new IOItem("X102", qsTr("X102")),
                new IOItem("X103", qsTr("X103")),
                new IOItem("X104", qsTr("X104")),
                new IOItem("X105", qsTr("X105")),
                new IOItem("X106", qsTr("X106")),
                new IOItem("X107", qsTr("X107")),

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

                new IOItem("X150", qsTr("X150")),
                new IOItem("X151", qsTr("X151")),
                new IOItem("X152", qsTr("X152")),
                new IOItem("X153", qsTr("X153")),
                new IOItem("X154", qsTr("X154")),
                new IOItem("X155", qsTr("X155")),
                new IOItem("X156", qsTr("X156")),
                new IOItem("X157", qsTr("X157")),
                new IOItem("X160", qsTr("X160")),
                new IOItem("X161", qsTr("X161")),
                new IOItem("X162", qsTr("X162")),
                new IOItem("X163", qsTr("X163")),
                new IOItem("X164", qsTr("X164")),
                new IOItem("X165", qsTr("X165")),
                new IOItem("X166", qsTr("X166")),
                new IOItem("X167", qsTr("X167")),
                new IOItem("X170", qsTr("X170")),
                new IOItem("X171", qsTr("X171")),
                new IOItem("X172", qsTr("X172")),
                new IOItem("X173", qsTr("X173")),
                new IOItem("X174", qsTr("X174")),
                new IOItem("X175", qsTr("X175")),
                new IOItem("X176", qsTr("X176")),
                new IOItem("X177", qsTr("X177")),
                new IOItem("X200", qsTr("X200")),
                new IOItem("X201", qsTr("X201")),
                new IOItem("X202", qsTr("X202")),
                new IOItem("X203", qsTr("X203")),
                new IOItem("X204", qsTr("X204")),
                new IOItem("X205", qsTr("X205")),
                new IOItem("X206", qsTr("X206")),
                new IOItem("X207", qsTr("X207")),
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

    "valve0"   : new ValveItem(0,   qsTr("Normal Y010"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 0),
    "valve1"   : new ValveItem(1,   qsTr("Normal Y011"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 1),
    "valve2"   : new ValveItem(2,   qsTr("Normal Y012"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 2),
    "valve3"   : new ValveItem(3,   qsTr("Normal Y013"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 3),
    "valve4"   : new ValveItem(4,   qsTr("Normal Y014"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 4),
    "valve5"   : new ValveItem(5,   qsTr("Normal Y015"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 5),
    "valve6"   : new ValveItem(6,   qsTr("Normal Y016"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 6),
    "valve7"   : new ValveItem(7,   qsTr("Normal Y017"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 7),
    "valve8"   : new ValveItem(8,   qsTr("Normal Y020"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 8),
    "valve9"   : new ValveItem(9,   qsTr("Normal Y021"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 9),
    "valve10"  : new ValveItem(10,  qsTr("Normal Y022"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 10),
    "valve11"  : new ValveItem(11,  qsTr("Normal Y023"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 11),
    "valve12"  : new ValveItem(12,  qsTr("Normal Y024"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 12),
    "valve13"  : new ValveItem(13,  qsTr("Normal Y025"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 13),
    "valve14"  : new ValveItem(14,  qsTr("Normal Y026"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 14),
    "valve15"  : new ValveItem(15,  qsTr("Normal Y027"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 15),
    "valve16"  : new ValveItem(16,  qsTr("Normal Y030"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 16),
    "valve17"  : new ValveItem(17,  qsTr("Normal Y031"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 17),
    "valve18"  : new ValveItem(18,  qsTr("Normal Y032"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 18),
    "valve19"  : new ValveItem(19,  qsTr("Normal Y033"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 19),
    "valve20"  : new ValveItem(20,  qsTr("Normal Y034"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 20),
    "valve21"  : new ValveItem(21,  qsTr("Normal Y035"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 21),
    "valve22"  : new ValveItem(22,  qsTr("Normal Y036"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 22),
    "valve23"  : new ValveItem(23,  qsTr("Normal Y037"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 23),
    "valve24"  : new ValveItem(24,  qsTr("Normal Y040"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 24),
    "valve25"  : new ValveItem(25,  qsTr("Normal Y041"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 25),
    "valve26"  : new ValveItem(26,  qsTr("Normal Y042"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 26),
    "valve27"  : new ValveItem(27,  qsTr("Normal Y043"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 27),
    "valve28"  : new ValveItem(28,  qsTr("Normal Y044"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 28),
    "valve29"  : new ValveItem(29,  qsTr("Normal Y045"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 29),
    "valve30"  : new ValveItem(30,  qsTr("Normal Y046"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 30),
    "valve31"  : new ValveItem(31,  qsTr("Normal Y047"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 31),

    "mValve0"  : new ValveItem(32,  qsTr("M010"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 0),
    "mValve1"  : new ValveItem(33,  qsTr("M011"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 1),
    "mValve2"  : new ValveItem(34,  qsTr("M012"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 2),
    "mValve3"  : new ValveItem(35,  qsTr("M013"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 3),
    "mValve4"  : new ValveItem(36,  qsTr("M014"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 4),
    "mValve5"  : new ValveItem(37,  qsTr("M015"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 5),
    "mValve6"  : new ValveItem(38,  qsTr("M016"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 6),
    "mValve7"  : new ValveItem(39,  qsTr("M017"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 7),
    "mValve8"  : new ValveItem(40,  qsTr("M020"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 8),
    "mValve9"  : new ValveItem(41,  qsTr("M021"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 9),
    "mValve10" : new ValveItem(42,  qsTr("M022"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 10),
    "mValve11" : new ValveItem(43,  qsTr("M023"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 11),
    "mValve12" : new ValveItem(44,  qsTr("M024"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 12),
    "mValve13" : new ValveItem(45,  qsTr("M025"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 13),
    "mValve14" : new ValveItem(46,  qsTr("M026"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 14),
    "mValve15" : new ValveItem(47,  qsTr("M027"), IO_TYPE_NORMAL_Y, 0, M_BOARD_0, 15),

    "tValve0"  : new ValveItem(48,  qsTr("Time Y010"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 0),
    "tValve1"  : new ValveItem(49,  qsTr("Time Y011"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 1),
    "tValve2"  : new ValveItem(50,  qsTr("Time Y012"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 2),
    "tValve3"  : new ValveItem(51,  qsTr("Time Y013"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 3),
    "tValve4"  : new ValveItem(52,  qsTr("Time Y014"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 4),
    "tValve5"  : new ValveItem(53,  qsTr("Time Y015"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 5),
    "tValve6"  : new ValveItem(54,  qsTr("Time Y016"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 6),
    "tValve7"  : new ValveItem(55,  qsTr("Time Y017"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 7),
    "tValve8"  : new ValveItem(56,  qsTr("Time Y020"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 8),
    "tValve9"  : new ValveItem(57,  qsTr("Time Y021"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 9),
    "tValve10" : new ValveItem(58,  qsTr("Time Y022"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 10),
    "tValve11" : new ValveItem(59,  qsTr("Time Y023"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 11),
    "tValve12" : new ValveItem(60,  qsTr("Time Y024"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 12),
    "tValve13" : new ValveItem(61,  qsTr("Time Y025"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 13),
    "tValve14" : new ValveItem(62,  qsTr("Time Y026"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 14),
    "tValve15" : new ValveItem(63,  qsTr("Time Y027"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 15),
    "tValve16" : new ValveItem(64,  qsTr("Time Y030"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 16),
    "tValve17" : new ValveItem(65,  qsTr("Time Y031"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 17),
    "tValve18" : new ValveItem(66,  qsTr("Time Y032"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 18),
    "tValve19" : new ValveItem(67,  qsTr("Time Y033"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 19),
    "tValve20" : new ValveItem(68,  qsTr("Time Y034"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 20),
    "tValve21" : new ValveItem(69,  qsTr("Time Y035"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 21),
    "tValve22" : new ValveItem(70,  qsTr("Time Y036"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 22),
    "tValve23" : new ValveItem(71,  qsTr("Time Y037"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 23),
    "tValve24" : new ValveItem(72,  qsTr("Time Y040"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 24),
    "tValve25" : new ValveItem(73,  qsTr("Time Y041"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 25),
    "tValve26" : new ValveItem(74,  qsTr("Time Y042"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 26),
    "tValve27" : new ValveItem(75,  qsTr("Time Y043"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 27),
    "tValve28" : new ValveItem(76,  qsTr("Time Y044"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 28),
    "tValve29" : new ValveItem(77,  qsTr("Time Y045"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 29),
    "tValve30" : new ValveItem(78,  qsTr("Time Y046"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 30),
    "tValve31" : new ValveItem(79,  qsTr("Time Y047"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_0, 31),

    "valve32"  : new ValveItem(80,  qsTr("Normal Y050"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 0),
    "valve33"  : new ValveItem(81,  qsTr("Normal Y051"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 1),
    "valve34"  : new ValveItem(82,  qsTr("Normal Y052"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 2),
    "valve35"  : new ValveItem(83,  qsTr("Normal Y053"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 3),
    "valve36"  : new ValveItem(84,  qsTr("Normal Y054"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 4),
    "valve37"  : new ValveItem(85,  qsTr("Normal Y055"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 5),
    "valve38"  : new ValveItem(86,  qsTr("Normal Y056"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 6),
    "valve39"  : new ValveItem(87,  qsTr("Normal Y057"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 7),
    "valve40"  : new ValveItem(88,  qsTr("Normal Y060"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 8),
    "valve41"  : new ValveItem(89,  qsTr("Normal Y061"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 9),
    "valve42"  : new ValveItem(90,  qsTr("Normal Y062"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 10),
    "valve43"  : new ValveItem(91,  qsTr("Normal Y063"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 11),
    "valve44"  : new ValveItem(92,  qsTr("Normal Y064"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 12),
    "valve45"  : new ValveItem(93,  qsTr("Normal Y065"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 13),
    "valve46"  : new ValveItem(94,  qsTr("Normal Y066"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 14),
    "valve47"  : new ValveItem(95,  qsTr("Normal Y067"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 15),
    "valve48"  : new ValveItem(96,  qsTr("Normal Y070"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 16),
    "valve49"  : new ValveItem(97,  qsTr("Normal Y071"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 17),
    "valve50"  : new ValveItem(98,  qsTr("Normal Y072"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 18),
    "valve51"  : new ValveItem(99,  qsTr("Normal Y073"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 19),
    "valve52"  : new ValveItem(100, qsTr("Normal Y074"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 20),
    "valve53"  : new ValveItem(101, qsTr("Normal Y075"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 21),
    "valve54"  : new ValveItem(102, qsTr("Normal Y076"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 22),
    "valve55"  : new ValveItem(103, qsTr("Normal Y077"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 23),
    "valve56"  : new ValveItem(104, qsTr("Normal Y100"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 24),
    "valve57"  : new ValveItem(105, qsTr("Normal Y101"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 25),
    "valve58"  : new ValveItem(106, qsTr("Normal Y102"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 26),
    "valve59"  : new ValveItem(107, qsTr("Normal Y103"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 27),
    "valve60"  : new ValveItem(108, qsTr("Normal Y104"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 28),
    "valve61"  : new ValveItem(109, qsTr("Normal Y105"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 29),
    "valve62"  : new ValveItem(110, qsTr("Normal Y106"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 30),
    "valve63"  : new ValveItem(111, qsTr("Normal Y107"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 31),

    "valve64"  : new ValveItem(112, qsTr("Normal Y110"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 0),
    "valve65"  : new ValveItem(113, qsTr("Normal Y111"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 1),
    "valve66"  : new ValveItem(114, qsTr("Normal Y112"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 2),
    "valve67"  : new ValveItem(115, qsTr("Normal Y113"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 3),
    "valve68"  : new ValveItem(116, qsTr("Normal Y114"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 4),
    "valve69"  : new ValveItem(117, qsTr("Normal Y115"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 5),
    "valve70"  : new ValveItem(118, qsTr("Normal Y116"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 6),
    "valve71"  : new ValveItem(119, qsTr("Normal Y117"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 7),
    "valve72"  : new ValveItem(120, qsTr("Normal Y120"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 8),
    "valve73"  : new ValveItem(121, qsTr("Normal Y121"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 9),
    "valve74"  : new ValveItem(122, qsTr("Normal Y122"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 10),
    "valve75"  : new ValveItem(123, qsTr("Normal Y123"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 11),
    "valve76"  : new ValveItem(124, qsTr("Normal Y124"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 12),
    "valve77"  : new ValveItem(125, qsTr("Normal Y125"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 13),
    "valve78"  : new ValveItem(126, qsTr("Normal Y126"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 14),
    "valve79"  : new ValveItem(127, qsTr("Normal Y127"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 15),
    "valve80"  : new ValveItem(128, qsTr("Normal Y130"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 16),
    "valve81"  : new ValveItem(129, qsTr("Normal Y131"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 17),
    "valve82"  : new ValveItem(130, qsTr("Normal Y132"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 18),
    "valve83"  : new ValveItem(131, qsTr("Normal Y133"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 19),
    "valve84"  : new ValveItem(132, qsTr("Normal Y134"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 20),
    "valve85"  : new ValveItem(133, qsTr("Normal Y135"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 21),
    "valve86"  : new ValveItem(134, qsTr("Normal Y136"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 22),
    "valve87"  : new ValveItem(135, qsTr("Normal Y137"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 23),
    "valve88"  : new ValveItem(136, qsTr("Normal Y140"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 24),
    "valve89"  : new ValveItem(137, qsTr("Normal Y141"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 25),
    "valve90"  : new ValveItem(138, qsTr("Normal Y142"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 26),
    "valve91"  : new ValveItem(139, qsTr("Normal Y143"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 27),
    "valve92"  : new ValveItem(140, qsTr("Normal Y144"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 28),
    "valve93"  : new ValveItem(141, qsTr("Normal Y145"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 29),
    "valve94"  : new ValveItem(142, qsTr("Normal Y146"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 30),
    "valve95"  : new ValveItem(143, qsTr("Normal Y147"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 31),

    "valve96"  : new ValveItem(144, qsTr("Normal Y150"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 0),
    "valve97"  : new ValveItem(145, qsTr("Normal Y151"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 1),
    "valve98"  : new ValveItem(146, qsTr("Normal Y152"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 2),
    "valve99"  : new ValveItem(147, qsTr("Normal Y153"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 3),
    "valve100" : new ValveItem(148, qsTr("Normal Y154"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 4),
    "valve101" : new ValveItem(149, qsTr("Normal Y155"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 5),
    "valve102" : new ValveItem(150, qsTr("Normal Y156"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 6),
    "valve103" : new ValveItem(151, qsTr("Normal Y157"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 7),
    "valve104" : new ValveItem(152, qsTr("Normal Y160"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 8),
    "valve105" : new ValveItem(153, qsTr("Normal Y161"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 9),
    "valve106" : new ValveItem(154, qsTr("Normal Y162"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 10),
    "valve107" : new ValveItem(155, qsTr("Normal Y163"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 11),
    "valve108" : new ValveItem(156, qsTr("Normal Y164"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 12),
    "valve109" : new ValveItem(157, qsTr("Normal Y165"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 13),
    "valve110" : new ValveItem(158, qsTr("Normal Y166"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 14),
    "valve111" : new ValveItem(159, qsTr("Normal Y167"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 15),
    "valve112" : new ValveItem(160, qsTr("Normal Y170"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 16),
    "valve113" : new ValveItem(161, qsTr("Normal Y171"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 17),
    "valve114" : new ValveItem(162, qsTr("Normal Y172"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 18),
    "valve115" : new ValveItem(163, qsTr("Normal Y173"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 19),
    "valve116" : new ValveItem(164, qsTr("Normal Y174"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 20),
    "valve117" : new ValveItem(165, qsTr("Normal Y175"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 21),
    "valve118" : new ValveItem(166, qsTr("Normal Y176"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 22),
    "valve119" : new ValveItem(167, qsTr("Normal Y177"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 23),
    "valve120" : new ValveItem(168, qsTr("Normal Y200"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 24),
    "valve121" : new ValveItem(169, qsTr("Normal Y201"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 25),
    "valve122" : new ValveItem(170, qsTr("Normal Y202"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 26),
    "valve123" : new ValveItem(171, qsTr("Normal Y203"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 27),
    "valve124" : new ValveItem(172, qsTr("Normal Y204"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 28),
    "valve125" : new ValveItem(173, qsTr("Normal Y205"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 29),
    "valve126" : new ValveItem(174, qsTr("Normal Y206"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 30),
    "valve127" : new ValveItem(175, qsTr("Normal Y207"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 31),


    "tValve32" : new ValveItem(176, qsTr("Normal Y050"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 0),
    "tValve33" : new ValveItem(177, qsTr("Normal Y051"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 1),
    "tValve34" : new ValveItem(178, qsTr("Normal Y052"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 2),
    "tValve35" : new ValveItem(179, qsTr("Normal Y053"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 3),
    "tValve36" : new ValveItem(180, qsTr("Normal Y054"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 4),
    "tValve37" : new ValveItem(181, qsTr("Normal Y055"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 5),
    "tValve38" : new ValveItem(182, qsTr("Normal Y056"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 6),
    "tValve39" : new ValveItem(183, qsTr("Normal Y057"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 7),
    "tValve40" : new ValveItem(184, qsTr("Normal Y060"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 8),
    "tValve41" : new ValveItem(185, qsTr("Normal Y061"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 9),
    "tValve42" : new ValveItem(186, qsTr("Normal Y062"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 10),
    "tValve43" : new ValveItem(187, qsTr("Normal Y063"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 11),
    "tValve44" : new ValveItem(188, qsTr("Normal Y064"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 12),
    "tValve45" : new ValveItem(189, qsTr("Normal Y065"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 13),
    "tValve46" : new ValveItem(190, qsTr("Normal Y066"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 14),
    "tValve47" : new ValveItem(191, qsTr("Normal Y067"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 15),
    "tValve48" : new ValveItem(192, qsTr("Normal Y070"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 16),
    "tValve49" : new ValveItem(193, qsTr("Normal Y071"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 17),
    "tValve50" : new ValveItem(194, qsTr("Normal Y072"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 18),
    "tValve51" : new ValveItem(195, qsTr("Normal Y073"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 19),
    "tValve52" : new ValveItem(196, qsTr("Normal Y074"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 20),
    "tValve53" : new ValveItem(197, qsTr("Normal Y075"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 21),
    "tValve54" : new ValveItem(198, qsTr("Normal Y076"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 22),
    "tValve55" : new ValveItem(199, qsTr("Normal Y077"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 23),
    "tValve56" : new ValveItem(200, qsTr("Normal Y100"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 24),
    "tValve57" : new ValveItem(201, qsTr("Normal Y101"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 25),
    "tValve58" : new ValveItem(202, qsTr("Normal Y102"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 26),
    "tValve59" : new ValveItem(203, qsTr("Normal Y103"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 27),
    "tValve60" : new ValveItem(204, qsTr("Normal Y104"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 28),
    "tValve61" : new ValveItem(205, qsTr("Normal Y105"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 29),
    "tValve62" : new ValveItem(206, qsTr("Normal Y106"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 30),
    "tValve63" : new ValveItem(207, qsTr("Normal Y107"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_1, 31),

    "tValve64" : new ValveItem(208, qsTr("Normal Y110"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 0),
    "tValve65" : new ValveItem(209, qsTr("Normal Y111"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 1),
    "tValve66" : new ValveItem(210, qsTr("Normal Y112"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 2),
    "tValve67" : new ValveItem(211, qsTr("Normal Y113"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 3),
    "tValve68" : new ValveItem(212, qsTr("Normal Y114"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 4),
    "tValve69" : new ValveItem(213, qsTr("Normal Y115"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 5),
    "tValve70" : new ValveItem(214, qsTr("Normal Y116"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 6),
    "tValve71" : new ValveItem(215, qsTr("Normal Y117"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 7),
    "tValve72" : new ValveItem(216, qsTr("Normal Y120"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 8),
    "tValve73" : new ValveItem(217, qsTr("Normal Y121"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 9),
    "tValve74" : new ValveItem(218, qsTr("Normal Y122"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 10),
    "tValve75" : new ValveItem(219, qsTr("Normal Y123"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 11),
    "tValve76" : new ValveItem(220, qsTr("Normal Y124"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 12),
    "tValve77" : new ValveItem(221, qsTr("Normal Y125"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 13),
    "tValve78" : new ValveItem(222, qsTr("Normal Y126"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 14),
    "tValve79" : new ValveItem(223, qsTr("Normal Y127"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 15),
    "tValve80" : new ValveItem(224, qsTr("Normal Y130"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 16),
    "tValve81" : new ValveItem(225, qsTr("Normal Y131"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 17),
    "tValve82" : new ValveItem(226, qsTr("Normal Y132"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 18),
    "tValve83" : new ValveItem(227, qsTr("Normal Y133"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 19),
    "tValve84" : new ValveItem(228, qsTr("Normal Y134"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 20),
    "tValve85" : new ValveItem(229, qsTr("Normal Y135"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 21),
    "tValve86" : new ValveItem(230, qsTr("Normal Y136"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 22),
    "tValve87" : new ValveItem(231, qsTr("Normal Y137"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 23),
    "tValve88" : new ValveItem(232, qsTr("Normal Y140"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 24),
    "tValve89" : new ValveItem(233, qsTr("Normal Y141"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 25),
    "tValve90" : new ValveItem(234, qsTr("Normal Y142"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 26),
    "tValve91" : new ValveItem(235, qsTr("Normal Y143"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 27),
    "tValve92" : new ValveItem(236, qsTr("Normal Y144"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 28),
    "tValve93" : new ValveItem(237, qsTr("Normal Y145"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 29),
    "tValve94" : new ValveItem(238, qsTr("Normal Y146"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 30),
    "tValve95" : new ValveItem(239, qsTr("Normal Y147"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_2, 31),

    "tValve96" : new ValveItem(240, qsTr("Normal Y150"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 0),
    "tValve97" : new ValveItem(241, qsTr("Normal Y151"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 1),
    "tValve98" : new ValveItem(242, qsTr("Normal Y152"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 2),
    "tValve99" : new ValveItem(243, qsTr("Normal Y153"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 3),
    "tValve100": new ValveItem(244, qsTr("Normal Y154"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 4),
    "tValve101": new ValveItem(245, qsTr("Normal Y155"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 5),
    "tValve102": new ValveItem(246, qsTr("Normal Y156"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 6),
    "tValve103": new ValveItem(247, qsTr("Normal Y157"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 7),
    "tValve104": new ValveItem(248, qsTr("Normal Y160"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 8),
    "tValve105": new ValveItem(249, qsTr("Normal Y161"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 9),
    "tValve106": new ValveItem(250, qsTr("Normal Y162"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 10),
    "tValve107": new ValveItem(251, qsTr("Normal Y163"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 11),
    "tValve108": new ValveItem(252, qsTr("Normal Y164"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 12),
    "tValve109": new ValveItem(253, qsTr("Normal Y165"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 13),
    "tValve110": new ValveItem(254, qsTr("Normal Y166"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 14),
    "tValve111": new ValveItem(255, qsTr("Normal Y167"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 15),
    "tValve112": new ValveItem(256, qsTr("Normal Y170"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 16),
    "tValve113": new ValveItem(257, qsTr("Normal Y171"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 17),
    "tValve114": new ValveItem(258, qsTr("Normal Y172"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 18),
    "tValve115": new ValveItem(259, qsTr("Normal Y173"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 19),
    "tValve116": new ValveItem(260, qsTr("Normal Y174"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 20),
    "tValve117": new ValveItem(261, qsTr("Normal Y175"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 21),
    "tValve118": new ValveItem(262, qsTr("Normal Y176"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 22),
    "tValve119": new ValveItem(263, qsTr("Normal Y177"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 23),
    "tValve120": new ValveItem(264, qsTr("Normal Y200"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 24),
    "tValve121": new ValveItem(265, qsTr("Normal Y201"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 25),
    "tValve122": new ValveItem(266, qsTr("Normal Y202"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 26),
    "tValve123": new ValveItem(267, qsTr("Normal Y203"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 27),
    "tValve124": new ValveItem(268, qsTr("Normal Y204"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 28),
    "tValve125": new ValveItem(269, qsTr("Normal Y205"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 29),
    "tValve126": new ValveItem(270, qsTr("Normal Y206"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 30),
    "tValve127": new ValveItem(271, qsTr("Normal Y207"), IO_TYPE_NORMAL_Y, 1, IO_BOARD_3, 31),
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
                vd.autoCheck = customValves[i].autoCheck;
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
