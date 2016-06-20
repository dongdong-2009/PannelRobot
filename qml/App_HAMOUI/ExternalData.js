.pragma library

function externalDataToString(data){
    return "m0:" + data.m0 + " m1:" + data.m1 + " m2:" + data.m2 +
            " m3:" + data.m3 + " m4:" + data.m4 + " m5:" + data.m5;
}

function ExternalDataPosFormat(){
    this.m0 = 0;
    this.m1 = 0;
    this.m2 = 0;
    this.m3 = 0;
    this.m4 = 0;
    this.m5 = 0;
}

function RawExternalDataFormat(dsID, dsData){
    this.dsID = dsID;
    this.dsData = dsData;
}

var DataSource = {
    createNew : function(name, hostID){
        var dataSource = {};
        dataSource.name = name;
        dataSource.hostID = hostID;
        dataSource.getName = function() { return dataSource.name;};
        dataSource.getHostID = function() { return dataSource.hostID;};
        dataSource.type = 0;
        return dataSource;
    }
}

var CamDataSource = {
    createNew : function(name, hostID){
        var camDS = DataSource.createNew(name, hostID);
        camDS.parse = function(dsData){
            var ret = {"hostID":hostID};
            var retData = [];
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
                            toAdd.m0 = parseFloat(pos.X);
                        if(pos.hasOwnProperty("Y"))
                            toAdd.m1 = parseFloat(pos.Y);
                        if(pos.hasOwnProperty("Angel"))
                            toAdd.m5 = parseFloat(pos.Angel);
                        if(pos.X != null && pos.Y != null && pos.Angel != null)
                            retData.push(toAdd);
                    }
                }
            }
            ret.dsData = retData;
            return ret;
        };
        return camDS;
    }
}

var CustomDataSource = {
    createNew : function(name, hostID){
        var customDS = DataSource.createNew(name, hostID);
        customDS.type = 1;
        customDS.parse = function(dsData){
            var ret = {"hostID":hostID};
            var retData = [];
            var tmp;
            for(var i = 0; i < dsData.length; ++i){
                tmp = dsData[i].pointPos;
                retData.push({"m0":parseFloat(tmp.m0),
                             "m1":parseFloat(tmp.m1),
                             "m2":parseFloat(tmp.m2),
                             "m3":parseFloat(tmp.m3),
                             "m4":parseFloat(tmp.m4),
                             "m5":parseFloat(tmp.m5)});
            }
            ret.dsData = retData;
            return ret;

        };
        return customDS;
    }
}

function ExternalDataManager(){
    this.dataSources = {};
    this.dataSourceExist = function(dsID){
        return this.dataSources.hasOwnProperty(dsID);
    };

    this.registerDataSource = function(dsID, ds){
        console.log("registerDataSource", dsID)
        if(this.dataSourceExist(dsID))
            return false;
        this.dataSources[dsID] = ds;
        return true;
    };
    this.parse = function(jsonStr){
        var o = JSON.parse(jsonStr);
        return this.parseRaw(o);
    };

    this.parseRaw = function(rawData){
        if(!this.dataSourceExist(rawData.dsID)){
            return [];
        }
        return this.dataSources[rawData.dsID].parse(rawData.dsData);
    }

    this.dataSourceNameList = function(){
        var ret = [];
        for(var d in this.dataSources){
            if(this.dataSources[d].type != 1)
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

    this.getDataSourceHostIDByDisplayName = function(displayName){
        var dsID = this.getDSIDFromDisplayName(displayName);
        return this.getDataSource(dsID).getHostID();
    }
}

var externalDataManager = new ExternalDataManager();
externalDataManager.registerDataSource("www.geforcevision.com.cam", CamDataSource.createNew("GeforceVision-Cam", 100));
