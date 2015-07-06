.pragma library

var IO_TYPE_INPUT  = 0;
var IO_TYPE_OUTPUT = 1;

var IODefine = function(pointName, descr)
{
    this.pointName = pointName;
    this.descr = descr;
}

var yDefines = [
            new IODefine("Y010", {"ch":"Y010", "en":"Y010"}),
            new IODefine("Y011", {"ch":"Y011", "en":"Y011"}),
            new IODefine("Y012", {"ch":"Y012", "en":"Y012"}),
            new IODefine("Y013", {"ch":"Y013", "en":"Y013"}),
            new IODefine("Y014", {"ch":"Y014", "en":"Y014"}),
            new IODefine("Y015", {"ch":"Y015", "en":"Y015"}),
            new IODefine("Y016", {"ch":"Y016", "en":"Y016"}),
            new IODefine("Y017", {"ch":"Y017", "en":"Y017"}),
            new IODefine("Y020", {"ch":"Y020", "en":"Y020"}),
            new IODefine("Y021", {"ch":"Y021", "en":"Y021"}),
            new IODefine("Y022", {"ch":"Y022", "en":"Y022"}),
            new IODefine("Y023", {"ch":"Y023", "en":"Y023"}),
            new IODefine("Y024", {"ch":"Y024", "en":"Y024"}),
            new IODefine("Y025", {"ch":"Y025", "en":"Y025"}),
            new IODefine("Y026", {"ch":"Y026", "en":"Y026"}),
            new IODefine("Y027", {"ch":"Y027", "en":"Y027"}),
            new IODefine("Y030", {"ch":"Y030", "en":"Y030"}),
            new IODefine("Y031", {"ch":"Y031", "en":"Y031"}),
            new IODefine("Y032", {"ch":"Y032", "en":"Y032"}),
            new IODefine("Y033", {"ch":"Y033", "en":"Y033"}),
            new IODefine("Y034", {"ch":"Y034", "en":"Y034"}),
            new IODefine("Y035", {"ch":"Y035", "en":"Y035"}),
            new IODefine("Y036", {"ch":"Y036", "en":"Y036"}),
            new IODefine("Y037", {"ch":"Y037", "en":"Y037"}),
            new IODefine("Y040", {"ch":"Y040", "en":"Y040"}),
            new IODefine("Y041", {"ch":"Y041", "en":"Y041"}),
            new IODefine("Y042", {"ch":"Y042", "en":"Y042"}),
            new IODefine("Y043", {"ch":"Y043", "en":"Y043"}),
            new IODefine("Y044", {"ch":"Y044", "en":"Y044"}),
            new IODefine("Y045", {"ch":"Y045", "en":"Y045"}),
            new IODefine("Y046", {"ch":"Y046", "en":"Y046"}),
            new IODefine("Y047", {"ch":"Y047", "en":"Y047"}),
];

var xDefines = [
            new IODefine("X010", {"ch":"X010", "en":"X010"}),
            new IODefine("X011", {"ch":"X011", "en":"X011"}),
            new IODefine("X012", {"ch":"X012", "en":"X012"}),
            new IODefine("X013", {"ch":"X013", "en":"X013"}),
            new IODefine("X014", {"ch":"X014", "en":"X014"}),
            new IODefine("X015", {"ch":"X015", "en":"X015"}),
            new IODefine("X016", {"ch":"X016", "en":"X016"}),
            new IODefine("X017", {"ch":"X017", "en":"X017"}),
            new IODefine("X020", {"ch":"X020", "en":"X020"}),
            new IODefine("X021", {"ch":"X021", "en":"X021"}),
            new IODefine("X022", {"ch":"X022", "en":"X022"}),
            new IODefine("X023", {"ch":"X023", "en":"X023"}),
            new IODefine("X024", {"ch":"X024", "en":"X024"}),
            new IODefine("X025", {"ch":"X025", "en":"X025"}),
            new IODefine("X026", {"ch":"X026", "en":"X026"}),
            new IODefine("X027", {"ch":"X027", "en":"X027"}),
            new IODefine("X030", {"ch":"X030", "en":"X030"}),
            new IODefine("X031", {"ch":"X031", "en":"X031"}),
            new IODefine("X032", {"ch":"X032", "en":"X032"}),
            new IODefine("X033", {"ch":"X033", "en":"X033"}),
            new IODefine("X034", {"ch":"X034", "en":"X034"}),
            new IODefine("X035", {"ch":"X035", "en":"X035"}),
            new IODefine("X036", {"ch":"X036", "en":"X036"}),
            new IODefine("X037", {"ch":"X037", "en":"X037"}),
            new IODefine("X040", {"ch":"X040", "en":"X040"}),
            new IODefine("X041", {"ch":"X041", "en":"X041"}),
            new IODefine("X042", {"ch":"X042", "en":"X042"}),
            new IODefine("X043", {"ch":"X043", "en":"X043"}),
            new IODefine("X044", {"ch":"X044", "en":"X044"}),
            new IODefine("X045", {"ch":"X045", "en":"X045"}),
            new IODefine("X046", {"ch":"X046", "en":"X046"}),
            new IODefine("X047", {"ch":"X047", "en":"X047"}),
            new IODefine("X050", {"ch":"X050", "en":"X050"}),
            new IODefine("X051", {"ch":"X051", "en":"X051"}),
            new IODefine("X052", {"ch":"X052", "en":"X052"}),
            new IODefine("X053", {"ch":"X053", "en":"X053"}),
            new IODefine("X054", {"ch":"X054", "en":"X054"}),
            new IODefine("X055", {"ch":"X055", "en":"X055"}),
            new IODefine("X056", {"ch":"X056", "en":"X056"}),
            new IODefine("X057", {"ch":"X057", "en":"X057"}),
];

