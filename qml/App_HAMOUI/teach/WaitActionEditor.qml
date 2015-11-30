import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines


Item {
    id:container
    QtObject{
        id:pData
        property variant xs: [
            "X010",
            "X011",
            "X012",
            "X014",
            "X015",
            "X016",
            "X017",
            "X020",
        ]
        property  variant euXs : ["EuX010", "EuX011"]
        property variant mXs: ["INX010"]

        property variant xModel: []
        property variant euXModel: []
        property variant mXModel: []
    }


    function createActionObjects(){
        var ret = [];
        var mD;
        var data;
        var ui;
        if(normalX.isChecked){
            mD = pData.xModel

        }else if(euX.isChecked)
            mD = pData.euXModel
        else
            mD = pData.mXModel
        for(var i = 0; i < mD.length; ++i)
        {
            data = mD[i].data;
            ui = mD[i].ui;
            if(ui.isChecked){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateWaitAction(data.hwPoint, data.type, isOn, delay.configValue));
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
                id:normalX
                text: qsTr("X")
                isChecked: true
            }
            ICCheckBox{
                id:euX
                text: qsTr("EUX")
            }
            ICCheckBox{
                id:mX
                text: qsTr("M")
            }
        }
        Rectangle{
            id:xContainer
            width: container.width - 10
            height: container.height - typeGroup.height - statusGroup.height - parent.spacing * 4
            color: "gray"
            border.width: 1
            border.color: "black"
            visible: normalX.isChecked
            Grid{
                id:xContainerFlow
                anchors.fill: parent
                anchors.margins: 4
                spacing: 10
                columns: 6
            }
        }
        Rectangle{
            id:euXContaienr
            width: xContainer.width
            height: xContainer.height
            color: "gray"
            border.width: 1
            border.color: "black"
            visible: euX.isChecked
            Grid{
                id:euXContainerFlow
                anchors.fill: parent
                anchors.margins: 4
                spacing: 10
                columns: 6
            }
        }

        Rectangle{
            id:mXContaienr
            width: xContainer.width
            height: xContainer.height
            color: "gray"
            border.width: 1
            border.color: "black"
            visible: mX.isChecked
            Grid{
                id:mXContainerFlow
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
                configValue: "0.0"
            }
        }
    }


    Component.onCompleted: {

        var xDefines = pData.xs
        var xDefine;
        var ioDescrComponent = Qt.createComponent("IOTeachDescrComponent.qml");
        var xM = [];
        var euxM = [];
        var mXM = [];
        var ioDescrObject;
        var i;
        for(i = 0; i < xDefines.length; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            ioDescrObject = ioDescrComponent.createObject(xContainerFlow, {"pointDescr" : xDefines[i] + ":"
                                                          + xDefine.xDefine.descr});
            xM.push({"data":xDefine,
                              "ui": ioDescrObject});

        }
        xDefines = pData.euXs;
        for(i = 0; i < xDefines.length; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            ioDescrObject = ioDescrComponent.createObject(euXContainerFlow, {"pointDescr" : xDefines[i] + ":"
                                                          + xDefine.xDefine.descr});
            euxM.push({"data":xDefine,
                              "ui": ioDescrObject});

        }

        xDefines = pData.mXs;
        for(i = 0; i < xDefines.length; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            ioDescrObject = ioDescrComponent.createObject(mXContainerFlow, {"pointDescr" : xDefines[i] + ":"
                                                          + xDefine.xDefine.descr});
            mXM.push({"data":xDefine,
                              "ui": ioDescrObject});

        }

        pData.xModel = xM;
        pData.euXModel = euxM;
        pData.mXModel = mXM;

    }
}
