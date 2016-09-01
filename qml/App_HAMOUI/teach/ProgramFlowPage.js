.pragma library


var programs = [];
var functions = {};
var programToInsertIndex = [];
var stepAddrs =
        ["c_ro_0_16_0_933",
        "c_ro_16_16_0_933",
        "c_ro_0_16_0_934",
        "c_ro_16_16_0_934",
        "c_ro_0_16_0_935",
        "c_ro_16_16_0_935",
        "c_ro_0_16_0_936",
        "c_ro_16_16_0_936",
        "c_ro_0_16_0_937"];
var lastRunning = {"model": -1, "moduleID":-1, "step":-1, "items":[]};

var isReadOnly = true;

function LinesInfo(){
    this.programsLines = [];
    this.clear = function(programIndex){
        var tmp = this.programsLines[programIndex];
        if(tmp != undefined){
            this.programsLines.splice(programIndex, 1);
        }
    }
    this.add = function(programIndex, id, line){
        var tmp = this.programsLines[programIndex];
        if(tmp == undefined){
            this.programsLines[programIndex] = {};
        }
        tmp = this.programsLines[programIndex][id];
        if(tmp == undefined)
            tmp = []
        tmp.push(line);
        this.programsLines[programIndex][id] = tmp;
    }
    this.removeIDLine = function(programIndex, id, line){
        var lines = this.programsLines[programIndex][id];
        var count = lines.length;
        for(var i = 0; i < count; ++i){
            if(line == lines[i]){
                lines.splice(i,1);
                return i;
            }
        }
        return -1;
    }
    this.removeLine = function(programIndex, line){
        var pl = this.programsLines[programIndex];
        for(var id in pl){
            if(this.removeIDLine(programIndex, id, line) >= 0)
                break;
        }
    }

    this.syncLines = function(programIndex, beginLine, steps){
        if(this.programsLines.length == 0) return [];
        var pLs = this.programsLines[programIndex];
        for(var id in pLs){
            var lines = pLs[id];
            for(var l in lines){
                if(lines[l] >= beginLine)
                    lines[l] += steps;
            }
        }
    }

    this.getLines = function(programIndex, id){
        if(this.programsLines.length == 0) return [];
        if(!this.programsLines.hasOwnProperty(programIndex)) return [];
//        if(programIndex >= this.programsLines.length) return [];
        var tmp = this.programsLines[programIndex][id];
        return tmp || [];
    }

    this.idUsed = function(id){
        var ret = {"used":false, "details":[]};
        for(var i = 0, len = this.programsLines.length; i < len; ++i){
            var ls = this.getLines(i, id);
            if(ls.length > 0) {
                ret.used = true;
                ret.details.push({"which":i, "lines":ls});
            }
        }
        return ret;
    }
}


LinesInfo.usedLineInfoString = function(usedLineInfo){
    var details = usedLineInfo.details;
    var ret = "";
    for(var i = 0, len = details.length; i < len; ++i){
        ret += details[i].which == 0 ? qsTr("Main Program") : (qsTr("Sub-") + details[i].which);
        ret += ":";
        ret += qsTr("Lines:") + JSON.stringify(details[i].lines);
        ret += "\n";
    }
    return ret;
}

var counterLinesInfo = new LinesInfo();

var stackLinesInfo = new LinesInfo();

var pointLinesInfo = new LinesInfo();

var kFunctionProgramIndex = 9;
var kManualProgramIndex = 10;

var programActionMenu = null;
var moduleActionEditor;

var currentEditingProgram = 0;
var lastEditingIndex = 0;

function UpdateModelStruct(event,listIndex, programIndex, model, actionObject){
    this.event = event;
    this.listIndex = listIndex;
    this.programIndex = programIndex;
    this.model = model;
    this.actionObject = actionObject;
}

var registerEditableActions = {

}

function isRegisterEditableAction(action){
    return registerEditableActions.hasOwnProperty(action);
}

var autoModifyPosActions = {}

function hasAutoModified(index){
    return autoModifyPosActions.hasOwnProperty(index);
}

function clearAutoModifyPosActions(){
    autoModifyPosActions = {}
}

function programToParsingIndex(p){
    for(var i = 0, len = programs.length; i < len; ++i){
        if(p == programs[i])
            return i;
    }
    console.log("programToParsingIndex wrong p");
    return 0;
}
var insertboad = null;
