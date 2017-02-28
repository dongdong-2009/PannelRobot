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

        if(normalX.isChecked)
            mD = normalXModel;
        else if(singleY.isChecked)
            mD = singleYModel;
        else if(holdDoubleY.isChecked)
            mD = holdDoubleYModel;
        for(var i = 0; i < mD.count; ++i)
        {
            data = mD.get(i);
            if(data.isSel){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateCheckAction(data.hwPoint, onBox.isChecked ? Teach.VALVE_CHECK_START : Teach.VALVE_CHECK_END, delay.configValue,xDir.configValue,normalX.isChecked));
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
                id:normalX
                text: qsTr("Normal X")
                isChecked: true
            }
            ICCheckBox{
                id:singleY
                text: qsTr("Single Y")
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
                id:normalXModel
            }
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
                    if(normalX.isChecked) return normalXModel;
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
            ICComboBoxConfigEdit{
                id:xDir
                visible: (normalX.isChecked && onBox.isChecked)
                popupMode: 1
                configName: qsTr("Check Dir")
                inputWidth:40
                items: [qsTr("Forward"),qsTr("Reverse")]
                Component.onCompleted: {
                    configValue =0;
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

        var xDefines = IODefines.xDefines;
        var xDefine;
        var ioBoard = panelRobotController.getConfigValue("s_rw_22_2_0_184");
        normalX.visible = ioBoard>0;
        for(i=0;i<(ioBoard*32);++i){
            xDefine= IODefines.getXDefineFromPointName(xDefines[i].pointName);
            normalXModel.append(yView.createMoldItem(xDefine.xDefine,xDefine.hwPoint,xDefine.type));
        }

        var yDefines = IOConfigs.teachSingleY;
        var yDefine;

        singleY.visible = yDefines.length > 0;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            singleYModel.append(yView.createValveMoldItem(yDefine, IODefines.VALVE_BOARD));
        }

        yDefines = IOConfigs.teachHoldDoubleY
        holdDoubleY.visible = yDefines.length > 0;
        for(i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getValveItemFromValveName(yDefines[i]);
            holdDoubleYModel.append(yView.createValveMoldItem(yDefine, IODefines.VALVE_BOARD));
        }

    }
}
