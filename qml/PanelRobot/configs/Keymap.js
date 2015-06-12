function HashTable() {
   this.table = new Array(137);//用来保存键
   this.values=[];//用来保存值
   this.simpleHash = simpleHash;
   this.betterHash = betterHash;
   this.showDistro = showDistro;
   this.put = put;
   this.get = get;
 }
 // 防碰撞，线性探测的put方法
 function put(key, data) {
   //var pos = this.betterHash(key);
   var pos=this.simpleHash(key);//会产生碰撞
   if (this.table[pos] == undefined) {
      this.table[pos] = key;
      this.values[pos] = data;
   }
   else {
      while (this.table[pos] != undefined) {
         pos++;
      }
      this.table[pos] = key;
      this.values[pos] = data;
   }
 }
 // 简单的散列函数
 function simpleHash(string) {
   var total = 0;
   for (var i = 0; i < string.length; ++i) {
      total += string.charCodeAt(i);
   }
   return total % this.table.length;
 }
 //更好的散列函数
 function betterHash(string) {
   var H = 37;
   var total = 0;
   for (var i = 0; i < string.length; ++i) {
      total += H * total + string.charCodeAt(i);
   }
   total = total % this.table.length;
   if (total < 0) {
      total += this.table.length-1;
   }
   return parseInt(total);
 }
 //显示散列表中的数据
 function showDistro() {
   var n = 0;
   for (var i = 0; i < this.table.length; ++i) {
      if (this.table[i] != undefined) {
         console.log(this.table[i] + ": " + this.values[i]);
      }
   }
 }
 //产生一个min到max的随机数
 function getRandomInt (min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
 }

 // 防碰撞，线性探测的get方法
 function get(key) {
   var hash = -1;
  // hash = this.betterHash(key);
     hash=this.simpleHash(key);
   if (hash > -1) {
      for (var i = hash; this.table[i] != undefined; i++) {
         if (this.table[i] == key) {
            return this.values[i];
         }
      }
   }
   return undefined;
 }


var KEY_F1 = parseInt(Qt.Key_C);
var KEY_F2 = parseInt(Qt.Key_W);
var KEY_F3 = parseInt(Qt.key_R);
var KEY_F4 = parseInt(Qt.Key_M);
var KEY_F5 = parseInt(Qt.key_H);


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
var KEY_Origin= parseInt(Qt.Key_S);
var KEY_Return= parseInt(Qt.Key_D);
var KEY_Up    = parseInt(Qt.Key_I)
var KEY_Down  = parseInt(Qt.Key_N)

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
keyStructs.put(KEY_X1Sub, new KeyStruct(KEY_X1Sub, 0xCB, false, Axis_Type));
keyStructs.put(KEY_X1Add, new KeyStruct(KEY_X1Add, 0xCC, false, Axis_Type));
keyStructs.put(KEY_Y1Sub, new KeyStruct(KEY_Y1Sub, 0xCD, false, Axis_Type));
keyStructs.put(KEY_Y1Add, new KeyStruct(KEY_Y1Add, 0xCE, false, Axis_Type));
keyStructs.put(KEY_ZSub,  new KeyStruct(KEY_ZSub,  0xCF, false, Axis_Type));
keyStructs.put(KEY_ZAdd,  new KeyStruct(KEY_ZAdd,  0xD1, false, Axis_Type));
keyStructs.put(KEY_X2Sub, new KeyStruct(KEY_X2Sub, 0xD4, false, Axis_Type));
keyStructs.put(KEY_X2Add, new KeyStruct(KEY_X2Add, 0xD5, false, Axis_Type));
keyStructs.put(KEY_Y2Sub, new KeyStruct(KEY_Y2Sub, 0xD6, false, Axis_Type));
keyStructs.put(KEY_Y2Add, new KeyStruct(KEY_Y2Add, 0xD7, false, Axis_Type));
keyStructs.put(KEY_CSub,  new KeyStruct(KEY_CSub,  0xD2, false, Axis_Type));
keyStructs.put(KEY_CAdd,  new KeyStruct(KEY_CAdd,  0xD3, false, Axis_Type));
keyStructs.put(KEY_F1, new KeyStruct(KEY_F1, 0, false, Menu_Type));
keyStructs.put(KEY_F2, new KeyStruct(KEY_F2, 0, false, Menu_Type));
keyStructs.put(KEY_F3, new KeyStruct(KEY_F3, 0, false, Menu_Type));
keyStructs.put(KEY_F4, new KeyStruct(KEY_F4, 0, false, Menu_Type));
keyStructs.put(KEY_F5, new KeyStruct(KEY_F5, 0, false, Menu_Type));
keyStructs.put(KEY_Run   , new KeyStruct(KEY_Run   , 0xC1, false, Menu_Type));
keyStructs.put(KEY_Stop  , new KeyStruct(KEY_Stop  , 0xC2, false, Menu_Type));
keyStructs.put(KEY_Origin, new KeyStruct(KEY_Origin, 0xD8, false, Menu_Type));
keyStructs.put(KEY_Return, new KeyStruct(KEY_Return, 0xD9, false, Menu_Type));
keyStructs.put(KEY_Up    , new KeyStruct(KEY_Up    , 0xC3, false, Menu_Type));
keyStructs.put(KEY_Down  , new KeyStruct(KEY_Down  , 0xC4, false, Menu_Type));
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

function isKeyPressed(key){
    return keyStructs.get(key).isPressed;
}
