import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../configs/IOConfigs.js" as IOConfigs


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
    property variant mXs: IOConfigs.teachMy


    function createActionObjects(){
        var ret = [];
        var mD;
        var data;
        if(normalX.isChecked){
            mD = xModel

        }else if(euX.isChecked)
            mD = euXModel
        else if(simpleDelay.isChecked)
        {
            ret.push(Teach.generateWaitAction(0, 100, 0, delay.configValue));
            return ret;
        }
        else
            mD = mXModel
        for(var i = 0; i < mD.count; ++i){
            data = mD.get(i);
            if(data.isSel){
                var isOn;
                if(statusGroup.checkedItem == onBox)isOn = 1;
                else if(statusGroup.checkedItem == offBox)isOn = 0;
                else if(statusGroup.checkedItem == risingEdgeBox)isOn = 2;
                else if(statusGroup.checkedItem == fallingEdgeBox)isOn = 3;
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
                visible: false
            }
            ICCheckBox{
                id:mX
                text: qsTr("M")
                visible: mXs.length > 0
            }
            ICCheckBox{
                id:simpleDelay
                text: qsTr("Simple Delay")
                visible: true
            }
        }
        Rectangle{
            id:xContainer
            width: 690
            height: container.height - typeGroup.height - statusBGroup.height - parent.spacing * 4
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
            id:statusBGroup
            spacing: 20
            ICCheckBox{
                id:onBox
                text: qsTr("ON")
                isChecked: true
                visible: !simpleDelay.isChecked
            }
            ICCheckBox{
                id:offBox
                text: qsTr("OFF")
                visible: !simpleDelay.isChecked
            }
            ICCheckBox{
                id:risingEdgeBox
                visible: normalX.isChecked
                text: qsTr("Rising Edge")
            }
            ICCheckBox{
                id:fallingEdgeBox
                visible: normalX.isChecked
                text: qsTr("Falling Edge")
            }
            ICConfigEdit{
                id:delay
                configName: simpleDelay.isChecked?qsTr("Simple Delay:"):qsTr("Delay:")
                unit: qsTr("s")
                width: 100
                height: 24
                visible: true
                z:1
                configAddr: "s_rw_0_32_1_1201"
                configValue: "0.0"
            }
            Component.onCompleted: {
                statusGroup.addButton(onBox);
                statusGroup.addButton(offBox);
                statusGroup.addButton(risingEdgeBox);
                statusGroup.addButton(fallingEdgeBox);
            }
        }
        ICButtonGroup{
            id:statusGroup
            checkedItem: onBox
            mustChecked: true
            layoutMode: 2
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
            xModel.append(xView.createMoldItem(xDefine.xDefine,parseInt(xDefine.hwPoint%32), xDefine.type));
        }

//        xDefines = euXs;
//        for(i = 0, l = xDefines.length; i < l; ++i){
//            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
//            euXModel.append(xView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
//        }

        xDefines = mXs;
        for(i = 0, l = xDefines.length; i < l; ++i){
            xDefine = IODefines.getValveItemFromValveID(xDefines[i]);
            xDefine = IODefines.getXDefineFromHWPoint(xDefine.y1Point, xDefine.y1Board);
            mXModel.append(xView.createMoldItem(xDefine.xDefine, xDefine.hwPoint, xDefine.type));
        }
    }
}
