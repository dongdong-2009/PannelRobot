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
            id:canSetting
//            enabled: false
            text: qsTr("can")
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
        Item {
            id: canSettingPage
            Rectangle{
                z:10
                id:searchTipRec
                visible: false
                width: 300
                height: 150
                border.color: "black"
                border.width: 1
                color: "#A0A0F0"
                x:300
                Text {
                    id: searchingTip
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("searching")+"..."
                }
            }
            Column{
                spacing: 8
                Row{
                    spacing: 8
                    ICButtonGroup{
                        id:canSel
                        checkedItem: canAContainer
                        checkedIndex: 0
                        mustChecked: true
                        spacing: 10
                        x:5
                        y:3
                        ICCheckBox{
                            id:canASetting
                            text: "CanA"
                            isChecked: true
                        }
                        ICCheckBox{
                            id:canBSetting
                            text: "CanB"
                        }
                    }
                    Text {
                        id: canTips
                        height: canSel.height
                        color: "red"
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("Tips:After modified, must be restart to take effect!")
                    }
                }
                Row{
                    id:canAContainer
                    visible: canASetting.isChecked
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
                Row{
                    id:canBContainer
                    visible: canBSetting.isChecked
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
                        items: ["125kbps", "250kbps", "500kbps", "1000kbps"]
                        configName:  qsTr("Baud Setting")
                        configAddr: "s_rw_10_6_0_287"
                    }
                }

                Rectangle{
                    id:encoderArea
                    visible: ((canAContainer.visible&&canAUse.configValue==1)||(canBContainer.visible&&canBUse.configValue==1))
                    color: "transparent"
                    border.color: "black"
                    border.width: 1
                    height:pageContainer.height - canBContainer.height -canSel.height -funcBtnArea.height-38
                    width: pageContainer.width -5
                    ListModel{
                        id:encoderModel
                    }
                    ICListView{
                        id:encoderList
                        height:parent.height
                        width: parent.width
                        model:encoderModel
                        spacing: 5
                        delegate: Row{
                            spacing: 8
                            ICCheckableLineEdit {
                                id:ecoderEnEdit
                                configName: "ID"
                                configValue: ecoderID
                                inputWidth: 50
                                isChecked: check
                                onIsCheckedChanged: {
                                    encoderModel.setProperty(index,"check",isChecked);
                                }
                                onConfigValueChanged: {
                                    encoderModel.setProperty(index,"ecoderID",configValue);
                                }
                            }
                            ICConfigEdit{
                                id:ecoderNameEdit
                                isNumberOnly: false
                                inputWidth: 70
                                configName: qsTr("name")
                                configValue: ecoderName
                                unit: ":"
                                onConfigValueChanged: {
                                    encoderModel.setProperty(index,"ecoderName",configValue);
                                }
                            }
                            ICComboBoxConfigEdit{
                                id:surfaceSelEdit
                                configName: qsTr("surface")
                                items:["XY","XZ","YZ"]
                                inputWidth: 40
                                configValue: surface
                                onConfigValueChanged: {
                                    encoderModel.setProperty(index,"surface",configValue);
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
                                configName:{
                                    if(surfaceSelEdit.configValue === 2)
                                        return "Y";
                                    else return "X";
                                }
                                configValue: p0M0
                                inputWidth: 70
                                min:-10000
                                max:10000
                                decimal: 3
                                onConfigValueChanged: {
                                    encoderModel.setProperty(index,"p0M0",configValue);
                                }
                            }
                            ICConfigEdit{
                                id:p0M1Edit
                                configName: {
                                    if(surfaceSelEdit.configValue === 0)
                                        return "Y";
                                    else
                                        return "Z";
                                }
                                configValue: p0M1
                                inputWidth: 70
                                min:-10000
                                max:10000
                                decimal: 3
                                onConfigValueChanged: {
                                    encoderModel.setProperty(index,"p0M1",configValue);
                                }
                            }
                            ICButton{
                                id:setZeroBtn
                                width: 80
                                height: ecoderEnEdit.height
                                text: qsTr("setZero")
                                onButtonClicked: {
                                    panelRobotController.modifyConfigValue(35,((ecoderID&0xffff)|(1<<16)));
                                }
                            }
                            ICButton{
                                id:delBtn
                                width: 80
                                height: ecoderEnEdit.height
                                text: qsTr("delete")
                                onButtonClicked: {
                                    encoderModel.remove(index);
                                }
                            }
                        }
                    }
                }
                Row{
                    id:funcBtnArea
                    x:5
                    spacing: 8
                    ICButton{
                        id:newBtn
                        visible: encoderArea.visible
                        text: qsTr("new")
                        onButtonClicked: {
                            encoderModel.append({"check":true,"ecoderID":0,"ecoderName":"0","surface":0,"p0M0":0,"p0M1":0});
                        }
                    }
                    ICButton{
                        id:saveBtn
                        visible: encoderArea.visible
                        text: qsTr("save")
                        onButtonClicked:{
                            var i,len,v;
                            var toSave = [],toSend = [];
                            for(i=0,len=encoderModel.count;i<len;i++)
                            {
                                v = encoderModel.get(i);
                                toSave.push(v);
                                if(v.check == true){
                                    toSend[0] = v.ecoderID;
                                    toSend[0]|= v.surface<<8;
                                    toSend[1] = v.p0M0;
                                    toSend[2] = v.p0M1;
                                    panelRobotController.sendEncoder(JSON.stringify(toSend));
                                }
                            }
                            panelRobotController.setCustomSettings("encoderSet", JSON.stringify(toSave));
                        }
                    }
                    ICButton{
                        id:searchBtn
                        visible: encoderArea.visible
                        text: qsTr("search")
                        onButtonClicked: {
                            enabled = false;
                            searchTipRec.visible = true;
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        pageContainer.addPage(serialContainer);
        pageContainer.addPage(canSettingPage);
        pageContainer.setCurrentIndex(typeSel.checkedIndex);

        var encoderSettings =  JSON.parse(panelRobotController.getCustomSettings("encoderSet","[]"));
        for(var i=0,len = encoderSettings.length; i < len; ++i){
            encoderModel.append(encoderSettings[i]);
        }
    }
}

