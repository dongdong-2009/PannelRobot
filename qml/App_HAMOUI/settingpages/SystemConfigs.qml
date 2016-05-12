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
            ICComboBoxConfigEdit{
                id:hostBoard
                configName: qsTr("Host Board")
                configAddr: "s_rw_0_16_0_184"
                popupHeight: 200
                items: ["S2V30",
                    "S2V31",
                    "S3V2x",
                    "S3V30",
                    "S3V31",
                    "S3V32",
                    "S3V33",
                    "S3V34",
                    "S5V2x",
                    "S5V30",
                    "S5V31",
                    "S5V32",
                    "S5V33",
                    "C6V10",
                    "C6V11",
                    "C6V12",
                    "C6V13"
                ]
                indexMappedValue: [
                    0,1,0x0010,0x0011,0x0012,0x0013,0x0014,0x0015,
                    0x0020,0x0021,0x0022,0x0023,0x0024,
                    0x0040,0x0041,0x0042,0x0043
                ]
            }
            ICComboBoxConfigEdit{
                id:machineType
                configName: qsTr("Machine Type")
                configAddr: "s_rw_24_8_0_184"
                popupHeight: 200
                items: [qsTr("kSttIndependent"), qsTr("kSttPP"), qsTr("kSttRR"),
                qsTr("kSttPPP"), qsTr("kSttRTR"), qsTr("kSttRRP"), qsTr("kSttRRPR"),
                qsTr("kSttRTRT"), qsTr("kSttRTRTTT"), qsTr("kStt5P"), qsTr("kSttPPP_RRR"),
                qsTr("kSttRRPR_BRT"), qsTr("kSttRTRTTT_EX")]
            }
            ICConfigEdit{
                id:axisNum
                configName: qsTr("Axis Num")
                configAddr: "s_rw_16_8_0_184"
            }


        }
        onConfigValueChanged: {
            console.log(addr, newV, oldV);
            ICOperationLog.opLog.appendNumberConfigOperationLog(addr, newV, oldV);
            panelRobotController.setConfigValue("s_rw_0_32_0_185", panelRobotController.configsCheckSum(ConfigDefines.machineStructConfigsJSON));
            panelRobotController.syncConfigs();
        }
    }
}
