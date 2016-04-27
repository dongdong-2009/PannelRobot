import QtQuick 2.2

import QtTest 1.0
import "../App_HAMOUI/teach/StackCustomPointEditor.js" as HCCYCodeInterpreter

TestCase {
    name: "GCodeTests"

    function sinA(angle){
        return Math.sin(180 / Math.PI * angle);
    }
    function cosA(angle){
        return Math.cos(180 / Math.PI * angle);
    }

    function test_G76() {
        var interpreter = HCCYCodeInterpreter.HCCYGCodeInterpreter.createNew();
        interpreter.interprete("G72 X300. Y200. \nG76 I25. J30. K6 T208");
        compare(interpreter.interpretedPoints.length, 6, "G76 cmd generate size should equal K");
        var i;
        var p = interpreter.interpretedPoints;
        var len = p.length;
        for(i = 0; i < len; ++i){
            compare(p[i].m1 , (25 * (i + 1) * sinA(30) + 200).toFixed(3), "PY" + i);
            compare(p[i].m0 , (25 * (i + 1) * cosA(30) + 300).toFixed(3), "PX" + i);
        }


        interpreter.interprete("G98 X10. Y11.\nG72 X300. Y200. \nG76 I25. J30. K6 T208");
        compare(interpreter.interpretedPoints.length, 6, "G76 cmd generate size should equal K");
        p = interpreter.interpretedPoints;
        len = p.length;
        for(i = 0; i < len; ++i){
            compare(p[i].m1 , (25 * (i + 1) * sinA(30) + 211).toFixed(3), "PY+G98" + i);
            compare(p[i].m0 , (25 * (i + 1) * cosA(30) + 310).toFixed(3), "PX+G98" + i);
        }

        interpreter.interprete("G72 X300. Y200. \nG76 I-25. J30. K6 T208");
        p = interpreter.interpretedPoints;
        len = p.length;
        compare(interpreter.interpretedPoints.length, 6, "G76 cmd generate size should equal K");
        for(i = 0; i < len; ++i){
            compare(p[i].m1 , (-25 * (i + 1) * sinA(30) + 200).toFixed(3), "PY" + i);
            compare(p[i].m0 , (-25 * (i + 1) * cosA(30) + 300).toFixed(3), "PX" + i);
        }
    }

    function test_G77() {
        var interpreter = HCCYCodeInterpreter.HCCYGCodeInterpreter.createNew();
        interpreter.interprete("G72 X480. Y120. \nG77 I180. J30. P15. K6 T208");
        compare(interpreter.interpretedPoints.length, 6, "G77 cmd generate size should equal K");
        var i;
        var p = interpreter.interpretedPoints;
        var len = p.length;
        for(i = 0; i < len; ++i){
            compare(p[i].m1 , (180 * sinA(30 + i * 15) + 120).toFixed(3), "PY" + i);
            compare(p[i].m0 , (180 * cosA(30 + i * 15) + 480).toFixed(3), "PX" + i);
        }

        interpreter.interprete("G72 X480. Y120. \nG77 I180. J30. P-15. K6 T208");
        p = interpreter.interpretedPoints;
        len = p.length;
        compare(interpreter.interpretedPoints.length, 6, "G77 cmd generate size should equal K");
        for(i = 0, p = interpreter.interpretedPoints, len = p.length; i < len; ++i){
            compare(p[i].m1 , (180 * sinA(30 + i * -15) + 120).toFixed(3), "PY" + i);
            compare(p[i].m0 , (180 * cosA(30 + i * -15) + 480).toFixed(3), "PX" + i);
        }
    }

    function test_G78(){
        var interpreter = HCCYCodeInterpreter.HCCYGCodeInterpreter.createNew();
        interpreter.interprete("G72 X350. Y410.\nG78 I50. P3 J-20. K5 T208");
        compare(interpreter.interpretedPoints.length, 3 * 5, "G78 cmd generate size should equal P * K");
        var i, p, len;
        for(i = 0, p = interpreter.interpretedPoints; i < 3; ++i){
            for(var j = 0; j < 5; ++j){
                compare(p[i * 5 + j].m0, (50 * (i + 1) +  350).toFixed(3), "PX" + i + " " + j);
                compare(p[i * 5 + j].m1, (-20 * (j + 1) +  410).toFixed(3), "PY" + i + " " + j);

            }
        }

    }
}
