import QtQuick 1.1
import "../../../ICCustomElement"
import "../../configs/AxisDefine.js" as AxisDefine
import "ExtentActionDefine.js" as ExtentActionDefine

ExtentActionEditorBase {
    id:axisFlyConfigs
    width: content.width + 20
    height: content.height
    property alias plane: planeSel.configValue
    property alias plateNum: plateNum.configValue
    property alias speed: speed.configValue
    property alias delay: delay.configValue
    property alias poseEn: poseEn.isChecked
    property alias centerPos_0: centerPos_0.configValue
    property alias centerPos_1: centerPos_1.configValue
    property alias centerPos_2: centerPos_2.configValue
    property alias startPos_0: startPos_0.configValue
    property alias startPos_1: startPos_1.configValue
    property alias startPos_2: startPos_2.configValue
    property alias startPos_5: startPos_5.configValue



    function configsCheck(){
        return planeSel.configValue >= 0;
    }

    Column{
        id:content
        spacing: 4
        Row{
            spacing: 20
            ICComboBoxConfigEdit{
                id:planeSel
                z:2
                configName: qsTr("Plane Sel")
                configNameWidth: 80
                items: ["XY","XZ","YZ"]
                onConfigValueChanged: {
                    if(configValue == 0){
                        centerPos_0.visible = true;
                        centerPos_1.visible = true;
                        centerPos_2.visible = false;

                        startPos_0.visible = true;
                        startPos_1.visible = true;
                        startPos_2.visible = false;
                    }
                    else if(configValue == 1){
                        centerPos_0.visible = true;
                        centerPos_1.visible = false;
                        centerPos_2.visible = true;

                        startPos_0.visible = true;
                        startPos_1.visible = false;
                        startPos_2.visible = true;
                    }
                    else if(configValue == 2){
                        centerPos_0.visible = false;
                        centerPos_1.visible = true;
                        centerPos_2.visible = true;

                        startPos_0.visible = false;
                        startPos_1.visible = true;
                        startPos_2.visible = true;
                    }
                }
                Component.onCompleted: configValue = 0;
            }
            ICConfigEdit{
                id:plateNum
                configName: qsTr("Plate Num")
                configNameWidth: planeSel.configNameWidth
                configValue: "1"
                unit: qsTr("Plate")
            }
        }
        Row{
            spacing: 20
            ICConfigEdit{
                id:speed
                configName: qsTr("Speed")
                configNameWidth: planeSel.configNameWidth
                configAddr: "s_rw_0_32_1_1200"
                configValue: "80.0"
                unit: qsTr("%")
            }
            ICConfigEdit{
                id:delay
                configName: qsTr("Delay")
                configNameWidth: planeSel.configNameWidth
                configValue: "0.00"
                configAddr: "s_rw_0_32_2_1100"
                unit: qsTr("s")
            }
        }
        Row{
            spacing: 20
            ICCheckBox{
                id:poseEn
                text: qsTr("Pose En")
                isChecked: false
            }
        }
        Row{
            spacing: 20
            ICButton{
                id:setInCenterPos
                text:qsTr("Set In CP:")
                width: planeSel.configNameWidth
                height: centerPos_0.height
                onButtonClicked: {
                    centerPos_0.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[0].jAddr) / 1000).toFixed(3);
                    centerPos_1.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[1].jAddr) / 1000).toFixed(3);
                    centerPos_2.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[2].jAddr) / 1000).toFixed(3);
                }
            }
            ICConfigEdit{
                id:centerPos_0
                configName: qsTr("X:")
                configAddr: "s_rw_0_32_3_1300"
                configValue: "0.000"
                unit: AxisDefine.axisInfos[0].unit
            }
            ICConfigEdit{
                id:centerPos_1
                configName: qsTr("Y:")
                configAddr: "s_rw_0_32_3_1300"
                configValue: "0.000"
                unit: AxisDefine.axisInfos[1].unit
            }
            ICConfigEdit{
                id:centerPos_2
                configName: qsTr("Z:")
                configAddr: "s_rw_0_32_3_1300"
                configValue: "0.000"
                unit: AxisDefine.axisInfos[2].unit
            }
        }
        Row{
            spacing: 20
            ICButton{
                id:setInStartPos
                text:qsTr("Set In SP:")
                width: planeSel.configNameWidth
                height: centerPos_0.height
                onButtonClicked: {
                    startPos_0.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[0].jAddr) / 1000).toFixed(3);
                    startPos_1.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[1].jAddr) / 1000).toFixed(3);
                    startPos_2.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[2].jAddr) / 1000).toFixed(3);
                    startPos_5.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[5].jAddr) / 1000).toFixed(3);
                }
            }
            ICConfigEdit{
                id:startPos_0
                configName: qsTr("X:")
                configAddr: "s_rw_0_32_3_1300"
                configValue: "0.000"
                unit: AxisDefine.axisInfos[0].unit
            }
            ICConfigEdit{
                id:startPos_1
                configName: qsTr("Y:")
                configAddr: "s_rw_0_32_3_1300"
                configValue: "0.000"
                unit: AxisDefine.axisInfos[1].unit
            }
            ICConfigEdit{
                id:startPos_2
                configName: qsTr("Z:")
                configAddr: "s_rw_0_32_3_1300"
                configValue: "0.000"
                unit: AxisDefine.axisInfos[2].unit
            }
        }
        ICConfigEdit{
            id:startPos_5
            visible: poseEn.isChecked
            x: setInStartPos.x + setInStartPos.width + 20
            configName: qsTr("W:")
            configAddr: "s_rw_0_32_3_1300"
            configValue: "0.000"
            unit: AxisDefine.axisInfos[5].unit
        }
    }
    Component.onCompleted: {
        bindActionDefine(ExtentActionDefine.extentRotateCatchAction);
    }
}


