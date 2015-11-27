.pragma library

var alarmInfo = {
    "1":qsTr("1"),
    "2":qsTr("2"),
    "3":qsTr("3"),
}

function getAlarmDescr(errNum){
    if(alarmInfo.hasOwnProperty(errNum.toString())){
        return alarmInfo[errNum.toString()];
    }
    return "";
}
