.pragma library
Qt.include("../../utils/HashTable.js")

var kTPHelper = 0;
var kTP_LINE_START_POINT = kTPHelper++;    //< 直线起点位置
var kTP_LINE_END_POINT   = kTPHelper++;    //< 直线终点位置
var kTP_AUTO_START_POINT = kTPHelper++;    //< 关节坐标起点位置
var kTP_AUTO_END_POINT = kTPHelper++;      //< 关节坐标终点位置
var kTP_RELATIVE_LINE_START_POINT = kTPHelper++;  //< 直线相对移动位置
var kTP_RELATIVE_AUTO_END_POINT = kTPHelper++;     //< 关节坐标相对移动位置
var kTP_TEACH_LINE_START_POINT = kTPHelper++;   //< 直线起点位置
var kTP_TEACH_LINE_END_POINT = kTPHelper++;     //< 直线终点位置
var kTP_TEACH_AUTO_START_POINT = kTPHelper++;   //< 关节坐标起点位置
var kTP_TEACH_AUTO_END_POINT = kTPHelper++;     //< 关节坐标终点位置
var kTP_TEACH_RELATIVE_LINE_START_POINT= kTPHelper++;   //< 直线相对移动位置
var kTP_TEACH_RELATIVE_AUTO_END_POINT= kTPHelper++;     //< 关节坐标相对移动位置
kTPHelper = 30;
var kTP_ARC_START_POINT = kTPHelper++;   //< 弧线起点位置
var kTP_ARC_MID_POINT = kTPHelper++;     //< 弧线中间点位置
var kTP_ARC_END_POINT = kTPHelper++;     //< 弧线终点位置
var kTP_TEACH_ARC_START_POINT = kTPHelper++; //< 弧线起点位置
var kTP_TEACH_ARC_MID_POINT = kTPHelper++;      //< 弧线中间点位置
var kTP_TEACH_ARC_END_POINT = kTPHelper++;      //< 弧线终点位置


var kAM_SINGLE_STEP_MODE = 1;
var kAM_SINGLE_STEP_START = 2;
var kAM_SINGLE_CYCLE_MODE = 3;
var kAM_SINGLE_CYCLE_START = 4;

var COMBINE_ARM_MOVE_TYPE = 30;
var SINGLE_ARM_MOVE_TYPE = 0;

var cmdHelper = 0;

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

var modeToText = {
    7:qsTr("Running"),
    8:qsTr("Single"),
    9:qsTr("One Cycle")
}

cmdHelper = 0x0050;
var CMD_MANUAL_STOP = cmdHelper++;  // 手动运行停止
var CMD_MANUAL_START1        = cmdHelper++;  // 手动运行主程序
var CMD_MANUAL_START2        = cmdHelper++;  // 手动运行子程序1
var CMD_MANUAL_START3        = cmdHelper++;  // 手动运行子程序2
var CMD_MANUAL_START4        = cmdHelper++;  // 手动运行子程序3
var CMD_MANUAL_START5        = cmdHelper++;  // 手动运行子程序4
var CMD_MANUAL_START6        = cmdHelper++;  // 手动运行子程序5
var CMD_MANUAL_START7        = cmdHelper++;  // 手动运行子程序6
var CMD_MANUAL_START8        = cmdHelper++;  // 手动运行子程序7
var CMD_MANUAL_START9        = cmdHelper++;  // 手动运行子程序8
var CMD_MANUAL_START10        = cmdHelper++;  // 手动运行程序9
var CMD_MANUAL_START11        = cmdHelper++;  // 手动运行程序10
var CMD_MANUAL_START12        = cmdHelper++;  // 手动运行程序11
var CMD_MANUAL_START13        = cmdHelper++;  // 手动运行程序12
var CMD_MANUAL_START14        = cmdHelper++;  // 手动运行程序13
var CMD_MANUAL_START15        = cmdHelper++;  // 手动运行程序14
var CMD_MANUAL_START16        = cmdHelper++;  // 手动运行程序15
var CMD_MANUAL_START17        = cmdHelper++;  // 手动运行程序16
var CMD_MANUAL_START18        = cmdHelper++;  // 手动运行程序17
var CMD_MANUAL_START19        = cmdHelper++;  // 手动运行程序18
var CMD_MANUAL_START20        = cmdHelper++;  // 手动运行程序19

