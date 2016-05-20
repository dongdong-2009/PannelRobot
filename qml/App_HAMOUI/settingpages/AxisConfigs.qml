import QtQuick 1.1
import ".."
import "../../ICCustomElement"
import "../Theme.js" as Theme
import "../configs/Keymap.js" as Keymap
import "../configs/AxisDefine.js" as AxisDefine
import "../configs/ConfigDefines.js" as ConfigDefines
import "../ICOperationLog.js" as ICOperationLog


Item {
    id: container
    width: parent.width
    height: parent.height
    QtObject{
        id:pdata
        property int tabWidth: 80
        property int menuItemHeight: 32
        property int configNameWidth: 150
        property int inputWidth: 100
        property int currentGroup: 0
        property int checkSumPos: 18
        property variant configAddrs:
            [
            ["s_rw_0_32_3_100", "s_rw_0_16_0_101", "s_rw_16_16_2_101", "s_rw_0_16_0_102", "s_rw_16_16_0_102", "s_rw_0_8_0_104", "s_rw_8_8_0_104", "s_rw_16_8_0_104", "s_rw_24_4_0_104", "s_rw_0_16_0_105","s_rw_0_16_3_106","s_rw_16_16_3_106","s_rw_16_16_1_105", "s_rw_0_32_0_103", "s_rw_28_4_0_104","s_rw_0_4_0_103","s_rw_4_4_0_103","s_rw_8_4_0_103","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_107", "s_rw_0_16_0_108", "s_rw_16_16_2_108", "s_rw_0_16_0_109", "s_rw_16_16_0_109", "s_rw_0_8_0_111", "s_rw_8_8_0_111", "s_rw_16_8_0_111", "s_rw_24_4_0_111", "s_rw_0_16_0_112","s_rw_0_16_3_113","s_rw_16_16_3_113","s_rw_16_16_1_112", "s_rw_0_32_0_110", "s_rw_28_4_0_111","s_rw_0_4_0_110","s_rw_4_4_0_110","s_rw_8_4_0_110","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_114", "s_rw_0_16_0_115", "s_rw_16_16_2_115", "s_rw_0_16_0_116", "s_rw_16_16_0_116", "s_rw_0_8_0_118", "s_rw_8_8_0_118", "s_rw_16_8_0_118", "s_rw_24_4_0_118", "s_rw_0_16_0_119","s_rw_0_16_3_120","s_rw_16_16_3_120","s_rw_16_16_1_119", "s_rw_0_32_0_117", "s_rw_28_4_0_118","s_rw_0_4_0_117","s_rw_4_4_0_117","s_rw_8_4_0_117","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_121", "s_rw_0_16_0_122", "s_rw_16_16_2_122", "s_rw_0_16_0_123", "s_rw_16_16_0_123", "s_rw_0_8_0_125", "s_rw_8_8_0_125", "s_rw_16_8_0_125", "s_rw_24_4_0_125", "s_rw_0_16_0_126","s_rw_0_16_3_127","s_rw_16_16_3_127","s_rw_16_16_1_126", "s_rw_0_32_0_124", "s_rw_28_4_0_125","s_rw_0_4_0_124","s_rw_4_4_0_124","s_rw_8_4_0_124","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_128", "s_rw_0_16_0_129", "s_rw_16_16_2_129", "s_rw_0_16_0_130", "s_rw_16_16_0_130", "s_rw_0_8_0_132", "s_rw_8_8_0_132", "s_rw_16_8_0_132", "s_rw_24_4_0_132", "s_rw_0_16_0_133","s_rw_0_16_3_134","s_rw_16_16_3_134","s_rw_16_16_1_133", "s_rw_0_32_0_131", "s_rw_28_4_0_132","s_rw_0_4_0_131","s_rw_4_4_0_131","s_rw_8_4_0_131","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_135", "s_rw_0_16_0_136", "s_rw_16_16_2_136", "s_rw_0_16_0_137", "s_rw_16_16_0_137", "s_rw_0_8_0_139", "s_rw_8_8_0_139", "s_rw_16_8_0_139", "s_rw_24_4_0_139", "s_rw_0_16_0_140","s_rw_0_16_3_141","s_rw_16_16_3_141","s_rw_16_16_1_140", "s_rw_0_32_0_138", "s_rw_28_4_0_139","s_rw_0_4_0_138","s_rw_4_4_0_138","s_rw_8_4_0_138","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_142", "s_rw_0_16_0_143", "s_rw_16_16_2_143", "s_rw_0_16_0_144", "s_rw_16_16_0_144", "s_rw_0_8_0_146", "s_rw_8_8_0_146", "s_rw_16_8_0_146", "s_rw_24_4_0_146", "s_rw_0_16_0_147","s_rw_0_16_3_148","s_rw_16_16_3_148","s_rw_16_16_1_147", "s_rw_0_32_0_145", "s_rw_28_4_0_146","s_rw_0_4_0_145","s_rw_4_4_0_145","s_rw_8_4_0_145","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_149", "s_rw_0_16_0_150", "s_rw_16_16_2_150", "s_rw_0_16_0_151", "s_rw_16_16_0_151", "s_rw_0_8_0_153", "s_rw_8_8_0_153", "s_rw_16_8_0_153", "s_rw_24_4_0_153", "s_rw_0_16_0_154","s_rw_0_16_3_155","s_rw_16_16_3_155","s_rw_16_16_1_154", "s_rw_0_32_0_152", "s_rw_28_4_0_153","s_rw_0_4_0_152","s_rw_4_4_0_152","s_rw_8_4_0_152","s_rw_0_32_0_185"],
        ]

        property variant sentPulseAddrs: ["c_ro_0_32_3_900","c_ro_0_32_3_904",
            "c_ro_0_32_3_908", "c_ro_0_32_3_912","c_ro_0_32_3_916", "c_ro_0_32_3_920",
        ]

        property variant receivedPulseAddrs: ["c_ro_0_32_0_901", "c_ro_0_32_0_905",
            "c_ro_0_32_0_909","c_ro_0_32_0_913","c_ro_0_32_0_917","c_ro_0_32_0_921"]

        property variant zPulseAddrs: ["c_ro_0_16_0_902", "c_ro_0_16_0_906",
            "c_ro_0_16_0_910", "c_ro_0_16_0_914", "c_ro_0_16_0_918", "c_ro_0_16_0_922"]
    }

    function currentGroupAddr(which){
        return pdata.configAddrs[pdata.currentGroup][which];
    }

    function checkSumAddrs(){
        return ConfigDefines.machineStructConfigsJSON;
        //        var ret = [];
        //        var addrs;
        //        for(var i = 0; i < pdata.configAddrs.length; ++i){
        //            addrs = pdata.configAddrs[i];
        //            for(var j = 0; j < addrs.length - 1; ++j){
        //                ret.push(addrs[j]);
        //            }
        //        }
        //        return JSON.stringify(ret);
    }



    function onLengthChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(0), length.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onPulseCountPerCircleChanged(){
        var addr = currentGroupAddr(1);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, pulseCountPerCircle.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr,pulseCountPerCircle.configValue, oldV);

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onReductionRatioChanged(){
        var addr = currentGroupAddr(2);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, reductionRatio.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr,reductionRatio.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onPLimitChanged(){
        var addr = currentGroupAddr(3);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, pLimit.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, pLimit.configValue, oldV);

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onNLimitChanged(){
        var addr = currentGroupAddr(4);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, nLimit.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, nLimit.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onPLimitPointChanged(){
        var addr = currentGroupAddr(5);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, pLimitPoint.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, pLimitPoint.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onNLimitPointChanged(){
        var addr = currentGroupAddr(6);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, nLimitPoint.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, nLimitPoint.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onOriginPointChanged(){
        var addr = currentGroupAddr(7);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, originPoint.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, originPoint.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onAcc1Changed(){
        var addr = currentGroupAddr(10);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, acc1.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, acc1.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onAcc2Changed(){
        var addr = currentGroupAddr(11);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, acc2.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, acc2.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onMaxSpeedChanged(){
        var addr = currentGroupAddr(12);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, maxSpeed.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, maxSpeed.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onEncoderTypeChanged(){
        var addr = currentGroupAddr(15);
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, encoderType.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, encoderType.text(encoderType.configValue), encoderType.text(oldV));

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onMotorFactoryChanged(){
        var addr = currentGroupAddr(16);
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, motorFactory.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, motorFactory.text(motorFactory.configValue), motorFactory.text(oldV));


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onEncoderReadWayChanged(){
        var addr = currentGroupAddr(17);
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, encoderReadWay.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, encoderReadWay.text(encoderReadWay.configValue), encoderReadWay.text(oldV));


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onAxisTypeChanged(){
        var addr = currentGroupAddr(8);
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, axisType.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, axisType.text(axisType.configValue), axisType.text(oldV));


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function updateConfigValue(editor, addr, handler){
        editor.configValueChanged.disconnect(handler);
        editor.configAddr = addr
        editor.configValue = panelRobotController.getConfigValueText(addr);
        editor.configValueChanged.connect(handler);
    }

    function updateComboBoxValue(editor, addr, handler){
        editor.configValueChanged.disconnect(handler);
        editor.configAddr = addr
        editor.configValue = panelRobotController.getConfigValue(addr);
        editor.configValueChanged.connect(handler);
    }

    function showMotorConfigs(which){
        pdata.currentGroup = which;
        updateConfigValue(length, pdata.configAddrs[which][0], onLengthChanged);
        updateConfigValue(pulseCountPerCircle, pdata.configAddrs[which][1], onPulseCountPerCircleChanged);
        updateConfigValue(reductionRatio, pdata.configAddrs[which][2], onReductionRatioChanged);
        updateConfigValue(pLimit, pdata.configAddrs[which][3], onPLimitChanged);
        updateConfigValue(nLimit, pdata.configAddrs[which][4], onNLimitChanged);
        updateConfigValue(pLimitPoint, pdata.configAddrs[which][5], onPLimitPointChanged);
        updateConfigValue(nLimitPoint, pdata.configAddrs[which][6], onNLimitPointChanged);
        updateConfigValue(originPoint, pdata.configAddrs[which][7], onOriginPointChanged);
        updateComboBoxValue(axisType, pdata.configAddrs[which][8], onAxisTypeChanged);
        updateConfigValue(acc1, pdata.configAddrs[which][10], onAcc1Changed);
        updateConfigValue(acc2, pdata.configAddrs[which][11], onAcc2Changed);
        updateConfigValue(maxSpeed, pdata.configAddrs[which][12], onMaxSpeedChanged);
        updateComboBoxValue(encoderType, pdata.configAddrs[which][15], onEncoderTypeChanged);
        updateComboBoxValue(motorFactory, pdata.configAddrs[which][16], onMotorFactoryChanged);
        updateComboBoxValue(encoderReadWay, pdata.configAddrs[which][17], onEncoderReadWayChanged);

    }

    ICButtonGroup{
        id:menuContainer
        width: parent.width;
        height: pdata.menuItemHeight
        isAutoSize: false
        y:2
        z:1
        TabMenuItem{
            id:motor1
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: AxisDefine.axisInfos[0].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(0)
            }
        }
        TabMenuItem{
            id:motor2
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: AxisDefine.axisInfos[1].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(1)
            }
        }
        TabMenuItem{
            id:motor3
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: AxisDefine.axisInfos[2].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(2)
            }
        }
        TabMenuItem{
            id:motor4
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: AxisDefine.axisInfos[3].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(3)
            }
        }
        TabMenuItem{
            id:motor5
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: AxisDefine.axisInfos[4].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(4)
            }
        }
        TabMenuItem{
            id:motor6
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: AxisDefine.axisInfos[5].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(5)
            }
        }
        TabMenuItem{
            id:motor7
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: AxisDefine.axisInfos[6].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(6)
            }
        }
        TabMenuItem{
            id:motor8
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: AxisDefine.axisInfos[7].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(7)
            }
        }
    }
    Item{
        anchors.top: menuContainer.bottom
        anchors.topMargin: 4
        ICFlickable{
            id:configContainer
            width: 300
            height: 300
            clip: true
            isshowhint: true
            contentHeight: configContentContainer.height + 10
            Grid{
                id:configContentContainer
                columns: 1
                spacing: 6
                ICComboBoxConfigEdit{
                    id:motorFactory
                    configName: qsTr("Motor Factory")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items: [qsTr("Motor 1"), qsTr("Motor 2"), qsTr("Motor 3")]
                    z:5
                }
                ICComboBoxConfigEdit{
                    id:encoderType
                    configName: qsTr("Encoder Type")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items: [qsTr("Encode Type1"), qsTr("Encode Type2"), qsTr("Encode Type3")]
                    z:4
                }
                ICComboBoxConfigEdit{
                    id:encoderReadWay
                    configName: qsTr("Encoder Read Way")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items: [qsTr("Encode RW1"), qsTr("Encode RW2"), qsTr("Encode RW3")]
                    z:3
                }

                ICComboBoxConfigEdit{
                    id:axisType
                    configName: qsTr("Axis Type")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items:[qsTr("Rotate"), qsTr("Line")]
                    z:2
                }

                ICConfigEdit{
                    id:length
                    configName: qsTr("Arm Length")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    unit: qsTr("mm")
                    visible: false
                }
                ICConfigEdit{
                    id:pulseCountPerCircle
                    configName: qsTr("Pulse Count Per Circle")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    unit: qsTr("a")
                }
                ICConfigEdit{
                    id:reductionRatio
                    configName: qsTr("Reduction Ratio")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                }
                ICConfigEdit{
                    id:pLimit
                    configName: qsTr("Positive Limit")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    unit: qsTr("mm")
                }
                ICConfigEdit{
                    id:nLimit
                    configName: qsTr("Negative Limit")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    unit: qsTr("mm")
                }
                ICConfigEdit{
                    id:pLimitPoint
                    configName: qsTr("Positive Limit Point")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth

                }
                ICConfigEdit{
                    id:nLimitPoint
                    configName: qsTr("Negative Limit Point")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth

                }
                ICConfigEdit{
                    id:originPoint
                    configName: qsTr("Origin Point")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth

                }
                ICConfigEdit{
                    id:acc1
                    configName: qsTr("ACC 1")
                    configNameWidth: pdata.configNameWidth
                    unit: qsTr("s")
                    inputWidth: pdata.inputWidth

                }
                ICConfigEdit{
                    id:acc2
                    configName: qsTr("ACC 2")
                    configNameWidth: pdata.configNameWidth
                    unit: qsTr("s")
                    inputWidth: pdata.inputWidth

                }
                ICConfigEdit{
                    id:maxSpeed
                    configName: qsTr("Max RPM")
                    configNameWidth: pdata.configNameWidth
                    unit: qsTr("RPM")
                    inputWidth: pdata.inputWidth

                }

            }

        }
        Rectangle{
            id:splitLine
            anchors.left: configContainer.right
            anchors.leftMargin: 40
            width: 1
            height: configContainer.height + menuContainer.height
            border{
                width: 1
                color: "gray"
            }
        }

        Column{
            id:motorTestContainer
            anchors.left: splitLine.right
            anchors.leftMargin: 20
            spacing: 6
            Text {
                text: qsTr("Motor Test")
                font.pixelSize: 24
            }
            Grid{
                columns: 2
                Text {
                    text: qsTr("Test Pulse Number:")
                }
                ICLineEdit{
                    id:testPulseNum
                    unit: qsTr("a")
                    text: "10000"
                    onTextChanged: {
                        panelRobotController.setMotorTestPulseNum(text);
                    }
                }

                Text {
                    text: qsTr("Pulse Sent:")
                }
                ICStatusWidget{
                    id:pulseSent
                }
                Text {
                    text: qsTr("Pulse received:")
                }
                ICStatusWidget{
                    id:pulseReceived
                }
                Text {
                    text: qsTr("Z Pulse:")
                }
                ICStatusWidget{
                    id:zPulse
                }

                Timer{
                    id:refreshTimer
                    running: visible
                    interval: 50
                    repeat: true
                    onTriggered: {
                        pulseSent.text = panelRobotController.statusValue(pdata.sentPulseAddrs[pdata.currentGroup]);
                        pulseReceived.text = panelRobotController.statusValue(pdata.receivedPulseAddrs[pdata.currentGroup]);
                        zPulse.text = panelRobotController.statusValue(pdata.zPulseAddrs[pdata.currentGroup]);
                    }
                }
                onVisibleChanged: {
                    panelRobotController.setMotorTestPulseNum(testPulseNum.text);
                    panelRobotController.swichPulseAngleDisplay(visible ? 5:0);
                    testClear.clicked();
                }
            }

            Row{
                spacing: 20
                ICButton{
                    id:testPlus
                    text: qsTr("Motor+")
                    width: 120
                    onButtonClicked: {
                        panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEST_JOG_PX + pdata.currentGroup);
                    }
                }
                ICButton{
                    id:testMinus
                    text: qsTr("Motor-")
                    width: 120
                    onButtonClicked: {
                        panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEST_JOG_NX + pdata.currentGroup);
                    }
                }
                ICButton{
                    id:testClear
                    text: qsTr("Test Clear")
                    width: 120
                    onButtonClicked: {
                        panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEST_CLEAR);
                    }
                }
            }
        }
        Rectangle{
            id:horSplitLine
            height: 1
            width: originContainer.width
            anchors.top: motorTestContainer.bottom
            anchors.topMargin: 20
            x:originContainer.x
            border{
                width: 1
                color: "gray"
            }
        }

        Row{
            id:originContainer
            spacing: 20
            anchors.bottom : splitLine.bottom
            anchors.left:  splitLine.right
            anchors.leftMargin: 20
            ICButton{
                id:setAsOrigin
                text: qsTr("Set to Origin")
                width: 120
                onButtonClicked: {
                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_SET_ZERO0 + pdata.currentGroup);
                }
            }
            ICButton{
                id:saveOrigin
                text: qsTr("Save Origin")
                width: 120
                onButtonClicked: {
                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_REM_POS);
                }
            }
            ICButton{
                id:setOrigined
                text: qsTr("Set All Origin")
                width: 120
                onButtonClicked: {
                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_SET_ZERO);
                }
            }
        }

    }

    Component.onCompleted: {
        motor1.setChecked(true);
        showMotorConfigs(pdata.currentGroup);
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }
    function onAxisDefinesChanged(){
        motor1.visible = AxisDefine.axisInfos[0].visiable;
        motor2.visible = AxisDefine.axisInfos[1].visiable;
        motor3.visible = AxisDefine.axisInfos[2].visiable;
        motor4.visible = AxisDefine.axisInfos[3].visiable;
        motor5.visible = AxisDefine.axisInfos[4].visiable;
        motor6.visible = AxisDefine.axisInfos[5].visiable;
    }
}
