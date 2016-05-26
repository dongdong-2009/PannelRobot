import QtQuick 1.1
import "../teach"
import "KeXuYePentuRecord.js" as KXYRecord
import "../teach/ProgramFlowPage.js" as BasePData

ProgramFlowPage {

    id:base
    anchors.fill: parent
    function getRecordContent(which){
        if(which == 0)
            return JSON.parse(KXYRecord.keXuyePentuRecord.getRecordContent(panelRobotController.currentRecordName()));
        else
            return JSON.parse(panelRobotController.programs(which));
    }

    function afterSaveProgram(which){
        var p = modelToProgramHelper(which);
        KXYRecord.keXuyePentuRecord.updateRecord(panelRobotController.currentRecordName(), JSON.stringify(p));
    }

    Component.onCompleted: {
        console.log("kxy menu")
    }
}
