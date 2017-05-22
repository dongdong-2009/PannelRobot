import QtQuick 1.1
import "../ICCustomElement"
import "configs/AxisDefine.js" as AxisDefine
import "ToolsCalibration.js" as ToolsCalibrationManager

Item {
    id:root
    width: parent.width
    height: parent.height
    property variant pulseAddr:["c_ro_0_32_0_901","c_ro_0_32_0_905","c_ro_0_32_0_909",
        "c_ro_0_32_0_913","c_ro_0_32_0_917","c_ro_0_32_0_921"]
    property variant worldAddr:["c_ro_0_32_3_900","c_ro_0_32_0_904","c_ro_0_32_0_908",
        "c_ro_0_32_0_912","c_ro_0_32_0_916","c_ro_0_32_0_920"]

    function readPulse(){
        return [panelRobotController.statusValue(pulseAddr[0])/1000,
                panelRobotController.statusValue(pulseAddr[1])/1000,
                panelRobotController.statusValue(pulseAddr[2])/1000,
                panelRobotController.statusValue(pulseAddr[3])/1000,
                panelRobotController.statusValue(pulseAddr[4])/1000,
                panelRobotController.statusValue(pulseAddr[5])/1000];
    }

    function pulseToText(pulses){
        return AxisDefine.axisInfos[0].name + ":" +  parseInt(pulses[0]*1000) + "," +
                AxisDefine.axisInfos[1].name + ":" + parseInt(pulses[1]*1000) + "," +
                AxisDefine.axisInfos[2].name + ":" + parseInt(pulses[2]*1000) + "," +"\n"+
                AxisDefine.axisInfos[3].name + ":" + parseInt(pulses[3]*1000) + "," +
                AxisDefine.axisInfos[4].name + ":" + parseInt(pulses[4]*1000) + "," +
                AxisDefine.axisInfos[5].name + ":" + parseInt(pulses[5])*1000;
    }

    ListModel{
        id:toolsModel
    }
    ICListView{
        id:toolsView
        color: "white"
        width: parent.width*0.5
        height: parent.height -50
        model: toolsModel
        highlight: Rectangle { width: toolsView.width; height: 30;color: "lightsteelblue"; }
        highlightMoveDuration: 1
        delegate: Text{
            width: parent.width
            height: 30
            text: id+": "+name+"["+(type==0?qsTr("Four Point"):qsTr("Two Point"))+"]"
            MouseArea{
                id:toolsItem
                anchors.fill: parent
                onClicked: {
                    toolsView.currentIndex = index;
                }
            }
        }
        onCurrentItemChanged:{
            if(currentIndex<0)return;
            var i,j;
            var tmpToolPoint = [];
            var tmpVar;
            tmpToolPoint  = toolsModel.get(currentIndex).info.data;
            toolName.configValue = toolsModel.get(currentIndex).name;
            typeSel.configValue = toolsModel.get(currentIndex).type;
            if(typeSel.configValue == 0){
                for(i=0;i<4;++i){
                    tmpVar = tmpToolPoint.slice(i*6,((i+1)*6));
                    pulseArea.itemAt(i).pulseDatas = tmpVar;
                }
            }
            else if(typeSel.configValue == 1){
                for(i=0;i<6;i++){
                    terPos.itemAt(i).configValue = tmpToolPoint[i];
                }
                for(i=0;i<6;i++){
                    devPos.itemAt(i).configValue = tmpToolPoint[i+6];
                }
            }
        }
    }

    Row{
        anchors.top: toolsView.bottom
        anchors.right: toolsView.right
        anchors.topMargin: 10
        spacing: 20
        ICButton{
            id:newBtn
            text:qsTr("newBtn")
            onButtonClicked: {
                var tmpToolPoint =[];
                var i,j,tmpToolType =0;
                if(fourPoint.visible){
                    tmpToolType = 0;
                    for(i=0;i<4;++i){
                        tmpToolPoint = tmpToolPoint.concat(pulseArea.itemAt(i).pulseDatas);
                    }

                }
                else if(twoPoint.visible){
                    tmpToolType = 1;
                    for(i=0;i<6;i++){
                        tmpToolPoint[i] = terPos.itemAt(i).configValue;
                    }
                    for(i=0;i<6;i++){
                        tmpToolPoint[i+6] = devPos.itemAt(i).configValue;
                    }
                }

                var tmpToolName = toolName.configValue;
                var tmpToolID =ToolsCalibrationManager.toolCalibrationManager.addToolCalibration(tmpToolType,tmpToolName,tmpToolPoint);
                toolsModel.append({"type":tmpToolType,"name":tmpToolName, "id":tmpToolID,"info":{"data":tmpToolPoint}});
                panelRobotController.sendToolCalibration((tmpToolID|(tmpToolType<<16)),JSON.stringify(tmpToolPoint));
                toolsView.currentIndex = toolsModel.count - 1;
            }
        }
        ICButton{
            id:deleteBtn
            text:qsTr("deleteBtn")
            onButtonClicked:{
                if(toolsView.currentIndex < 0)return;
                var toDelID = toolsModel.get(toolsView.currentIndex).id;
                ToolsCalibrationManager.toolCalibrationManager.removeToolCalibration(toDelID);
                toolsModel.remove(toolsView.currentIndex);
            }
        }
    }

    Column{
        id:content
        spacing: 10
        anchors.left: toolsView.right
        anchors.leftMargin: 10
        ICConfigEdit{
            id:toolName
            isNumberOnly: false
            configName: qsTr("toolName")
            configNameWidth: 90
            inputWidth:120
        }
        ICComboBoxConfigEdit{
            id:typeSel
            configName: qsTr("Tool Type Sel")
            items: [qsTr("Four Point"),qsTr("Two Point")]
            configValue: 0
        }

        Column{
            id:fourPoint
            visible: typeSel.configValue === 0
            spacing: 10
            Repeater{
                id:pulseArea
                model: 4
                Row{
                    spacing: 10
                    property variant pulseDatas:[0,0,0,0,0,0]
                    ICButton{
                        id:p
                        width: 80
                        height: typeSel.height
                        text: qsTr("Set to P")+(index+1)
                        onButtonClicked: {
                            pulseDatas = root.readPulse();
                        }
                    }
                    Text {
                        id: pShow
                        text: pulseToText(pulseDatas)
                        height: p.height*2
                    }
                }
            }

            onVisibleChanged: {
                panelRobotController.swichPulseAngleDisplay(visible ? 1 : 0);
            }
        }

        Row{
           id:twoPoint
           visible: typeSel.configValue === 1
           spacing: 30
           Column{
               spacing: 10
               ICButton{
                   id:termianalSetBtn
                   text: qsTr("T Set")
                   height: typeSel.height
                   width: 80
                   onButtonClicked: {
                       for(var i=0;i<6;++i){
                           terPos.itemAt(i).configValue = panelRobotController.statusValueText(root.worldAddr[i]);
                       }
                   }
               }
               Repeater{
                   id:terPos
                   model: 6
                   ICConfigEdit{
                       configName: AxisDefine.axisInfos[index].name
                       configNameWidth:20
                       unit: index<3?"mm":"°"
                       min:-10000
                       max:10000
                       decimal: 3
                       configValue: "0.000"
                   }
               }
           }
           Column{
               spacing: 10
               Text {
                   id: toolDev
                   height: termianalSetBtn.height
                   text: qsTr("Tool Dev:")
               }
               Repeater{
                   id:devPos
                   model: 6
                   ICConfigEdit{
                       configName: AxisDefine.axisInfos[index].name
                       configNameWidth:20
                       unit: index<3?"mm":"°"
                       min:-10000
                       max:10000
                       decimal: 3
                       configValue: "0.000"
                   }
               }
           }
       }
    }

    ICButton{
        id:confirmBtn
        anchors.top: content.bottom
        anchors.right: content.right
        anchors.topMargin: 15
        text:qsTr("confirmBtn")
        onButtonClicked: {
            if(toolsView.currentIndex < 0) return;
            var tmpToolPoint =[];
            var i,j,tmpToolType =0;
            if(fourPoint.visible){
                tmpToolType = 0;
                for(i=0;i<4;++i){
                    tmpToolPoint = tmpToolPoint.concat(pulseArea.itemAt(i).pulseDatas);
                }
            }
            else if(twoPoint.visible){
                tmpToolType = 1;
                for(i=0;i<6;i++){
                    tmpToolPoint[i] = terPos.itemAt(i).configValue;
                }
                for(i=0;i<6;i++){
                    tmpToolPoint[i+6] = devPos.itemAt(i).configValue;
                }
            }

            var tmpToolName = toolName.configValue;
            var tmpToolID = toolsModel.get(toolsView.currentIndex).id
            ToolsCalibrationManager.toolCalibrationManager.updateToolCalibration(tmpToolID,tmpToolType,tmpToolName,tmpToolPoint);
            toolsModel.set(toolsView.currentIndex,{"type":tmpToolType,"name":tmpToolName, "id":tmpToolID, "info":{"data":tmpToolPoint}});
            panelRobotController.sendToolCalibration((tmpToolID|(tmpToolType<<16)),JSON.stringify(tmpToolPoint));
        }
    }
    Component.onCompleted: {
        var tmptools = ToolsCalibrationManager.toolCalibrationManager.toolCalibrationList();
        for(var i =0;i<tmptools.length;++i){
            toolsModel.append({"type":tmptools[i].type,"name":tmptools[i].name, "id":tmptools[i].id, "info":{"data":tmptools[i].info}});
        }
    }
}
