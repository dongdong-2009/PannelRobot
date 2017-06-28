.pragma library
Qt.include("configs/IODefines.js")
Qt.include("configs/AxisDefine.js")
Qt.include("configs/AlarmConfigs.js")

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
var m6Name = axisInfos[6].name;
var m7Name = axisInfos[7].name;



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
    24:qsTr("ALARM_FPGA_ERR"),
    25:qsTr("ALARM_ANALOG_CRC_ERR"),
    26:qsTr("ALARM_ANALOG_OVERTIME_ERR"),
    27:qsTr("ALARM_USER_COORD_ERR"),
    28:qsTr("ALARM_INTERVAL_ERR"),
    29:qsTr("ALARM_POS_STABLE_ING"),
    30:qsTr("ALARM_NULL_COORD_ERR"),


    90:m0Name + qsTr("ALARM_Motor_ALARM_ERR"),
    91:m1Name + qsTr("ALARM_Motor_ALARM_ERR"),
    92:m2Name + qsTr("ALARM_Motor_ALARM_ERR"),
    93:m3Name + qsTr("ALARM_Motor_ALARM_ERR"),
    94:m4Name + qsTr("ALARM_Motor_ALARM_ERR"),
    95:m5Name + qsTr("ALARM_Motor_ALARM_ERR"),
    96:m6Name + qsTr("ALARM_Motor_ALARM_ERR"),
    97:m7Name + qsTr("ALARM_Motor_ALARM_ERR"),
    98:qsTr("2"),
    99:qsTr("3"),

    100:m0Name + qsTr("ALARM_AXIS_RUN_ERR "),
    101:m1Name + qsTr("ALARM_AXIS_RUN_ERR"),
    102:m2Name + qsTr("ALARM_AXIS_RUN_ERR"),
    103:m3Name + qsTr("ALARM_AXIS_RUN_ERR"),
    104:m4Name + qsTr("ALARM_AXIS_RUN_ERR"),
    105:m5Name + qsTr("ALARM_AXIS_RUN_ERR"),
    106:m6Name + qsTr("ALARM_AXIS_RUN_ERR"),
    107:m7Name + qsTr("ALARM_AXIS_RUN_ERR"),
    108:qsTr("2"),
    109:qsTr("3"),


    110:m0Name + qsTr("ALARM_AXIS_SPEED_SET_ERR "),
    111:m1Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    112:m2Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    113:m3Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    114:m4Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    115:m5Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    116:m6Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    117:m7Name + qsTr("ALARM_AXIS_SPEED_SET_ERR"),
    118:qsTr("2"),
    119:qsTr("3"),

    120:m0Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR "),
    121:m1Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    122:m2Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    123:m3Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    124:m4Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    125:m5Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    126:m6Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    127:m7Name + qsTr("ALARM_AXIS_OVER_SPEED_ERR"),
    128:qsTr("2"),
    129:qsTr("3"),

    130:m0Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    131:m1Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    132:m2Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    133:m3Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    134:m4Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    135:m5Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    136:m6Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    137:m7Name + qsTr("ALARM_AXIS_SOFT_LIMIT_P"),
    138:qsTr("2"),
    139:qsTr("3"),


    140:m0Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    141:m1Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    142:m2Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    143:m3Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    144:m4Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    145:m5Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    146:m6Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    147:m7Name + qsTr("ALARM_AXIS_SOFT_LIMIT_N"),
    148:qsTr("2"),
    149:qsTr("3"),

    150:m0Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    151:m1Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    152:m2Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    153:m3Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    154:m4Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    155:m5Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    156:m6Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    157:m7Name + qsTr("ALARM_ERROR_SERVO_WARP"),
    158:qsTr("2"),
    159:qsTr("3"),

    160:m0Name + qsTr("ALARM_ACC_LIMIT"),
    161:m1Name + qsTr("ALARM_ACC_LIMIT"),
    162:m2Name + qsTr("ALARM_ACC_LIMIT"),
    163:m3Name + qsTr("ALARM_ACC_LIMIT"),
    164:m4Name + qsTr("ALARM_ACC_LIMIT"),
    165:m5Name + qsTr("ALARM_ACC_LIMIT"),
    166:m6Name + qsTr("ALARM_ACC_LIMIT"),
    167:m7Name + qsTr("ALARM_ACC_LIMIT"),
    168:qsTr("2"),
    169:qsTr("3"),

    170:m0Name + qsTr("ALARM_POINT_LIMIT_P"),
    171:m1Name + qsTr("ALARM_POINT_LIMIT_P"),
    172:m2Name + qsTr("ALARM_POINT_LIMIT_P"),
    173:m3Name + qsTr("ALARM_POINT_LIMIT_P"),
    174:m4Name + qsTr("ALARM_POINT_LIMIT_P"),
    175:m5Name + qsTr("ALARM_POINT_LIMIT_P"),
    176:m6Name + qsTr("ALARM_POINT_LIMIT_P"),
    177:m7Name + qsTr("ALARM_POINT_LIMIT_P"),
    178:qsTr("2"),
    179:qsTr("3"),

    180:m0Name + qsTr("ALARM_POINT_LIMIT_N"),
    181:m1Name + qsTr("ALARM_POINT_LIMIT_N"),
    182:m2Name + qsTr("ALARM_POINT_LIMIT_N"),
    183:m3Name + qsTr("ALARM_POINT_LIMIT_N"),
    184:m4Name + qsTr("ALARM_POINT_LIMIT_N"),
    185:m5Name + qsTr("ALARM_POINT_LIMIT_N"),
    186:m6Name + qsTr("ALARM_POINT_LIMIT_N"),
    187:m7Name + qsTr("ALARM_POINT_LIMIT_N"),
    188:qsTr("2"),
    189:qsTr("3"),

    190:m0Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    191:m1Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    192:m2Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    193:m3Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    194:m4Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    195:m5Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    196:m6Name + qsTr("ALARM_NOT_SET_ORIGIN"),
    197:m7Name + qsTr("ALARM_NOT_SET_ORIGIN"),
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
    506:m6Name + qsTr("ALARM_OVER_CURRENT"),
    507:m7Name + qsTr("ALARM_OVER_CURRENT"),

    510:m0Name + qsTr("ALARM_ZPULSER_ERR"),
    511:m1Name + qsTr("ALARM_ZPULSER_ERR"),
    512:m2Name + qsTr("ALARM_ZPULSER_ERR"),
    513:m3Name + qsTr("ALARM_ZPULSER_ERR"),
    514:m4Name + qsTr("ALARM_ZPULSER_ERR"),
    515:m5Name + qsTr("ALARM_ZPULSER_ERR"),
    516:m6Name + qsTr("ALARM_ZPULSER_ERR"),
    517:m7Name + qsTr("ALARM_ZPULSER_ERR"),

    520:m0Name + qsTr("ALARM_NO_ZPULSER"),
    521:m1Name + qsTr("ALARM_NO_ZPULSER"),
    522:m2Name + qsTr("ALARM_NO_ZPULSER"),
    523:m3Name + qsTr("ALARM_NO_ZPULSER"),
    524:m4Name + qsTr("ALARM_NO_ZPULSER"),
    525:m5Name + qsTr("ALARM_NO_ZPULSER"),
    526:m6Name + qsTr("ALARM_NO_ZPULSER"),
    527:m7Name + qsTr("ALARM_NO_ZPULSER"),

    530:m0Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    531:m1Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    532:m2Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    533:m3Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    534:m4Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    535:m5Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    536:m6Name + qsTr("ALARM_ORIGIN_DEVIATION"),
    537:m7Name + qsTr("ALARM_ORIGIN_DEVIATION"),

    600:qsTr("ALARM_UNSAFEAREA_PART1"),
    601:qsTr("ALARM_UNSAFEAREA_PART2"),
    602:qsTr("ALARM_UNSAFEAREA_PART3"),
    603:qsTr("ALARM_UNSAFEAREA_PART4"),
    604:qsTr("ALARM_UNSAFEAREA_PART5"),
    605:qsTr("ALARM_UNSAFEAREA_PART6"),

    700:m0Name + qsTr("ALARM_SERVO_AXIS_INIT_FLT"),
    701:m1Name + qsTr("ALARM_SERVO_AXIS_INIT_FLT"),
    702:m2Name + qsTr("ALARM_SERVO_AXIS_INIT_FLT"),
    703:m3Name + qsTr("ALARM_SERVO_AXIS_INIT_FLT"),
    704:m4Name + qsTr("ALARM_SERVO_AXIS_INIT_FLT"),
    705:m5Name + qsTr("ALARM_SERVO_AXIS_INIT_FLT"),
    706:m6Name + qsTr("ALARM_SERVO_AXIS_INIT_FLT"),
    707:m7Name + qsTr("ALARM_SERVO_AXIS_INIT_FLT"),

    710:m0Name + qsTr("ALARM_SERVO_AXIS_EEPROM_FLT"),
    711:m1Name + qsTr("ALARM_SERVO_AXIS_EEPROM_FLT"),
    712:m2Name + qsTr("ALARM_SERVO_AXIS_EEPROM_FLT"),
    713:m3Name + qsTr("ALARM_SERVO_AXIS_EEPROM_FLT"),
    714:m4Name + qsTr("ALARM_SERVO_AXIS_EEPROM_FLT"),
    715:m5Name + qsTr("ALARM_SERVO_AXIS_EEPROM_FLT"),
    716:m6Name + qsTr("ALARM_SERVO_AXIS_EEPROM_FLT"),
    717:m7Name + qsTr("ALARM_SERVO_AXIS_EEPROM_FLT"),

    720:m0Name + qsTr("ALARM_SERVO_AXIS_ADC_FLT"),
    721:m1Name + qsTr("ALARM_SERVO_AXIS_ADC_FLT"),
    722:m2Name + qsTr("ALARM_SERVO_AXIS_ADC_FLT"),
    723:m3Name + qsTr("ALARM_SERVO_AXIS_ADC_FLT"),
    724:m4Name + qsTr("ALARM_SERVO_AXIS_ADC_FLT"),
    725:m5Name + qsTr("ALARM_SERVO_AXIS_ADC_FLT"),
    726:m6Name + qsTr("ALARM_SERVO_AXIS_ADC_FLT"),
    727:m7Name + qsTr("ALARM_SERVO_AXIS_ADC_FLT"),

    730:m0Name + qsTr("ALARM_SERVO_AXIS_EXECTM_FLT"),
    731:m1Name + qsTr("ALARM_SERVO_AXIS_EXECTM_FLT"),
    732:m2Name + qsTr("ALARM_SERVO_AXIS_EXECTM_FLT"),
    733:m3Name + qsTr("ALARM_SERVO_AXIS_EXECTM_FLT"),
    734:m4Name + qsTr("ALARM_SERVO_AXIS_EXECTM_FLT"),
    735:m5Name + qsTr("ALARM_SERVO_AXIS_EXECTM_FLT"),
    736:m6Name + qsTr("ALARM_SERVO_AXIS_EXECTM_FLT"),
    737:m7Name + qsTr("ALARM_SERVO_AXIS_EXECTM_FLT"),

    740:m0Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT1"),
    741:m1Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT1"),
    742:m2Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT1"),
    743:m3Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT1"),
    744:m4Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT1"),
    745:m5Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT1"),
    746:m6Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT1"),
    747:m7Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT1"),

    750:m0Name + qsTr("ALARM_SERVO_AXIS_OV_FLT"),
    751:m1Name + qsTr("ALARM_SERVO_AXIS_OV_FLT"),
    752:m2Name + qsTr("ALARM_SERVO_AXIS_OV_FLT"),
    753:m3Name + qsTr("ALARM_SERVO_AXIS_OV_FLT"),
    754:m4Name + qsTr("ALARM_SERVO_AXIS_OV_FLT"),
    755:m5Name + qsTr("ALARM_SERVO_AXIS_OV_FLT"),
    756:m6Name + qsTr("ALARM_SERVO_AXIS_OV_FLT"),
    757:m7Name + qsTr("ALARM_SERVO_AXIS_OV_FLT"),

    760:m0Name + qsTr("ALARM_SERVO_AXIS_LV_FLT"),
    761:m1Name + qsTr("ALARM_SERVO_AXIS_LV_FLT"),
    762:m2Name + qsTr("ALARM_SERVO_AXIS_LV_FLT"),
    763:m3Name + qsTr("ALARM_SERVO_AXIS_LV_FLT"),
    764:m4Name + qsTr("ALARM_SERVO_AXIS_LV_FLT"),
    765:m5Name + qsTr("ALARM_SERVO_AXIS_LV_FLT"),
    766:m6Name + qsTr("ALARM_SERVO_AXIS_LV_FLT"),
    767:m7Name + qsTr("ALARM_SERVO_AXIS_LV_FLT"),

    770:m0Name + qsTr("ALARM_SERVO_AXIS_MAIN_POWER_OFF"),
    771:m1Name + qsTr("ALARM_SERVO_AXIS_MAIN_POWER_OFF"),
    772:m2Name + qsTr("ALARM_SERVO_AXIS_MAIN_POWER_OFF"),
    773:m3Name + qsTr("ALARM_SERVO_AXIS_MAIN_POWER_OFF"),
    774:m4Name + qsTr("ALARM_SERVO_AXIS_MAIN_POWER_OFF"),
    775:m5Name + qsTr("ALARM_SERVO_AXIS_MAIN_POWER_OFF"),
    776:m6Name + qsTr("ALARM_SERVO_AXIS_MAIN_POWER_OFF"),
    777:m7Name + qsTr("ALARM_SERVO_AXIS_MAIN_POWER_OFF"),

    780:m0Name + qsTr("ALARM_SERVO_AXIS_GATE_KILL_FLT"),
    781:m1Name + qsTr("ALARM_SERVO_AXIS_GATE_KILL_FLT"),
    782:m2Name + qsTr("ALARM_SERVO_AXIS_GATE_KILL_FLT"),
    783:m3Name + qsTr("ALARM_SERVO_AXIS_GATE_KILL_FLT"),
    784:m4Name + qsTr("ALARM_SERVO_AXIS_GATE_KILL_FLT"),
    785:m5Name + qsTr("ALARM_SERVO_AXIS_GATE_KILL_FLT"),
    786:m6Name + qsTr("ALARM_SERVO_AXIS_GATE_KILL_FLT"),
    787:m7Name + qsTr("ALARM_SERVO_AXIS_GATE_KILL_FLT"),

    790:m0Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT2"),
    791:m1Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT2"),
    792:m2Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT2"),
    793:m3Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT2"),
    794:m4Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT2"),
    795:m5Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT2"),
    796:m6Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT2"),
    797:m7Name + qsTr("ALARM_SERVO_AXIS_OVER_TEMP_FLT2"),

    800:m0Name + qsTr("ALARM_SERVO_AXIS_OVER_LD_FLT"),
    801:m1Name + qsTr("ALARM_SERVO_AXIS_OVER_LD_FLT"),
    802:m2Name + qsTr("ALARM_SERVO_AXIS_OVER_LD_FLT"),
    803:m3Name + qsTr("ALARM_SERVO_AXIS_OVER_LD_FLT"),
    804:m4Name + qsTr("ALARM_SERVO_AXIS_OVER_LD_FLT"),
    805:m5Name + qsTr("ALARM_SERVO_AXIS_OVER_LD_FLT"),
    806:m6Name + qsTr("ALARM_SERVO_AXIS_OVER_LD_FLT"),
    807:m7Name + qsTr("ALARM_SERVO_AXIS_OVER_LD_FLT"),

    810:m0Name + qsTr("ALARM_SERVO_AXIS_OVER_SPD_FLT"),
    811:m1Name + qsTr("ALARM_SERVO_AXIS_OVER_SPD_FLT"),
    812:m2Name + qsTr("ALARM_SERVO_AXIS_OVER_SPD_FLT"),
    813:m3Name + qsTr("ALARM_SERVO_AXIS_OVER_SPD_FLT"),
    814:m4Name + qsTr("ALARM_SERVO_AXIS_OVER_SPD_FLT"),
    815:m5Name + qsTr("ALARM_SERVO_AXIS_OVER_SPD_FLT"),
    816:m6Name + qsTr("ALARM_SERVO_AXIS_OVER_SPD_FLT"),
    817:m7Name + qsTr("ALARM_SERVO_AXIS_OVER_SPD_FLT"),

    820:m0Name + qsTr("ALARM_SERVO_AXIS_OVER_FRQ_FLT"),
    821:m1Name + qsTr("ALARM_SERVO_AXIS_OVER_FRQ_FLT"),
    822:m2Name + qsTr("ALARM_SERVO_AXIS_OVER_FRQ_FLT"),
    823:m3Name + qsTr("ALARM_SERVO_AXIS_OVER_FRQ_FLT"),
    824:m4Name + qsTr("ALARM_SERVO_AXIS_OVER_FRQ_FLT"),
    825:m5Name + qsTr("ALARM_SERVO_AXIS_OVER_FRQ_FLT"),
    826:m6Name + qsTr("ALARM_SERVO_AXIS_OVER_FRQ_FLT"),
    827:m7Name + qsTr("ALARM_SERVO_AXIS_OVER_FRQ_FLT"),

    830:m0Name + qsTr("ALARM_SERVO_AXIS_POS_ERROR_OVER_FLT"),
    831:m1Name + qsTr("ALARM_SERVO_AXIS_POS_ERROR_OVER_FLT"),
    832:m2Name + qsTr("ALARM_SERVO_AXIS_POS_ERROR_OVER_FLT"),
    833:m3Name + qsTr("ALARM_SERVO_AXIS_POS_ERROR_OVER_FLT"),
    834:m4Name + qsTr("ALARM_SERVO_AXIS_POS_ERROR_OVER_FLT"),
    835:m5Name + qsTr("ALARM_SERVO_AXIS_POS_ERROR_OVER_FLT"),
    836:m6Name + qsTr("ALARM_SERVO_AXIS_POS_ERROR_OVER_FLT"),
    837:m7Name + qsTr("ALARM_SERVO_AXIS_POS_ERROR_OVER_FLT"),

    840:m0Name + qsTr("ALARM_SERVO_AXIS_MTR_ENC_FLT"),
    841:m1Name + qsTr("ALARM_SERVO_AXIS_MTR_ENC_FLT"),
    842:m2Name + qsTr("ALARM_SERVO_AXIS_MTR_ENC_FLT"),
    843:m3Name + qsTr("ALARM_SERVO_AXIS_MTR_ENC_FLT"),
    844:m4Name + qsTr("ALARM_SERVO_AXIS_MTR_ENC_FLT"),
    845:m5Name + qsTr("ALARM_SERVO_AXIS_MTR_ENC_FLT"),
    846:m6Name + qsTr("ALARM_SERVO_AXIS_MTR_ENC_FLT"),
    847:m7Name + qsTr("ALARM_SERVO_AXIS_MTR_ENC_FLT"),

    850:m0Name + qsTr("ALARM_SERVO_AXIS_OVER_CUR_FLT"),
    851:m1Name + qsTr("ALARM_SERVO_AXIS_OVER_CUR_FLT"),
    852:m2Name + qsTr("ALARM_SERVO_AXIS_OVER_CUR_FLT"),
    853:m3Name + qsTr("ALARM_SERVO_AXIS_OVER_CUR_FLT"),
    854:m4Name + qsTr("ALARM_SERVO_AXIS_OVER_CUR_FLT"),
    855:m5Name + qsTr("ALARM_SERVO_AXIS_OVER_CUR_FLT"),
    856:m6Name + qsTr("ALARM_SERVO_AXIS_OVER_CUR_FLT"),
    857:m7Name + qsTr("ALARM_SERVO_AXIS_OVER_CUR_FLT"),

    900:m0Name + qsTr("ALARM_SERVO_BATTERY_FLT"),
    901:m1Name + qsTr("ALARM_SERVO_BATTERY_FLT"),
    902:m2Name + qsTr("ALARM_SERVO_BATTERY_FLT"),
    903:m3Name + qsTr("ALARM_SERVO_BATTERY_FLT"),
    904:m4Name + qsTr("ALARM_SERVO_BATTERY_FLT"),
    905:m5Name + qsTr("ALARM_SERVO_BATTERY_FLT"),
    906:m6Name + qsTr("ALARM_SERVO_BATTERY_FLT"),
    907:m7Name + qsTr("ALARM_SERVO_BATTERY_FLT"),

    910:m0Name + qsTr("ALARM_SERVO_ENCODER_FLT"),
    911:m1Name + qsTr("ALARM_SERVO_ENCODER_FLT"),
    912:m2Name + qsTr("ALARM_SERVO_ENCODER_FLT"),
    913:m3Name + qsTr("ALARM_SERVO_ENCODER_FLT"),
    914:m4Name + qsTr("ALARM_SERVO_ENCODER_FLT"),
    915:m5Name + qsTr("ALARM_SERVO_ENCODER_FLT"),
    916:m6Name + qsTr("ALARM_SERVO_ENCODER_FLT"),
    917:m7Name + qsTr("ALARM_SERVO_ENCODER_FLT"),

    1000:m0Name + qsTr("ALARM_SERVO_AXIS_ENABLE_FORBID"),
    1001:m1Name + qsTr("ALARM_SERVO_AXIS_ENABLE_FORBID"),
    1002:m2Name + qsTr("ALARM_SERVO_AXIS_ENABLE_FORBID"),
    1003:m3Name + qsTr("ALARM_SERVO_AXIS_ENABLE_FORBID"),
    1004:m4Name + qsTr("ALARM_SERVO_AXIS_ENABLE_FORBID"),
    1005:m5Name + qsTr("ALARM_SERVO_AXIS_ENABLE_FORBID"),
    1006:m6Name + qsTr("ALARM_SERVO_AXIS_ENABLE_FORBID"),
    1007:m7Name + qsTr("ALARM_SERVO_AXIS_ENABLE_FORBID"),

    1500:m0Name + qsTr("ALARM_ECAN_TIMEOUT"),
    1501:m1Name + qsTr("ALARM_ECAN_TIMEOUT"),
    1502:m2Name + qsTr("ALARM_ECAN_TIMEOUT"),
    1503:m3Name + qsTr("ALARM_ECAN_TIMEOUT"),
    1504:m4Name + qsTr("ALARM_ECAN_TIMEOUT"),
    1505:m5Name + qsTr("ALARM_ECAN_TIMEOUT"),
    1506:m6Name + qsTr("ALARM_ECAN_TIMEOUT"),
    1507:m7Name + qsTr("ALARM_ECAN_TIMEOUT"),

    1508:m0Name + qsTr("ALARM_ECAN_READING"),
    1509:m1Name + qsTr("ALARM_ECAN_READING"),
    1510:m2Name + qsTr("ALARM_ECAN_READING"),
    1511:m3Name + qsTr("ALARM_ECAN_READING"),
    1512:m4Name + qsTr("ALARM_ECAN_READING"),
    1513:m5Name + qsTr("ALARM_ECAN_READING"),
    1514:m6Name + qsTr("ALARM_ECAN_READING"),
    1515:m7Name + qsTr("ALARM_ECAN_READING"),

    1516:m0Name + qsTr("ALARM_ECAN_WRITING"),
    1517:m1Name + qsTr("ALARM_ECAN_WRITING"),
    1518:m2Name + qsTr("ALARM_ECAN_WRITING"),
    1519:m3Name + qsTr("ALARM_ECAN_WRITING"),
    1520:m4Name + qsTr("ALARM_ECAN_WRITING"),
    1521:m5Name + qsTr("ALARM_ECAN_WRITING"),
    1522:m6Name + qsTr("ALARM_ECAN_WRITING"),
    1523:m7Name + qsTr("ALARM_ECAN_WRITING"),

    1516:m0Name + qsTr("ALARM_ECAN_WRITING"),
    1517:m1Name + qsTr("ALARM_ECAN_WRITING"),
    1518:m2Name + qsTr("ALARM_ECAN_WRITING"),
    1519:m3Name + qsTr("ALARM_ECAN_WRITING"),
    1520:m4Name + qsTr("ALARM_ECAN_WRITING"),
    1521:m5Name + qsTr("ALARM_ECAN_WRITING"),
    1522:m6Name + qsTr("ALARM_ECAN_WRITING"),
    1523:m7Name + qsTr("ALARM_ECAN_WRITING"),

    1524:m0Name + qsTr("ALARM_SERVO_OVERCURRENT"),
    1525:m1Name + qsTr("ALARM_SERVO_OVERCURRENT"),
    1526:m2Name + qsTr("ALARM_SERVO_OVERCURRENT"),
    1527:m3Name + qsTr("ALARM_SERVO_OVERCURRENT"),
    1528:m4Name + qsTr("ALARM_SERVO_OVERCURRENT"),
    1529:m5Name + qsTr("ALARM_SERVO_OVERCURRENT"),
    1530:m6Name + qsTr("ALARM_SERVO_OVERCURRENT"),
    1531:m7Name + qsTr("ALARM_SERVO_OVERCURRENT"),

    1532:m0Name + qsTr("ALARM_SERVO_OVERVOLTAGE"),
    1533:m1Name + qsTr("ALARM_SERVO_OVERVOLTAGE"),
    1534:m2Name + qsTr("ALARM_SERVO_OVERVOLTAGE"),
    1535:m3Name + qsTr("ALARM_SERVO_OVERVOLTAGE"),
    1536:m4Name + qsTr("ALARM_SERVO_OVERVOLTAGE"),
    1537:m5Name + qsTr("ALARM_SERVO_OVERVOLTAGE"),
    1538:m6Name + qsTr("ALARM_SERVO_OVERVOLTAGE"),
    1539:m7Name + qsTr("ALARM_SERVO_OVERVOLTAGE"),

    1540:m0Name + qsTr("ALARM_SERVO_LOWVOLTAGE"),
    1541:m1Name + qsTr("ALARM_SERVO_LOWVOLTAGE"),
    1542:m2Name + qsTr("ALARM_SERVO_LOWVOLTAGE"),
    1543:m3Name + qsTr("ALARM_SERVO_LOWVOLTAGE"),
    1544:m4Name + qsTr("ALARM_SERVO_LOWVOLTAGE"),
    1545:m5Name + qsTr("ALARM_SERVO_LOWVOLTAGE"),
    1546:m6Name + qsTr("ALARM_SERVO_LOWVOLTAGE"),
    1547:m7Name + qsTr("ALARM_SERVO_LOWVOLTAGE"),

    1548:m0Name + qsTr("ALARM_SERVO_CTRL_LOWVOLTAGE"),
    1549:m1Name + qsTr("ALARM_SERVO_CTRL_LOWVOLTAGE"),
    1550:m2Name + qsTr("ALARM_SERVO_CTRL_LOWVOLTAGE"),
    1551:m3Name + qsTr("ALARM_SERVO_CTRL_LOWVOLTAGE"),
    1552:m4Name + qsTr("ALARM_SERVO_CTRL_LOWVOLTAGE"),
    1553:m5Name + qsTr("ALARM_SERVO_CTRL_LOWVOLTAGE"),
    1554:m6Name + qsTr("ALARM_SERVO_CTRL_LOWVOLTAGE"),
    1555:m7Name + qsTr("ALARM_SERVO_CTRL_LOWVOLTAGE"),

    1556:m0Name + qsTr("ALARM_SERVO_OUTPU_SHORTCIRCUIT"),
    1557:m1Name + qsTr("ALARM_SERVO_OUTPU_SHORTCIRCUIT"),
    1558:m2Name + qsTr("ALARM_SERVO_OUTPU_SHORTCIRCUIT"),
    1559:m3Name + qsTr("ALARM_SERVO_OUTPU_SHORTCIRCUIT"),
    1560:m4Name + qsTr("ALARM_SERVO_OUTPU_SHORTCIRCUIT"),
    1561:m5Name + qsTr("ALARM_SERVO_OUTPU_SHORTCIRCUIT"),
    1562:m6Name + qsTr("ALARM_SERVO_OUTPU_SHORTCIRCUIT"),
    1563:m7Name + qsTr("ALARM_SERVO_OUTPU_SHORTCIRCUIT"),

    1564:m0Name + qsTr("ALARM_SERVO_POWER_ERROR"),
    1565:m1Name + qsTr("ALARM_SERVO_POWER_ERROR"),
    1566:m2Name + qsTr("ALARM_SERVO_POWER_ERROR"),
    1567:m3Name + qsTr("ALARM_SERVO_POWER_ERROR"),
    1568:m4Name + qsTr("ALARM_SERVO_POWER_ERROR"),
    1569:m5Name + qsTr("ALARM_SERVO_POWER_ERROR"),
    1570:m6Name + qsTr("ALARM_SERVO_POWER_ERROR"),
    1571:m7Name + qsTr("ALARM_SERVO_POWER_ERROR"),

    1572:m0Name + qsTr("ALARM_SERVO_RESISTANCE_OVERLOAD"),
    1573:m1Name + qsTr("ALARM_SERVO_RESISTANCE_OVERLOAD"),
    1574:m2Name + qsTr("ALARM_SERVO_RESISTANCE_OVERLOAD"),
    1575:m3Name + qsTr("ALARM_SERVO_RESISTANCE_OVERLOAD"),
    1576:m4Name + qsTr("ALARM_SERVO_RESISTANCE_OVERLOAD"),
    1577:m5Name + qsTr("ALARM_SERVO_RESISTANCE_OVERLOAD"),
    1578:m6Name + qsTr("ALARM_SERVO_RESISTANCE_OVERLOAD"),
    1579:m7Name + qsTr("ALARM_SERVO_RESISTANCE_OVERLOAD"),

    1580:m0Name + qsTr("ALARM_SERVO_DRIVE_OVERLOAD"),
    1581:m1Name + qsTr("ALARM_SERVO_DRIVE_OVERLOAD"),
    1582:m2Name + qsTr("ALARM_SERVO_DRIVE_OVERLOAD"),
    1583:m3Name + qsTr("ALARM_SERVO_DRIVE_OVERLOAD"),
    1584:m4Name + qsTr("ALARM_SERVO_DRIVE_OVERLOAD"),
    1585:m5Name + qsTr("ALARM_SERVO_DRIVE_OVERLOAD"),
    1586:m6Name + qsTr("ALARM_SERVO_DRIVE_OVERLOAD"),
    1587:m7Name + qsTr("ALARM_SERVO_DRIVE_OVERLOAD"),

    1588:m0Name + qsTr("ALARM_SERVO_MOTOR_POWEROFF"),
    1589:m1Name + qsTr("ALARM_SERVO_MOTOR_POWEROFF"),
    1590:m2Name + qsTr("ALARM_SERVO_MOTOR_POWEROFF"),
    1591:m3Name + qsTr("ALARM_SERVO_MOTOR_POWEROFF"),
    1592:m4Name + qsTr("ALARM_SERVO_MOTOR_POWEROFF"),
    1593:m5Name + qsTr("ALARM_SERVO_MOTOR_POWEROFF"),
    1594:m6Name + qsTr("ALARM_SERVO_MOTOR_POWEROFF"),
    1595:m7Name + qsTr("ALARM_SERVO_MOTOR_POWEROFF"),

    1596:m0Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1597:m1Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1598:m2Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1599:m3Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1600:m4Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1601:m5Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1602:m6Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1603:m7Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),

    1596:m0Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1597:m1Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1598:m2Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1599:m3Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1600:m4Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1601:m5Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1602:m6Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),
    1603:m7Name + qsTr("ALARM_SERVO_DRIVE_OVERHEAT"),

    1604:m0Name + qsTr("ALARM_SERVO_DRIVE_ACCESS"),
    1605:m1Name + qsTr("ALARM_SERVO_DRIVE_ACCESS"),
    1606:m2Name + qsTr("ALARM_SERVO_DRIVE_ACCESS"),
    1607:m3Name + qsTr("ALARM_SERVO_DRIVE_ACCESS"),
    1608:m4Name + qsTr("ALARM_SERVO_DRIVE_ACCESS"),
    1609:m5Name + qsTr("ALARM_SERVO_DRIVE_ACCESS"),
    1610:m6Name + qsTr("ALARM_SERVO_DRIVE_ACCESS"),
    1611:m7Name + qsTr("ALARM_SERVO_DRIVE_ACCESS"),

    1612:m0Name + qsTr("ALARM_SERVO_DRIVE_ACCESSABNORMA"),
    1613:m1Name + qsTr("ALARM_SERVO_DRIVE_ACCESSABNORMA"),
    1614:m2Name + qsTr("ALARM_SERVO_DRIVE_ACCESSABNORMA"),
    1615:m3Name + qsTr("ALARM_SERVO_DRIVE_ACCESSABNORMA"),
    1616:m4Name + qsTr("ALARM_SERVO_DRIVE_ACCESSABNORMA"),
    1617:m5Name + qsTr("ALARM_SERVO_DRIVE_ACCESSABNORMA"),
    1618:m6Name + qsTr("ALARM_SERVO_DRIVE_ACCESSABNORMA"),
    1619:m7Name + qsTr("ALARM_SERVO_DRIVE_ACCESSABNORMA"),

    1620:m0Name + qsTr("ALARM_SERVO_LOCKED_ROTOR"),
    1621:m1Name + qsTr("ALARM_SERVO_LOCKED_ROTOR"),
    1622:m2Name + qsTr("ALARM_SERVO_LOCKED_ROTOR"),
    1623:m3Name + qsTr("ALARM_SERVO_LOCKED_ROTOR"),
    1624:m4Name + qsTr("ALARM_SERVO_LOCKED_ROTOR"),
    1625:m5Name + qsTr("ALARM_SERVO_LOCKED_ROTOR"),
    1626:m6Name + qsTr("ALARM_SERVO_LOCKED_ROTOR"),
    1627:m7Name + qsTr("ALARM_SERVO_LOCKED_ROTOR"),

    1628:m0Name + qsTr("ALARM_SERVO_SERVO_ENCODER"),
    1629:m1Name + qsTr("ALARM_SERVO_SERVO_ENCODER"),
    1630:m2Name + qsTr("ALARM_SERVO_SERVO_ENCODER"),
    1631:m3Name + qsTr("ALARM_SERVO_SERVO_ENCODER"),
    1632:m4Name + qsTr("ALARM_SERVO_SERVO_ENCODER"),
    1633:m5Name + qsTr("ALARM_SERVO_SERVO_ENCODER"),
    1634:m6Name + qsTr("ALARM_SERVO_SERVO_ENCODER"),
    1635:m7Name + qsTr("ALARM_SERVO_SERVO_ENCODER"),

    1636:m0Name + qsTr("ALARM_SERVO_MOTOR_OVERSPEED"),
    1637:m1Name + qsTr("ALARM_SERVO_MOTOR_OVERSPEED"),
    1638:m2Name + qsTr("ALARM_SERVO_MOTOR_OVERSPEED"),
    1639:m3Name + qsTr("ALARM_SERVO_MOTOR_OVERSPEED"),
    1640:m4Name + qsTr("ALARM_SERVO_MOTOR_OVERSPEED"),
    1641:m5Name + qsTr("ALARM_SERVO_MOTOR_OVERSPEED"),
    1642:m6Name + qsTr("ALARM_SERVO_MOTOR_OVERSPEED"),
    1643:m7Name + qsTr("ALARM_SERVO_MOTOR_OVERSPEED"),

    1644:m0Name + qsTr("ALARM_SERVO_SERVO_POSERROR"),
    1645:m1Name + qsTr("ALARM_SERVO_SERVO_POSERROR"),
    1646:m2Name + qsTr("ALARM_SERVO_SERVO_POSERROR"),
    1647:m3Name + qsTr("ALARM_SERVO_SERVO_POSERROR"),
    1648:m4Name + qsTr("ALARM_SERVO_SERVO_POSERROR"),
    1649:m5Name + qsTr("ALARM_SERVO_SERVO_POSERROR"),
    1650:m6Name + qsTr("ALARM_SERVO_SERVO_POSERROR"),
    1651:m7Name + qsTr("ALARM_SERVO_SERVO_POSERROR"),

    1652:m0Name + qsTr("ALARM_SERVO_DRIVE_PULSE"),
    1653:m1Name + qsTr("ALARM_SERVO_DRIVE_PULSE"),
    1654:m2Name + qsTr("ALARM_SERVO_DRIVE_PULSE"),
    1655:m3Name + qsTr("ALARM_SERVO_DRIVE_PULSE"),
    1656:m4Name + qsTr("ALARM_SERVO_DRIVE_PULSE"),
    1657:m5Name + qsTr("ALARM_SERVO_DRIVE_PULSE"),
    1658:m6Name + qsTr("ALARM_SERVO_DRIVE_PULSE"),
    1659:m7Name + qsTr("ALARM_SERVO_DRIVE_PULSE"),

    1660:m0Name + qsTr("ALARM_SERVO_HEARTBEAT"),
    1661:m1Name + qsTr("ALARM_SERVO_HEARTBEAT"),
    1662:m2Name + qsTr("ALARM_SERVO_HEARTBEAT"),
    1663:m3Name + qsTr("ALARM_SERVO_HEARTBEAT"),
    1664:m4Name + qsTr("ALARM_SERVO_HEARTBEAT"),
    1665:m5Name + qsTr("ALARM_SERVO_HEARTBEAT"),
    1666:m6Name + qsTr("ALARM_SERVO_HEARTBEAT"),
    1667:m7Name + qsTr("ALARM_SERVO_HEARTBEAT"),

    1668:m0Name + qsTr("ALARM_SERVO_PDO_LENGTH"),
    1669:m1Name + qsTr("ALARM_SERVO_PDO_LENGTH"),
    1670:m2Name + qsTr("ALARM_SERVO_PDO_LENGTH"),
    1671:m3Name + qsTr("ALARM_SERVO_PDO_LENGTH"),
    1672:m4Name + qsTr("ALARM_SERVO_PDO_LENGTH"),
    1673:m5Name + qsTr("ALARM_SERVO_PDO_LENGTH"),
    1674:m6Name + qsTr("ALARM_SERVO_PDO_LENGTH"),
    1675:m7Name + qsTr("ALARM_SERVO_PDO_LENGTH"),

    1676:m0Name + qsTr("ALARM_SERVO_RE_LIMIT"),
    1677:m1Name + qsTr("ALARM_SERVO_RE_LIMIT"),
    1678:m2Name + qsTr("ALARM_SERVO_RE_LIMIT"),
    1679:m3Name + qsTr("ALARM_SERVO_RE_LIMIT"),
    1680:m4Name + qsTr("ALARM_SERVO_RE_LIMIT"),
    1681:m5Name + qsTr("ALARM_SERVO_RE_LIMIT"),
    1682:m6Name + qsTr("ALARM_SERVO_RE_LIMIT"),
    1683:m7Name + qsTr("ALARM_SERVO_RE_LIMIT"),

    1684:m0Name + qsTr("ALARM_SERVO_FAULT"),
    1685:m1Name + qsTr("ALARM_SERVO_FAULT"),
    1686:m2Name + qsTr("ALARM_SERVO_FAULT"),
    1687:m3Name + qsTr("ALARM_SERVO_FAULT"),
    1688:m4Name + qsTr("ALARM_SERVO_FAULT"),
    1689:m5Name + qsTr("ALARM_SERVO_FAULT"),
    1690:m6Name + qsTr("ALARM_SERVO_FAULT"),
    1691:m7Name + qsTr("ALARM_SERVO_FAULT"),

    1692:qsTr("ALARM_VENDER_UNLIKE"),
    1693:qsTr("ALARM_CTRLTYPE_UNLIKE"),
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
