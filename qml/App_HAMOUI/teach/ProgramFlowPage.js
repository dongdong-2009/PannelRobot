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
    "clear": function(){ this.programsCounters.length = 0;},
    "add":function(program, counterID, line){
        var tmp = this.programsCounters[programs];
        if(tmp == undefined){
            this.programsCounters[programs] = {};
        }
        tmp = this.programsCounters[programs][counterID];
        if(tmp == undefined)
            tmp = []
        tmp.push(line);
        this.programsCounters[programs][counterID] = tmp;
    },
    "getCounterLine":function(program, counterID){
        var tmp = this.programsCounters[programs][counterID];
        return tmp || [];
    }
}
