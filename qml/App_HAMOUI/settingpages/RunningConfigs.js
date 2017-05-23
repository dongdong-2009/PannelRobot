.pragma library

Qt.include("../configs/IODefines.js")

var moldbyIOData = [];

var ledKesSetData =[];
var xDefinesList = [];
var yDefinesList=[];
var yList=[];
var mDefinesList=[];
var yOutList=[];
var mOutList=[];
var programList=[];
var programIDList=[];
var barnLogicList=[];

function getOutIDFromConfig(cV){
    var ret = [];
    var isNormal,id;
    var valve = yOutList[cV];
    if(valve.type == IO_TYPE_NORMAL_Y){
        isNormal = true;
    }
    else{
        isNormal = false;
    }
    ret.push(isNormal);
    if(isNormal){
        id = valve.y1Point+valve.y1Board*32;
    }
    else{
        id = valve.id;
    }
    ret.push(id);
    return ret;
}

