import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine

Item {
    id:container
    width: parent.width
    height: parent.height
    property variant actionObject: null

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
        ao.slope = slope.configValue;
        ao.chamferRadius = chamferRadius.configValue;
        ao.linglong = linelong.configValue
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
            "slope":slope.configValue,
            "chamferRadius":chamferRadius.configValue,
            "linglong":linelong.configValue
        };
    }
    function speedcontainer() {return configContainer;}
    Row{
        spacing: 50
        Column{
            id:configContainer
            property int posNameWidth: 60
            spacing: 10
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
                Row{
                    spacing: 10
                    id:delaycontiner
                    ICConfigEdit{
                        id:delay0
                        configName: qsTr("Atomization Delay")
                        configAddr: "s_rw_0_32_2_1100"
                        unit: qsTr("s")

                    }
                    ICConfigEdit{
                        id:delay1
                        configName: qsTr("Amplitude Delay")
                        configAddr: "s_rw_0_32_2_1100"
                        unit: qsTr("s")

                    }
                    ICConfigEdit{
                        id:delay2
                        configName: qsTr("Oil Delay")
                        configAddr: "s_rw_0_32_2_1100"
                        unit: qsTr("s")

                    }

                }
            }
            Column{
                spacing: 4
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
                Row{
                    spacing: 10
                    id:delaycontiner2
                    ICConfigEdit{
                        id:delay20
                        configName: qsTr("Atomization Delay")
                        configAddr: "s_rw_0_32_2_1100"
                        unit: qsTr("s")

                    }
                    ICConfigEdit{
                        id:delay21
                        configName: qsTr("Amplitude Delay")
                        configAddr: "s_rw_0_32_2_1100"
                        unit: qsTr("s")

                    }
                    ICConfigEdit{
                        id:delay22
                        configName: qsTr("Oil Delay")
                        configAddr: "s_rw_0_32_2_1100"
                        unit: qsTr("s")

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
                configName: qsTr("FixSwitch")
                items: [qsTr("L"), qsTr("R"), qsTr("D"), qsTr("Close"), qsTr("Open")]
            }
            ICComboBoxConfigEdit{
                id:fixture1Switch
                z: 2
                configName: qsTr("FixSwitch")
                items: [qsTr("L"), qsTr("R"), qsTr("D"), qsTr("Close"), qsTr("Open")]
            }
            ICConfigEdit{
                id:slope
                z: 1
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
        m0Speed.configValue = actionObject.startSpeed0;
        m1Speed.configValue = actionObject.startSpeed1;
        m2Speed.configValue = actionObject.startSpeed2;
        m3Speed.configValue = actionObject.startSpeed3;
        m4Speed.configValue = actionObject.startSpeed4;
        m5Speed.configValue = actionObject.startSpeed5;
        delay0.configValue = actionObject.fixtureDelay0;
        delay1.configValue = actionObject.fixtureDelay1;
        delay2.configValue = actionObject.fixtureDelay2;
        fixtureSwitch.configValue = actionObject.fixture1Switch;
        delay20.configValue = actionObject.fixture2Delay0;
        delay21.configValue = actionObject.fixture2Delay1;
        delay22.configValue = actionObject.fixture2Delay2;
        fixture1Switch.configValue = actionObject.fixture2Switch;
        slope.configValue = actionObject.slope;
//        chamferRadius.configValue = actionObject.chamferRadius;
//        linelong.configValue = actionObject.linelong
    }

    Component.onCompleted: {
        delay0.configValue = 0;
        delay1.configValue = 0;
        delay2.configValue = 0;
        fixtureSwitch.configValue = 3;
        delay20.configValue = 0;
        delay21.configValue = 0;
        delay22.configValue = 0;
        fixture1Switch.configValue = 3;
        m0Speed.configValue = 20;
        m1Speed.configValue = 20;
        m2Speed.configValue = 20;
        m3Speed.configValue = 30;
        m4Speed.configValue = 30;
        m5Speed.configValue = 30;
        slope.configValue = 0;
        chamferRadius.configValue = 4;
        linelong.configValue = 100;


    }
}
