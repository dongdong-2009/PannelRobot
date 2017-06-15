import QtQuick 1.1

import "../Theme.js" as Theme
import "Teach.js" as Teach
import "../../utils/utils.js" as Utils
import "../../utils/stringhelper.js" as ICString
import "../../utils/Storage.js" as Storage
//import com.szhc.axis 1.0

import "../../ICCustomElement"
import "../ICOperationLog.js" as ICOperationLog
import "../ExternalData.js" as ESData


Rectangle {
    function onGetVisionData(visionData){
        if(visionData.reqType == "listModel"){
            visionModel.clear();
            var models = visionData.data;
            var subModels;
            var current = visionData.currentModel;
            var currentIndex = 0;
            for(var i = 0, len = models.length; i < len; ++i){
                subModels = models[i].models;
                for(var j = 0, sLen = subModels.length; j < sLen; ++j){
                    if(current.name == models[i].name &&
                            current.modelID == subModels[j].id){
                        currentIndex = visionModel.count;
                    }

                    visionModel.append({
                                           "name":models[i].name + "[" + subModels[j].id + "]",
                                           "offsetX":subModels[j].offsetX,
                                           "offsetY":subModels[j].offsetY,
                                           "offsetA":subModels[j].offsetA,
                                           "modelImgPath":subModels[j].modelImgPath
                                       });
                }
            }
        }
    }

    MouseArea{
        anchors.fill: parent
    }
    color: Theme.defaultTheme.BASE_BG

    ICButtonGroup{
        id:recordType
        mustChecked: true
        checkedIndex: 0
        spacing: 48
        x:48
        ICCheckBox{
            id:robot
            text: qsTr("Robot")
            isChecked: true
        }
        ICCheckBox{
            id:vision
            text: qsTr("Vision")
        }
    }
    Rectangle{
        id:splitLine
        width: parent.width
        height: 1
        color: "black"
        anchors.top: recordType.bottom

    }

    Rectangle {
        id:recordPage
        anchors.top: splitLine.bottom
        anchors.topMargin: 4
        color: Theme.defaultTheme.BASE_BG
        width: parent.width
        height: parent.height - recordType.height - anchors.topMargin
        visible: robot.isChecked
        states: [
            State {
                name: "exportMode"
                PropertyChanges { target: newRecord; enabled:false;}
                PropertyChanges { target: loadRecord; enabled:false;}
                PropertyChanges { target: copyRecord; enabled:false;}
                PropertyChanges { target: delRecord; enabled:false;}
                PropertyChanges { target: exportRecord; visible:true;}
                PropertyChanges { target: recordsView; model:recordsModel;isSelectable:true;}
            },
            State {
                name: "importMode"
                PropertyChanges { target: newRecord; enabled:false;}
                PropertyChanges { target: loadRecord; enabled:false;}
                PropertyChanges { target: copyRecord; enabled:false;}
                PropertyChanges { target: delRecord; enabled:false;}
                PropertyChanges { target: returnUp; visible:false;}
                PropertyChanges { target: recordsView; model:backupPackageModel;}
            },
            State {
                name: "openMode"
                PropertyChanges { target: newRecord; enabled:false;}
                PropertyChanges { target: loadRecord; enabled:false;}
                PropertyChanges { target: copyRecord; enabled:false;}
                PropertyChanges { target: delRecord; enabled:false;}
                PropertyChanges { target: importRecord; visible:true;}
                PropertyChanges { target: returnUp; visible:true;}
                PropertyChanges { target: viewBackupRecords; visible:false;}
                PropertyChanges {
                    target: recordsView;
                    model:usbModel;
                    isSelectable:true;
                }

            }
        ]
        onStateChanged: {
            if(state == "exportMode"){
                recordsView.model = null;
                for(var i = 0, len = recordsModel.count; i < len; ++i){
                    recordsModel.setProperty(i, "isSelected", false);
                }
                recordsView.model = recordsModel;
            }
        }

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
                width: 200
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
                width: 200
                onIsCheckedChanged: {
                    if(isChecked){
                        recordPage.state = "exportMode";
                    }
                }
            }
            ICCheckBox{
                id:importFromUsb
                text:qsTr("Import From USB")
                width: 200
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

        Row{
            x:recordsView.x
            id:searchContainer
            spacing: 10
            anchors.top: usbContainer.bottom
            anchors.topMargin: 10
            ICConfigEdit{
                id:searchBox
                isNumberOnly: false
                inputWidth: 250
            }
            ICButton{
                id:searchBtn
                text: qsTr("Search")
                height: searchBox.height
                onButtonClicked: {
                    var m = recordsView.model;
                    for(var i = 0, len = m.count; i < len; ++i){
                        m.setProperty(i, "visible", m.get(i).name.indexOf(searchBox.configValue) >= 0);
                    }
                }
            }
            ICButton{
                id:clearSearchBtn
                text: qsTr("Clear Search")
                height: searchBox.height
                onButtonClicked: {
                    searchBox.configValue = "";
                    var m = recordsView.model;
                    for(var i = 0, len = m.count; i < len; ++i){
                        m.setProperty(i, "visible", true);
                    }
                }
            }
        }

        ListView{
            function createRecordItem(name, time, isSelected){
                return{"name":name,
                    "createDatetime":time,
                    "isSelected":isSelected || false,
                    "visible":true
                };
            }
            property bool isSelectable: false
            property string openBackupPackage: ""



            id:recordsView
            width: parent.width * 0.8
            height: parent.height  - infoContainer.height - infoContainer.y - usbContainer.height - usbContainer.anchors.topMargin - anchors.topMargin - searchContainer.height - searchContainer.anchors.topMargin
            x:10
            clip: true
            anchors.top: searchContainer.bottom
            anchors.topMargin: 10
            model: recordsModel
            delegate: Rectangle{
                width: parent.width - border.width
                border.width: 1
                border.color: "gray"
                color: recordsView.currentIndex == index ? "lightsteelblue" : "white"
                visible: model.visible
                height: model.visible ? 40 : 0
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
                        isChecked: isSelected
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
                    if(selectName.text == panelRobotController.currentRecordName())
                    {
                        tipDialog.warning(qsTr("In current mold"));
                        return;
                    }
                    if(!panelRobotController.loadRecord(selectName.text))
                    {
                        tipDialog.warning(qsTr("Mold has error!"));
                        return;
                    }
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
                        Storage.setSetting(selectName.text + "_valve", "");
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
                    tipDialog.runningTip(qsTr("Exporting..."))
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
//                    console.log(ret);
                    if(ret === 0)
                        tipDialog.information(qsTr("Expoert Finished!"), qsTr("OK"));
                    else
                        tipDialog.warning(qsTr("No USB Found!"), qsTr("OK"));
                }
            }
            ICButton{
                id:exportPrintableRecord
                text: qsTr("Export Printable")
                height: exportRecord.height
                visible: exportRecord.visible
//                visible: false
                onButtonClicked: {
                    tipDialog.runningTip(qsTr("Exporting..."))
                    var record;
                    var toTranslate;
                    var tmpStr;
                    var recordTmp = new Teach.Record();
                    for(var i = 0; i < recordsModel.count; ++i){
                        var recordPrograms = "";
                        record = recordsModel.get(i);
                        if(record.isSelected){
                            toTranslate = JSON.parse(panelRobotController.recordPrograms(record.name));
                            console.log(record.name, panelRobotController.recordPrograms(record.name));
                            recordTmp.init(record.name,
                                           JSON.parse(panelRobotController.recordCounterDefs(record.name)),
                                           panelRobotController.recordStacks(record.name),
                                           JSON.parse(panelRobotController.recordVariableDefs(record.name)),
                                           panelRobotController.recordFunctions(record.name));
                            for(var j=0;j<toTranslate.length;++j)
                            {
                                if(j === 0){
                                    tmpStr = qsTr("mainProgram:<br>") + recordTmp.programsToText(toTranslate[j])+"<br>";
                                }
                                else{
                                    tmpStr = qsTr("subProgram")+j+":<br>" + recordTmp.programsToText(toTranslate[j])+"<br>";
                                }
                                recordPrograms += tmpStr;
                            }


                            toTranslate = recordTmp.functionManager.functions;
                            for(var k=0;k<toTranslate.length;++k){
                                tmpStr = qsTr("fuction")+"["+ toTranslate[k].id +"]:"+toTranslate[k].name + "<br>" + recordTmp.programsToText(toTranslate[k].program)+"<br>";
                                recordPrograms += tmpStr;
                            }
                            var ret = panelRobotController.writeUsbFile(record.name+".html",'<html><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><body>' + recordPrograms + "</body></html>");
                        }
                    }
                    if(ret === 0){
                        tipDialog.information(qsTr("Print Finished!"), qsTr("OK"));
                    }
                    else{
                        tipDialog.warning(qsTr("No USB Found!"), qsTr("OK"));
                    }
                }
            }

            ICButton{
                id:importRecord
                text: qsTr("Import")
                height: loadRecord.height
                visible: false
                onButtonClicked: {
                    if(recordsView.openBackupPackage == "") return;
                    tipDialog.runningTip(qsTr("Importing..."))
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
                    tipDialog.warning(qsTr("Import Finished!\n"),qsTr("OK"),errLog);
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
            ICButton{
                id:returnUp
                text: qsTr("Ret Up")
                height: loadRecord.height
                visible: importFromUsb.isChecked
                onButtonClicked: {
                    recordPage.state = "importMode";
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

    Rectangle{
        id:visionPage
        anchors.top: splitLine.bottom
        anchors.topMargin: 4
        color: Theme.defaultTheme.BASE_BG
        width: parent.width
        height: parent.height - recordType.height - anchors.topMargin
        visible: vision.isChecked
        ICComboBoxConfigEdit{
            id:dataSource
            configName: qsTr("Data Source")
            inputWidth: 500
            z:100
            x:10
            y:10
        }
        ICButton{
            id:scanModel
            x:dataSource.x
            text:qsTr("Scan Model")
            anchors.top: dataSource.bottom
            anchors.topMargin: 10
            onButtonClicked: {
                panelRobotController.writeDataToETH0(ESData.externalDataManager.getModelListCmd(dataSource.configText()));
            }
        }
        ICListView{
            id:visionModelView
            function setModelOffset(data){
                var toSend = ESData.externalDataManager.getSetModelOffsetCmd(dataSource.configText(), data);
                panelRobotController.writeDataToETH0(toSend);
            }

            isShowHint: true
            border.color: "black"
            border.width: 1
            width: parent.width - 20
            x:dataSource.x
            anchors.top: scanModel.bottom
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            model: visionModel
            clip: true
            delegate:VisionModelItem{
                width: visionModelView.width
//                modelImg: modelImgPath
                modelName: name
                offsetX:offsetX
                offsetY:offsetY
                offsetA:offsetA
                onOffsetChanged: visionModelView.setModelOffset(data);
//                onModelChanged:
            }

            ListModel{
                id:visionModel
            }
        }
        Component.onCompleted: {
            dataSource.items = ESData.externalDataManager.dataSourceNameList(false);
        }
    }
}
