import QtQuick 1.1
import "../../ICCustomElement"
import '..'
import "../configs/IODefines.js" as IODefines
import "../configs/IOConfigs.js" as IOConfigs
import "../teach/ManualProgramManager.js" as ManualProgramManager
import "RunningConfigs.js" as MData

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
        ListModel{
            id:valveModel
        }
        Row{
            id:newAndPreservation
            spacing: 20
                ICButton{
                    id:newBtn
                    text: qsTr("new")
                    onButtonClicked: {
                        valveModel.append({"check":true,"mode":6,"sendMode":3,"outType_init":0,"outid_init":4,"outstatus_init":0})
                    }
                }
                ICButton{
                    id:saveBtn
                    text: qsTr("Preservation")
                    onButtonClicked: {
                        var toSave = [];
                        var v;
                        panelRobotController.modifyConfigValue(14,0);
                        for(var i=0;i<valveModel.count;i++)
                        {
                            v = valveModel.get(i);
                            toSave.push(v);
                            if(v.check == true){
                                console.log("send:");
                                /*
typedef union {
    struct{
        uint16_t on:1;//< 输出 普通IO或则M值 0为断，1为通
        uint16_t id:7;//< 输出点ID 普通IO或则M值
        uint16_t out_type:1;//< 输出类型 0为普通输出，1为M值输出
        uint16_t type:5;//< 类型
        uint16_t res:2;//< 预留
    }bit;
    uint16_t io_all;
}IORunningSetting;//< IO运行设定
*/
                                var value = 0;
                                value=v.outstatus_init?1:0;
                                value|=v.outid_init<<1;
                                value|=v.outType_init<<8;
                                value|=v.sendMode<<9;
                                console.log(value);
                                panelRobotController.modifyConfigValue(13,value);
                            }
                        }
                        panelRobotController.setCustomSettings("IOSettings", JSON.stringify(toSave), "IOSettings");
                        console.log(JSON.stringify(toSave));
                    }
                }
        }
        ICListView{
            id:valveContainer
            anchors.top: newAndPreservation.bottom
            width: parent.width
            height: parent.height
            model:valveModel
            spacing: 10
            delegate: Row{
                spacing: 8
                z: 1000-index;

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
                        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
                        if(ioBoardCount == 0)
                            ioBoardCount = 1;
                        var len = ioBoardCount * 32;
                        len=configValue == 0?len:16;
                        var ioItems = [];
                        for(var i = 0; i < len; ++i){
                            ioItems.push(IODefines.ioItemName(IODefines[configValue == 0 ? "yDefines":"mYDefines"][i]));
                        }
                        outid.items = ioItems;
                    }
                    configValue: outType_init
                }
                Text {
                    text: qsTr("output point")
                    anchors.verticalCenter: parent.verticalCenter
                }
                ICComboBox{
                    id: outid
                    width: 180
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
    }

    Item {
        id:ledAndKeySettingPage
        width:  parent.width
        height: parent.height
        ListModel{
            id:keyModel
        }
        ICButton{
            id:saveKeyBtn
            text: qsTr("Preservation")
            onButtonClicked: {
                refreshLedKeyData();
                console.log(JSON.stringify(MData.ledKesSetData));
                panelRobotController.setCustomSettings("LedAndKeySetting", JSON.stringify(MData.ledKesSetData), "LedAndKeySetting");
            }
        }
        ICListView{
            id:modelContainer
            anchors.top: saveKeyBtn.bottom
            width: parent.width
            height: parent.height
            spacing: 10
            z:10
            delegate:
            Row{
                id:settingRow
                spacing: 20
                z: 1000-index;
                function refreshPropertyThingID(){
                    if(bindingNum >=0){
                        if(type==0){
                            if(bindingType == 0){
                                keyModel.setProperty(index,"thingID",bindingNum);
                            }
                            else if(bindingType == 1){
                                keyModel.setProperty(index,"thingID",MData.yOutList[bindingNum].id);
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
                            case 1:ioItems = MData.yDefinesList;
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
                                console.log("1");
                                bindingIdChoose.currentIndex = 0;
                            }
                            bindingIdChoose.items = ioItems;
                        }
                        else{
                            bindingIdChoose.items = ioItems;
                            if(bindingNum == -1 && ioItems.length>0){
                                console.log("2");
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
        var iosettings = JSON.parse(panelRobotController.getCustomSettings("IOSettings", "[]", "IOSettings"));
        for(i = 0, len = iosettings.length; i < len; ++i){
            valveModel.append(iosettings[i]);
        }

        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
        if(ioBoardCount == 0)
            ioBoardCount = 1;
        len = ioBoardCount * 32;
        for(i = 0; i < len; ++i){
            MData.xDefinesList.push(IODefines.ioItemName(IODefines.xDefines[i]));
        }
        var valveTmp;
        MData.yOutList = IODefines.valveDefines.getValves(IOConfigs.kIO_TYPE.yOut);
        for(i = 0,len =MData.yOutList.length; i < len; ++i){
            valveTmp = MData.yOutList[i];
            MData.yDefinesList.push(IODefines.getYDefineFromHWPoint(valveTmp.y1Point, valveTmp.y1Board).yDefine.pointName+":"+valveTmp.descr);
        }
        MData.mOutList = IODefines.valveDefines.getValves(IOConfigs.kIO_TYPE.mY);
        for(i = 0,len = MData.mOutList.length; i < len; ++i){
            valveTmp = MData.mOutList[i];
            MData.mDefinesList.push(IODefines.getYDefineFromHWPoint(valveTmp.y1Point, IODefines.M_BOARD_0).yDefine.pointName+":"+valveTmp.descr);
        }
        onProgramAdded();
        ManualProgramManager.manualProgramManager.registerMonitor(root);

        MData.ledKesSetData = JSON.parse(panelRobotController.getCustomSettings("LedAndKeySetting", "[]", "LedAndKeySetting"));
        len = MData.ledKesSetData.length;
        if(len === 10){
            for(i = 0; i < len; ++i){
                keyModel.append(MData.ledKesSetData[i]);
            }
        }
        else{
            console.log("new");
            for(i = 0; i < 10; ++i){
                keyModel.append({"functionCheck":1,"type":(i<5?0:1),"bindingType":0,"keyFuncType":0,"bindingNum":0,"thingID":0});
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
