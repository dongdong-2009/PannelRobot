.pragma library

function ExternalDataPosFormat(){
    this.motor0 = 0;
    this.motor1 = 0;
    this.motor2 = 0;
    this.motor3 = 0;
    this.motor4 = 0;
    this.motor5 = 0;
}

var DataSource = {
    createNew : function(name){
        var dataSource = {};
        dataSource.name = name;
        dataSource.getName = function() { return dataSource.name;};
        return dataSource;
    }
}

var CamDataSource = {
    createNew : function(name){
        var camDS = DataSource.createNew("Cam_DS" + name);
        camDS.parse = function(object){
            var d = JSON.parse(jsonStr);
        };
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
        return this.dataSources[o.dsID].parse(o.data)
    }
}

var externalDataManager = new ExternalDataManager();
