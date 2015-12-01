import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines


Item {
    id:container
    property variant ys: [
        "Y010",
        "Y011",
        "Y012",
        "Y013",
        "Y014",
        "Y015",
        "Y016",
        "Y017",
        "Y020",
    ]
    property  variant euYs : ["EuY010", "EuY011", "EuY012"]
    property variant mYs: ["INY010"]
    //    QtObject{
    //        id:pData

    ////        property variant yModel: []
    ////        property variant euYModel: []
    ////        property variant mYModel: []
    //    }

    function createActionObjects(){
        var ret = [];
        var mD;
        var data;
        var ui;
        if(normalY.isChecked){
            mD = yModel;

        }else if(euY.isChecked){
            mD = euYModel;
        }
        else
            mD = mYModel;
        for(var i = 0; i < mD.count; ++i)
        {
            data = mD.get(i);
            if(data.isSel){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateOutputAction(data.hwPoint, data.board, isOn, delay.configValue));
                break;
            }
        }
        return ret;
    }
    width: parent.width
    height: parent.height

    Column{
        spacing: 4
        ICButtonGroup{
            id:typeGroup
            spacing: 20
            ICCheckBox{
                id:normalY
                text: qsTr("Y")
                isChecked: true
                visible:ys.length > 0
            }
            ICCheckBox{
                id:euY
                text: qsTr("EUY")
                visible: euYs.length > 0
            }
            ICCheckBox{
                id:mY
                text: qsTr("M")
                visible: mYs.length > 0
            }
        }
        Rectangle{
            id:yContainer
            width: 690
            height: container.height - typeGroup.height - statusGroup.height - parent.spacing * 4
            color: "#A0A0F0"
            border.width: 1
            border.color: "black"
            //            visible: normalY.isChecked
            ListModel{
                id:yModel
            }
            ListModel{
                id:euYModel
            }
            ListModel{
                id:mYModel
            }

            GridView{
                id:yView
                function createMoldItem(ioDefine, hwPoint, board){
                    return {"isSel":false,
                        "pointNum":ioDefine.pointName,
                        "pointDescr":ioDefine.descr,
                        "hwPoint":hwPoint,
                        "board":board,
                        "isOn": false
                    };
                }

                width: parent.width - 4
                height: parent.height - 4
                anchors.centerIn: parent
                cellWidth: 226
                cellHeight: 32
                clip: true
                model: {
                    if(normalY.isChecked) return yModel;
                    if(euY.isChecked) return euYModel;
                    if(mY.isChecked) return mYModel;
                    return null;
                }

                delegate: Row{
                    spacing: 2
                    height: 26
                    ICCheckBox{
                        text: pointNum
                        isChecked: isSel
                        width: yView.cellWidth * 0.35
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var m = yView.model;
                                var toSetSel = !isSel;
                                m.setProperty(index, "isSel", toSetSel);
                                for(var i = 0; i < m.count; ++i){
                                    if( i !== index){
                                        m.setProperty(i, "isSel", false);
                                    }
                                }
                            }
                        }
                    }
                    ICButton{
                        height: parent.height
                        text: pointDescr
                        width:yView.cellWidth * 0.6
                        bgColor: isOn ? "lime" : "white"
                        onButtonClicked: {
                            panelRobotController.setYStatus(board, hwPoint, !isOn);
                        }

                    }
                }
            }

            //            ICButtonGroup{
            //                Grid{
            //                    id:yContainerFlow
            //                    anchors.fill: parent
            //                    anchors.margins: 4
            //                    spacing: 10
            //                    columns: 6
            //                }
            //            }
        }
        //        Rectangle{
        //            id:euYContaienr
        //            width: yContainer.width
        //            height: yContainer.height
        //            color: "gray"
        //            border.width: 1
        //            border.color: "black"
        //            visible: euY.isChecked

        //            Grid{
        //                id:euYContainerFlow
        //                anchors.fill: parent
        //                anchors.margins: 4
        //                spacing: 10
        //                columns: 6
        //            }
        //        }

        //        Rectangle{
        //            id:mYContaienr
        //            width: yContainer.width
        //            height: yContainer.height
        //            color: "gray"
        //            border.width: 1
        //            border.color: "black"
        //            visible: mY.isChecked
        //            Grid{
        //                id:mYContainerFlow
        //                anchors.fill: parent
        //                anchors.margins: 4
        //                spacing: 10
        //                columns: 6
        //            }
        //        }

        Row{
            spacing: 20
            ICButtonGroup{
                id:statusGroup
                checkedItem: onBox
                Row{
                    spacing: 10
                    ICCheckBox{
                        id:onBox
                        text: qsTr("ON")
                        isChecked: true
                    }
                    ICCheckBox{
                        id:offBox
                        text: qsTr("OFF")
                    }
                }
                height: 32
            }

            ICConfigEdit{
                id:delay
                configName: qsTr("Delay:")
                unit: qsTr("s")
                width: 100
                height: 24
                visible: true
                z:1
                configAddr: "s_rw_0_32_1_1201"
                configValue: "0.0"
            }
        }
    }


    Component.onCompleted: {

        var yDefines = ys;
        var yDefine;
        var i;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            yModel.append(yView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
        }

        yDefines = euYs;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            euYModel.append(yView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
        }

        yDefines = mYs;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            mYModel.append(yView.createMoldItem(yDefine.yDefine, yDefine.hwPoint, yDefine.type));
        }
        //        var ioDescrComponent = Qt.createComponent("OutputTeachDescrComponent.qml");
        //        var yM = [];
        //        var euyM = [];
        //        var mYM = [];
        //        var ioDescrObject;
        //        var i;
        //        for(i = 0; i < yDefines.length; ++i){
        //            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
        //            ioDescrObject = ioDescrComponent.createObject(yContainerFlow, {"pointNum":yDefines[i], "pointDescr" : yDefine.yDefine.descr});
        //            yM.push({"data":yDefine,
        //                        "ui": ioDescrObject});

        //        }
        //        yDefines = pData.euYs;
        //        for(i = 0; i < yDefines.length; ++i){
        //            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
        //            ioDescrObject = ioDescrComponent.createObject(euYContainerFlow, {"pointNum":yDefines[i], "pointDescr" : yDefine.yDefine.descr});
        //            euyM.push({"data":yDefine,
        //                          "ui": ioDescrObject});

        //        }

        //        yDefines = pData.mYs;
        //        for(i = 0; i < yDefines.length; ++i){
        //            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
        //            ioDescrObject = ioDescrComponent.createObject(mYContainerFlow, {"pointNum":yDefines[i], "pointDescr" : yDefine.yDefine.descr});
        //            mYM.push({"data":yDefine,
        //                         "ui": ioDescrObject});

        //        }

        //        pData.yModel = yM;
        //        pData.euYModel = euyM;
        //        pData.mYModel = mYM;

    }
    Timer{
        id:refreshTimer
        interval: 50; running: visible; repeat: true
        onTriggered: {
            var currentModel = yView.model;
            var modelItem;
            for(var i = 0; i < currentModel.count; ++i){
                modelItem =  currentModel.get(i);
                currentModel.setProperty(i, "isOn", panelRobotController.isOutputOn(modelItem.hwPoint, modelItem.board));
            }
        }
    }

}
