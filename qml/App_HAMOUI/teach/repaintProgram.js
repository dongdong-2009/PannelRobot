.pragma library

Qt.include("Teach.js")
//Qt.include("ProgramFlowPage.js")


WorkerScript.onMessage = function(msg) {
    var programModel = msg.model;
    var listIndex = msg.listIndex;
    var programIndex = msg.programIndex;
    var actionObject = msg.actionObject;
    var event = msg.event;

    var l = programModel.count;
    var start = 0;
    var  end = l;

    if(start >= l || end > l)
        return;
    var step;
    var at;
    var isSyncStart = false;
    var toRepaintLine = {}
    for(var i = start; i < end; ++i){
        step = programModel.get(i).mI_ActionObject;
        if(step.action === actions.F_CMD_SYNC_START){
            at = actionTypes.kAT_SyncStart;
            isSyncStart = true;
        }else if(step.action === actions.F_CMD_SYNC_END){
            at = actionTypes.kAT_SyncEnd;
            isSyncStart = false;
        }else if((step.action === actions.ACT_FLAG) ||
                 isJumpAction(step.action)){
            at = actionTypes.kAT_Flag;
        }else
            at = actionTypes.kAT_Normal;
        if(isSyncStart)
            at = actionTypes.kAT_SyncStart;
//        if(programModel.get(i).mI_ActionType !== at)
//            toRepaintLine[i] = at;
        programModel.setProperty(i, "mI_ActionType", at);
        programModel.sync();
    }
    WorkerScript.sendMessage({ 'toRepainLine': toRepaintLine});
}