var CMD_POWER_OFF0 = 0x0100;	// 第一个逻辑电机关闭
var CMD_POWER_OFF  = 0x017F;	// 所有逻辑电机关闭
var CMD_POWER_ON0  = 0x0180;	// 第一个逻辑电机开机
var CMD_POWER_ON  = 0x01FF;	// 所有逻辑电机开机

var CMD_WHEEL_JOG_P0     = 0x0200;  // 手轮正转
var CMD_WHEEL_JOG_N0     = 0x0201;          // 手轮反转

var CMD_JOG_PX     = 0x0300;	// 直角坐标系位置轴，X轴正向点动
var CMD_JOG_PY     = 0x0301;	// 直角坐标系位置轴，Y轴正向点动
var CMD_JOG_PZ     = 0x0302;	// 直角坐标系位置轴，Z轴正向点动
var CMD_JOG_PU     = 0x0303;	// 直角坐标系姿势轴，X轴正向点动
var CMD_JOG_PV     = 0x0304;	// 直角坐标系姿势轴，X轴正向点动
var CMD_JOG_PW     = 0x0305;	// 直角坐标系姿势轴，X轴正向点动
var CMD_JOG_PR     = 0x0306;  // 直角坐标系姿势轴，R轴正向点动
var CMD_JOG_PT     = 0x0307;  // 直角坐标系姿势轴，T轴正向点动

var CMD_TEST_CLEAR      = 0x034f;  // 清除当前所有测试脉冲
var CMD_TEST_JOG_PX     = 0x0350;  // 测试X轴正向运动
var CMD_TEST_JOG_PY     = 0x0351;  // 测试Y轴正向运动
var CMD_TEST_JOG_PZ     = 0x0352;  // 测试Z轴正向运动
var CMD_TEST_JOG_PU     = 0x0353;  // 测试U轴正向运动
var CMD_TEST_JOG_PV     = 0x0354;  // 测试V轴正向运动
var CMD_TEST_JOG_PW     = 0x0355;  // 测试W轴正向运动
var CMD_TEST_JOG_NX     = 0x0360;  // 测试X轴反向运动
var CMD_TEST_JOG_NY     = 0x0361;  // 测试Y轴反向运动
var CMD_TEST_JOG_NZ     = 0x0362;  // 测试Z轴反向运动
var CMD_TEST_JOG_NU     = 0x0363;  // 测试U轴反向运动
var CMD_TEST_JOG_NV     = 0x0364;  // 测试V轴反向运动
var CMD_TEST_JOG_NW     = 0x0365;  // 测试W轴反向运动

var CMD_JOG_NX     = 0x0380;	// 直角坐标系位置轴，X轴反向点动
var CMD_JOG_NY     = 0x0381;	// 直角坐标系位置轴，Y轴反向点动
var CMD_JOG_NZ     = 0x0382;	// 直角坐标系位置轴，Z轴反向点动
var CMD_JOG_NU     = 0x0383;	// 直角坐标系姿势轴，X轴反向点动
var CMD_JOG_NV     = 0x0384;	// 直角坐标系姿势轴，X轴反向点动
var CMD_JOG_NW     = 0x0385;	// 直角坐标系姿势轴，X轴反向点动
var CMD_JOG_NR     = 0x0386;  // 直角坐标系姿势轴，R轴正向点动
var CMD_JOG_NT     = 0x0387;  // 直角坐标系姿势轴，T轴正向点动

