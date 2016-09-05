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
                valveModel.set(s, {"x1Dir":d.x1Dir, "x2Dir":d.x2Dir, "time":d.time});
            }
            var valveDefines = []
            for(var i = 0; i < valveModel.count; ++i){
                valveDefines.push(valveModel.get(i));
            }
            Storage.setSetting(panelRobotController.currentRecordName() + "_valve", JSON.stringify(PData.changedData));
            panelRobotController.initValveDefines(JSON.stringify(valveDefines));
        }
    }

    GridView{
        id:valveContainer
        anchors.top: saveBtn.bottom
        anchors.topMargin: 6
        //        model: valveModel
        cellWidth: width / 2 -10
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
            }
        }
    }

    function onMoldChanged(){
        valveContainer.model = null;
        valveModel.clear();
        IODefines.combineValveDefines(Storage.getSetting(panelRobotController.currentRecordName() + "_valve"));
        panelRobotController.initValveDefines(IODefines.valveDefinesJSON());
        var vds = IODefines.valveDefines;
        var vd;
        for(var v in vds){
            vd = vds[v];
            if(vd instanceof(IODefines.ValveItem)){
                if(!IODefines.isNormalYType(vd))
                    valveModel.append(vd);
            }
        }
        valveContainer.model = valveModel;
    }

    Component.onCompleted: {
        panelRobotController.moldChanged.connect(onMoldChanged);
        onMoldChanged();
    }
}
