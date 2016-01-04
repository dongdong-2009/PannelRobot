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
    UserInfo.informUserChangeEvent();
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
