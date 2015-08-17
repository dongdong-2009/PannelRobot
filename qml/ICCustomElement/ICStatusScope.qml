import QtQuick 1.1

Item {
    property alias refreshInterval: refreshTimer.interval
    id:container
    QtObject{
        id:pdata
        property variant status: []

        function deepFindStatus(ret, item){
//            console.log(item)
            if(item.hasOwnProperty("bindStatus")){
                ret.push(item);
                return;
            }
            var itemChildren = item.children;

            var count = itemChildren.length;
            for(var i = 0; i < count; ++i){
                pdata.deepFindStatus(ret,itemChildren[i]);
            }

        }
    }

    Component.onCompleted: {
        var ret = [];
        pdata.deepFindStatus(ret, container)
        pdata.status = ret;
//        console.log(pdata.status.length)
    }
    onVisibleChanged: {
        visible ? refreshTimer.start() : refreshTimer.stop();
    }

    Timer{
        id:refreshTimer
        interval: 50; running: false; repeat: true
        onTriggered: {
//            console.log("refress")
            var count = pdata.status.length;
            var w;
            var t;
            for(var i = 0; i < count; ++i){
                w = pdata.status[i];
                t = panelRobotController.statusValueText(w.bindStatus);
                if( t !== w.text)
                    w.text = t;
            }
        }
    }
}
