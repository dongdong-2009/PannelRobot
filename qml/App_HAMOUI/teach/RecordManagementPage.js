.pragma library

Qt.include("../../utils/utils.js")

var HCCYGCodeInterpreter = {

    createNew:function(options){
        var interpreter = GCodeInterpreter.createNew(options);
//        var axisNames = ["X", "Y", "Z", "U", "V", "W"];
        var fillAxisPos = function(point, args){
            for(var m in args){
                point[m] = args[m];
            }
        };

        var moveDistance;
        var moveDistanceG90 = function(current, args){
            fillAxisPos(current, args);
        };

        var moveDistanceG91 = function(current, args){
            for(var m in args){
                point[m] += args[m];
            }
        }

        var cmdGrouMap = {
            "G0":1,"G1":1,"G2":1,"G3":1,
            "G17":2,"G18":2,"G19":2,
            "G90":3,"G91":3

        };
        var originPos = {
            "X":0,"Y":0,"Z":0, "U":0, "V":0, "W":0
        }

        var currentPos = {
            "X":0,"Y":0,"Z":0, "U":0, "V":0, "W":0
        }

        interpreter._ = function(cmd, args){
            console.log(cmd, JSON.stringify(args));
        }
        interpreter._NoCmd = function(args){
            console.log("No CMD:", JSON.stringify(args));
        }

        interpreter.G90 = function(args){
            moveDistance = moveDistanceG90;
        }
        interpreter.G91 = function(args){
            moveDistance = moveDistanceG91;
        }

        interpreter.G92 = function(args){
            fillAxisPos(originPos, args);
        }

        interpreter.G98 = function(args){

        }

        return interpreter;
    }
}

var hcInterpreter = HCCYGCodeInterpreter.createNew();
//hcInterpreter.interprete(gCode);
