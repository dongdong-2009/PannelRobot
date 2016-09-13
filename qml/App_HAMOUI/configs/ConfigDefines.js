.pragma library

var MAX_UINT_16 = 65536;
var MAX_UINT_32 = 2147483647;
var MAX_INT_16 = 32767;
var MIN_INT_16 = -32767;
var MAX_INT_32 = 2147483647;
var MIN_INT_32 = -2147483647;

var configRanges = {
    "m_rw_0_16_0_0":[-100, 100],
    "m_rw_0_16_0_1":[2, 200],
    "m_rw_0_16_0_2":["m_rw_0_16_0_0", "m_rw_0_16_0_1"],
    "m_rw_0_16_0_16":[0, MAX_UINT_16],
    "s_rw_0_16_1_294":[0, 100], //m0 manual speed
    "s_rw_16_16_1_294":[0, 100], //m1 manual speed
    "s_rw_0_16_1_295":[0, 100], //m2 manual speed
    "s_rw_16_16_1_295":[0, 100], //m3 manual speed
    "s_rw_0_16_1_296":[0, 100], //m4 manual speed
    "s_rw_16_16_1_296":[0, 100], //m5 manual speed
    "s_rw_0_16_1_297":[0, 100], //m6 manual speed
    "s_rw_16_16_1_297":[0, 100], //m7 manual speed
    "s_rw_0_32_1_212":[0, 100], //manual speed
//    "s_rw_0_16_1_265":[0, 100], //auto speed
    "s_rw_0_16_0_102":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_102":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_109":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_109":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_116":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_116":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_123":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_123":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_130":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_130":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_137":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_137":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_107":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_107":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_114":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_114":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_121":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_121":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_128":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_128":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_16_0_135":[MIN_INT_16, MAX_INT_16],
    "s_rw_16_16_0_135":[MIN_INT_16, MAX_INT_16],
    "s_rw_0_32_0_181":[0, MAX_UINT_16],
    "s_rw_0_32_3_1000":["s_rw_16_16_0_102", "s_rw_0_16_0_102"],
    "s_rw_0_32_3_1001":["s_rw_16_16_0_109", "s_rw_0_16_0_109"],
    "s_rw_0_32_3_1002":["s_rw_16_16_0_116", "s_rw_0_16_0_116"],
    "s_rw_0_32_3_1003":["s_rw_16_16_0_123", "s_rw_0_16_0_123"],
    "s_rw_0_32_3_1004":["s_rw_16_16_0_130", "s_rw_0_16_0_130"],
    "s_rw_0_32_3_1005":["s_rw_16_16_0_137", "s_rw_0_16_0_137"],
    "s_rw_0_32_3_1006":["s_rw_16_16_0_144", "s_rw_0_16_0_144"],
    "s_rw_0_32_3_1007":["s_rw_16_16_0_151", "s_rw_0_16_0_151"],
    "s_rw_0_32_2_1100":[0, 600],
    "s_rw_0_32_1_1200":[0, 100],
    "s_rw_0_32_1_1201":[0, 600000], //IO Teach delay
    "s_rw_0_32_3_1300":[MIN_INT_32, MAX_INT_32], //Path limit
    "s_rw_0_32_3_1301":[0, MAX_UINT_32], //Path limit
    "s_rw_0_32_0_1400":[0, MAX_UINT_32], // count
    "s_rw_12_6_0_103":[1, 60], // origin spd
    "s_rw_12_6_0_110":[1, 60], // origin spd
    "s_rw_12_6_0_117":[1, 60], // origin spd
    "s_rw_12_6_0_124":[1, 30], // origin spd
    "s_rw_12_6_0_131":[1, 30], // origin spd
    "s_rw_12_6_0_138":[1, 30], // origin spd
    "s_rw_12_6_0_145":[1, 30], // origin spd
    "s_rw_12_6_0_152":[1, 30], // origin spd
    "m_rw_0_32_1_214":[0, 10], // analog range
    "m_rw_0_32_1_215":[0, 10], // analog range
    "m_rw_0_32_1_216":[0, 10], // analog range
    "m_rw_0_32_1_217":[0, 10], // analog range
    "m_rw_0_32_1_218":[0, 10], // analog range
    "m_rw_0_32_1_219":[0, 10], // analog range

};

