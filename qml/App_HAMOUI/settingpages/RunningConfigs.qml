import QtQuick 1.1
import "../../ICCustomElement"
import "../ICOperationLog.js" as ICOperationLog
import "../configs/ConfigDefines.js" as ConfigDefines
import "../configs/AxisDefine.js" as AxisDefine
import "../configs/IODefines.js" as IODefines



Item {
    id:container
    width: parent.width
    height: parent.height
    ICSettingConfigsScope{
        anchors.fill: parent
        Grid{
            id:configSec1
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
        ICCheckBoxEdit{
            id:independentManualSpeed
            text: qsTr("Independent Manual Speed")
            anchors.top: configSec1.bottom
            anchors.topMargin: 6
            configAddr: "s_rw_0_32_0_211"
        }
        Grid{
            id:independentManualSpeedGroup
            anchors.top: independentManualSpeed.bottom
            anchors.topMargin: 6
            enabled: independentManualSpeed.isChecked
            columns: 3
            spacing: 6
            ICConfigEdit{
                id:m0Speed
                configName: AxisDefine.axisInfos[0].name + " " + qsTr("Manual Speed");
                configAddr: "s_rw_0_16_1_294"
                configNameWidth: 110
            }
            ICConfigEdit{
                id:m1Speed
                configName: AxisDefine.axisInfos[1].name + " " + qsTr("Manual Speed");
                configAddr: "s_rw_16_16_1_294"
                configNameWidth: m0Speed.configNameWidth

            }
            ICConfigEdit{
                id:m2Speed
                configName: AxisDefine.axisInfos[2].name + " " + qsTr("Manual Speed");
                configAddr: "s_rw_0_16_1_295"
                configNameWidth: m0Speed.configNameWidth
            }
            ICConfigEdit{
                id:m3Speed
                configName: AxisDefine.axisInfos[3].name + " " + qsTr("Manual Speed");
                configAddr: "s_rw_16_16_1_295"
                configNameWidth: m0Speed.configNameWidth
            }
            ICConfigEdit{
                id:m4Speed
                configName: AxisDefine.axisInfos[4].name + " " + qsTr("Manual Speed");
                configAddr: "s_rw_0_16_1_296"
                configNameWidth: m0Speed.configNameWidth
            }
            ICConfigEdit{
                id:m5Speed
                configName: AxisDefine.axisInfos[5].name + " " + qsTr("Manual Speed");
                configAddr: "s_rw_16_16_1_296"
                configNameWidth: m0Speed.configNameWidth
            }
            ICConfigEdit{
                id:m6Speed
                configName: AxisDefine.axisInfos[6].name + " " + qsTr("Manual Speed");
                configAddr: "s_rw_0_16_1_297"
                configNameWidth: m0Speed.configNameWidth
            }
            ICConfigEdit{
                id:m7Speed
                configName: AxisDefine.axisInfos[7].name + " " + qsTr("Manual Speed");
                configAddr: "s_rw_16_16_1_297"
                configNameWidth: m0Speed.configNameWidth
            }
        }
        Item{
            id:selMoldWithIO
//            visible: false
            width: parent.width*0.5
            anchors.top:muxForInput.bottom
            anchors.topMargin: 6
            height: parent.height - configSec1.height -independentManualSpeed.height - independentManualSpeedGroup.height - 20 -muxForInput.height
            ListModel{
                id:selItem
            }
            ICListView{
                id:itemView
                height:parent.height-80
                width: parent.width
                color: "white"
                model: selItem
                highlight: Rectangle { width: itemView.width; height: 25;color: "lightsteelblue"; }
                highlightMoveDuration: 1
                delegate: Text {
                    width:parent.width
                    height: 25
                    text: ioName + " "+qsTr("select")+":"+ moldName
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            itemView.currentIndex = index;
                        }
                    }
                }
            }
            Row{
                id:funcArea1
                anchors.top:itemView.bottom
                anchors.topMargin: 6
                spacing: 10
                ICComboBoxConfigEdit{
                    id:selIO
                    configName: qsTr("IO Select")
                    popupMode: 1
                    popupHeight: itemView.height
                    Component.onCompleted: {
                        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
                        if(ioBoardCount == 0)
                            ioBoardCount = 1;
                        var len = ioBoardCount * 32;
                        var ioItems = [];
                        for(var i = 0; i < len; ++i){
                            ioItems.push(IODefines.xDefines[i].pointName);
                        }
                        items = ioItems;
                        configValue = 0;
                    }
                }
                ICComboBoxConfigEdit{
                    id:selMold
                    configName: qsTr("Mold Select")
                    inputWidth:120
                    popupMode: 1
                    popupHeight: itemView.height
                    function refreshMoldList(){
                        var records = JSON.parse(panelRobotController.records());
                        var recordsItems = [];
                        for(var i = 0; i < records.length; ++i){
                            recordsItems.push(records[i].recordName);
                        }
                        selMold.items = recordsItems;
                    }
                    Component.onCompleted: {
                        refreshMoldList();
                        configValue = 0;
                    }
                }
            }
            Row{
                id:funcArea2
                anchors.top:funcArea1.bottom
                anchors.topMargin: 6
                anchors.right: parent.right
                spacing: 6
                ICButton{
                    id:newItem
                    text:qsTr("new")
                    onButtonClicked: {
                        for(var i=0;i<selItem.count;++i){
                            if(selIO.configText() == selItem.get(i).ioName)
                                return;
                            if(selMold.configText() == selItem.get(i).moldName)
                                return;
                        }
                        selItem.append({"ioID":selIO.configValue,"ioName":selIO.configText(),"moldName":selMold.configText()});
                        panelRobotController.setCustomSettings("MoldByIOGroup",JSON.stringify(getDataFromListModel()));
//                        console.log(JSON.stringify(getDataFromListModel()));
                    }
                }
                ICButton{
                    id:delItem
                    text:qsTr("delete")
                    onButtonClicked: {
                        selItem.remove(itemView.currentIndex);
                        panelRobotController.setCustomSettings("MoldByIOGroup",JSON.stringify(getDataFromListModel()));
                    }
                }
            }
            Component.onCompleted: {
                var updateListData = panelRobotController.getCustomSettings("MoldByIOGroup","");
//                console.log(updateListData);
                updateListData = JSON.parse(updateListData);
                for(var i=0;i<updateListData.length;++i){
                    selItem.append({"ioID":updateListData[i].ioID,"ioName":updateListData[i].ioName,"moldName":updateListData[i].mold});
                }
            }
            onVisibleChanged: {
                if(visible){
                    selMold.refreshMoldList();
                }
            }
        }


        Grid{
            id:muxForInput
//            anchors.left: selMoldWithIO.right
//            anchors.leftMargin: 6
            anchors.top: independentManualSpeedGroup.bottom
            anchors.topMargin: 6
            columns: 4
            spacing: 6
            ICCheckBox{
                id:x32UseForOrigin
                text:qsTr("x32 Mux for Origin mode Btn");
                onIsCheckedChanged: {
                    panelRobotController.setCustomSettings("X32UseForOrigin", isChecked ? 1 : 0);
                }
            }
            ICCheckBox{
                id:x33UseForAuto
                text:qsTr("x33 Mux for Auto mode Btn");
                onIsCheckedChanged: {
                    panelRobotController.setCustomSettings("X33UseForAuto", isChecked ? 1 : 0);
                }
            }
            ICCheckBox{
                id:x46UseForStartup
                text:qsTr("x46 Mux for Startup Btn");
                onIsCheckedChanged: {
                    panelRobotController.setCustomSettings("X46UseForStartup", isChecked ? 1 : 0);
                }
            }
            ICCheckBox{
                id:x47UseForStop
                text:qsTr("x47 Mux for Stop Btn");
                onIsCheckedChanged: {
                    panelRobotController.setCustomSettings("X47UseForStop", isChecked ? 1 : 0);
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
        x32UseForOrigin.isChecked = panelRobotController.getCustomSettings("X32UseForOrigin", 0);
        x33UseForAuto.isChecked = panelRobotController.getCustomSettings("X33UseForAuto", 0);
        x46UseForStartup.isChecked = panelRobotController.getCustomSettings("X46UseForStartup", 0);
        x47UseForStop.isChecked = panelRobotController.getCustomSettings("X47UseForStop", 0);
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }

    function onAxisDefinesChanged(){
        m0Speed.visible = AxisDefine.axisInfos[0].visiable;
        m1Speed.visible = AxisDefine.axisInfos[1].visiable;
        m2Speed.visible = AxisDefine.axisInfos[2].visiable;
        m3Speed.visible = AxisDefine.axisInfos[3].visiable;
        m4Speed.visible = AxisDefine.axisInfos[4].visiable;
        m5Speed.visible = AxisDefine.axisInfos[5].visiable;
        m6Speed.visible = AxisDefine.axisInfos[6].visiable;
        m7Speed.visible = AxisDefine.axisInfos[7].visiable;
    }

    function getDataFromListModel(){
        var moldByIOGroup = [];
        for(var i=0;i<selItem.count;++i){
            moldByIOGroup.push({"ioID":selItem.get(i).ioID,"ioName":selItem.get(i).ioName,"mold":selItem.get(i).moldName});
        }
        return moldByIOGroup;
    }

}
