import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../AlarmInfo.js" as AlarmInfo

Item {
    width: parent.width
    height: parent.height
    function createActionObjects(){
        var ret = [];
        ret.push(Teach.generateCustomAlarmAction(alarmModel.get(alarmView.currentIndex).alarmNum));
        return ret;
    }

    Rectangle{
        id:alarmViewFrame
        border.width: 1
        border.color: "black"
        color: "#A0A0F0"
        width: parent.width - 6
        height: parent.height - 6
        x:3
        y:3
        ListView{
            id:alarmView
            width: parent.width
            height: parent.height - 2
            y:2
            clip: true
            highlight: Rectangle {
                color: "yellow"
                radius: 2
                width: parent.width-2
                x:1
                y:1
            }
            delegate: MouseArea{
                width: parent.width
                height: 24
                Row{
                    width: parent.width
                    height: 24
                    Text {
                        text: alarmNum + ":"
                        width: 60
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: descr
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }
                onClicked: {
                    alarmView.currentIndex = index;
                }
            }
        }
        ListModel{
            id:alarmModel
        }
    }

    Component.onCompleted: {
        var csas = AlarmInfo.customAlarmInfo;
        for(var alarmNum in csas){
            alarmModel.append({"alarmNum":alarmNum, "descr":csas[alarmNum]});
        }
        alarmView.model = alarmModel;
    }
}