var getConfigRange = function(config){
    var r = configRanges[config];
    var items = config.split("_");
    if(r === undefined){
        return {"min":0, "max":Math.pow(2, parseInt(items[3])) - 1, "decimal":parseInt(items[4])};
    }
    return {"min":r[0], "max":r[1], "decimal":parseInt(items[4])};
};

var fncDefaultValues = {
    "m_rw_0_1_0_357": 1,
    "m_rw_1_1_0_357": 1,
    "m_rw_2_1_0_357": 1,
    "m_rw_3_1_0_357": 1,
    "m_rw_4_1_0_357": 1,
    "m_rw_5_1_0_357": 1,
    "m_rw_6_1_0_357": 1,
    "m_rw_7_1_0_357": 1,
    "m_rw_8_1_0_357": 1,
    "m_rw_9_23_0_357": 0
};

var configStr = {};

function getConfigDescr (addr){
    if(addr in configStr)
        return configStr[addr];
    return addr;
}

var machineStructConfigs = [
            "s_rw_0_32_3_100",
            "s_rw_0_16_0_101",
            "s_rw_16_16_2_101",
            "s_rw_0_16_0_102",
            "s_rw_16_16_0_102",
            "s_rw_0_4_0_103",
            "s_rw_4_4_0_103",
            "s_rw_8_4_0_103",
            "s_rw_12_6_0_103",
            "s_rw_18_1_0_103",
            "s_rw_19_6_0_103",
            "s_rw_25_6_0_103",
            "s_rw_31_1_0_103",
            "s_rw_0_8_0_104",
            "s_rw_8_8_0_104",
            "s_rw_16_8_0_104",
            "s_rw_24_4_0_104",
            "s_rw_28_1_0_104",
            "s_rw_29_1_0_104",
            "s_rw_30_1_0_104",
            "s_rw_31_1_0_104",
            "s_rw_0_6_0_105",
            "s_rw_6_6_0_105",
            "s_rw_12_4_0_105",
            "s_rw_16_16_1_105",
            "s_rw_0_16_3_106",
            "s_rw_16_16_3_106",
            "s_rw_0_32_3_107",
            "s_rw_0_16_0_108",
            "s_rw_16_16_2_108",
            "s_rw_0_16_0_109",
            "s_rw_16_16_0_109",
            "s_rw_0_4_0_110",
            "s_rw_4_4_0_110",
            "s_rw_8_4_0_110",
            "s_rw_12_6_0_110",
            "s_rw_18_1_0_110",
            "s_rw_19_6_0_110",
            "s_rw_25_6_0_110",
            "s_rw_31_1_0_110",
            "s_rw_0_8_0_111",
            "s_rw_8_8_0_111",
            "s_rw_16_8_0_111",
            "s_rw_24_4_0_111",
            "s_rw_28_1_0_111",
            "s_rw_29_1_0_111",
            "s_rw_30_1_0_111",
            "s_rw_31_1_0_111",
            "s_rw_0_6_0_112",
            "s_rw_6_6_0_112",
            "s_rw_12_4_0_112",
            "s_rw_16_16_1_112",
            "s_rw_0_16_3_113",
            "s_rw_16_16_3_113",
            "s_rw_0_32_3_114",
            "s_rw_0_16_0_115",
            "s_rw_16_16_2_115",
            "s_rw_0_16_0_116",
            "s_rw_16_16_0_116",
            "s_rw_0_4_0_117",
            "s_rw_4_4_0_117",
            "s_rw_8_4_0_117",
            "s_rw_12_6_0_117",
            "s_rw_18_1_0_117",
            "s_rw_19_6_0_117",
            "s_rw_25_6_0_117",
            "s_rw_31_1_0_117",
            "s_rw_0_8_0_118",
            "s_rw_8_8_0_118",
            "s_rw_16_8_0_118",
            "s_rw_24_4_0_118",
            "s_rw_28_1_0_118",
            "s_rw_29_1_0_118",
            "s_rw_30_1_0_118",
            "s_rw_31_1_0_118",
            "s_rw_0_6_0_119",
            "s_rw_6_6_0_119",
            "s_rw_12_4_0_119",
            "s_rw_16_16_1_119",
            "s_rw_0_16_3_120",
            "s_rw_16_16_3_120",
            "s_rw_0_32_3_121",
            "s_rw_0_16_0_122",
            "s_rw_16_16_2_122",
            "s_rw_0_16_0_123",
            "s_rw_16_16_0_123",
            "s_rw_0_4_0_124",
            "s_rw_4_4_0_124",
            "s_rw_8_4_0_124",
            "s_rw_12_6_0_124",
            "s_rw_18_1_0_124",
            "s_rw_19_6_0_124",
            "s_rw_25_6_0_124",
            "s_rw_31_1_0_124",
            "s_rw_0_8_0_125",
            "s_rw_8_8_0_125",
            "s_rw_16_8_0_125",
            "s_rw_24_4_0_125",
            "s_rw_28_1_0_125",
            "s_rw_29_1_0_125",
            "s_rw_30_1_0_125",
            "s_rw_31_1_0_125",
            "s_rw_0_6_0_126",
            "s_rw_6_6_0_126",
            "s_rw_12_4_0_126",
            "s_rw_16_16_1_126",
            "s_rw_0_16_3_127",
            "s_rw_16_16_3_127",
            "s_rw_0_32_3_128",
            "s_rw_0_16_0_129",
            "s_rw_16_16_2_129",
            "s_rw_0_16_0_130",
            "s_rw_16_16_0_130",
            "s_rw_0_4_0_131",
            "s_rw_4_4_0_131",
            "s_rw_8_4_0_131",
            "s_rw_12_6_0_131",
            "s_rw_18_1_0_131",
            "s_rw_19_6_0_131",
            "s_rw_25_6_0_131",
            "s_rw_31_1_0_131",
            "s_rw_0_8_0_132",
            "s_rw_8_8_0_132",
            "s_rw_16_8_0_132",
            "s_rw_24_4_0_132",
            "s_rw_28_1_0_132",
            "s_rw_29_1_0_132",
            "s_rw_30_1_0_132",
            "s_rw_31_1_0_132",
            "s_rw_0_6_0_133",
            "s_rw_6_6_0_133",
            "s_rw_12_4_0_133",
            "s_rw_16_16_1_133",
            "s_rw_0_16_3_134",
            "s_rw_16_16_3_134",
            "s_rw_0_32_3_135",
            "s_rw_0_16_0_136",
            "s_rw_16_16_2_136",
            "s_rw_0_16_0_137",
            "s_rw_16_16_0_137",
            "s_rw_0_4_0_138",
            "s_rw_4_4_0_138",
            "s_rw_8_4_0_138",
            "s_rw_12_6_0_138",
            "s_rw_18_1_0_138",
            "s_rw_19_6_0_138",
            "s_rw_25_6_0_138",
            "s_rw_31_1_0_138",
            "s_rw_0_8_0_139",
            "s_rw_8_8_0_139",
            "s_rw_16_8_0_139",
            "s_rw_24_4_0_139",
            "s_rw_28_1_0_139",
            "s_rw_29_1_0_139",
            "s_rw_30_1_0_139",
            "s_rw_31_1_0_139",
            "s_rw_0_6_0_140",
            "s_rw_6_6_0_140",
            "s_rw_12_4_0_140",
            "s_rw_16_16_1_140",
            "s_rw_0_16_3_141",
            "s_rw_16_16_3_141",
            "s_rw_0_32_3_142",
            "s_rw_0_16_0_143",
            "s_rw_16_16_2_143",
            "s_rw_0_16_0_144",
            "s_rw_16_16_0_144",
            "s_rw_0_4_0_145",
            "s_rw_4_4_0_145",
            "s_rw_8_4_0_145",
            "s_rw_12_6_0_145",
            "s_rw_18_1_0_145",
            "s_rw_19_6_0_145",
            "s_rw_25_6_0_145",
            "s_rw_31_1_0_145",
            "s_rw_0_8_0_146",
            "s_rw_8_8_0_146",
            "s_rw_16_8_0_146",
            "s_rw_24_4_0_146",
            "s_rw_28_1_0_146",
            "s_rw_29_1_0_146",
            "s_rw_30_1_0_146",
            "s_rw_31_1_0_146",
            "s_rw_0_6_0_147",
            "s_rw_6_6_0_147",
            "s_rw_12_4_0_147",
            "s_rw_16_16_1_147",
            "s_rw_0_16_3_148",
            "s_rw_16_16_3_148",
            "s_rw_0_32_3_149",
            "s_rw_0_16_0_150",
            "s_rw_16_16_2_150",
            "s_rw_0_16_0_151",
            "s_rw_16_16_0_151",
            "s_rw_0_4_0_152",
            "s_rw_4_4_0_152",
            "s_rw_8_4_0_152",
            "s_rw_12_6_0_152",
            "s_rw_18_1_0_152",
            "s_rw_19_6_0_152",
            "s_rw_25_6_0_152",
            "s_rw_31_1_0_152",
            "s_rw_0_8_0_153",
            "s_rw_8_8_0_153",
            "s_rw_16_8_0_153",
            "s_rw_24_4_0_153",
            "s_rw_28_1_0_153",
            "s_rw_29_1_0_153",
            "s_rw_30_1_0_153",
            "s_rw_31_1_0_153",
            "s_rw_0_6_0_154",
            "s_rw_6_6_0_154",
            "s_rw_12_4_0_154",
            "s_rw_16_16_1_154",
            "s_rw_0_16_3_155",
            "s_rw_16_16_3_155",
            "s_rw_0_32_3_156",
            "s_rw_0_32_3_157",
            "s_rw_0_32_3_158",
            "s_rw_0_32_3_159",
            "s_rw_0_32_3_160",
            "s_rw_0_32_3_161",
            "s_rw_0_32_3_162",
            "s_rw_0_32_3_163",
            "s_rw_0_32_3_164",
            "s_rw_0_8_0_165",
            "s_rw_8_8_0_165",
            "s_rw_16_8_0_165",
            "s_rw_24_8_0_165",
            "s_rw_0_16_3_166",
            "s_rw_16_16_3_166",
            "s_rw_0_16_3_167",
            "s_rw_16_16_0_167",
            "s_rw_0_32_3_168",
            "s_rw_0_32_3_169",
            "s_rw_0_32_3_170",
            "s_rw_0_32_3_171",
            "s_rw_0_32_3_172",
            "s_rw_0_32_3_173",
            "s_rw_0_32_3_174",
            "s_rw_0_32_3_175",
            "s_rw_0_8_0_176",
            "s_rw_8_24_0_176",
            "s_rw_0_32_0_177",
            "s_rw_0_32_0_178",
            "s_rw_0_32_0_179",
            "s_rw_0_32_0_180",
            "s_rw_0_32_0_181",
            "s_rw_0_32_0_182",
            "s_rw_0_32_0_183",
            "s_rw_0_16_0_184",
            "s_rw_16_6_0_184",
            "s_rw_22_2_0_184",
            "s_rw_24_8_0_184"
        ];
var machineStructConfigsJSON = JSON.stringify(machineStructConfigs);

var multiplexingConfigAddrs = {
    "ICAddr_Common_Para0":0, //<类型:状态;名字:查询当前周期运行时间;结构:CYCLE_TIME;
    "ICAddr_Common_Para1":1,//<类型:状态;名字:查询上周期运行时间;结构:CYCLE_TIME;
    "ICAddr_Common_Para2":2,
    "ICAddr_Common_Para3":3,
    "ICAddr_Common_Para4":4,
    "ICAddr_Common_Para5":5,
    "ICAddr_Common_Para6":6,
    "ICAddr_Common_Para7":7,
    "ICAddr_Common_Para8":8,
    "ICAddr_Common_Para9":9
};
