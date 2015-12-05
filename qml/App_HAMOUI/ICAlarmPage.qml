import QtQuick 1.1
import "."
import "Theme.js" as Theme
import "../utils/Storage.js" as Storage
import "../utils/utils.js" as Utils
import "configs/AlarmInfo.js" as AlarmInfo


Rectangle {
    id:container

    color: Theme.defaultTheme.BASE_BG
    property variant unResolvedAlarms: []

    function appendAlarm(errNum){
        var alarmItem = new Storage.AlarmItem(0, errNum);
        alarmItem = Storage.appendAlarmToLog(alarmItem);
        if(alarmModel.count >= Storage.ALARM_LOG_TB_INFO.max)
        {
            alarmModel.remove(alarmModel.count - 1);
        }else
            alarmModel.insert(0, alarmItem);
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
        Rectangle{
            id:hNum
            border.width: 1
            border.color: "gray"
            width: 50
            height: 32
            Text {
                text: qsTr("Alarm\n Num")
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }
        }
        Rectangle{
            id:hLevel
            border.width: hNum.border.width
            border.color: hNum.border.color
            width: 30
            height: hNum.height
            Text {
                text: qsTr("L")
                verticalAlignment: Text.AlignVCenter
                height: parent.height

            }
        }
        Rectangle{
            id:hDescr
            border.width: hNum.border.width
            border.color: hNum.border.color
            width: 400
            height: hNum.height
            Text {
                text: qsTr("Descr")
                verticalAlignment: Text.AlignVCenter
                height: parent.height

            }
        }
        Rectangle{
            id:hTriggeredTime
            border.width: hNum.border.width
            border.color: hNum.border.color
            width: 150
            height: hNum.height
            Text {
                text: qsTr("Triggered Time")
                verticalAlignment: Text.AlignVCenter
                height: parent.height

            }
        }
        Rectangle{
            id:hEndTime
            border.width: hNum.border.width
            border.color: hNum.border.color
            width: 150
            height: hNum.height
            Text {
                text: qsTr("End Time")
                verticalAlignment: Text.AlignVCenter
                height: parent.height

            }
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
            return Math.min(cH, mH);
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
                }
            }
        }
    }


    Component.onCompleted: {
        var alarmlog = Storage.alarmlog();
        for(var i = 0; i < alarmlog.length; ++i){
            console.log(alarmlog[i].id, alarmlog[i].alarmNum);
            alarmModel.append(alarmlog[i]);
        }
    }
}
