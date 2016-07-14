import QtQuick 1.1

import "../Theme.js" as Theme
import "Teach.js" as Teach
import "../../utils/utils.js" as Utils
import "../../utils/stringhelper.js" as ICString
import "RecordManagementPage.js" as PData
import "../../ICCustomElement"
import "../ICOperationLog.js" as ICOperationLog

Rectangle {
    id:recordPage
    color: Theme.defaultTheme.BASE_BG
    states: [
        State {
            name: "exportMode"
            PropertyChanges { target: newRecord; enabled:false;}
            PropertyChanges { target: loadRecord; enabled:false;}
            PropertyChanges { target: copyRecord; enabled:false;}
            PropertyChanges { target: exportRecord; visible:true;}
            PropertyChanges { target: recordsView; model:recordsModel;isSelectable:true;}
        },
        State {
            name: "importMode"
            PropertyChanges { target: newRecord; enabled:false;}
            PropertyChanges { target: loadRecord; enabled:false;}
            PropertyChanges { target: copyRecord; enabled:false;}
            PropertyChanges { target: delRecord; enabled:false;}
            PropertyChanges { target: recordsView; model:backupPackageModel;}
        },
        State {
            name: "openMode"
            PropertyChanges { target: newRecord; enabled:false;}
            PropertyChanges { target: loadRecord; enabled:false;}
            PropertyChanges { target: copyRecord; enabled:false;}
            PropertyChanges { target: delRecord; enabled:false;}
            PropertyChanges { target: importRecord; visible:true;}
            PropertyChanges { target: viewBackupRecords; visible:false;}
            PropertyChanges {
                target: recordsView;
                model:usbModel;
                isSelectable:true;
            }
        },
        State {
            name: "gCodeMode"
            PropertyChanges { target: newRecord; enabled:false;}
            PropertyChanges { target: loadRecord; enabled:false;}
            PropertyChanges { target: copyRecord; enabled:false;}
            PropertyChanges { target: delRecord; enabled:false;}
            PropertyChanges { target: importGCode; visible:true;}
            PropertyChanges { target: viewBackupRecords; visible:false;}
            PropertyChanges { target: exportRecord; visible:false;}
            PropertyChanges {
                target: recordsView;
                model:gCodeModel;
                isSelectable:false;
            }
        }
    ]
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
            text:{
                if(recordsView.model != recordsModel) return ""
                return recordsView.currentIndex == -1? "":recordsModel.get(recordsView.currentIndex).name
            }
            anchors.verticalCenter: parent.verticalCenter
            width: 272

        }
        Text{
            text:qsTr("New Name:")
            anchors.verticalCenter: parent.verticalCenter

        }
        ICLineEdit{
            id:newName
            inputWidth: selectName.width
            isNumberOnly: false
        }

    }
    ICButtonGroup{
        id:usbContainer
        anchors.top: infoContainer.bottom
        anchors.topMargin: 4
        x:infoContainer.x
        spacing: 10
        mustChecked: true
        checkedIndex: 0

        ICCheckBox{
            id:localRecord
            text: qsTr("Local")
            width: 160
            isChecked: true
            onIsCheckedChanged: {
                if(isChecked){
                    recordPage.state = "";
                }
            }
        }

        ICCheckBox{
            id:exportToUsb
            text: qsTr("Export To USB")
            width: 160
            onIsCheckedChanged: {
                if(isChecked){
                    recordPage.state = "exportMode";
                }
            }
        }
        ICCheckBox{
            id:importFromUsb
            text:qsTr("Import From USB")
            width: 160
            onIsCheckedChanged: {
                if(isChecked){
                    backupPackageModel.clear();
                    var backups = JSON.parse(panelRobotController.scanUSBBackupPackages("HCBackupRobot"));
                    for(var i = 0; i < backups.length; ++i){
                        backupPackageModel.append(recordsView.createRecordItem(backups[i], undefined));
                    }
                    recordPage.state = "importMode";
                }
            }
        }
    }

    ListModel{
        id:recordsModel
    }
    ListModel{
        id:usbModel
    }
    ListModel{
        id:backupPackageModel
    }
    ListModel{
        id:gCodeModel
    }

    ListView{
        function createRecordItem(name, time, isSelected){
            return{"name":name,
                "createDatetime":time,
                "isSelected":isSelected || false
            };
        }
        property bool isSelectable: false
        property string openBackupPackage: ""

        id:recordsView
        width: parent.width * 0.8
        height: parent.height  - infoContainer.height - infoContainer.y - usbContainer.height - usbContainer.anchors.topMargin - anchors.topMargin
        x:10
        clip: true
        anchors.top: usbContainer.bottom
        anchors.topMargin: 10
        model: recordsModel
        delegate: Rectangle{
            width: parent.width - border.width
            height: 40
            border.width: 1
            border.color: "gray"
            color: recordsView.currentIndex == index ? "lightsteelblue" : "white"
            Row{
                width: parent.width
                height: parent.height
                x:4
                ICCheckBox{
                    text: ""
                    anchors.verticalCenter: parent.verticalCenter
                    visible: recordsView.isSelectable
                    onIsCheckedChanged: {
                        recordsView.model.setProperty(index, "isSelected", isChecked);
                    }
                    onVisibleChanged: {
                        if(!visible){
                            isChecked = false;
                        }
                    }

                }

                Item{
                    width: parent.width
                    height: parent.height
                    Row{
                        width: parent.width
                        height: parent.height
                        spacing: 10

                        Text{
                            text: name
                            width:parent.width * 0.5
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: createDatetime || ""
                            anchors.verticalCenter: parent.verticalCenter
                            visible: createDatetime || false

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
        }
    }
    Column{
        id:operationContainer
        anchors.left: recordsView.right
        anchors.leftMargin: -1
        y:recordsView.y
        function inputerr(text){
            var name = /^[A-Za-z0-9\u4E00-\u9FA5]+[A-Za-z0-9-_\u4E00-\u9FA5]*$/;
            if(!name.test(text)){
                tipDialog.warning(qsTr("name must be word number or underline\n and underline begin is not allowed"), qsTr("OK"));
                var err = true;
            }else err = false;
            return err;
        }
        ICButton{
            id:loadRecord
            text: qsTr("Load")
            height: 40
            onButtonClicked: {
                panelRobotController.loadRecord(selectName.text);
                ICOperationLog.appendOperationLog(qsTr("Load record ") + selectName.text);
            }
        }

        ICButton{
            id:newRecord
            text: qsTr("New")
            height: loadRecord.height
            onButtonClicked: {
                if(operationContainer.inputerr(newName.text))
                    return;
                var ret = JSON.parse(panelRobotController.newRecord(newName.text,
                                                                    Teach.generateInitProgram(), Teach.generateInitSubPrograms()));
                if(!ret.errno){
                    recordsModel.insert(0, recordsView.createRecordItem(ret.recordName, ret.createDatetime));
                    recordsView.positionViewAtBeginning();
                }
            }
        }
        ICButton{
            id:copyRecord
            text: qsTr("Copy")
            height: loadRecord.height
            onButtonClicked: {
                if(operationContainer.inputerr(newName.text))
                    return;
                var ret = JSON.parse(panelRobotController.copyRecord(newName.text,
                                                                     recordsModel.get(recordsView.currentIndex).name));
                if(!ret.errno){
                    recordsModel.insert(0, recordsView.createRecordItem(ret.recordName, ret.createDatetime));
                    recordsView.positionViewAtBeginning();
                }

            }
        }
        ICButton{
            id:delRecord
            text: qsTr("Del")
            height: loadRecord.height
            onButtonClicked: {
                if(recordsView.currentIndex < 0) return;
                if(panelRobotController.currentRecordName() == selectName.text){
                    tipDialog.warning((qsTr("This mold is using!")), qsTr("OK"));
                    return;
                }
                if(panelRobotController.deleteRecord(selectName.text)){
                    recordsModel.remove(recordsView.currentIndex);
                }
            }
        }
        ICButton{
            id:exportRecord
            text: qsTr("Export")
            height: loadRecord.height
            visible: false
            onButtonClicked: {
                var exportMolds = [];
                var record;
                for(var i = 0; i < recordsModel.count; ++i){
                    record = recordsModel.get(i);
                    if(record.isSelected){
                        exportMolds.push(record.name);
                    }
                }
                var now = new Date();
                var ret = panelRobotController.exportRobotMold(JSON.stringify(exportMolds),
                                                               "HCBackupRobot_" + Utils.formatDate(now, "yyyyMMddhhmmss"));
                console.log(ret);
                if(ret === 0)
                    tipDialog.information(qsTr("Expoert Finished!"), qsTr("OK"));
                else
                    tipDialog.warning(qsTr("No USB Found!"), qsTr("OK"));
            }
        }
        ICButton{
            id:importRecord
            text: qsTr("Import")
            height: loadRecord.height
            visible: false
            onButtonClicked: {
                if(recordsView.openBackupPackage == "") return;
                var importMolds = [];
                var record;
                var i;
                for(i = 0; i < usbModel.count; ++i){
                    record = usbModel.get(i);
                    if(record.isSelected){
                        importMolds.push(record.name);
                    }
                }
                var ret = JSON.parse(panelRobotController.importRobotMold(JSON.stringify(importMolds),
                                                                        recordsView.openBackupPackage));

                var errLog = "";
                for(i = 0; i < ret.length; ++i){
                    if(ret[i].errno === 0)
                        recordsModel.append(
                                    recordsView.createRecordItem(ret[i].recordName,
                                                                     ret[i].createDatetime));
                    else{
                        errLog += ICString.icStrformat(qsTr("Import {0} fail!\n"), ret[i].recordName);
//                        tipDialog.warning(ICString.icStrformat(qsTr("Import {0} fail!"), ret[i].recordName), qsTr("OK"));
                    }
                }
                tipDialog.information(qsTr("Import Finished!\n") + errLog, qsTr("OK"));
            }

        }
        ICButton{
            id:viewBackupRecords
            text: qsTr("Open")
            height: loadRecord.height
            visible: importFromUsb.isChecked
            onButtonClicked: {
                usbModel.clear();
                recordsView.openBackupPackage = backupPackageModel.get(recordsView.currentIndex).name;
                var molds = JSON.parse(panelRobotController.viewBackupPackageDetails(recordsView.openBackupPackage));
                for(var i = 0; i < molds.length; ++i){
                    usbModel.append(recordsView.createRecordItem(molds[i], undefined));
                }
                recordPage.state = "openMode";
            }
        }
    }

    ICMessageBox{
        id: tipDialog
//        anchors.centerIn: parent
        x:(parent.width - realWidth) >>1
        y:(parent.height - realWidth) >> 1
        z: 100
    }

    onVisibleChanged: {
        exportToUsb.setChecked(false);
        importFromUsb.setChecked(false);
    }

    Component.onCompleted: {
        var records = JSON.parse(panelRobotController.records());
        for(var i = 0; i < records.length; ++i){
            recordsModel.append(recordsView.createRecordItem(records[i].recordName, records[i].createDatetime));

        }
    }
}