var euxDefines = [
            new IODefine("EuX010", {"ch":"EuX010", "en":"EuX010"}),
            new IODefine("EuX011", {"ch":"EuX011", "en":"EuX011"}),
            new IODefine("EuX012", {"ch":"EuX012", "en":"EuX012"}),
            new IODefine("EuX013", {"ch":"EuX013", "en":"EuX013"}),
            new IODefine("EuX014", {"ch":"EuX014", "en":"EuX014"}),
            new IODefine("EuX015", {"ch":"EuX015", "en":"EuX015"}),
            new IODefine("EuX016", {"ch":"EuX016", "en":"EuX016"}),
            new IODefine("EuX017", {"ch":"EuX017", "en":"EuX017"}),
            new IODefine("EuX020", {"ch":"EuX020", "en":"EuX020"}),
            new IODefine("EuX021", {"ch":"EuX021", "en":"EuX021"}),
            new IODefine("EuX022", {"ch":"EuX022", "en":"EuX022"}),
            new IODefine("EuX023", {"ch":"EuX023", "en":"EuX023"}),
            new IODefine("EuX024", {"ch":"EuX024", "en":"EuX024"}),
            new IODefine("EuX025", {"ch":"EuX025", "en":"EuX025"}),
            new IODefine("EuX026", {"ch":"EuX026", "en":"EuX026"}),
            new IODefine("EuX027", {"ch":"EuX027", "en":"EuX027"}),
];

var euyDefines = [
            new IODefine("EuY010", {"ch":"EuY010", "en":"EuY010"}),
            new IODefine("EuY011", {"ch":"EuY011", "en":"EuY011"}),
            new IODefine("EuY012", {"ch":"EuY012", "en":"EuY012"}),
            new IODefine("EuY013", {"ch":"EuY013", "en":"EuY013"}),
            new IODefine("EuY014", {"ch":"EuY014", "en":"EuY014"}),
            new IODefine("EuY015", {"ch":"EuY015", "en":"EuY015"}),
            new IODefine("EuY016", {"ch":"EuY016", "en":"EuY016"}),
            new IODefine("EuY017", {"ch":"EuY017", "en":"EuY017"}),
            new IODefine("EuY020", {"ch":"EuY020", "en":"EuY020"}),
            new IODefine("EuY021", {"ch":"EuY021", "en":"EuY021"}),
            new IODefine("EuY022", {"ch":"EuY022", "en":"EuY022"}),
            new IODefine("EuY023", {"ch":"EuY023", "en":"EuY023"}),
            new IODefine("EuY024", {"ch":"EuY024", "en":"EuY024"}),
            new IODefine("EuY025", {"ch":"EuY025", "en":"EuY025"}),
            new IODefine("EuY026", {"ch":"EuY026", "en":"EuY026"}),
            new IODefine("EuY027", {"ch":"EuY027", "en":"EuY027"}),
];

var yChecksMap = {
    "Y010": "X010",
    "Y011": "X011"
}

function yCheckedX(y){
    if(!yChecksMap.hasOwnProperty(y)) return -1;
    var xStr = yChecksMap[y];
    for(var i = 0; xDefines.length; ++i){
        if(xDefines[i].pointName == xStr)
            return i;
    }
    return -1;
}

var getYDefineFromPointName = function(pointName){
    var i;
    for(i = 0; i < yDefines.length; ++i){
        if(pointName === yDefines[i].pointName)
            return {"yDefine":yDefines[i], "hwPoint":i};
    }
    for(i = 0; i < euyDefines.length; ++i){
        if(pointName === euyDefines[i].pointName)
            return {"yDefine":euyDefines[i], "hwPoint": i + 32};
    }

    return null;
}

var getXDefineFromPointName = function(pointName){
    var i;
    for(i = 0; i < xDefines.length; ++i){
        if(pointName === xDefines[i].pointName)
            return {"xDefine":xDefines[i], "hwPoint":i};
    }
    for(i = 0; i < euxDefines.length; ++i){
        if(pointName === euxDefines[i].pointName)
            return {"xDefine":euxDefines[i], "hwPoint": i + 32};
    }

    return null;
}
