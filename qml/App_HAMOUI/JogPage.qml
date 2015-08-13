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
    }

    Row{
        spacing: 100
        anchors.left: button.right
        anchors.leftMargin:  100
        Column{
            spacing: 6
            Text {
                id: status1
                text: qsTr("text")
            }
            Text {
                id: status2
                text: qsTr("text")
            }
            Text {
                id: status3
                text: qsTr("text")
            }
            Text {
                id: status4
                text: qsTr("text")
            }
            Text {
                id: status5
                text: qsTr("text")
            }
            Text {
                id: status6
                text: qsTr("text")
            }
            Text {
                id: status7
                text: qsTr("text")
            }
            Text {
                id: status8
                text: qsTr("text")
            }
            Text {
                id: status9
                text: qsTr("text")
            }
            Text {
                id: status10
                text: qsTr("text")
            }
            Text {
                id: status11
                text: qsTr("text")
            }
            Text {
                id: status12
                text: qsTr("text")
            }
            Text {
                id: status13
                text: qsTr("text")
            }
            Text {
                id: status14
                text: qsTr("text")
            }
            Text {
                id: status15
                text: qsTr("text")
            }
            Text {
                id: status16
                text: qsTr("text")
            }

        }
        Column{
            spacing: 6
            Text {
                id: status17
                text: qsTr("text")
            }
            Text {
                id: status18
                text: qsTr("text")
            }
            Text {
                id: status19
                text: qsTr("text")
            }
            Text {
                id: status20
                text: qsTr("text")
            }
            Text {
                id: status21
                text: qsTr("text")
            }
            Text {
                id: status22
                text: qsTr("text")
            }
            Text {
                id: status23
                text: qsTr("text")
            }
            Text {
                id: status24
                text: qsTr("text")
            }
            Text {
                id: status25
                text: qsTr("text")
            }
            Text {
                id: status26
                text: qsTr("text")
            }
            Text {
                id: status27
                text: qsTr("text")
            }
            Text {
                id: status28
                text: qsTr("text")
            }
            Text {
                id: status29
                text: qsTr("text")
            }
            Text {
                id: status30
                text: qsTr("text")
            }
            Text {
                id: status31
                text: qsTr("text")
            }
            Text {
                id: status32
                text: qsTr("text")
            }

        }
        Timer{
            id:refreshTimer
            interval: 50; running: true; repeat: true
            onTriggered: {
                status1.text = panelRobotController.statusValue("c_ro_0_32_0_900");
                status2.text = panelRobotController.statusValue("c_ro_0_32_0_901");
                status3.text = panelRobotController.statusValue("c_ro_0_32_0_902");
                status4.text = panelRobotController.statusValue("c_ro_0_32_0_903");
                status5.text = panelRobotController.statusValue("c_ro_0_32_0_904");
                status6.text = panelRobotController.statusValue("c_ro_0_32_0_905");
                status7.text = panelRobotController.statusValue("c_ro_0_32_0_906");
                status8.text = panelRobotController.statusValue("c_ro_0_32_0_907");
                status9.text = panelRobotController.statusValue("c_ro_0_32_0_908");
                status10.text = panelRobotController.statusValue("c_ro_0_32_0_909");
                status11.text = panelRobotController.statusValue("c_ro_0_32_0_910");
                status12.text = panelRobotController.statusValue("c_ro_0_32_0_911");
                status13.text = panelRobotController.statusValue("c_ro_0_32_0_912");
                status14.text = panelRobotController.statusValue("c_ro_0_32_0_913");
                status15.text = panelRobotController.statusValue("c_ro_0_32_0_914");
                status16.text = panelRobotController.statusValue("c_ro_0_32_0_915");

                status17.text = panelRobotController.statusValue("c_ro_0_32_0_916");
                status18.text = panelRobotController.statusValue("c_ro_0_32_0_917");
                status19.text = panelRobotController.statusValue("c_ro_0_32_0_918");
                status20.text = panelRobotController.statusValue("c_ro_0_32_0_919");
                status21.text = panelRobotController.statusValue("c_ro_0_32_0_920");
                status22.text = panelRobotController.statusValue("c_ro_0_32_0_921");
                status23.text = panelRobotController.statusValue("c_ro_0_32_0_922");
                status24.text = panelRobotController.statusValue("c_ro_0_32_0_923");
                status25.text = panelRobotController.statusValue("c_ro_0_32_0_924");
                status26.text = panelRobotController.statusValue("c_ro_0_32_0_925");
                status27.text = panelRobotController.statusValue("c_ro_0_32_0_926");
                status28.text = panelRobotController.statusValue("c_ro_0_32_0_927");
                status29.text = panelRobotController.statusValue("c_ro_0_32_0_928");
                status30.text = panelRobotController.statusValue("c_ro_0_32_0_929");
                status31.text = panelRobotController.statusValue("c_ro_0_32_0_930");
                status32.text = panelRobotController.statusValue("c_ro_0_32_0_931");
            }
        }
    }
}
