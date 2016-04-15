.pragma library

Qt.include("../../utils/utils.js")

var HCGCodeInterpreter = {

    createNew:function(options){
        var interpreter = GCodeInterpreter.createNew(options);
        var cmdGrouMap = {
            "G0":1,"G1":1,"G2":1,"G3":1,
            "G17":2,"G18":2,"G19":2

        };
        var currentPos = {
            "X":0,"Y":0,"Z":0
        }

        interpreter.G92 = function(args){
            console.log("G92", args);
        }
        return interpreter;
    }
}

var hcInterpreter = HCGCodeInterpreter.createNew();
//hcInterpreter.interprete(gCode);
