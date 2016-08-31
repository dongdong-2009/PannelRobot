import QtQuick 1.1

Rectangle {
    property string form: ""
    property int second: 0
    signal hourGone()
    signal minuteGone()
    Timer {
        interval: 1000; running: parent.visible; repeat: true
        triggeredOnStart: true
        onTriggered: {
            time.text = formatDate(form).toString();
            ++second;
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
        case 1: week="星期一"; break;
        case 2: week="星期二"; break;
        case 3: week="星期三"; break;
        case 4: week="星期四"; break;
        case 5: week="星期五"; break;
        case 6: week="星期六"; break;
        default: week="星期天";
        }
        return week;
    }
    Text {
        id: time
    }
}
