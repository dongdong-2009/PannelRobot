import QtQuick 1.1
import "../../ICCustomElement"
import "ProgramActionMenuFrame.js" as PData

Rectangle{
    id:actionEditorFrame
    border.width: 1
    border.color: "black"

    signal insertActionTriggered()

    function showActionMenu() {
        actionEditorContainer.setCurrentIndex(0);
        linkedBtn1.visible = false;
        linkedBtn2.visible = false;
        linkedBtn3.visible = false;
    }

    function setMode(mode){
        actionMenuObject.state = mode;
    }

    function createActionObjects(){
        if(actionEditorContainer.isMenuShow()) return 0;
        return actionEditorContainer.currentPage().createActionObjects();
    }

    function isMenuVisiable() { return actionEditorContainer.isMenuShow();}

    function showMenu(){
        if(!actionEditorContainer.isMenuShow() && visible)
            showActionMenu();
    }

    function actionEditorContainerInstance() { return actionEditorContainer;}

    ICButton{
        id:insertBtn
        x:4
        y:4
        width: 80
        height: 32
        text: qsTr("Insert")
        bgColor: "lime"
    }

    Rectangle{
        id:menuSplitLine1
        height: 1
        width: 70
        x:8
        anchors.top: insertBtn.bottom
        anchors.topMargin: 4
        color: "gray"
    }

    ICButton{
        id:linkedBtn1
        x:insertBtn.x
        anchors.top: menuSplitLine1.bottom
        anchors.topMargin: 8
        width: 80
        height: 32
        bgColor: "#A0A0F0"
        onButtonClicked: PData.linked1Function();

    }

    ICButton{
        id:linkedBtn2
        x:insertBtn.x
        anchors.top: linkedBtn1.bottom
        anchors.topMargin: 8
        width: 80
        height: 32
        bgColor: "mediumspringgreen"
        onButtonClicked: PData.linked2Function();

    }

    ICButton{
        id:linkedBtn3
        x:insertBtn.x
        anchors.top: linkedBtn2.bottom
        anchors.topMargin: 8
        width: 80
        height: 32
        bgColor: "mediumturquoise"
        onButtonClicked: PData.linked3Function();

    }

    Rectangle{
        height: 1
        width: 70
        x:8
        anchors.bottom: actionMenuBtn.top
        anchors.bottomMargin: 4
        color: "gray"
    }

    ICButton{
        id:actionMenuBtn
        x:insertBtn.x + insertBtn.width / 2
        y: 176
        width: insertBtn.width / 2
        height: insertBtn.height
        text: qsTr("Menu")
        bgColor: "yellow"
        font.pixelSize: 12
    }
    Rectangle{
        id:splitLine
        width: 1
        y:2
        height:parent.height -3
        anchors.left: insertBtn.right
        anchors.leftMargin: 5
        color: "gray"
    }

    ICStackContainer{

        function isMenuShow() { return currentIndex == 0;}
        id:actionEditorContainer
        width: parent.width - insertBtn.width - anchors.leftMargin - splitLine.width -splitLine.anchors.leftMargin
        height: parent.height - 1
        anchors.left: insertBtn.right
        anchors.leftMargin: 10

        ProgramActionMenu{
            id:actionMenuObject
        }
    }
    Component.onCompleted: {
        var editor = Qt.createComponent('AxisActionEditor.qml');
        var axisEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('OutputActionEditor.qml')
        var outputEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('WaitActionEditor.qml')
        var waitEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('CheckActionEditor.qml')
        var checkEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('ConditionActionEditor.qml')
        var conditionEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('SyncActionEditor.qml')
        var syncEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('CommentActionEditor.qml')
        var commentEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('SearchActionEditor.qml')
        var searchEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('PathActionEditor.qml')
        var pathEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('StackActionEditor.qml')
        var stackEditorObject = editor.createObject(actionEditorContainer);
        stackEditorObject.stackUpdated.connect(onStackUpdated);
        editor = Qt.createComponent('CounterActionEditor.qml')
        var counterEditorObject = editor.createObject(actionEditorContainer);
        counterEditorObject.counterUpdated.connect(onCounterUpdated);
        editor = Qt.createComponent('CustomAlarmActionEditor.qml')
        var customAlarmEditorObject = editor.createObject(actionEditorContainer);
        editor = Qt.createComponent('ModuleActionEditor.qml')
        var moduleEditorObject = editor.createObject(actionEditorContainer);
//        PData.moduleActionEditor = moduleEditorObject;

        editor = Qt.createComponent('OriginActionEditor.qml')
        var originEditorObject = editor.createObject(actionEditorContainer);

        editor = Qt.createComponent('VisionActionEditor.qml')
        var visionEditorObject = editor.createObject(actionEditorContainer);

        actionEditorContainer.addPage(actionMenuObject);
        actionEditorContainer.addPage(axisEditorObject);
        actionEditorContainer.addPage(outputEditorObject);
        actionEditorContainer.addPage(waitEditorObject);
        actionEditorContainer.addPage(checkEditorObject);
        actionEditorContainer.addPage(conditionEditorObject);
        actionEditorContainer.addPage(syncEditorObject);
        actionEditorContainer.addPage(commentEditorObject);
        actionEditorContainer.addPage(searchEditorObject);
        actionEditorContainer.addPage(pathEditorObject);
        actionEditorContainer.addPage(stackEditorObject);
        actionEditorContainer.addPage(counterEditorObject);
        actionEditorContainer.addPage(customAlarmEditorObject);
        actionEditorContainer.addPage(moduleEditorObject);
        actionEditorContainer.addPage(originEditorObject);
        actionEditorContainer.addPage(visionEditorObject);


        showActionMenu();
        actionMenuObject.axisMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(1);
            linkedBtn1.text = qsTr("Output Action");
            linkedBtn1.visible = true;
            PData.linked1Function = actionMenuObject.outputMenuTriggered;

            linkedBtn2.text = qsTr("Wait");
            linkedBtn2.visible = true;
            PData.linked2Function = actionMenuObject.waitMenuTriggered;

            linkedBtn3.text = qsTr("Condition")
            linkedBtn3.visible = true;
            linkedBtn3.enabled = moduleSel.currentIndex == 0;
            PData.linked3Function = actionMenuObject.conditionMenuTriggered;
        });
        actionMenuObject.outputMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(2);
            linkedBtn1.text = qsTr("Path");
            linkedBtn1.visible = true;
            PData.linked1Function = actionMenuObject.pathMenuTriggered;

            linkedBtn2.text = qsTr("Wait");
            linkedBtn2.visible = true;
            PData.linked2Function = actionMenuObject.waitMenuTriggered;

            linkedBtn3.text = qsTr("Check")
            linkedBtn3.visible = true;
            PData.linked3Function = actionMenuObject.checkMenuTriggered;
        });
        actionMenuObject.waitMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(3);
            linkedBtn1.text = qsTr("Path");
            linkedBtn1.visible = true;
            PData.linked1Function = actionMenuObject.pathMenuTriggered;

            linkedBtn2.text = qsTr("Output Action");
            linkedBtn2.visible = true;
            PData.linked2Function = actionMenuObject.outputMenuTriggered;

            linkedBtn3.text = qsTr("Check")
            linkedBtn3.visible = true;
            PData.linked3Function = actionMenuObject.checkMenuTriggered;
        });
        actionMenuObject.checkMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(4);
            linkedBtn1.text = qsTr("Path");
            linkedBtn1.visible = true;
            PData.linked1Function = actionMenuObject.pathMenuTriggered;

            linkedBtn2.text = qsTr("Wait");
            linkedBtn2.visible = true;
            PData.linked2Function = actionMenuObject.waitMenuTriggered;

            linkedBtn3.text = qsTr("Output Action")
            linkedBtn3.visible = true;
            PData.linked3Function = actionMenuObject.checkMenuTriggered;
        });
        actionMenuObject.conditionMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(5);
            linkedBtn1.text = qsTr("Path");
            linkedBtn1.visible = true;
            PData.linked1Function = actionMenuObject.pathMenuTriggered;

            linkedBtn2.text = qsTr("Output Action");
            linkedBtn2.visible = true;
            PData.linked2Function = actionMenuObject.outputMenuTriggered;

            linkedBtn3.text = qsTr("Check")
            linkedBtn3.visible = true;
            PData.linked3Function = actionMenuObject.checkMenuTriggered;
        });
        actionMenuObject.syncMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(6);
            linkedBtn1.visible = false;
            linkedBtn2.visible = false;
            linkedBtn3.visible = false;
        });
        actionMenuObject.commentMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(7);
            linkedBtn1.visible = false;
            linkedBtn2.visible = false;
            linkedBtn3.visible = false;
        });
        actionMenuObject.searchMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(8);
            linkedBtn1.visible = false;
            linkedBtn2.visible = false;
            linkedBtn3.visible = false;
        });
        actionMenuObject.pathMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(9);
            linkedBtn1.text = qsTr("Output Action");
            linkedBtn1.visible = true;
            PData.linked1Function = actionMenuObject.outputMenuTriggered;

            linkedBtn2.text = qsTr("Wait");
            linkedBtn2.visible = true;
            PData.linked2Function = actionMenuObject.waitMenuTriggered;

            linkedBtn3.text = qsTr("Condition")
            linkedBtn3.visible = true;
            linkedBtn3.enabled = moduleSel.currentIndex == 0;
            PData.linked3Function = actionMenuObject.conditionMenuTriggered;
        });
        actionMenuObject.stackMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(10);
            linkedBtn1.text = qsTr("Output Action");
            linkedBtn1.visible = true;
            PData.linked1Function = actionMenuObject.outputMenuTriggered;

            linkedBtn2.text = qsTr("Path");
            linkedBtn2.visible = true;
            PData.linked2Function = actionMenuObject.pathMenuTriggered;

            linkedBtn3.text = qsTr("Counter")
            linkedBtn3.visible = true;
            PData.linked3Function = actionMenuObject.counterMenuTriggered;
        });
        actionMenuObject.counterMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(11);
            linkedBtn1.text = qsTr("Path");
            linkedBtn1.visible = true;
            PData.linked1Function = actionMenuObject.pathMenuTriggered;

            linkedBtn2.text = qsTr("Wait");
            linkedBtn2.visible = true;
            PData.linked2Function = actionMenuObject.waitMenuTriggered;

            linkedBtn3.text = qsTr("Condition")
            linkedBtn3.visible = true;
            linkedBtn3.enabled = moduleSel.currentIndex == 0;
            PData.linked3Function = actionMenuObject.conditionMenuTriggered;
        });
        actionMenuObject.customAlarmMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(12);
            linkedBtn1.visible = false;
            linkedBtn2.visible = false;
            linkedBtn3.visible = false;
        });
        actionMenuObject.moduleMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(13);
            linkedBtn1.visible = false;
            linkedBtn2.visible = false;
            linkedBtn3.visible = false;
        });
        actionMenuObject.originMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(14);
            linkedBtn1.visible = false;
            linkedBtn2.visible = false;
            linkedBtn3.visible = false;
        });
        actionMenuObject.visionMenuTriggered.connect(function(){
            actionEditorContainer.setCurrentIndex(15);
            linkedBtn1.visible = false;
            linkedBtn2.visible = false;
            linkedBtn3.visible = false;
        });

        actionMenuBtn.buttonClicked.connect(showActionMenu);
        insertBtn.buttonClicked.connect(insertActionTriggered);
    }
}

