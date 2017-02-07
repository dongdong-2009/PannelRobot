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
        width:parent.width*2/3-20
        height: parent.height - 50
        model: toolCoordModel
        highlight: Rectangle { width: view.width; height: 30;color: "lightsteelblue"; }
        highlightMoveDuration: 1
        delegate: Text {
            width:parent.width
            height: 30
            text: id+':'+name
            MouseArea{
                id:selItem
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index;
                }
            }
        }
        onCurrentItemChanged:{
            var coordPoint = [];
            coordPoint  = toolCoordModel.get(currentIndex).info.data;
            coordName.configValue = toolCoordModel.get(currentIndex).name;
            p1m0.configValue = coordPoint[0]? coordPoint[0].toFixed(3):"0.000";
            p1m1.configValue = coordPoint[1]? coordPoint[1].toFixed(3):"0.000";
            p1m2.configValue = coordPoint[2]? coordPoint[2].toFixed(3):"0.000";

            p2m0.configValue = coordPoint[3]? coordPoint[3].toFixed(3):"0.000";
            p2m1.configValue = coordPoint[4]? coordPoint[4].toFixed(3):"0.000";
            p2m2.configValue = coordPoint[5]? coordPoint[5].toFixed(3):"0.000";

            p3m0.configValue = coordPoint[6]? coordPoint[6].toFixed(3):"0.000";
            p3m1.configValue = coordPoint[7]? coordPoint[7].toFixed(3):"0.000";
            p3m2.configValue = coordPoint[8]? coordPoint[8].toFixed(3):"0.000";
        }
    }
    Row{
        anchors.top: view.bottom
        anchors.right: view.right
        anchors.topMargin: 10
        spacing: 20
        ICConfigEdit{
            id:coordName
            isNumberOnly: false
            configName: qsTr("coordName")
            configNameWidth: 90
            inputWidth:120
        }
        ICButton{
            id:newBtn
            text:qsTr("newBtn")
            onButtonClicked: {
                var coordPoint =[];
                coordPoint[0] = p1m0.getConfigValue();
                coordPoint[1] = p1m1.getConfigValue();
                coordPoint[2] = p1m2.getConfigValue();

                coordPoint[3] = p2m0.getConfigValue();
                coordPoint[4] = p2m1.getConfigValue();
                coordPoint[5] = p2m2.getConfigValue();

                coordPoint[6] = p3m0.getConfigValue();
                coordPoint[7] = p3m1.getConfigValue();
                coordPoint[8] = p3m2.getConfigValue();

                var toolCoordName = coordName.configValue;
                var ret =ToolCoordManager.toolCoordManager.addToolCoord(toolCoordName,coordPoint);
                toolCoordModel.append({"name":ret[1], "id":ret[0],"info":{"data":coordPoint}});
                panelRobotController.sendToolCoord(ret[0],JSON.stringify(coordPoint));
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
        columns: 2
        spacing: 15
        ICButton{
            id:setP1Btn
            text:qsTr("setP1Btn")
            height: p1m0.height
            onButtonClicked: {
                p1m0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                p1m1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                p1m2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
            }
        }
        ICConfigEdit{
            id:p1m0
            configName: AxisDefine.axisInfos[0].name
            unit: "mm"
            configNameWidth: 18
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

        ICButton{
            id:setP2Btn
            text:qsTr("setP2Btn")
            height: p2m0.height
            onButtonClicked: {
                p2m0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                p2m1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                p2m2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
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

        ICButton{
            id:setP3Btn
            text:qsTr("setP3Btn")
            height: p3m0.height
            onButtonClicked: {
                p3m0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                p3m1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                p3m2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
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
    }
    ICButton{
        id:confirmBtn
        anchors.top: posGrid.bottom
        anchors.right: posGrid.right
        anchors.topMargin: 15
        text:qsTr("confirmBtn")
        onButtonClicked: {
            if(view.currentIndex < 0) return;
            var coordPoint =[];
            coordPoint[0] = p1m0.getConfigValue();
            coordPoint[1] = p1m1.getConfigValue();
            coordPoint[2] = p1m2.getConfigValue();

            coordPoint[3] = p2m0.getConfigValue();
            coordPoint[4] = p2m1.getConfigValue();
            coordPoint[5] = p2m2.getConfigValue();

            coordPoint[6] = p3m0.getConfigValue();
            coordPoint[7] = p3m1.getConfigValue();
            coordPoint[8] = p3m2.getConfigValue();

            var toolCoordName = coordName.configValue;
            var toolCoordID = toolCoordModel.get(view.currentIndex).id
            ToolCoordManager.toolCoordManager.updateToolCoord(toolCoordID,toolCoordName,coordPoint);
            toolCoordModel.set(view.currentIndex,{"name":toolCoordName, "id":toolCoordID, "info":{"data":coordPoint}});
            panelRobotController.sendToolCoord(toolCoordID,JSON.stringify(coordPoint));
        }
    }

    Component.onCompleted: {
        var toolCoords = ToolCoordManager.toolCoordManager.toolCoordList();
        for(var i =0;i<toolCoords.length;++i){
            toolCoordModel.append({"name":toolCoords[i].name, "id":toolCoords[i].id, "info":{"data":toolCoords[i].info}});
        }
    }
}
