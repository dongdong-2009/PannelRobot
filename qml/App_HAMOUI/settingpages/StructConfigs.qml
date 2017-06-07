import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/ConfigDefines.js" as ConfigDefines
import "../configs/AxisDefine.js" as AxisDefine
import "../ICOperationLog.js" as ICOperationLog

Item {
    id:container
    width: parent.width
    height: parent.height
    QtObject{
        id:pdata
        property int configNameWidth: 45
    }
    ICSettingConfigsScope{
        onConfigValueChanged: {
            ICOperationLog.appendNumberConfigOperationLog(addr, newV, oldV)
            panelRobotController.setConfigValue("s_rw_0_32_0_185", panelRobotController.configsCheckSum(ConfigDefines.machineStructConfigsJSON));
            panelRobotController.syncConfigs();
        }
        Image {
            id: structGuideImg
            source: "../images/struct-guide.png"
            visible: false
        }
//        Column{
//            id:lengthContainer
//            spacing: 12
//            visible: !structGuideImg.visible
//            ICConfigEdit{
//                id:axis1Length
//                configNameWidth: pdata.configNameWidth + 50
//                configName: AxisDefine.axisInfos[0].name + " " + qsTr("Length");
//                unit: AxisDefine.axisInfos[0].unit
//                configAddr: "s_rw_0_32_3_100"
//            }
//            ICConfigEdit{
//                id:axis2Length
//                configNameWidth: axis1Length.configNameWidth
//                configName: AxisDefine.axisInfos[1].name + " " + qsTr("Length");
//                unit: AxisDefine.axisInfos[0].unit
//                configAddr: "s_rw_0_32_3_107"

//            }
//            ICConfigEdit{
//                id:axis3Length
//                configNameWidth: axis1Length.configNameWidth
//                configName: AxisDefine.axisInfos[2].name + " " + qsTr("Length");
//                unit: AxisDefine.axisInfos[0].unit
//                configAddr: "s_rw_0_32_3_114"
//            }
//            ICConfigEdit{
//                id:axis4Length
//                configNameWidth: axis1Length.configNameWidth
//                configName: AxisDefine.axisInfos[3].name + " " + qsTr("Length");
//                unit: AxisDefine.axisInfos[0].unit
//                configAddr: "s_rw_0_32_3_121"
//            }
//            ICConfigEdit{
//                id:axis5Length
//                configNameWidth: axis1Length.configNameWidth
//                configName: AxisDefine.axisInfos[4].name + " " + qsTr("Length");
//                unit: AxisDefine.axisInfos[0].unit
//                configAddr: "s_rw_0_32_3_128"
//            }
//            ICConfigEdit{
//                id:axis6Length
//                configNameWidth: axis1Length.configNameWidth
//                configName: AxisDefine.axisInfos[5].name + " " + qsTr("Length");
//                unit: AxisDefine.axisInfos[0].unit
//                configAddr: "s_rw_0_32_3_135"
//            }

//        }

        Grid{
//            columns: 2
            id:structContainer
            visible: false
            anchors.top: structGuideImg.bottom
            anchors.topMargin: 12
            rows:4
            spacing: 12
            flow: Grid.TopToBottom

            ICConfigEdit{
                id:struct1
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 1");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_156"
            }

            ICConfigEdit{
                id:struct2
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 2");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_157"
            }

            ICConfigEdit{
                id:struct3
                configNameWidth: pdata.configNameWidth
                configName: qsTr("L01");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_158"
            }

            ICConfigEdit{
                id:struct4
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 4");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_159"
            }

            ICConfigEdit{
                id:struct5
                configNameWidth: pdata.configNameWidth
                configName: qsTr("L23");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_160"
            }

            ICConfigEdit{
                id:struct6
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Machine Struct 6");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_161"
            }

            ICConfigEdit{
                id:struct7
                configNameWidth: pdata.configNameWidth
                configName: qsTr("L34a");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_162"
            }

            ICConfigEdit{
                id:struct8
                configNameWidth: pdata.configNameWidth
                configName: qsTr("L34b");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_163"
            }

            ICConfigEdit{
                id:struct9
                configNameWidth: pdata.configNameWidth
                configName: qsTr("L4");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_164"
            }
            ICConfigEdit{
                id:struct10
                configNameWidth: pdata.configNameWidth
                configName: qsTr("L12");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_174"
            }
            ICConfigEdit{
                id:struct11
                configNameWidth: pdata.configNameWidth
                configName: qsTr("L24");
                unit: qsTr("mm")
                configAddr: "s_rw_0_32_3_175"
            }

            ICConfigEdit{
                id:axis1Diff
                configNameWidth: pdata.configNameWidth
                configName: qsTr("Axis1 Diff");
                unit: qsTr("°")
                configAddr: "s_rw_0_32_3_168"
            }
            ICConfigEdit{
                id:axis2Diff
                configNameWidth: axis1Diff.configNameWidth
                configName: qsTr("Axis2 Diff");
                unit: qsTr("°")
                configAddr: "s_rw_0_32_3_169"
            }
            ICConfigEdit{
                id:axis3Diff
                configNameWidth: axis1Diff.configNameWidth
                configName: qsTr("Axis3 Diff");
                unit: qsTr("°")
                configAddr: "s_rw_0_32_3_170"
            }
            ICConfigEdit{
                id:axis4Diff
                configNameWidth: axis1Diff.configNameWidth
                configName: qsTr("Axis4 Diff");
                unit: qsTr("°")
                configAddr: "s_rw_0_32_3_171"
            }
            ICConfigEdit{
                id:axis5Diff
                configNameWidth: axis1Diff.configNameWidth
                configName: qsTr("Axis5 Diff");
                unit: qsTr("°")
                configAddr: "s_rw_0_32_3_172"
            }
            ICConfigEdit{
                id:axis6Diff
                configNameWidth: axis1Diff.configNameWidth
                configName: qsTr("Axis6 Diff");
                unit: qsTr("°")
                configAddr: "s_rw_0_32_3_173"
            }
        }
        Grid{
            rows:4
            spacing: 12
            flow: Grid.TopToBottom
            anchors.left:structGuideImg.visible ? structGuideImg.right : structGuideImg.left
            anchors.leftMargin: 12
            ICConfigEdit{
                id:sAcc1
                configNameWidth: pdata.configNameWidth + 35
                configName: qsTr("SACC 1");
                unit: qsTr("%")
                configAddr: "s_rw_0_8_0_165"
            }

            ICConfigEdit{
                id:sAcc2
                configNameWidth: sAcc1.configNameWidth
                configName: qsTr("SACC 2");
                unit: qsTr("%")
                configAddr: "s_rw_8_8_0_165"
            }

            ICConfigEdit{
                id:sAcc3
                configNameWidth: sAcc1.configNameWidth
                configName: qsTr("SDEC 1");
                unit: qsTr("%")
                configAddr: "s_rw_16_8_0_165"
            }

            ICConfigEdit{
                id:sAcc4
                configNameWidth: sAcc1.configNameWidth
                configName: qsTr("SDEC 2");
                unit: qsTr("%")
                configAddr: "s_rw_24_8_0_165"
            }
            ICConfigEdit{
                id:sAccTime
                configNameWidth: sAcc1.configNameWidth
                configName: qsTr("SACC Time");
                unit: qsTr("m/s²")
                configAddr: "s_rw_0_16_3_166"
            }
            ICConfigEdit{
                id:sDecTime
                configNameWidth: sAcc1.configNameWidth
                configName: qsTr("SDec Time");
                unit: qsTr("m/s²")
                configAddr: "s_rw_16_16_3_166"
            }
            ICConfigEdit{
                id:pathMaxSpeed
                configNameWidth: sAcc1.configNameWidth
                configName: qsTr("SACC Max");
                unit: qsTr("m/s")
                configAddr: "s_rw_0_16_3_167"
            }
            ICCheckBoxEdit{
                id:isAnalogEn
                configAddr: "s_rw_0_32_0_213"
                configName: qsTr("Analog En")
            }
            ICConfigEdit{
                id:ioBoardNum
                configNameWidth: sAcc1.configNameWidth
                configName: qsTr("IO Board Num")
                configAddr: "s_rw_22_2_0_184"
            }

        }
    }
    ICComboBoxConfigEdit{
        id:l6Type
        visible: false
        configName: qsTr("IO Type")
        items: [qsTr("L6-IO-1"), qsTr("L6-IO-2"),qsTr("L6-IO-3"),qsTr("L6-IO-4")]
        anchors.right: parent.right
        anchors.rightMargin: 20
    }

    function onIOTypeChanged(){
        if(panelRobotController.getCustomSettings("Language", "CN") == "US") return;
        var qm ="HAMOUI_zh_CN.qm";
        switch(l6Type.configValue)
        {
        case 1:qm="L6-2_zh_CN.qm";break;
        case 2:qm="L6-3_zh_CN.qm";break;
        case 3:qm="L6-4_zh_CN.qm";break;
        default:qm ="HAMOUI_zh_CN.qm";break;
        }

        panelRobotController.setCustomSettings("L6CNQM", qm);
        panelRobotController.setCurrentTranslator(qm);
    }

//    function onAxisDefinesChanged(){
//        axis1Length.visible = AxisDefine.axisInfos[0].visiable;
//        axis2Length.visible = AxisDefine.axisInfos[1].visiable;
//        axis3Length.visible = AxisDefine.axisInfos[2].visiable;
//        axis4Length.visible = AxisDefine.axisInfos[3].visiable;
//        axis5Length.visible = AxisDefine.axisInfos[4].visiable;
//        axis6Length.visible = AxisDefine.axisInfos[5].visiable;
//    }
    Component.onCompleted: {
//        AxisDefine.registerMonitors(container);
//        onAxisDefinesChanged();
        var qm = panelRobotController.getCustomSettings("L6CNQM", "HAMOUI_zh_CN.qm");
        if(qm=="HAMOUI_zh_CN.qm")l6Type.configValue=0;
        else if(qm=="L6-2_zh_CN.qm")l6Type.configValue=1;
        else if(qm=="L6-3_zh_CN.qm")l6Type.configValue=2;
        else if(qm=="L6-4_zh_CN.qm")l6Type.configValue=3;
        l6Type.configValueChanged.connect(onIOTypeChanged);
    }
}
