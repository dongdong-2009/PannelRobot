var handlers = [];
var configs = [];
var isLoaded = false;
function deepFindFitItem(item){
    var l = configs.length;
    if(item.hasOwnProperty("configAddr")){
        console.log("settingscope:",item.configAddr)

        configs.push(item);
        var fun = function(){
            onConfigValueEditFinished(l);
        };
        handlers.push(fun);
        return;
    }
    var itemChildren = item.children;

    var count = itemChildren.length;
    for(var i = 0; i < count; ++i){
        deepFindFitItem(itemChildren[i]);
    }
}
