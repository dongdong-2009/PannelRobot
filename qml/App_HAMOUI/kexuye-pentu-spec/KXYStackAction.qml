import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine
import "../teach"
import "../teach/Teach.js" as Teach
import "../../utils/utils.js" as Utils

Item {
    id:container
    width: parent.width
    height: parent.height
    property variant actionObject: null
    property bool isauto: false

    StackActionEditor{
        id: stackaction
        anchors.fill: parent
        useFlagVisible: false
        stackSelector: false
        defineStackEN: false
        useFlagIsChecked: useStack.visible
    }
    ICCheckBox{
        id:useStack
        text: qsTr("Use Stack")
        onClicked: {
            stackaction.defineStackIsChecked = !isChecked;
            stackaction.useFlagIsChecked = isChecked;
        }
    }
    ICComboBoxConfigEdit{
        id:stackSelector
        visible: useStack.isChecked
        configName: qsTr("Stack")
        inputWidth: 200
        popupHeight: 150
        y: 60
        z:11
        items: Teach.stackInfosDescr();
        onVisibleChanged: items = Teach.stackInfosDescr();
    }

    function updateActionObject(ao){
        ao.stackID = parseInt(Utils.getValueFromBrackets(stackSelector.text(parseInt(stackSelector.configValue))));
        ao.useStack = useStack.isChecked;
//        ao.useDeviation = useDeviation.isChecked;
//        ao.turns = turns.configValue;
//        ao.stackType = stackType.configValue;
        ao.stackSpeed = stackaction.speed;
//        ao.xdeviation = xdeviation.configValue;
//        ao.ydeviation = ydeviation.configValue;
//        ao.zdeviation = zdeviation.configValue;
//        ao.xspace = xspace.configValue;
//        ao.yspace = yspace.configValue;
//        ao.zspace = zspace.configValue;
//        ao.xcount = xcount.configValue;
//        ao.ycount = ycount.configValue;
//        ao.zcount = zcount.configValue;
//        ao.xdirection = xdirection.configValue;
//        ao.ydirection = ydirection.configValue;
//        ao.zdirection = zdirection.configValue;
    }

    function getstackInstace(){
        console.log("1111",parseInt(Utils.getValueFromBrackets(stackSelector.text(parseInt(stackSelector.configValue)))))
        return {
            "stackID":parseInt(Utils.getValueFromBrackets(stackSelector.text(parseInt(stackSelector.configValue)))),
            "useStack":useStack.isChecked,
//            "useDeviation":useDeviation.isChecked,
//            "turns":turns.configValue,
//            "stackType":stackType.configValue,
            "stackSpeed":stackaction.speed,
//            "xdeviation":xdeviation.configValue,
//            "ydeviation":ydeviation.configValue,
//            "zdeviation":zdeviation.configValue,
//            "xspace":xspace.configValue,
//            "yspace":yspace.configValue,
//            "zspace":zspace.configValue,
//            "xcount":xcount.configValue,
//            "ycount":ycount.configValue,
//            "zcount":zcount.configValue,
//            "xdirection":xdirection.configValue,
//            "ydirection":ydirection.configValue,
//            "zdirection":zdirection.configValue
        };
    }
    function speedcontainer() {return stackaction;}
//    Row{
//        spacing: 50
//        Column{
//            id:configContainer
//            property int posNameWidth: 60
//            spacing: 10
//            Column{
//                spacing: 4
//                Row{
//                    id:checkrow
//                    spacing: 10
//                    z: 3
//                    ICCheckBox{
//                        id:useStack
//                        text: qsTr("Use Stack")
//                    }
//                    ICCheckBox{
//                        id:useDeviation
//                        text: qsTr("Use Deviation")
//                    }
//                    ICComboBoxConfigEdit{
//                        id:turns
//                        configName: qsTr("Turns")
//                        items: [qsTr("X->Y->Z"), qsTr("X->Z->Y"), qsTr("Y->X->Z"),
//                                qsTr("Y->Z->X"), qsTr("Z->X->Y"), qsTr("Z->Y->X")]
//                    }
//                    ICConfigEdit{
//                        id:stackSpeed
//                        configName: qsTr("Stack Speed")
//                        configAddr: "s_rw_0_32_1_1200"
//                        unit: "%"
//                    }
//                    ICComboBoxConfigEdit{
//                        id:stackType
//                        configName: qsTr("Stack Type")
//                        items: [qsTr("normal"), qsTr("Custom Pos")]
//                    }
//                }
//                Row{
//                    spacing: 10
//                    id:stackcontiner
//                    Column{
//                        spacing: 4
//                        id:deviation
//                        visible: useDeviation.isChecked
//                        ICConfigEdit{
//                            id:xdeviation
//                            configName: qsTr("X Deviation")
//                            configAddr: "s_rw_0_32_3_1300"
//                        }
//                        ICConfigEdit{
//                            id:ydeviation
//                            configName: qsTr("Y Deviation")
//                            configAddr: "s_rw_0_32_3_1300"
//                        }
//                        ICConfigEdit{
//                            id:zdeviation
//                            configName: qsTr("Z Deviation")
//                            configAddr: "s_rw_0_32_3_1300"
//                        }
//                    }
//                    Column{
//                        spacing: 4
//                        id:space
//                        ICConfigEdit{
//                            id:xspace
//                            configName: qsTr("X Space")
//                            configAddr: "s_rw_0_32_3_1300"
//                        }
//                        ICConfigEdit{
//                            id:yspace
//                            configName: qsTr("Y Space")
//                            configAddr: "s_rw_0_32_3_1300"
//                        }
//                        ICConfigEdit{
//                            id:zspace
//                            configName: qsTr("Z Space")
//                            configAddr: "s_rw_0_32_3_1300"
//                        }
//                    }
//                    Column{
//                        spacing: 4
//                        id:stackcount
//                        ICConfigEdit{
//                            id:xcount
//                            configName: qsTr("X Count")
////                            configAddr: "s_rw_0_32_1_1200"
//                        }
//                        ICConfigEdit{
//                            id:ycount
//                            configName: qsTr("Y Count")
////                            configAddr: "s_rw_0_32_1_1200"
//                        }
//                        ICConfigEdit{
//                            id:zcount
//                            configName: qsTr("Z Count")
////                            configAddr: "s_rw_0_32_1_1200"
//                        }
//                    }
//                    Column{
//                        spacing: 4
//                        id:direction
//                        ICComboBoxConfigEdit{
//                            id:xdirection
//                            z: 3
//                            configName: qsTr("X Direction")
//                            items: [qsTr("Negitive"), qsTr("Positive")]
//                        }
//                        ICComboBoxConfigEdit{
//                            id:ydirection
//                            z: 2
//                            configName: qsTr("Y Direction")
//                            items: [qsTr("Negitive"), qsTr("Positive")]
//                        }
//                        ICComboBoxConfigEdit{
//                            id:zdirection
//                            z: 1
//                            configName: qsTr("Z Direction")
//                            items: [qsTr("Negitive"), qsTr("Positive")]
//                        }
//                    }
//                    ICButton{
//                        id:editPos
//                        text: qsTr("Edit Pos")
//                        visible: stackType.configValue == 1
//                        function onEditConfirm(accepted, points){
//                            if(accepted){
//                                if(stackViewSel.currentIndex < 0) return;
//                                var id = parseInt(Utils.getValueFromBrackets(stackViewSel.currentText()));
//                                var sI = Teach.getStackInfoFromID(id);
//                                sI = Teach.getStackInfoFromID(topContainer.saveStack(id,sI.descr, true, points));
//                                var toSend = new ESData.RawExternalDataFormat(sI.dsName, sI.posData);
//                                toSend = ESData.externalDataManager.parseRaw(toSend);
//                                panelRobotController.sendExternalDatas(JSON.stringify(toSend));
//                            }else
//                                customPointEditor.editConfirm.disconnect(editPos.onEditConfirm);
//                        }

//                        onButtonClicked: {
//    //                        customPointEditor.visible = true;
//    //                        customPointEditor.editConfirm.connect(editPos.onEditConfirm);
//                            var id = parseInt(Utils.getValueFromBrackets(stackViewSel.currentText()));
//                            var sI = Teach.getStackInfoFromID(id);
//                            if(sI.posData === undefined)
//                                sI.podData = [];
//                            customPointEditor.show(sI.posData, true, editPos.onEditConfirm);
//                        }
//                    }
//                }
//            }
//        }
//    }

    onActionObjectChanged: {
        if(actionObject == null) return;
        stackSelector.items = Teach.stackInfosDescr();
        var tmpname = 0;
        for(var i = 0;i < stackSelector.items.length;i++){
            tmpname = parseInt(Utils.getValueFromBrackets(stackSelector.text(i)));
            if(tmpname == actionObject.stackID){
                stackSelector.configValue = i;
                break;
            }
        }
        useStack.isChecked = actionObject.useStack;
//        useDeviation.isChecked = actionObject.useDeviation;
//        turns.configValue = actionObject.turns;
//        stackType.configValue = actionObject.stackType;
        stackaction.speed = actionObject.stackSpeed;
//        xdeviation.configValue = actionObject.xdeviation;
//        ydeviation.configValue = actionObject.ydeviation;
//        zdeviation.configValue = actionObject.zdeviation;
//        xspace.configValue = actionObject.xspace;
//        yspace.configValue = actionObject.yspace;
//        zspace.configValue = actionObject.zspace;
//        xcount.configValue = actionObject.xcount;
//        ycount.configValue = actionObject.ycount;
//        zcount.configValue = actionObject.zcount;
//        xdirection.configValue = actionObject.xdirection;
//        ydirection.configValue = actionObject.ydirection;
//        zdirection.configValue = actionObject.zdirection;
    }

    Component.onCompleted: {
        useStack.isChecked = false;
//        useDeviation.isChecked = false;
//        turns.configValue = 0;
//        stackType.configValue = 0;
        stackaction.speed = 100;
        stackSelector.configValue = -1;
//        xdeviation.configValue = 0;
//        ydeviation.configValue = 0;
//        zdeviation.configValue = 0;
//        xspace.configValue = 0;
//        yspace.configValue = 0;
//        zspace.configValue = 0;
//        xcount.configValue = 0;
//        ycount.configValue = 0;
//        zcount.configValue = 0;
//        xdirection.configValue = 1;
//        ydirection.configValue = 1;
//        zdirection.configValue = 1;
    }
}
