.pragma library
Qt.include("../../utils/HashTable.js")

var CMD_NULL = 0; //< 无命令
var CMD_MANUAL = 1; //< 手动命令
var CMD_AUTO = 2; //< 自动命令
var CMD_CONFIG = 3; //< 配置命令
var CMD_IO = 4; // IO命令

var CMD_POWER_OFF0 = 0x0100;	// 第一个逻辑电机关闭
var CMD_POWER_OFF  = 0x017F;	// 所有逻辑电机关闭
var CMD_POWER_ON0  = 0x0180;	// 第一个逻辑电机开机
var CMD_POWER_ON  = 0x01FF;	// 所有逻辑电机开机

var CMD_JOG_N0     = 0x0200;    // 关节坐标系，第一个轴反向点动
var CMD_JOG_P0     = 0x0280;	// 关节坐标系，第一个轴正向点动

var CMD_JOG_PX     = 0x0300;	// 直角坐标系位置轴，X轴正向点动
var CMD_JOG_PY     = 0x0301;	// 直角坐标系位置轴，Y轴正向点动
var CMD_JOG_PZ     = 0x0302;	// 直角坐标系位置轴，Z轴正向点动
var CMD_JOG_PU     = 0x0303;	// 直角坐标系姿势轴，X轴正向点动
var CMD_JOG_PV     = 0x0304;	// 直角坐标系姿势轴，X轴正向点动
var CMD_JOG_PW     = 0x0305;	// 直角坐标系姿势轴，X轴正向点动
var CMD_JOG_PR     = 0x0306;	// 极坐标系，远离原点点动

var CMD_MOVE_POINT = 0x0310;  // 直角坐标系内点到点直线运动
var CMD_MOVE_ARC   = 0x0330;  // 直角坐标系内圆弧线运动
var CMD_GET_COORDINATE= 0x0340;  // 记录当前坐标

var CMD_JOG_NX     = 0x0380;	// 直角坐标系位置轴，X轴反向点动
var CMD_JOG_NY     = 0x0381;	// 直角坐标系位置轴，Y轴反向点动
var CMD_JOG_NZ     = 0x0382;	// 直角坐标系位置轴，Z轴反向点动
var CMD_JOG_NU     = 0x0383;	// 直角坐标系姿势轴，X轴反向点动
var CMD_JOG_NV     = 0x0384;	// 直角坐标系姿势轴，X轴反向点动
var CMD_JOG_NW     = 0x0385;	// 直角坐标系姿势轴，X轴反向点动
var CMD_JOG_NR     = 0x0386;	// 极坐标系，靠近原点点动

var CMD_FIND_ZERO0 = 0x0400;	// 第一个逻辑轴，找零
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

var KNOB_MANUAL= parseInt(0x01000033);
var KNOB_STOP = parseInt(0x01000036);
var KNOB_AUTO = parseInt(0x01000034);

var Menu_Type = 0;
var Axis_Type = 1;
var Command_Type = 2;

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
keyStructs.put(KEY_Up, new KeyStruct(KEY_Up        , CMD_KEY_UP     , false, Command_Type));
keyStructs.put(KEY_Down, new KeyStruct(KEY_Down    , CMD_KEY_DOWN   , false, Command_Type));
keyStructs.put(KNOB_AUTO, new KeyStruct(KNOB_AUTO    , CMD_AUTO   , false, Command_Type));
keyStructs.put(KNOB_MANUAL, new KeyStruct(KNOB_MANUAL    , CMD_MANUAL   , false, Command_Type));
keyStructs.put(KNOB_STOP, new KeyStruct(KNOB_STOP    , CMD_MANUAL   , false, Command_Type));


//keyStructs.put(KEY_X1Sub, new KeyStruct(KEY_X1Sub, 0xCB, false, Axis_Type));
//keyStructs.put(KEY_X1Add, new KeyStruct(KEY_X1Add, 0xCC, false, Axis_Type));
//keyStructs.put(KEY_Y1Sub, new KeyStruct(KEY_Y1Sub, 0xCD, false, Axis_Type));
//keyStructs.put(KEY_Y1Add, new KeyStruct(KEY_Y1Add, 0xCE, false, Axis_Type));
//keyStructs.put(KEY_ZSub,  new KeyStruct(KEY_ZSub,  0xCF, false, Axis_Type));
//keyStructs.put(KEY_ZAdd,  new KeyStruct(KEY_ZAdd,  0xD1, false, Axis_Type));
//keyStructs.put(KEY_X2Sub, new KeyStruct(KEY_X2Sub, 0xD4, false, Axis_Type));
//keyStructs.put(KEY_X2Add, new KeyStruct(KEY_X2Add, 0xD5, false, Axis_Type));
//keyStructs.put(KEY_Y2Sub, new KeyStruct(KEY_Y2Sub, 0xD6, false, Axis_Type));
//keyStructs.put(KEY_Y2Add, new KeyStruct(KEY_Y2Add, 0xD7, false, Axis_Type));
//keyStructs.put(KEY_CSub,  new KeyStruct(KEY_CSub,  0xD2, false, Axis_Type));
//keyStructs.put(KEY_CAdd,  new KeyStruct(KEY_CAdd,  0xD3, false, Axis_Type));

keyStructs.put(KEY_F1, new KeyStruct(KEY_F1, 0, false, Menu_Type));
keyStructs.put(KEY_F2, new KeyStruct(KEY_F2, 0, false, Menu_Type));
keyStructs.put(KEY_F3, new KeyStruct(KEY_F3, 0, false, Menu_Type));
keyStructs.put(KEY_F4, new KeyStruct(KEY_F4, 0, false, Menu_Type));
keyStructs.put(KEY_F5, new KeyStruct(KEY_F5, 0, false, Menu_Type));
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
    return getKeyType(key) == Axis_Type;
}

function isCommandKeyType(key){
    return getKeyType(key) == Command_Type;

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
