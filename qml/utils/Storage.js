.pragma library

Qt.include("stringhelper.js")

var USERS_TB_INFO = {
    "tb_name":"users",
    "user_name_col":"name",
    "password_col": "password",
    "perm_col":"perm"
};

function AlarmItem(id, alarmNum, level, triggerTime, endTime){
    var now = new Date();
    this.id = id;
    this.alarmNum = alarmNum;
    this.level = level || 0;
    this.triggerTime = triggerTime || now.getTime();
    this.endTime = endTime || "";
}

function OperationLogItem(id, opTime, user, descr){
    this.id = id;
    this.opTime = opTime;
    this.user = user;
    this.descr = descr;
}

var ALARM_LOG_TB_INFO = {
    "max":500,
    "tb_name":"alarmlog",
    "id_col":"id",
    "alarm_num_col":"alarmNum",
    "level_col":"level",
    "triggerTime_col":"triggerTime",
    "endTime_col":"endTime"
};

var OPERATION_LOG_TB_INFO = {
    "max":500,
    "tb_name":"oplog",
    "id_col":"id",
    "opTime_col":"opTime",
    "user_col":"user",
    "descr_col":"descr"
}

//storage.js
// 首先创建一个helper方法连接数据库
var isDbInit = false;
function getDatabase() {
    return openDatabaseSync("PanelRobotCustomDB", "1.0", "StorageDatabase", 100000);
}

// 程序打开时，初始化表
function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    // 如果setting表不存在，则创建一个
                    // 如果表存在，则跳过此步
                    tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS users(name TEXT UNIQUE, password TEXT  NOT NULL, perm INTEGER NOT NULL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS alarmlog(id PK INTEGER NOT NULL, alarmNum INTEGER NOT NULL, level INTEGER NOT NULL, triggerTime INTEGER NOT NULL, endTime INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS oplog(id PK INTEGER NOT NULL, opTime INTEGER NOT NULL, user TEXT NOT NULL, descr TEXT NOT NULL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS manualprogram(id PK INTEGER NOT NULL, name TEXT  NOT NULL, program TEXT  NOT NULL)');
//                    tx.executeSql('CREATE TABLE IF NOT EXISTS globalstack(id PK INTEGER NOT NULL,stack TEXT NOT NULL)');
//                    tx.executeSql('CREATE TABLE IF NOT EXISTS globalcounter(id PK INTEGER NOT NULL,)')
                    //                    tx.executeSql('DELETE FROM alarmlog;');
                    var rs = tx.executeSql('SELECT * FROM users');
                    if (rs.rows.length === 0) {
                        tx.executeSql('INSERT INTO users VALUES("操作员", "123", 0)');
                        tx.executeSql('InSERT INTO users VALUES("管理员", "123", 1)');
                        tx.executeSql('InSERT INTO users VALUES("高级管理员", "123456", 3)');
                        tx.executeSql('InSERT INTO users VALUES("超级管理员", "12345678", 7)');
                        tx.executeSql('InSERT INTO users VALUES("szhcroot", "szhcrobot", 15)');
                    }
                    else if(rs.rows.length > 0){
                        console.log("Database has been init!");
                    }
                    isDbInit = true;
                });
}

// 插入数据
function setSetting(setting, value) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
        //console.log(rs.rowsAffected)
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    }
    );
    return res;
}

// 获取数据
function getSetting(setting) {
    if(!isDbInit) initialize();
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).value;
        } else {
            res = "";
        }
    })
    return res
}

