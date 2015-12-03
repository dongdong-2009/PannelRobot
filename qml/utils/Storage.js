.pragma library

Qt.include("stringhelper.js")

var USERS_TB_INFO = {
    "tb_name":"users",
    "user_name_col":"name",
    "password_col": "password",
    "perm_col":"perm"
};

function AlarmItem(id, alarmNum, level, triggerTime, endTime){
    this.id = id;
    this.alarmNum = alarmNum;
    this.level = level;
    this.triggerTime = triggerTime;
    this.endTime = endTime;
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

//storage.js
// 首先创建一个helper方法连接数据库
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
                    var rs = tx.executeSql('SELECT * FROM users');
                    if (rs.rows.length === 0) {
                        tx.executeSql('INSERT INTO users VALUES("op", "123", 0)');
                        tx.executeSql('InSERT INTO users VALUES("admin", "123", 1)');
                        tx.executeSql('InSERT INTO users VALUES("super", "123456", 3)');
                        tx.executeSql('InSERT INTO users VALUES("root", "12345678", 7)');
                        tx.executeSql('InSERT INTO users VALUES("szhcroot", "szhcrobot", 15)');
                    }
                    else if(rs.rows.length > 0){
                        console.log("Database has been init!");
                    }
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
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).value;
        } else {
            res = "Unknown";
        }
    })
    return res
}

function appendAlarmToLog(alarmItem){
    var db = getDatabase();
//    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql(icStrformat('SELECT COUNT(*), MIN({0}) FROM {1};', ALARM_LOG_TB_INFO.id_col, ALARM_LOG_TB_INFO.tb_name));
//        console.log(rs.rows.item(0)["COUNT(*)"], rs.rows.item(0)["MAX(id)"]);
        var newID = rs.rows.item(0)["MIN(id)"] + 1;
        if(rs.rows.item(0)["COUNT(*)"] >= ALARM_LOG_TB_INFO.max){
            tx.executeSql(icStrformat('UPDATE {0} SET {1}={2}, {3}={4}, {5}={6}, {7}={8}, {9}={10} WHERE {1}={11}',
                                      ALARM_LOG_TB_INFO.tb_name, ALARM_LOG_TB_INFO.id_col, newID,
                                      ALARM_LOG_TB_INFO.alarm_num_col, alarmItem.alarmNum,
                                      ALARM_LOG_TB_INFO.level_col, alarmItem.level,
                                      ALARM_LOG_TB_INFO.triggerTime_col, Date.now().getTime(),
                                      ALARM_LOG_TB_INFO.endTime_col, ""));
        }else{
//            tx.executeSql(icStrformat());
        }

//        for(var o in rs.rows.item(0)){
//            console.log(o);
//        }

//        if (rs.rows.length > 0) {
//            res = rs.rows.item(0).value;
//        } else {
//            res = "Unknown";
//        }
    })
//    return res
}
