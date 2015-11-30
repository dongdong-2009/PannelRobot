import QtQuick 1.1
import "../ICCustomElement"
import "configs/AxisDefine.js" as AxisDefine


Item {
    width: parent.width
    height: parent.height
    Grid{
        spacing: 10
        columns: 2
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 20
        function readPulse(){
            return [panelRobotController.statusValue("c_ro_0_32_0_901"),
                    panelRobotController.statusValue("c_ro_0_32_0_905"),
                    panelRobotController.statusValue("c_ro_0_32_0_909"),
                    panelRobotController.statusValue("c_ro_0_32_0_913"),
                    panelRobotController.statusValue("c_ro_0_32_0_917"),
                    panelRobotController.statusValue("c_ro_0_32_0_921")];
        }

        function pulseToText(pulses){
            return AxisDefine.axisInfos[0].name + ":" + pulses[0] + "," +
                    AxisDefine.axisInfos[1].name + ":" + pulses[1] + "," +
                    AxisDefine.axisInfos[2].name + ":" + pulses[2] + "," +
                    AxisDefine.axisInfos[3].name + ":" + pulses[3] + "," +
                    AxisDefine.axisInfos[4].name + ":" + pulses[4] + "," +
                    AxisDefine.axisInfos[5].name + ":" + pulses[5];
        }

        function onMoldChanged(){
            var pulses =[
                        panelRobotController.getConfigValueText("m_rw_0_32_0_358"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_359"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_360"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_361"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_362"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_363"),
                    ];
            p1Show.text = pulseToText(pulses);
            pulses =[
                        panelRobotController.getConfigValueText("m_rw_0_32_0_364"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_365"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_366"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_367"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_368"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_369"),
                    ];
            p2Show.text = pulseToText(pulses);

            pulses =[
                        panelRobotController.getConfigValueText("m_rw_0_32_0_370"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_371"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_372"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_373"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_374"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_375"),
                    ];
            p3Show.text = pulseToText(pulses);

            pulses =[
                        panelRobotController.getConfigValueText("m_rw_0_32_0_376"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_377"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_378"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_379"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_380"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_381"),
                    ];
            p4Show.text = pulseToText(pulses);

            pulses =[
                        panelRobotController.getConfigValueText("m_rw_0_32_0_382"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_383"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_384"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_385"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_386"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_387"),
                    ];
            p5Show.text = pulseToText(pulses);

            pulses =[
                        panelRobotController.getConfigValueText("m_rw_0_32_0_388"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_389"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_390"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_391"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_392"),
                        panelRobotController.getConfigValueText("m_rw_0_32_0_393"),
                    ];
            p6Show.text = pulseToText(pulses);


        }

        ICButton{
            id:p1
            text: qsTr("Set to P1")
            onButtonClicked: {
                var pulses = parent.readPulse();
                panelRobotController.setConfigValue("m_rw_0_32_0_358", pulses[0]);
                panelRobotController.setConfigValue("m_rw_0_32_0_359", pulses[1]);
                panelRobotController.setConfigValue("m_rw_0_32_0_360", pulses[2]);
                panelRobotController.setConfigValue("m_rw_0_32_0_361", pulses[3]);
                panelRobotController.setConfigValue("m_rw_0_32_0_362", pulses[4]);
                panelRobotController.setConfigValue("m_rw_0_32_0_363", pulses[5]);
                p1Show.text = parent.pulseToText(pulses);
                panelRobotController.syncConfigs();

            }
        }
        Text {
            id: p1Show
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            height: p1.height
        }
        ICButton{
            id:p2
            text: qsTr("Set to P2")
            onButtonClicked: {
                var pulses = parent.readPulse();
                panelRobotController.setConfigValue("m_rw_0_32_0_364", pulses[0]);
                panelRobotController.setConfigValue("m_rw_0_32_0_365", pulses[1]);
                panelRobotController.setConfigValue("m_rw_0_32_0_366", pulses[2]);
                panelRobotController.setConfigValue("m_rw_0_32_0_367", pulses[3]);
                panelRobotController.setConfigValue("m_rw_0_32_0_368", pulses[4]);
                panelRobotController.setConfigValue("m_rw_0_32_0_369", pulses[5]);
                p2Show.text = parent.pulseToText(pulses);
                panelRobotController.syncConfigs();


            }
        }
        Text {
            id: p2Show
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            height: p2.height

        }
        ICButton{
            id:p3
            text: qsTr("Set to P3")
            onButtonClicked: {
                var pulses = parent.readPulse();
                panelRobotController.setConfigValue("m_rw_0_32_0_370", pulses[0]);
                panelRobotController.setConfigValue("m_rw_0_32_0_371", pulses[1]);
                panelRobotController.setConfigValue("m_rw_0_32_0_372", pulses[2]);
                panelRobotController.setConfigValue("m_rw_0_32_0_373", pulses[3]);
                panelRobotController.setConfigValue("m_rw_0_32_0_374", pulses[4]);
                panelRobotController.setConfigValue("m_rw_0_32_0_375", pulses[5]);
                p3Show.text = parent.pulseToText(pulses);
                panelRobotController.syncConfigs();

            }
        }
        Text {
            id: p3Show
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            height: p3.height

        }
        ICButton{
            id:p4
            text: qsTr("Set to P4")
            onButtonClicked: {
                var pulses = parent.readPulse();
                panelRobotController.setConfigValue("m_rw_0_32_0_376", pulses[0]);
                panelRobotController.setConfigValue("m_rw_0_32_0_377", pulses[1]);
                panelRobotController.setConfigValue("m_rw_0_32_0_378", pulses[2]);
                panelRobotController.setConfigValue("m_rw_0_32_0_379", pulses[3]);
                panelRobotController.setConfigValue("m_rw_0_32_0_380", pulses[4]);
                panelRobotController.setConfigValue("m_rw_0_32_0_381", pulses[5]);
                p4Show.text = parent.pulseToText(pulses);
                panelRobotController.syncConfigs();

            }
        }
        Text {
            id: p4Show
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            height: p4.height
        }
        ICButton{
            id:p5
            text: qsTr("Set to P5")
            onButtonClicked: {
                var pulses = parent.readPulse();
                panelRobotController.setConfigValue("m_rw_0_32_0_382", pulses[0]);
                panelRobotController.setConfigValue("m_rw_0_32_0_383", pulses[1]);
                panelRobotController.setConfigValue("m_rw_0_32_0_384", pulses[2]);
                panelRobotController.setConfigValue("m_rw_0_32_0_385", pulses[3]);
                panelRobotController.setConfigValue("m_rw_0_32_0_386", pulses[4]);
                panelRobotController.setConfigValue("m_rw_0_32_0_387", pulses[5]);
                p5Show.text = parent.pulseToText(pulses);
                panelRobotController.syncConfigs();

            }
        }
        Text {
            id: p5Show
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            height: p5.height
        }
        ICButton{
            id:p6
            text: qsTr("Set to P6")
            onButtonClicked: {
                var pulses = parent.readPulse();
                panelRobotController.setConfigValue("m_rw_0_32_0_388", pulses[0]);
                panelRobotController.setConfigValue("m_rw_0_32_0_389", pulses[1]);
                panelRobotController.setConfigValue("m_rw_0_32_0_390", pulses[2]);
                panelRobotController.setConfigValue("m_rw_0_32_0_391", pulses[3]);
                panelRobotController.setConfigValue("m_rw_0_32_0_392", pulses[4]);
                panelRobotController.setConfigValue("m_rw_0_32_0_393", pulses[5]);
                p6Show.text = parent.pulseToText(pulses);
                panelRobotController.syncConfigs();

            }
        }
        Text {
            id: p6Show
            text: qsTr("text")
            verticalAlignment: Text.AlignVCenter
            height: p6.height
        }
        ICCheckBox {
            id:enBtn
            text: qsTr("Use it?")
            onClicked: {

                panelRobotController.setConfigValue("m_rw_9_1_0_357", enBtn.isChecked ? 1 : 0);
                panelRobotController.syncConfigs();
            }
        }
        Component.onCompleted: {
            panelRobotController.moldChanged.connect(onMoldChanged);
            onMoldChanged();
        }
    }
}