function appendAlarmToLog(alarmItem){
    var db = getDatabase();
    db.transaction(function(tx) {
        var now = new Date();
        var rs = tx.executeSql(icStrformat('SELECT COUNT(*), MIN({0}), MAX({0}) FROM {1};', ALARM_LOG_TB_INFO.id_col, ALARM_LOG_TB_INFO.tb_name));
        var newID = parseInt(rs.rows.item(0)["MAX(id)"]) + 1;
        var minID = parseInt(rs.rows.item(0)["MIN(id)"]);
        var rowCount = parseInt(rs.rows.item(0)["COUNT(*)"]);
        if(rowCount === 0){
            newID = 0;
            minID = 0;
        }
        if(rowCount >= ALARM_LOG_TB_INFO.max){
            tx.executeSql(icStrformat('UPDATE {0} SET {1}={2}, {3}={4}, {5}={6}, {7}={8}, {9}={10} WHERE {1}={11}',
                                      ALARM_LOG_TB_INFO.tb_name, ALARM_LOG_TB_INFO.id_col, newID,
                                      ALARM_LOG_TB_INFO.alarm_num_col, alarmItem.alarmNum,
                                      ALARM_LOG_TB_INFO.level_col, alarmItem.level,
                                      ALARM_LOG_TB_INFO.triggerTime_col, now.getTime(),
                                      ALARM_LOG_TB_INFO.endTime_col, "\"\"", minID));
        }else{
//            console.log("<500", newID, minID, rowCount);
            var toexec = icStrformat('INSERT INTO {0} VALUES({1}, {2}, {3}, {4}, {5});',
                                     ALARM_LOG_TB_INFO.tb_name, newID, alarmItem.alarmNum,
                                     alarmItem.level, now.getTime(), "\"\"");
            tx.executeSql(toexec);
        }
        alarmItem.id = newID;
    });
    return alarmItem;
}

function alarmlog(){
    if(!isDbInit) initialize();

    var db = getDatabase();
//    var res="";
    var ret = [];
    db.transaction(function(tx) {
        var rs = tx.executeSql(icStrformat('SELECT * FROM {0} ORDER BY {1} DESC;',
                                           ALARM_LOG_TB_INFO.tb_name, ALARM_LOG_TB_INFO.id_col));
        var rowItem;
        for(var i = 0, len = rs.rows.length; i < len; ++i){
            rowItem = rs.rows.item(i);
            ret.push(new AlarmItem(rowItem[ALARM_LOG_TB_INFO.id_col],
                                   rowItem[ALARM_LOG_TB_INFO.alarm_num_col],
                                   rowItem[ALARM_LOG_TB_INFO.level_col],
                                   rowItem[ALARM_LOG_TB_INFO.triggerTime_col],
                                   rowItem[ALARM_LOG_TB_INFO.endTime_col]));
        }
    });
    return ret;
}

function updateAlarmLog(alarmItem){
    var db = getDatabase();
    db.transaction(function(tx) {
        tx.executeSql(icStrformat('UPDATE {0} SET {1}={2}, {3}={4}, {5}={6}, {7}={8}, {9}={10} WHERE {1}={11}',
                                  ALARM_LOG_TB_INFO.tb_name, ALARM_LOG_TB_INFO.id_col, alarmItem.id,
                                  ALARM_LOG_TB_INFO.alarm_num_col, alarmItem.alarmNum,
                                  ALARM_LOG_TB_INFO.level_col, alarmItem.level,
                                  ALARM_LOG_TB_INFO.triggerTime_col, alarmItem.triggerTime,
                                  ALARM_LOG_TB_INFO.endTime_col, alarmItem.endTime, alarmItem.id));
    });
}

