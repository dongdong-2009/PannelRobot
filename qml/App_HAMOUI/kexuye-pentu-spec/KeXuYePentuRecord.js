.pragma library
Qt.include("../../utils/stringhelper.js")
Qt.include("../../utils/Storage.js")

function KeXuyePentuRecord(){
    this.init = function(){
        var db = getDatabase();
        db.transaction(function(tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS kxyrecord(name TEXT UNIQUE, value TEXT, lineInfo TEXT)');
            var rs = tx.executeSql("SELECT sql FROM sqlite_master WHERE name = 'kxyrecord'");
            var sql = rs.rows.item(0).sql;
            if(sql.indexOf("lineInfo") < 0){
                tx.executeSql('ALTER TABLE kxyrecord ADD COLUMN lineInfo TEXT;');
            }
        });
    };

    this.exist = function(name){
        var db = getDatabase();
        var ret = false;
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat('SELECT * FROM kxyrecord WHERE name="{0}"', name));
            if(rs.rows.length > 0) ret = true;
        });
        return ret;
    };

    this.newRecord = function(name, content){
        if(this.exist(name)) return false;
        var db = getDatabase();
        db.transaction(function(tx){
            tx.executeSql(icStrformat("INSERT INTO kxyrecord VALUES('{0}','{1}','{}')", name, content));
        });
        return true;
    };

    this.updateRecord = function(name, content){
        if(this.exist(name)){
            var db = getDatabase();
            db.transaction(function(tx){
                tx.executeSql(icStrformat("UPDATE kxyrecord SET value='{0}' WHERE name='{1}'", content, name));
            });
        }else{
            this.newRecord(name, content);
        }
    };

    this.updateLineInfo= function(name, content){
        if(this.exist(name)){
            var db = getDatabase();
            db.transaction(function(tx){
                tx.executeSql(icStrformat("UPDATE kxyrecord SET lineInfo='{0}' WHERE name='{1}'", content, name));
            });
        }else{
            this.newRecord(name, content);
        }
    };

    this.delRecord = function(name){
        var db = getDatabase();
        db.transaction(function(tx){
           tx.executeSql(icStrformat('DELETE FROM kxyrecord WHERE name="{0}"', name));
        });
    };

    this.copyRecord = function(newName, originName){
        if(this.exist(name)) return false;
        var db = getDatabase();
        db.transaction(function(tx){
            tx.executeSql(icStrformat("CREATE TABLE {0} AS SELECT * FROM {1}", newName, originName));
        });
    }

    this.getRecordContent = function(name){
        var db = getDatabase();
        var ret  = '[{"action":60000,"insertedIndex":0}]';
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat('SELECT value FROM kxyrecord WHERE name = "{0}"', name));
            if(rs.rows.length > 0){
                ret = rs.rows.item(0).value;
            }
        });
        return ret;
    };
    this.getLineInfo = function(name){
        var db = getDatabase();
        var ret = "{}";
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat('SELECT lineInfo FROM kxyrecord WHERE name = "{0}"', name));
            if(rs.rows.length > 0){
                ret = rs.rows.item(0).lineInfo;
                if(ret == null || ret == "")
                    ret = "{}";
            }
        });
        return ret;
    }
}

var keXuyePentuRecord = new KeXuyePentuRecord();
keXuyePentuRecord.init();
