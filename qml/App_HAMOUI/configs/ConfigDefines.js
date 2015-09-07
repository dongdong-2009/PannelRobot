.pragma library

var MAX_UINT_16 = 65536;
var MAX_INT_32 = 2147483647;
var MIN_INT_32 = -2147483647;

var configRanges = {
    "m_rw_0_16_0_0":[-100, 100],
    "m_rw_0_16_0_1":[2, 200],
    "m_rw_0_16_0_2":["m_rw_0_16_0_0", "m_rw_0_16_0_1"],
    "m_rw_0_16_0_16":[0, MAX_UINT_16],
    "s_rw_0_16_3_265":[0, 100],
    "s_rw_0_32_3_103":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_102":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_109":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_110":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_116":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_117":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_123":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_124":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_130":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_131":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_137":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_138":[MIN_INT_32, MAX_INT_32],
    "s_rw_0_32_3_1000":["s_rw_0_32_3_103", "s_rw_0_32_3_102"],
    "s_rw_0_32_3_1001":["s_rw_0_32_3_110", "s_rw_0_32_3_109"],
    "s_rw_0_32_3_1002":["s_rw_0_32_3_117", "s_rw_0_32_3_116"],
    "s_rw_0_32_3_1003":["s_rw_0_32_3_124", "s_rw_0_32_3_123"],
    "s_rw_0_32_3_1004":["s_rw_0_32_3_131", "s_rw_0_32_3_130"],
    "s_rw_0_32_3_1005":["s_rw_0_32_3_138", "s_rw_0_32_3_137"],
    "s_rw_0_32_2_1100":[0, 600],
    "s_rw_0_32_1_1200":[0, 100]

};

var getConfigRange = function(config){
    var r = configRanges[config];
    var items = config.split("_");
    if(r === undefined){
        return {"min":MIN_INT_32, "max":MAX_INT_32, "decimal":parseInt(items[4])};
    }
    return {"min":r[0], "max":r[1], "decimal":parseInt(items[4])};
};

var fncDefaultValues = {
    "m_rw_0_16_0_0":10,
    "m_rw_0_16_0_1":20,
    "m_rw_0_16_0_2":30,
    "m_rw_0_16_0_16":40,
    "m_rw_0_16_1_22":10.5
};
