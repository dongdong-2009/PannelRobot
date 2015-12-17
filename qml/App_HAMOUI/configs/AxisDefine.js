.pragma library

function AxisInfo(id, name, unit){
    this.id = id;
    this.name = name;
    this.unit = unit;
}

var axisInfos = [new AxisInfo(0, qsTr("X"), qsTr("mm")),
                 new AxisInfo(1, qsTr("Y"), qsTr("mm")),
                 new AxisInfo(2, qsTr("Z"), qsTr("mm")),
                 new AxisInfo(3, qsTr("U"), qsTr("mm")),
                 new AxisInfo(4, qsTr("V"), qsTr("mm")),
                 new AxisInfo(5, qsTr("W"), qsTr("mm")),
                 new AxisInfo(6, qsTr("M7"), qsTr("mm")),
                 new AxisInfo(7, qsTr("M8"), qsTr("mm"))];
