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
    Row{
        ICButtonGroup{
            id:funSel
            ICButton{
                id:actionInMold
                text: qsTr("In Mold")
            }
            ICButton{
                id:getMaterial
                text:qsTr("Get M")
            }
            ICButton{
                id:releaseMaterial
                text: qsTr("Rel M")
            }
        }
        ICStackContainer{
            height: instance.height
            width: instance.width - funSel.width
        }
    }
}
