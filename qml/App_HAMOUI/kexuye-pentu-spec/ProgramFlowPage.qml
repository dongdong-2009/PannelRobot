import QtQuick 1.1
import "../teach"
import "KeXuYePentuRecord.js" as KXYRecord

Item {
    function showActionEditorPanel(){
        base.showActionEditorPanel();
    }

    ProgramFlowPage{
        id:base
        anchors.fill: parent
        function getRecordContent(which){
            if(which == 0)
                return JSON.parse(KXYRecord.keXuyePentuRecord.getRecordContent(panelRobotController.currentRecordName()));
            else
                return JSON.parse(panelRobotController.programs(which));
        }
    }
}
