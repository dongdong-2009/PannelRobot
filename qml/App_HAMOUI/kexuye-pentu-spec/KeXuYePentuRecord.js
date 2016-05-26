.pragma library
Qt.include("../../utils/stringhelper.js")
Qt.include("../../utils/Storage.js")

function KeXuyePentuRecord(){
    this.init = function(){
        var db = getDatabase();
        db.transaction(function(tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS kxyrecord(name TEXT UNIQUE, value TEXT)');
        });
    };

    this.exist = function(name){
        var db = getDatabase();
        var ret = false;
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat('SELECT * FROM kxyrecord WHERE name="{0}"', name));
            if(rs.rowsAffected > 0) ret = true;
        });
        return ret;
    };

    this.newRecord = function(name, content){
        if(this.exist(name)) return false;
        var db = getDatabase();
        db.transaction(function(tx){
            tx.executeSql(icStrformat('INSERT INTO kxyrecord VALUES("{0}","{1}")', name, content));
        });
        return true;
    };

    this.updateRecord = function(name, content){
        if(this.exist(name)){
            var db = getDatabase();
            db.transaction(function(tx){
                tx.executeSql(icStrformat('UPDATE kxyrecord SET value="{0}" WHERE name="{1}"', content, name));
            });
        }
    };

    this.delRecord = function(name){
        var db = getDatabase();
        db.transaction(function(tx){
           tx.executeSql(icStrformat('DELETE FROM kxyrecord WHERE name="{0}"', name));
        });
    };

    this.getRecordContent = function(name){
        var db = getDatabase();
        var ret  = "[]";
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat('SELECT value FROM kxyrecord WHERE name = "{0}"', name));
            if(rs.rows.length > 0){
                ret = rs.rows.item(0).value;
            }
        });
        return ret;
    };
}