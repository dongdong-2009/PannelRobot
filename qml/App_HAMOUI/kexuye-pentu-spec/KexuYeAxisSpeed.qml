import QtQuick 1.1
import "../../ICCustomElement"

Item {
    id:container
    width: parent.width
    height: parent.height
    property variant actionObject: null

    function updateActionObject(ao){
        ao.startSpeed0 = m0Speed.configValue;
        ao.startSpeed1 = m1Speed.configValue;
        ao.startSpeed2 = m2Speed.configValue;
        ao.startSpeed3 = m3Speed.configValue;
        ao.startSpeed4 = m4Speed.configValue;
        ao.startSpeed5 = m5Speed.configValue;
        ao.fixtureDelay0 = delay0.configValue;
        ao.fixtureDelay1 = delay1.configValue;
        ao.fixtureDelay2 = delay2.configValue;
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
        };
    }
    function speedcontainer() {return configContainer;}

    Column{
        id:configContainer
        property int posNameWidth: 60
        spacing: 20
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
                    configName: qsTr("X")
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
                ICConfigEdit{
                    id:m1Speed
                    configName: qsTr("Y")
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
                ICConfigEdit{
                    id:m2Speed
                    configName: qsTr("Z")
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
                ICConfigEdit{
                    id:m3Speed
                    configName: qsTr("A")
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
                ICConfigEdit{
                    id:m4Speed
                    configName: qsTr("B")
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
                ICConfigEdit{
                    id:m5Speed
                    configName: qsTr("C")
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
            }
        }
        Column{
            spacing: 4
            Row{
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
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
                ICConfigEdit{
                    id:delay1
                    configName: qsTr("Oil Delay")
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
                ICConfigEdit{
                    id:delay2
                    configName: qsTr("Amplitude Delay")
                    configAddr: "s_rw_0_32_1_1200"
                    unit: qsTr("%")

                }
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
    }

    Component.onCompleted: {
        m0Speed.configValue = 50;
        m1Speed.configValue = 50;
        m2Speed.configValue = 50;
        m3Speed.configValue = 5;
        m4Speed.configValue = 5;
        m5Speed.configValue = 5;
        delay0.configValue = 0;
        delay1.configValue = 0;
        delay2.configValue = 0;
    }
}
