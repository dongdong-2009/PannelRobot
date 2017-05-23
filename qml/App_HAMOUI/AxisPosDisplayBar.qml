import QtQuick 1.1

import "."
import "../ICCustomElement/"
import "configs/AxisDefine.js" as AxisDefine
import "ToolCoordManager.js" as ToolCoordManager
import "ShareData.js" as ShareData

Item {
    id:container
    x:4
    function setWorldPosVisible(en){
        worldPos.visible = en;
    }

    function setJogPosVisible(en){
        jogPos.visible = en;
    }

    function setCurrentState(barState){
        container.state = barState;
    }


    states: [
        State {
            name: "jogPos"
            PropertyChanges { target: jogPos; visible: true}
            PropertyChanges { target: worldPos; visible: false}
            PropertyChanges { target: hint; text:qsTr("JogCoord")}
            PropertyChanges { target: coordName; text: qsTr("")}
            PropertyChanges { target: w; color: "gray"}
            PropertyChanges { target: j; color: "black"}
        },
        State {
            name: "worldPos"
            PropertyChanges { target: worldPos; visible: true}
            PropertyChanges { target: jogPos; visible: false}
            PropertyChanges { target: hint; text:qsTr("worldCoord")}
            PropertyChanges { target: w; color: "black"}
            PropertyChanges { target: j; color: "gray"}
        }
    ]

    ICStatusScope{
        width: 793
        height: 42
            Grid{
                id:worldPos
                rows: 2
                columns: 3
                spacing: 2
                AxisPosDisplayComponent{
                    id:m0
                    name: AxisDefine.axisInfos[0].name+qsTr("Axis")+":"
                    unit:"mm"
                    bindStatus: "c_ro_0_32_3_900"
                }
                AxisPosDisplayComponent{
                    id:m1
                    name: AxisDefine.axisInfos[1].name+qsTr("Axis")+":"
                    unit:"mm"
                    bindStatus: "c_ro_0_32_3_904"
                }
                AxisPosDisplayComponent{
                    id:m2
                    name: AxisDefine.axisInfos[2].name+qsTr("Axis")+":"
                    unit:"mm"
                    bindStatus: "c_ro_0_32_3_908"
                }
                AxisPosDisplayComponent{
                    id:m3
                    name: AxisDefine.axisInfos[3].name+qsTr("Axis")+":"
                    unit:"°"
                    bindStatus: "c_ro_0_32_3_912"
                }
                AxisPosDisplayComponent{
                    id:m4
                    name: AxisDefine.axisInfos[4].name+qsTr("Axis")+":"
                    unit:"°"
                    bindStatus: "c_ro_0_32_3_916"
                }
                AxisPosDisplayComponent{
                    id:m5
                    name: AxisDefine.axisInfos[5].name+qsTr("Axis")+":"
                    unit:"°"
                    bindStatus: "c_ro_0_32_3_920"
                }
            }
            Grid{
                id:jogPos
                rows: 2
                columns: 4
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
                AxisPosDisplayComponent{
                    id:a6
                    name: AxisDefine.axisInfos[6].name+qsTr("Axis")+":"
    //                unit: "°"
                    bindStatus: "c_ro_0_32_0_925"
                    mode:0.001
                }
                AxisPosDisplayComponent{
                    id:a7
                    name: AxisDefine.axisInfos[7].name+qsTr("Axis")+":"
    //                unit: "°"
                    bindStatus: "c_ro_0_32_0_929"
                    mode:0.001
                }
            }

        Item{
            id:funcArea
            height:parent.height
            anchors.right:parent.right
            Rectangle{
                id:switchBtn
                y:1
                height: parent.height-3 //39
                width: 60
                anchors.right: parent.right
                anchors.rightMargin: 1
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        if(container.state == "worldPos"){
                            container.state = "jogPos";
                        }
                        else{
                            container.state = "worldPos";
                        }
                        ShareData.barStatus = container.state;
                    }
                }
                Rectangle{
                    id:splitJW
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    height: 2
                    width: Math.sqrt((parent.height*parent.height+ parent.width*parent.width))
                    transformOrigin:Item.Left
                    rotation: -Math.atan2(parent.height,parent.width)*180/Math.PI
                    color: "green"
                    smooth: true
                }
                Text {
                    id: w
                    anchors.left: parent.left
                    anchors.leftMargin: 3
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    font.pixelSize: 20
                    font.weight:Font.Bold
                    text: "W"
                }
                Text {
                    id: j
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3
                    font.pixelSize: 20
                    font.weight:Font.Bold
                    text: "J"
                }

            }
            Rectangle{
                id:splitLine
                anchors.right: switchBtn.left
                height: parent.height
                width: 3
                color: "green"
            }
            Column{
                id:coordDisplay
                property int coordIDOld: 0
                anchors.right: splitLine.left
                anchors.rightMargin: 20
                spacing: 2
                Text {
                    id: hint
                    height: 20
                    color: m0.textColor
                }
                Text {
                    id: coordName
                    height: 20
                    color: m0.textColor
                }
            }
        }
        onRefreshTimeOut:{
            if(container.state == "worldPos"){
                var coordID = panelRobotController.iStatus(4)&0xff;
                if(coordDisplay.coordIDOld !== coordID){
                    coordDisplay.coordIDOld = coordID;
                    var coords =ToolCoordManager.toolCoordManager.toolCoordNameList();
                    coords.splice(0, 0, qsTr(""));
                    coordName.text = coords[coordDisplay.coordIDOld];
                }
            }
        }
    }

    function onAxisDefinesChanged(){
        m0.visible = AxisDefine.axisInfos[0].visiable;
        m1.visible = AxisDefine.axisInfos[1].visiable;
        m2.visible = AxisDefine.axisInfos[2].visiable;
        m3.visible = AxisDefine.axisInfos[3].visiable;
        m4.visible = AxisDefine.axisInfos[4].visiable;
        m5.visible = AxisDefine.axisInfos[5].visiable;

        if(AxisDefine.axisInfos[6].visiable || AxisDefine.axisInfos[7].visiable){
            jogPos.columns = 4;
        }
        else
            jogPos.columns = 3;
        a0.visible = AxisDefine.axisInfos[0].visiable;
        a1.visible = AxisDefine.axisInfos[1].visiable;
        a2.visible = AxisDefine.axisInfos[2].visiable;
        a3.visible = AxisDefine.axisInfos[3].visiable;
        a4.visible = AxisDefine.axisInfos[4].visiable;
        a5.visible = AxisDefine.axisInfos[5].visiable;
        a6.visible = AxisDefine.axisInfos[6].visiable;
        a7.visible = AxisDefine.axisInfos[7].visiable;

        a0.unit = AxisDefine.axisInfos[0].unit;
        a1.unit = AxisDefine.axisInfos[1].unit;
        a2.unit = AxisDefine.axisInfos[2].unit;
        a3.unit = AxisDefine.axisInfos[3].unit;
        a4.unit = AxisDefine.axisInfos[4].unit;
        a5.unit = AxisDefine.axisInfos[5].unit;
        a6.unit = AxisDefine.axisInfos[6].unit;
        a7.unit = AxisDefine.axisInfos[7].unit;
    }

    Component.onCompleted: {
        container.state = "worldPos";
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }
}
