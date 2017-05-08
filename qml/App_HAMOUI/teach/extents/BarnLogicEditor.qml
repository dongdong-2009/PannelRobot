import QtQuick 1.1
import "../../../ICCustomElement"
import "ExtentActionDefine.js" as ExtentActionDefine

ExtentActionEditorBase {
    width: editArea.width + 20
    height: editArea.height
    property alias barnID: barnIDEdit.configValue
    property alias start:startEdit.configValue
    Column{
        id:editArea
        spacing: 10
        ICConfigEdit{
            id:barnIDEdit
            configName: qsTr("barnID")
            configNameWidth: startEdit.configNameWidth
            min: 1
            decimal: 0
            configValue: "1"
        }
        ICComboBoxConfigEdit{
            id:startEdit
            configName: qsTr("Barn status")
            items: [qsTr("stop"),qsTr("start")]
            configValue: 0
        }
    }
    Component.onCompleted: {
         bindActionDefine(ExtentActionDefine.extentBarnLogicAction);
    }
}
