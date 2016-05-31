.pragma library

Qt.include("../teach/Teach.js")
Qt.include("../configs/AxisDefine.js")
actions.F_CMD_PENTU = 70000;

var pentuModes = {

}
pentuModes.singleAxisRepeat = 0;

var generatePENTUAction = function(mode, plane, startPos, startPosSpeeds,
                                   repeatSpeed, repeateCount,
                                   dirAxis, dirLength, dirSpeed, dirCount,
                                   point1, point2, rotate, rotateSpeed, rotateCount,
                                   fixtureDelay, rcID, dirCID, rotateCID){


    var f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag0 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag1 = f.flagID;
    f = flagsDefine.createFlag(0, "");
    flagsDefine.pushFlag(0, f);
    var flag2 = f.flagID;
    return {
        "action":actions.F_CMD_PENTU,
        "mode":mode,
        "plane":plane,
        "startPos":startPos,
        "repeateSpeed":repeatSpeed,
        "repeateCount":repeateCount,
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
        "startPosSpeed0":startPosSpeeds[0],
        "startPosSpeed1":startPosSpeeds[1],
        "startPosSpeed2":startPosSpeeds[2],
        "startPosSpeed3":startPosSpeeds[3],
        "startPosSpeed4":startPosSpeeds[4],
        "startPosSpeed5":startPosSpeeds[5],
        "fixtureDelay":fixtureDelay
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
