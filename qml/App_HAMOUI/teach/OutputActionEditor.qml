import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../AppSettings.js" as UISettings


Item {
    id:container
    QtObject{
        id:pData
        property variant ys: [
            "Y010",
            "Y011",
            "Y012",
            "Y014",
            "Y015",
            "Y016",
            "Y017",
            "Y020",
        ]
        property  variant euYs : ["EuY010", "EuY011"]
        property variant mYs: ["INY010"]

        property variant yModel: []
        property variant euYModel: []
        property variant mYModel: []
    }

    function createActionObjects(){
        var ret = [];
        var yModel;
        var data;
        var ui;
        if(normalY.isChecked){
            yModel = pData.yModel
            for(var i = 0; i < yModel.length; ++i)
            {
                data = yModel[i].data;
                ui = yModel[i].ui;
                if(ui.isChecked){
                    var isOn = statusGroup.checkedItem == onBox ? true : false;
                    ret.push(Teach.generateOutputAction(data.hwPoint, data.type, isOn, delay.configValue));
                    break;
                }
            }
            return ret;
        }
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
            }
            ICCheckBox{
                id:euY
                text: qsTr("EUY")
            }
            ICCheckBox{
                id:mY
                text: qsTr("M")
            }
        }
        Rectangle{
            id:yContainer
            width: container.width - 10
            height: container.height - typeGroup.height - statusGroup.height - parent.spacing * 4
            color: "gray"
            border.width: 1
            border.color: "black"
            visible: normalY.isChecked
            Grid{
                id:yContainerFlow
                anchors.fill: parent
                anchors.margins: 4
                spacing: 10
                columns: 6
            }
        }
        Rectangle{
            id:euYContaienr
            width: yContainer.width
            height: yContainer.height
            color: "gray"
            border.width: 1
            border.color: "black"
            visible: euY.isChecked
            Grid{
                id:euYContainerFlow
                anchors.fill: parent
                anchors.margins: 4
                spacing: 10
                columns: 6
            }
        }

        Rectangle{
            id:mYContaienr
            width: yContainer.width
            height: yContainer.height
            color: "gray"
            border.width: 1
            border.color: "black"
            visible: mY.isChecked
            Grid{
                id:mYContainerFlow
                anchors.fill: parent
                anchors.margins: 4
                spacing: 10
                columns: 6
            }
        }

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
                min:0
                max:600000
                decimal: 1
            }
        }
    }


    Component.onCompleted: {

        var yDefines = pData.ys
        var yDefine;
        var ioDescrComponent = Qt.createComponent("IOTeachDescrComponent.qml");
        var yM = [];
        var euyM = [];
        var mYM = [];
        var ioDescrObject;
        var i;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            ioDescrObject = ioDescrComponent.createObject(yContainerFlow, {"pointDescr" : yDefines[i] + ":"
                                                          + yDefine.yDefine.descr});
            yM.push({"data":yDefine,
                              "ui": ioDescrObject});

        }
        yDefines = pData.euYs;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            ioDescrObject = ioDescrComponent.createObject(euYContainerFlow, {"pointDescr" : yDefines[i] + ":"
                                                          + yDefine.yDefine.descr});
            yM.push({"data":yDefine,
                              "ui": ioDescrObject});

        }

        yDefines = pData.mYs;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            ioDescrObject = ioDescrComponent.createObject(mYContainerFlow, {"pointDescr" : yDefines[i] + ":"
                                                          + yDefine.yDefine.descr});
            yM.push({"data":yDefine,
                              "ui": ioDescrObject});

        }

        pData.yModel = yM;
        pData.euYModel = euyM;
        pData.mYModel = mYM;

    }

}
