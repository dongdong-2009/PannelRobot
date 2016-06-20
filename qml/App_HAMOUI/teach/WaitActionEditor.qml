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
        "X013",
        "X014",
        "X015",
        "X016",
        "X017",
        "X020",
        "X021",
        "X022",
        "X023",
        "X024",
        "X025",
        "X026",
        "X027",
        "X030",
        "X031",
        "X032",
        "X033",
        "X034",
        "X035",
        "X036",
        "X037",
        "X040",
        "X041",
        "X042",
        "X043",
        "X044",
        "X045",
        "X046",
        "X047",
    ]
    property  variant euXs : []
    property variant mXs: [
    "M010",
    "M011",
    "M012",
    "M013",
    "M014",
    "M015",
    "M016",
    "M017",
    "M020",
    "M021",
    "M022",
    "M023",
    "M024",
    "M025",
    "M026",
    "M027"
    ]


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
                visible: xs.length > 0
            }
            ICCheckBox{
                id:euX
                text: qsTr("EUX")
                visible: euXs.length > 0
            }
            ICCheckBox{
                id:mX
                text: qsTr("M")
                visible: mXs.length > 0
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
                mustChecked: true
                isAutoSize: true
                layoutMode: 0
                spacing: 20
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

        var i;
        var l;
        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
        if(ioBoardCount == 0)
            ioBoardCount = 1;

        xs = IODefines.generateIOBaseBoardCount("X", ioBoardCount);
        var xDefines = xs;
        var xDefine;
        for(i = 0, l = xDefines.length; i < l; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            xModel.append(xView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
        }

        xDefines = euXs;
        for(i = 0, l = xDefines.length; i < l; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            euXModel.append(xView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
        }

        xDefines = mXs;
        for(i = 0, l = xDefines.length; i < l; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            mXModel.append(xView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
        }
    }
}
