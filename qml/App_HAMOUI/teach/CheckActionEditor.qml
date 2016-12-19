import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../configs/IOConfigs.js" as IOConfigs


Item {
    id:container

    function createActionObjects(){
        var ret = [];
        var mD;
        var data;
        var ui;

        if(singleY.isChecked)
            mD = singleYModel;
        else
            mD = holdDoubleYModel;
        for(var i = 0; i < mD.count; ++i)
        {
            data = mD.get(i);
            if(data.isSel){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateCheckAction(data.hwPoint, onBox.isChecked ? Teach.VALVE_CHECK_START : Teach.VALVE_CHECK_END, delay.configValue));
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
            //            checkedItem: singleY
            ICCheckBox{
                id:singleY
                text: qsTr("Single Y")
                isChecked: true
            }
            ICCheckBox{
                id:holdDoubleY
                text: qsTr("Hold Double Y")
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
                id:singleYModel
            }
            ListModel{
                id:holdDoubleYModel
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

                function createValveMoldItem(valve, board){
                    return {"isSel":false,
                        "pointNum":IODefines.getYDefinePointNameFromValve(valve),
                        "pointDescr":valve.descr,
                        "hwPoint":valve.id,
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

                    if(singleY.isChecked) return singleYModel;
                    if(holdDoubleY.isChecked) return holdDoubleYModel;
                    return null;
                }

                delegate: Row{
                    spacing: 2
                    height: 26
                    ICCheckBox{
                        text: pointNum + ":" + pointDescr
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
                }
            }
        }

        Row{
            spacing: 20

            ICButtonGroup{
                id:statusGroup
                checkedItem: onBox
                layoutMode: 0
                isAutoSize: true
                mustChecked: true
                spacing: 20
                ICCheckBox{
                    id:onBox
                    text: qsTr("Start")
                    isChecked: true
                }
                ICCheckBox{
                    id:offBox
                    text: qsTr("End")
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

        var yDefines = IOConfigs.teachSingleY
        var yDefine;
        var i;

        singleY.visible = yDefines.length > 0;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = yDefines[i];
            singleYModel.append(yView.createValveMoldItem(yDefine, IODefines.VALVE_BOARD));
        }

        yDefines = IOConfigs.teachHoldDoubleY
        holdDoubleY.visible = yDefines.length > 0;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = yDefines[i];
            holdDoubleYModel.append(yView.createValveMoldItem(yDefine, IODefines.VALVE_BOARD));
        }

    }
}