var CMD_FIND_ZERO0 = 0x0400;	// 第一个逻辑轴，找零
var CMD_SET_ZERO0  = 0x0410;  // X轴原点设定
var CMD_SET_ZERO1  = 0x0411;  // y轴原点设定
var CMD_SET_ZERO2  = 0x0412;  // z轴原点设定
var CMD_SET_ZERO3  = 0x0413;  // u轴原点设定
var CMD_SET_ZERO4  = 0x0414;  // v轴原点设定
var CMD_SET_ZERO5  = 0x0415;  // w轴原点设定
var CMD_SET_ZERO   = 0x0416;  // 全部轴原点设定
var CMD_REM_POS    = 0x0417;  // 保存每个轴当前位置
var CMD_FIND_ZERO  = 0x047F;	// 所有逻辑轴，同时找零

var CMD_GO_HOME0   = 0x0500;	// 第一个逻辑轴，回零点
var CMD_GO_HOME    = 0x057F;	// 所有逻辑轴，同时回零点

var CMD_STOP0      = 0x0600;	// 立即停止第一个逻辑轴相关的运动- 回零、找零等
var CMD_STOP       = 0x067F;	// 立即停止所有逻辑轴的运动- 回零、找零等
var CMD_SLOW_STOP0 = 0x0680;	// 减速停止第一个逻辑轴相关的运动- 回零、找零等
var CMD_SLOW_STOP  = 0x06FF;	// 减速停止所有逻辑轴的运动- 回零、找零等

var CMD_RUN_LENGTH_P0 = 0x0700;	// 第一个逻辑轴-运行正向测试脉冲，带一个参数- 正脉冲数
var CMD_RUN_LENGTH_N0 = 0x0780;	// 第一个逻辑轴-运行反向测试脉冲，带一个参数- 正脉冲数

var CMD_IO_OUT_P0  = 0x0800;	// 第一个IO端口输出高
var CMD_IO_OUT_N0  = 0x0900;    // 第一个IO端口输出低

var CMD_KEY_RUN      = 0x0A00; //< 启动命令
var CMD_KEY_STOP     = 0x0A01; //< 停止命令
var CMD_KEY_ORIGIN   = 0x0A02; //< 原点命令
var CMD_KEY_RETURN   = 0x0A03; //< 复归命令
var CMD_KEY_UP       = 0x0A04; //< 上命令
var CMD_KEY_DOWN     = 0x0A05; //< 下命令
var CMD_KEY_CONTINUE = 0x0A06; //< 清除报警后继续运行

var CMD_INVALID = 0x7FFF;

var KEY_F1 = parseInt(Qt.Key_C);
var KEY_F2 = parseInt(Qt.Key_W);
var KEY_F3 = parseInt(0x52);
var KEY_F4 = parseInt(Qt.Key_M);
var KEY_F5 = parseInt(0x48);


var KEY_X1Sub = parseInt(Qt.Key_F9);
var KEY_X1Add = parseInt(Qt.Key_U);
var KEY_Y1Sub = parseInt(Qt.Key_Z);
var KEY_Y1Add = parseInt(Qt.Key_V);
var KEY_ZSub  = parseInt(Qt.Key_B);
var KEY_ZAdd  = parseInt(Qt.Key_A);
var KEY_X2Sub = parseInt(Qt.Key_Q);
var KEY_X2Add = parseInt(Qt.Key_K);
var KEY_Y2Sub = parseInt(Qt.Key_P);
var KEY_Y2Add = parseInt(Qt.Key_L);
var KEY_CSub  = parseInt(Qt.Key_G);
var KEY_CAdd  = parseInt(Qt.Key_F);

var KEY_Run   = parseInt(Qt.Key_F11);
var KEY_Stop  = parseInt(Qt.Key_X);
var KEY_Origin = parseInt(Qt.Key_S);
var KEY_Return = parseInt(Qt.Key_D);
var KEY_Up    = parseInt(Qt.Key_I);
var KEY_Down  = parseInt(Qt.Key_N);

var KNOB_MANUAL= parseInt(0x01000033); //F4
var KNOB_SETTINGS = parseInt(0x01000036); //F7
var KNOB_AUTO = parseInt(0x01000034); //F5

var PULLY_UP = parseInt(0x0100003C); //F13
var PULLY_DW = parseInt(0x0100003D); //F14

