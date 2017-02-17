import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "extents/ExtentActionDefine.js" as ExtentActionDefine
import "extents"

ExtentActionEditorBase {
    id: continer
    width: 100
    height: editArea.height
    property alias startSpeed: startSpeedEdit.configValue
    property alias endSpeed: endSpeedEdit.configValue

    function createActionObjects(){
        var ret = [];
        ret.push(Teach.generateCustomAction(continer.getActionProperties()));
        return ret;
    }

    Column{
        id:editArea
        spacing: 6
        Text {
            text: qsTr("Path Speed:")
        }
        ICConfigEdit{
            id:startSpeedEdit
            configName: qsTr("Start Speed")
            configAddr: "s_rw_0_32_1_1200"
            configNameWidth: 120
            unit: qsTr("%")
        }
        ICConfigEdit{
            id:endSpeedEdit
            configName: qsTr("End Speed")
            configAddr: "s_rw_0_32_1_1200"
            configNameWidth: 120
            unit: qsTr("%")

        }
    }
    Component.onCompleted: {
         bindActionDefine(ExtentActionDefine.speedAction);
    }
}
