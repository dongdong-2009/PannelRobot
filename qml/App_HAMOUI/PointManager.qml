import QtQuick 1.1
import QtQuick 1.0
import "../ICCustomElement"
import "./teach/Teach.js" as Teach
import "configs/AxisDefine.js" as AxisDefine


Rectangle {
    id:container
    width: parent.width
    height: parent.height

    border.width: 1
    border.color: "gray"
    color: "#A0A0F0"

    ICButton{
        id:button_loadin
        text: qsTr("Load in")
        x:80
        y:10
        onButtonClicked: {
            console.log("load in");

        }
    }
    ICButton{
        id:button_new
        text: qsTr("New")
        height: 25
        x:315
        y:350
        onButtonClicked: {
            var pointPos = {"m0":m0.configValue,"m1":m1.configValue,"m2":m2.configValue,
                "m3":m3.configValue,"m4":m4.configValue,"m5":m5.configValue};
            var pointName = text_name.configValue;
            var point = Teach.definedPoints.addNewPoint(pointName, pointPos);
            pointModel.append({"point":point});
        }
    }
    ICButton{
        id:button_delet
        text: qsTr("Delete")
        height: 25
        x:450
        y:350
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
        x:585
        y:350
        onButtonClicked: {
            var pointPos = {"m0":m0.configValue,"m1":m1.configValue,"m2":m2.configValue,
                "m3":m3.configValue,"m4":m4.configValue,"m5":m5.configValue};
            var toUpdate  = pointModel.get(pointView.currentIndex).point;
            toUpdate.name = "P" + toUpdate.index + ":" + text_name.configValue;
            toUpdate.point = pointPos;
            Teach.definedPoints.updatePoint(toUpdate.index, toUpdate);
            pointModel.set(pointView.currentIndex, {"point":toUpdate});
        }
    }
    ICConfigEdit{
        id:text_name
        isNumberOnly: false
        height: 400
        x:200
        y:350
    }
    ICConfigEdit{
        id:m0
        configName: qsTr(AxisDefine.axisInfos[0].name)
        x:70
        y:50
    }
    ICConfigEdit{
        id:m1
        configName: qsTr(AxisDefine.axisInfos[1].name)
        x:70
        y:100
    }
    ICConfigEdit{
        id:m2
        configName: qsTr(AxisDefine.axisInfos[2].name)
        x:70
        y:150
    }
    ICConfigEdit{
        id:m3
        configName: qsTr(AxisDefine.axisInfos[3].name)
        x:70
        y:200
    }
    ICConfigEdit{
        id:m4
        configName: qsTr(AxisDefine.axisInfos[4].name)
        x:70
        y:250
    }
    ICConfigEdit{
        id:m5
        configName: qsTr(AxisDefine.axisInfos[5].name)
        x:70
        y:300
    }

    Rectangle  {
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
            highlight: Rectangle { width: 490; height: 20;color: "lightsteelblue"; radius: 5}
            delegate: Item {
                width: 490;
                height: 20
                Text {
                    text: Teach.definedPoints.pointDescr(point)
                    anchors.verticalCenter: parent.verticalCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
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
    }
}
