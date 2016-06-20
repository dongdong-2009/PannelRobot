.pragma library

Qt.include("../../utils/utils.js")

var HCCYGCodeInterpreter = {

    //    G码表
    //    G00：快速定位
    //    G01：直线切削
    //    G02：圆弧切削（顺时针方向）
    //    G03：圆弧切削（逆时针方向）
    //    G04：暂停n秒
    //    G20：英制
    //    G21：公制
    //    G26：圆形阵列
    //    G28：自动参考点回归
    //    G40：切削补偿取消
    //    G41：切削补偿（左边）
    //    G42：切削补偿（右边）
    //    G52：局部坐标系统设定
    //    G54：工件坐标系统1
    //    G55：工件坐标系统2
    //    G56：工件坐标系统3
    //    G57：工件坐标系统4
    //    G58：工件坐标系统5
    //    G59：工件坐标系统6
    //    G68：圆形蚕食，最大量为6mm
    //    G69：直线蚕食，最大量为6mm
    //    G70：定位不冲孔
    //    G72：基准点设置
    //    G73：多数取加工（X方向先移动）
    //    G74：多数取加工（Y方向先移动）
    //    G75：换爪
    //    G76：任何角度作直线等距冲孔
    //    G77：等角度圆弧冲孔
    //    G78：网状冲孔（X方向先动）
    //    G79：网状冲孔（Y方向先动）
    //    G86：长条孔
    //    G87：方形孔
    //    G88：圆形孔
    //    G89：任何角度作直线冲孔
    //    G90：绝对坐标
    //    G92：床台坐标设定
    //    G98：多数取坐标设定



    //    M码表
    //    M00:程序暂停
    //    M01:选择性停止
    //    M02:程序结束
    //    M03:X、Y回原点后自动打开夹爪
    //    M05:刀具自动润滑系统启动
    //    M06: 刀具自动润滑系统关闭
    //    M08:冲击完成讯号延迟开始
    //    M09: 冲击完成讯号延迟结束
    //    M10:压缸下降
    //    M11:压缸上升
    //    M12:蚕食模式开始
    //    M13:原本模式取消更换下一模式
    //    M21:冲速度1段
    //    M22: 冲速度2段
    //    M23: 冲速度3段
    //    M30:程序结束，回头等待
    //    M60:X、Y轴自动速度100%，T、C速度100%
    //    M61: X、Y轴自动速度75%，T、C速度100%
    //    M62: X、Y轴自动速度50%，T、C速度50%
    //    M63: X、Y轴自动速度25%，T、C速度50%
    //    M98:副程序呼叫
    //    M99: :副程序结束

    //    G90 X500. Y600. T220 C45. ;
    //    T220 以 45°的角度加工。
    //    X350. Y700. ;
    //    X10. Y600. T309 ; ······· 自动分度回到“0°”后选择 T309、加工。

    //    G90 X100. Y100. T
    //    ;···· 冲。
    //    G70 G91 X200. ; ···· 不冲。
    //    G90 Y300. ; ···· 冲。

    //    G28 自动原点回归

    createNew:function(options){
        var interpreter = GCodeInterpreter.createNew(options);
        interpreter.interpretedPoints = [];
        var axisNames = ["X", "Y", "C"];

        var cmdGrouMap = {
            "G0":1,"G1":1,"G2":1,"G3":1,
            "G17":2,"G18":2,"G19":2,
            "G90":3,"G91":3

        };
        var originPos = {
            "X":0,"Y":0, "T":0, "C":0
        }

        var currentPos = {
            "X":0,"Y":0,"T":0, "C":0
        }

        var currentModelPos = {
            "X":0, "Y":0
        }

        var virtualOriginPos = {
            "X":0,"Y":0, "T":0, "C":0
        }

        var lastG98Args = {
            "X":0,"Y":0, "T":0, "C":0
        };

        var macros = {}
        var currentInMacro = 0;

        var fillAxisPos = function(point, args){
            for(var m in args){
                point[m] = args[m];
            }
        };

        var moveAxisPos = function(point, args){
            for(var m in axisNames){
                m = axisNames[m];
                if( m in args){
                    if(args[m] != null)
                        point[m] = args[m] + virtualOriginPos[m]/* + originPos[m]*/;
                }
            }
            if("T" in args)
                point.T = args.T;
        }

        var moveDistanceG90 = function(current, args){
            moveAxisPos(current, args);
        };

        var moveDistanceG91 = function(current, args){
            for(var m in args){
                current[m] += args[m];
            }
        }
        var moveDistance = moveDistanceG90;

        var posToStackPoint = function(pos){
            return {
                "m0":pos.X.toFixed(3) || 0.000,
                "m1":pos.Y.toFixed(3) || 0.000,
                "m2":0.000,
                "m3":0.000,
                "m4":0.000,
                "m5":0.000
            };

        }

        var runPos = function(args){
            if(!needToAppendToMacro("_NoCmd", args)){
                moveDistance(currentPos, args);
                interpreter.interpretedPoints.push(posToStackPoint(currentPos));
                console.log("Run Pos:", JSON.stringify(currentPos));
            }
        }
        var needToAppendToMacro = function(cmd, args){
            if(currentInMacro != 0){
                macros[currentInMacro].push({"cmd":cmd, "args":args});
                return true;
            }
            return false;
        }

        var runMacro = function(which){
            if(which in macros){
                for(var i = 0, macro = macros[which], len = macro.length; i < len; ++i){
                    //                    runPos(macro[i]);
                    interpreter[macro[i].cmd](macro[i].args);
                }
            }
        }

        var sinA = function(angle){
            return Math.sin(180 / Math.PI * angle);
        }

        var cosA = function(angle){
            return Math.cos(180 / Math.PI * angle);
        }

        var axisRotate = function(x, y, angle){
            var x1, y1;
            var a = 180 / Math.PI * angle;
            x1 = x * Math.cos(a) - y * Math.sin(a);
            y1 = y * Math.cos(a) + x * Math.sin(a);
            return {"X":x1, "Y":y1};
        }

        interpreter.beforeInterprete = function(){
            interpreter.interpretedPoints.length = 0;
            currentPos.X = 0;
            currentPos.Y = 0;
            currentPos.C = 0;
            currentPos.T = 0;
            currentModelPos.X = 0;
            currentModelPos.Y = 0;
            currentInMacro = 0;
            virtualOriginPos.X = 0;
            virtualOriginPos.Y = 0;
            originPos.X = 0;
            originPos.Y = 0;

        }

        interpreter._ = function(cmd, args){
            console.log(cmd, JSON.stringify(args));
        }


        interpreter._NoCmd = function(args){
            if("O" in args) return;
            if("U" in args){
                macros[args.U] = [];
                currentInMacro = args.U;
            }else if("V" in args){
                currentInMacro = 0;
            }else if("W" in args){
                runMacro(args.W);
            }else{
                runPos(args);
            }


        }

        interpreter.G90 = function(args){
            if(!needToAppendToMacro("G90", args))
                moveDistance = moveDistanceG90;
        }
        interpreter.G91 = function(args){
            if(!needToAppendToMacro("G91", args))
                moveDistance = moveDistanceG91;
        }

        interpreter.G92 = function(args){
            fillAxisPos(originPos, args);
        }

        interpreter.G98 = function(args){
            if("X" in args)
                virtualOriginPos.X = args.X;
            if("Y" in args)
                virtualOriginPos.Y = args.Y;
            lastG98Args = args;
        }

        interpreter.G73 = function(args){
            var xCount = lastG98Args.P;
            var yCount = lastG98Args.K;
            var xSpace = lastG98Args.I;
            var ySpace = lastG98Args.J;
            for(var i = 0; i < xCount; ++i){
                for(var j = 0; j < yCount; ++j){
                    runMacro(args.W);
                    virtualOriginPos.Y += ySpace;
                }
                virtualOriginPos.X += xSpace;
            }
            virtualOriginPos.X = lastG98Args.X;
            virtualOriginPos.Y = lastG98Args.Y;
        }

        interpreter.G74 = function(args){
            interpreter["G73"](args);
        }

        interpreter.G72 = function(args){
            moveDistance(currentModelPos, args);
        }

        interpreter.G76 = function(args){
            if(!needToAppendToMacro("G76", args)){
                var space = args.I;
                var num = args.K;

                var currentX = 0;
                var p;
                virtualOriginPos.X = currentModelPos.X;
                virtualOriginPos.Y = currentModelPos.Y;
                for(var i = 0; i < num; ++i){
                    currentX += space;
                    p = axisRotate(currentX, 0, args.J)
                    p.T = (args.T || null);
                    p.C = (args.C || null);
                    runPos(p);
                }
                virtualOriginPos = lastG98Args;

            }
        }

        interpreter.G77 = function(args){
            if(!needToAppendToMacro("G77", args)){
                var currentA = args.J;
                var num = args.K;
                var x1, y1;
                virtualOriginPos.X = currentModelPos.X;
                virtualOriginPos.Y = currentModelPos.Y;
                for(var i = 0; i < num; ++i){
                    x1 = args.I * cosA(currentA);
                    y1 = args.I * sinA(currentA);
                    runPos({"X":x1, "Y":y1, "T":(args.T || null), "C":(args.C || null)});
                    currentA += args.P;
                }
                virtualOriginPos = lastG98Args;
            }
        }

        interpreter.G78 = function(args){
            if(!needToAppendToMacro("G78", args)){
                var xSpace = args.I;
                var xCount = args.P;
                var ySpace = args.J;
                var yCount = args.K;
                virtualOriginPos.X = currentModelPos.X;
                virtualOriginPos.Y = currentModelPos.Y;
                for(var i = 0; i < xCount; ++i){
                    for(var j = 0; j < yCount; ++j){
                        runPos({"X": xSpace * (i + 1),
                                   "Y":ySpace * (j + 1),
                                   "C":(args.C || null),
                                   "T":(args.T || null)});
                    }
                }
                virtualOriginPos = lastG98Args;
            }
        }

        interpreter.G79 = function(args){
            if(!needToAppendToMacro("G79", args))
                interpreter["G78"](args);
        }

        //        interpreter.G86 = function(args){
        //            if(!needToAppendToMacro("G86", args)){
        //                var wx = args.P / 2;
        //                var wy = args.Q / 2;
        //            }
        //        }

        //        interpreter.G89 = function(args){
        //            if(!needToAppendToMacro("G89", args))
        //            {
        //                var wx = args.P / 2 - (args.D || 0);
        //                var wy = args.Q / 2;
        //                var angle = args.J * 180 / Math.PI;
        //                var currentL = 0;
        //                virtualOriginPos.X += currentModelPos.X;
        //                virtualOriginPos.Y += currentModelPos.Y;
        //                var x1,y1;
        //                var yCos = wy * Math.cos(angle);
        //                var ySin = wy * Math.sin(angle);
        //                console.log("G89", JSON.stringify(args));
        //                while(currentL < args.I){
        //                    currentL += wx;
        //                    x1 = currentL * Math.cos(angle) + ySin;
        //                    y1 = yCos - currentL * Math.sin(angle);
        //                    runPos({"X":x1, "Y":y1, "T":args.T || null});
        //                }
        //                console.log("G89END");
        //                virtualOriginPos = lastG98Args;
        //            }
        //        }



        return interpreter;
    }
}

var hcInterpreter = HCCYGCodeInterpreter.createNew();
//hcInterpreter.interprete(gCode);
