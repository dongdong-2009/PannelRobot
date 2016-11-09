import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine

Item {
    id:container
    width: parent.width
    height: parent.height
    property variant actionObject: null
    property bool isauto: false

    function updateActionObject(ao){
        ao.startPosSpeed0 = m0Speed.configValue;
        ao.startPosSpeed1 = m1Speed.configValue;
        ao.startPosSpeed2 = m2Speed.configValue;
        ao.startPosSpeed3 = m3Speed.configValue;
        ao.startPosSpeed4 = m4Speed.configValue;
        ao.startPosSpeed5 = m5Speed.configValue;
        ao.fixtureDelay0 = delay0.configValue;
        ao.fixtureDelay1 = delay1.configValue;
        ao.fixtureDelay2 = delay2.configValue;
        ao.fixture1Switch = fixtureSwitch.configValue;
        ao.fixture2Delay0 = delay20.configValue;
        ao.fixture2Delay1 = delay21.configValue;
        ao.fixture2Delay2 = delay22.configValue;
        ao.fixture2Switch = fixture1Switch.configValue;
        ao.turnOver = turnOver.configValue;
        ao.slope = slope.configValue;
        ao.chamferRadius = chamferRadius.configValue;
        ao.linglong = linelong.configValue;
        ao.gun1use0 = use0.isChecked;
        ao.gun1use1 = use1.isChecked;
        ao.gun1use2 = use2.isChecked;
        ao.gun2use0 = use3.isChecked;
        ao.gun2use1 = use4.isChecked;
        ao.gun2use2 = use5.isChecked;
    }

    function getDetails(){
        return {
            "spd0":m0Speed.configValue,
            "spd1":m1Speed.configValue,
            "spd2":m2Speed.configValue,
            "spd3":m3Speed.configValue,
            "spd4":m4Speed.configValue,
            "spd5":m5Speed.configValue,
            "delay0":delay0.configValue,
            "delay1":delay1.configValue,
            "delay2":delay2.configValue,
            "delay20":delay20.configValue,
            "delay21":delay21.configValue,
            "delay22":delay22.configValue,
            "fixtureSwitch":fixtureSwitch.configValue,
            "fixture1Switch":fixture1Switch.configValue,
            "turnOver":turnOver.configValue,
            "slope":slope.configValue,
            "chamferRadius":chamferRadius.configValue,
            "linglong":linelong.configValue,
            "use0":use0.isChecked,
            "use1":use1.isChecked,
            "use2":use2.isChecked,
            "use3":use3.isChecked,
            "use4":use4.isChecked,
            "use5":use5.isChecked
        };
    }
    function speedcontainer() {return configContainer;}
    Row{
        spacing: 50
        Column{
            id:configContainer
            property int posNameWidth: 60
            spacing: 10
            Row{
                spacing: 20
                Column{
                    spacing: 4
                    Row{
                        id:delayrow
                        spacing: 10
                        Text {
                            id: fixtureDelay
                            text: qsTr("Fixture Delay")
                            width: 200
                            anchors.verticalCenter: parent.verticalCenter
                            color: "green"
                        }
                    }
                    Column{
                        spacing: 10
                        id:delaycontiner
                        Row{
                            spacing: 5
                            ICConfigEdit{
                                id:delay0
                                configName: qsTr("Atomization Delay")
                                configAddr: "s_rw_0_32_2_1100"
                                unit: qsTr("s")

                            }
                            ICCheckBox{
                                id:use0
                                width: 60
                                text: qsTr("Use")
                                isChecked: false
                                useCustomClickHandler: true
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(!use0.isChecked)
                                            use0.isChecked = true;
                                        else use0.isChecked = false;
                                    }
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            ICConfigEdit{
                                id:delay1
                                configName: qsTr("Amplitude Delay")
                                configAddr: "s_rw_0_32_2_1100"
                                unit: qsTr("s")

                            }
                            ICCheckBox{
                                id:use1
                                width: 60
                                text: qsTr("Use")
                                isChecked: false
                                useCustomClickHandler: true
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(!use1.isChecked)
                                            use1.isChecked = true;
                                        else use1.isChecked = false;
                                    }
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            ICConfigEdit{
                                id:delay2
                                configName: qsTr("Oil Delay")
                                configAddr: "s_rw_0_32_2_1100"
                                unit: qsTr("s")

                            }
                            ICCheckBox{
                                id:use2
                                width: 60
                                text: qsTr("Use")
                                isChecked: false
                                useCustomClickHandler: true
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(!use2.isChecked)
                                            use2.isChecked = true;
                                        else use2.isChecked = false;
                                    }
                                }
                            }
                        }
                    }
                }
                Column{
                    spacing: 4
                    visible: false
                    Row{
                        spacing: 10
                        Text {
                            id: fixture1Delay
                            text: qsTr("Fixture1 Delay")
                            width: 200
                            anchors.verticalCenter: parent.verticalCenter
                            color: "green"
                        }
                    }
                    Column{
                        spacing: 10
                        id:delaycontiner2
                        Row{
                            spacing: 5
                            ICConfigEdit{
                                id:delay20
                                configName: qsTr("Atomization Delay")
                                configAddr: "s_rw_0_32_2_1100"
                                unit: qsTr("s")

                            }
                            ICCheckBox{
                                id:use3
                                width: 60
                                text: qsTr("Use")
                                isChecked: false
                                useCustomClickHandler: true
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(!use3.isChecked)
                                            use3.isChecked = true;
                                        else use3.isChecked = false;
                                    }
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            ICConfigEdit{
                                id:delay21
                                configName: qsTr("Amplitude Delay")
                                configAddr: "s_rw_0_32_2_1100"
                                unit: qsTr("s")

                            }
                            ICCheckBox{
                                id:use4
                                width: 60
                                text: qsTr("Use")
                                isChecked: false
                                useCustomClickHandler: true
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(!use4.isChecked)
                                            use4.isChecked = true;
                                        else use4.isChecked = false;
                                    }
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            ICConfigEdit{
                                id:delay22
                                configName: qsTr("Oil Delay")
                                configAddr: "s_rw_0_32_2_1100"
                                unit: qsTr("s")

                            }
                            ICCheckBox{
                                id:use5
                                width: 60
                                text: qsTr("Use")
                                isChecked: false
                                useCustomClickHandler: true
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(!use5.isChecked)
                                            use5.isChecked = true;
                                        else use5.isChecked = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Column{
                spacing: 4
                Row{
                    spacing: 10
                    Text {
                        id: returnspeed
                        text: qsTr("Return Speed")
                        width: 200
                        anchors.verticalCenter: parent.verticalCenter
                        color: "green"
                    }
                }
                Row{
                    spacing: 10
                    id:rspeedContainer
                    ICConfigEdit{
                        id:m0Speed
                        configNameWidth: 28
                        configName: AxisDefine.axisInfos[0].name
                        configAddr: "s_rw_0_32_1_1200"
                        unit: qsTr("%")

                    }
                    ICConfigEdit{
                        id:m1Speed
                        configNameWidth: m0Speed.configNameWidth
                        configName: AxisDefine.axisInfos[1].name
                        configAddr: "s_rw_0_32_1_1200"
                        unit: qsTr("%")

                    }
                    ICConfigEdit{
                        id:m2Speed
                        configNameWidth: m0Speed.configNameWidth
                        configName: AxisDefine.axisInfos[2].name
                        configAddr: "s_rw_0_32_1_1200"
                        unit: qsTr("%")

                    }
                }
                Row{
                    spacing: 10
                    id:rspeedContainer1
                    ICConfigEdit{
                        id:m3Speed
                        configNameWidth: m0Speed.configNameWidth
                        configName: AxisDefine.axisInfos[3].name
                        configAddr: "s_rw_0_32_1_1200"
                        unit: qsTr("%")

                    }
                    ICConfigEdit{
                        id:m4Speed
                        configNameWidth: m0Speed.configNameWidth
                        configName: AxisDefine.axisInfos[4].name
                        configAddr: "s_rw_0_32_1_1200"
                        unit: qsTr("%")

                    }
                    ICConfigEdit{
                        id:m5Speed
                        configNameWidth: m0Speed.configNameWidth
                        configName: AxisDefine.axisInfos[5].name
                        configAddr: "s_rw_0_32_1_1200"
                        unit: qsTr("%")

                    }
                }
            }
        }

//        Rectangle{
//            width: 1
//            height: container.height
//            border.width: 1
//        }

        Column{
            spacing: 10
            y: fixtureDelay.height
            ICComboBoxConfigEdit{
                id:fixtureSwitch
                z: 3
                configName: qsTr("FixSwitch1")
                items: [qsTr("L"), qsTr("R"), qsTr("D"), qsTr("Close"), qsTr("Open")]
            }
            ICComboBoxConfigEdit{
                id:fixture1Switch
                z: 2
                visible: false
                configName: qsTr("FixSwitch2")
                popupHeight: 100
                items: [qsTr("L"), qsTr("R"), qsTr("D"), qsTr("Close"), qsTr("Open")]

            }
            ICComboBoxConfigEdit{
                id:turnOver
                z: 1
                configName: qsTr("Turn Over")
                popupHeight: 100
                items: [qsTr("L"), qsTr("R"), qsTr("M")]

            }
            ICConfigEdit{
                id:slope
                z: 1
                visible: false
                configName: qsTr("slope")
                configAddr: "s_rw_0_32_3_1300"
                unit: qsTr("°")
            }
            ICConfigEdit{
                id:chamferRadius
                visible: false
                z: 1
                configName: qsTr("radius")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("mm")
            }
            ICConfigEdit{
                id:linelong
                visible: false
                z: 1
                configName: qsTr("Line Long")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("mm")
            }
        }
    }

    onActionObjectChanged: {
        if(actionObject == null) return;
        m0Speed.configValue = actionObject.startPosSpeed0;
        m1Speed.configValue = actionObject.startPosSpeed1;
        m2Speed.configValue = actionObject.startPosSpeed2;
        m3Speed.configValue = actionObject.startPosSpeed3;
        m4Speed.configValue = actionObject.startPosSpeed4;
        m5Speed.configValue = actionObject.startPosSpeed5;
        delay0.configValue = actionObject.fixtureDelay0;
        delay1.configValue = actionObject.fixtureDelay1;
        delay2.configValue = actionObject.fixtureDelay2;
        fixtureSwitch.configValue = actionObject.fixture1Switch;
        delay20.configValue = actionObject.fixture2Delay0;
        delay21.configValue = actionObject.fixture2Delay1;
        delay22.configValue = actionObject.fixture2Delay2;
        fixture1Switch.configValue = actionObject.fixture2Switch;
        turnOver.configValue = actionObject.turnOver;
        slope.configValue = actionObject.slope;
//        chamferRadius.configValue = actionObject.chamferRadius;
//        linelong.configValue = actionObject.linelong
        use0.isChecked = actionObject.gun1use0;
        use1.isChecked = actionObject.gun1use1;
        use2.isChecked = actionObject.gun1use2;
        use3.isChecked = actionObject.gun2use0;
        use4.isChecked = actionObject.gun2use1;
        use5.isChecked = actionObject.gun2use2;
    }

    Component.onCompleted: {
        delay0.configValue = 0;
        delay1.configValue = 0;
        delay2.configValue = 0.08;
        fixtureSwitch.configValue = 4;
        delay20.configValue = 0;
        delay21.configValue = 0;
        delay22.configValue = 0.03;
        fixture1Switch.configValue = 3;
        turnOver.configValue = 2;
        m0Speed.configValue = 20;
        m1Speed.configValue = 20;
        m2Speed.configValue = 20;
        m3Speed.configValue = 30;
        m4Speed.configValue = 30;
        m5Speed.configValue = 30;
        slope.configValue = 0;
        chamferRadius.configValue = 4;
        linelong.configValue = 100;
        use0.isChecked = true;
        use1.isChecked = true;
        use2.isChecked = true;
        use3.isChecked = false;
        use4.isChecked = false;
        use5.isChecked = false;


    }
}
