import QtQuick 1.1

ICConfigEdit {
    id:instance
    width: inputWidth + configNameWidth + plus.x + plus.width
    height: minus.height

    QtObject{
        id:pData
        property variant speedInfo: {"lastTime": new Date(), "changeCount":0}
    }

    function endAnalogCalcByTime(current, dir){
        var ret = current;
        var speedInfo = pData.speedInfo;
        if(speedInfo.changeCount === 0){
            speedInfo.changeCount = 1;
            ret += 0.1 * dir;
            var d = new Date();
            speedInfo.lastTime = d.getTime();
        }else{
            var now = new Date();
            var delta = (now.getTime() - speedInfo.lastTime);
    //        console.log(delta)
            ret = current + delta * 0.005 * dir;
        }
        if(ret >= 10)
            ret = 10.0;
        if(ret <= 0.1)
            ret = 0.1;
        pData.speedInfo = speedInfo;
        return ret.toFixed(1);
    }
    ICButton{
        id:minus
        text: "-"
        width: 32
        height: 32
        x:configNameWidth + inputWidth + unit.length * minus.font.pixelSize + 6
        anchors.verticalCenter: parent.verticalCenter
        isAutoRepeat: true
        delayOnAutoRepeat: 200

        onTriggered: {
            configValue = endAnalogCalcByTime(parseFloat(configValue), -1);
        }
        onBtnReleased: {
            var speedInfo = pData.speedInfo;
            speedInfo.changeCount = 0;
            pData.speedInfo = speedInfo;
            editFinished();
        }
    }
    ICButton{
        id:plus
        text: "+"
        width: 32
        height: 32
        x:minus.x + width + 6
        anchors.verticalCenter: parent.verticalCenter

        isAutoRepeat: true
        delayOnAutoRepeat: 200

        onTriggered: {
            configValue = endAnalogCalcByTime(parseFloat(configValue), 1);
        }
        onBtnReleased: {
            var speedInfo = pData.speedInfo;
            speedInfo.changeCount = 0;
            pData.speedInfo = speedInfo;
            editFinished();
        }
    }
}