var Menu_Type = 0;
var Axis_Type = 1;
var Command_Type = 2;
var Nomal_Type = 3;
var Continuous_Type = 4;

function KeyStruct(keyVal, actionVal, isPressed, keyType){
    this.keyVal = keyVal;
    this.actionVal = actionVal;
    this.isPressed = isPressed;
    if(keyType == undefined)
        keyType = Command_Type;
    this.keyType = keyType;
}

var keyStructs = new HashTable();
keyStructs.put(KEY_X1Sub, new KeyStruct(KEY_X1Sub, CMD_JOG_NX, false, Axis_Type));
keyStructs.put(KEY_X1Add, new KeyStruct(KEY_X1Add, CMD_JOG_PX, false, Axis_Type));
keyStructs.put(KEY_Y1Sub, new KeyStruct(KEY_Y1Sub, CMD_JOG_NY, false, Axis_Type));
keyStructs.put(KEY_Y1Add, new KeyStruct(KEY_Y1Add, CMD_JOG_PY, false, Axis_Type));
keyStructs.put(KEY_ZSub,  new KeyStruct(KEY_ZSub,  CMD_JOG_NZ, false, Axis_Type));
keyStructs.put(KEY_ZAdd,  new KeyStruct(KEY_ZAdd,  CMD_JOG_PZ, false, Axis_Type));
keyStructs.put(KEY_X2Sub, new KeyStruct(KEY_X2Sub, CMD_JOG_NU, false, Axis_Type));
keyStructs.put(KEY_X2Add, new KeyStruct(KEY_X2Add, CMD_JOG_PU, false, Axis_Type));
keyStructs.put(KEY_Y2Sub, new KeyStruct(KEY_Y2Sub, CMD_JOG_NV, false, Axis_Type));
keyStructs.put(KEY_Y2Add, new KeyStruct(KEY_Y2Add, CMD_JOG_PV, false, Axis_Type));
keyStructs.put(KEY_CSub,  new KeyStruct(KEY_CSub,  CMD_JOG_NW, false, Axis_Type));
keyStructs.put(KEY_CAdd,  new KeyStruct(KEY_CAdd,  CMD_JOG_PW, false, Axis_Type));
keyStructs.put(KEY_Run, new KeyStruct(KEY_Run      , CMD_KEY_RUN    , false, Command_Type));
keyStructs.put(KEY_Stop, new KeyStruct(KEY_Stop    , CMD_KEY_STOP   , false, Command_Type));
keyStructs.put(KEY_Origin, new KeyStruct(KEY_Origin, CMD_KEY_ORIGIN , false, Command_Type));
keyStructs.put(KEY_Return, new KeyStruct(KEY_Return, CMD_KEY_RETURN , false, Command_Type));
keyStructs.put(KEY_Up, new KeyStruct(KEY_Up        , CMD_KEY_UP     , false, Continuous_Type));
keyStructs.put(KEY_Down, new KeyStruct(KEY_Down    , CMD_KEY_DOWN   , false, Continuous_Type));
keyStructs.put(KNOB_AUTO, new KeyStruct(KNOB_AUTO    , CMD_AUTO   , false, Command_Type));
keyStructs.put(KNOB_SETTINGS, new KeyStruct(KNOB_SETTINGS    , CMD_CONFIG   , false, Command_Type));
keyStructs.put(KNOB_MANUAL, new KeyStruct(KNOB_MANUAL    , CMD_MANUAL   , false, Command_Type));


keyStructs.put(KEY_F1, new KeyStruct(KEY_F1, 0, false, Menu_Type));
keyStructs.put(KEY_F2, new KeyStruct(KEY_F2, 0, false, Menu_Type));
keyStructs.put(KEY_F3, new KeyStruct(KEY_F3, 0, false, Menu_Type));
keyStructs.put(KEY_F4, new KeyStruct(KEY_F4, 0, false, Menu_Type));
keyStructs.put(KEY_F5, new KeyStruct(KEY_F5, 0, false, Menu_Type));
keyStructs.put(PULLY_UP, new KeyStruct(PULLY_UP, CMD_WHEEL_JOG_P0, false, Command_Type));
keyStructs.put(PULLY_DW, new KeyStruct(PULLY_DW, CMD_WHEEL_JOG_N0, false, Command_Type));
keyStructs.put(0x01000037, new KeyStruct(0x01000037, CMD_WHEEL_JOG_N0, false, Command_Type)); // for destop F8
keyStructs.put(0x01000039, new KeyStruct(0x01000039, CMD_WHEEL_JOG_P0, false, Command_Type)); // for destop F10

