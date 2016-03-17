import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/ConfigDefines.js" as ConfigDefines
import "../configs/AxisDefine.js" as AxisDefine
import "../ICOperationLog.js" as ICOperationLog

Item {
    width: parent.width
    height: parent.height
    QtObject{
        id:pdata
        property int configNameWidth: 140
    }
    ICSettingConfigsScope{
        onConfigValueChanged: {
            ICOperationLog.appendNumberConfigOperationLog(addr, newV, oldV)
            panelRobotController.setConfigValue("s_rw_0_32_0_185", panelRobotController.configsCheckSum(ConfigDefines.machineStructConfigsJSON));
            panelRobotController.syncConfigs();
        }

        Grid{
//            columns: 2
            rows:10
            flow: Grid.TopToBottom
            spacing: 15
            ICConfigEdit{
                id:axis1Length
                configNameWidth: pdata.configNameWidth
                configName: AxisDefine.axisInfos[0].name + " " + qsTr("Length");
                unit: AxisDefine.axisInfos[0].unit
                configAddr: "s_rw_0_32_3_100"
            }
            ICConfigEdit{
                id:axis2Length
                configNameWidth: pdata.configNameWidth
                configName: AxisDefine.axisInfos[1].name + " " + qsTr("Length");
                unit: AxisDefine.axisInfos[0].unit
                configAddr: "s_rw_0_32_3_107"
            }
            ICConfigEdit{
                id:axis3Length
                configNameWidth: pdata.configNameWidth
                configName: AxisDefine.axisInfos[2].name + " " + qsTr("Length");
                unit: AxisDefine.axisInfos[0].unit
                configAddr: "s_rw_0_32_3_114"
            }
            ICConfigEdit{
                id:axis4Length
                configNameWidth: pdata.configNameWidth
                configName: AxisDefine.axisInfos[3].name + " " + qsTr("Length");
                unit: AxisDefine.axisInfos[0].unit
                configAddr: "s_rw_0_32_3_121"
            }
            ICConfigEdit{
                id:axis5Length
                configNameWidth: pdata.configNameWidth
                configName: AxisDefine.axisInfos[4].name + " " + qsTr("Length");
                unit: AxisDefine.axisInfos[0].unit
                configAddr: "s_rw_0_32_3_128"
            }
            ICConfigEdit{
                id:axis6Length
                configNameWidth: pdata.configNameWidth
                configName: AxisDefine.axisInfos[5].name + " " + qsTr("Length");
                unit: AxisDefine.axisInfos[0].unit
                configAddr: "s_rw_0_32_3_135"
            }

            ICConfigEdit{
                id:struct1
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 1");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_156"
            }

            ICConfigEdit{
                id:struct2
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 2");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_157"
            }

            ICConfigEdit{
                id:struct3
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 3");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_158"
            }

            ICConfigEdit{
                id:struct4
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 4");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_159"
            }

            ICConfigEdit{
                id:struct5
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 5");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_160"
            }

            ICConfigEdit{
                id:struct6
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 6");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_161"
            }

            ICConfigEdit{
                id:struct7
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 7");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_162"
            }

            ICConfigEdit{
                id:struct8
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 8");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_163"
            }

            ICConfigEdit{
                id:struct9
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 9");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_164"
            }

            ICConfigEdit{
                id:sAcc1
                configNameWidth: pdata.configNameWidth
                configName: qsTr("SACC 1");
                unit: qsTr("%")
                configAddr: "s_rw_0_8_0_165"
            }

            ICConfigEdit{
                id:sAcc2
                configNameWidth: pdata.configNameWidth
                configName: qsTr("SACC 2");
                unit: qsTr("%")
                configAddr: "s_rw_8_8_0_165"
            }

            ICConfigEdit{
                id:sAcc3
                configNameWidth: pdata.configNameWidth
                configName: qsTr("SDEC 1");
                unit: qsTr("%")
                configAddr: "s_rw_16_8_0_165"
            }

            ICConfigEdit{
                id:sAcc4
                configNameWidth: pdata.configNameWidth
                configName: qsTr("SDEC 2");
                unit: qsTr("%")
                configAddr: "s_rw_24_8_0_165"
            }
            ICConfigEdit{
                id:sAccTime
                configNameWidth: pdata.configNameWidth
                configName: qsTr("SACC Time");
                unit: qsTr("m/s²")
                configAddr: "s_rw_0_16_3_166"
            }
            ICConfigEdit{
                id:sDecTime
                configNameWidth: pdata.configNameWidth
                configName: qsTr("SDec Time");
                unit: qsTr("m/s²")
                configAddr: "s_rw_16_16_3_166"
            }
            ICConfigEdit{
                id:pathMaxSpeed
                configNameWidth: pdata.configNameWidth
                configName: qsTr("SACC Max");
                unit: qsTr("RPM")
                configAddr: "s_rw_0_16_3_167"
            }

        }
    }
}
