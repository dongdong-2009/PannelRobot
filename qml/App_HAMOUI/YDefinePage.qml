import QtQuick 1.1
import "configs/IODefines.js" as IODefines
import "Theme.js" as Theme
import "."

Item {

    property variant yPointNames: []

    QtObject{
        id:pData
        property variant pointUIs: []
    }

    function itemY(index) {

        return (index % 8) * 40 + 20
    }
    function itemX(index) {
        return index < 8 ? 100 : 500
    }
    function update(y, index) {
        var c = panelRobotController.isOutputOn(index + ioStart)
        if (y.isOn != c) {
            y.isOn = c
        }
    }

    Grid{
        id:pointsContainer
        columns: 2
        spacing: 10
        flow:Grid.TopToBottom
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 10

    }

    onYPointNamesChanged: {
        var yDefineItemClass = Qt.createComponent("YDefineItem.qml");
        var uis = [];
        for(var i = 0; i < yPointNames.length; ++i){
            var ioinfo = IODefines.getYDefineFromPointName(yPointNames[i]);

            uis.push(yDefineItemClass.createObject(pointsContainer, {"board":ioinfo.type,
                                                       "hwPoint":ioinfo.hwPoint}));
        }
        pData.pointUIs = uis;
    }

    Timer {
        id: refreshTimer
        interval: 50
        running: visible
        repeat: true
        onTriggered: {
            var yItems = pData.pointUIs;
            var yItem;
            for(var i = 0; i < yItems.length; ++i){
                yItem = yItems[i];
                yItem.isOn = panelRobotController.isOutputOn(yItem.hwPoint, yItem.board);
            }
//            pData.pointUIs = yItems;

            //            update(y0, 0 + ioStart)
            //            update(y1, 1 + ioStart)
            //            update(y2, 2 + ioStart)
            //            update(y3, 3 + ioStart)
            //            update(y4, 4 + ioStart)
            //            update(y5, 5 + ioStart)
            //            update(y6, 6 + ioStart)
            //            update(y7, 7 + ioStart)

            //            update(y8, 8 + ioStart)
            //            update(y9, 9 + ioStart)
            //            update(y10, 10 + ioStart)
            //            update(y11, 11 + ioStart)
            //            update(y12, 12 + ioStart)
            //            update(y13, 13 + ioStart)
            //            update(y14, 14 + ioStart)
            //            update(y15, 15 + ioStart)
        }
    }
    onVisibleChanged: {
        if (visible)
            refreshTimer.start()
        else
            refreshTimer.stop()
    }
}