//keyStructs.put(KEY_Run, new KeyStruct(KEY_Run   , 0xC1, false, Command_Type));
//keyStructs.put(KEY_Stop, new KeyStruct(KEY_Stop  , 0xC2, false, Command_Type));
//keyStructs.put(KEY_Origin, new KeyStruct(KEY_Origin, 0xD8, false, Command_Type));
//keyStructs.put(KEY_Return, new KeyStruct(KEY_Return, 0xD9, false, Command_Type));
//keyStructs.put(KEY_Up, new KeyStruct(KEY_Up    , 0xC3, false, Command_Type));
//keyStructs.put(KEY_Down, new KeyStruct(KEY_Down  , 0xC4, false, Command_Type));
function setKeyPressed(key, isPressed){
    keyStructs.get(key).isPressed = isPressed;
}

function getKeyMappedAction(key){
    return keyStructs.get(key).actionVal;
}

function getKeyType(key){
    return keyStructs.get(key).keyType;
}

function isAxisKeyType(key){
    return getKeyType(key) === Axis_Type;
}

function isCommandKeyType(key){
    return getKeyType(key) === Command_Type;

}

function isContinuousType(key){
    return getKeyType(key) === Continuous_Type;
}

function isKeyPressed(key){
    return keyStructs.get(key).isPressed;
}


function pressedKeys(){
    var ret = [];
    var keys = keyStructs.keys;
    for( var i = 0; i < keys.length; ++i){
        if(isKeyPressed(keys[i]))
            ret[ret.length] = keys[i];
    }
    return ret;
}


var speedInfo = {"lastTime": new Date(), "changeCount":0};
function endSpeed(current, dir){
    var now = new Date();
    var delta = (now.getTime() - speedInfo.lastTime.getTime());
    speedInfo.lastTime = now;
    if(delta >= 100){
        speedInfo.changeCount = 0;
    }
    speedInfo.changeCount += 1;
    var ret = current + speedInfo.changeCount * 0.1 * dir;
    if(ret >= 200)
        ret = 200.0;
    if(ret <= 0.1)
        ret = 0.1;
    return ret;
}

function endSpeedCalcByTime(current, dir){
    var ret = current;
    if(speedInfo.changeCount === 0){
        speedInfo.changeCount = 1;
        ret += 0.1 * dir;
        speedInfo.lastTime = new Date();
    }else{
        var now = new Date();
        var delta = (now.getTime() - speedInfo.lastTime.getTime());
//        console.log(delta)
        ret = current + delta * 0.005 * dir;
    }
    if(ret >= 100)
        ret = 100.0;
    if(ret <= 0.1)
        ret = 0.1;
    return ret;
}

function endSpeedCaclByTimeStop(){
    speedInfo.changeCount = 0;
}

var hwtestSequence = [KEY_F5, KEY_F3, KEY_F4, KEY_F3, KEY_F2, KEY_F3, KEY_F1, KEY_F5];
var recalSequence = [KEY_F5, KEY_F1, KEY_F4, KEY_F1, KEY_F3, KEY_F1, KEY_F2, KEY_F5];
var currentKeySequence = [];

function matchSequenceHelper(sequence){
    if(currentKeySequence.length == sequence.length)
    {
        for(var i = 0, len = currentKeySequence.length; i < len; ++i){
            if(currentKeySequence[i] != sequence[i])
                return false;
        }
        return true;
    }
    return false;
}

function matchHWTestSequence(){
    return matchSequenceHelper(hwtestSequence);
}

function matchRecalSequence(){
    return matchSequenceHelper(recalSequence);
}
