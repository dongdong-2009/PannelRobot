import QtQuick 1.1
import "../../ICCustomElement"
import "../ICOperationLog.js" as ICOperationLog



Item {
    width: parent.width
    height: parent.height
    ICSettingConfigsScope{
        anchors.fill: parent
        Grid{
            spacing: 20
            ICConfigEdit{
                id:tolerance
                configName: qsTr("Tolerance")
                unit: qsTr("Pulse")
                configAddr: "s_rw_0_32_0_210"

            }
            ICCheckableLineEdit{
                id:turnAutoSpeedEdit
                unit: qsTr("%")
                configName: qsTr("Turn Auto Speed")
                min: 0.0
                max: 100.0
                decimal: 1
                onIsCheckedChanged: {
                    panelRobotController.setCustomSettings("IsTurnAutoSpeedEn", isChecked ? 1 : 0);
                }
                onConfigValueChanged: {
                    panelRobotController.setCustomSettings("TurnAutoSpeed", configValue);
                }
            }
            ICConfigEdit{
                id:alarmTimes
                configName: qsTr("Alarm Times")
                min:0
                max:200
                decimal: 1
                unit: qsTr("Times")
                configAddr: "s_rw_0_8_0_176"
            }
        }
        onConfigValueChanged: {
            console.log(addr, newV, oldV);
            ICOperationLog.opLog.appendNumberConfigOperationLog(addr, newV, oldV);
            if(addr == "s_rw_0_8_0_176"){
                panelRobotController.setConfigValue("s_rw_0_32_0_185", panelRobotController.configsCheckSum(ConfigDefines.machineStructConfigsJSON));
                panelRobotController.syncConfigs();
            }
        }
    }
    Component.onCompleted: {
        var isTurnAutoSpeedEn = panelRobotController.getCustomSettings("IsTurnAutoSpeedEn", 0);
        var turnAutoSpeed = panelRobotController.getCustomSettings("TurnAutoSpeed", 10.0);
        turnAutoSpeedEdit.isChecked = isTurnAutoSpeedEn;
        turnAutoSpeedEdit.configValue = turnAutoSpeed;
    }

}
