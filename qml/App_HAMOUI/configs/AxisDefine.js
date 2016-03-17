.pragma library

function AxisInfo(id, name, unit){
    this.id = id;
    this.name = name;
    this.unit = unit;
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

var axisInfos = [new AxisInfo(0, qsTr("X"), qsTr("mm")),
                 new AxisInfo(1, qsTr("Y"), qsTr("mm")),
                 new AxisInfo(2, qsTr("Z"), qsTr("mm")),
                 new AxisInfo(3, qsTr("U"), qsTr("mm")),
                 new AxisInfo(4, qsTr("V"), qsTr("mm")),
                 new AxisInfo(5, qsTr("W"), qsTr("mm")),
                 new AxisInfo(6, qsTr("M7"), qsTr("mm")),
                 new AxisInfo(7, qsTr("M8"), qsTr("mm"))];


