import QtQuick 1.1
import "../../../ICCustomElement"
import "ExtentActionDefine.js" as ExtentActionDefine

ExtentActionEditorBase {
    width: coordIDEdit.width + 20
    height: coordIDEdit.height
    id:instance
    property alias coordID: coordIDEdit.configValue

    ICConfigEdit{
        id:coordIDEdit
        configName: qsTr("coordID")
        min: 0
        decimal: 0
        configValue: "0"
        configNameWidth: 80
    }
    Component.onCompleted: {
         bindActionDefine(ExtentActionDefine.extentSwitchCoordAction);
    }
}

