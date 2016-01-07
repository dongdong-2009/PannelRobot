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

    function onConfigValueEditFinished(index){
        var config = PData.configs[index];
        var oldV = panelRobotController.getConfigValueText(config.configAddr);
        panelRobotController.setConfigValue(config.configAddr, config.configValue);
        if(!isCache){
            panelRobotController.syncConfigs();
        }
        configValueChanged(config.configAddr, config.configValue, oldV);

    }

    function needToUpdateConfigs(){
        var count = PData.configs.length;
        var config;
        var handlers = PData.handlers;
        for(var i = 0; i < count; ++i){
            config = PData.configs[i];
            config.configValueChanged.disconnect(handlers[i]);
            config.configValue = panelRobotController.getConfigValueText(config.configAddr);
            config.configValueChanged.connect(handlers[i]);
        }
    }

    onVisibleChanged: {
        if(!visible && isCache){
            panelRobotController.syncConfigs();
        }

        //        console.log(visible)
        //        if(!pData.isLoaded) return;
        //        var count = pData.configs.length;
        //        var config;
        //        var handlers = Impl.handlers;
        //        var i;
        //        if(visible){
        //            for(i = 0; i < count; ++i){
        //                config = pData.configs[i];
        //                config.configValue = panelRobotController.getConfigValue(config.configAddr);
        //                config.configValueChanged.connect(handlers[i]);
        //            }
        //        }
        //        else{
        //            for(i = 0; i < count; ++i){
        //                config = pData.configs[i];
        //                config.configValueChanged.disconnect(handlers[i]);
        //            }
        //            panelRobotController.syncConfigs();
        //        }
    }
    Component.onCompleted: {
        //        var count = children.length;
        //        var cs = [];
        //        var config;
        //        var l;
        //        for(var i = 0; i < count; ++i){
        //            config = children[i];
        //            if(config.hasOwnProperty("configValue")){
        //                l = cs.length;
        //                cs.push(config);
        //                console.log(config.configAddr)
        //                var fun = function(){
        //                    onConfigValueChanged(l);
        //                };
        //                Impl.handlers.push(fun);
        //                config.configValueChanged.connect(fun);
        //            }
        //        }
        //        pData.configs = cs;
        PData.deepFindFitItem(container)
        PData.isLoaded = true;
        panelRobotController.moldChanged.connect(needToUpdateConfigs)
        needToUpdateConfigs();
    }

}
