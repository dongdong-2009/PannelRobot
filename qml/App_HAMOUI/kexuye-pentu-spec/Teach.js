.pragma library

Qt.include("../teach/Teach.js")
Qt.include("../configs/AxisDefine.js")
actions.F_CMD_PENTU = 70000;

var pentuModes = {

}
pentuModes.Line2DRepeat = 0;
pentuModes.Arc3DRepeat = 1;

var generatePENTUAction = function(mode, plane, startPos, startPosSpeed0, startPosSpeed1,
                                   startPosSpeed2, startPosSpeed3, startPosSpeed4, startPosSpeed5,
                                   repeatSpeed, repeateCount, zlength, dirAxis, dirLength, dirSpeed,
                                   dirCount, point1, point2, rotate, rotateSpeed, rotateCount,
                                   fixtureDelay0, fixtureDelay1, fixtureDelay2, rcID, dirCID, rotateCID){


    var f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag0 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag1 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag2 = f.flagID;
    switch(plane){
        case 0:
            if(dirAxis == 0){
                var rpeateAxis = 1;
                var startPos0 = startPos.pos.m1;
                var startPos1 = startPos.pos.m0;
                var startSpeed0 = startPosSpeed1;
                var startSpeed1 = startPosSpeed0;
            }
            else {
                rpeateAxis = 0;
                startPos0 = startPos.pos.m0;
                startPos1 = startPos.pos.m1;
                startSpeed0 = startPosSpeed0;
                startSpeed1 = startPosSpeed1;
            }
            var deepAxis = 2;
            var startPos2 = startPos.pos.m2;
            var startSpeed2 = startPosSpeed2;
            break;
        case 1:
            if(dirAxis == 0){
                rpeateAxis = 2;
                startPos0 = startPos.pos.m1;
                startPos2 = startPos.pos.m0;
                startSpeed0 = startPosSpeed1;
                startSpeed2 = startPosSpeed0;
            }
            else {
                rpeateAxis = 0;
                startPos0 = startPos.pos.m0;
                startPos2 = startPos.pos.m1;
                startSpeed0 = startPosSpeed0;
                startSpeed2 = startPosSpeed1;
            }
            deepAxis = 1;
            startPos1 = startPos.pos.m2;
            startSpeed1 = startPosSpeed2;
            break;
        case 2:
            if(dirAxis == 1){
                rpeateAxis = 2;
                startPos1 = startPos.pos.m1;
                startPos2 = startPos.pos.m0;
                startSpeed1 = startPosSpeed1;
                startSpeed2 = startPosSpeed0;
            }
            else {
                rpeateAxis = 1;
                startPos1 = startPos.pos.m0;
                startPos2 = startPos.pos.m1;
                startSpeed1 = startPosSpeed0;
                startSpeed2 = startPosSpeed1;
            }
            deepAxis = 0;
            startPos0 = startPos.pos.m2;
            startSpeed0 = startPosSpeed2;
            break;
    }

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
        "dirAxis":dirAxis,
        "dirLength":dirLength,
        "dirSpeed":dirSpeed,
        "dirCount":dirCount,
        "dirCounterID":dirCID,
        "point1":point1,
        "point2":point2,
        "rotate":rotate,
        "rotateSpeed":rotateSpeed,
        "rotateCounterID":rotateCID,
        "flag0":flag0,
        "flag1":flag1,
        "flag2":flag2,
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
        "fixtureDelay2":fixtureDelay2
    };
}

var pentuActionToStringHandler = function(actionObject){
    var mode = actionObject.mode;
    var ret = "";
    if(mode == pentuModes.singleAxisRepeat)
        ret += qsTr("SingleAxisRepeat");
    ret += " ";
    if(actionObject.plane == 0)
        ret += "XY " + qsTr("Plane");
    else if(actionObject.plane == 1)
        ret += "XZ " + qsTr("Plane");
    else if(actionObject.plane == 2)
        ret += "YZ " + qsTr("Plane");
    ret += " ";
    ret += qsTr("Start Pos:") + pointToString(actionObject.startPos) + "\n                            ";
    ret += qsTr("Repeate Pos:") + pointToString(actionObject.point1) + " " +
            qsTr("Repeate Speed:") + actionObject.repeateSpeed + " " +
            qsTr("Repeate ") + actionObject.repeateCount + "Times" + "\n                            " +
            axisInfos[actionObject.dirAxis].name + qsTr("Dir Length:") + actionObject.dirLength + " " +
            qsTr("Dir Speed:") + actionObject.dirSpeed + " " +
            qsTr("Dir") + actionObject.dirCount + "Times";
    return ret;
}
