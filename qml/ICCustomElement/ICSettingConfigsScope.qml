import QtQuick 1.1
import "ICSettingConfigsScope.js" as PData

Item {
    id:container
    property bool isCache: false
    //    QtObject{
    //        id:pData
    //        property variant configs: []
    //        property bool isLoaded: false
    //    }

    signal configValueChanged(string addr, string newV, string oldV)

    function sync(){
        panelRobotController.syncConfigs();
    }

    function onConfigValueEditFinished(index){
        var config = PData.configs[index];
        var oldV = panelRobotController.getConfigValueText(config.configAddr);
        var toSetConfigVal = config.configValue;
        if(config.hasOwnProperty("indexMappedValue"))
        {
            if(config.indexMappedValue.length > 0)
                toSetConfigVal = config.indexMappedValue[toSetConfigVal];
        }

        panelRobotController.setConfigValue(config.configAddr, toSetConfigVal);
        if(!isCache){
            panelRobotController.syncConfigs();
        }
        configValueChanged(config.configAddr, toSetConfigVal, oldV);

    }

    function needToUpdateConfigs(){
        var count = PData.configs.length;
        var config;
        var handlers = PData.handlers;
        var toShowVal;
        for(var i = 0; i < count; ++i){
            config = PData.configs[i];
            config.configValueChanged.disconnect(handlers[i]);
            toShowVal = panelRobotController.getConfigValueText(config.configAddr);
            if(config.hasOwnProperty("indexMappedValue")){
                for(var j = 0, len = config.indexMappedValue.length; j < len; ++j){
                    if(toShowVal == config.indexMappedValue[j]){
                        toShowVal = j;
                        break;
                    }
                }

            }

            config.configValue = toShowVal;
            config.configValueChanged.connect(handlers[i]);
        }
    }

    onVisibleChanged: {
        if(!visible && isCache){
            sync();
        }
    }
    Component.onCompleted: {
        PData.deepFindFitItem(container)
        PData.isLoaded = true;
        panelRobotController.moldChanged.connect(needToUpdateConfigs)
        needToUpdateConfigs();
    }

}
