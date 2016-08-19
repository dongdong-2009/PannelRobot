.pragma library

Qt.include("../utils/Storage.js")
Qt.include("../utils/stringhelper.js")
Qt.include("../utils/utils.js")

function DataLog()
{
    this.init = function(){
        var db = getDatabase();
        db.transaction(function(tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS posLog(id PK INTEGER NOT NULL, datetime TEXT  NOT NULL, pos TEXT  NOT NULL)');
        }
        );
    }
    this.maxPosLog = 1000;
    this.appendPosLog = function(pos){
        var db = getDatabase();
        db.transaction(function(tx){
            var rs = tx.executeSql("SELECT MAX(id), MIN(id) FROM posLog");
            var max = 0;
            var min = 0;
            if(rs.rows.length > 0){
                max = parseInt(rs.rows.item(0)["MAX(id)"]);
                min = parseInt(rs.rows.item(0)["MIN(id)"]);
            }
            var now  = new Date;
            if(max >= this.maxPosLog){
                tx.executeSql(icStrformat("UPDATE posLog SET id = {0}, datetime = {1}, pos = '{2}' WHERE id = {3}", max + 1, now.getTime(), pos, min));
            }else{
                tx.executeSql(icStrformat("INSERT into posLog VALUES({0}, {1}, '{2}' WHERE id = {3})", max + 1, now.getTime(), pos, min));
            }
        });
    }
}
