.pragma library

Qt.include("../teach/Teach.js")
Qt.include("../configs/AxisDefine.js")
actions.F_CMD_PENTU = 70000;

var pentuModes = {

}
pentuModes.LineU2DRepeat = 0;
pentuModes.LineZ2DRepeat = 1;
pentuModes.LineSaw2DRepeat = 2;
pentuModes.LineDir2DRepeat = 3;

pentuModes.ArcU3DRepeat = 4;
pentuModes.ArcZ3DRepeat = 5;
pentuModes.ArcSaw3DRepeat = 6;
pentuModes.ArcDir3DRepeat = 7;

var generatePENTUAction = function(mode, plane, startPos, startPosSpeed0, startPosSpeed1,
                                   startPosSpeed2, startPosSpeed3, startPosSpeed4, startPosSpeed5,
                                   repeatSpeed, repeateCount, zlength, dirAxis, dirLength, dirSpeed,
                                   dirCount, point1, point2, rotate, rotateSpeed, rotateCount,
                                   fixtureDelay0, fixtureDelay1, fixtureDelay2, rcID, dirCID, rotateCID,
                                   fixture2Delay0, fixture2Delay1, fixture2Delay2, fixture1Switch, fixture2Switch,
                                   slope, rotateOKCID){


    var f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag0 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag1 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag2 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag3 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag4 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag5 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag6 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag7 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag8 = f.flagID;
//    if(mode == 0){
    switch(plane){
        case 0:
            if(dirAxis == 0){
                var rpeateAxis = 1;
                var startPos0 = startPos.pos.m1;
                var startPos1 = startPos.pos.m0;
                var startSpeed0 = startPosSpeed1;
                var startSpeed1 = startPosSpeed0;
                var point1_m0 = point1.pos.m1;
                var point1_m1 = point1.pos.m0;
            }
            else if(dirAxis == 1){
                rpeateAxis = 0;
                startPos0 = startPos.pos.m0;
                startPos1 = startPos.pos.m1;
                startSpeed0 = startPosSpeed0;
                startSpeed1 = startPosSpeed1;
                point1_m0 = point1.pos.m0;
                point1_m1 = point1.pos.m1;
            }
            var deepAxis = 2;
            var startPos2 = startPos.pos.m2;
            var startSpeed2 = startPosSpeed2;
            break;
        case 1:
            if(dirAxis == 0){
                rpeateAxis = 2;
                startPos0 = startPos.pos.m2;
                startPos1 = startPos.pos.m0;
                startSpeed0 = startPosSpeed2;
                startSpeed1 = startPosSpeed0;
                point1_m0 = point1.pos.m2;
                point1_m1 = point1.pos.m0;
            }
            else {
                rpeateAxis = 0;
                startPos0 = startPos.pos.m0;
                startPos1 = startPos.pos.m2;
                startSpeed0 = startPosSpeed0;
                startSpeed1 = startPosSpeed2;
                point1_m0 = point1.pos.m0;
                point1_m1 = point1.pos.m2;
            }
            deepAxis = 1;
            startPos2 = startPos.pos.m1;
            startSpeed2 = startPosSpeed1;
            break;
        case 2:
            if(dirAxis == 1){
                rpeateAxis = 2;
                startPos0 = startPos.pos.m2;
                startPos1 = startPos.pos.m1;
                startSpeed0 = startPosSpeed2;
                startSpeed1 = startPosSpeed1;
                point1_m0 = point1.pos.m2;
                point1_m1 = point1.pos.m1;
            }
            else {
                rpeateAxis = 1;
                startPos0 = startPos.pos.m1;
                startPos1 = startPos.pos.m2;
                startSpeed0 = startPosSpeed1;
                startSpeed1 = startPosSpeed2;
                point1_m0 = point1.pos.m1;
                point1_m1 = point1.pos.m2;
            }
            deepAxis = 0;
            startPos2 = startPos.pos.m0;
            startSpeed2 = startPosSpeed0;
            break;
    }
//    }
//    if(mode == 1){
//        switch(plane){
//            case 0:
//                if(dirAxis == 0){
//                    rpeateAxis = 1;
//                    startPos0 = startPos.pos.m1;
//                    startPos1 = startPos.pos.m0;
//                    startSpeed0 = startPosSpeed1;
//                    startSpeed1 = startPosSpeed0;
//                    point1_m0 = point1.pos.m1;
//                    point1_m1 = point1.pos.m0;
//                }
//                else if(dirAxis == 1){
//                    rpeateAxis = 0;
//                    startPos0 = startPos.pos.m0;
//                    startPos1 = startPos.pos.m1;
//                    startSpeed0 = startPosSpeed0;
//                    startSpeed1 = startPosSpeed1;
//                    point1_m0 = point1.pos.m0;
//                    point1_m1 = point1.pos.m1;
//                }
//                deepAxis = 2;
//                startPos2 = startPos.pos.m2;
//                startSpeed2 = startPosSpeed2;
//                break;
//            case 1:
//                if(dirAxis == 0){
//                    rpeateAxis = 1;
//                    startPos0 = startPos.pos.m1;
//                    startPos1 = startPos.pos.m0;
//                    startSpeed0 = startPosSpeed1;
//                    startSpeed2 = startPosSpeed0;
//                }
//                else {
//                    rpeateAxis = 0;
//                    startPos0 = startPos.pos.m0;
//                    startPos1 = startPos.pos.m1;
//                    startSpeed0 = startPosSpeed0;
//                    startSpeed1 = startPosSpeed1;
//                }
//                deepAxis = 2;
//                startPos2 = startPos.pos.m2;
//                startSpeed2 = startPosSpeed2;
//                break;
//            case 2:
//                if(dirAxis == 1){
//                    rpeateAxis = 2;
//                    startPos1 = startPos.pos.m1;
//                    startPos2 = startPos.pos.m0;
//                    startSpeed1 = startPosSpeed1;
//                    startSpeed2 = startPosSpeed0;
//                }
//                else {
//                    rpeateAxis = 1;
//                    startPos1 = startPos.pos.m0;
//                    startPos2 = startPos.pos.m1;
//                    startSpeed1 = startPosSpeed0;
//                    startSpeed2 = startPosSpeed1;
//                }
//                deepAxis = 0;
//                startPos0 = startPos.pos.m2;
//                startSpeed0 = startPosSpeed2;
//                break;
//        }
//    }
    return {
        "action":actions.F_CMD_PENTU,
        "mode":mode,
        "plane":plane,
        "rpeateAxis":rpeateAxis,
        "deepAxis":deepAxis,
        "startPos":startPos,
        "startPos0":startPos0,
        "startPos1":startPos1,
        "startPos2":startPos2,
        "repeateSpeed":repeatSpeed,
        "repeateCount":repeateCount,
        "zlength":zlength,
        "repeateCounterID":rcID,
        "rotateOKCID":rotateOKCID,
        "dirAxis":dirAxis,
        "dirLength":dirLength,
        "dirSpeed":dirSpeed,
        "dirCount":dirCount,
        "dirCounterID":dirCID,
        "point1":point1,
        "point2":point2,
        "point1_m0":point1_m0,
        "point1_m1":point1_m1,
        "rotate":rotate,
        "rotateSpeed":rotateSpeed,
        "rotateCount":rotateCount,
        "rotateCounterID":rotateCID,
        "flag0":flag0,
        "flag1":flag1,
        "flag2":flag2,
        "flag3":flag3,
        "flag4":flag4,
        "flag5":flag5,
        "flag6":flag6,
        "flag7":flag7,
        "flag8":flag8,
//        "startPosSpeed0":startPosSpeed0,
//        "startPosSpeed1":startPosSpeed1,
//        "startPosSpeed2":startPosSpeed2,
//        "startPosSpeed3":startPosSpeed3,
//        "startPosSpeed4":startPosSpeed4,
//        "startPosSpeed5":startPosSpeed5,
//        "fixtureDelay0":fixtureDelay0,
//        "fixtureDelay1":fixtureDelay1,
//        "fixtureDelay2":fixtureDelay2,

        "startSpeed0":startSpeed0,
        "startSpeed1":startSpeed1,
        "startSpeed2":startSpeed2,
        "startSpeed3":startPosSpeed3,
        "startSpeed4":startPosSpeed4,
        "startSpeed5":startPosSpeed5,
        "fixtureDelay0":fixtureDelay0,
        "fixtureDelay1":fixtureDelay1,
        "fixtureDelay2":fixtureDelay2,
        "fixture2Delay0":fixtureDelay0,
        "fixture2Delay1":fixtureDelay1,
        "fixture2Delay2":fixtureDelay2,
        "fixture1Switch":fixture1Switch,
        "fixture2Switch":fixture2Switch,
        "slope":slope
    };
}

