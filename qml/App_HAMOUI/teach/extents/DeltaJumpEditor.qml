import QtQuick 1.1
import "../../../ICCustomElement"
import "ExtentActionDefine.js" as ExtentActionDefine
import "../../configs/AxisDefine.js" as AxisDefine

ExtentActionEditorBase {
    width: content.width + 20
    height: content.height
    id:instance
    property alias xpos1: xpos1Edit.configValue
    property alias ypos1: ypos1Edit.configValue
    property alias zpos1: zpos1Edit.configValue
    property alias upos1: upos1Edit.configValue
    property alias vpos1: vpos1Edit.configValue
    property alias wpos1: wpos1Edit.configValue

    property alias xpos2: xpos2Edit.configValue
    property alias ypos2: ypos2Edit.configValue
    property alias zpos2: zpos2Edit.configValue
    property alias upos2: upos2Edit.configValue
    property alias vpos2: vpos2Edit.configValue
    property alias wpos2: wpos2Edit.configValue

    property alias lh: lhEdit.configValue
    property alias mh: mhEdit.configValue
    property alias rh: rhEdit.configValue

    property alias speed: speedEdit.configValue
    property alias delay: delayEdit.configValue
    Image {
        id: tipImage
        source: "../../images/delta_jump.png"
        y:-height
    }

    ICFlickable{
        id:content
        height: 200
        width: 430
        isshowhint: true
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentContainer.height + 10
        contentWidth: contentContainer.width
        Column{
            id:contentContainer
            spacing: 6
            Row{
                spacing: lhEdit.width
                Text {
                    text: qsTr("LH Pos")
                }
                Text {
                    text: qsTr("MH Pos")
                }
                Text {
                    text: qsTr("RH Pos")
                }
            }
            Row{
                spacing: 50
                ICConfigEdit{
                    id:lhEdit
                    min: -1000
                    max: 1000
                    decimal: 3
                    configValue: "0.000"
                    unit: qsTr("mm")
                }
                ICConfigEdit{
                    id:mhEdit
                    min: -10000
                    max: 10000
                    decimal: 3
                    configValue: "0.000"
                    unit: qsTr("mm")
                }
                ICConfigEdit{
                    id:rhEdit
                    min: -1000
                    max: 1000
                    decimal: 3
                    configValue: "0.000"
                    unit: qsTr("mm")
                }
            }

            Row{
                spacing: 12
                Column{
                    spacing: 6
                    Row{
                        spacing: 6
                        Text {
                            text: qsTr("Start Pos")
                        }
                        ICButton{
                            id:setPos1
                            height: 30
                            width: 60
                            text: qsTr("Set In")
                            onButtonClicked:{
                                xpos1Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                                ypos1Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                                zpos1Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                                upos1Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                                vpos1Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                                wpos1Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                            }
                        }
                    }
                    ICConfigEdit{
                        id:xpos1Edit
                        configName: AxisDefine.axisInfos[0].name
                        configAddr: "s_rw_0_32_3_1300"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[0].unit
                    }
                    ICConfigEdit{
                        id:ypos1Edit
                        configName: AxisDefine.axisInfos[1].name
                        configAddr: "s_rw_0_32_3_1301"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[1].unit
                    }
                    ICConfigEdit{
                        id:zpos1Edit
                        configName: AxisDefine.axisInfos[2].name
                        configAddr: "s_rw_0_32_3_1302"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[2].unit
                    }
                    ICConfigEdit{
                        id:upos1Edit
                        configName: AxisDefine.axisInfos[3].name
                        configAddr: "s_rw_0_32_3_1303"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[3].unit
                    }
                    ICConfigEdit{
                        id:vpos1Edit
                        configName: AxisDefine.axisInfos[4].name
                        configAddr: "s_rw_0_32_3_1304"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[4].unit
                    }
                    ICConfigEdit{
                        id:wpos1Edit
                        configName: AxisDefine.axisInfos[5].name
                        configAddr: "s_rw_0_32_3_1305"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[5].unit
                    }
                }
                Column{
                    spacing: 6
                    Row{
                        spacing: 6
                        Text {
                            text: qsTr("End Pos")
                        }
                        ICButton{
                            id:setPos2
                            height: 30
                            width: 60
                            text: qsTr("Set In")
                            onButtonClicked:{
                                xpos2Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                                ypos2Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                                zpos2Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                                upos2Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                                vpos2Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                                wpos2Edit.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                            }
                        }
                    }

                    ICConfigEdit{
                        id:xpos2Edit
                        configName: AxisDefine.axisInfos[0].name
                        configAddr: "s_rw_0_32_3_1300"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[0].unit
                    }
                    ICConfigEdit{
                        id:ypos2Edit
                        configName: AxisDefine.axisInfos[1].name
                        configAddr: "s_rw_0_32_3_1301"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[1].unit
                    }
                    ICConfigEdit{
                        id:zpos2Edit
                        configName: AxisDefine.axisInfos[2].name
                        configAddr: "s_rw_0_32_3_1302"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[2].unit
                    }
                    ICConfigEdit{
                        id:upos2Edit
                        configName: AxisDefine.axisInfos[3].name
                        configAddr: "s_rw_0_32_3_1303"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[3].unit
                    }
                    ICConfigEdit{
                        id:vpos2Edit
                        configName: AxisDefine.axisInfos[4].name
                        configAddr: "s_rw_0_32_3_1304"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[4].unit
                    }
                    ICConfigEdit{
                        id:wpos2Edit
                        configName: AxisDefine.axisInfos[5].name
                        configAddr: "s_rw_0_32_3_1305"
                        configValue: "0.000"
                        configNameWidth: 40
                        unit: AxisDefine.axisInfos[5].unit
                    }
                }
            }

            Row{
                spacing: 24
                ICConfigEdit{
                    id:speedEdit
                    configName: qsTr("speed Value")
                    configAddr: "s_rw_0_32_1_1200"
                    configValue: "80.0"
                    configNameWidth: 40
                    unit: qsTr("%")
                }
                ICConfigEdit{
                    id:delayEdit
                    configName: qsTr("Delay")
                    configAddr: "s_rw_0_32_1_1201"
                    configValue: "0.0"
                    configNameWidth: 40
                    unit: qsTr("s")
                }
            }
        }
    }
    Component.onCompleted: {
        bindActionDefine(ExtentActionDefine.extentDeltaJumpAction);
    }
}
