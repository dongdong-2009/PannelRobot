var changedData = [];
function changeX1Dir(uiIndex, id, dir){
    if(!(uiIndex in changedData)){
        changedData[uiIndex] = {};
    }
    changedData[uiIndex].x1Dir = dir;
    changedData[uiIndex].id = id;
}

function changeX2Dir(uiIndex, id, dir){
    if(!(uiIndex in changedData)){
        changedData[uiIndex] = {};
    }
    changedData[uiIndex].x2Dir = dir;
    changedData[uiIndex].id = id;
}

function changeTime(uiIndex, id, time){
    if(!(uiIndex in changedData)){
        changedData[uiIndex] = {};
    }
    changedData[uiIndex].time = parseFloat(time);
    changedData[uiIndex].id = id;
}
