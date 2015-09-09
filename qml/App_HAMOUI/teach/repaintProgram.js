.pragma library

Qt.include("Teach.js")


WorkerScript.onMessage = function(msg) {
    var l = msg.programModel.count;
    var start = msg.start || 0;
    var end = msg.end || l;

    if(start >= l || end > l)
        return;
    var step;
    var at;
    var isSyncStart = false;
    for(var i = start; i < end; ++i){
        step = msg.programModel.get(i).mI_ActionObject;
        if(step.action === actions.F_CMD_SYNC_START){
            at = actionTypes.kAT_SyncStart;
            isSyncStart = true;
        }
        else if(step.action === actions.F_CMD_SYNC_END){
            at = actionTypes.kAT_SyncEnd;
            isSyncStart = false;
        }
        else
            at = actionTypes.kAT_Normal;
        if(isSyncStart)
            at = actionTypes.kAT_SyncStart;
        msg.programModel.setProperty(i, "mI_ActionType", at);
    }
//    WorkerScript.sendMessage({"programModel":msg.programModel});
    msg.programModel.sync();
//    console.log("repaint finished");
}
