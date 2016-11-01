import QtQuick 1.1

Rectangle {
    property string form: ""
    property int second: 0
    signal hourGone()
    signal minuteGone()
    signal secondGone()
    Timer {
        interval: 1000; running: parent.visible; repeat: true
        triggeredOnStart: true
        onTriggered: {
            time.text = formatDate(form).toString();
            ++second;
            secondGone();
            if(second % 60 == 0)
                minuteGone();
            if(second % 3600 == 0){
                hourGone();
                second = 0;
            }
        }
    }
    width: time.width
    height: time.height
    color: "transparent"

    function formatDate(fmt)
    { //author: meizz
        var date = new Date();
        var o = {
            "M+" : date.getMonth()+1,                 //月份
            "d+" : date.getDate(),                    //日
            "h+" : date.getHours(),                   //小时
            "m+" : date.getMinutes(),                 //分
            "s+" : date.getSeconds(),                 //秒
            "q+" : Math.floor((date.getMonth()+3)/3), //季度
            "S"  : date.getMilliseconds()             //毫秒
        };
        if(/(y+)/.test(fmt))
            fmt=fmt.replace(RegExp.$1, (date.getFullYear()+"").substr(4 - RegExp.$1.length));
        if(/(D+)/.test(fmt))
            fmt=fmt.replace(RegExp.$1, (getWeek()+"").substr(3 - RegExp.$1.length));
        for(var k in o)
            if(new RegExp("("+ k +")").test(fmt))
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
        return fmt;
    }
    function getWeek(){
        var d = new Date()
        var week;
        switch (d.getDay()){
        case 1: week=qsTr("Mon"); break;
        case 2: week=qsTr("Tur"); break;
        case 3: week=qsTr("Wen"); break;
        case 4: week=qsTr("Thu"); break;
        case 5: week=qsTr("Fri"); break;
        case 6: week=qsTr("Sat"); break;
        default: week=qsTr("Sun");
        }
        return week;
    }
    Text {
        id: time
    }
}
