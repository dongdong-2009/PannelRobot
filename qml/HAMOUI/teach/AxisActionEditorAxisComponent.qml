import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Row{
    id:axis
    property string axisName: ""
    property alias psName:ps.items
    property int axisDefine: 0
    property int editorWidth: 80

    function getAxisActionInfo(){
        if(!box.isChecked) return null;
        var ret = {};
        if(pos.visible) {
            ret.pos = pos.text;
            ret.speed = speed.text
        }
        else if(ps.visible) ret.ps = ps.currentIndex;
        ret.delay = delay.text
        return ret;
    }

    spacing: 10
    visible: {
        return axisDefine != Teach.kAxisType_NoUse &&
                axisDefine != Teach.kAxisType_Reserve
    }

    ICCheckBox{
        id:box
        text: axisName
        width: editorWidth
    }
    ICTextEdit{
        id:pos
        width: editorWidth
        visible: axisDefine == Teach.kAxisType_Servo
        unit: qsTr("mm")
    }
    ICComboBox{
        id:ps
        width: editorWidth
        visible: axisDefine == Teach.kAxisType_Pneumatic
    }
    ICTextEdit{
        id:speed
        width: editorWidth
        visible: axisDefine == Teach.kAxisType_Servo
        unit: qsTr("%")
    }
    ICTextEdit{
        id:delay
        width: editorWidth
        unit: qsTr("s")
    }

    onVisibleChanged: {
        if(!visible){
            box.setChecked(false);
        }
    }
}
