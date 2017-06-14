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
        height:parent.height - typeSel.height -5
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
            Row{
                spacing: 8
                ICComboBoxConfigEdit{
                    id: canAUse
                    items: [qsTr("online"), qsTr("Encoder")]
                    configName:  qsTr("CAN use to")
                    configAddr: "s_rw_0_2_0_286"
                }
                ICConfigEdit{
                    id:canA_id_config
                    configName: qsTr("ID config")
                    configAddr: "s_rw_2_8_0_286"
                }
                ICComboBoxConfigEdit{
                    id: canA_baud_config
                    items: [qsTr("125kbps"), qsTr("250kbps"), qsTr("500kbps"), qsTr("1000kbps")]
                    configName:  qsTr("Baud Setting")
                    configAddr: "s_rw_10_6_0_286"
                }
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
            Row{
                id:canBConfigRow
                spacing: 8
                ICComboBoxConfigEdit{
                    id: canBUse
                    items: [qsTr("online"), qsTr("Encoder")]
                    configName:  qsTr("CAN use to")
                    configAddr: "s_rw_0_2_0_287"
                }
                ICConfigEdit{
                    id:canB_id_config
                    configName: qsTr("ID config")
                    configAddr: "s_rw_2_8_0_287"
                }
                ICComboBoxConfigEdit{
                    id: canB_baud_config
                    items: [qsTr("125kbps"), qsTr("250kbps"), qsTr("500kbps"), qsTr("1000kbps")]
                    configName:  qsTr("Baud Setting")
                    configAddr: "s_rw_10_6_0_287"
                }
            }

            Rectangle{
                visible: canBUse.configValue == 1
                color: "transparent"
                border.color: "black"
                border.width: 1
                height:pageContainer.height - canBConfigRow.height -24
                width: pageContainer.width -5
                ListModel{
                    id:ecoderModel
                }
                ICListView{
                    id:encoderList
                    height:parent.height - funcBtnArea.height - 5
                    width: parent.width
                    model:ecoderModel
                    spacing: 5
                    delegate: Row{
                        spacing: 8
                        ICCheckBox {
                            id:ecoderEnEdit
                            text: ecoderID
                            isChecked: check
                            onIsCheckedChanged: {
                                ecoderModel.setProperty(index,"check",isChecked);
                            }
                        }
                        ICConfigEdit{
                            id:ecoderNameEdit
                            isNumberOnly: false
                            inputWidth: 70
                            configName: qsTr("name")+ ": "
                            configValue: ecoderName
                            onConfigValueChanged: {
                                ecoderModel.setProperty(index,"ecoderName",configValue);
                            }
                        }
                        ICButton{
                            id:setZeroBtn
                            width: 80
                            height: ecoderEnEdit.height
                            text: qsTr("setZero")
                        }
                        ICComboBoxConfigEdit{
                            id:surfaceSelEdit
                            configName: qsTr("surface")
                            items:["XY","XZ","YZ"]
                            inputWidth: 40
                            configValue: surface
                            onConfigValueChanged: {
                                ecoderModel.setProperty(index,"surface",configValue);
                            }
                        }
                        ICButton{
                            id:setPosBtn
                            width: 80
                            height: ecoderEnEdit.height
                            text:qsTr("setPos")
                        }
                        ICConfigEdit{
                            id:p0M0Edit
                            configName: qsTr("p0M0")
                            configValue: p0M0
                            inputWidth: 70
                            onConfigValueChanged: {
                                ecoderModel.setProperty(index,"p0M0",configValue);
                            }
                        }
                        ICConfigEdit{
                            id:p0M1Edit
                            configName: qsTr("p0M1")
                            configValue: p0M1
                            inputWidth: 70
                            onConfigValueChanged: {
                                ecoderModel.setProperty(index,"p0M1",configValue);
                            }
                        }
                        ICButton{
                            id:delBtn
                            width: 80
                            height: ecoderEnEdit.height
                            text: qsTr("delete")
                            onButtonClicked: {
                                ecoderModel.remove(index);
                            }
                        }
                    }
                }
                Row{
                    id:funcBtnArea
                    x:5
                    anchors.top:encoderList.bottom
                    anchors.bottomMargin: 2
                    spacing: 8
                    ICButton{
                        id:newBtn
                        text: qsTr("new")
                        onButtonClicked: {
                            ecoderModel.append({"check":true,"ecoderID":0,"ecoderName":"0","surface":0,"p0M0":0,"p0M1":0});
                        }
                    }
                    ICButton{
                        id:saveBtn
                        text: qsTr("save")
                        onButtonClicked:{

                        }
                    }

                    Text {
                        id: canBtips
                        height: saveBtn.height
                        color: "red"
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("Tips:After modified, must be restart to take effect!")
                    }
                }
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

