.pragma library

function externalDataToString(data){
    return "motor0:" + data.motor0 + " motor1:" + data.motor1 + " motor2:" + data.motor2 +
            " motor3:" + data.motor3 + " motor4:" + data.motor4 + " motor5:" + data.motor5;
}

function ExternalDataPosFormat(){
    this.motor0 = 0;
    this.motor1 = 0;
    this.motor2 = 0;
    this.motor3 = 0;
    this.motor4 = 0;
    this.motor5 = 0;
}

var DataSource = {
    createNew : function(name, hostID){
        var dataSource = {};
        dataSource.name = name;
        dataSource.hostID = hostID;
        dataSource.getName = function() { return dataSource.name;};
        dataSource.getHostID = function() { return dataSource.hostID;};
        return dataSource;
    }
}

var CamDataSource = {
    createNew : function(name, hostID){
        var camDS = DataSource.createNew(name, hostID);
        camDS.parse = function(dsData){
            var ret = [];
            if(!(dsData instanceof Array)){
                return ret;
            }
            var d;
            var posDatas = [];
            var pos;
            for(var i = 0; i < dsData.length; ++i){
                d = dsData[i];
                if(d.hasOwnProperty("data")){
                    posDatas = d.data;
                    for(var j = 0; j < posDatas.length; ++j){
                        pos = posDatas[j];
                        var toAdd = new ExternalDataPosFormat();
                        if(pos.hasOwnProperty("X"))
                            toAdd.motor0 = pos.X;
                        if(pos.hasOwnProperty("Y"))
                            toAdd.motor1 = pos.Y;
                        if(pos.hasOwnProperty("Angel"))
                            toAdd.motor5 = pos.Angel;
                        ret.push(toAdd);

                    }
                }
            }
            return ret;
        };
        return camDS;
    }
}

function ExternalDataManager(){
    this.dataSources = {};
    this.dataSourceExist = function(dsID){
        return this.dataSources.hasOwnProperty(dsID);
    };

    this.registerDataSource = function(dsID, ds){
        if(this.dataSourceExist(dsID))
            return false;
        this.dataSources[dsID] = ds;
        return true;
    };
    this.parse = function(jsonStr){
        console.log(jsonStr);
        var o = JSON.parse(jsonStr);
        if(!this.dataSourceExist(o.dsID)){
            return [];
        }
        return this.dataSources[o.dsID].parse(o.dsData)
    };

    this.dataSourceNameList = function(){
        var ret = [];
        for(var d in this.dataSources){
            ret.push(d + "::" + this.dataSources[d].getName() + "::[HID:" + this.dataSources[d].getHostID() + "]");
        }
        return ret;

    };

    this.getDSIDFromDisplayName = function(displayName){
        return displayName.split("::")[0];
    };

    this.getDataSource = function(dsID){
        return this.dataSourceExist(dsID) ? this.dataSources[dsID] : null;
    };
}

var externalDataManager = new ExternalDataManager();
externalDataManager.registerDataSource("www.geforcevision.com.cam", CamDataSource.createNew("GeforceVision-Cam", 100));
