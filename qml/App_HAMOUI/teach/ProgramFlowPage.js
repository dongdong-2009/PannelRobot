var programs = [];
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
var lastRunning = {"model": -1, "step":-1, "items":[]};

var isReadOnly = true;

var counterLinesInfo = {
    "programsCounters":[],
    "clear": function(programIndex){
        var tmp = this.programsCounters[programIndex];
        if(tmp != undefined){
            tmp.length = 0;
        }
    },
    "add":function(programIndex, counterID, line){
        var tmp = this.programsCounters[programIndex];
        if(tmp == undefined){
            this.programsCounters[programIndex] = {};
        }
        tmp = this.programsCounters[programIndex][counterID];
        if(tmp == undefined)
            tmp = []
        tmp.push(line);
        this.programsCounters[programIndex][counterID] = tmp;
    },
    "getCounterLine":function(programIndex, counterID){
        var tmp = this.programsCounters[programIndex][counterID];
        return tmp || [];
    }
}
