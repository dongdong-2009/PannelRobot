import QtQuick 1.1
import "."
import "Theme.js" as Theme
import "../utils/Storage.js" as Storage
import "../utils/utils.js" as Utils
import "configs/AlarmInfo.js" as AlarmInfo
import "../ICCustomElement"


Rectangle {
    id:container
    property int textOffset: 2


    property variant unResolvedAlarms: []
    color: "#d1d1d1"

    function appendAlarm(errNum){
        var alarmItem = new Storage.AlarmItem(0, errNum);
        alarmItem = Storage.appendAlarmToLog(alarmItem);
        alarmModel.insert(0, alarmItem);
        if(alarmModel.count > Storage.ALARM_LOG_TB_INFO.max)
        {
            alarmModel.remove(alarmModel.count - 1);
        }
        var tmp = unResolvedAlarms;
        tmp.push(alarmItem);
        unResolvedAlarms = tmp;
    }

    function resolvedAlarms(){
        var tmp = unResolvedAlarms;
        if(tmp.length > 0){
            var unResolvedItem;
            var oldItem;
            var now = new Date();
            now = now.getTime();
            for(var i = 0; i < alarmModel.count; ++i){
                oldItem = alarmModel.get(i);
                for(var j = 0; j < tmp.length; ++j){
                    unResolvedItem = tmp[j];
                    if(oldItem.id === unResolvedItem.id){
                        oldItem.endTime = now;
                        Storage.updateAlarmLog(oldItem);
                        tmp.splice(j, 1);
                        break;
                    }
                }
                if(tmp.length == 0){
                    unResolvedAlarms = tmp;
                    break;
                }
            }
        }
    }

    ListModel{
        id:alarmModel
    }

    Row{
        id:header
        anchors.horizontalCenter: parent.horizontalCenter
        y:6
        z:2
        ICLabel{
            id:hNum
            border.width: 1
            border.color: "gray"
            width: 50
            height: 32
            text: qsTr("Alarm\n Num")
            horizontalAlignment: Text.AlignLeft
            horizontalTextOffset: textOffset
        }

        ICLabel{
            id:hLevel
            border.width: hNum.border.width
            border.color: hNum.border.color
            width: 30
            height: hNum.height
            text: qsTr("L")
            horizontalAlignment: Text.AlignLeft
            horizontalTextOffset: textOffset
        }
        ICLabel{
            id:hDescr
            border.width: hNum.border.width
            border.color: hNum.border.color
            width: 400
            height: hNum.height
            text: qsTr("Descr")
            horizontalAlignment: Text.AlignLeft
            horizontalTextOffset: textOffset
        }
        ICLabel{
            id:hTriggeredTime
            border.width: hNum.border.width
            border.color: hNum.border.color
            width: 150
            height: hNum.height
            text: qsTr("Triggered Time")
            horizontalAlignment: Text.AlignLeft
            horizontalTextOffset: textOffset
        }
        ICLabel{
            id:hEndTime
            border.width: hNum.border.width
            border.color: hNum.border.color
            width: 150
            height: hNum.height
            text: qsTr("End Time")
            horizontalAlignment: Text.AlignLeft
            horizontalTextOffset: textOffset
        }
    }

    ListView{
        id:alarmView
        anchors.top: header.bottom
        model: alarmModel
        x:header.x
        width: header.width + 1
        height: {
            var cH = container.height - header.height - header.y * 2;
            var mH = header.height * alarmModel.count;
            return Math.min(cH, mH) + 5;
        }
        clip: true
//        footer: Rectangle{
//            height: border.width
//            width: alarmView.width
//            border.width: hNum.border.width
//            border.color: hNum.border.color
//    //        anchors.top: alarmView.bottom
//        }
        delegate: Row{
            Rectangle{
                border.width: hNum.border.width
                border.color: hNum.border.color
                width: hNum.width
                height: hNum.height
                Text {
                    text: alarmNum
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    x:textOffset
                }
            }
            Rectangle{
                border.width: hNum.border.width
                border.color: hNum.border.color
                width: hLevel.width
                height: hLevel.height
                Text {
                    text: level
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    x:textOffset

                }
            }
            Rectangle{
                border.width: hNum.border.width
                border.color: hNum.border.color
                width: hDescr.width
                height: hDescr.height
                Text {
                    text:AlarmInfo.getAlarmDescr(alarmNum)
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    x:textOffset

                }
            }
            Rectangle{
                border.width: hNum.border.width
                border.color: hNum.border.color
                width: hTriggeredTime.width
                height: hTriggeredTime.height
                Text {
                    text: {
                        var t = new Date();
                        t.setTime(triggerTime);
                        return Utils.formatDate(t, "yyyy/MM/dd hh:mm:ss");
                    }
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    x:textOffset

                }
            }
            Rectangle{
                border.width: hNum.border.width
                border.color: hNum.border.color
                width: hEndTime.width
                height: hEndTime.height
                Text {
                    text: {
                        if(endTime === "") return "";
                        var t = new Date();
                        t.setTime(endTime);
                        Utils.formatDate(t, "yyyy/MM/dd hh:mm:ss");
                    }
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    x:textOffset

                }
            }
        }
    }


    Component.onCompleted: {
        var alarmlog = Storage.alarmlog();
        for(var i = 0; i < alarmlog.length; ++i){
            alarmModel.append(alarmlog[i]);
        }
    }
}
