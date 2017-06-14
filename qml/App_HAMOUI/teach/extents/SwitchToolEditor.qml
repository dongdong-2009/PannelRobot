import QtQuick 1.1
import "../../../ICCustomElement"
import "ExtentActionDefine.js" as ExtentActionDefine
import "../../ToolsCalibration.js" as ToolsCalibrationManager
import "../../../utils/utils.js" as Utils

ExtentActionEditorBase {
    id:instance
    width: toolIDEdit.width + 20
    height: toolIDEdit.height
    property int toolID: toolIDEdit.configValue<0?-1:Number(Utils.getValueBeforeColon(toolIDEdit.configText()))
    property string toolName:toolIDEdit.configValue<0?"":Utils.getValueAfterColon(toolIDEdit.configText())

    onActionObjectChanged: {
        if(actionObject == null) return;
        var tmpItems = ToolsCalibrationManager.toolCalibrationManager.toolCalibrationNameList();
        tmpItems.splice(0, 0, ("0:"+qsTr("None")));
        toolIDEdit.items = tmpItems;
        for(var i=0,len = toolIDEdit.items.length;i<len;++i){
            if(actionObject.toolID == Utils.getValueBeforeColon(toolIDEdit.items[i])){
               toolIDEdit.configValue = i;
                return;
            }
        }
        toolIDEdit.configValue = -1;
    }

    ICComboBoxConfigEdit{
        id:toolIDEdit
        configName: qsTr("toolID")
    }
    onVisibleChanged: {
        if(visible){
            var tmpItems = ToolsCalibrationManager.toolCalibrationManager.toolCalibrationNameList();
//            console.log("tmpItems",tmpItems)
            tmpItems.splice(0, 0, ("0:"+qsTr("None")));
            toolIDEdit.items = tmpItems;
        }
    }
    Component.onCompleted: {
         bindActionDefine(ExtentActionDefine.extentSwitchToolAction);
    }
}
