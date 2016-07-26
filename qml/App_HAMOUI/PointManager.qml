import QtQuick 1.1
import "../ICCustomElement"
import "./teach/Teach.js" as Teach
import "configs/AxisDefine.js" as AxisDefine

MouseArea{
    id:instance
    width: parent.width
    height: parent.height

    property int axisNameWidth: 30
    function newPointHelper(type){
        var pointPos = {
            "m0":m0.configValue || 0.000,
            "m1":m1.configValue || 0.000,
            "m2":m2.configValue || 0.000,
            "m3":m3.configValue || 0.000,
            "m4":m4.configValue || 0.000,
            "m5":m5.configValue || 0.000};
        var pointName = text_name.configValue;
        var point = Teach.definedPoints.addNewPoint(pointName, pointPos, type);
        //        pointModel.append({"point":point});
    }

    function onPointsCleared(){
        pointModel.clear();
    }

    function onPointAdded(point){
        pointModel.append({"point":point});
    }

    Rectangle {
        id:container
        width: parent.width
        height: parent.height

        border.width: 1
        border.color: "gray"
        color: "#A0A0F0"

        function onPointsCleared(){
            pointModel.clear();
        }

        function onPointAdded(point){
            pointModel.append({"point":point});
        }

        Row{
            id:boxRectContainer
            anchors.bottom: pointViewContainer.top
            anchors.bottomMargin: 4
            anchors.left: pointViewContainer.left
            spacing: 6
            ICConfigEdit{
                id:boxLength
                configName: qsTr("Length(mm)")
                configValue: "0.00"
                anchors.verticalCenter: parent.verticalCenter
                decimal: 2
            }
            ICConfigEdit{
                id:boxWidth
                configName: qsTr("Width(mm)")
                configValue: "0.00"
                anchors.verticalCenter: parent.verticalCenter
                decimal: 2
            }
            ICButton{
                id:calcCenter
                text: qsTr("Calc Center to current")
                width: 157
                onButtonClicked: {
                    var l = parseFloat(boxLength.configValue);
                    var w = parseFloat(boxWidth.configValue);
                    l = l / 2;
                    w = w / 2;
                    if(pointView.currentIndex < 1) return;
                    var iPoint = pointModel.get(pointView.currentIndex).point;
                    var oPoint = pointModel.get(0).point;
                    iPoint.point.m0 = (parseFloat(oPoint.point.m0) + l).toFixed(3);
                    iPoint.point.m1 = (parseFloat(oPoint.point.m1) + w).toFixed(3);
                    pointModel.setProperty(pointView.currentIndex, "point", iPoint);

                }
            }
        }

        Row{
            y:370
            x:pointViewContainer.x
            spacing: 6
            ICConfigEdit{
                id:text_name
                isNumberOnly: false
                inputWidth: 195
                configName: qsTr("Point Name:")
            }

            ICButton{
                id:button_delet
                text: qsTr("Delete")
                height: 25
                onButtonClicked: {
                    var pl = Teach.definedPoints.pointNameList();
                    var toDelete = pointModel.get(pointView.currentIndex).point;
                    Teach.definedPoints.deletePoint(toDelete.index);
                    pointModel.remove(pointView.currentIndex);
                }
            }
            ICButton{
                id:button_replace
                text: qsTr("Replace")
                height: 25
                onButtonClicked: {
                    var pointPos = {"m0":m0.configValue,"m1":m1.configValue,"m2":m2.configValue,
                        "m3":m3.configValue,"m4":m4.configValue,"m5":m5.configValue};
                    var toUpdate  = pointModel.get(pointView.currentIndex).point;
                    toUpdate.name = toUpdate.name.substr(0,2) + toUpdate.index + ":" + text_name.configValue;
                    toUpdate.point = pointPos;
                    Teach.definedPoints.updatePoint(toUpdate.index, toUpdate);
                    pointModel.set(pointView.currentIndex, {"point":toUpdate});
                }
            }
        }
        Column{
            spacing: 6
            x:60
            y:10

            ICButton{
                id:button_setWorldPos
                text: qsTr("Set In World Pos")
                onButtonClicked: {
                    m0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                    m1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                    m2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                    m3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                    m4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                    m5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                }
                width: m0.width
            }
            ICButton{
                id:button_setJogPos
                text: qsTr("Set In Jog Pos")
                onButtonClicked: {
                    m0.configValue = (panelRobotController.statusValue("c_ro_0_32_0_901") / 1000).toFixed(3);
                    m1.configValue = (panelRobotController.statusValue("c_ro_0_32_0_905") / 1000).toFixed(3);
                    m2.configValue = (panelRobotController.statusValue("c_ro_0_32_0_909") / 1000).toFixed(3);
                    m3.configValue = (panelRobotController.statusValue("c_ro_0_32_0_913") / 1000).toFixed(3);
                    m4.configValue = (panelRobotController.statusValue("c_ro_0_32_0_917") / 1000).toFixed(3);
                    m5.configValue = (panelRobotController.statusValue("c_ro_0_32_0_921") / 1000).toFixed(3);
                }
                width: m0.width

            }
            ICConfigEdit{
                id:m0
                configName: qsTr(AxisDefine.axisInfos[0].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth
            }
            ICConfigEdit{
                id:m1
                configName: qsTr(AxisDefine.axisInfos[1].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICConfigEdit{
                id:m2
                configName: qsTr(AxisDefine.axisInfos[2].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICConfigEdit{
                id:m3
                configName: qsTr(AxisDefine.axisInfos[3].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICConfigEdit{
                id:m4
                configName: qsTr(AxisDefine.axisInfos[4].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICConfigEdit{
                id:m5
                configName: qsTr(AxisDefine.axisInfos[5].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICButton{
                id:button_newFree
                text: qsTr("New Free")
                height: 25
                width: button_setWorldPos.width
                //            x:60
                //            y:270
                onButtonClicked: {
                    //                var pointPos = {"m0":m0.configValue,"m1":m1.configValue,"m2":m2.configValue,
                    //                    "m3":m3.configValue,"m4":m4.configValue,"m5":m5.configValue};
                    //                var pointName = text_name.configValue;
                    //                var point = Teach.definedPoints.addNewPoint(pointName, pointPos);
                    //                pointModel.append({"point":point});
                    newPointHelper(Teach.DefinePoints.kPT_Free);
                }
            }

            ICButton{
                id:button_newLocus
                text: qsTr("New Locus")
                width: button_setWorldPos.width
                height: 25
                //            x:button_newFree.x
                //            y:button_newFree.y + button_newFree.height + 2
                onButtonClicked: {
                    newPointHelper(Teach.DefinePoints.kPT_Locus);
                }
            }

            ICButton{
                id:button_newOffset
                text: qsTr("New Offset")
                width: button_setWorldPos.width
                height: 25
                //            x:button_newFree.x
                //            y:button_newLocus.y + button_newLocus.height + 2
                onButtonClicked: {
                    newPointHelper(Teach.DefinePoints.kPT_Offset);
                }
            }
        }

        Rectangle  {
            id:pointViewContainer
            width: 490; height: 300
            x:200
            y:50
            ListModel {
                id:pointModel
            }

            ListView {
                id:pointView
                width: 490;height: 300
                model: pointModel
                clip: true
                highlight: Rectangle { width: 490; height: 20;color: "lightsteelblue"; radius: 2}
                highlightMoveDuration: 1
                delegate: Item {
                    width: 490;
                    height: 32
                    Text {
                        text: Teach.definedPoints.pointDescr(point, AxisDefine.axisInfos)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var iPoint = pointModel.get(index).point;
                            text_name.configValue  = Teach.definedPoints.getPointName(iPoint);
                            m0.configValue = iPoint.point.m0 || 0.000;
                            m1.configValue = iPoint.point.m1 || 0.000;
                            m2.configValue = iPoint.point.m2 || 0.000;
                            m3.configValue = iPoint.point.m3 || 0.000;
                            m4.configValue = iPoint.point.m4 || 0.000;
                            m5.configValue = iPoint.point.m5 || 0.000;
                            pointView.currentIndex = index;

                        }
                    }
                }
            }
        }

        Component.onCompleted: {
            var ps = Teach.definedPoints.pointNameList();
            for(var i = 0 ;i < ps.length;i++){
                pointModel.append({"point":Teach.definedPoints.getPoint(ps[i])});
            }
            Teach.definedPoints.registerPointsMonitor(container);
            AxisDefine.registerMonitors(instance);
            onAxisDefinesChanged();
        }
    }

    function onAxisDefinesChanged(){
        m0.visible = AxisDefine.axisInfos[0].visiable;
        m1.visible = AxisDefine.axisInfos[1].visiable;
        m2.visible = AxisDefine.axisInfos[2].visiable;
        m3.visible = AxisDefine.axisInfos[3].visiable;
        m4.visible = AxisDefine.axisInfos[4].visiable;
        m5.visible = AxisDefine.axisInfos[5].visiable;

    }
}
