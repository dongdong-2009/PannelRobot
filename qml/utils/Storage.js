.pragma library

var USERS_TB_INFO = {
    "tb_name":"users",
    "user_name_col":"name",
    "password_col": "password",
    "perm_col":"perm"
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
                    var rs = tx.executeSql('SELECT * FROM users');
                    if (rs.rows.length === 0) {
                        tx.executeSql('INSERT INTO users VALUES("op", "123", 0)');
                        tx.executeSql('InSERT INTO users VALUES("admin", "123", 1)');
//                        res = rs.rows.item(0).value;
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
