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
    1:qsTr("ALARM_NOT_INIT                 "),
    2:qsTr("ALARM_AXIS_CFG_DIFF            "),
    3:qsTr("ALARM_AXIS_CFG_ERR             "),
    4:qsTr("ALARM_OUT_OF_MEMORY_ERR        "),
    5:qsTr("ALARM_TEACH_DATA_ANALYTICAL_ERR"),
    6:qsTr("ALARM_TEACH_DATA_EDIT_ERR      "),
    7:qsTr("ALARM_EMERGENCY_STOP           "),
    8:qsTr("ALARM_AUTO_JUMP_ERR"),
    9:qsTr("Connect host fail!"),
    10:qsTr("ALARM_PROGRAM_ERR"),
    11:qsTr("ALARM_CFG_STORAGE_ERR"),
    12:qsTr("ALARM_MAHCINE_SET_ERR"),
    13:qsTr("ALARM_SINGLE_DEBUG_ERR"),
    14:qsTr("ALARM_STORAGE_READ_ERR"),
    15:qsTr("ALARM_IO_CONNET_ERR"),
    16:qsTr("ALARM_SERVO_ABS_READ_ERR"),
    17:qsTr("ALARM_SERVO_ABS_CRC_ERR"),
    18:qsTr("ALARM_SERVO_ABS_FUNC_ERR"),
    19:qsTr("ALARM_SERVO_ABS_OVERTIME_ERR"),
    20:qsTr("ALARM_IO_CONNET2_ERR"),
    21:qsTr("ALARM_IO_CONNET3_ERR"),
    22:qsTr("ALARM_IO_CONNET4_ERR"),
    23:qsTr("ALARM_PROGRAM_CHANGE_ERR"),
    24:qsTr("1"),
    25:qsTr("2"),
    26:qsTr("3"),
    27:qsTr("1"),
    28:qsTr("2"),
    29:qsTr("3"),


    90:m0Name + qsTr("ALARM_Motor_ALARM_ERR"),
    91:m1Name + qsTr("ALARM_Motor_ALARM_ERR"),
    92:m2Name + qsTr("ALARM_Motor_ALARM_ERR"),
    93:m3Name + qsTr("ALARM_Motor_ALARM_ERR"),
    94:m4Name + qsTr("ALARM_Motor_ALARM_ERR"),
    95:m5Name + qsTr("ALARM_Motor_ALARM_ERR"),
    96:qsTr("3"),
    97:qsTr("1"),
    98:qsTr("2"),
    99:qsTr("3"),

    100:m0Name + qsTr("ALARM_AXIS_RUN_ERR "),
    101:m1Name + qsTr("ALARM_AXIS_RUN_ERR"),
    102:m2Name + qsTr("ALARM_AXIS_RUN_ERR"),
    103:m3Name + qsTr("ALARM_AXIS_RUN_ERR"),
    104:m4Name + qsTr("ALARM_AXIS_RUN_ERR"),
    105:m5Name + qsTr("ALARM_AXIS_RUN_ERR"),
    106:qsTr("3"),
    107:qsTr("1"),
    108:qsTr("2"),
    109:qsTr("3"),


    110:m0Name + qsTr("ALARM_AXIS_SPEED_SET_ERR "),
    111:m1Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    112:m2Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    113:m3Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    114:m4Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    115:m5Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    116:qsTr("3"),
    117:qsTr("1"),
    118:qsTr("2"),
    119:qsTr("3"),

    120:m0Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR "),
    121:m1Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    122:m2Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    123:m3Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    124:m4Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    125:m5Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    126:qsTr("3"),
    127:qsTr("1"),
    128:qsTr("2"),
    129:qsTr("3"),

    130:m0Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    131:m1Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    132:m2Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    133:m3Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    134:m4Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    135:m5Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    136:qsTr("3"),
    137:qsTr("1"),
    138:qsTr("2"),
    139:qsTr("3"),


    140:m0Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    141:m1Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    142:m2Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    143:m3Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    144:m4Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    145:m5Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    146:qsTr("3"),
    147:qsTr("1"),
    148:qsTr("2"),
    149:qsTr("3"),

    150:m0Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    151:m1Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    152:m2Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    153:m3Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    154:m4Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    155:m5Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    156:qsTr("3"),
    157:qsTr("1"),
    158:qsTr("2"),
    159:qsTr("3"),

    160:m0Name + qsTr("ALARM_ACC_LIMIT"),
    161:m1Name + qsTr("ALARM_ACC_LIMIT"),
    162:m2Name + qsTr("ALARM_ACC_LIMIT"),
    163:m3Name + qsTr("ALARM_ACC_LIMIT"),
    164:m4Name + qsTr("ALARM_ACC_LIMIT"),
    165:m5Name + qsTr("ALARM_ACC_LIMIT"),
    166:qsTr("3"),
    167:qsTr("1"),
    168:qsTr("2"),
    169:qsTr("3"),

    170:m0Name + qsTr("ALARM_POINT_LIMIT_P"),
    171:m1Name + qsTr("ALARM_POINT_LIMIT_P"),
    172:m2Name + qsTr("ALARM_POINT_LIMIT_P"),
    173:m3Name + qsTr("ALARM_POINT_LIMIT_P"),
    174:m4Name + qsTr("ALARM_POINT_LIMIT_P"),
    175:m5Name + qsTr("ALARM_POINT_LIMIT_P"),
    176:qsTr("3"),
    177:qsTr("1"),
    178:qsTr("2"),
    179:qsTr("3"),

    180:m0Name + qsTr("ALARM_POINT_LIMIT_N"),
    181:m1Name + qsTr("ALARM_POINT_LIMIT_N"),
    182:m2Name + qsTr("ALARM_POINT_LIMIT_N"),
    183:m3Name + qsTr("ALARM_POINT_LIMIT_N"),
    184:m4Name + qsTr("ALARM_POINT_LIMIT_N"),
    185:m5Name + qsTr("ALARM_POINT_LIMIT_N"),
    186:qsTr("3"),
    187:qsTr("1"),
    188:qsTr("2"),
    189:qsTr("3"),

    190:m0Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    191:m1Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    192:m2Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    193:m3Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    194:m4Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    195:m5Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    196:qsTr("3"),
    197:qsTr("1"),
    198:qsTr("2"),
    199:qsTr("3"),

    200:qsTr("ALARM_ROUTE_ACTION_FAIL"),
    201:qsTr("ALARM_ROUTE_LINE_P1_NOTSET"),
    202:qsTr("ALARM_ROUTE_LINE_P2_NOTSET"),
    203:qsTr("ALARM_JOINT_P1_NOTSET"),
    204:qsTr("ALARM_JOINT_P2_NOTSET"),
    205:qsTr("ALARM_RELATIVE_LP_NOTSET"),
    206:qsTr("ALARM_RELATIVE_JP_NOTSET"),
    207:qsTr("ALARM_TEACH_ROUTE_LINE_P1_NOTSET"),
    208:qsTr("ALARM_TEACH_ROUTE_LINE_P2_NOTSET"),
    209:qsTr("ALARM_TEACH_JOINT_P1_NOTSET"),
    210:qsTr("ALARM_TEACH_JOINT_P2_NOTSET"),
    211:qsTr("ALARM_TEACH_RELATIVE_LP_NOTSET"),
    212:qsTr("ALARM_TEACH_RELATIVE_JP_NOTSET"),
    213:qsTr("ALARM_ROUTE_ARC_P1_NOTSET"),
    214:qsTr("ALARM_ROUTE_ARC_P2_NOTSET"),
    215:qsTr("ALARM_ROUTE_ARC_P3_NOTSET"),
    216:qsTr("ALARM_TEACH_ROUTE_ARC_P1_NOTSET"),
    217:qsTr("ALARM_TEACH_ROUTE_ARC_P2_NOTSET"),
    218:qsTr("ALARM_TEACH_ROUTE_ARC_P3_NOTSET"),
    219:qsTr("ALARM_SETROUTESPEED_FAIL"),
    220:qsTr("ALARM_ROUTE_ACC_ERR"),
    221:qsTr("ALARM_ROUTE_REPLAN_ERR"),
    222:qsTr("ALARM_STACK_WAITE_ERR"),
    223:qsTr("ALARM_STACK_SOURCE_ERR"),


    300:qsTr("ALARM_COUNTER_NOT_DEFINE"),

    500:m0Name + qsTr("ALARM_OVER_CURRENT"),
    501:m1Name + qsTr("ALARM_OVER_CURRENT"),
    502:m2Name + qsTr("ALARM_OVER_CURRENT"),
    503:m3Name + qsTr("ALARM_OVER_CURRENT"),
    504:m4Name + qsTr("ALARM_OVER_CURRENT"),
    505:m5Name + qsTr("ALARM_OVER_CURRENT"),

    510:m0Name + qsTr("ALARM_ZPULSER_ERR"),
    511:m1Name + qsTr("ALARM_ZPULSER_ERR"),
    512:m2Name + qsTr("ALARM_ZPULSER_ERR"),
    513:m3Name + qsTr("ALARM_ZPULSER_ERR"),
    514:m4Name + qsTr("ALARM_ZPULSER_ERR"),
    515:m5Name + qsTr("ALARM_ZPULSER_ERR"),

    520:m0Name + qsTr("ALARM_NO_ZPULSER"),
    521:m1Name + qsTr("ALARM_NO_ZPULSER"),
    522:m2Name + qsTr("ALARM_NO_ZPULSER"),
    523:m3Name + qsTr("ALARM_NO_ZPULSER"),
    524:m4Name + qsTr("ALARM_NO_ZPULSER"),
    525:m5Name + qsTr("ALARM_NO_ZPULSER"),

    530:m0Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    531:m1Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    532:m2Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    533:m3Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    534:m4Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    535:m5Name + qsTr("ALARM_ORIGIN_DEVIATION"),

}

