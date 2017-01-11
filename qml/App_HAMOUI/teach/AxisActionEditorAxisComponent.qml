import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Row{
    id:axis
    property string axisName: ""
    property alias psName:ps.items
    property bool posvisible: pos.visible
    property bool psvisible: ps.visible
    property int axisDefine: 0
    property int editorWidth: 80
    property alias rangeAddr: pos.bindConfig
    property alias angle: pos.text
    property alias unit: pos.unit
    property alias mode: axis.state
    property alias relPoints: relPoint.items
    property alias popupMode: relPoint.popupMode

    function getAxisActionInfo(){
        if(!box.isChecked) return null;
        var ret = {};
        if(pos.visible) {
            ret.pos = pos.text;
            ret.speed = speed.text
        }
        else if(ps.visible) ret.ps = ps.currentIndex;
        else if(relPoint.visible) {
            var pt = Teach.definedPoints.getPoint(relPoint.currentText());
            ret.point = {"pointName":pt.name, "pos":pt.point};
            ret.speed = speed.text;
            ret.pos = 0;
        }
        ret.delay = delay.text
        return ret;
    }

    spacing: 10
    visible: {
        return axisDefine != Teach.kAxisType_NoUse &&
                axisDefine != Teach.kAxisType_Reserve
    }

    states: [
        State {
            name: "psMode"
            PropertyChanges {target: pos; visible:false;}
            PropertyChanges {target: relPoint; visible:false;}
            PropertyChanges {target: ps; visible:true;}
        },
        State {
            name: "relPointMode"
            PropertyChanges {target: pos; visible:false;}
            PropertyChanges {target: ps; visible:false;}
            PropertyChanges {target: relPoint; visible:true;}
        }
    ]

    ICCheckBox{
        id:box
        text: axisName
        width: 50
    }
    ICLineEdit{
        id:pos
//        width: editorWidth + 25
        inputWidth: editorWidth
        visible: axisDefine == Teach.kAxisType_Servo
        bindConfig: rangeAddr
        unit: qsTr("deg")

    }
    ICComboBox{
        id:ps
        width: editorWidth
        visible: axisDefine == Teach.kAxisType_Pneumatic
    }
    ICComboBox{
        id:relPoint
        width: pos.width
        visible: false
        popupHeight: 100
        popupMode: 1
    }

    ICLineEdit{
        id:speed
        inputWidth: editorWidth - 20
        visible: axisDefine == Teach.kAxisType_Servo
        unit: qsTr("%")
        text: "80.0"
        bindConfig: "s_rw_0_32_1_1200"
    }
    ICLineEdit{
        id:delay
        inputWidth: editorWidth - 15
        unit: qsTr("s")
        text:"0.00"
        bindConfig: "s_rw_0_32_2_1100"
    }

    onVisibleChanged: {
        if(!visible){
            box.setChecked(false);
        }
    }

}
