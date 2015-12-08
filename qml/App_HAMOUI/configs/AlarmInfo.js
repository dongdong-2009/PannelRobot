.pragma library
Qt.include("IODefines.js")

var ALARM_IO_OFF_SIGNAL_START = 0;   //<名字：IO输入等待OFF时间内未检测到信号
var ALARM_IO_ON_SIGNAL_START = 1;    //<名字：IO输入等待ON时间内未检测到信号
var ALARM_SINGLE_OFF_START = 2;//<名字：单头阀IO输入检测ON时间内未检测到信号
var ALARM_SINGLE_ON_START = 3;//<名字：单头阀IO输入检测ON时间内未检测到信号
var ALARM_DOUBLE_OFF_START = 4;  //<名字：双头阀IO输入检测时间内未检测到信号
var ALARM_DOUBLE_ON_START = 5;//<名字：双头阀IO输入检测时间内未检测到信号
var NORMAL_TYPE = 9;

var alarmInfo = {
    "1":qsTr("ALARM_NOT_INIT                 "),
    "2":qsTr("ALARM_AXIS_CFG_DIFF            "),
    "3":qsTr("ALARM_AXIS_CFG_ERR             "),
    "4":qsTr("ALARM_OUT_OF_MEMORY_ERR        "),
    "5":qsTr("ALARM_TEACH_DATA_ANALYTICAL_ERR"),
    "6":qsTr("ALARM_TEACH_DATA_EDIT_ERR      "),
    "7":qsTr("ALARM_EMERGENCY_STOP           "),
    "8":qsTr("2"),
    "9":qsTr("3"),
    "10":qsTr("3"),
    "11":qsTr("1"),
    "12":qsTr("2"),
    "13":qsTr("3"),
    "14":qsTr("1"),
    "15":qsTr("2"),
    "16":qsTr("3"),
    "17":qsTr("1"),
    "18":qsTr("2"),
    "19":qsTr("3"),
    "20":qsTr("3"),
    "21":qsTr("1"),
    "22":qsTr("2"),
    "23":qsTr("3"),
    "24":qsTr("1"),
    "25":qsTr("2"),
    "26":qsTr("3"),
    "27":qsTr("1"),
    "28":qsTr("2"),
    "29":qsTr("3"),


    "90":qsTr("ALARM_AXIS1_ALARM_ERR"),
    "91":qsTr("ALARM_AXIS2_ALARM_ERR"),
    "92":qsTr("ALARM_AXIS3_ALARM_ERR"),
    "93":qsTr("ALARM_AXIS4_ALARM_ERR"),
    "94":qsTr("ALARM_AXIS5_ALARM_ERR"),
    "95":qsTr("ALARM_AXIS6_ALARM_ERR"),
    "96":qsTr("3"),
    "97":qsTr("1"),
    "98":qsTr("2"),
    "99":qsTr("3"),

    "100":qsTr("ALARM_AXIS_RUN_ERR "),
    "101":qsTr("ALARM_AXIS2_RUN_ERR"),
    "102":qsTr("ALARM_AXIS3_RUN_ERR"),
    "103":qsTr("ALARM_AXIS4_RUN_ERR"),
    "104":qsTr("ALARM_AXIS5_RUN_ERR"),
    "105":qsTr("ALARM_AXIS6_RUN_ERR"),
    "106":qsTr("3"),
    "107":qsTr("1"),
    "108":qsTr("2"),
    "109":qsTr("3"),


    "110":qsTr("ALARM_AXIS_SPEED_SET_ERR "),
    "111":qsTr("ALARM_AXIS2_SPEED_SET_ERR"),
    "112":qsTr("ALARM_AXIS3_SPEED_SET_ERR"),
    "113":qsTr("ALARM_AXIS4_SPEED_SET_ERR"),
    "114":qsTr("ALARM_AXIS5_SPEED_SET_ERR"),
    "115":qsTr("ALARM_AXIS6_SPEED_SET_ERR"),
    "116":qsTr("3"),
    "117":qsTr("1"),
    "118":qsTr("2"),
    "119":qsTr("3"),

    "120":qsTr("ALARM_AXIS_OVER_SPEED_ERR "),
    "121":qsTr("ALARM_AXIS2_OVER_SPEED_ERR"),
    "122":qsTr("ALARM_AXIS3_OVER_SPEED_ERR"),
    "123":qsTr("ALARM_AXIS4_OVER_SPEED_ERR"),
    "124":qsTr("ALARM_AXIS5_OVER_SPEED_ERR"),
    "125":qsTr("ALARM_AXIS6_OVER_SPEED_ERR"),
    "126":qsTr("3"),
    "127":qsTr("1"),
    "128":qsTr("2"),
    "129":qsTr("3"),

    "130":qsTr("ALARM_AXIS1_SOFT_LIMIT_P"),
    "131":qsTr("ALARM_AXIS2_SOFT_LIMIT_P"),
    "132":qsTr("ALARM_AXIS3_SOFT_LIMIT_P"),
    "133":qsTr("ALARM_AXIS4_SOFT_LIMIT_P"),
    "134":qsTr("ALARM_AXIS5_SOFT_LIMIT_P"),
    "135":qsTr("ALARM_AXIS6_SOFT_LIMIT_P"),
    "136":qsTr("3"),
    "137":qsTr("1"),
    "138":qsTr("2"),
    "139":qsTr("3"),


    "140":qsTr("ALARM_AXIS1_SOFT_LIMIT_N"),
    "141":qsTr("ALARM_AXIS2_SOFT_LIMIT_N"),
    "142":qsTr("ALARM_AXIS3_SOFT_LIMIT_N"),
    "143":qsTr("ALARM_AXIS4_SOFT_LIMIT_N"),
    "144":qsTr("ALARM_AXIS5_SOFT_LIMIT_N"),
    "145":qsTr("ALARM_AXIS6_SOFT_LIMIT_N"),
    "146":qsTr("3"),
    "147":qsTr("1"),
    "148":qsTr("2"),
    "149":qsTr("3"),
}

