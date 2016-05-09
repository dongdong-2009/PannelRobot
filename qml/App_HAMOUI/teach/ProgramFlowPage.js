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
}

var counterLinesInfo = new LinesInfo();

var stackLinesInfo = new LinesInfo();

var pointLinesInfo = new LinesInfo();

var linked1Function = null;
var linked2Function = null;
var linked3Function = null;

var kFunctionProgramIndex = 9;
var kManualProgramIndex = 10;

var programActionMenu = null;
var moduleActionEditor;

var currentEditingProgram = 0;

function UpdateModelStruct(event,listIndex, programIndex, model, actionObject){
    this.event = event;
    this.listIndex = listIndex;
    this.programIndex = programIndex;
    this.model = model;
    this.actionObject = actionObject;
}
