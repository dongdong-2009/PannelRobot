import QtQuick 1.1
import "../../../ICCustomElement"
import "ExtentActionDefine.js" as ExtentActionDefine

ExtentActionEditorBase {
    width: content.width + 20
    height: content.height
    id:instance
    property alias chanel: chanelEdit.configValue
    property alias analog: analogEdit.configValue
    property alias delay: delayEdit.configValue

    Column{
        id:content
        spacing: 6
        ICConfigEdit{
            id:chanelEdit
            configName: qsTr("Chanel")
            min: 0
            max: 6
            decimal: 0
            configValue: "0"
            configNameWidth: 80
        }
        ICConfigEdit{
            id:analogEdit
            configName: qsTr("Analog Value")
            min: 0
            max: 10
            decimal: 1
            configValue: "0.0"
            configNameWidth: chanelEdit.configNameWidth
        }
        ICConfigEdit{
            id:delayEdit
            configName: qsTr("Delay")
            configAddr: "s_rw_0_32_1_1201"
            configValue: "0.0"
            configNameWidth: chanelEdit.configNameWidth
            unit: qsTr("s")
        }

    }
    Component.onCompleted: {
        bindActionDefine(ExtentActionDefine.extentAnalogControlAction);
    }
}
