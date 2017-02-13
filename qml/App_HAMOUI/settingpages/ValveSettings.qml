import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/IODefines.js" as IODefines
import "../../utils/Storage.js" as Storage
import "ValveSettings.js" as PData



Item {
    ListModel{
        id:valveModel
    }

    ICButton{
        id:saveBtn
        text: qsTr("Confirm")
        onButtonClicked: {
            var d;
            for(var s in PData.changedData){
                d = PData.changedData[s];
//                valveModel.set(s, {"x1Dir":d.x1Dir, "x2Dir":d.x2Dir, "time":d.time, "autoCheck":d.autoCheck });
                valveModel.set(s, d);
            }
            var valveDefines = []
            for(var i = 0; i < valveModel.count; ++i){
                valveDefines.push(valveModel.get(i));
            }
            valveDefines = JSON.stringify(valveDefines);
            Storage.setSetting(panelRobotController.currentRecordName() + "_valve", valveDefines);
            IODefines.combineValveDefines(Storage.getSetting(panelRobotController.currentRecordName() + "_valve"));
            panelRobotController.initValveDefines(valveDefines);
            PData.changedData = [];
        }
    }

    GridView{
        id:valveContainer
        anchors.top: saveBtn.bottom
        anchors.topMargin: 6
        //        model: valveModel
        cellWidth: width  -10
        cellHeight: 32
        width: parent.width
        height: parent.height
        delegate: Row{
            spacing: 4
            z: valveModel.count - index;

            Text {
                text: descr
                width: 150
                anchors.verticalCenter: parent.verticalCenter
            }
            ICComboBox{
                currentIndex: x1Dir
                items: [qsTr("RP"), qsTr("PP")]
                width: 70
                onCurrentIndexChanged: {
                    PData.changeX1Dir(index, valveModel.get(index).id, currentIndex);
                }
            }
            ICComboBox{
                enabled: (type == IODefines.IO_TYPE_HOLD_DOUBLE_Y) || (type == IODefines.IO_TYPE_UNHOLD_DOUBLE_Y)
                currentIndex: x2Dir
                items: [qsTr("RP"), qsTr("PP")]
                width: 70
                onCurrentIndexChanged: {
                    PData.changeX2Dir(index, valveModel.get(index).id, currentIndex);
                }
            }
            ICLineEdit{
                text: time.toFixed(1);
                unit: "s"
                bindConfig: "s_rw_0_32_1_1201"
                onTextChanged: {
                    PData.changeTime(index, valveModel.get(index).id, text);
                }
            }
            ICCheckBox{
                text:qsTr("Auto Check")
                isChecked: autoCheck
                onIsCheckedChanged:     PData.changeAutoCheck(index, valveModel.get(index).id, isChecked  );
            }
        }
    }

    function onMoldChanged(){
        valveContainer.model = null;
        valveModel.clear();
        PData.changedData = [];
        IODefines.combineValveDefines(Storage.getSetting(panelRobotController.currentRecordName() + "_valve"));
        panelRobotController.initValveDefines(IODefines.valveDefinesJSON());
//        console.log("_valve",Storage.getSetting(panelRobotController.currentRecordName() + "_valve"));
        Storage.setSetting(panelRobotController.currentRecordName() + "_valve",IODefines.valveDefinesJSON());
//        console.log("IODefines",IODefines.valveDefinesJSON());
        var vds = IODefines.valveDefines;
        var vd;
        for(var v in vds){
            vd = vds[v];
            if(vd instanceof(IODefines.ValveItem)){
                if(!IODefines.isNormalYType(vd)){
//                    console.log(JSON.stringify(vd));
                    valveModel.append(vd);
                }
            }
        }
        valveContainer.model = valveModel;
    }

    Component.onCompleted: {
        panelRobotController.moldChanged.connect(onMoldChanged);
        onMoldChanged();
    }
    onVisibleChanged: {
        if(visible){
            onMoldChanged();
        }
    }
}