function analysisAlarmNum(errNum){
    return {
        "type":(errNum <=2048 ? NORMAL_TYPE: (errNum >> 8) & 0x7),
        "board":(errNum >> 5) & 0x7,
        "point":(errNum & 0x1F)
    };
}

function isWaitONAlarmType(errNum){
    if(errNum > 2048)
    {
        return ((errNum >> 8) & 0x7) == ALARM_IO_ON_SIGNAL_START;
    }
    return false;
}

function getAlarmDescr(errNum){
    if(alarmInfo.hasOwnProperty(errNum.toString())){
        return alarmInfo[errNum.toString()];
    }else{
        var alarm = analysisAlarmNum(errNum);
        if(alarm.type === ALARM_IO_ON_SIGNAL_START){
            return qsTr("Wait Input:") + getXDefineFromHWPoint(alarm.point, alarm.type).xDefine.descr + qsTr("ON over time")
        }else if(alarm.type === ALARM_IO_OFF_SIGNAL_START){
            return qsTr("Wait Input:") + getXDefineFromHWPoint(alarm.point, alarm.type).xDefine.descr + qsTr("OFF over time")
        }else if(alarm.type === ALARM_SINGLE_ON_START){
            return qsTr("Wait Single Input:") + getValveItemFromValveID(alarm.point).descr + qsTr("ON over time")
        }else if(alarm.type === ALARM_SINGLE_OFF_START){
            return qsTr("Wait Single Input:") + getValveItemFromValveID(alarm.point).descr + qsTr("OFF over time")
        }
        else if(alarm.type === ALARM_DOUBLE_ON_START){
            return qsTr("Wait Double Input:") + getValveItemFromValveID(alarm.point).descr + qsTr("ON over time")
        }else if(alarm.type === ALARM_DOUBLE_OFF_START){
            return qsTr("Wait Double Input:") + getValveItemFromValveID(alarm.point).descr + qsTr("OFF over time")
        }
    }

    return "";
}
