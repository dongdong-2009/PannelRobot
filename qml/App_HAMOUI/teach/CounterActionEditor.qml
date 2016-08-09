import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../../utils/utils.js" as Utils
import "CounterActionEditor.js" as PData
import "ProgramFlowPage.js" as ProgramList

Rectangle {
    function createActionObjects(){
        var ret = [];
        var editor;
        for(var cid in PData.editors){
            editor = PData.editors[cid];
            if(editor.isSel){
                if(setCounter.isChecked)
                    ret.push(Teach.generateCounterAction(editor.cID));
                else if(clearCounter.isChecked)
                    ret.push(Teach.generateClearCounterAction(editor.cID));
            }
        }

        return ret;
    }

    signal counterUpdated(int id);

    ICButtonGroup{
        id:typeContainer
        layoutMode: 1
        mustChecked: true
        spacing: 8
        ICCheckBox{
            id:setCounter
            text: qsTr("Set Counter")
        }
        ICCheckBox{
            id:clearCounter
            text: qsTr("Clear Counter")
        }
    }
    ICMessageBox{
        id:tipBox
        visible: false
        x:200
        y:-50
        z:10
    }

    Column{
        id:commandContainer
        spacing: 6
        anchors.left: counterViewContaienr.right
        anchors.leftMargin: 6
        y:counterViewContaienr.y
        ICLineEdit{
            id:newCounterName
            isNumberOnly: false
            inputWidth: 120
        }
        ICButton{
            id:newCounterBtn
            text: qsTr("New")
            width: 80
            bgColor: "lime"
            onButtonClicked: {
                var toAdd = Teach.counterManager.newCounter(newCounterName.text, 0, 0);
                if(panelRobotController.saveCounterDef(toAdd.id, toAdd.name, toAdd.current, toAdd.target))
                    counterContainer.addCounter(toAdd.id, toAdd.name, toAdd.current, toAdd.target);
                counterUpdated(toAdd.id);
            }
        }

        ICButton{
            id:delCounterBtn
            text: qsTr("Delete")
            x:newCounterBtn.x
            width: 80
            bgColor: "red"
            onButtonClicked: {
                var editor;
                var tip = "";
                var details = "";
                for(var cid in PData.editors){
                    editor = PData.editors[cid];
                    if(editor.isSel){
                        var usedInfo = ProgramList.counterLinesInfo.idUsed(editor.cID);
                        if(usedInfo.used){
//                            console.log(ProgramList.LinesInfo.usedLineInfoString(usedInfo));
                            details += ProgramList.LinesInfo.usedLineInfoString(usedInfo) + "\n";
                            tip += Teach.counterManager.counterToString(editor.cID) + " " +  qsTr("is using!") + "\n";
                            continue;
                        }

                        Teach.counterManager.delCounter(editor.cID);
                        panelRobotController.delCounterDef(editor.cID);
                        counterUpdated(editor.cID);
                         PData.editors[editor.cID].destroy();
                        delete PData.editors[editor.cID];

                    }
                }
                if(tip != ""){
                    tipBox.warning(tip, qsTr("OK"), details);
                }
            }

        }
    }

    Rectangle{
        id:counterViewContaienr
        border.width: 1
        border.color: "black"
        width: 395
        height: parent.height - 10
        anchors.left: typeContainer.right
        anchors.leftMargin: 4
        Column{
            anchors.fill: parent
            spacing: 2
            Row{
                id:viewHeader
                spacing: 4
                Text {
                    id: headerID
                    text: qsTr("ID")
                    horizontalAlignment: Text.AlignHCenter
                    width: headerSplitLine.width * 0.1 - parent.spacing
                }
                Text {
                    id: headerName
                    text: qsTr("Name")
                    horizontalAlignment: Text.AlignHCenter

                    width: headerSplitLine.width * 0.5 - parent.spacing

                }
                Text {
                    id: headerCurrent
                    text: qsTr("Current")
                    horizontalAlignment: Text.AlignHCenter

                    width: headerSplitLine.width * 0.19 - parent.spacing

                }
                Text {
                    id: headerTarget
                    text: qsTr("Target")
                    horizontalAlignment: Text.AlignHCenter

                    width: headerSplitLine.width * 0.19 - parent.spacing

                }
            }
            Rectangle{
                id:headerSplitLine
                height: 1
                width: counterViewContaienr.width - 12
                color: "gray "
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ICFlickable{
                contentWidth: counterContainer.width
                contentHeight: counterContainer.height
                flickableDirection: Flickable.VerticalFlick
                width: headerSplitLine.width
                height: counterViewContaienr.height - viewHeader.height - headerSplitLine.height - parent.spacing - 5
                clip: true
                Column{
                    x:2
                    id:counterContainer
                    spacing: 4
                    function onCounterEditFinished(cid, name, current, target){
                        Teach.counterManager.updateCounter(cid, name, current, target);
                        panelRobotController.saveCounterDef(cid, name, current, target);
                        counterUpdated(cid);
                    }

                    function addCounter(cid, name, cc, ct){
                        var editorClass = Qt.createComponent("CounterActionEditorComponent.qml");
                        var editor = editorClass.createObject(counterContainer, {"cID":cid, "cName":name, "cc":cc, "ct":ct,
                                                                  "cIDWidth":headerID.width, "nameWidth":headerName.width,
                                                                  "currentWidth":headerCurrent.width, "targetWidth":headerTarget.width});
                        editor.counterEditFinished.connect(counterContainer.onCounterEditFinished);
                        PData.editors[cid] = editor;
                    }
                }
            }
        }
    }
    function onMoldChanged(){
        var counters = JSON.parse(panelRobotController.counterDefs());
        Teach.counterManager.init(counters);
        Teach.variableManager.init(JSON.parse(panelRobotController.variableDefs()));
        var cs = Teach.counterManager.counters;
        var cc;
        var editor;
        for(var cid in PData.editors){
            editor = PData.editors[cid];
            PData.editors[editor.cID].destroy();
            delete PData.editors[editor.cID];
        }
        for(var c in cs){
            cc = cs[c];
            counterContainer.addCounter(cc.id, cc.name, cc.current, cc.target);
        }
    }

    onVisibleChanged: {
        if(visible){
            var editor;
            for(var p in PData.editors){
                editor = PData.editors[p];
                editor.cc = Teach.counterManager.getCounter(editor.cID).current;
            }
        }
    }

    Component.onCompleted: {
        panelRobotController.moldChanged.connect(onMoldChanged);
        onMoldChanged();
    }
}
