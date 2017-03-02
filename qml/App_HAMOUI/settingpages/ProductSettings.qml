import QtQuick 1.1
import "../../ICCustomElement"
import '..'
import "../configs/IODefines.js" as IODefines

Item {
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
//            anchors.top: valveContainer.bottom
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
//            anchors.topMargin: 6
            width: parent.width
            height: parent.height
            model:valveModel
            spacing: 10
            delegate: Row{
                spacing: 8
                z: 1000-index;

                ICCheckBox {
                    text: index+":"+qsTr("When the mode change to")
//                    width: 150
                    anchors.verticalCenter: parent.verticalCenter
                    isChecked: check
                    onIsCheckedChanged: {
                        valveModel.setProperty(index,"check",isChecked);
                    }
                }
                ICComboBoxConfigEdit{
                    popupHeight:100
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
                    popupMode: 0
                    popupHeight: 100
//                    width: 50
//                    z:10
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
//                    width: 150
                    anchors.verticalCenter: parent.verticalCenter
                }
                ICComboBox{
                    id: outid
                    width: 180
                    popupHeight:100
                    currentIndex: outid_init
                    onCurrentIndexChanged: {
                        valveModel.setProperty(index,"outid_init",currentIndex);
                    }
                }
                ICComboBox{
                    id: outstatus
                    items: [qsTr("OFF"), qsTr("ON")]
                    width: 40
                    popupHeight:100
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

    onVisibleChanged: {
        if(visible)
            showMenu();
    }

    Component.onCompleted: {
        var ps = [];
        ps.push(productPage);
        ps.push(valveSettings)
        ps.push(customVariableConfigs)
        ps.push(ioRunningSettingPage)
        pages = ps;
        var iosettings = JSON.parse(panelRobotController.getCustomSettings("IOSettings", "[]", "IOSettings"));
        for(var i = 0, len = iosettings.length; i < len; ++i){
            valveModel.append(iosettings[i]);
        }
    }

}
