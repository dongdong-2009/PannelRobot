.pragma library

Qt.include("../teach/Teach.js")
actions.F_CMD_PENTU = 70000;

//var baseHasCounterIDAction = hasCounterIDAction();
//hasCounterIDAction = function(action){
//    if(action.action == actions.F_CMD_PENTU)
//        return true;
//    return baseHasCounterIDAction(action);
//}

var pentuModes = {

}
pentuModes.singleAxisRepeat = 0;

var generatePENTUAction = function(mode, plane, startPos,
                                   repeatSpeed, repeateCount,
                                   dirAxis, dirLength, dirSpeed, dirCount,
                                   point1, point2){
    var rcID = 0;
    var dirCID = 0;
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
        "point2":point2
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
    ret += qsTr("Start Pos:") + pointToString(actionObject.startPos) + "\n";
    return ret;
}
