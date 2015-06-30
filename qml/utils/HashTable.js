.pragma library

function HashTable() {
    this.table = new Array(137);//用来保存键
    this.values=[];//用来保存值
    this.simpleHash = simpleHash;
    this.betterHash = betterHash;
    this.showDistro = showDistro;
    this.put = put;
    this.get = get;
    this.keys = [];
}
// 防碰撞，线性探测的put方法
function put(key, data) {
    //var pos = this.betterHash(key);
    this.keys[this.keys.length] = key;
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
