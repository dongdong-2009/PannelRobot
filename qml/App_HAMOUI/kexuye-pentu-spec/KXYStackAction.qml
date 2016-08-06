import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine

Item {
    id:container
    width: parent.width
    height: parent.height
    property variant actionObject: null

//    function updateActionObject(ao){
//        ao.startSpeed0 = m0Speed.configValue;
//        ao.startSpeed1 = m1Speed.configValue;
//        ao.startSpeed2 = m2Speed.configValue;
//        ao.startSpeed3 = m3Speed.configValue;
//        ao.startSpeed4 = m4Speed.configValue;
//        ao.startSpeed5 = m5Speed.configValue;
//        ao.fixtureDelay0 = delay0.configValue;
//        ao.fixtureDelay1 = delay1.configValue;
//        ao.fixtureDelay2 = delay2.configValue;
//        ao.fixture1Switch = fixtureSwitch.configValue;
//        ao.fixture2Delay0 = delay20.configValue;
//        ao.fixture2Delay1 = delay21.configValue;
//        ao.fixture2Delay2 = delay22.configValue;
//        ao.fixture2Switch = fixture1Switch.configValue;
//        ao.slope = slope.configValue;
//        ao.chamferRadius = chamferRadius.configValue;
//        ao.linglong = linelong.configValue
//    }

    function getstackInstace(){
        return {
            "useStack":useStack.isChecked,
            "useDeviation":useDeviation.isChecked,
            "turns":turns.configValue,
            "stackSpeed":stackSpeed.configValue,
            "xdeviation":xdeviation.configValue,
            "ydeviation":ydeviation.configValue,
            "zdeviation":zdeviation.configValue,
            "xspace":xspace.configValue,
            "yspace":yspace.configValue,
            "zspace":zspace.configValue,
            "xcount":xcount.configValue,
            "ycount":ycount.configValue,
            "zcount":zcount.configValue,
            "xdirection":xdirection.configValue,
            "ydirection":ydirection.configValue,
            "zdirection":zdirection.configValue
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
                    id:checkrow
                    spacing: 10
                    z: 3
                    ICCheckBox{
                        id:useStack
                        text: qsTr("Use Stack")
                    }
                    ICCheckBox{
                        id:useDeviation
                        text: qsTr("Use Deviation")
                    }
                    ICComboBoxConfigEdit{
                        id:turns
                        configName: qsTr("Turns")
                        items: [qsTr("X->Y->Z"), qsTr("X->Z->Y"), qsTr("Y->X->Z"),
                                qsTr("Y->Z->X"), qsTr("Z->X->Y"), qsTr("Z->Y->X")]

                    }
                    ICConfigEdit{
                        id:stackSpeed
                        configName: qsTr("Stack Speed")
                        configAddr: "s_rw_0_32_1_1200"
                        unit: "%"
                    }
                }
                Row{
                    spacing: 10
                    id:stackcontiner
                    Column{
                        spacing: 4
                        id:deviation
                        visible: useDeviation.isChecked
                        ICConfigEdit{
                            id:xdeviation
                            configName: qsTr("X Deviation")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:ydeviation
                            configName: qsTr("Y Deviation")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:zdeviation
                            configName: qsTr("Z Deviation")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                    }
                    Column{
                        spacing: 4
                        id:space
                        ICConfigEdit{
                            id:xspace
                            configName: qsTr("X Space")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:yspace
                            configName: qsTr("Y Space")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:zspace
                            configName: qsTr("Z Space")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                    }
                    Column{
                        spacing: 4
                        id:stackcount
                        ICConfigEdit{
                            id:xcount
                            configName: qsTr("X Count")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:ycount
                            configName: qsTr("Y Count")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:zcount
                            configName: qsTr("Z Count")
                            configAddr: "s_rw_0_32_1_1200"
                        }
                    }
                    Column{
                        spacing: 4
                        id:direction
                        ICComboBoxConfigEdit{
                            id:xdirection
                            z: 3
                            configName: qsTr("X Direction")
                            items: [qsTr("Positive"), qsTr("Negitive")]
                        }
                        ICComboBoxConfigEdit{
                            id:ydirection
                            z: 2
                            configName: qsTr("Y Direction")
                            items: [qsTr("Positive"), qsTr("Negitive")]
                        }
                        ICComboBoxConfigEdit{
                            id:zdirection
                            z: 1
                            configName: qsTr("Z Direction")
                            items: [qsTr("Positive"), qsTr("Negitive")]
                        }
                    }
                }
            }
        }
    }

    onActionObjectChanged: {
//        if(actionObject == null) return;
//        m0Speed.configValue = actionObject.startSpeed0;
//        m1Speed.configValue = actionObject.startSpeed1;
//        m2Speed.configValue = actionObject.startSpeed2;
//        m3Speed.configValue = actionObject.startSpeed3;
//        m4Speed.configValue = actionObject.startSpeed4;
//        m5Speed.configValue = actionObject.startSpeed5;
//        delay0.configValue = actionObject.fixtureDelay0;
//        delay1.configValue = actionObject.fixtureDelay1;
//        delay2.configValue = actionObject.fixtureDelay2;
//        fixtureSwitch.configValue = actionObject.fixture1Switch;
//        delay20.configValue = actionObject.fixture2Delay0;
//        delay21.configValue = actionObject.fixture2Delay1;
//        delay22.configValue = actionObject.fixture2Delay2;
//        fixture1Switch.configValue = actionObject.fixture2Switch;
//        slope.configValue = actionObject.slope;
////        chamferRadius.configValue = actionObject.chamferRadius;
////        linelong.configValue = actionObject.linelong
    }

    Component.onCompleted: {
        useStack.isChecked = false;
        useDeviation.isChecked = false;
        turns.configValue = 0;
        stackSpeed.configValue = 100;
        xdeviation.configValue = 0;
        ydeviation.configValue = 0;
        zdeviation.configValue = 0;
        xspace.configValue = 0;
        yspace.configValue = 0;
        zspace.configValue = 0;
        xcount.configValue = 0;
        ycount.configValue = 0;
        zcount.configValue = 0;
        xdirection.configValue = 0;
        ydirection.configValue = 0;
        zdirection.configValue = 0;
    }
}
