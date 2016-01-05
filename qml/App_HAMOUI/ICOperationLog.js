.pragma library

Qt.include("../utils/Storage.js")
Qt.include("ShareData.js")
Qt.include("../utils/utils.js")
Qt.include("configs/ConfigDefines.js")
Qt.include("../utils/stringhelper.js")

function ICOperationLog(){
    this.model = null;
    this.mapViewModel = function(model){
        this.model = model;
        var ops = oplog();
        var t = new Date();
        for(var i = 0; i < ops.length; ++i){
            t.setTime(ops[i].opTime);
            ops[i].opTime = formatDate(t, "yyyy/MM/dd hh:mm:ss");
            this.model.append(ops[i]);
        }
    }
    this.appendOperationLog = function(logText){
        var now = new Date();
        var opItem = new OperationLogItem(0,
                                          formatDate(now, "yyyy/MM/dd hh:mm:ss"),
                                          UserInfo.currentUser(),
                                          logText);
        opItem = appendOpToLog(opItem);
        this.model.insert(0, opItem);
        if(this.model.count > OPERATION_LOG_TB_INFO.max){
            this.model.remove(operationLogModel.count - 1);
        }
    }

    this.appendNumberConfigOperationLog = function(addr, newV, oldV){
        var logText = icStrformat(qsTr("{0} from {1} to {2}"),
                                  getConfigDescr(addr),
                                  oldV, newV);
        this.appendOperationLog(logText);
    }
}

var opLog = new ICOperationLog();
