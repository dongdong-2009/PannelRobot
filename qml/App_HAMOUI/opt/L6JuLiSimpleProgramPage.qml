import QtQuick 1.1
import "../../ICCustomElement"
import "../teach/Teach.js" as Teach
Rectangle {
    id:instance

    function showActionEditorPanel(){}
    function onInsertTriggered(){}
    function onDeleteTriggered(){}
    function onUpTriggered(){}
    function onDownTriggered(){}
    function onFixIndexTriggered(){}
    function onSaveTriggered(){

    }
    Column{
        spacing: 1
        ICButtonGroup{
            id:funSel
            isAutoSize: true
            mustChecked: true
            spacing: 20
            checkedIndex: 0
            ICCheckBox{
                id:actionInMold
                text: qsTr("In Mold")
                isChecked: true
            }
            ICCheckBox{
                id:getMaterial
                text:qsTr("Get M")
            }
            ICCheckBox{
                id:releaseMaterial
                text: qsTr("Rel M")
            }
        }
        Rectangle{
            id:horSplitLine
            height: 1
            color: "black"
            width: instance.width
        }
        ICStackContainer{
            height: instance.height - funSel.height - horSplitLine.height
            width: instance.width

        }
    }
//    Component.onStatusChanged: {
//        console.log(errorString())
//    }
}
