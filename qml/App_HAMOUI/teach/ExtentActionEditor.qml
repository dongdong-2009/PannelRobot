import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "extents"
import "extents/ExtentActionDefine.js" as ExtentActionDefine

Item {
    id:container
    width: parent.width
    height: parent.height



    function createActionObjects(){
        var ret = [];
//        if(axisPly.isChecked){
//            ret.push(Teach.generateCustomAction(axisFlyConfigs.getActionProperties()));
//        }else if(analogControl.isChecked)
        var p = configsContainer.currentPage().getActionProperties();
        if(p != null)
            ret.push(Teach.generateCustomAction(p));
        return ret;
    }

    ICButtonGroup{
        id:cmdContainer
        layoutMode: 1
        isAutoSize: false
        mustChecked: true
        width: cmdContent.width
        height: cmdContent.height
        checkedIndex: 0
        y:6
        Flow{
            id:cmdContent
            width: 250
            spacing: 12
            ICCheckBox{
                id:axisPly
                text: qsTr("Axis Ply")
                isChecked: true
            }
            ICCheckBox{
                id:analogControl
                text: qsTr("Analog Control")
            }
            ICCheckBox{
                id:deltaJumpControl
                text: qsTr("Delta Jump Control")
            }
            ICCheckBox{
                id:safeRangeControl
                text: qsTr("Safe Range Control")
            }
            ICCheckBox{
                id:singleStack
                text: qsTr("Single Stack")
            }
            ICCheckBox{
                id:switchCoord
                text: qsTr("switchCoord")
            }
        }
        onCheckedIndexChanged: {
            configsContainer.setCurrentIndex(checkedIndex);
        }
    }
    Rectangle{
        id:spliteLine
        height: 200
        color: "black"
        width: 1
        y:cmdContainer.y
        anchors.left: cmdContainer.right
        anchors.leftMargin: 4
    }
    ICStackContainer{
        id:configsContainer
        anchors.left: spliteLine.right
        anchors.leftMargin: 4
        Component.onCompleted: {
            if(axisPly.visible){
                addPage(ExtentActionDefine.extentPENQIANGAction.editableItems.comp.createObject(configsContainer));
            }
            if(analogControl.visible){
                addPage(ExtentActionDefine.extentAnalogControlAction.editableItems.comp.createObject(configsContainer));

            }
            if(deltaJumpControl.visible){
                addPage(ExtentActionDefine.extentDeltaJumpAction.editableItems.comp.createObject(configsContainer));

            }
            if(safeRangeControl.visible){
                addPage(ExtentActionDefine.extentSafeRangeAction.editableItems.comp.createObject(configsContainer));
            }
            if(singleStack.visible){
                addPage(ExtentActionDefine.extentSingleStackAction.editableItems.comp.createObject(configsContainer));
            }
            if(switchCoord.visible){
                addPage(ExtentActionDefine.extentSwitchCoordAction.editableItems.comp.createObject(configsContainer));
            }
            currentIndex = 0;
        }
    }
}
