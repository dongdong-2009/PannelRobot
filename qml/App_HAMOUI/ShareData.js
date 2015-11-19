.pragma library

Qt.include("configs/Keymap.js")
Qt.include("../utils/Storage.js")
Qt.include("../utils/stringhelper.js")

function UserInfo(){

}
UserInfo.permType = {
    "op":0,
    "admin":1,
    "super":2,
    "root":3
};
UserInfo.current = {
    "user":"",
    "perm":0
};
UserInfo.currentUser = function(){
    return UserInfo.current.user;
}
UserInfo.users = function(){
    var db = getDatabase();
    var users = [];
    db.transaction(function(tx){
        var rs = tx.executeSql(icStrformat('SELECT * FROM {0}',
                                           USERS_TB_INFO.tb_name));
        for(var i = 0; i < rs.rows.length; ++i){
            users.push(rs.rows.item(i)[USERS_TB_INFO.user_name_col]);
        }
    });
    return users;
}

UserInfo.loginUser = function(username, password){
    var db = getDatabase();
    var ret = false;
    db.transaction(function(tx){
        var rs = tx.executeSql(icStrformat('SELECT * FROM {0} WHERE {1} = "{2}"',
                                           USERS_TB_INFO.tb_name,
                                           USERS_TB_INFO.user_name_col,
                                           username));
        if(rs.rows.length > 0){
            if(rs.rows.item(0)[USERS_TB_INFO.password_col] === password){
                UserInfo.current.user = username;
                UserInfo.current.perm = rs.rows.item(0)[USERS_TB_INFO.perm_col];
                ret = true;
            }
        }
    });
    return ret;
}

UserInfo.logout = function(){
    UserInfo.current.user = "";
    UserInfo.current.perm = 0;
}

var knobStatus = KNOB_STOP;
