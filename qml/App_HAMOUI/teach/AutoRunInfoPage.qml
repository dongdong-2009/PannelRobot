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
                PropertyAction{target:counterDetailsBtn; property: "z"; value: 10}
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
                PropertyAction{target:counterDetailsBtn; property: "z"; value: 1}

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
                        width: 180
                    }
                    Text {
                        text: qsTr("Target:") + " " + target
                        width: 135
                    }
                    Text{
                        text:qsTr("Current:") + " " + current
                        width: 135
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

        ICButton{
            id:analogDetailsBtn
            //            visible: false
            text: qsTr("Analog >>")
            x:parent.width - width
            anchors.top:counterDetailsBtn.bottom
            anchors.topMargin: 6
            color: "green"
            onButtonClicked: {
                if(analogDetails.visible)
                    toHideAnalogDetails.start();
                else
                    toShowAnalogDetails.start();
            }

            SequentialAnimation{
                id:toShowAnalogDetails
                PropertyAction{target:analogDetailsBtn; property: "z"; value: 10}
                PropertyAction{target: analogDetails; property: "visible"; value: true}
                PropertyAnimation{target:analogDetailsBtn; property: "x"; to: analogDetailsBtn.x + analogDetails.width}
                PropertyAction{target: analogDetailsBtn; property: "text"; value: qsTr("Analog <<")}
                PropertyAction{target:analogDetailsBtn; property: "bgColor"; value: "#A0A0F0"}
            }
            SequentialAnimation{
                id:toHideAnalogDetails
                PropertyAnimation{target:analogDetailsBtn; property: "x"; to: analogDetailsBtn.x - analogDetails.width}
                PropertyAction{target: analogDetails; property: "visible"; value: false}
                PropertyAction{target: analogDetailsBtn; property: "text"; value: qsTr("Analog >>")}
                PropertyAction{target:analogDetailsBtn; property: "bgColor"; value: "green"}
                PropertyAction{target:analogDetailsBtn; property: "z"; value: 1}

            }

            Rectangle{
                MouseArea{anchors.fill: parent}
                id:analogDetails
                anchors.right: analogDetailsBtn.left
                border.color: "gray"
                border.width: 1
                width: 460
                height: container.height
                color: "#A0A0F0"
                y:-analogDetailsBtn.y
                visible: false
                Column{
                    anchors.fill: parent
                    spacing: 6
                    Row{
                        spacing: 4
                        ICButton{
                            id:sub0
                            text: "-"
                            width: 32
                        }
                        ICConfigEdit{
                            id:chanel0
                            configName: qsTr("Chanel-0")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        ICButton{
                            id:add0
                            text: "+"
                            width: 32
                        }
                    }
                    ICConfigEdit{
                        id:chanel1
                        configName: qsTr("Chanel-1")
                    }
                    ICConfigEdit{
                        id:chanel2
                        configName: qsTr("Chanel-2")
                    }
                    ICConfigEdit{
                        id:chanel3
                        configName: qsTr("Chanel-3")
                    }
                    ICConfigEdit{
                        id:chanel4
                        configName: qsTr("Chanel-4")
                    }
                    ICConfigEdit{
                        id:chanel5
                        configName: qsTr("Chanel-5")
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
            var c;
            var mc;
            for(var i = 0, len = counterModel.count; i < len; ++i){
                mc = counterModel.get(i);
                c = Teach.counterManager.getCounter(mc.id);
                if(c.current != mc.current)
                    counterModel.setProperty(i, "current", c.current);
            }
        }
    }
}
