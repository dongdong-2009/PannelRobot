import QtQuick 1.1
import "../../../ICCustomElement"
import "ExtentActionDefine.js" as ExtentActionDefine
import "../../ToolCoordManager.js" as ToolCoordManager
import "../../../utils/utils.js" as Utils

ExtentActionEditorBase {
    width: coordIDEdit.width + 20
    height: coordIDEdit.height
    id:instance
    property int coordID: coordIDEdit.configValue<0?-1:Number(Utils.getValueBeforeColon(coordIDEdit.configText()))
    property string coordName:coordIDEdit.configValue<0?"":Utils.getValueAfterColon(coordIDEdit.configText())

    onActionObjectChanged: {
        if(actionObject == null) return;
        var tmpItems = ToolCoordManager.toolCoordManager.toolCoordNameList();
        tmpItems.splice(0, 0, ("0:"+qsTr("world coord")));
        coordIDEdit.items = tmpItems;
        for(var i=0,len = coordIDEdit.items.length;i<len;++i){
            if(actionObject.coordID == Utils.getValueBeforeColon(coordIDEdit.items[i])){
               coordIDEdit.configValue = i;
                return;
            }
        }
        coordIDEdit.configValue = -1;
    }

    ICComboBoxConfigEdit{
        id:coordIDEdit
        configName: qsTr("coordID")
    }
    onVisibleChanged: {
        if(visible){
            var tmpItems = ToolCoordManager.toolCoordManager.toolCoordNameList();
            tmpItems.splice(0, 0, ("0:"+qsTr("world coord")));
            coordIDEdit.items = tmpItems;
        }
    }

    Component.onCompleted: {
         bindActionDefine(ExtentActionDefine.extentSwitchCoordAction);
    }
}

