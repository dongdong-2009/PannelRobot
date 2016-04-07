import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/ConfigDefines.js" as ConfigDefines

MouseArea{
    id:instance
    width: parent.width
    height: parent.height
    Rectangle {
        id:container
        width: parent.width
        height: parent.height
        border.width: 1
        border.color: "gray"
        color: "#A0A0F0"
        Grid{
            anchors.centerIn: parent
            columns: 2
            Text {
                text: qsTr("Last Cycle:")
            }
            Text {
                id: lastCycle
            }
            Text {
                text: qsTr("Cycle")
            }
            Text {
                id: cycle
            }
        }
    }
    Timer{
        id:refreshTimer
        interval: 50; running: visible; repeat: true
        onTriggered: {
            lastCycle.text = (panelRobotController.getMultiplexingConfig(ConfigDefines.multiplexingConfigAddrs.ICAddr_Common_Para1) / 1000).toFixed(3);
            cycle.text =  (panelRobotController.getMultiplexingConfig(ConfigDefines.multiplexingConfigAddrs.ICAddr_Common_Para0) / 1000).toFixed(3);
        }
    }
}
