import QtQuick 1.1
import "configs/IODefines.js" as YDefines
import "AppSettings.js" as UISettings
import "Theme.js" as Theme
import "."

Rectangle {

    property int ioStart: 0

    anchors.fill: parent
    QtObject {
        id: pData
        property string currentLanguage: UISettings.AppSettings.prototype.currentLanguage()
    }

    function getYDesc(index) {
        var y = YDefines.yDefines[index + ioStart]
        return y.pointName + ":" + y.descr[pData.currentLanguage]
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
    function mappedX(index) {
        var y = YDefines.yDefines[index + ioStart]
        return YDefines.yCheckedX(y.pointName) != -1
    }

    color: Theme.defaultTheme.BASE_BG

    YDefineItem {
        id: y0
        pointDescr: getYDesc(0)
        x: itemX(0)
        y: itemY(0)
        hasMappedX: mappedX(0)
    }
    YDefineItem {
        id: y1
        pointDescr: getYDesc(1)
        x: itemX(1)
        y: itemY(1)
        hasMappedX: mappedX(1)
    }
    YDefineItem {
        id: y2
        pointDescr: getYDesc(2)
        x: itemX(2)
        y: itemY(2)
        hasMappedX: mappedX(2)
    }
    YDefineItem {
        id: y3
        pointDescr: getYDesc(3)
        x: itemX(3)
        y: itemY(3)
        hasMappedX: mappedX(3)
    }
    YDefineItem {
        id: y4
        pointDescr: getYDesc(4)
        x: itemX(4)
        y: itemY(4)
        hasMappedX: mappedX(4)
    }
    YDefineItem {
        id: y5
        pointDescr: getYDesc(5)
        x: itemX(5)
        y: itemY(5)
        hasMappedX: mappedX(5)
    }
    YDefineItem {
        id: y6
        pointDescr: getYDesc(6)
        x: itemX(6)
        y: itemY(6)
        hasMappedX: mappedX(6)
    }
    YDefineItem {
        id: y7
        pointDescr: getYDesc(7)
        x: itemX(7)
        y: itemY(7)
        hasMappedX: mappedX(7)
    }

    YDefineItem {
        id: y8
        pointDescr: getYDesc(8)
        x: itemX(8)
        y: itemY(8)
        hasMappedX: mappedX(8)
    }
    YDefineItem {
        id: y9
        pointDescr: getYDesc(9)
        x: itemX(9)
        y: itemY(9)
        hasMappedX: mappedX(9)
    }
    YDefineItem {
        id: y10
        pointDescr: getYDesc(10)
        x: itemX(10)
        y: itemY(10)
        hasMappedX: mappedX(10)
    }
    YDefineItem {
        id: y11
        pointDescr: getYDesc(11)
        x: itemX(11)
        y: itemY(11)
        hasMappedX: mappedX(11)
    }
    YDefineItem {
        id: y12
        pointDescr: getYDesc(12)
        x: itemX(12)
        y: itemY(12)
        hasMappedX: mappedX(12)
    }
    YDefineItem {
        id: y13
        pointDescr: getYDesc(13)
        x: itemX(13)
        y: itemY(13)
        hasMappedX: mappedX(13)
    }
    YDefineItem {
        id: y14
        pointDescr: getYDesc(14)
        x: itemX(14)
        y: itemY(14)
        hasMappedX: mappedX(14)
    }
    YDefineItem {
        id: y15
        pointDescr: getYDesc(15)
        x: itemX(15)
        y: itemY(15)
        hasMappedX: mappedX(15)
    }
    Timer {
        id: refreshTimer
        interval: 50
        running: true
        repeat: true
        onTriggered: {
            update(y0, 0 + ioStart)
            update(y1, 1 + ioStart)
            update(y2, 2 + ioStart)
            update(y3, 3 + ioStart)
            update(y4, 4 + ioStart)
            update(y5, 5 + ioStart)
            update(y6, 6 + ioStart)
            update(y7, 7 + ioStart)

            update(y8, 8 + ioStart)
            update(y9, 9 + ioStart)
            update(y10, 10 + ioStart)
            update(y11, 11 + ioStart)
            update(y12, 12 + ioStart)
            update(y13, 13 + ioStart)
            update(y14, 14 + ioStart)
            update(y15, 15 + ioStart)
        }
    }
    onVisibleChanged: {
        if (visible)
            refreshTimer.start()
        else
            refreshTimer.stop()
    }
}
