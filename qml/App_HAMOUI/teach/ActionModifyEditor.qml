import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "ActionModifyEditor.js" as PData

Item {
    id:container
    property bool isAutoMode: false
    property variant autoEditableItems: ["speed", "delay", "limit", "acTime", "speed0", "speed1"]
    Rectangle{
        id:bgLayer
        border.color: "black"
        border.width: 1
        width: parent.width
        height: parent.height
        MouseArea{
            anchors.fill: parent
        }
        color: "#A0A0F0"
    }

    signal editConfirm(variant actionObject)

    function openEditor(actionObject,editableItems){
        pos.visible = false;
        speed.visible = false;
        speed0.visible = false;
        speed1.visible = false;

        delay.visible = false;
        limit.visible = false;
        points.visible = false;
        acTime.visible = false;
        customName.visible = false;
        var item;
        var editor;
        var maxWidth = 0;
        height = 0;
        PData.editingActionObject = actionObject;
        PData.editingEditors = [];
        for(var i = 0; i < editableItems.length; ++i){
            item = editableItems[i];
            editor = PData.itemToEditorMap.get(item.item);
            if(editor == points){
                editor.action = actionObject.action;
                editor.points = actionObject[item.item];
            }else{
                editor.configAddr = item.range || "";
                editor.configValue = actionObject[item.item] ||"";
            }

            if((!isAutoMode) || (autoEditableItems.indexOf(item.item) >= 0)){
                editor.visible = true;
                height += editor.height + editorContainer.spacing;
                if(editor.width > maxWidth)
                    maxWidth = editor.width;
                PData.editingEditors.push(editor);
            }
            if(Teach.hasStackIDAction(actionObject)){
                var si = Teach.getStackInfoFromID(actionObject.stackID);
                if(si.type == Teach.stackTypes.kST_Box){
                    speed0.configName = qsTr("Speed0:");
                }else{
                    speed0.configName = qsTr("Speed:");
                    speed1.visible = false;
                }
            }
        }
        height += buttons.height;
        height += 20
        width = maxWidth < 300 ? 300 : maxWidth;
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
            id:customName
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Custom Name:")
            isNumberOnly: false
        }

        ICConfigEdit{
            id:pos
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Pos:")
            unit: qsTr("mm")
        }
        PointEdit{
            id:points
            isEditorMode: true
        }

        ICConfigEdit{
            id:speed
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Speed:")
            unit: qsTr("%")
        }
        ICConfigEdit{
            id:speed0
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Speed:")
            unit: qsTr("%")
        }
        ICConfigEdit{
            id:speed1
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Speed1:")
            unit: qsTr("%")
        }
        ICConfigEdit{
            id:delay
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Delay:")
            unit: qsTr("s")
        }
        ICConfigEdit{
            id:limit
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Limit:")
            unit: qsTr("s")
        }
        ICConfigEdit{
            id:acTime
            configNameWidth: PData.configNameWidth
            inputWidth: PData.inputWidth
            configName: qsTr("Action Time:")
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
                        if(editor == points){
                            editingObject[PData.editorToItemMap.get(editor)] = editor.getPoints();

                        }else{
                            editingObject[PData.editorToItemMap.get(editor)] = editor.configValue;
                        }
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
            PData.itemToEditorMap.put("speed0", speed0);
            PData.itemToEditorMap.put("speed1", speed1);
            PData.itemToEditorMap.put("delay", delay);
            PData.itemToEditorMap.put("points", points);
            PData.itemToEditorMap.put("limit", limit);
            PData.itemToEditorMap.put("acTime", acTime);
            PData.itemToEditorMap.put("customName", customName);

            PData.editorToItemMap.put(pos, "pos");
            PData.editorToItemMap.put(speed, "speed");
            PData.editorToItemMap.put(speed0, "speed0");
            PData.editorToItemMap.put(speed1, "speed1");
            PData.editorToItemMap.put(delay, "delay");
            PData.editorToItemMap.put(points, "points")
            PData.editorToItemMap.put(limit, "limit");
            PData.editorToItemMap.put(acTime, "acTime");
            PData.editorToItemMap.put(customName, "customName");

        }
    }
}
