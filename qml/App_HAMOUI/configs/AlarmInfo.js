.pragma library
Qt.include("IODefines.js")
Qt.include("AxisDefine.js")

var ALARM_IO_OFF_SIGNAL_START = 0;   //<名字：IO输入等待OFF时间内未检测到信号
var ALARM_IO_ON_SIGNAL_START = 1;    //<名字：IO输入等待ON时间内未检测到信号
var ALARM_SINGLE_OFF_START = 2;//<名字：单头阀IO输入检测ON时间内未检测到信号
var ALARM_SINGLE_ON_START = 3;//<名字：单头阀IO输入检测ON时间内未检测到信号
var ALARM_DOUBLE_OFF_START = 4;  //<名字：双头阀IO输入检测时间内未检测到信号
var ALARM_DOUBLE_ON_START = 5;//<名字：双头阀IO输入检测时间内未检测到信号
var NORMAL_TYPE = 9;

var m0Name = axisInfos[0].name;
var m1Name = axisInfos[1].name;
var m2Name = axisInfos[2].name;
var m3Name = axisInfos[3].name;
var m4Name = axisInfos[4].name;
var m5Name = axisInfos[5].name;


var alarmInfo = {
    "1":qsTr("ALARM_NOT_INIT                 "),
    "2":qsTr("ALARM_AXIS_CFG_DIFF            "),
    "3":qsTr("ALARM_AXIS_CFG_ERR             "),
    "4":qsTr("ALARM_OUT_OF_MEMORY_ERR        "),
    "5":qsTr("ALARM_TEACH_DATA_ANALYTICAL_ERR"),
    "6":qsTr("ALARM_TEACH_DATA_EDIT_ERR      "),
    "7":qsTr("ALARM_EMERGENCY_STOP           "),
    "8":qsTr("ALARM_AUTO_JUMP_ERR"),
    "9":qsTr("Connect host fail!"),
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


    "90":m0Name + qsTr("ALARM_Motor_ALARM_ERR"),
    "91":m1Name + qsTr("ALARM_Motor_ALARM_ERR"),
    "92":m2Name + qsTr("ALARM_Motor_ALARM_ERR"),
    "93":m3Name + qsTr("ALARM_Motor_ALARM_ERR"),
    "94":m4Name + qsTr("ALARM_Motor_ALARM_ERR"),
    "95":m5Name + qsTr("ALARM_Motor_ALARM_ERR"),
    "96":qsTr("3"),
    "97":qsTr("1"),
    "98":qsTr("2"),
    "99":qsTr("3"),

    "100":m0Name + qsTr("ALARM_AXIS_RUN_ERR "),
    "101":m1Name + qsTr("ALARM_AXIS_RUN_ERR"),
    "102":m2Name + qsTr("ALARM_AXIS_RUN_ERR"),
    "103":m3Name + qsTr("ALARM_AXIS_RUN_ERR"),
    "104":m4Name + qsTr("ALARM_AXIS_RUN_ERR"),
    "105":m5Name + qsTr("ALARM_AXIS_RUN_ERR"),
    "106":qsTr("3"),
    "107":qsTr("1"),
    "108":qsTr("2"),
    "109":qsTr("3"),


    "110":m0Name + qsTr("ALARM_AXIS_SPEED_SET_ERR "),
    "111":m1Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    "112":m2Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    "113":m3Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    "114":m4Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    "115":m5Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    "116":qsTr("3"),
    "117":qsTr("1"),
    "118":qsTr("2"),
    "119":qsTr("3"),

    "120":m0Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR "),
    "121":m1Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    "122":m2Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    "123":m3Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    "124":m4Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    "125":m5Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    "126":qsTr("3"),
    "127":qsTr("1"),
    "128":qsTr("2"),
    "129":qsTr("3"),

    "130":m0Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    "131":m1Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    "132":m2Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    "133":m3Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    "134":m4Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    "135":m5Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    "136":qsTr("3"),
    "137":qsTr("1"),
    "138":qsTr("2"),
    "139":qsTr("3"),


    "140":m0Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    "141":m1Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    "142":m2Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    "143":m3Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    "144":m4Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    "145":m5Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    "146":qsTr("3"),
    "147":qsTr("1"),
    "148":qsTr("2"),
    "149":qsTr("3"),

    "150":m0Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    "151":m1Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    "152":m2Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    "153":m3Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    "154":m4Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    "155":m5Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    "156":qsTr("3"),
    "157":qsTr("1"),
    "158":qsTr("2"),
    "159":qsTr("3"),

    "200":qsTr("ALARM_ROUTE_ACTION_FAIL"),
    "201":qsTr("ALARM_ROUTE_LINE_P1_NOTSET"),
    "202":qsTr("ALARM_ROUTE_LINE_P2_NOTSET"),
    "203":qsTr("ALARM_ROUTE_ARC_P1_NOTSET"),
    "204":qsTr("ALARM_ROUTE_ARC_P2_NOTSET"),
    "205":qsTr("ALARM_ROUTE_ARC_P3_NOTSET"),
    "206":qsTr("ALARM_SETROUTESPEED_FAIL"),
    "207":qsTr("1"),
    "208":qsTr("2"),
    "209":qsTr("3"),
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
