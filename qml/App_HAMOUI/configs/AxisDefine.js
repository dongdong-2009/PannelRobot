.pragma library

function AxisInfo(id, name, unit, wAddr, jAddr, sAddr,rangeAddr){
    this.id = id;
    this.name = name;
    this.unit = unit;
    this.visiable = true;
    this.wAddr = wAddr;
    this.jAddr = jAddr;
    this.sAddr = sAddr;
    this.rangeAddr = rangeAddr;
}

var kAP_X = 1;
var kAP_Y = 2;
var kAP_Z = 3;
var kAP_U = 4;
var kAP_V = 5;
var kAP_W = 6;
var kAP_LX = 7;
var kAP_LY = 8;
var kAP_LZ = 9;
var kAP_RU = 10;
var kAP_RV = 11;
var kAP_RW = 12;


var axisInfos = [new AxisInfo(0, qsTr("X"), qsTr("mm"), "c_ro_0_32_3_900", "c_ro_0_32_0_901", "s_rw_0_16_1_294", "s_rw_0_32_3_1000"),
                 new AxisInfo(1, qsTr("Y"), qsTr("mm"), "c_ro_0_32_3_904", "c_ro_0_32_0_905", "s_rw_16_16_1_294", "s_rw_0_32_3_1001"),
                 new AxisInfo(2, qsTr("Z"), qsTr("mm"), "c_ro_0_32_3_908", "c_ro_0_32_0_909", "s_rw_0_16_1_295","s_rw_0_32_3_1002"),
                 new AxisInfo(3, qsTr("U"), qsTr("°"), "c_ro_0_32_3_912", "c_ro_0_32_0_913", "s_rw_16_16_1_295","s_rw_0_32_3_1003"),
                 new AxisInfo(4, qsTr("V"), qsTr("°"), "c_ro_0_32_3_916", "c_ro_0_32_0_917", "s_rw_0_16_1_296","s_rw_0_32_3_1004"),
                 new AxisInfo(5, qsTr("W"), qsTr("°"), "c_ro_0_32_3_920", "c_ro_0_32_0_921", "s_rw_16_16_1_296","s_rw_0_32_3_1005"),
                 new AxisInfo(6, qsTr("M7"), qsTr("mm"), "c_ro_0_32_3_924", "c_ro_0_32_0_925", "s_rw_0_16_1_297","s_rw_0_32_3_1006"),
                 new AxisInfo(7, qsTr("M8"), qsTr("mm"), "c_ro_0_32_3_928", "c_ro_0_32_0_929", "s_rw_16_16_1_297","s_rw_0_32_3_1007")];


var axisDefineMonitors = [];
function registerMonitors(obj){
    axisDefineMonitors.push(obj);
}

function informMonitors(){
    for(var i = 0, len = axisDefineMonitors.length; i < len; ++i){
        if(axisDefineMonitors[i].hasOwnProperty("onAxisDefinesChanged"))
            axisDefineMonitors[i]["onAxisDefinesChanged"]();
    }
}

function changeAxisNum(num){
    for(var i = 0, len = axisInfos.length; i < len; ++i){
        axisInfos[i].visiable = true;
    }
    for(i = num; i < len; ++i){
        axisInfos[i].visiable = false;
    }
    informMonitors();
}

function changeAxisUnit(id, axisType){
    var unit = (axisType == 1 ? qsTr("mm") : qsTr("°"));
    if(axisInfos[id].unit != unit){
        axisInfos[id].unit = unit;
        informMonitors();
    }
}

function usedAxisNum(){
    var c = 0;
    for(var i = 0, len = axisInfos.length; i < len; ++i){
        if(axisInfos[i].visiable) ++c;
    }
    return c;
}

function getAxisNum(){return axisInfos.length}
function isAxisUsed(id){return axisInfos[id].visiable}

function usedAxisNameList(){
    var ret = [];
    for(var i = 0, len = axisInfos.length; i < len; ++i){
        if(axisInfos[i].visiable) ret.push(axisInfos[i].name);
    }
    return ret;
}

function changeAxisVisble(m,num){
    for(var i=0;i<num;++i){
        axisInfos[i].visiable = m[i]===1?false:true;
    }
    informMonitors();
}
