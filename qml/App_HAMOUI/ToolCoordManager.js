.pragma library

Qt.include("../utils/Storage.js")
Qt.include("../utils/stringhelper.js")
Qt.include("../utils/utils.js")
function ToolCoordManager(){
    this.toolCoords = [];
//    this.monitors = [];
    var db = getDatabase();
    var toolCoords = this.toolCoords;
    var manager = this;
    db.transaction(function(tx){
        tx.executeSql('CREATE TABLE IF NOT EXISTS toolcoord(id PK INTEGER NOT NULL, name TEXT  NOT NULL, info TEXT  NOT NULL)');
    }
    );

    db.transaction(function(tx){
        var rs = tx.executeSql('SELECT * FROM toolcoord ORDER BY id ASC');
        var toolcoord ={};
        for(var i = 0; i < rs.rows.length; ++i){
            toolcoord = rs.rows.item(i);
            toolcoord.info = JSON.parse(toolcoord.info);
            toolCoords[toolcoord.id] = toolcoord;
        }
    });

    this.clear = function(){
        db.transaction(function(tx){
            tx.executeSql('DELETE FROM toolcoord');
        });
    }

    this.findUsableID = function(){
        for(var i=0;i<toolCoords.length;++i){
            if(toolCoords[i+1] == undefined)
                return i+1
        }
        return toolCoords.length+1;
    }

    this.getToolCoord = function(id){
        return toolCoords[id];
    }

    this.getToolCoordByName = function(name){
        var toGetID = getValueFromBrackets(name);
        return this.getToolCoord(toGetID);
    }

    this.toolCoordNameList = function(){
        var ret=[];
        var c;
        for(var i=0;i<toolCoords.length;++i)
        {
            c=toolCoords[i];
            if(c !== undefined)
                ret.push(icStrformat(qsTr("{0}:{1}"),c.id,c.name));
        }
        return ret;
    }

    this.toolCoordList = function(){
        var ret =[];
        var c;
        for(var i=0;i<toolCoords.length;++i){
            c= toolCoords[i];
            if(c !== undefined)
                ret.push(c);
        }
        return ret;
    }


    this.addToolCoord = function(name,info){
        var id = this.findUsableID()
        var toRet = [id,name];

        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat("INSERT INTO toolcoord VALUES({0},'{1}','{2}')",
                                               id,name,JSON.stringify(info)));
            if(rs.rowsAffected > 0){
                toolCoords[id] = {"id":id,"name":name,"info":info};
//                manager.informMonitor("onToolCoordAdded",toolCoords[id]);
            }
        });
        return toRet;
    }

    this.removeToolCoord = function(id){
        db.transaction(function(tx){
            var rs =tx.executeSql(icStrformat('DELETE FROM toolcoord WHERE id={0}',
                                              id));
            if(rs.rowsAffected > 0){
                toolCoords[id] = undefined;
//                manager.informMonitor("onToolCoordRemoved",id);
            }
        });
    }

    this.removeToolCoordByName = function(name){
        var toDelID = getValueFromBrackets(name);
        this.removeToolCoord(toDelID);
    }

    this.updateToolCoord =function(id,name,info){
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat("UPDATE toolcoord SET name='{0}',info='{1}' WHERE id={2}",
                                               name,JSON.stringify(info),id));
            if(rs.rowsAffected > 0){
                toolCoords[id] ={"id":id,"name":name,"info":info};
//                manager.informMonitor("onToolCoordChange",toolCoords[id]);
            }
        });
    }

    this.updateToolCoordByName = function(name, info){
        var toUpdateID = getValueFromBrackets(name);
        this.updateToolCoord(toUpdateID, toolCoords[toUpdateID].name, info);
        return toUpdateID;
    }

//    this.registerMonitor = function(obj){
//        this.monitors.push(obj)
//    }

//    this.informMonitor = function(event, info){
//        var m;
//        for(var i = 0; i < this.monitors.length; ++i){
//            m = this.monitors[i];
//            if(m.hasOwnProperty(event))
//                m[event](info);
//        }
//    }


}
    var toolCoordManager= new ToolCoordManager();
