import QtQuick 1.1
import "../../ICCustomElement"
import "../ICOperationLog.js" as ICOperationLog
import "../configs/ConfigDefines.js" as ConfigDefines



Item {
    width: parent.width
    height: parent.height
    ICSettingConfigsScope{
        anchors.fill: parent
        Grid{
            spacing: 20
            columns: 2
            ICConfigEdit{
                id:tolerance
                configName: qsTr("Tolerance")
                unit: qsTr("Pulse")
                configAddr: "s_rw_0_32_0_210"

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
            ICCheckableLineEdit{
                id:turnManualSpeedEdit
                unit: qsTr("%")
                configName: qsTr("Turn Manual Speed")
                min: 0.0
                max: 100.0
                decimal: 1
                onIsCheckedChanged: {
                    panelRobotController.setCustomSettings("IsTurnManualSpeedEn", isChecked ? 1 : 0);
                }
                onConfigValueChanged: {
                    panelRobotController.setCustomSettings("TurnManualSpeed", configValue);
                }
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
        var isTurnManalSpeedEn = panelRobotController.getCustomSettings("IsTurnManualSpeedEn", 0);
        var turnManalSpeed = panelRobotController.getCustomSettings("TurnManualSpeed", 10.0);
        turnManualSpeedEdit.isChecked = isTurnManalSpeedEn;
        turnManualSpeedEdit.configValue = turnManalSpeed;
    }

}
