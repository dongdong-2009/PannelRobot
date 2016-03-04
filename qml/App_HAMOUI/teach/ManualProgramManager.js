.pragma library

Qt.include("../../utils/Storage.js")
Qt.include("../../utils/stringhelper.js")
Qt.include("../../utils/utils.js")

function ManualProgramManager(){
    this.programs = [];
    var db = getDatabase();
    var programs = this.programs;
    db.transaction(function(tx){
        tx.executeSql('CREATE TABLE IF NOT EXISTS manualprogram(id PK INTEGER NOT NULL, name TEXT  NOT NULL, program TEXT  NOT NULL)');
    }
    );
    db.transaction(function(tx){
        var rs = tx.executeSql('SELECT * FROM manualprogram ORDER BY id ASC');
        var prog;
        for(var i = 0; i < rs.rows.length; ++i){
            prog = rs.rows.item(i);
            prog.program = JSON.parse(prog.program);
            programs[prog.id] = prog;

        }
    }
    );
    this.findUsableID = function(){
        for(var i = 0 ; i < programs.length; ++i){
            if(programs[i] === undefined)
                return i;
        }
        return programs.length;
    }

    this.getProgram = function(id){
        return programs[id];
    }

    this.getProgramByName = function(name){
        var toGetID = getValueFromBrackets(name);
        return this.getProgram(toGetID);
    }

    this.programsNameList = function(){
        var ret = [];
        var p;
        for(var i = 0; i < programs.length; ++i){
            p = programs[i];
            if(p !== undefined)
                ret.push(icStrformat(qsTr("M CMD[{0}]:{1}"), p.id, p.name));
        }
        return ret;
    }

    this.addProgram = function(name, program){
        var id = this.findUsableID();
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat("INSERT INTO manualprogram VALUES({0}, '{1}', '{2}')",
                                     id , name, JSON.stringify(program)));
            if(rs.rowsAffected > 0){
                programs[id] = {"id":id, "name":name, "program":program};
            }
        });
        return icStrformat(qsTr("M CMD[{0}]:{1}"), id, name)
    }
    this.removeProgram = function(id){
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat('DELETE FROM manualprogram WHERE id={0}',
                                     id));
            if(rs.rowsAffected > 0){
                programs[id] = undefined;
            }
        });
    }
    this.removeProgramByName = function(name){
        var toDelID = getValueFromBrackets(name);
        this.removeProgram(toDelID);
    }

    this.updateProgram = function(id, name, program){
        db.transaction(function(tx){
            var rs = tx.executeSql(icStrformat("UPDATE manualprogram SET name='{0}', program='{1}' WHERE id={2}",
                                     name, JSON.stringify(program), id));
            if(rs.rowsAffected > 0){
                programs[id] = {"id":id, "name":name, "program":program};
            }
        });
    }

    this.updateProgramByName = function(name, program){
        var toUpdateID = getValueFromBrackets(name);
        this.updateProgram(toUpdateID, programs[toUpdateID].name, program);
    }
}

var manualProgramManager = new ManualProgramManager();
