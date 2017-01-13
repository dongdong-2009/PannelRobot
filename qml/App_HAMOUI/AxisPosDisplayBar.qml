import QtQuick 1.1

import "."
import "../ICCustomElement/"
import "configs/AxisDefine.js" as AxisDefine
import "ToolCoordManager.js" as ToolCoordManager

Item {
    id:container
    x:4
    function setWorldPosVisible(en){
        worldPos.visible = en;
    }

    function setJogPosVisible(en){
        jogPos.visible = en;
    }

    states: [
    State {
        name: "jogPos"
        PropertyChanges { target: jogPos; visible: true}
        PropertyChanges { target: worldPos; visible: false}
        PropertyChanges { target:coordDisplay;visible: false}
    },
    State {
        name: "worldPos"
        PropertyChanges { target: worldPos; visible: true}
        PropertyChanges { target: jogPos; visible: false}
        PropertyChanges { target:coordDisplay;visible: true}
    }
]

    ICStatusScope{
        Row{
            spacing: 20
            Grid{
                id:worldPos
                rows: 2
                columns: 3
                spacing: 2
                AxisPosDisplayComponent{
                    id:m0
                    name: AxisDefine.axisInfos[0].name+qsTr("Axis")+":"
    //                unit: AxisDefine.axisInfos[0].unit
                    unit:"mm"
                    bindStatus: "c_ro_0_32_3_900"
                }
                AxisPosDisplayComponent{
                    id:m1
                    name: AxisDefine.axisInfos[1].name+qsTr("Axis")+":"
    //                unit: AxisDefine.axisInfos[1].unit
                    unit:"mm"
                    bindStatus: "c_ro_0_32_3_904"

                }
                AxisPosDisplayComponent{
                    id:m2
                    name: AxisDefine.axisInfos[2].name+qsTr("Axis")+":"
    //                unit: AxisDefine.axisInfos[2].unit
                    unit:"mm"
                    bindStatus: "c_ro_0_32_3_908"

                }
                AxisPosDisplayComponent{
                    id:m3
                    name: AxisDefine.axisInfos[3].name+qsTr("Axis")+":"
    //                unit: AxisDefine.axisInfos[3].unit
                    unit:"°"
                    bindStatus: "c_ro_0_32_3_912"

                }
                AxisPosDisplayComponent{
                    id:m4
                    name: AxisDefine.axisInfos[4].name+qsTr("Axis")+":"
    //                unit: AxisDefine.axisInfos[4].unit
                    unit:"°"
                    bindStatus: "c_ro_0_32_3_916"

                }
                AxisPosDisplayComponent{
                    id:m5
                    name: AxisDefine.axisInfos[5].name+qsTr("Axis")+":"
    //                unit: AxisDefine.axisInfos[5].unit
                    unit:"°"
                    bindStatus: "c_ro_0_32_3_920"

                }
            }
            Grid{
                id:jogPos
                rows: 2
                columns: 3
                spacing: 2
                AxisPosDisplayComponent{
                    id:a0
                    name: AxisDefine.axisInfos[0].name+qsTr("Axis")+":"
    //                unit: "°"
                    bindStatus: "c_ro_0_32_0_901"
                    mode:0.001
                }
                AxisPosDisplayComponent{
                    id:a1
                    name: AxisDefine.axisInfos[1].name+qsTr("Axis")+":"
    //                unit: "°"
                    bindStatus: "c_ro_0_32_0_905"
                    mode:0.001

                }
                AxisPosDisplayComponent{
                    id:a2
                    name: AxisDefine.axisInfos[2].name+qsTr("Axis")+":"
    //                unit: "°"
                    bindStatus: "c_ro_0_32_0_909"
                    mode:0.001

                }
                AxisPosDisplayComponent{
                    id:a3
                    name: AxisDefine.axisInfos[3].name+qsTr("Axis")+":"
    //                unit: "°"
                    bindStatus: "c_ro_0_32_0_913"
                    mode:0.001

                }
                AxisPosDisplayComponent{
                    id:a4
                    name: AxisDefine.axisInfos[4].name+qsTr("Axis")+":"
    //                unit: "°"
                    bindStatus: "c_ro_0_32_0_917"
                    mode:0.001

                }
                AxisPosDisplayComponent{
                    id:a5
                    name: AxisDefine.axisInfos[5].name+qsTr("Axis")+":"
    //                unit: "°"
                    bindStatus: "c_ro_0_32_0_921"
                    mode:0.001
                }
            }

            Item{
                id:funcArea
                width: 200;height:parent.height
                Column{
                    id:coordDisplay
                    spacing: 2
                    Text {
                        id: hint
                        height: 20
                        text: qsTr("Current TableCoord:")
                        color: m0.textColor
                    }
                    Text {
                        id: coordName
                        height: 20
                        text: qsTr("0:BaseCoord")
                        color: m0.textColor
                    }
                }
                ICButton{
                    anchors.left: coordDisplay.right
                    anchors.leftMargin: 30
                    height: funcArea.height
                    text:qsTr("worldPos")
                    onButtonClicked: {
                        if(container.state == "worldPos"){
                            container.state = "jogPos";
                            text = qsTr("worldPos");
                        }
                        else{
                            container.state = "worldPos";
                            text = qsTr("jogPos");
                        }
                    }
                }

            }
        }
        onRefreshTimeOut:{
            var coords =ToolCoordManager.toolCoordManager.toolCoordNameList();
            coords.splice(0, 0, qsTr("0:BaseCoord"));
            coordName.text = coords[panelRobotController.iStatus(4)];
        }
    }

    function onAxisDefinesChanged(){
        m0.visible = AxisDefine.axisInfos[0].visiable;
        m1.visible = AxisDefine.axisInfos[1].visiable;
        m2.visible = AxisDefine.axisInfos[2].visiable;
        m3.visible = AxisDefine.axisInfos[3].visiable;
        m4.visible = AxisDefine.axisInfos[4].visiable;
        m5.visible = AxisDefine.axisInfos[5].visiable;

        a0.visible = AxisDefine.axisInfos[0].visiable;
        a1.visible = AxisDefine.axisInfos[1].visiable;
        a2.visible = AxisDefine.axisInfos[2].visiable;
        a3.visible = AxisDefine.axisInfos[3].visiable;
        a4.visible = AxisDefine.axisInfos[4].visiable;
        a5.visible = AxisDefine.axisInfos[5].visiable;

        a0.unit = AxisDefine.axisInfos[0].unit;
        a1.unit = AxisDefine.axisInfos[1].unit;
        a2.unit = AxisDefine.axisInfos[2].unit;
        a3.unit = AxisDefine.axisInfos[3].unit;
        a4.unit = AxisDefine.axisInfos[4].unit;
        a5.unit = AxisDefine.axisInfos[5].unit;

    }

    Component.onCompleted: {
        container.state = "worldPos";
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }
}
