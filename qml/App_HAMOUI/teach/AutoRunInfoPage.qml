import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/ConfigDefines.js" as ConfigDefines
import "../teach/Teach.js" as Teach

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
    //        anchors.horizontalCenter: parent.horizontalCenter
//            anchors.right: container.right
            columns: 1
            spacing: 2
//            ICButton{
//                id:clearCount
////                anchors.right: container.right
//                width: 60
//                height: 32
//                text: qsTr("Clear Count")
//                bgColor: "green"
//                onButtonClicked: {
//                    total.configValue = 0;
//                    var cr = Teach.counterManager.getCounter(0);
//                    Teach.counterManager.updateCounter(cr.id, cr.name, 0, cr.target);
//                    panelRobotController.saveCounterDef(cr.id, cr.name, 0, cr.target);
//                }
//            }
            ICConfigEdit{
                id:total
                width: 50
                inputWidth:60
                enabled: false
                configNameWidth: 60
                configName: qsTr("Total:")
                unit: qsTr("nmb")
                configAddr: "s_rw_0_16_0_944"
            }
            ICConfigEdit{
                id:count
                width: 50
                inputWidth:60
                configNameWidth: 60
                configName: qsTr("cuont:")
                unit: qsTr("nmb")
                configAddr: "s_rw_0_32_0_1400"
            }
            ICConfigEdit{
                id:target
                width: 50
                inputWidth:60
                enabled: false
                configNameWidth: 60
                configName: qsTr("Target:")
                unit: qsTr("nmb")
                configAddr: "s_rw_0_16_0_944"
            }
        }
        Column{
            id:normalContainer
            spacing: 2
            anchors.centerIn: parent
            Grid{
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


//            ICComboBoxConfigEdit{
//                id: counter
//                configName: qsTr("Counter")
//                onVisibleChanged: {
//                    if(visible){
//                        var cs = Teach.counterManager.counters;
//                        var csNames = [];
//                        for(var i = 0, len = cs.length; i < len; ++i){
//                            csNames.push("[" + cs[i].id + "]:" + cs[i].name);
//                        }
//                        var cI = configValue;
//                        configValue = -1;
//                        items = csNames;
//                        if(cI < items.length)
//                            configValue = cI;
//                    }
//                }
//            }
        }
        ICButton{
            id:counterDetailsBtn
            text: qsTr("Counter >>")
            x:parent.width - width
            anchors.top:normalContainer.bottom
            color: "green"
            onButtonClicked: {
                if(counterDetails.visible)
                    toHideCounterDetails.start();
                else
                    toShowCounterDetails.start();
            }

            SequentialAnimation{
                id:toShowCounterDetails
                PropertyAction{target: counterDetails; property: "visible"; value: true}
                PropertyAnimation{target:counterDetailsBtn; property: "x"; to: counterDetailsBtn.x + counterDetails.width}
                PropertyAction{target: counterDetailsBtn; property: "text"; value: qsTr("Counter <<")}
                PropertyAction{target:counterDetailsBtn; property: "bgColor"; value: "#A0A0F0"}
            }
            SequentialAnimation{
                id:toHideCounterDetails
                PropertyAnimation{target:counterDetailsBtn; property: "x"; to: counterDetailsBtn.x - counterDetails.width}
                PropertyAction{target: counterDetails; property: "visible"; value: false}
                PropertyAction{target: counterDetailsBtn; property: "text"; value: qsTr("Counter >>")}
                PropertyAction{target:counterDetailsBtn; property: "bgColor"; value: "green"}
            }

            ICListView{
                id:counterDetails
                anchors.right: counterDetailsBtn.left
                border.color: "gray"
                border.width: 1
                isShowHint: true
                width: 460
                height: container.height
                color: "#A0A0F0"
                y:-counterDetailsBtn.y
                visible: false
                spacing: 6
                delegate: Row{
                    Text {
                        text: name
                        width: 150
                    }
                    Text {
                        text: qsTr("Target:") + " " + target
                        width: 150
                    }
                    Text{
                        text:qsTr("Current:") + " " + current
                        width: 150
                    }
                }

                ListModel{
                    id:counterModel

                }
                model: counterModel
            }
            onVisibleChanged: {
                if(visible){
                    counterModel.clear();
                    var cs = Teach.counterManager.counters;
                    for(var i = 0, len = cs.length; i < len; ++i){
                        counterModel.append({"name":qsTr("counter") + "[" + cs[i].id + "]:" + cs[i].name,
                                            "target":cs[i].target, "current":cs[i].current, "id":cs[i].id});
                    }
                }
            }
        }
    }
    Timer{
        id:refreshTimer
        interval: 50; running: visible; repeat: true
        onTriggered: {
            lastCycle.text = (panelRobotController.getMultiplexingConfig(ConfigDefines.multiplexingConfigAddrs.ICAddr_Common_Para1) / 1000).toFixed(3);
            cycle.text =  (panelRobotController.getMultiplexingConfig(ConfigDefines.multiplexingConfigAddrs.ICAddr_Common_Para0) / 1000).toFixed(3);
            var counter = Teach.counterManager.getCounter(0);
            total.configValue = count.configValue*counter.current;
            target.configValue = count.configValue*counter.target;
//            total.configValue = counter.current*panelRobotController.getConfigValue("s_rw_0_16_0_943");
//            target.configValue = panelRobotController.getConfigValue("s_rw_0_16_0_943")*panelRobotController.getConfigValue("s_rw_16_16_0_943");
            var c;
            var mc;
            for(var i = 0, len = counterModel.count; i < len; ++i){
                mc = counterModel.get(i);
                c = Teach.counterManager.getCounter(mc.id);
                if(c.current != mc.current)
                    counterModel.setProperty(i, "current", c.current);
                panelRobotController.getConfigValue("s_rw_30_1_0_153")
            }
        }
    }
}
