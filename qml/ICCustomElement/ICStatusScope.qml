import QtQuick 1.1

import './ICStatusScope.js' as PData

Item {
    property alias refreshInterval: refreshTimer.interval
    function dataStyle(ori){
        return ori
    }

    id:container

    Component.onCompleted: {
        PData.deepFindStatus(container)
    }

    Timer{
        id:refreshTimer
        interval: 50; running: visible; repeat: true;
        onTriggered: {
            var count = PData.status.length;
            var w;
            var t;
            for(var i = 0; i < count; ++i){
                w = PData.status[i];
                t = dataStyle(panelRobotController.statusValueText(w.bindStatus));
                if( t !== w.text)
                    w.text = t;
            }
        }
    }
}
