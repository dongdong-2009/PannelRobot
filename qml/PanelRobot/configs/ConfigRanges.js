.pragma library

var configRanges = {
    "m_rw_0_16_0_0":[-100, 100],
    "m_rw_0_16_0_1":[2, 200],
    "m_rw_0_16_0_2":["m_rw_0_16_0_0", "m_rw_0_16_0_1"]
};

var getConfigRange = function(config){
    var r = configRanges[config];
    if(r === undefined){
        return undefined;
    }
    var items = config.split("_");
    return {"min":r[0], "max":r[1], "decimal":parseInt(items[4])};
};
