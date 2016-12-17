import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../../utils/stringhelper.js" as ICString
import "../../utils/utils.js" as Utils

MouseArea{
    id:instance

    property int axisNameWidth: 30
    function newPointHelper(){
        var pointPos = {
            "m0":m0.configValue || 0.000,
            "m1":m1.configValue || 0.000,
            "m2":m2.configValue || 0.000,
            "m3":m3.configValue || 0.000,
            "m4":m4.configValue || 0.000,
            "m5":m5.configValue || 0.000};
        var pointName = text_name.configValue;
        pointModel.append({"pointName":pointName, "pointPos":pointPos});
    }

    function show(posData, clearOld, confirmHandler){
        if(clearOld)
            pointModel.clear();
        for(var i = 0; i < posData.length; ++i){
            pointModel.append({"pointName":posData[i].pointName, "pointPos":posData[i].pointPos});
        }
        editConfirm.connect(confirmHandler);
        visible = true;
    }

    signal editConfirm(bool accept, variant points)



    Rectangle {
        id:container
        width: parent.width
        height: parent.height

        border.width: 1
        border.color: "gray"
        color: "#A0A0F0"

        ICFileSelector{
            id:califileSelector
            visible: false;
            width: parent.width * 0.8
            height: parent.height * 0.6
            anchors.centerIn:  parent
            z:10
            onGotFileContent: {
                pointModel.clear();
                for(var i = 0, points = Utils.parseCalibration(content), len = points.length; i < len; ++i)
                {
                    pointModel.append({"pointName":qsTr("P") + i,
                                      "pointPos":points[i]});
                }

            }
        }

        Text{
            id:statistics
            text: qsTr("Total:") + pointModel.count
            anchors.right: close.left
            anchors.rightMargin: 20
        }

        ICButton{
            id:close
            text: qsTr("Close")
            anchors.right: parent.right
            onButtonClicked: {
                instance.visible = false
                editConfirm(false, []);
            }
        }
        ICButton{
            id:syncReplace
            text:qsTr("Sync Replace")
            anchors.bottom: pointViewContainer.top
            anchors.bottomMargin: 6
            anchors.left: pointViewContainer.left
            onButtonClicked: {
                var baseCurrent = pointModel.get(pointView.currentIndex).pointPos;
                var toReplace = {"m0":parseFloat(m0.configValue),"m1":parseFloat(m1.configValue),"m2":parseFloat(m2.configValue),
                    "m3":parseFloat(m3.configValue),"m4":parseFloat(m4.configValue),"m5":parseFloat(m5.configValue)};
                var diff = toReplace;
                diff.m0 -= parseFloat(baseCurrent.m0);
                diff.m1 -= parseFloat(baseCurrent.m1);
                diff.m2 -= parseFloat(baseCurrent.m2);
                diff.m3 -= parseFloat(baseCurrent.m3);
                diff.m4 -= parseFloat(baseCurrent.m4);
                diff.m5 -= parseFloat(baseCurrent.m5);

                var tmpPointPos;
                for(var i = 0, len = pointModel.count; i < len; ++i){
                    tmpPointPos = pointModel.get(i).pointPos;
                    tmpPointPos.m0 = (parseFloat(tmpPointPos.m0) + diff.m0).toFixed(3);
                    tmpPointPos.m1 = (parseFloat(tmpPointPos.m1) + diff.m1).toFixed(3);
                    tmpPointPos.m2 = (parseFloat(tmpPointPos.m2) + diff.m2).toFixed(3);
                    tmpPointPos.m3 = (parseFloat(tmpPointPos.m3) + diff.m3).toFixed(3);
                    tmpPointPos.m4 = (parseFloat(tmpPointPos.m4) + diff.m4).toFixed(3);
                    tmpPointPos.m5 = (parseFloat(tmpPointPos.m5) + diff.m5).toFixed(3);
                    pointModel.setProperty(i, "pointPos", tmpPointPos);
                }
            }
        }

        Row{
            y:365
            x:pointViewContainer.x
            spacing: 6
            ICConfigEdit{
                id:text_name
                isNumberOnly: false
                inputWidth: 165
                configName: qsTr("Point Name:")
                height: 30
            }

            ICButton{
                id:button_delet
                text: qsTr("Delete")
                height: text_name.height
                onButtonClicked: {
                    pointModel.remove(pointView.currentIndex);
                }
            }
            ICButton{
                id:button_replace
                text: qsTr("Replace")
                height: text_name.height
                onButtonClicked: {
                    var pointPos = {"m0":m0.configValue,"m1":m1.configValue,"m2":m2.configValue,
                        "m3":m3.configValue,"m4":m4.configValue,"m5":m5.configValue};
                    pointModel.set(pointView.currentIndex, {"pointName":text_name.configValue, "pointPos":pointPos});
                }
            }
        }
        Column{
            id:leftContainer
            spacing: 6
            x:10
            y:10

            ICButton{
                id:button_setWorldPos
                text: qsTr("Set In")
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
                id:button_newLocus
                text: qsTr("New")
                width: button_setWorldPos.width
                height: button_setWorldPos.height
                onButtonClicked: {
                    newPointHelper();
                }
            }

        }

        ICButton{
            id:loadCalibration
            visible: false
            text: qsTr("Load Calibration")
            width: button_setWorldPos.width
            height: button_setWorldPos.height
            anchors.bottom: saveBtn.top
            anchors.bottomMargin: 20
            anchors.left: leftContainer.left
            onButtonClicked: {
                califileSelector.visible = true;
            }
        }

        ICButton{
            id:saveBtn
            text: qsTr("Save")
            width: button_setWorldPos.width
            height: button_setWorldPos.height
            anchors.bottom: pointViewContainer.bottom
            anchors.left: leftContainer.left
            onButtonClicked: {
                var points = [];
                var p;
                for(var i = 0; i < pointModel.count; ++i){
                    p = pointModel.get(i);
                    points.push({"pointName":p.pointName, "pointPos":p.pointPos});
                }
                editConfirm(true, points);
            }
        }



        Rectangle  {
            id:pointViewContainer
            width: 460
            height: 300
            x:130
            y:50
            ListModel {
                id:pointModel
            }

            ListView {
                id:pointView
                width: parent.width
                height: parent.height
                model: pointModel
                clip: true
                highlight: Rectangle { width: 490; height: 20;color: "lightsteelblue"; radius: 2}
                highlightMoveDuration: 1
                delegate: Text {
                    verticalAlignment: Text.AlignVCenter
                    width: pointView.width
                    height: 32
                    text: {ICString.icStrformat("{0}:({1}:{2},{3}:{4},{5}:{6},{7}:{8},{9}:{10},{11}:{12})",
                                               pointName,
                                               AxisDefine.axisInfos[0].name, pointPos.m0,
                                               AxisDefine.axisInfos[1].name, pointPos.m1,
                                               AxisDefine.axisInfos[2].name, pointPos.m2,
                                               AxisDefine.axisInfos[3].name, pointPos.m3,
                                               AxisDefine.axisInfos[4].name, pointPos.m4,
                                               AxisDefine.axisInfos[5].name, pointPos.m5);
                        var ret = pointName + ":(";
                        if(AxisDefine.axisInfos[0].visiable)
                            ret += AxisDefine.axisInfos[0].name + ":" + pointPos.m0 + ","
                        if(AxisDefine.axisInfos[1].visiable)
                            ret += AxisDefine.axisInfos[1].name + ":" + pointPos.m1 + ","
                        if(AxisDefine.axisInfos[2].visiable)
                            ret += AxisDefine.axisInfos[2].name + ":" + pointPos.m2 + ","
                        if(AxisDefine.axisInfos[3].visiable)
                            ret += AxisDefine.axisInfos[3].name + ":" + pointPos.m3 + ","
                        if(AxisDefine.axisInfos[4].visiable)
                            ret += AxisDefine.axisInfos[4].name + ":" + pointPos.m4 + ","
                        if(AxisDefine.axisInfos[5].visiable)
                            ret += AxisDefine.axisInfos[5].name + ":" + pointPos.m5 + ","
                        ret = ret.slice(0, ret.length - 1);
                        ret += ")";
                        return ret;
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var iPoint = pointModel.get(index);
                            text_name.configValue  = iPoint.pointName;
                            var pointPos = iPoint.pointPos;
                            m0.configValue = pointPos.m0 || 0.000;
                            m1.configValue = pointPos.m1 || 0.000;
                            m2.configValue = pointPos.m2 || 0.000;
                            m3.configValue = pointPos.m3 || 0.000;
                            m4.configValue = pointPos.m4 || 0.000;
                            m5.configValue = pointPos.m5 || 0.000;
                            pointView.currentIndex = index;

                        }
                    }
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
    }

    Component.onCompleted: {
        AxisDefine.registerMonitors(instance);
        onAxisDefinesChanged();
    }

}
