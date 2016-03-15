.pragma library

Qt.include("Teach.js")


WorkerScript.onMessage = function(msg) {
    var programModel = msg.model;
    var cM = programModel;
    for(var i = 0; i < cM.count; ++i){
        console.log("iws",i, cM.get(i).mI_ActionType);
    }
    var l = programModel.count;
    var start = start || 0;
    var  end = end || l;

    if(start >= l || end > l)
        return;
    var step;
    var at;
    var isSyncStart = false;
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
        programModel.setProperty(i, "mI_ActionType", at);
    }
    msg.model.sync();
    WorkerScript.sendMessage({ 'model': "finshed"});
}
