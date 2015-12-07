import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines


Item {
    id:container
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


    function createActionObjects(){
        var ret = [];
        var mD;
        var data;
        if(normalX.isChecked){
            mD = xModel

        }else if(euX.isChecked)
            mD = euXModel
        else
            mD = mXModel
        for(var i = 0; i < mD.count; ++i){
            data = mD.get(i);
            if(data.isSel){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateWaitAction(data.hwPoint, data.board, isOn, delay.configValue));
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
            width: 690
            height: container.height - typeGroup.height - statusGroup.height - parent.spacing * 4
            color: "#A0A0F0"
            border.width: 1
            border.color: "black"
            ListModel{
                id:xModel
            }
            ListModel{
                id:euXModel
            }
            ListModel{
                id:mXModel
            }

            GridView{
                id:xView
                function createMoldItem(ioDefine, hwPoint, board){
                    return {"isSel":false,
                        "pointNum":ioDefine.pointName,
                        "pointDescr":ioDefine.descr,
                        "hwPoint":hwPoint,
                        "board":board,
                    };
                }

                width: parent.width - 4
                height: parent.height - 4
                anchors.centerIn: parent
                cellWidth: 226
                cellHeight: 32
                clip: true
                model: {
                    if(normalX.isChecked) return xModel;
                    if(euX.isChecked) return euXModel;
                    if(mX.isChecked) return mXModel;
                    return null;
                }

                delegate: Row{
                    spacing: 2
                    height: 26
                    ICCheckBox{
                        text: pointNum + ":" + pointDescr
                        isChecked: isSel
                        width: xView.cellWidth * 0.35
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var m = xView.model;
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
                }
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
                configAddr: "s_rw_0_32_1_1201"
                configValue: "0.0"
            }
        }
    }


    Component.onCompleted: {

        var xDefines = xs;
        var xDefine;
        var i;
        for(i = 0; i < xDefines.length; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            xModel.append(xView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
        }

        xDefines = euXs;
        for(i = 0; i < xDefines.length; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            euXModel.append(xView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
        }

        xDefines = mXs;
        for(i = 0; i < xDefines.length; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            mXModel.append(xView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
        }
    }
}
