import QtQuick 1.1
import ".."
import "../../ICCustomElement"
import "../Theme.js" as Theme
import "../configs/Keymap.js" as Keymap


Item {
    width: parent.width
    height: parent.height
    QtObject{
        id:pdata
        property int tabWidth: 80
        property int menuItemHeight: 32
        property int configNameWidth: 150
        property int inputWidth: 100
        property int currentGroup: 0
        property int checkSumPos: 15
        property variant configAddrs:
        [
            ["s_rw_0_32_3_100", "s_rw_0_16_0_101", "s_rw_16_16_0_101", "s_rw_0_16_0_102", "s_rw_16_16_0_102", "s_rw_0_8_0_104", "s_rw_8_8_0_104", "s_rw_16_8_0_104", "s_rw_24_4_0_104", "s_rw_0_16_0_105","s_rw_0_16_3_106","s_rw_16_16_3_106","s_rw_16_16_1_105", "s_rw_0_32_0_103", "s_rw_28_4_0_104","s_rw_0_32_0_156"],
            ["s_rw_0_32_3_107", "s_rw_0_16_0_108", "s_rw_16_16_0_108", "s_rw_0_16_0_109", "s_rw_16_16_0_109", "s_rw_0_8_0_111", "s_rw_8_8_0_111", "s_rw_16_8_0_111", "s_rw_24_4_0_111", "s_rw_0_16_0_112","s_rw_0_16_3_113","s_rw_16_16_3_113","s_rw_16_16_1_112", "s_rw_0_32_0_110", "s_rw_28_4_0_111","s_rw_0_32_0_156"],
            ["s_rw_0_32_3_114", "s_rw_0_16_0_115", "s_rw_16_16_0_115", "s_rw_0_16_0_116", "s_rw_16_16_0_116", "s_rw_0_8_0_118", "s_rw_8_8_0_118", "s_rw_16_8_0_118", "s_rw_24_4_0_118", "s_rw_0_16_0_119","s_rw_0_16_3_120","s_rw_16_16_3_120","s_rw_16_16_1_119", "s_rw_0_32_0_117", "s_rw_28_4_0_118","s_rw_0_32_0_156"],
            ["s_rw_0_32_3_121", "s_rw_0_16_0_122", "s_rw_16_16_0_122", "s_rw_0_16_0_123", "s_rw_16_16_0_123", "s_rw_0_8_0_125", "s_rw_8_8_0_125", "s_rw_16_8_0_125", "s_rw_24_4_0_125", "s_rw_0_16_0_126","s_rw_0_16_3_127","s_rw_16_16_3_127","s_rw_16_16_1_126", "s_rw_0_32_0_124", "s_rw_28_4_0_125","s_rw_0_32_0_156"],
            ["s_rw_0_32_3_128", "s_rw_0_16_0_129", "s_rw_16_16_0_129", "s_rw_0_16_0_130", "s_rw_16_16_0_130", "s_rw_0_8_0_132", "s_rw_8_8_0_132", "s_rw_16_8_0_132", "s_rw_24_4_0_132", "s_rw_0_16_0_133","s_rw_0_16_3_134","s_rw_16_16_3_134","s_rw_16_16_1_133", "s_rw_0_32_0_131", "s_rw_28_4_0_132","s_rw_0_32_0_156"],
            ["s_rw_0_32_3_135", "s_rw_0_16_0_136", "s_rw_16_16_0_136", "s_rw_0_16_0_137", "s_rw_16_16_0_137", "s_rw_0_8_0_139", "s_rw_8_8_0_139", "s_rw_16_8_0_139", "s_rw_24_4_0_139", "s_rw_0_16_0_140","s_rw_0_16_3_141","s_rw_16_16_3_141","s_rw_16_16_1_140", "s_rw_0_32_0_138", "s_rw_28_4_0_139","s_rw_0_32_0_156"],
            ["s_rw_0_32_3_142", "s_rw_0_16_0_143", "s_rw_16_16_0_143", "s_rw_0_16_0_144", "s_rw_16_16_0_144", "s_rw_0_8_0_146", "s_rw_8_8_0_146", "s_rw_16_8_0_146", "s_rw_24_4_0_146", "s_rw_0_16_0_147","s_rw_0_16_3_148","s_rw_16_16_3_148","s_rw_16_16_1_147", "s_rw_0_32_0_145", "s_rw_28_4_0_146","s_rw_0_32_0_156"],
            ["s_rw_0_32_3_149", "s_rw_0_16_0_150", "s_rw_16_16_0_150", "s_rw_0_16_0_151", "s_rw_16_16_0_151", "s_rw_0_8_0_153", "s_rw_8_8_0_153", "s_rw_16_8_0_153", "s_rw_24_4_0_153", "s_rw_0_16_0_154","s_rw_0_16_3_155","s_rw_16_16_3_155","s_rw_16_16_1_154", "s_rw_0_32_0_152", "s_rw_28_4_0_153","s_rw_0_32_0_156"],
        ]
    }

    function currentGroupAddr(which){
        return pdata.configAddrs[pdata.currentGroup][which];
    }

    function checkSumAddrs(){
        var ret = [];
        var addrs;
        for(var i = 0; i < pdata.configAddrs.length; ++i){
            addrs = pdata.configAddrs[i];
            for(var j = 0; j < addrs.length - 1; ++j){
                ret.push(addrs[j]);
            }
        }
        return JSON.stringify(ret);
    }

    function onLengthChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(0), length.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onPulseCountPerCircleChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(1), pulseCountPerCircle.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onReductionRatioChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(2), reductionRatio.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onPLimitChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(3), pLimit.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onNLimitChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(4), nLimit.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onPLimitPointChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(5), pLimitPoint.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onNLimitPointChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(6), nLimitPoint.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onOriginPointChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(7), originPoint.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onAcc1Changed(){
        panelRobotController.setConfigValue(currentGroupAddr(10), acc1.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onAcc2Changed(){
        panelRobotController.setConfigValue(currentGroupAddr(11), acc2.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onMaxSpeedChanged(){
        panelRobotController.setConfigValue(currentGroupAddr(12), maxSpeed.configValue);
        panelRobotController.syncConfigs();

        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function updateConfigValue(editor, addr, handler){
        editor.configValueChanged.disconnect(handler);
        editor.configAddr = addr
        editor.configValue = panelRobotController.getConfigValueText(addr);
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
        updateConfigValue(acc1, pdata.configAddrs[which][10], onAcc1Changed);
        updateConfigValue(acc2, pdata.configAddrs[which][11], onAcc2Changed);
        updateConfigValue(maxSpeed, pdata.configAddrs[which][12], onMaxSpeedChanged);
    }

    ICButtonGroup{
        id:menuContainer
        width: parent.width;
        height: pdata.menuItemHeight
        y:2
        z:1
        TabMenuItem{
            id:motor1
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: qsTr("Motor 1")
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(0)
            }
        }
        TabMenuItem{
            id:motor2
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: qsTr("Motor 2")
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(1)
            }
        }
        TabMenuItem{
            id:motor3
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: qsTr("Motor 3")
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(2)
            }
        }
        TabMenuItem{
            id:motor4
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: qsTr("Motor 4")
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(3)
            }
        }
        TabMenuItem{
            id:motor5
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: qsTr("Motor 5")
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(4)
            }
        }
        TabMenuItem{
            id:motor6
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: qsTr("Motor 6")
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(5)
            }
        }
        TabMenuItem{
            id:motor7
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: qsTr("Motor 7")
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(6)
            }
        }
        TabMenuItem{
            id:motor8
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            itemText: qsTr("Motor 8")
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(7)
            }
        }
    }
    Item{
        anchors.top: menuContainer.bottom
        anchors.topMargin: 4
        Grid{
            columns: 2
            flow: Grid.TopToBottom
            spacing: 30
            ICConfigEdit{
                id:length
                configName: qsTr("Arm Length")
                configNameWidth: pdata.configNameWidth
                inputWidth: pdata.inputWidth
                unit: qsTr("mm")
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
            Row{
                spacing: 20
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
    }

    Component.onCompleted: {
        motor1.setChecked(true);
        showMotorConfigs(pdata.currentGroup)
    }
}
