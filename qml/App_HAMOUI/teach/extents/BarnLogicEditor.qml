import QtQuick 1.1
import "../../../ICCustomElement"
import "ExtentActionDefine.js" as ExtentActionDefine

ExtentActionEditorBase {
    width: editArea.width + 20
    height: editArea.height
    property int barnID: barnIDEdit.getConfigValue()
    property alias start:startEdit.configValue
    property alias delay: delayEdit.configValue
    Column{
        id:editArea
        spacing: 10

        ICComboBoxConfigEdit{
            id:barnIDEdit
            property variant barnType : []
            configName: qsTr("barnID")
            configNameWidth: startEdit.configNameWidth
            onConfigValueChanged: {
                if(configValue < 0)return;
                if(barnType[configValue] == 1){
                    startEdit.setItemVisble(1,true);
                    startEdit.setItemVisble(2,false);
                    startEdit.setItemVisble(3,false);
                }
                else{
                    startEdit.setItemVisble(1,false);
                    startEdit.setItemVisble(2,true);
                    startEdit.setItemVisble(3,true);
                }
            }
        }
        ICComboBoxConfigEdit{
            id:startEdit
            configName: qsTr("Barn status")
            items: [qsTr("stop"),qsTr("start"),qsTr("Up"),qsTr("Down")]
            configValue: 0
        }
        ICConfigEdit{
            id:delayEdit
            configNameWidth: startEdit.configNameWidth
            configName: qsTr("Delay")
            configValue: "0.0"
            min:0
            decimal: 1
        }
    }
    Component.onCompleted: {
         bindActionDefine(ExtentActionDefine.extentBarnLogicAction);
    }
    onVisibleChanged: {
        if(visible){
            var barnData = JSON.parse(panelRobotController.getCustomSettings("IOBarnLogicSet","[]","IOBarnLogicSet"));
            var nameList = [],idList = [],typeList = [];
            for(var i=0,len =barnData.length;i<len;++i){
                nameList.push(barnData[i].barnName);
                idList.push(barnData[i].barnID);
                typeList.push(barnData[i].isAutoBarn);
            }
            barnIDEdit.items = nameList;
            barnIDEdit.indexMappedValue = idList;
            barnIDEdit.barnType = typeList;
        }
    }
}