var alarmDetails = {
    "1":"1",
    "2":"2",
    "3":"3",
    "4":"4",
    "5":"5",
    "6":"6",
}

function analysisAlarmNum(errNum){
    return {
        "type":(errNum < 2048 ? NORMAL_TYPE: (errNum >> 8) & 0x7),
        "board":(errNum >> 5) & 0x7,
        "point":(errNum & 0x1F)
    };
}

function isWaitONAlarmType(errNum){
    if(errNum >= 2048)
    {
        return ((errNum >> 8) & 0x7) == ALARM_IO_ON_SIGNAL_START;
    }
    return false;
}

function getAlarmDescr(errNum){
    if(alarmInfo.hasOwnProperty(errNum.toString())){
        return alarmInfo[errNum.toString()];
    }else if(customAlarmInfo.hasOwnProperty(errNum.toString())){
        return customAlarmInfo[errNum.toString()];
    }else{
        var alarm = analysisAlarmNum(errNum);
        if(alarm.type === ALARM_IO_ON_SIGNAL_START){
            return qsTr("Wait Input:") + getXDefineFromHWPoint(alarm.point, alarm.board).xDefine.descr + qsTr("ON over time")
        }else if(alarm.type === ALARM_IO_OFF_SIGNAL_START){
            return qsTr("Wait Input:") + getXDefineFromHWPoint(alarm.point, alarm.board).xDefine.descr + qsTr("OFF over time")
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

var customAlarmInfo = {
    "5000":qsTr("5000"),
    "5001":qsTr("5001"),
    "5002":qsTr("5002"),
    "5003":qsTr("5003"),
    "5004":qsTr("5004"),
    "5005":qsTr("5005"),
    "5006":qsTr("5006"),
    "5007":qsTr("5007"),
    "5008":qsTr("5008"),
    "5009":qsTr("5009"),
    "5010":qsTr("5010"),
    "5011":qsTr("5011"),
    "5012":qsTr("5012"),
    "5013":qsTr("5013"),
    "5014":qsTr("5014"),
    "5015":qsTr("5015"),
    "5016":qsTr("5016"),
    "5017":qsTr("5017"),
    "5018":qsTr("5018"),
    "5019":qsTr("5019"),
    "5020":qsTr("5020"),
}

function getCustomAlarmDescr(errNum){
    if(customAlarmInfo.hasOwnProperty(errNum.toString())){
        return customAlarmInfo[errNum.toString()];
    }
    return qsTr("Unknow Err");
}

function getAlarmDetail(errNum){
    if(errNum == 9){
        return qsTr("1.Connector loose\n2.Wire is off\n3.Pannel is broken\n4.Host is broken")
    }

    return qsTr("None");
}