var pentuActionToStringHandler = function(actionObject){
    var mode = actionObject.mode;
    var ret = "";
    if(mode == pentuModes.Line2DRepeat)
        ret += qsTr("Line2DRepeat");
    else if(mode == pentuModes.Arc3DRepeat)
        ret += qsTr("Arc3DRepeat");
    ret += " ";
    if(actionObject.plane == 0)
        ret += "XY " + qsTr("Plane");
    else if(actionObject.plane == 1)
        ret += "XZ " + qsTr("Plane");
    else if(actionObject.plane == 2)
        ret += "YZ " + qsTr("Plane");
    ret += " ";
    ret += qsTr("Start Pos:") + pointToString(actionObject.startPos) + "\n                            ";

    ret += qsTr("Next Pos:") + pointToString(actionObject.point1) + " ";
    if(mode == pentuModes.Arc3DRepeat)
        ret += qsTr("End Pos:") + pointToString(actionObject.point2) + " ";
    ret += qsTr("Repeate Speed:") + actionObject.repeateSpeed + " " +
            qsTr("Repeate ") + actionObject.repeateCount + qsTr("Times") + "\n                            " +
            axisInfos[actionObject.dirAxis].name + qsTr("Dir Length:") + actionObject.dirLength + " " +
            qsTr("Dir Speed:") + actionObject.dirSpeed + " " +
            qsTr("Dir") + actionObject.dirCount + qsTr("Times");
    return ret;
}
