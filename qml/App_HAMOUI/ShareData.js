.pragma library

Qt.include("configs/Keymap.js")
Qt.include("../utils/Storage.js")
Qt.include("../utils/stringhelper.js")
Qt.include("../utils/utils.js")

var eventType = {
    "userChanged":"userChanged",
    "knobChanged":"knobChanged",
    "tuneGlobalSpeedEnChanged":"tuneGlobalSpeedEnChanged",
    "globalSpeedChanged":"globalSpeedChanged",
}

//var knobStatus = KNOB_STOP;

function GlobalStatusCenter(){}

GlobalStatusCenter.status = {
    "knobStatus":{"value":KNOB_MANUAL, "et":eventType.knobChanged},
    "tuneGlobalSpeedEn":{"value":false, "et":eventType.tuneGlobalSpeedEnChanged},
    "globalSpeed":{"value":0, "et":eventType.globalSpeedChanged}
};

GlobalStatusCenter.initEventObservers = function(){
    var ret = new Object;
    for(var st in GlobalStatusCenter.status){
        (function(status){
            GlobalStatusCenter["set" + upperFirst(status)] = function(v){
                GlobalStatusCenter.status[status].value = v;
                GlobalStatusCenter.informEventHelper(GlobalStatusCenter.status[status].et, v);
            }
            GlobalStatusCenter["get" + upperFirst(status)] = function(){
                return GlobalStatusCenter.status[status].value;

            }
        })(st);
    }

    var ets = [];
    for(var p in eventType){
        ret[p] = [];
        (function(et){
            GlobalStatusCenter["registe" + upperFirst(et) + "Event"] = function(obj){
                GlobalStatusCenter.registeEventHelper(et, obj);
            };
            GlobalStatusCenter["unregiste" + upperFirst(et) + "Event"] = function(obj){
                GlobalStatusCenter.unregisteEventHelper(et, obj);
            };
            GlobalStatusCenter["inform" + upperFirst(et) + "Event"] = function(v){
                GlobalStatusCenter.informEventHelper(et, v);
            }
        })(p);
    }
    return ret;
}
GlobalStatusCenter.eventObservers = GlobalStatusCenter.initEventObservers();

GlobalStatusCenter.registeEventHelper = function(et, obj){
    if(et in eventType){
        GlobalStatusCenter.eventObservers[et].push(obj);
    }
}

GlobalStatusCenter.unregisteEventHelper = function(et, obj){
    if(et in eventType){
        var obs = GlobalStatusCenter.eventObservers[et];
        for(var i = 0; i < obs.length; ++i){
            if(obs[i] == obj){
                obs.splice(i, 1);
                break;
            }
        }
    }
}

GlobalStatusCenter.informEventHelper = function (et, v){
    if(et in eventType){
        var obs = GlobalStatusCenter.eventObservers[et];
        for(var i = 0; i < obs.length; ++i){
            obs[i]["on" + upperFirst(eventType[et])](v);
        }
    }
}


function UserInfo(){

}
UserInfo.permType = {
    "op":0,
    "mold":1,
    "system":2,
    "user":4
};
UserInfo.current = {
    "user":"",
    "perm":0
};
UserInfo.currentUser = function(){
    return UserInfo.current.user;
}
UserInfo.currentHasMoldPerm = function(){
    return (UserInfo.current.perm & UserInfo.permType.mold) > 0;
}

UserInfo.users = function(){
    var db = getDatabase();
    var users = [];
    db.readTransaction(function(tx){
        var rs = tx.executeSql(icStrformat('SELECT * FROM {0}',
                                           USERS_TB_INFO.tb_name));
        for(var i = 0; i < rs.rows.length; ++i){
            users.push(rs.rows.item(i)[USERS_TB_INFO.user_name_col]);
        }
    });
    return users;
}

UserInfo.users_ = function(){
    var db = getDatabase();
    var usersmsg  = [];
    db.readTransaction(function(tx){
        var rs = tx.executeSql(icStrformat('SELECT * FROM {0}',
                                           USERS_TB_INFO.tb_name));
        for(var i = 0; i < rs.rows.length; ++i){
            usersmsg.push(rs.rows.item(i));
        }
    });
    return usersmsg;
}

UserInfo.addUser = function(username, password, perm){
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS users(name TEXT, password TEXT  NOT NULL, perm INTEGER NOT NULL)');
                    var rs = tx.executeSql('SELECT * FROM users');
                    var length = rs.rows.length
                    tx.executeSql('INSERT INTO users VALUES("'+username+'", "'+password+'", "'+perm+'")',
                                  [],
                                  function (tx, result) { alert('addsuccess'); },
                                  function (tx, error) { alert('unable to add: ' + error.message);
                                  });
                    rs = tx.executeSql('SELECT * FROM users');
                    if(rs.rows.length > length)
                        console.log('addsuccess');
                    else
                        console.log('unable to add');
                });
}

UserInfo.deleteUser = function(username){
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM users');
                    var length = rs.rows.length;
                    tx.executeSql('DELETE FROM users WHERE name = "'+username+'"',
                                  [],
                                  function (tx, result) { alert('already deleted'); },
                                  function (tx, error) { alert('unable to delete: ' + error.message);
                                  });
                    rs = tx.executeSql('SELECT * FROM users');
                    if(rs.rows.length < length)
                        console.log('already deleted');
                    else
                        console.log('unable to delete');
                });
}

UserInfo.userscount = function(){
    var buffer = UserInfo.users();
    return buffer.length;
}

UserInfo.loginUser = function(username, password){
    var db = getDatabase();
    var ret = false;
    db.readTransaction(function(tx){
        var rs = tx.executeSql(icStrformat('SELECT * FROM {0} WHERE {1} = "{2}"',
                                           USERS_TB_INFO.tb_name,
                                           USERS_TB_INFO.user_name_col,
                                           username));
        if(rs.rows.length > 0){
            if(rs.rows.item(0)[USERS_TB_INFO.password_col] === password){
                UserInfo.current.user = username;
                UserInfo.current.perm = rs.rows.item(0)[USERS_TB_INFO.perm_col];
                ret = true;
                UserInfo.informUserChangeEvent(UserInfo.current);
            }
        }
    });
    return ret;
}

UserInfo.logout = function(){
    UserInfo.current.user = "";
    UserInfo.current.perm = 0;
    UserInfo.informUserChangeEvent(UserInfo.current);
}

UserInfo.userChangeEventObservers = [];

UserInfo.registUserChangeEvent = function(obj){
    GlobalStatusCenter.registeEventHelper(eventType.userChanged, obj);
}

UserInfo.unregisteUserChangeEvent = function(obj){
    GlobalStatusCenter.unregisteEventHelper(eventType.userChanged, obj);
}

UserInfo.informUserChangeEvent = function(user){
    GlobalStatusCenter.informEventHelper(eventType.userChanged, user);
}
