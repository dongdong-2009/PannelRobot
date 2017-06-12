import QtQuick 1.1
import "../../ICCustomElement"

ICSettingConfigsScope {
    id:ioRunningSettingPage
    width:  parent.width
    height: parent.height
    ICButtonGroup{
        id:typeSel
        checkedItem: serialSetting
        checkedIndex: 0
        mustChecked: true
        spacing: 10
        x:5
        y:3
        ICCheckBox{
            id:serialSetting
            text: qsTr("Serial485")
            isChecked: true
        }
        ICCheckBox{
            id:canASetting
//            enabled: false
            text: qsTr("CANA")
        }
        ICCheckBox{
            id:canBSetting
//            enabled: false
            text: qsTr("CANB")
        }
        onCheckedIndexChanged: {
            pageContainer.setCurrentIndex(checkedIndex);
        }
    }

    ICStackContainer{
        id:pageContainer
        width: parent.width-3
        height: parent.height
        anchors.top:typeSel.bottom
        anchors.topMargin: 5
        Column
        {
            id:serialContainer
            spacing: 8
            Row{
                spacing: 8
                Text {
                    text: qsTr("serial 485 config")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            ICComboBoxConfigEdit{
                id: parity_config
                items: [qsTr("NULL"), qsTr("ODD"), qsTr("EVEN"), qsTr("INVALID")]
                configNameWidth: 100
                configName: qsTr("Parity Setting")
                configAddr: "s_rw_0_2_0_288"
            }

            ICComboBoxConfigEdit{
                id: stopbits_config
                items: [qsTr("1"), qsTr("1.5"), qsTr("2"), qsTr("INVALID")]
                configNameWidth: 100
                configName:  qsTr("Stopbits Setting")
                configAddr: "s_rw_2_2_0_288"
            }

            ICComboBoxConfigEdit{
                id: databits_config
                items: [qsTr("1"), qsTr("2"), qsTr("3"), qsTr("4"), qsTr("5"), qsTr("6"), qsTr("7"), qsTr("8")]
                configNameWidth: 100
                configName:  qsTr("Databits Setting")
                configAddr: "s_rw_4_3_0_288"
            }
            ICComboBoxConfigEdit{
                id: loopback_config
                items: [qsTr("OFF"), qsTr("ON")]
                configNameWidth: 100
                configName:  qsTr("Loopback Setting")
                configAddr: "s_rw_7_1_0_288"
            }
            ICComboBoxConfigEdit{
                id: baud_config
                items: [qsTr("2400"), qsTr("4800"), qsTr("9600"), qsTr("19200"), qsTr("38400"), qsTr("57600"), qsTr("115200")]
                configNameWidth: 100
                configName:  qsTr("Baud Setting")
                configAddr: "s_rw_8_8_0_288"
            }

            Text {
                id: tips
                color: "red"
                text: qsTr("Tips:After modified, must be restart to take effect!")
            }
        }
        Column{
            id:canAContainer
            spacing: 8
            ICComboBoxConfigEdit{
                id: canAUse
                items: [qsTr("online"), qsTr("Encoder")]
                configNameWidth: 100
                configName:  qsTr("CAN use to")
                configValue: 0
//                configAddr: "s_rw_8_8_0_288"
            }
//            ICComboBoxConfigEdit{
//                id: canAMode
//                items: [qsTr("SDO"), qsTr("PDO")]
//                configNameWidth: 100
//                configName:  qsTr("Host CAN b")
////                configAddr: "s_rw_8_8_0_288"
//            }
            ICConfigEdit{
                id:canA_id_config
                configName: qsTr("ID config")
                configValue: qsTr("0")
            }
            ICComboBoxConfigEdit{
                id: canA_baud_config
                items: [qsTr("125kbps"), qsTr("250kbps"), qsTr("500kbps"), qsTr("1000kbps")]
                configNameWidth: 100
                configName:  qsTr("Baud Setting")
                configValue: 2
            }
            Text {
                id: canAtips
                color: "red"
                text: qsTr("Tips:After modified, must be restart to take effect!")
            }
        }
        Column{
            id:canBContainer
            spacing: 8
            ICComboBoxConfigEdit{
                id: canBUse
                items: [qsTr("online"), qsTr("Encoder")]
                configNameWidth: 100
                configName:  qsTr("CAN use to")
                configValue: 1
//                configAddr: "s_rw_8_8_0_288"
            }
//            ICComboBoxConfigEdit{
//                id: canBMode
//                items: [qsTr("SDO"), qsTr("PDO")]
//                configNameWidth: 100
//                configName:  qsTr("Host CAN b")
////                configAddr: "s_rw_8_8_0_288"
//            }
            ICConfigEdit{
                id:canB_id_config
                configName: qsTr("ID config")
                configValue: qsTr("0")
            }
            ICComboBoxConfigEdit{
                id: canB_baud_config
                items: [qsTr("125kbps"), qsTr("250kbps"), qsTr("500kbps"), qsTr("1000kbps")]
                configNameWidth: 100
                configName:  qsTr("Baud Setting")
                configValue: 2
            }


            ICButton{
                id:newBtn
                text: qsTr("new")
                visible: (canBUse.configValue == 1)?true:false
                onButtonClicked: {
                    if(canBUse.configValue == 1){
//                        valveModel.append({"check":true,"mode":6,"sendMode":3,"outType_init":0,"outid_init":0,"outstatus_init":0});
                    }
                }
            }

            Text {
                id: canBtips
                color: "red"
                text: qsTr("Tips:After modified, must be restart to take effect!")
            }
        }
    }
    Component.onCompleted: {
        pageContainer.addPage(serialContainer);
        pageContainer.addPage(canAContainer);
        pageContainer.addPage(canBContainer);
        pageContainer.setCurrentIndex(typeSel.checkedIndex);
    }
}

