import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "ActionModifyEditor.js" as PData

Item {
    id:container
    Rectangle{
        id:bgLayer
        border.color: "black"
        border.width: 1
        width: parent.width
        height: parent.height
        MouseArea{
            anchors.fill: parent
        }
    }

    signal editConfirm(variant actionObject)

    function openEditor(actionObject,editableItems){
        pos.visible = false;
        speed.visible = false;
        delay.visible = false;
        var item;
        var editor;
        height = 0;
        PData.editingActionObject = actionObject;
        PData.editingEditors = [];
        for(var i = 0; i < editableItems.length; ++i){
            item = editableItems[i];
            editor = PData.itemToEditorMap.get(item.item);
            editor.configAddr = item.range;
            editor.configValue = actionObject[item.item];
            editor.visible = true;
            height += editor.height + editorContainer.spacing;
            PData.editingEditors.push(editor);
        }
        height += buttons.height
        height += 20
        visible = true;
    }
    visible: false
    width: 300
    Column{
        id:editorContainer
        y:10
        x:10
        spacing: 6
        ICConfigEdit{
            id:pos
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Pos:")
            unit: qsTr("mm")
        }
//        PointEdit{
//            id:point
//        }

        ICConfigEdit{
            id:speed
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Speed:")
            unit: qsTr("%")
        }
        ICConfigEdit{
            id:delay
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Delay:")
            unit: qsTr("s")
        }
        Row{
            id:buttons
            spacing: 20
            ICButton{
                id:okBtn
                text: qsTr("Ok")
                onButtonClicked: {
                    container.visible = false;
                    var editingObject = PData.editingActionObject;
//                    var modifiedObject = {};
                    var editor;
                    for(var i = 0; i < PData.editingEditors.length; ++i){
                        editor = PData.editingEditors[i];
                        editingObject[PData.editorToItemMap.get(editor)] = editor.configValue;
                    }
                    editConfirm(editingObject);
                }
            }
            ICButton{
                id:cancelBtn
                text: qsTr("Cancel")
                onButtonClicked: {
                    container.visible = false;
                }
            }
        }
        Component.onCompleted: {
            PData.itemToEditorMap.put("pos", pos);
            PData.itemToEditorMap.put("speed", speed);
            PData.itemToEditorMap.put("delay", delay);
            PData.editorToItemMap.put(pos, "pos");
            PData.editorToItemMap.put(speed, "speed");
            PData.editorToItemMap.put(delay, "delay");
        }
    }
}
