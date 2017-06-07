.pragma library

Qt.include("../utils/Storage.js")
Qt.include("../utils/stringhelper.js")
Qt.include("../utils/utils.js")
function ToolCalibrationManager(){
    this.toolCalibrations = [];
    var db = getDatabase();
    var toolCalibrations = this.toolCalibrations;
    var manager = this;
    db.transaction(function(tx){
        tx.executeSql('CREATE TABLE IF NOT EXISTS toolCalibration(id PK INTEGER NOT NULL,type PK INTEGER NOT NULL,name TEXT  NOT NULL, info TEXT  NOT NULL)');
    }
    );

    db.transaction(function(tx){
        var rs = tx.executeSql('SELECT * FROM toolCalibration ORDER BY id ASC');
        var toolCalibration ={};
        for(var i = 0; i < rs.rows.length; ++i){
            toolCalibration = rs.rows.item(i);
            toolCalibration.info = JSON.parse(toolCalibration.info);
            toolCalibrations[toolCalibration.id] = toolCalibration;
        }
    });

    this.clear = function(){
        db.transaction(function(tx){
            tx.executeSql('DELETE FROM toolCalibration');
        });
    }

    this.findUsableID = function(){
        for(var i=0;i<toolCalibrations.length;++i){
            if(toolCalibrations[i+1] == undefined)
                return i+1
        }
        return toolCalibrations.length+1;
    }

    this.getToolCalibration = function(id){
        return toolCalibrations[id];
    }

    this.getToolCalibrationByName = function(name){
        var toGetID = getValueFromBrackets(name);
        return this.getToolCalibration(toGetID);
    }

    this.toolCalibrationNameList = function(){
        var ret=[];
        var c;
        for(var i=0;i<toolCalibrations.length;++i)
        {
            c=toolCalibrations[i];
            if(c !== undefined)
                ret.push(icStrformat(qsTr("{0}:{1}"),c.id,c.name));
        }
        return ret;
    }

    this.toolCalibrationList = function(){
        var ret =[];
        var c;
        for(var i=0;i<toolCalibrations.length;++i){
            c= toolCalibrations[i];
            if(c !== undefined)
                ret.push(c);
        }
        return ret;
    }


    this.addToolCalibration = function(type,name,info){
        var id = this.findUsableID()
        var toRet = id;

        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat("INSERT INTO toolCalibration VALUES({0},{1},'{2}','{3}')",
                                               id,type,name,JSON.stringify(info)));
            if(rs.rowsAffected > 0){
                toolCalibrations[id] = {"id":id,"type":type,"name":name,"info":info};
            }
        });
        return toRet;
    }

    this.removeToolCalibration = function(id){
        db.transaction(function(tx){
            var rs =tx.executeSql(icStrformat('DELETE FROM toolCalibration WHERE id={0}',
                                              id));
            if(rs.rowsAffected > 0){
                toolCalibrations[id] = undefined;
            }
        });
    }

    this.removeToolCalibrationByName = function(name){
        var toDelID = getValueFromBrackets(name);
        this.removeToolCalibration(toDelID);
    }

    this.updateToolCalibration =function(id,type,name,info){
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat("UPDATE toolCalibration SET name='{0}',info='{1}',type ={2} WHERE id={3}",
                                               name,JSON.stringify(info),type,id));
            if(rs.rowsAffected > 0){
                toolCalibrations[id] ={"id":id,"type":type,"name":name,"info":info};
            }
        });
    }

    this.updateToolCalibrationByName = function(name, type,info){
        var toUpdateID = getValueFromBrackets(name);
        this.updateToolCalibration(toUpdateID,type, toolCalibrations[toUpdateID].name, info);
        return toUpdateID;
    }
}

var toolCalibrationManager= new ToolCalibrationManager();
