.pragma library

Qt.include("../../utils/utils.js")

var HCGCodeInterpreter = {

    createNew:function(options){
        var interpreter = GCodeInterpreter.createNew(options);
        interpreter.G92 = function(args){
            console.log("G92", args);
        }
        return interpreter;
    }
}

var hcInterpreter = HCGCodeInterpreter.createNew();
//hcInterpreter.interprete(gCode);
