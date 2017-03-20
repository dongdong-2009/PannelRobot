import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "ActionModifyEditor.js" as PData
import "../configs/IODefines.js" as IODefines
import "../configs/AxisDefine.js" as AxisDefine

Item {
    id:container
    property bool isAutoMode: false
    property variant autoEditableItems: ["speed", "delay", "limit", "acTime", "speed0", "speed1", "pos"]

    property int maxHeight: 310
    function registerEditableItem(editor, itemName){
        editor.parent = editorContainer;
        PData.itemToEditorMap.put(itemName, editor);
        PData.editorToItemMap.put(editor, itemName);
        PData.registerEditors.push(editor);
    }

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
        earlyEndPos.visible = false;
        earlyEndSpdEditor.visible = false;
        startSpeed.visible = false;
        endSpeed.visible = false;
        addr.visible = false;
        data.visible = false;
        signalStopEditor.visible = false;
        rel.visible = false;
        for(var i = 0, len = PData.registerEditors.length; i < len; ++i){
            PData.registerEditors[i].visible = false;
        }
        var item;
        var editor;
        var maxWidth = 0;
        height = 0;
        PData.editingActionObject = actionObject;
        PData.editingEditors = [];
        for(i = 0, len = editableItems.length; i < len; ++i){
            item = editableItems[i];
            editor = PData.itemToEditorMap.get(item.item);
            var isCustomEditor = false;
            if(PData.isRegisterEditor(editor)){
                editor.actionObject = actionObject;
                isCustomEditor = true;
            }
            else if(editor == points){
                editor.action = actionObject.action;
                editor.points = actionObject[item.item];
            }else if(editor == earlyEndPos){
                editor.configValue = actionObject.earlyEndPos || 0.0;
                editor.isChecked = actionObject.isEarlyEnd || false;
            }else if(editor == earlyEndSpdEditor){
                earlyEndSpeedPos.isChecked = actionObject.isEarlySpd || false;
                earlyEndSpeedPos.configValue = actionObject.earlySpdPos ||"";
                earlyEndSpeed.configValue = actionObject.earlySpd || 0.0;
            }else if(editor == signalStopEditor){
                signalStop.isChecked = actionObject.signalStopEn || false;
                signalStop.configValue = actionObject.signalStopPoint || 0;
                fastStop.isChecked = (actionObject.signalStopMode == 1 ? true : false);
            }else if(editor == rel){
                rel.isChecked = actionObject.rel || false;              
            }else if(editor == speed0){
                speedX.configAddr = item.range || "";
                speedY.configAddr = item.range || "";
                speedZ.configAddr = item.range || "";
                speedX.configValue = actionObject.speed0 || 0.0;
                speedY.configValue = (actionObject.speedY == undefined?80.0:actionObject.speedY);
                speedZ.configValue = (actionObject.speedZ == undefined?80.0:actionObject.speedZ);
            }else if(editor == pos){
                pos.axisID = actionObject.axis;
                if(isAutoMode){
                    pos.configAddr = "";
                    pos.min = -20;
                    pos.max = 20;
                    pos.decimal = 3;
                    pos.configValue = "0.000";
                    pos.configName = qsTr("Pos(+/-):");

                }else{
                    pos.configAddr = item.range || "";
                    pos.configValue = actionObject[item.item] ||"";
                    pos.configName = qsTr("Pos:");
                }

            }else{
                editor.configAddr = item.range || "";
                editor.configValue = actionObject[item.item] ||"";
            }
            if((!isAutoMode) || (autoEditableItems.indexOf(item.item) >= 0) || isCustomEditor){
                editor.visible = true;
                if(isCustomEditor){
                    if(editor.hasOwnProperty("isAutoMode"))
                        editor.isAutoMode = isAutoMode;
                }
                height += editor.height + editorContainer.spacing;
                if(height > maxHeight) height = maxHeight;
                if(editor.width > maxWidth)
                    maxWidth = editor.width;
                PData.editingEditors.push(editor);
            }
            if(Teach.hasStackIDAction(actionObject)){
                var si = Teach.getStackInfoFromID(actionObject.stackID);
                if(si.type == Teach.stackTypes.kST_Box){
                    speedX.configName = AxisDefine.axisInfos[0].name +qsTr("Speed0:");
                    speedY.configName = AxisDefine.axisInfos[1].name +qsTr("Speed0:");
                    speedZ.configName = AxisDefine.axisInfos[2].name +qsTr("Speed0:");
                }else{
                    speedX.configName = AxisDefine.axisInfos[0].name + qsTr("Speed:");
                    speedY.configName = AxisDefine.axisInfos[1].name + qsTr("Speed:");
                    speedZ.configName = AxisDefine.axisInfos[2].name + qsTr("Speed:");
                    speed1.visible = false;
                }
            }
        }
        if(Teach.hasPosAction(actionObject)){
            var isSpeedMode = false;
            if(actionObject.stop)
                isSpeedMode = true;
            else if(actionObject.speedMode)
                isSpeedMode = true;
            earlyEndPos.visible = !isSpeedMode && !isAutoMode;
            earlyEndSpdEditor.visible = !isSpeedMode && !isAutoMode;
            signalStopEditor.visible = !isSpeedMode && !isAutoMode;
        }
        height += buttons.height + buttons.spacing + 6;
//        height += 20
        width = maxWidth < 300 ? 300 : maxWidth;
        visible = height > buttons.height + buttons.spacing + 6;
    }
    visible: false
    width: 300
    ICFlickable{
        id:editorContainerFrame
        y:10
        x:10
        flickableDirection: Flickable.VerticalFlick
        clip: true
        isshowhint: true
        width: editorContainer.width + 10
        height: Math.min(editorContainer.height, maxHeight) + 4
        hintx: width - 15
        contentWidth: editorContainer.width + 10
        contentHeight: editorContainer.height
        Column{
            id:editorContainer
            spacing: 6
            ICConfigEdit{
                id:customName
                configNameWidth: PData.configNameWidth
                inputWidth: PData.inputWidth
                configName: qsTr("Custom Name:")
                isNumberOnly: false
                height: 32
            }

            ICConfigEdit{
                id:pos
                property int axisID: 0
                configNameWidth: PData.configNameWidth
                inputWidth: PData.inputWidth
                configName: qsTr("Pos:")
                unit: qsTr("mm")
                height: 32
                ICButton{
                    id:setInBtn
                    text: qsTr("Set In")
                    anchors.left: parent.right
                    anchors.leftMargin: 6
                    visible: !isAutoMode
                    onButtonClicked: {
                        pos.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[pos.axisID].jAddr) / 1000).toFixed(3);
                    }
                }
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
                height: 32

            }
            Column{
                id:speed0
                spacing: 10
                ICConfigEdit{
                    id:speedX
                    configNameWidth: PData.configNameWidth
                    inputWidth: PData.inputWidth
                    configName: AxisDefine.axisInfos[0].name + qsTr("Speed:")
                    unit: qsTr("%")
                    height: 32
                }
                ICConfigEdit{
                    id:speedY
                    configNameWidth: PData.configNameWidth
                    inputWidth: PData.inputWidth
                    configName: AxisDefine.axisInfos[1].name+ qsTr("Speed:")
                    unit: qsTr("%")
                    height: 32
                }
                ICConfigEdit{
                    id:speedZ
                    configNameWidth: PData.configNameWidth
                    inputWidth: PData.inputWidth
                    configName: AxisDefine.axisInfos[2].name + qsTr("Speed:")
                    unit: qsTr("%")
                    height: 32
                }
            }
            ICConfigEdit{
                id:speed1
                configNameWidth: PData.configNameWidth
                inputWidth: PData.inputWidth
                configName: qsTr("Speed1:")
                unit: qsTr("%")
                height: 32

            }
            ICConfigEdit{
                id:delay
                configNameWidth: PData.configNameWidth
                inputWidth: PData.inputWidth
                configName: qsTr("Delay:")
                unit: qsTr("s")
                height: 32

            }
            ICConfigEdit{
                id:limit
                configNameWidth: PData.configNameWidth
                inputWidth: PData.inputWidth
                configName: qsTr("Limit:")
                unit: qsTr("s")
                height: 32

            }
            ICConfigEdit{
                id:acTime
                configNameWidth: PData.configNameWidth
                inputWidth: PData.inputWidth
                configName: qsTr("Action Time:")
                unit: qsTr("s")
                height: 32

            }
            ICCheckableLineEdit{
                id:earlyEndPos
                configName: qsTr("Early End Pos");
                enabled: !signalStop.isChecked;
            }
            Row{
                id:earlyEndSpdEditor
                spacing: 4
                width: 380
                ICCheckableLineEdit{
                    id:earlyEndSpeedPos
                    configName: qsTr("ESD Pos")
                    enabled: earlyEndPos.enabled
                }

                ICConfigEdit{
                    id:earlyEndSpeed
                    configName: qsTr("ESD")
                    unit: qsTr("%")
                    configAddr: "s_rw_0_32_1_1200"
                    enabled: earlyEndSpeedPos.isChecked
                }
            }
            ICCheckBox{
                id:rel
                text: qsTr("Rel")
                enabled: earlyEndPos.enabled
            }

            Row{
                id:signalStopEditor
                spacing: 6
                ICCheckableComboboxEdit{
                    id:signalStop
                    configName: qsTr("Signal Stop")
                    configValue: -1
                    inputWidth: 100
                    z:2
                    enabled: !(earlyEndPos.isChecked || earlyEndSpeedPos.isChecked || rel.isChecked);
                    Component.onCompleted: {
                        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
                        if(ioBoardCount == 0)
                            ioBoardCount = 1;
                        var len = ioBoardCount * 32;
                        var ioItems = [];
                        for(var i = 0; i < len; ++i){
                            ioItems.push(IODefines.ioItemName(IODefines.xDefines[i]));
                        }
                        items = ioItems;
                    }
                }
                ICCheckBox{
                    id:fastStop
                    text: qsTr("Fast Stop")
                }
            }

            ICConfigEdit{
                id:startSpeed
                configNameWidth: PData.configNameWidth
                configName: qsTr("startSpeed")
                inputWidth: PData.inputWidth
                unit: qsTr("%")
                height: 32
            }
            ICConfigEdit{
                id:endSpeed
                configNameWidth: PData.configNameWidth
                configName: qsTr("endSpeed")
                inputWidth: PData.inputWidth
                unit: qsTr("%")
                height: 32
            }
            ICConfigEdit{
                id:addr
                configNameWidth: PData.configNameWidth
                configName: qsTr("addr")
                inputWidth: PData.inputWidth
                height: 32
            }
            ICConfigEdit{
                id:data
                configNameWidth: PData.configNameWidth
                configName: qsTr("data")
                inputWidth: PData.inputWidth
                height: 32
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
                PData.itemToEditorMap.put("earlyEnd", earlyEndPos);
                PData.itemToEditorMap.put("earlyEndSpd", earlyEndSpdEditor);
                PData.itemToEditorMap.put("startSpeed", startSpeed);
                PData.itemToEditorMap.put("endSpeed", endSpeed);
                PData.itemToEditorMap.put("addr",addr);
                PData.itemToEditorMap.put("data",data);
                PData.itemToEditorMap.put("signalStop", signalStopEditor);
                PData.itemToEditorMap.put("rel", rel);

                PData.editorToItemMap.put(pos, "pos");
                PData.editorToItemMap.put(speed, "speed");
                PData.editorToItemMap.put(speed0, "speed0");
                PData.editorToItemMap.put(speed1, "speed1");
                PData.editorToItemMap.put(delay, "delay");
                PData.editorToItemMap.put(points, "points")
                PData.editorToItemMap.put(limit, "limit");
                PData.editorToItemMap.put(acTime, "acTime");
                PData.editorToItemMap.put(customName, "customName");
                PData.editorToItemMap.put(earlyEndPos, "earlyEnd");
                PData.editorToItemMap.put(earlyEndSpdEditor, "earlyEndSpd");
                PData.editorToItemMap.put(startSpeed, "startSpeed");
                PData.editorToItemMap.put(endSpeed, "endSpeed");
                PData.editorToItemMap.put(addr, "addr");
                PData.editorToItemMap.put(data, "data");
                PData.editorToItemMap.put(signalStopEditor, "signalStop")
                PData.editorToItemMap.put(rel, "rel");

            }
        }
    }

    Row{
        id:buttons
        spacing: 20
        anchors.top: editorContainerFrame.bottom
        anchors.topMargin: editorContainer.spacing
        anchors.right: parent.right
        anchors.rightMargin: 10
        ICButton{
            id:okBtn
            text: qsTr("Ok")
            bgColor: "lime"
            height: 40
            onButtonClicked: {
                container.visible = false;
                var editingObject = PData.editingActionObject;
                //                    var modifiedObject = {};
                var editor;
                for(var i = 0; i < PData.editingEditors.length; ++i){
                    editor = PData.editingEditors[i];
                    if(PData.isRegisterEditor(editor)){
                        editor.updateActionObject(editingObject);
                    }
                    else if(editor == points){
                        editingObject[PData.editorToItemMap.get(editor)] = editor.getPoints();

                    }else if(editor == earlyEndPos){
                        editingObject.isEarlyEnd = earlyEndPos.isChecked;
                        editingObject.earlyEndPos = earlyEndPos.configValue;
                    }else if(editor == earlyEndSpdEditor){
                        editingObject.isEarlySpd = earlyEndSpeedPos.isChecked;
                        editingObject.earlySpdPos = earlyEndSpeedPos.configValue;
                        editingObject.earlySpd = earlyEndSpeed.configValue;
                    }else if(editor == signalStopEditor){
                        editingObject.signalStopEn = signalStop.isChecked;
                        editingObject.signalStopPoint = signalStop.configValue;
                        editingObject.signalStopMode = (fastStop.isChecked ? 1 : 0);
                    }else if(editor == rel){
                        editingObject.rel = rel.isChecked;
                    }else if(editor == speed0){
                        editingObject.speed0 = speedX.configValue;
                        editingObject.speedY = speedY.configValue;
                        editingObject.speedZ = speedZ.configValue;
                    }else if(editor == pos){
                        if(isAutoMode){
                            var o = parseFloat(editingObject.pos);
                            o += parseFloat(pos.configValue);
                            editingObject.pos = o.toFixed(3);
                        }else{
                            editingObject.pos = editor.configValue;
                        }
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
            bgColor: "yellow"
            height: 40
            onButtonClicked: {
                container.visible = false;
            }
        }
    }
}
