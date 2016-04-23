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
            "X":0,"Y":0,"Z":0, "U":0, "V":0, "W":0, "T":0, "C":0
        }

        var currentModelPos = {
            "X":0, "Y":0
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
