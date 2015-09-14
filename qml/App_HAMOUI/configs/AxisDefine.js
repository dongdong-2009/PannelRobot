.pragma library

function AxisInfo(id, name, unit){
    this.id = id;
    this.name = name;
    this.unit = unit;
}

var axisInfos = [new AxisInfo(0, qsTr("M1"), qsTr("mm")),
                 new AxisInfo(1, qsTr("M2"), qsTr("mm")),
                 new AxisInfo(2, qsTr("M3"), qsTr("mm")),
                 new AxisInfo(3, qsTr("M4"), qsTr("mm")),
                 new AxisInfo(4, qsTr("M5"), qsTr("mm")),
                 new AxisInfo(5, qsTr("M6"), qsTr("mm")),
                 new AxisInfo(6, qsTr("M7"), qsTr("mm")),
                 new AxisInfo(7, qsTr("M8"), qsTr("mm"))];
