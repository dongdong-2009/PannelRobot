import QtQuick 1.1
import "../../ICCustomElement"
import "../ICOperationLog.js" as ICOperationLog



Item {
    width: parent.width
    height: parent.height
    ICSettingConfigsScope{
        anchors.fill: parent
        Grid{
            ICConfigEdit{
                id:tolerance
                configName: qsTr("Tolerance")
                unit: qsTr("Pulse")
                configAddr: "s_rw_0_32_0_210"

            }
        }
        onConfigValueChanged: {
            console.log(addr, newV, oldV);
            ICOperationLog.opLog.appendNumberConfigOperationLog(addr, newV, oldV);
        }
    }

}
