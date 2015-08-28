.pragma library

function cloneObject(ob) {
    return JSON.parse(JSON.stringify(ob));
}

function getRandomNum(Min,Max)
{
    var Range = Max - Min;
    var Rand = Math.random();
    return(Min + Math.round(Rand * Range));
}
