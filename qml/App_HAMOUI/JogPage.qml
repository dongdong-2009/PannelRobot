import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap


Item {
    width: parent.width
    height: parent.height

    Column{
        id:button
        spacing: 10
        ICButton{
            id:savePoint
            text: qsTr("Log Point")
            onTriggered: {
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_GET_COORDINATE);
            }

        }
        ICButton{
            id:line
            text: qsTr("Line To")
            autoInterval: 50
            isAutoRepeat: true
            onTriggered: {
                console.log(text);
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_MOVE_POINT);
            }
        }
        ICButton{
            id:curve
            text: qsTr("Curve To")
            autoInterval: 50
            isAutoRepeat: true
            onTriggered: {
                console.log(text);
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_MOVE_ARC);
            }

        }
        ICButton{
            id:loadMachineConfigFromHost
            text:qsTr("Load Host Configs")
            onTriggered: {
                panelRobotController.loadHostMachineConfigs();
            }
        }

        Row{
            spacing: 20
            height: 32
            ICConfigEdit{
                width: 120
                height: 32
                id:debugAddr
                configName: qsTr("Addr")
                alignMode: 1
            }
            ICConfigEdit{
                width: 120
                height: 32
                id:debugVal
                configName: qsTr("value")
                alignMode: 1
            }
            ICButton{
                id:debug
                text: qsTr("Send")
                onButtonClicked: {
                    panelRobotController.modifyConfigValue(parseInt(debugAddr.configValue),
                                                           parseInt(debugVal.configValue));
                }
            }
        }

        ICSettingConfigsScope{
            //            visible: false
            width: 120
            height: 24
            ICConfigEdit{
                id:speed
                height: parent.height
                configName: qsTr("Speed")
                configAddr: "s_rw_0_16_3_265"
                alignMode:1
                unit: qsTr("%")
            }
        }
    }

    ICStatusScope{
        anchors.left: button.right
        anchors.leftMargin:  100
        //        width: 800
        //        height: 600
        Row{
            spacing: 100

            Column{
                spacing: 6
                ICStatusWidget {
                    id: status1
                    bindStatus: "c_ro_0_32_0_900"
                }
                ICStatusWidget {
                    id: status2
                    bindStatus: "c_ro_0_32_0_901"
                }
                ICStatusWidget {
                    id: status3
                    bindStatus: "c_ro_0_32_0_902"
                }
                ICStatusWidget {
                    id: status4
                    bindStatus: "c_ro_0_32_0_903"
                }
                ICStatusWidget {
                    id: status5
                    bindStatus: "c_ro_0_32_0_904"
                }
                ICStatusWidget {
                    id: status6
                    bindStatus: "c_ro_0_32_0_905"
                }
                ICStatusWidget {
                    id: status7
                    bindStatus: "c_ro_0_32_0_906"
                }
                ICStatusWidget {
                    id: status8
                    bindStatus: "c_ro_0_32_0_907"
                }
                ICStatusWidget {
                    id: status9
                    bindStatus: "c_ro_0_32_0_908"
                }
                ICStatusWidget {
                    id: status10
                    bindStatus: "c_ro_0_32_0_909"
                }
                ICStatusWidget {
                    id: status11
                    bindStatus: "c_ro_0_32_0_910"
                }
                ICStatusWidget {
                    id: status12
                    bindStatus: "c_ro_0_32_0_911"
                }
                ICStatusWidget {
                    id: status13
                    bindStatus: "c_ro_0_32_0_912"
                }
                ICStatusWidget {
                    id: status14
                    bindStatus: "c_ro_0_32_0_913"
                }
                ICStatusWidget {
                    id: status15
                    bindStatus: "c_ro_0_32_0_914"
                }
                ICStatusWidget {
                    id: status16
                    bindStatus: "c_ro_0_32_0_915"
                }

            }
            Column{
                spacing: 6
                ICStatusWidget {
                    id: status17
                    bindStatus: "c_ro_0_32_0_916"
                }
                ICStatusWidget {
                    id: status18
                    bindStatus: "c_ro_0_32_0_917"
                }
                ICStatusWidget {
                    id: status19
                    bindStatus: "c_ro_0_32_0_918"
                }
                ICStatusWidget {
                    id: status20
                    bindStatus: "c_ro_0_32_0_919"
                }
                ICStatusWidget {
                    id: status21
                    bindStatus: "c_ro_0_32_0_920"
                }
                ICStatusWidget {
                    id: status22
                    bindStatus: "c_ro_0_32_0_921"
                }
                ICStatusWidget {
                    id: status23
                    bindStatus: "c_ro_0_32_0_922"
                }
                ICStatusWidget {
                    id: status24
                    bindStatus: "c_ro_0_32_0_923"
                }
                ICStatusWidget {
                    id: status25
                    bindStatus: "c_ro_0_32_0_924"
                }
                ICStatusWidget {
                    id: status26
                    bindStatus: "c_ro_0_32_0_925"
                }
                ICStatusWidget {
                    id: status27
                    bindStatus: "c_ro_0_32_0_926"
                }
                ICStatusWidget {
                    id: status28
                    bindStatus: "c_ro_0_32_0_927"
                }
                ICStatusWidget {
                    id: status29
                    bindStatus: "c_ro_0_32_0_928"
                }
                ICStatusWidget {
                    id: status30
                    bindStatus: "c_ro_0_32_0_929"
                }
                ICStatusWidget {
                    id: status31
                    bindStatus: "c_ro_0_32_0_932"
                }
                ICStatusWidget {
                    id: status32
                    bindStatus: "c_ro_0_32_0_931"
                }

            }
        }
    }
}