function appendOpToLog(opItem){
    var db = getDatabase();
    db.transaction(function(tx) {
        var now = new Date();
        var rs = tx.executeSql(icStrformat('SELECT COUNT(*), MIN({0}), MAX({0}) FROM {1};', OPERATION_LOG_TB_INFO.id_col, OPERATION_LOG_TB_INFO.tb_name));
        var newID = parseInt(rs.rows.item(0)["MAX(id)"]) + 1;
        var minID = parseInt(rs.rows.item(0)["MIN(id)"]);
        var rowCount = parseInt(rs.rows.item(0)["COUNT(*)"]);
        if(rowCount === 0){
            newID = 0;
            minID = 0;
        }

        if(rowCount >= OPERATION_LOG_TB_INFO.max){
            var cmd = icStrformat('UPDATE {0} SET {1}={2}, {3}={4}, {5}="{6}", {7}="{8}" WHERE {1}={9}',
                                  OPERATION_LOG_TB_INFO.tb_name, OPERATION_LOG_TB_INFO.id_col, newID,
                                  OPERATION_LOG_TB_INFO.opTime_col, now.getTime(),
                                  OPERATION_LOG_TB_INFO.user_col, opItem.user,
                                  OPERATION_LOG_TB_INFO.descr_col, opItem.descr, minID);
            tx.executeSql(cmd);
        }else{
            var toexec = icStrformat('INSERT INTO {0} VALUES({1}, {2}, "{3}", "{4}");',
                                     OPERATION_LOG_TB_INFO.tb_name, newID, now.getTime(),
                                     opItem.user, opItem.descr);
            tx.executeSql(toexec);
        }
        opItem.id = newID;
    });
    return opItem;
}

function oplog(){
    if(!isDbInit) initialize();

    var db = getDatabase();
    var ret = [];
    db.transaction(function(tx) {
        var rs = tx.executeSql(icStrformat('SELECT * FROM {0} ORDER BY {1} DESC;',
                                           OPERATION_LOG_TB_INFO.tb_name, OPERATION_LOG_TB_INFO.id_col));
        var rowItem;
        for(var i = 0, len = rs.rows.length; i < len; ++i){
            rowItem = rs.rows.item(i);
            ret.push(new OperationLogItem(rowItem[OPERATION_LOG_TB_INFO.id_col],
                                   rowItem[OPERATION_LOG_TB_INFO.opTime_col],
                                   rowItem[OPERATION_LOG_TB_INFO.user_col],
                                   rowItem[OPERATION_LOG_TB_INFO.descr_col]));
        }
    });
    return ret;
}

function updateOpLog(opItem){
    var db = getDatabase();
    db.transaction(function(tx) {
        tx.executeSql(icStrformat('UPDATE {0} SET {1}={2}, {3}={4}, {5}={6}, {7}={8} WHERE {1}={9}',
                                  OPERATION_LOG_TB_INFO.tb_name, OPERATION_LOG_TB_INFO.id_col, opItem.id,
                                  OPERATION_LOG_TB_INFO.opTime_col, opItem.opTime,
                                  OPERATION_LOG_TB_INFO.user_col, opItem.user,
                                  OPERATION_LOG_TB_INFO.descr_col, opItem.descr,
                                  opItem.id));
    });
}

function backup(){
    var db = getDatabase();
    var ret = "BEGIN TRANSACTION;";
    db.transaction(function(tx){
        var rs = tx.executeSql("SELECT * FROM sqlite_master");
        var rowItem;
        var dataRowItem;
        for(var i = 0, len = rs.rows.length; i < len; ++i){
            rowItem = rs.rows.item(i);
            if(rowItem.tbl_name == "sqlite_stat1" ||
                    rowItem.type != "table")
                continue;
            ret += "\nDROP TABLE " + rowItem.tbl_name + ";\n";
            ret += rowItem.sql + ";\n";
            var data = tx.executeSql("SELECT * FROM " + rowItem.tbl_name);
            for(var j = 0, dlen = data.rows.length; j < dlen; ++j){
                dataRowItem = data.rows.item(j);
                var values = "";
                for(var v in dataRowItem){
                    values += ",'" + dataRowItem[v] + "'";
                }
                values = values.substr(1);
                ret += icStrformat("INSERT INTO {0} VALUES({1});\n",rowItem.tbl_name, values);
            }
        }
    });
    ret += "COMMIT;"
    return ret;
}

function restore(sqlData){
    var db = getDatabase();
    db.transaction(function(tx){
        var sqlline = sqlData.split(";\n");
        for(var i = 0, len = sqlline.length; i < len; ++i){
            if(sqlline[i] == "BEGIN TRANSACTION" ||
                    sqlline[i] == "COMMIT;"){
                continue;
            }
            tx.executeSql(sqlline[i]);
        }

    });
}
