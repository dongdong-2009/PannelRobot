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
            id:singl
            text: qsTr("single axis")
            onButtonClicked: {
                panelRobotController.modifyConfigValue(24,
                                                       0);
            }
        }
        ICButton{
            id:jog
            text: qsTr("jog axis")
            onButtonClicked: {
                panelRobotController.modifyConfigValue(24,
                                                       30);
            }
        }
        ICButton{
            id:connectUsbNet
            text: qsTr("USB Net")
            onButtonClicked: {
                panelRobotController.usbNetInit();
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
                configAddr: "s_rw_0_16_1_265"
                alignMode:1
                unit: qsTr("%")
            }
        }
    }

    ICStatusScope{
        anchors.left: button.right
        anchors.leftMargin:  50
        //        width: 800
        //        height: 600
        Row{
            spacing: 60

            Column{
                ICStatusWidget {
                    id: status1
                    bindStatus: "c_ro_0_32_3_900"
                }
                ICStatusWidget {
                    id: status2
                    bindStatus: "c_ro_0_32_0_901"
                }
                ICStatusWidget {
                    id: status3
                    bindStatus: "c_ro_0_16_0_902"
                }
                ICStatusWidget {
                    id: status4
                    bindStatus: "c_ro_16_16_0_902"
                }
                ICStatusWidget {
                    id: status5
                    bindStatus: "c_ro_0_16_0_903"
                }
                ICStatusWidget {
                    id: status6
                    bindStatus: "c_ro_16_16_0_903"
                }
                ICStatusWidget {
                    id: status7
                    bindStatus: "c_ro_0_32_3_904"
                }
                ICStatusWidget {
                    id: status8
                    bindStatus: "c_ro_0_32_0_905"
                }
                ICStatusWidget {
                    id: status9
                    bindStatus: "c_ro_0_16_0_906"
                }
                ICStatusWidget {
                    id: status10
                    bindStatus: "c_ro_16_16_0_906"
                }
                ICStatusWidget {
                    id: status11
                    bindStatus: "c_ro_0_16_0_907"
                }
                ICStatusWidget {
                    id: status12
                    bindStatus: "c_ro_16_16_0_907"
                }
                ICStatusWidget {
                    id: status13
                    bindStatus: "c_ro_0_32_3_908"
                }
                ICStatusWidget {
                    id: status14
                    bindStatus: "c_ro_0_32_0_909"
                }
                ICStatusWidget {
                    id: status15
                    bindStatus: "c_ro_0_16_0_910"
                }
                ICStatusWidget {
                    id: status16
                    bindStatus: "c_ro_16_16_0_910"
                }

            }
            Column{
                ICStatusWidget {
                    id: status17
                    bindStatus: "c_ro_0_16_0_911"
                }
                ICStatusWidget {
                    id: status18
                    bindStatus: "c_ro_16_16_0_911"
                }
                ICStatusWidget {
                    id: status19
                    bindStatus: "c_ro_0_32_3_912"
                }
                ICStatusWidget {
                    id: status20
                    bindStatus: "c_ro_0_32_0_913"
                }
                ICStatusWidget {
                    id: status21
                    bindStatus: "c_ro_0_16_0_914"
                }
                ICStatusWidget {
                    id: status22
                    bindStatus: "c_ro_16_16_0_914"
                }
                ICStatusWidget {
                    id: status23
                    bindStatus: "c_ro_0_16_0_915"
                }
                ICStatusWidget {
                    id: status24
                    bindStatus: "c_ro_16_16_0_915"
                }
                ICStatusWidget {
                    id: status25
                    bindStatus: "c_ro_0_32_3_916"
                }
                ICStatusWidget {
                    id: status26
                    bindStatus: "c_ro_0_32_0_917"
                }
                ICStatusWidget {
                    id: status27
                    bindStatus: "c_ro_0_16_0_918"
                }
                ICStatusWidget {
                    id: status28
                    bindStatus: "c_ro_16_16_0_918"
                }
                ICStatusWidget {
                    id: status29
                    bindStatus: "c_ro_0_16_0_919"
                }
                ICStatusWidget {
                    id: status30
                    bindStatus: "c_ro_16_16_0_919"
                }
                ICStatusWidget {
                    id: status31
                    bindStatus: "c_ro_0_32_3_920"
                }
                ICStatusWidget {
                    id: status32
                    bindStatus: "c_ro_0_32_0_921"
                }

            }

            Column{
                ICStatusWidget {
                    id: status33
                    bindStatus: "c_ro_0_16_0_922"
                }
                ICStatusWidget {
                    id: status34
                    bindStatus: "c_ro_16_16_0_922"
                }
                ICStatusWidget {
                    id: status35
                    bindStatus: "c_ro_0_16_0_923"
                }
                ICStatusWidget {
                    id: status36
                    bindStatus: "c_ro_16_16_0_923"
                }
                ICStatusWidget {
                    id: status37
                    bindStatus: "c_ro_0_32_3_924"
                }
                ICStatusWidget {
                    id: status38
                    bindStatus: "c_ro_0_32_0_925"
                }
                ICStatusWidget {
                    id: status39
                    bindStatus: "c_ro_0_16_0_926"
                }
                ICStatusWidget {
                    id: status40
                    bindStatus: "c_ro_16_16_0_926"
                }
                ICStatusWidget {
                    id: status41
                    bindStatus: "c_ro_0_16_0_927"
                }
                ICStatusWidget {
                    id: status42
                    bindStatus: "c_ro_16_16_0_927"
                }
                ICStatusWidget {
                    id: status43
                    bindStatus: "c_ro_0_32_3_928"
                }
                ICStatusWidget {
                    id: status44
                    bindStatus: "c_ro_0_32_0_929"
                }
                ICStatusWidget {
                    id: status45
                    bindStatus: "c_ro_0_16_0_930"
                }
                ICStatusWidget {
                    id: status46
                    bindStatus: "c_ro_16_16_0_930"
                }
                ICStatusWidget {
                    id: status47
                    bindStatus: "c_ro_0_16_0_931"
                }
                ICStatusWidget {
                    id: status48
                    bindStatus: "c_ro_16_16_0_931"
                }
            }

            Column{
                ICStatusWidget {
                    id: status49
                    bindStatus: "c_ro_0_32_0_932"
                }
                ICStatusWidget {
                    id: status50
                    bindStatus: "c_ro_0_16_0_933"
                }
                ICStatusWidget {
                    id: status51
                    bindStatus: "c_ro_16_16_0_933"
                }
                ICStatusWidget {
                    id: status52
                    bindStatus: "c_ro_0_16_0_934"
                }
                ICStatusWidget {
                    id: status53
                    bindStatus: "c_ro_16_16_0_934"
                }
                ICStatusWidget {
                    id: status54
                    bindStatus: "c_ro_0_16_0_935"
                }
                ICStatusWidget {
                    id: status55
                    bindStatus: "c_ro_16_16_0_935"
                }
                ICStatusWidget {
                    id: status56
                    bindStatus: "c_ro_0_16_0_936"
                }
                ICStatusWidget {
                    id: status57
                    bindStatus: "c_ro_16_16_0_936"
                }
                ICStatusWidget {
                    id: status58
                    bindStatus: "c_ro_0_16_0_937"
                }
                ICStatusWidget {
                    id: status59
                    bindStatus: "c_ro_16_16_0_937"
                }
                ICStatusWidget {
                    id: status60
                    bindStatus: "c_ro_0_1_0_938"
                }
                ICStatusWidget {
                    id: status61
                    bindStatus: "c_ro_1_4_0_938"
                }
                ICStatusWidget {
                    id: status62
                    bindStatus: "c_ro_5_29_0_938"
                }
                ICStatusWidget {
                    id: status63
                    bindStatus: "c_ro_0_16_0_931"
                }
                ICStatusWidget {
                    id: status64
                    bindStatus: "c_ro_16_16_0_931"
                }
            }
        }
    }
}
