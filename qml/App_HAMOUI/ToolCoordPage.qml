import QtQuick 1.1

import "../ICCustomElement"
import "configs/AxisDefine.js" as AxisDefine
import "ToolCoordManager.js" as ToolCoordManager


Item {
    width: parent.width
    height: parent.height
    ListModel{
        id:toolCoordModel
    }
    ICListView{
        id:view
        color:"white"
        width:parent.width/2
        height: parent.height - 50 - 100
        model: toolCoordModel
        highlight: Rectangle { width: view.width; height: 20;color: "lightsteelblue"; }
        highlightMoveDuration: 1
        delegate: Text {
            width:parent.width
            height: 20
            text: id+':'+name
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index;
                    var coordPoint = [];
                    coordPoint  = toolCoordModel.get(index).info.data;
                    coordName.configValue = toolCoordModel.get(index).name;
                    p1m0.configValue = coordPoint[0] || 0.000;
                    p1m1.configValue = coordPoint[1] || 0.000;
                    p1m2.configValue = coordPoint[2] || 0.000;
                    p1m3.configValue = coordPoint[3] || 0.000;
                    p1m4.configValue = coordPoint[4] || 0.000;
                    p1m5.configValue = coordPoint[5] || 0.000;

                    p2m0.configValue = coordPoint[6] || 0.000;
                    p2m1.configValue = coordPoint[7] || 0.000;
                    p2m2.configValue = coordPoint[8] || 0.000;
                    p2m3.configValue = coordPoint[9] || 0.000;
                    p2m4.configValue = coordPoint[10] || 0.000;
                    p2m5.configValue = coordPoint[11] || 0.000;

                    p3m0.configValue = coordPoint[12] || 0.000;
                    p3m1.configValue = coordPoint[13] || 0.000;
                    p3m2.configValue = coordPoint[14] || 0.000;
                    p3m3.configValue = coordPoint[15] || 0.000;
                    p3m4.configValue = coordPoint[16] || 0.000;
                    p3m5.configValue = coordPoint[17] || 0.000;
                }
            }
        }
    }

    Row{
        id:bOffset
        spacing: 6
        anchors.top: view.bottom
        anchors.right: view.right
        anchors.topMargin: 6
        Text {
            text: qsTr("B Offset Of A")
        }
        ICConfigEdit{
            id:bX
            configName: qsTr("X")
            decimal: 3
            configValue: panelRobotController.getCustomSettings("bx", 0, "BCOffset");
        }
        ICConfigEdit{
            id:bY
            configName: qsTr("Y")
            decimal: 3
            configValue: panelRobotController.getCustomSettings("by", 0, "BCOffset");
        }
    }

    Row{
        id:cOffset
        spacing: 6
        anchors.top: bOffset.bottom
        anchors.left: bOffset.left
        anchors.topMargin: 6
        Text {
            text: qsTr("C Offset Of A")
        }
        ICConfigEdit{
            id:cX
            configName: qsTr("X")
            decimal: 3
            configValue: panelRobotController.getCustomSettings("cx", 0, "BCOffset");

        }
        ICConfigEdit{
            id:cY
            decimal: 3
            configName: qsTr("Y")
            configValue: panelRobotController.getCustomSettings("cy", 0, "BCOffset");
        }
    }

    Row{
        anchors.top: cOffset.bottom
        anchors.right: view.right
        anchors.topMargin: 6
        id:bcGroup
        spacing: 6
        ICButton{
            id:saveOffset
            text: qsTr("Save Offset")
            onButtonClicked: {
                panelRobotController.setCustomSettings("bx", bX.configValue, "BCOffset", false);
                panelRobotController.setCustomSettings("by", bY.configValue, "BCOffset", false);
                panelRobotController.setCustomSettings("cx", cX.configValue, "BCOffset", false);
                panelRobotController.setCustomSettings("cy", cY.configValue, "BCOffset", true);
            }
        }

        ICButton{
            id:calcBCButton
            text: qsTr("Calc B C Coord Base Sel")
            width: 200
            onButtonClicked: {
                var coordPoint =[];
                coordPoint[0] = p1m0.getConfigValue() + bX.getConfigValue();
                coordPoint[1] = p1m1.getConfigValue() + bY.getConfigValue();
                coordPoint[2] = p1m2.getConfigValue();
                coordPoint[3] = p1m3.getConfigValue();
                coordPoint[4] = p1m4.getConfigValue();
                coordPoint[5] = p1m5.getConfigValue();
                coordPoint[6] = p2m0.getConfigValue() + bX.getConfigValue();
                coordPoint[7] = p2m1.getConfigValue() + bY.getConfigValue();
                coordPoint[8] = p2m2.getConfigValue();
                coordPoint[9] = p2m3.getConfigValue();
                coordPoint[10] = p2m4.getConfigValue();
                coordPoint[11] = p2m5.getConfigValue();
                coordPoint[12] = p3m0.getConfigValue() + bX.getConfigValue();
                coordPoint[13] = p3m1.getConfigValue() + bY.getConfigValue();
                coordPoint[14] = p3m2.getConfigValue();
                coordPoint[15] = p3m3.getConfigValue();
                coordPoint[16] = p3m4.getConfigValue();
                coordPoint[17] = p3m5.getConfigValue();
                var toolCoordName = qsTr("B Head");
                var ret =ToolCoordManager.toolCoordManager.addToolCoord(toolCoordName,coordPoint);
                toolCoordModel.append({"name":ret[1], "id":ret[0],"info":{"data":coordPoint}});
                panelRobotController.sendToolCoord(ret[0],JSON.stringify(coordPoint));


                coordPoint[0] = p1m0.getConfigValue() + cX.getConfigValue();
                coordPoint[1] = p1m1.getConfigValue() + cY.getConfigValue();
                coordPoint[2] = p1m2.getConfigValue();
                coordPoint[3] = p1m3.getConfigValue();
                coordPoint[4] = p1m4.getConfigValue();
                coordPoint[5] = p1m5.getConfigValue();
                coordPoint[6] = p2m0.getConfigValue() + cX.getConfigValue();
                coordPoint[7] = p2m1.getConfigValue() + cY.getConfigValue();
                coordPoint[8] = p2m2.getConfigValue();
                coordPoint[9] = p2m3.getConfigValue();
                coordPoint[10] = p2m4.getConfigValue();
                coordPoint[11] = p2m5.getConfigValue();
                coordPoint[12] = p3m0.getConfigValue() + cX.getConfigValue();
                coordPoint[13] = p3m1.getConfigValue() + cY.getConfigValue();
                coordPoint[14] = p3m2.getConfigValue();
                coordPoint[15] = p3m3.getConfigValue();
                coordPoint[16] = p3m4.getConfigValue();
                coordPoint[17] = p3m5.getConfigValue();
                toolCoordName = qsTr("C Head");
                ret =ToolCoordManager.toolCoordManager.addToolCoord(toolCoordName,coordPoint);
                toolCoordModel.append({"name":ret[1], "id":ret[0],"info":{"data":coordPoint}});
                panelRobotController.sendToolCoord(ret[0],JSON.stringify(coordPoint));
            }
        }
    }

    Row{
        anchors.top: bcGroup.bottom
        anchors.right: view.right
        anchors.topMargin: 10
        spacing: 20
        ICButton{
            id:newBtn
            text:qsTr("newBtn")
            onButtonClicked: {
                var coordPoint =[];
                coordPoint[0] = p1m0.getConfigValue();
                coordPoint[1] = p1m1.getConfigValue();
                coordPoint[2] = p1m2.getConfigValue();
                coordPoint[3] = p1m3.getConfigValue();
                coordPoint[4] = p1m4.getConfigValue();
                coordPoint[5] = p1m5.getConfigValue();
                coordPoint[6] = p2m0.getConfigValue();
                coordPoint[7] = p2m1.getConfigValue();
                coordPoint[8] = p2m2.getConfigValue();
                coordPoint[9] = p2m3.getConfigValue();
                coordPoint[10] = p2m4.getConfigValue();
                coordPoint[11] = p2m5.getConfigValue();
                coordPoint[12] = p3m0.getConfigValue();
                coordPoint[13] = p3m1.getConfigValue();
                coordPoint[14] = p3m2.getConfigValue();
                coordPoint[15] = p3m3.getConfigValue();
                coordPoint[16] = p3m4.getConfigValue();
                coordPoint[17] = p3m5.getConfigValue();
                var toolCoordName = coordName.configValue;
                var ret =ToolCoordManager.toolCoordManager.addToolCoord(toolCoordName,coordPoint);
                toolCoordModel.append({"name":ret[1], "id":ret[0],"info":{"data":coordPoint}});
            }
        }
        ICButton{
            id:deleteBtn
            text:qsTr("deleteBtn")
            onButtonClicked:{
                if(view.currentIndex < 0)return;
                var toDelID = toolCoordModel.get(view.currentIndex).id;
                ToolCoordManager.toolCoordManager.removeToolCoord(toDelID);
                toolCoordModel.remove(view.currentIndex);
            }
        }
    }
    Grid{
        id: posGrid
        anchors.leftMargin:  10
        anchors.left: view.right
        columns: 3
        spacing: 15
        ICButton{
            id:setP1Btn
            text:qsTr("setP1Btn")
            height: p1m0.height
            onButtonClicked: {
                p1m0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                p1m1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                p1m2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                p1m3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                p1m4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                p1m5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
            }
        }
        ICConfigEdit{
            id:p1m0
            configName: AxisDefine.axisInfos[0].name
            unit: "mm"
            configNameWidth: 15
            decimal: 3
            min:-10000
        }
        ICConfigEdit{
            id:p1m3
            configName: AxisDefine.axisInfos[3].name
            unit: "°"
            configNameWidth: p1m0.configNameWidth
            decimal: 3
            min:-10000
        }

        Text {
            text: (" ")
        }
        ICConfigEdit{
            id:p1m1
            configName: AxisDefine.axisInfos[1].name
            unit: "mm"
            configNameWidth: p1m0.configNameWidth
            decimal: 3
            min:-10000
        }
        ICConfigEdit{
            id:p1m4
            configName: AxisDefine.axisInfos[4].name
            unit: "°"
            configNameWidth: p1m0.configNameWidth
            decimal: 3
            min:-10000
        }

        Text{
            text:(" ")
        }
        ICConfigEdit{
            id:p1m2
            configName: AxisDefine.axisInfos[2].name
            unit: "mm"
            configNameWidth: p1m0.configNameWidth
            decimal: 3
            min:-10000
        }
        ICConfigEdit{
            id:p1m5
            configName: AxisDefine.axisInfos[5].name
            unit: "°"
            configNameWidth: p1m0.configNameWidth
            decimal: 3
            min:-10000
        }


            ICButton{
                id:setP2Btn
                text:qsTr("setP2Btn")
                height: p2m0.height
                onButtonClicked: {
                    p2m0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                    p2m1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                    p2m2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                    p2m3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                    p2m4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                    p2m5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                }
            }
            ICConfigEdit{
                id:p2m0
                configName: AxisDefine.axisInfos[0].name
                unit: "mm"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }
            ICConfigEdit{
                id:p2m3
                configName: AxisDefine.axisInfos[3].name
                unit: "°"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }

            Text {
                text: (" ")
            }
            ICConfigEdit{
                id:p2m1
                configName: AxisDefine.axisInfos[1].name
                unit: "mm"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }
            ICConfigEdit{
                id:p2m4
                configName: AxisDefine.axisInfos[4].name
                unit: "°"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }

            Text{
                text:(" ")
            }
            ICConfigEdit{
                id:p2m2
                configName: AxisDefine.axisInfos[2].name
                unit: "mm"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }
            ICConfigEdit{
                id:p2m5
                configName: AxisDefine.axisInfos[5].name
                unit: "°"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
        }

            ICButton{
                id:setP3Btn
                text:qsTr("setP3Btn")
                height: p3m0.height
                onButtonClicked: {
                    p3m0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                    p3m1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                    p3m2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                    p3m3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                    p3m4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                    p3m5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                }
            }
            ICConfigEdit{
                id:p3m0
                configName: AxisDefine.axisInfos[0].name
                unit: "mm"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }
            ICConfigEdit{
                id:p3m3
                configName: AxisDefine.axisInfos[3].name
                unit: "°"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }

            Text {
                text: (" ")
            }
            ICConfigEdit{
                id:p3m1
                configName: AxisDefine.axisInfos[1].name
                unit: "mm"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }
            ICConfigEdit{
                id:p3m4
                configName: AxisDefine.axisInfos[4].name
                unit: "°"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }

            Text{
                text:(" ")
            }
            ICConfigEdit{
                id:p3m2
                configName: AxisDefine.axisInfos[2].name
                unit: "mm"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
            }
            ICConfigEdit{
                id:p3m5
                configName: AxisDefine.axisInfos[5].name
                unit: "°"
                configNameWidth: p1m0.configNameWidth
                decimal: 3
                min:-10000
        }
    }
    Row{
        spacing:40
        anchors.top: posGrid.bottom
        anchors.right: posGrid.right
        anchors.topMargin: 15
        ICConfigEdit{
            id:coordName
            isNumberOnly: false
            configName: qsTr("coordName")
            configNameWidth: 90
            inputWidth:120
        }
        ICButton{
            id:confirmBtn
            text:qsTr("confirmBtn")
            onButtonClicked: {
                var coordPoint =[];
                coordPoint[0] = p1m0.getConfigValue();
                coordPoint[1] = p1m1.getConfigValue();
                coordPoint[2] = p1m2.getConfigValue();
                coordPoint[3] = p1m3.getConfigValue();
                coordPoint[4] = p1m4.getConfigValue();
                coordPoint[5] = p1m5.getConfigValue();
                coordPoint[6] = p2m0.getConfigValue();
                coordPoint[7] = p2m1.getConfigValue();
                coordPoint[8] = p2m2.getConfigValue();
                coordPoint[9] = p2m3.getConfigValue();
                coordPoint[10] = p2m4.getConfigValue();
                coordPoint[11] = p2m5.getConfigValue();
                coordPoint[12] = p3m0.getConfigValue();
                coordPoint[13] = p3m1.getConfigValue();
                coordPoint[14] = p3m2.getConfigValue();
                coordPoint[15] = p3m3.getConfigValue();
                coordPoint[16] = p3m4.getConfigValue();
                coordPoint[17] = p3m5.getConfigValue();
                var toolCoordName = coordName.configValue;
                var toolCoordID = toolCoordModel.get(view.currentIndex).id
                ToolCoordManager.toolCoordManager.updateToolCoord(toolCoordID,toolCoordName,coordPoint);
                toolCoordModel.set(view.currentIndex,{"name":toolCoordName, "id":toolCoordID, "info":{"data":coordPoint}});
                panelRobotController.sendToolCoord(toolCoordID,JSON.stringify(coordPoint));
            }
        }
    }

    Component.onCompleted: {
        var toolCoords = ToolCoordManager.toolCoordManager.toolCoordList();
        for(var i =0;i<toolCoords.length;++i){
            toolCoordModel.append({"name":toolCoords[i].name, "id":toolCoords[i].id, "info":{"data":toolCoords[i].info}});

        }
    }

}
