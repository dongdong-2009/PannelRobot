import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/ConfigDefines.js" as ConfigDefines
import "../teach/Teach.js" as Teach

MouseArea{
    id:instance
    width: parent.width
    height: parent.height
    property alias isAnalogEn: analogDetailsBtn.visible

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
                ICSettingConfigsScope{
                    anchors.centerIn: parent
                    isCache: true
                    Column{
                        anchors.centerIn: parent
                        spacing: 12
                        ICConfigControlEdit{
                            configName: qsTr("Chanel-0")
                            configAddr: "m_rw_0_32_1_214"
                            onEditFinished: parent.parent.sync();
                        }
                        ICConfigControlEdit{
                            configName: qsTr("Chanel-1")
                            configAddr: "m_rw_0_32_1_215"
                            onEditFinished: parent.parent.sync();
                        }
                        ICConfigControlEdit{
                            configName: qsTr("Chanel-2")
                            configAddr: "m_rw_0_32_1_216"
                            onEditFinished: parent.parent.sync();
                        }
                        ICConfigControlEdit{
                            configName: qsTr("Chanel-3")
                            configAddr: "m_rw_0_32_1_217"
                            onEditFinished: parent.parent.sync();
                        }
                        ICConfigControlEdit{
                            configName: qsTr("Chanel-4")
                            configAddr: "m_rw_0_32_1_218"
                            onEditFinished: parent.parent.sync();
                        }
                        ICConfigControlEdit{
                            configName: qsTr("Chanel-5")
                            configAddr: "m_rw_0_32_1_219"
                            onEditFinished: parent.parent.sync();
                        }
                    }
                }
            }
        }

        /****************************************/
        ICButton{
            id:niujuBtn
            visible: true
            text: qsTr("niuju >>")
            x:parent.width - width
            anchors.top:analogDetailsBtn.bottom
            anchors.topMargin: 6
            color: "green"
            onButtonClicked: {
                if(niujuDetails.visible)
                    toHideNiujuDetails.start();
                else
                    toShowNiujuDetails.start();
            }

            SequentialAnimation{
                id:toShowNiujuDetails
                PropertyAction{target:niujuBtn; property: "z"; value: 10}
                PropertyAction{target: niujuDetails; property: "visible"; value: true}
                PropertyAnimation{target:niujuBtn; property: "x"; to: niujuBtn.x + niujuDetails.width}
                PropertyAction{target: niujuBtn; property: "text"; value: qsTr("niuju <<")}
                PropertyAction{target:niujuBtn; property: "bgColor"; value: "#A0A0F0"}
            }
            SequentialAnimation{
                id:toHideNiujuDetails
                PropertyAnimation{target:niujuBtn; property: "x"; to: niujuBtn.x - niujuDetails.width}
                PropertyAction{target: niujuDetails; property: "visible"; value: false}
                PropertyAction{target: niujuBtn; property: "text"; value: qsTr("niuju >>")}
                PropertyAction{target:niujuBtn; property: "bgColor"; value: "green"}
                PropertyAction{target:niujuBtn; property: "z"; value: 1}

            }

            Rectangle{
                MouseArea{anchors.fill: parent}
                id:niujuDetails
                anchors.right: niujuBtn.left
                border.color: "gray"
                border.width: 1
                width: 460
                height: container.height
                color: "#A0A0F0"
                y:-niujuBtn.y
                visible: false
                onVisibleChanged: {
                    if(visible)panelRobotController.modifyConfigValue(26,8);
                    else panelRobotController.modifyConfigValue(26,0);
                }

                ICStatusScope{
                    anchors.centerIn: parent
                    function dataStyle(ori){
                        var v = parseInt(ori);
                        if(v>32767)v-=65535;
                        return v;
                    }

                    Column{
                        Row{
                            Text {
                                text: qsTr("motor1:")
                            }
                        ICStatusWidget{
                            bindStatus:"c_ro_0_16_0_902"
                        }
                        }

                        Row{
                            Text {
                                text: qsTr("motor2:")
                            }
                        ICStatusWidget{

                            bindStatus:"c_ro_0_16_0_906"
                        }
                        }

                        Row{
                            Text {
                                text: qsTr("motor3:")
                            }
                        ICStatusWidget{

                            bindStatus:"c_ro_0_16_0_910"
                        }
                        }

                        Row{
                            Text {
                                text: qsTr("motor4:")
                            }
                        ICStatusWidget{

                            bindStatus:"c_ro_0_16_0_914"
                        }
                        }
                    }
                }
            }
        }


        /****************************************/





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
