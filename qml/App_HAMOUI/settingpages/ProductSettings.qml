import QtQuick 1.1
import "../../ICCustomElement"
import '..'
import "../configs/IODefines.js" as IODefines
import "../configs/IOConfigs.js" as IOConfigs
import "../teach/ManualProgramManager.js" as ManualProgramManager
import "RunningConfigs.js" as MData
import "../ShareData.js" as ShareData

Item {
    id:root
    function showMenu(){
        for(var i = 0; i < pages.length; ++i){
            pages[i].visible = false;
        }
        menu.visible = true;
    }
    property variant pages: []
    QtObject{
        id:pData
        property variant useNoUseText: [qsTr("NoUse"), qsTr("Use")]
        property variant ledItem: [qsTr("Input"),qsTr("IO output"),qsTr("M value")]
        property variant keyItem: [qsTr("IO output"),qsTr("M value"),qsTr("Program Button")]
        property variant funcItem:[qsTr("status turn"),qsTr("keepPress"),qsTr("On"),qsTr("Off")]
    }

    Grid{
        id:menu
        x:6
        columns: 4
        spacing: 20
        anchors.centerIn: parent

        CatalogButton{
            id:productMenuBtn
            text: qsTr("Product")
            icon: "../images/product.png"
            y:10
            x:10
            onButtonClicked: {
                productPage.visible = true;
                menu.visible = false;
            }
        }
        CatalogButton{
            id:valveSettingsMenuBtn
            text: qsTr("Valve Settings")
            icon: "../images/settings_valve_define.png"
            onButtonClicked: {
                valveSettings.visible = true;
                menu.visible = false;
            }
        }
        CatalogButton{
            id:customVariablesSettingsMenuBtn
            text: qsTr("custom Variables")
            icon: "../images/product.png"
            visible: false
            onButtonClicked: {
                if(!customVariableConfigs.hasInit){
                    customVariableConfigs.init();
                }
                customVariableConfigs.visible = true;
                menu.visible = false;
            }
        }
        CatalogButton{
            id:ioRunningSettingMenuBtn
            text: qsTr("IO Running Setting")
            icon: "../images/IOsetting.png"
            y:10
            x:10
            onButtonClicked: {
                ioRunningSettingPage.visible = true;
                menu.visible = false;
            }
        }
        CatalogButton{
            id:ledAndKeySettingMenuBtn
            text: qsTr("Led And Key Setting")
            icon: "../images/LedAndKeySetting.png"
            y:10
            x:10
            onButtonClicked: {
                ledAndKeySettingPage.visible = true;
                menu.visible = false;
            }
        }
    }

    ICSettingConfigsScope{
        id:productPage
        visible: false
        width: parent.width
        height: parent.height
        y:10
        x:10
        Row{
            spacing: 10
            Column{
                ICComboBoxConfigEdit{
                    id:program0
                    width: 140
                    height: 32
                    configName: qsTr("Program0")
                    configAddr: "m_rw_0_1_0_357"
                    items: pData.useNoUseText
                    configNameWidth: 80
                    z:10
                }
                ICComboBoxConfigEdit{
                    id:program1
                    width: program0.width
                    height: 32
                    configName: qsTr("Program1")
                    configAddr: "m_rw_1_1_0_357"
                    items: pData.useNoUseText
                    z:9
                    configNameWidth: program0.configNameWidth

                }
                ICComboBoxConfigEdit{
                    id:program2
                    width: program0.width
                    height: 32
                    configName: qsTr("Program2")
                    configAddr: "m_rw_2_1_0_357"
                    items: pData.useNoUseText
                    z:8
                    configNameWidth: program0.configNameWidth

                }
                ICComboBoxConfigEdit{
                    id:program3
                    width: program0.width
                    height: 32
                    configName: qsTr("Program3")
                    configAddr: "m_rw_3_1_0_357"
                    items: pData.useNoUseText
                    z:7
                    configNameWidth: program0.configNameWidth

                }
                ICComboBoxConfigEdit{
                    id:program4
                    width: program0.width
                    height: 32
                    configName: qsTr("Program4")
                    configAddr: "m_rw_4_1_0_357"
                    items: pData.useNoUseText
                    z:6
                    configNameWidth: program0.configNameWidth

                }
                ICComboBoxConfigEdit{
                    id:program5
                    width: program0.width
                    height: 32
                    configName: qsTr("Program5")
                    configAddr: "m_rw_5_1_0_357"
                    items: pData.useNoUseText
                    z:5
                    configNameWidth: program0.configNameWidth

                }
                ICComboBoxConfigEdit{
                    id:program6
                    width: program0.width
                    height: 32
                    configName: qsTr("Program6")
                    configAddr: "m_rw_6_1_0_357"
                    items: pData.useNoUseText
                    z:4
                    configNameWidth: program0.configNameWidth

                }
                ICComboBoxConfigEdit{
                    id:program7
                    width: program0.width
                    height: 32
                    configName: qsTr("Program7")
                    configAddr: "m_rw_7_1_0_357"
                    items: pData.useNoUseText
                    z:3
                    configNameWidth: program0.configNameWidth

                }
                ICComboBoxConfigEdit{
                    id:program8
                    width: program0.width
                    height: 32
                    configName: qsTr("Program8")
                    configAddr: "m_rw_8_1_0_357"
                    items: pData.useNoUseText
                    z:2
                    configNameWidth: program0.configNameWidth
                    visible: false
                }

            }
        }
    }

    ValveSettings{
        id:valveSettings
        visible: false
        width: parent.width
        height: parent.height
        y:10
        x:10
    }

    CustomVariableConfigs{
        id:customVariableConfigs
        visible: false;
        y:10
        x:10
    }

    Item {
        id:ioRunningSettingPage
        width:  parent.width
        height: parent.height
        ICButtonGroup{
            id:typeSel
            checkedItem: modeStatus
            checkedIndex: 0
            mustChecked: true
            spacing: 10
            x:5
            y:3
            ICCheckBox{
                id:modeStatus
                text: qsTr("Mode")
                isChecked: true
            }
            ICCheckBox{
                id:ioStatus
                text: qsTr("IO")
            }
            onCheckedIndexChanged: {
                pageContainer.setCurrentIndex(checkedIndex);
            }
        }
        ListModel{
            id:valveModel
        }
        ListModel{
            id:ioModel
        }

        ICStackContainer{
            id:pageContainer
            width: parent.width-3
            height: parent.height -newBtn.height -10 -modeStatus.height -6
            anchors.top:typeSel.bottom
            anchors.topMargin: 5
            ICListView{
                id:valveContainer
                model:valveModel
                spacing: 10
                border.color: "gray"
                border.width: 1
                delegate: Row{
                    spacing: 8
                    z: 1000-index
                    ICCheckBox {
                        text: index+":"+qsTr("When the mode change to")
                        anchors.verticalCenter: parent.verticalCenter
                        isChecked: check
                        onIsCheckedChanged: {
                            valveModel.setProperty(index,"check",isChecked);
                        }
                    }
                    ICComboBoxConfigEdit{
                        indexMappedValue: [
                            16,17,18,19,1,2,3,5,6,7,8,9,10,11
                        ]
                        /*
    var CMD_NULL = 0; //< 无命令
    var CMD_MANUAL = 1; //< 手动命令
    var CMD_AUTO = 2; //< 自动命令
    var CMD_CONFIG = 3; //< 配置命令
    var CMD_IO = 4; // IO命令
    var CMD_ORIGIN = 5; // 原点模式
    var CMD_RETURN = 6; // 复归模式
    var CMD_RUNNING = 7 // 自动运行中
    var CMD_SINGLE = 8//< 单步模式
    var CMD_ONE_CYCLE = 9//< 单循环模式
    var CMD_ORIGIN_ING = 10; // 正在寻找原点中
    var CMD_RETURN_ING = 11; // 原点复归中
    var CMD_STANDBY = 15; // 待机模式
    CMD_MANUAL_TO_STOP=16 手动--->停止
    CMD_STOP_TO_MANUAL=17 停止--->手动
    CMD_STOP_TO_AUTO  =18 停止--->自动
    CMD_AUTO_TO_STOP  =19 自动--->停止
    */
                        items: [
                            qsTr("CMD_MANUAL_TO_STOP"),
                            qsTr("CMD_STOP_TO_MANUAL"),
                            qsTr("CMD_STOP_TO_AUTO"),
                            qsTr("CMD_AUTO_TO_STOP"),
    //                        qsTr("CMD_NULL"),
                        qsTr("CMD_MANUAL"),
                        qsTr("CMD_AUTO"),
                        qsTr("CMD_CONFIG"),
    //                    qsTr("CMD_IO"),
                        qsTr("CMD_ORIGIN"),
                        qsTr("CMD_RETURN"),
                        qsTr("CMD_RUNNING"),
                        qsTr("CMD_SINGLE"),
                        qsTr("CMD_ONE_CYCLE"),
                        qsTr("CMD_ORIGIN_ING"),
                        qsTr("CMD_RETURN_ING")]//,
    //                    qsTr("CMD_NULL"),
    //                    qsTr("CMD_NULL"),
    //                    qsTr("CMD_NULL"),
    //                    qsTr("CMD_STANDBY"),]
    //                    width: 70
                        configValue: mode
                        onConfigValueChanged: {
                            valveModel.setProperty(index,"mode",configValue);
                            valveModel.setProperty(index,"sendMode",getConfigValue());
                        }
                    }
                    ICComboBoxConfigEdit{
                        id:outType
                        configName: qsTr("Choos Out")
                        items: [qsTr("IO output"),qsTr("M output")]
                        onConfigValueChanged: {
                            if(configValue<0||configValue>1)return;
                            valveModel.setProperty(index,"outType_init",configValue);
                            if(configValue ==0){
                                if(outid_init >= MData.yDefinesList.length){
                                    outid.currentIndex = 0;
                                }
                                outid.items = MData.yDefinesList;
                            }
                            else if(configValue ==1){
                                if(outid_init >= MData.mDefinesList.length){
                                    outid.currentIndex = 0;
                                }
                                outid.items = MData.mDefinesList;
                            }
                        }
                        configValue: outType_init
                    }
                    Text {
                        text: qsTr("output point")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ICComboBox{
                        id: outid
                        width: 120
                        currentIndex: outid_init
                        onCurrentIndexChanged: {
                            valveModel.setProperty(index,"outid_init",currentIndex);
                        }
                    }
                    ICComboBox{
                        id: outstatus
                        items: [qsTr("OFF"), qsTr("ON")]
                        width: 40
                        currentIndex: outstatus_init
                        onCurrentIndexChanged: {
                            valveModel.setProperty(index,"outstatus_init",currentIndex);
                        }
                    }
                    ICButton{
                        id:deleteCurrent
                        height:outstatus.height
                        text: qsTr("Delete")
                        onButtonClicked: {
                            valveModel.remove(index);
                        }
                    }
                }
            }
            ICListView{
                id:ioContainer
                model:ioModel
                spacing: 10
                border.color: "gray"
                border.width: 1
                delegate: Item {
                    height: inputRow.height + outputRow.height
                    width: parent.width
                    Row{
                        id:inputRow
                        spacing: 8
                        z: 1000-index;
                        ICCheckBox {
                            text: index+":    "+qsTr("When")
                            anchors.verticalCenter: parent.verticalCenter
                            isChecked: check
                            onIsCheckedChanged: {
                                ioModel.setProperty(index,"check",isChecked);
                            }
                        }
                        ICComboBox{
                            items: pData.ledItem
                            currentIndex: checkType
                            onCurrentIndexChanged: {
                                ioModel.setProperty(index,"checkType",currentIndex);
                                if(currentIndex == 0){
                                    if(checkId>=MData.xDefinesList.length){
                                        selCheckId.currentIndex =0;
                                    }
                                    selCheckId.items = MData.xDefinesList;
                                }
                                else if(currentIndex == 1){
                                    if(checkId>=MData.yList.length){
                                        selCheckId.currentIndex =0;
                                    }
                                    selCheckId.items = MData.yList;
                                }
                                else if(currentIndex == 2){
                                    if(checkId>=MData.mDefinesList.length){
                                        selCheckId.currentIndex =0;
                                    }
                                    selCheckId.items = MData.mDefinesList;
                                }
                            }
                        }
                        ICComboBox{
                            id:selCheckId
                            currentIndex: checkId
                            onCurrentIndexChanged: {
                               ioModel.setProperty(index,"checkId",currentIndex);
                            }
                        }
                        ICComboBoxConfigEdit{
                            configName: qsTr("status to")
                            width: 40
                            items: [qsTr("OFF"), qsTr("ON")]
                            configValue: checkStatus
                            onConfigValueChanged: {
                                ioModel.setProperty(index,"checkStatus",configValue);
                            }
                        }
                    }
                    Row{
                        id:outputRow
                        spacing: 8
                        anchors.top:inputRow.bottom
                        anchors.topMargin: 5
                        x: 180
                        z: 1000-index
                        ICComboBoxConfigEdit{
                            configName: qsTr("Choos Out")
                            configValue: outType
                            items: [qsTr("IO output"),qsTr("M output")]
                            onConfigValueChanged: {
                                if(configValue<0||configValue>1)return;
                                ioModel.setProperty(index,"outType",configValue);
                                if(configValue == 0){
                                    if(outId>=MData.yDefinesList.length){
                                        selOutId.currentIndex =0;
                                    }
                                    selOutId.items = MData.yDefinesList;
                                }
                                else if(configValue == 1){
                                    if(outId>=MData.mDefinesList.length){
                                        selOutId.currentIndex =0;
                                    }
                                    selOutId.items = MData.mDefinesList;
                                }
                            }
                        }
                        ICComboBoxConfigEdit {
                            id: selOutId
                            configName: qsTr("output point")
                            configValue: outId
                            onConfigValueChanged: {
                                ioModel.setProperty(index,"outId",configValue);
                            }
                        }
                        ICComboBox{
                            items: [qsTr("OFF"), qsTr("ON")]
                            width: 40
                            currentIndex: outStatus
                            onCurrentIndexChanged: {
                                ioModel.setProperty(index,"outStatus",currentIndex);
                            }
                        }
                        ICButton{
                            id:deleteitem
                            height:selCheckId.height
                            text: qsTr("Delete")
                            onButtonClicked: {
                                ioModel.remove(index);
                            }
                        }
                    }
                }
            }

            Component.onCompleted: {
                pageContainer.addPage(valveContainer);
                pageContainer.addPage(ioContainer);
                pageContainer.setCurrentIndex(typeSel.checkedIndex);
            }
        }

        Row{
            id:newAndPreservation
            anchors.top: pageContainer.bottom
            anchors.topMargin: 3
            spacing: 20
            x:5
            ICButton{
                id:newBtn
                text: qsTr("new")
                onButtonClicked: {
                    if(typeSel.checkedItem == modeStatus){
                        valveModel.append({"check":true,"mode":6,"sendMode":3,"outType_init":0,"outid_init":0,"outstatus_init":0});
                    }
                    else if(typeSel.checkedItem == ioStatus){
                        ioModel.append({"check":true,"checkType":0,"checkId":0,"checkStatus":0,"outType":0,"outId":0,"outStatus":0});
                    }
                }
            }
            ICButton{
                id:saveBtn
                text: qsTr("Preservation")
                onButtonClicked: {
                    var toSave = [];
                    var v,isNormal=true;
                    var value = 0,ret =[];
                    if(typeSel.checkedItem == modeStatus){
                        panelRobotController.modifyConfigValue(14,0);
                        for(var i=0;i<valveModel.count;i++)
                        {
                            v = valveModel.get(i);
                            toSave.push(v);
                            if(v.check == true){
                                console.log("send:");
                                value=v.outstatus_init?1:0;
                                if(v.outType_init==0){
                                    ret = MData.getOutIDFromConfig(v.outid_init);
                                    value|=ret[1]<<1;
                                    isNormal = ret[0];
                                }
                                else{
                                    value|=v.outid_init<<1;
                                }
//                                value|=v.outid_init<<1;
                                value|=v.outType_init<<8;
                                value|=v.sendMode<<9;
                                value|=isNormal<<14;
                                console.log(isNormal,ret[1],value);
                                panelRobotController.modifyConfigValue(13,value);
                            }
                        }
                        panelRobotController.setCustomSettings("IOSettings", JSON.stringify(toSave), "IOSettings");
                        console.log(JSON.stringify(toSave));
                    }
                    else if(typeSel.checkedItem == ioStatus){
                        panelRobotController.modifyConfigValue(33,0);
                        for(var i=0;i<ioModel.count;i++)
                        {
                            v = ioModel.get(i);
                            toSave.push(v);
                            if(v.check == true){
                                console.log("send:");
                                value =v.checkStatus?1:0;
                                value|=v.checkId<<1;
                                value|=v.checkType<<8;
                                value|=v.outStatus<<10;
                                if(v.outType==0){
                                    ret = MData.getOutIDFromConfig(v.outId);
                                    value|=ret[1]<<11;
                                    isNormal = ret[0];
                                }
                                else{
                                    value|=v.outId<<11;
                                }
                                value|=v.outType<<18;
                                value|=isNormal<<19;
                                console.log(isNormal,ret[1],value);
                                panelRobotController.modifyConfigValue(32,value);
                            }
                        }
                        panelRobotController.setCustomSettings("IOCheckSet", JSON.stringify(toSave), "IOCheckSet");
                        console.log(JSON.stringify(toSave));
                    }
                }
            }
            Text {
                id: tips
                color: "red"
//                horizontalCenter: parent.horizontalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//                y:saveBtn.y-5
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Tips:New or modified, click Save to take effect!")
            }
        }
    }

    Item {
        id:ledAndKeySettingPage
        width:  parent.width
        height: parent.height
        ListModel{
            id:keyModel
        }
        Row{
            x:4
            id:clickArea
            spacing: 20
            ICButton{
                id:saveKeyBtn
                text: qsTr("Preservation")
                onButtonClicked: {
                    refreshLedKeyData();
                    console.log(JSON.stringify(MData.ledKesSetData));
                    panelRobotController.setCustomSettings("LedAndKeySetting", JSON.stringify(MData.ledKesSetData), "LedAndKeySetting");
                }
            }
            ICButton{
                id:clearDatabase
                visible: false
                text: qsTr("Clear Database")
                function onUserChanged(user){
                    clearDatabase.visible = ShareData.UserInfo.currentSZHCPerm();
                }
                onButtonClicked: {
                    panelRobotController.setCustomSettings("LedAndKeySetting", "[]", "LedAndKeySetting");
                }
                Component.onCompleted: {
                    ShareData.UserInfo.registUserChangeEvent(clearDatabase);
                }
            }
        }
        ICListView{
            id:modelContainer
            anchors.top: clickArea.bottom
            width: parent.width
            height: parent.height
            spacing: 10
            z:10
            delegate:
                Item {
                width: parent.width
                height: settingRow.height

                Rectangle{
                    id:modelSelItem
                    visible: false
                    width: 300
                    height: 150
                    border.color: "black"
                    border.width: 1
                    color: "#A0A0F0"
                    x:400
                    y:0-((settingRow.height+10)*index)
                    Text {
                        x:5
                        y:5
                        id: keyTip
                        text: qsTr("key Func in this mode");
                    }
                    Flow{
                        id:modeFlow
                        x:5
                        width: parent.width
                        height: parent.height - buttonArea.height
                        anchors.top: keyTip.bottom
                        anchors.topMargin: 5
                        property variant isModeSel: [manualMode.isChecked,stopMode.isChecked,autoMode.isChecked,
                        runningMode.isChecked,singleMode.isChecked,oneCycleMode.isChecked]
                        spacing: 4
                        ICCheckBox{
                            id:manualMode
                            text: qsTr("ManualMode")
                            isChecked: (usefulMode&(1<<0)) ==0?false:true
                        }
                        ICCheckBox{
                            id:stopMode
                            text: qsTr("StopMode")
                            isChecked: (usefulMode&(1<<1)) ==0?false:true
                        }
                        ICCheckBox{
                            id:autoMode
                            text: qsTr("AutoMode")
                            isChecked: (usefulMode&(1<<2)) ==0?false:true
                        }
                        ICCheckBox{
                            id:runningMode
                            text: qsTr("RunningMode")
                            isChecked: (usefulMode&(1<<3)) ==0?false:true
                        }
                        ICCheckBox{
                            id:singleMode
                            text: qsTr("SingleMode")
                            isChecked: (usefulMode&(1<<4)) ==0? false:true
                        }
                        ICCheckBox{
                            id:oneCycleMode
                            text: qsTr("OneCycleMode")
                            isChecked:(usefulMode&(1<<5)) ==0?false:true
                        }
                    }

                    ICButton{
                        id:buttonArea
                        bgColor: "lime"
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        text:qsTr("Ok")
                        onButtonClicked: {
                            var thisMode = 0;
                            for(var i=0,len= modeFlow.isModeSel.length;i<len;++i){
                                if(modeFlow.isModeSel[i]){
                                    thisMode |= 1<<i;
                                }
                            }
                            keyModel.setProperty(index,"usefulMode",thisMode);
                            modelSelItem.visible =false;
                            modeSel.enabled =true;
                        }
                    }
                }
                Row{
                    id:settingRow
                    spacing: 20
                    function refreshPropertyThingID(){
                        if(bindingNum >=0){
                            if(type==0){
                                if(bindingType == 0){
                                    keyModel.setProperty(index,"thingID",bindingNum);
                                }
                                else if(bindingType == 1){
                                    keyModel.setProperty(index,"thingID",bindingNum);
                                }
                                else if(bindingType == 2){
                                    keyModel.setProperty(index,"thingID",MData.mOutList[bindingNum].id);
                                }
                            }
                            else{
                                if(bindingType == 0){
                                    keyModel.setProperty(index,"thingID",MData.yOutList[bindingNum].id);
                                }
                                else if(bindingType == 1){
                                    keyModel.setProperty(index,"thingID",MData.mOutList[bindingNum].id);
                                }
                                else if(bindingType == 2){
                                    keyModel.setProperty(index,"thingID",MData.programIDList[bindingNum]);
                                }
                            }
                        }
                        else{
                            keyModel.setProperty(index,"thingID",-1);
                        }
                    }


                    ICCheckBox {
                        text: type==0?qsTr("Led")+qsTr(" ")+(index+1)+qsTr("  ")+qsTr("status binding"):
                                       qsTr("Key F")+(index-4)+qsTr("function binding")
                        anchors.verticalCenter: parent.verticalCenter
                        isChecked: functionCheck
                        onIsCheckedChanged: keyModel.setProperty(index,"functionCheck", isChecked);
                    }

                    ICButton{
                        id:modeSel
                        visible:type===1?true:false
                        height: bindingTypeChoose.height
                        text: qsTr("Mode Sel")
                        onButtonClicked: {
                            enabled = false;
                            modelSelItem.visible =true;
                        }
                    }

                    ICComboBox{
                        id: bindingTypeChoose
                        items: type==0?pData.ledItem:pData.keyItem
                        currentIndex: bindingType
                        onCurrentIndexChanged: {
                            keyModel.setProperty(index,"bindingType",currentIndex);
                            var ioItems = [];
                            var len,i;
                            if(type==0){
                                switch(currentIndex)
                                {
                                default:
                                case 0:ioItems = MData.xDefinesList;
                                    break;
                                case 1:ioItems = MData.yList;
                                    break;
                                case 2:ioItems = MData.mDefinesList;
                                }
                            }
                            else{
                                switch(currentIndex)
                                {
                                default:
                                case 0:ioItems = MData.yDefinesList;
                                    break;
                                case 1:ioItems = MData.mDefinesList;
                                    break;
                                case 2:ioItems = MData.programList;
                                    break;
                                }
                            }
                            if(ioItems.length <= bindingNum){
                                if(ioItems.length == 0 ){
                                    bindingIdChoose.currentIndex = -1;
                                }
                                else{
                                    bindingIdChoose.currentIndex = 0;
                                }
                                bindingIdChoose.items = ioItems;
                            }
                            else{
                                bindingIdChoose.items = ioItems;
                                if(bindingNum == -1 && ioItems.length>0){
                                    bindingIdChoose.currentIndex = 0;
                                }
                            }

                            settingRow.refreshPropertyThingID();
                        }
                    }

                    ICComboBox{
                        id:keyFunctionType
                        visible: (type && bindingType<2)
                        width: 100
                        items: pData.funcItem
                        currentIndex: keyFuncType
                        onCurrentIndexChanged: {
                            keyModel.setProperty(index,"keyFuncType",currentIndex);
                        }
                    }
                    ICComboBox{
                        id: bindingIdChoose
                        width:  100
                        currentIndex: bindingNum
                        onCurrentIndexChanged: {
                            keyModel.setProperty(index,"bindingNum",currentIndex);
                            settingRow.refreshPropertyThingID();
                        }
                    }
                }
            }
        }
    }


    onVisibleChanged: {
        if(visible)
            showMenu();
    }

    Component.onCompleted: {
        var ps = [];
        ps.push(productPage);
        ps.push(valveSettings);
        ps.push(customVariableConfigs);
        ps.push(ioRunningSettingPage);
        ps.push(ledAndKeySettingPage);
        pages = ps;
        var i,len;

        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
        if(ioBoardCount == 0)
            ioBoardCount = 1;
        len = ioBoardCount * 32;
        for(i = 0; i < len; ++i){
            MData.xDefinesList.push(IODefines.ioItemName(IODefines.xDefines[i]));
            MData.yList.push(IODefines.yDefines[i].pointName);
        }
        var valveTmp;

        var yDefines = IOConfigs.manualShowValves;
        for(i = 0, len = yDefines.length; i < len; ++i){
            valveTmp = IODefines.getValveItemFromValveName(yDefines[i]);
            MData.yOutList.push(valveTmp);
            MData.yDefinesList.push(IODefines.getYDefineFromHWPoint(valveTmp.y1Point, valveTmp.y1Board).yDefine.pointName+":"+valveTmp.descr);
        }

//        MData.yOutList = IODefines.valveDefines.getValves(IOConfigs.kIO_TYPE.yOut);
//        for(i = 0,len =MData.yOutList.length; i < len; ++i){
//            valveTmp = MData.yOutList[i];
//            MData.yDefinesList.push(IODefines.getYDefineFromHWPoint(valveTmp.y1Point, valveTmp.y1Board).yDefine.pointName+":"+valveTmp.descr);
//        }
        MData.mOutList = IODefines.valveDefines.getValves(IOConfigs.kIO_TYPE.mY);
        for(i = 0,len = MData.mOutList.length; i < len; ++i){
            valveTmp = MData.mOutList[i];
            MData.mDefinesList.push(IODefines.getYDefineFromHWPoint(valveTmp.y1Point, IODefines.M_BOARD_0).yDefine.pointName+":"+valveTmp.descr);
        }
        onProgramAdded();
        ManualProgramManager.manualProgramManager.registerMonitor(root);
        var iosettings = JSON.parse(panelRobotController.getCustomSettings("IOSettings", "[]", "IOSettings"));
        for(i = 0, len = iosettings.length; i < len; ++i){
            valveModel.append(iosettings[i]);
        }
        iosettings = JSON.parse(panelRobotController.getCustomSettings("IOCheckSet", "[]", "IOCheckSet"));
        for(i = 0, len = iosettings.length; i < len; ++i){
            ioModel.append(iosettings[i]);
        }
//        panelRobotController.setCustomSettings("LedAndKeySetting", "[]", "LedAndKeySetting");
        MData.ledKesSetData = JSON.parse(panelRobotController.getCustomSettings("LedAndKeySetting", "[]", "LedAndKeySetting"));
        len = MData.ledKesSetData.length;
        var isRem = false;
        if(len>0){
            if(MData.ledKesSetData[0].hasOwnProperty("usefulMode")){
                isRem = true;
            }
        }
        if(len === 10 && isRem){
            console.log("load");
            for(i = 0; i < len; ++i){
                keyModel.append(MData.ledKesSetData[i]);
            }
        }
        else{
            console.log("new");
            for(i = 0; i < 10; ++i){
                keyModel.append({"functionCheck":0,"type":(i<5?0:1),"bindingType":0,"keyFuncType":0,"bindingNum":0,"thingID":0,"usefulMode":3});
            }
        }
        refreshLedKeyData();
        modelContainer.model = keyModel;
    }



    function refreshLedKeyData(){
        MData.ledKesSetData =[];
        for(var i=0;i<keyModel.count;i++){
            MData.ledKesSetData.push(keyModel.get(i));
        }
    }

    function onProgramAdded(){
        MData.programList = ManualProgramManager.manualProgramManager.programsNameList();
        MData.programIDList = ManualProgramManager.manualProgramManager.programsIDList();
        var tmpIDList = MData.programIDList;
        var i,len,tmpID;
        for( i=0,len=tmpIDList.length;i<len;++i){
            tmpID = tmpIDList[i];
            if(tmpID ==0){
                MData.programList.splice(i,1);
                MData.programIDList.splice(i,1);
            }
        }
        tmpIDList = MData.programIDList;
        for( i=0,len=tmpIDList.length;i<len;++i){
            tmpID = tmpIDList[i];
            if(tmpID ==1){
                MData.programList.splice(i,1);
                MData.programIDList.splice(i,1);
            }
        }

    }
    function onProgramRemoved(){
        MData.programList = ManualProgramManager.manualProgramManager.programsNameList();
        MData.programIDList = ManualProgramManager.manualProgramManager.programsIDList();
        var tmpIDList = MData.programIDList;
        var i,len,tmpID;
        for( i=0,len=tmpIDList.length;i<len;++i){
            tmpID = tmpIDList[i];
            if(tmpID ==0){
                MData.programList.splice(i,1);
                MData.programIDList.splice(i,1);
            }
        }
        tmpIDList = MData.programIDList;
        for( i=0,len=tmpIDList.length;i<len;++i){
            tmpID = tmpIDList[i];
            if(tmpID ==1){
                MData.programList.splice(i,1);
                MData.programIDList.splice(i,1);
            }
        }
    }
}
