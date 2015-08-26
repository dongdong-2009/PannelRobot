import QtQuick 1.1

import "../Theme.js" as Theme
import "Teach.js" as Teach
import com.szhc.axis 1.0

import "../../ICCustomElement"

Rectangle {
    id:recordPage
    color: Theme.defaultTheme.BASE_BG

    Row{
        id:infoContainer
        x:10
        y:10
        spacing: 10
        Text {
            text: qsTr("Select Name:")
            anchors.verticalCenter: parent.verticalCenter
        }
        Text{
            id:selectName
            text: recordsView.currentIndex == -1? "":recordsModel.get(recordsView.currentIndex).name
            anchors.verticalCenter: parent.verticalCenter
            width: 200

        }
        Text{
            text:qsTr("New Name:")
            anchors.verticalCenter: parent.verticalCenter

        }
        ICLineEdit{
            id:newName
            width: 200
            isNumberOnly: false
        }
    }

    ListModel{
        id:recordsModel
    }

    ListView{
        id:recordsView
        width: parent.width * 0.8
        height: parent.height
        x:10
        anchors.top: infoContainer.bottom
        anchors.topMargin: 10
        model: recordsModel
        delegate: Rectangle{
            width: parent.width
            height: 32
            border.width: 1
            border.color: "gray"
            color: recordsView.currentIndex == index ? "lightsteelblue" : "white"
            Row{
                width: parent.width
                height: parent.height
                spacing: 10
                Text {
                    text: name
                    width:parent.width * 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: createDatetime
                    anchors.verticalCenter: parent.verticalCenter

                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    recordsView.currentIndex = index;
                }
            }
        }
    }
    Column{
        id:operationContainer
        anchors.left: recordsView.right
        y:recordsView.y
        ICButton{
            id:loadRecord
            text: qsTr("Load")
            onButtonClicked: {
                panelRobotController.loadRecord(selectName.text);
            }
        }
        ICButton{
            id:newRecord
            text: qsTr("New")
            onButtonClicked: {
                if(newName.isEmpty()){
                    tipDialog.show(qsTr("Please Enter the new record name!"));
                    return;
                }
                var ret = JSON.parse(panelRobotController.newRecord(newName.text,
                                               Teach.generateInitProgram(panelRobotController.axisDefine())));
//                console.log(ret);
                recordsModel.append({"name":ret.recordName,
                                    "createDatetime":ret.createDatetime});
            }
        }
        ICButton{
            id:copyRecord
            text: qsTr("Copy")
            onButtonClicked: {
                if(newName.isEmpty()){
                    tipDialog.show(qsTr("Please Enter the new record name!"));
                    return;
                }
//                panelRobotController.copyRecord(newName.text,
//                                                recordsModel.get(recordsView.currentIndex).name)
                var ret = JSON.parse(panelRobotController.copyRecord(newName.text,
                                    recordsModel.get(recordsView.currentIndex).name));
//                console.log(ret);
                recordsModel.append({"name":ret.recordName,
                                    "createDatetime":ret.createDatetime});
            }
        }
        ICButton{
            id:delRecord
            text: qsTr("Del")
            onButtonClicked: {
                if(recordsView.currentIndex < 0) return;
                if(panelRobotController.deleteRecord(selectName.text)){
                    recordsModel.remove(recordsView.currentIndex);
                }
            }
        }
        ICButton{
            id:importRecord
            text: qsTr("Import")
        }
        ICButton{
            id:exportRecord
            text: qsTr("Export")
        }
    }

    ICDialog{
        id: tipDialog
        anchors.centerIn: parent
        z: 100
    }

    Component.onCompleted: {
        var records = JSON.parse(panelRobotController.records());
        for(var i = 0; i < records.length; ++i){
            recordsModel.append({"name":records[i].recordName,
                                "createDatetime":records[i].createDatetime});
        }
    }
}
