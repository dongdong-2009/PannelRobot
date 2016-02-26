import QtQuick 1.1
import "configs/IODefines.js" as IODefines
import "Theme.js" as Theme
import "."

Item {

    property variant valves: []

//    Grid{
//        id:pointsContainer
//        columns: 2
//        spacing: 20
//        flow:Grid.TopToBottom
//        anchors.fill: parent
//        anchors.leftMargin: 20
//        anchors.topMargin: 10

//    }
    ListModel{
        id:valveModel
    }

    GridView{
        id:valveView
        width: parent.width
        height: parent.height
        x:5
        cellWidth :390
        cellHeight: 48
        clip: true
        delegate: YDefineItem{
            valveName: mValveName
            valveStatus: mValveStatus
            valve: mValve
        }

    }


    onValvesChanged:  {
        valveModel.clear();
        for(var i = 0; i < valves.length; ++i){
            valveModel.append({"mValveName":valves[i], "mValveStatus":{"y1":false, "x1":false, "y2":false, "x2":false}, "mValve":IODefines.getValveItemFromValveName(valves[i])});
        }
        valveView.model = valveModel;
    }

    Timer {
        id: refreshTimer
        interval: 50
        running: visible
        repeat: true
        onTriggered: {
            var yItem;
            var valve;
            var valveStatus = {};
            for(var i = 0; i < valveModel.count; ++i){
                yItem = valveModel.get(i);
                valve = yItem.mValve;

                valveStatus.y1 = panelRobotController.isOutputOn(valve.y1Point, valve.y1Board);
                valveStatus.x1 = panelRobotController.isInputOn(valve.x1Point, valve.x1Board);
                valveStatus.y2 = panelRobotController.isOutputOn(valve.y2Point, valve.y2Board);
                valveStatus.x2 = panelRobotController.isInputOn(valve.x2Point, valve.x2Board);
                valveModel.setProperty(i, "mValveStatus", valveStatus)
            }
        }
    }
    onVisibleChanged: {
        if (visible)
            refreshTimer.start()
        else
            refreshTimer.stop()
    }
}
