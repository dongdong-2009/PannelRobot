import QtQuick 1.1
import "configs/IODefines.js" as IODefines
import "Theme.js" as Theme
import "."
import "../ICCustomElement"

Item {

    property variant valves: []
    ListModel{
        id:valveModel
    }

    ICGridView{
        id:valveView
        width: 795
        height: 385
        x: 5
        hintx: valveView.width - 20
        hinty: valveView.height - 30
        isShowHint: true
        cellWidth :390
        cellHeight: 48
        clip: true
        delegate: YDefineItem{
            valveName: mValveName
            valveStatus: mValveStatus
            valve: mValve
        }
    }
    ICButton{
        id:gunfresh1
        x: valveView.width-gunfresh1.width
        height: 32
        width: 80
        text: qsTr("Gunfresh1")
        anchors.leftMargin: 12
        bgColor: "grey"
        onButtonClicked: {
            lookOver.running = false;
            if(gunfresh1.bgColor == "grey"){
                gunfresh1.bgColor = "lime";
                var toSend = IODefines.valveItemJSON("valve4");
                panelRobotController.setYStatus(toSend, 1);
                toSend = IODefines.valveItemJSON("valve5");
                panelRobotController.setYStatus(toSend, 1);
            }
            else{
                gunfresh1.bgColor = "grey";
                toSend = IODefines.valveItemJSON("valve6");
                panelRobotController.setYStatus(toSend, 0);

            }
            gunfresh1Timer.running = true;
            lookOver.running = true;
        }
    }
    ICButton{
        id:gunfresh2
        x: valveView.width-gunfresh1.width
        y: gunfresh1.height + 5
        height: 32
        width: 80
        text: qsTr("Gunfresh2")
        anchors.leftMargin: 12
        bgColor: "grey"
        onButtonClicked: {
            lookOver.running = false;
            if(gunfresh2.bgColor == "grey"){
                gunfresh2.bgColor = "lime"
                var toSend = IODefines.valveItemJSON("valve7");
                panelRobotController.setYStatus(toSend, 1);
                toSend = IODefines.valveItemJSON("valve8");
                panelRobotController.setYStatus(toSend, 1);
            }
            else{
                gunfresh2.bgColor = "grey"
                toSend = IODefines.valveItemJSON("valve9");
                panelRobotController.setYStatus(toSend, 0);
            }
            gunfresh2Timer.running = true;
            lookOver.running = true;
        }
    }
    Timer {
        id: gunfresh1Timer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            if(gunfresh1.bgColor == "grey"){
                var toSend = IODefines.valveItemJSON("valve4");
                panelRobotController.setYStatus(toSend, 0);
                toSend = IODefines.valveItemJSON("valve5");
                panelRobotController.setYStatus(toSend, 0);
            }
            else{
                toSend = IODefines.valveItemJSON("valve6");
                panelRobotController.setYStatus(toSend, 1);
            }
        }
    }
    Timer {
        id: gunfresh2Timer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            if(gunfresh2.bgColor == "grey"){
                var toSend = IODefines.valveItemJSON("valve7");
                panelRobotController.setYStatus(toSend, 0);
                toSend = IODefines.valveItemJSON("valve8");
                panelRobotController.setYStatus(toSend, 0);
            }
            else{
                toSend = IODefines.valveItemJSON("valve9");
                panelRobotController.setYStatus(toSend, 1);
            }
        }
    }
    Timer {
        id: lookOver
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            if(panelRobotController.isOutputOn(4, 0)&&panelRobotController.isOutputOn(5, 0)&&
                    panelRobotController.isOutputOn(6, 0))
                gunfresh1.bgColor = "lime";
            else if(!(panelRobotController.isOutputOn(4, 0)||panelRobotController.isOutputOn(5, 0)||
                    panelRobotController.isOutputOn(6, 0)))
                gunfresh1.bgColor = "grey";
            if(panelRobotController.isOutputOn(7, 0)&&panelRobotController.isOutputOn(8, 0)&&
                    panelRobotController.isOutputOn(9, 0))
                gunfresh2.bgColor = "lime";
            else if(!(panelRobotController.isOutputOn(7, 0)||panelRobotController.isOutputOn(8, 0)||
                    panelRobotController.isOutputOn(9, 0)))
                gunfresh2.bgColor = "grey";
        }
    }


    onValvesChanged:  {
        valveModel.clear();
        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
        if(ioBoardCount == 0)
            ioBoardCount = 1;
        var l = Math.min(ioBoardCount * 32, valves.length);
        for(var i = 0; i < l; ++i){
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
