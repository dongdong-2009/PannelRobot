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
        property int tabWidth: 98
        property int menuItemHeight: 32
        property int configNameWidth: 150
        property int inputWidth: 100
        property int currentGroup: 0
        property int checkSumPos: 28
        property bool isInit: false
        property variant configAddrs:
            [
            ["s_rw_0_32_3_100", "s_rw_0_16_0_101", "s_rw_16_16_2_101", "s_rw_0_16_0_102", "s_rw_16_16_0_102", "s_rw_0_8_0_104", "s_rw_8_8_0_104", "s_rw_16_8_0_104", "s_rw_24_4_0_104", "s_rw_0_16_0_105","s_rw_0_16_3_106","s_rw_16_16_3_106","s_rw_16_16_1_105", "s_rw_0_32_0_103", "s_rw_28_4_0_104","s_rw_0_4_0_103","s_rw_4_4_0_103","s_rw_8_4_0_103","s_rw_28_1_0_104","s_rw_29_1_0_104","s_rw_30_1_0_104","s_rw_31_1_0_104","s_rw_12_6_0_103","s_rw_18_1_0_103","s_rw_19_6_0_103","s_rw_25_6_0_103","s_rw_0_6_0_105","s_rw_6_6_0_105","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_107", "s_rw_0_16_0_108", "s_rw_16_16_2_108", "s_rw_0_16_0_109", "s_rw_16_16_0_109", "s_rw_0_8_0_111", "s_rw_8_8_0_111", "s_rw_16_8_0_111", "s_rw_24_4_0_111", "s_rw_0_16_0_112","s_rw_0_16_3_113","s_rw_16_16_3_113","s_rw_16_16_1_112", "s_rw_0_32_0_110", "s_rw_28_4_0_111","s_rw_0_4_0_110","s_rw_4_4_0_110","s_rw_8_4_0_110","s_rw_28_1_0_111","s_rw_29_1_0_111","s_rw_30_1_0_111","s_rw_31_1_0_111","s_rw_12_6_0_110","s_rw_18_1_0_110","s_rw_19_6_0_110","s_rw_25_6_0_110","s_rw_0_6_0_112","s_rw_6_6_0_112","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_114", "s_rw_0_16_0_115", "s_rw_16_16_2_115", "s_rw_0_16_0_116", "s_rw_16_16_0_116", "s_rw_0_8_0_118", "s_rw_8_8_0_118", "s_rw_16_8_0_118", "s_rw_24_4_0_118", "s_rw_0_16_0_119","s_rw_0_16_3_120","s_rw_16_16_3_120","s_rw_16_16_1_119", "s_rw_0_32_0_117", "s_rw_28_4_0_118","s_rw_0_4_0_117","s_rw_4_4_0_117","s_rw_8_4_0_117","s_rw_28_1_0_118","s_rw_29_1_0_118","s_rw_30_1_0_118","s_rw_31_1_0_118","s_rw_12_6_0_117","s_rw_18_1_0_117","s_rw_19_6_0_117","s_rw_25_6_0_117","s_rw_0_6_0_119","s_rw_6_6_0_119","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_121", "s_rw_0_16_0_122", "s_rw_16_16_2_122", "s_rw_0_16_0_123", "s_rw_16_16_0_123", "s_rw_0_8_0_125", "s_rw_8_8_0_125", "s_rw_16_8_0_125", "s_rw_24_4_0_125", "s_rw_0_16_0_126","s_rw_0_16_3_127","s_rw_16_16_3_127","s_rw_16_16_1_126", "s_rw_0_32_0_124", "s_rw_28_4_0_125","s_rw_0_4_0_124","s_rw_4_4_0_124","s_rw_8_4_0_124","s_rw_28_1_0_125","s_rw_29_1_0_125","s_rw_30_1_0_125","s_rw_31_1_0_125","s_rw_12_6_0_124","s_rw_18_1_0_124","s_rw_19_6_0_124","s_rw_25_6_0_124","s_rw_0_6_0_126","s_rw_6_6_0_126","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_128", "s_rw_0_16_0_129", "s_rw_16_16_2_129", "s_rw_0_16_0_130", "s_rw_16_16_0_130", "s_rw_0_8_0_132", "s_rw_8_8_0_132", "s_rw_16_8_0_132", "s_rw_24_4_0_132", "s_rw_0_16_0_133","s_rw_0_16_3_134","s_rw_16_16_3_134","s_rw_16_16_1_133", "s_rw_0_32_0_131", "s_rw_28_4_0_132","s_rw_0_4_0_131","s_rw_4_4_0_131","s_rw_8_4_0_131","s_rw_28_1_0_132","s_rw_29_1_0_132","s_rw_30_1_0_132","s_rw_31_1_0_132","s_rw_12_6_0_131","s_rw_18_1_0_131","s_rw_19_6_0_131","s_rw_25_6_0_131","s_rw_0_6_0_133","s_rw_6_6_0_133","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_135", "s_rw_0_16_0_136", "s_rw_16_16_2_136", "s_rw_0_16_0_137", "s_rw_16_16_0_137", "s_rw_0_8_0_139", "s_rw_8_8_0_139", "s_rw_16_8_0_139", "s_rw_24_4_0_139", "s_rw_0_16_0_140","s_rw_0_16_3_141","s_rw_16_16_3_141","s_rw_16_16_1_140", "s_rw_0_32_0_138", "s_rw_28_4_0_139","s_rw_0_4_0_138","s_rw_4_4_0_138","s_rw_8_4_0_138","s_rw_28_1_0_139","s_rw_29_1_0_139","s_rw_30_1_0_139","s_rw_31_1_0_139","s_rw_12_6_0_138","s_rw_18_1_0_138","s_rw_19_6_0_138","s_rw_25_6_0_138","s_rw_0_6_0_140","s_rw_6_6_0_140","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_142", "s_rw_0_16_0_143", "s_rw_16_16_2_143", "s_rw_0_16_0_144", "s_rw_16_16_0_144", "s_rw_0_8_0_146", "s_rw_8_8_0_146", "s_rw_16_8_0_146", "s_rw_24_4_0_146", "s_rw_0_16_0_147","s_rw_0_16_3_148","s_rw_16_16_3_148","s_rw_16_16_1_147", "s_rw_0_32_0_145", "s_rw_28_4_0_146","s_rw_0_4_0_145","s_rw_4_4_0_145","s_rw_8_4_0_145","s_rw_28_1_0_146","s_rw_29_1_0_146","s_rw_30_1_0_146","s_rw_31_1_0_146","s_rw_12_6_0_145","s_rw_18_1_0_145","s_rw_19_6_0_145","s_rw_25_6_0_145","s_rw_0_6_0_147","s_rw_6_6_0_147","s_rw_0_32_0_185"],
            ["s_rw_0_32_3_149", "s_rw_0_16_0_150", "s_rw_16_16_2_150", "s_rw_0_16_0_151", "s_rw_16_16_0_151", "s_rw_0_8_0_153", "s_rw_8_8_0_153", "s_rw_16_8_0_153", "s_rw_24_4_0_153", "s_rw_0_16_0_154","s_rw_0_16_3_155","s_rw_16_16_3_155","s_rw_16_16_1_154", "s_rw_0_32_0_152", "s_rw_28_4_0_153","s_rw_0_4_0_152","s_rw_4_4_0_152","s_rw_8_4_0_152","s_rw_28_1_0_153","s_rw_29_1_0_153","s_rw_30_1_0_153","s_rw_31_1_0_153","s_rw_12_6_0_152","s_rw_18_1_0_152","s_rw_19_6_0_152","s_rw_25_6_0_152","s_rw_0_6_0_154","s_rw_6_6_0_154","s_rw_0_32_0_185"],
        ]

        property variant sentPulseAddrs: ["c_ro_0_32_3_900","c_ro_0_32_3_904",
            "c_ro_0_32_3_908", "c_ro_0_32_3_912","c_ro_0_32_3_916", "c_ro_0_32_3_920", "c_ro_0_32_3_924", "c_ro_0_32_3_928"
        ]

        property variant receivedPulseAddrs: ["c_ro_0_32_0_901", "c_ro_0_32_0_905",
            "c_ro_0_32_0_909","c_ro_0_32_0_913","c_ro_0_32_0_917","c_ro_0_32_0_921", "c_ro_0_32_0_925", "c_ro_0_32_0_929"]

        property variant zPulseAddrs: ["c_ro_0_16_0_902", "c_ro_0_16_0_906",
            "c_ro_0_16_0_910", "c_ro_0_16_0_914", "c_ro_0_16_0_918", "c_ro_0_16_0_922", "c_ro_0_16_0_926", "c_ro_0_16_0_930"]
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
        AxisDefine.changeAxisUnit(pdata.currentGroup, axisType.configValue);
    }

    function onPLimitDirChanged(){
        var addr = currentGroupAddr(18);
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, pLimitPointDir.isChecked ? 1 : 0);
        panelRobotController.syncConfigs();
        ICOperationLog.appendOperationLog(AxisDefine.axisInfos[pdata.currentGroup].name + qsTr("pLimit Dir Change to") + (pLimitPointDir.isChecked ? qsTr("A ON") : qsTr("A OFF")));


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onNLimitDirChanged(){
        var addr = currentGroupAddr(19);
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, nLimitPointDir.isChecked ? 1 : 0);
        panelRobotController.syncConfigs();
        ICOperationLog.appendOperationLog(AxisDefine.axisInfos[pdata.currentGroup].name + qsTr("nLimit Dir Change to") + (nLimitPointDir.isChecked ? qsTr("A ON") : qsTr("A OFF")));


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onOriginMoveDirChanged(){
        var addr = currentGroupAddr(20);
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, originRunDirInvert.isChecked ? 1 : 0);
        panelRobotController.syncConfigs();
        ICOperationLog.appendOperationLog(AxisDefine.axisInfos[pdata.currentGroup].name + qsTr("Origin move dir Change to") + (originRunDirInvert.isChecked ? qsTr("N Dir") : qsTr("P Dir")));


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onMotorEnChanged(group, isChecked){
        if(!pdata.isInit) return;
        var addr = pdata.configAddrs[group][21];
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, isChecked ? 1 : 0);
        panelRobotController.syncConfigs();
        ICOperationLog.appendOperationLog(AxisDefine.axisInfos[group].name + qsTr("Change to") + (isChecked ? qsTr("Un") : qsTr("En")));


        panelRobotController.setConfigValue(pdata.configAddrs[group][pdata.checkSumPos], panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onOriginSpdChanged(){
        var addr = currentGroupAddr(22);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, originSpd.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, originSpd.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onMotorDirChanged(){
        var addr = currentGroupAddr(23);
        var oldV = panelRobotController.getConfigValue(addr);
        panelRobotController.setConfigValue(addr, motorDir.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, motorDir.text(motorDir.configValue), motorDir.text(oldV));


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onSACC1Changed(){
        var addr = currentGroupAddr(24);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, sACC1.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, sACC1.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onSACC2Changed(){
        var addr = currentGroupAddr(25);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, sACC2.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, sACC2.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onSDCC1Changed(){
        var addr = currentGroupAddr(26);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, sDCC1.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, sDCC1.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onSDCC2Changed(){
        var addr = currentGroupAddr(27);
        var oldV = panelRobotController.getConfigValueText(addr);
        panelRobotController.setConfigValue(addr, sDCC2.configValue);
        panelRobotController.syncConfigs();
        ICOperationLog.appendNumberConfigOperationLog(addr, sDCC2.configValue, oldV);


        panelRobotController.setConfigValue(currentGroupAddr(pdata.checkSumPos), panelRobotController.configsCheckSum(checkSumAddrs()));
        panelRobotController.syncConfigs();
    }

    function onOriginOffsetChanged(){
        var addr = originOffsetPulse.configAddrs[pdata.currentGroup];
        panelRobotController.setConfigValue(addr, originOffsetPulse.configValue);
        panelRobotController.syncConfigs();
    }

    function onTestSpeedChanged(){
        var addr = testSpeed.configAddrs[pdata.currentGroup];
        panelRobotController.setConfigValue(addr, testSpeed.configValue);
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

    function updateCheckBoxValue(editor, addr, handler){
        editor.isCheckedChanged.disconnect(handler);
        editor.isChecked = panelRobotController.getConfigValue(addr);
        editor.isCheckedChanged.connect(handler);
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
        updateCheckBoxValue(pLimitPointDir, pdata.configAddrs[which][18], onPLimitDirChanged);
        updateCheckBoxValue(nLimitPointDir, pdata.configAddrs[which][19], onNLimitDirChanged);
        updateCheckBoxValue(originRunDirInvert, pdata.configAddrs[which][20], onOriginMoveDirChanged);
        updateConfigValue(originSpd, pdata.configAddrs[which][22], onOriginSpdChanged);
        updateComboBoxValue(motorDir, pdata.configAddrs[which][23], onMotorDirChanged);
        updateConfigValue(sACC1, pdata.configAddrs[which][24], onSACC1Changed);
        updateConfigValue(sACC2, pdata.configAddrs[which][25], onSACC2Changed);
        updateConfigValue(sDCC1, pdata.configAddrs[which][26], onSDCC1Changed);
        updateConfigValue(sDCC2, pdata.configAddrs[which][27], onSDCC2Changed);
        updateConfigValue(originOffsetPulse,originOffsetPulse.configAddrs[which],onOriginOffsetChanged);
        updateConfigValue(testSpeed,testSpeed.configAddrs[which],onTestSpeedChanged);
    }

    function setAxisVisiable(axis,vis){
        AxisDefine.axisInfos[axis].visiable = vis;
        AxisDefine.informMonitors();
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
            horizontalAlignment: Text.AlignLeft
            itemText: AxisDefine.axisInfos[0].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(0)
            }
            ICCheckBox{
                id:motor1En
                text: qsTr("Un")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 6
                onIsCheckedChanged: {
                    onMotorEnChanged(0, isChecked);
                    setAxisVisiable(0,isChecked?false:true);
                }
            }
        }
        TabMenuItem{
            id:motor2
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            horizontalAlignment: Text.AlignLeft
            itemText: AxisDefine.axisInfos[1].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(1)
            }
            ICCheckBox{
                id:motor2En
                text: qsTr("Un")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 6
                onIsCheckedChanged: {
                    onMotorEnChanged(1, isChecked);
                    setAxisVisiable(1,isChecked?false:true);
                }
            }
        }
        TabMenuItem{
            id:motor3
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            horizontalAlignment: Text.AlignLeft
            itemText: AxisDefine.axisInfos[2].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(2)
            }
            ICCheckBox{
                id:motor3En
                text: qsTr("Un")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 6
                onIsCheckedChanged: {
                    onMotorEnChanged(2, isChecked);
                    setAxisVisiable(2,isChecked?false:true);
                }
            }
        }
        TabMenuItem{
            id:motor4
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            horizontalAlignment: Text.AlignLeft
            itemText: AxisDefine.axisInfos[3].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(3);
            }
            ICCheckBox{
                id:motor4En
                text: qsTr("Un")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 6
                onIsCheckedChanged: {
                    onMotorEnChanged(3, isChecked);
                    setAxisVisiable(3,isChecked?false:true);
                }
            }
        }
        TabMenuItem{
            id:motor5
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            horizontalAlignment: Text.AlignLeft
            itemText: AxisDefine.axisInfos[4].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(4);
            }
            ICCheckBox{
                id:motor5En
                text: qsTr("Un")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 6
                onIsCheckedChanged: {
                    onMotorEnChanged(4, isChecked);
                    setAxisVisiable(4,isChecked?false:true);
                }
            }
        }
        TabMenuItem{
            id:motor6
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            horizontalAlignment: Text.AlignLeft
            itemText: AxisDefine.axisInfos[5].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(5)
            }
            ICCheckBox{
                id:motor6En
                text: qsTr("Un")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 6
                onIsCheckedChanged: {
                    onMotorEnChanged(5, isChecked);
                    setAxisVisiable(5,isChecked?false:true);
                }
            }
        }
        TabMenuItem{
            id:motor7
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            horizontalAlignment: Text.AlignLeft
            itemText: AxisDefine.axisInfos[6].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(6)
            }
            ICCheckBox{
                id:motor7En
                text: qsTr("Un")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 6
                onIsCheckedChanged: {
                    onMotorEnChanged(6, isChecked);
                    setAxisVisiable(6,isChecked?false:true);
                }
            }
        }
        TabMenuItem{
            id:motor8
            width: pdata.tabWidth;
            height: pdata.menuItemHeight
            horizontalAlignment: Text.AlignLeft
            itemText: AxisDefine.axisInfos[7].name
            color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            onItemTriggered: {
                showMotorConfigs(7)
            }
            ICCheckBox{
                id:motor8En
                text: qsTr("Un")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 6
                onIsCheckedChanged: {
                    onMotorEnChanged(7, isChecked)
                    setAxisVisiable(7,isChecked?false:true);
                }
            }
        }
    }

    Rectangle{
        id:line
        width: 800
        height: 1
        y:menuContainer.y
        x:0
        color: "black"
        anchors.top: menuContainer.bottom
    }

    Item{
        anchors.top: line.bottom
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
                    id:encoderType
                    configName: qsTr("Encoder Type")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items: [qsTr("Encode Type1"), qsTr("Encode Type2"), qsTr("Encode Type3")]
                    z:10
                }
                ICComboBoxConfigEdit{
                    id:motorFactory
                    configName: qsTr("Motor Factory")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items: [qsTr("Motor 1"), qsTr("Motor 2"), qsTr("Motor 3"), qsTr("Motor 4"), qsTr("Motor 5"), qsTr("Motor 6")]
                    z:9
                    visible: encoderType.configValue == 1
                }

                ICComboBoxConfigEdit{
                    id:encoderReadWay
                    configName: qsTr("Encoder Read Way")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items: [qsTr("Encode RW1"), qsTr("Encode RW2"), qsTr("Encode RW3")]
                    z:8
                }

                ICComboBoxConfigEdit{
                    id:axisType
                    configName: qsTr("Axis Type")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items:[qsTr("Rotate"), qsTr("Line")]
                    z:7
                }
                ICComboBoxConfigEdit{
                    id:motorDir
                    configName: qsTr("Motor Dir")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    items:[qsTr("PP"), qsTr("RP")]
                    z:6
                }

                ICConfigEdit{
                    id:pulseCountPerCircle
                    configName: qsTr("Pulse Count Per Circle")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    unit: qsTr("a")
                }
                ICConfigEdit{
                    id:length
                    configName: qsTr("Arm Length")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    unit: qsTr("mm")
                    visible: axisType.configValue == 1
                }
                ICConfigEdit{
                    id:reductionRatio
                    configName: qsTr("Reduction Ratio")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                    visible: axisType.configValue == 0
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
                Row{
                    ICConfigEdit{
                        id:pLimitPoint
                        configName: qsTr("Positive Limit Point")
                        configNameWidth: pdata.configNameWidth
                        inputWidth: pdata.inputWidth / 2

                    }
                    ICCheckBox{
                        id:pLimitPointDir
                        text: qsTr("A ON")
                    }
                }
                Row{
                    ICConfigEdit{
                        id:nLimitPoint
                        configName: qsTr("Negative Limit Point")
                        configNameWidth: pdata.configNameWidth
                        inputWidth: pdata.inputWidth / 2
                    }
                    ICCheckBox{
                        id:nLimitPointDir
                        text: qsTr("A ON")
                    }
                }
                Row{
                    ICConfigEdit{
                        id:originPoint
                        configName: qsTr("Origin Point")
                        configNameWidth: pdata.configNameWidth
                        inputWidth: pdata.inputWidth / 2

                    }
                    ICCheckBox{
                        id:originRunDirInvert
                        text: qsTr("INV Move")
                    }
                }
                ICConfigEdit{
                    id:originSpd
                    configName: qsTr("Origin SPD")
                    configNameWidth: pdata.configNameWidth
                    unit: qsTr("%")
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
                ICConfigEdit{
                    id:sACC1
                    configName: qsTr("SACC1")
                    unit: qsTr("%")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                }
                ICConfigEdit{
                    id:sACC2
                    configName: qsTr("SACC2")
                    unit: qsTr("%")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                }
                ICConfigEdit{
                    id:sDCC1
                    configName: qsTr("SDCC1")
                    unit: qsTr("%")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                }
                ICConfigEdit{
                    id:sDCC2
                    configName: qsTr("SDCC2")
                    unit: qsTr("%")
                    configNameWidth: pdata.configNameWidth
                    inputWidth: pdata.inputWidth
                }
                ICConfigEdit{
                    id:originOffsetPulse
                    configName: qsTr("originOffset")
                    property variant configAddrs: ["s_rw_0_16_0_221","s_rw_16_16_0_221","s_rw_0_16_0_222",
                        "s_rw_16_16_0_222","s_rw_0_16_0_223","s_rw_16_16_0_223","s_rw_0_16_0_224","s_rw_16_16_0_224"]
                    unit: qsTr("a")
                    configNameWidth: pdata.configNameWidth
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
                spacing: 3
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
                    text: qsTr("Test Speed:")
                }
                ICConfigEdit{
                    id:testSpeed
                    unit: qsTr("%")
                    property variant configAddrs: ["s_rw_0_8_0_225","s_rw_8_8_0_225","s_rw_16_8_0_225",
                        "s_rw_24_8_0_225","s_rw_0_8_0_226","s_rw_8_8_0_226","s_rw_16_8_0_226","s_rw_24_8_0_226"]
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
                    if(visible){
                        console.log("IN Config");
                        testClear.clicked();
                        panelRobotController.setMotorTestPulseNum(testPulseNum.text);
                    }
                    console.log("Out Config");
                    panelRobotController.swichPulseAngleDisplay(visible ? 5:0);
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
        motor1En.setChecked(panelRobotController.getConfigValue(pdata.configAddrs[0][21]));
        motor2En.setChecked(panelRobotController.getConfigValue(pdata.configAddrs[1][21]));
        motor3En.setChecked(panelRobotController.getConfigValue(pdata.configAddrs[2][21]));
        motor4En.setChecked(panelRobotController.getConfigValue(pdata.configAddrs[3][21]));
        motor5En.setChecked(panelRobotController.getConfigValue(pdata.configAddrs[4][21]));
        motor6En.setChecked(panelRobotController.getConfigValue(pdata.configAddrs[5][21]));
        motor7En.setChecked(panelRobotController.getConfigValue(pdata.configAddrs[6][21]));
        motor8En.setChecked(panelRobotController.getConfigValue(pdata.configAddrs[7][21]));
        pdata.isInit = true;
    }
    function onAxisDefinesChanged(){
        var num = panelRobotController.getConfigValue("s_rw_16_6_0_184");
        motor1.visible = 0 < num?true:false;
        motor2.visible = 1 < num?true:false;
        motor3.visible = 2 < num?true:false;
        motor4.visible = 3 < num?true:false;
        motor5.visible = 4 < num?true:false;
        motor6.visible = 5 < num?true:false;
        motor7.visible = 6 < num?true:false;
        motor8.visible = 7 < num?true:false;
    }
}
