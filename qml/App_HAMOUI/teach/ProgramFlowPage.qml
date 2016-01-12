import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../Theme.js" as Theme
import "../../utils/utils.js" as Utils
import "ProgramFlowPage.js" as PData
import "../configs/Keymap.js" as Keymap
import "../ShareData.js" as ShareData
import "../../utils/stringhelper.js" as ICString
import "../ICOperationLog.js" as ICOperationLog


Rectangle {
    id:programFlowPageInstance
    property alias isActionEditorPanelVisable: actionEditorFrame.visible
    function showActionEditorPanel(){
        if(actionEditorFrame.visible && actionEditorContainer.currentIndex != 0){
            actionEditorContainer.showMenu();
            return;
        }
        if(!actionEditorFrame.visible)
            programListView.contentY += actionEditorFrame.height;
        else
            programListView.contentY -= actionEditorFrame.height;

        actionEditorFrame.visible = !actionEditorFrame.visible;
    }

    function onInsertTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 0)return;
        if(actionEditorContainer.isMenuShow()) return;
        var actionObjects = actionEditorContainer.currentPage().createActionObjects();
        if(actionObjects.length == 0) return;
        var model = currentModel();
        for(var i = 0; i < actionObjects.length; ++i){
            if(actionObjects[i].action === Teach.actions.ACT_FLAG){
                Teach.pushFlag(actionObjects[i].flag, actionObjects[i].comment);
            }

            model.insert(cI++, new Teach.ProgramModelItem(actionObjects[i], Teach.actionTypes.kAT_Normal));
        }
        repaintProgramItem(model)
        //        var msg = {"programModel":model}
        //        repaintThread.sendMessage(msg);
    }

    function onDeleteTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 0)return;
        var model = currentModel();
        if(cI >= model.count - 1) return;
        var actionObject = model.get(cI).mI_ActionObject;
        if(actionObject.action === Teach.actions.ACT_FLAG){
            Teach.delFlag(actionObject.flag);
        }
        model.remove(cI);
        repaintProgramItem(model);
    }

    function onUpTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 1)return;
        var model = currentModel();
        if(cI >= model.count - 1) return;
        var cIAction = currentModelData().mI_ActionObject;
        var cIPAction = model.get(cI - 1).mI_ActionObject;


        //        if(cIAction.action === Teach.actions.F_CMD_SYNC_START){
        //            if(!Teach.isSyncAction(cIPAction))
        //                model.set(cI - 1, {"mI_ActionType":Teach.actionTypes.kAT_SyncStart});
        //        }else if(cIAction.action === Teach.actions.F_CMD_SYNC_END){
        //            if(!Teach.isSyncAction(cIPAction))
        //                model.set(cI - 1, {"mI_ActionType":Teach.actionTypes.kAT_Normal});
        //        }else if(cIPAction.action === Teach.actions.F_CMD_SYNC_START){
        //            model.set(cI, {"mI_ActionType":Teach.actionTypes.kAT_Normal});
        //        }else if(cIPAction.action === Teach.actions.F_CMD_SYNC_END){
        //            model.set(cI, {"mI_ActionType":Teach.actionTypes.kAT_SyncStart});
        //        }

        model.move(cI, cI -1, 1);
        if(Teach.isSyncAction(cIAction) ||
                Teach.isSyncAction(cIPAction)){
            repaintProgramItem(model);
        }
    }

    function onDownTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 0)return;
        var model = currentModel();
        if(cI >= model.count - 2) return;
        var cIAction = currentModelData().mI_ActionObject;
        var cINAction = model.get(cI + 1).mI_ActionObject;
        //        if(cIAction.action === Teach.actions.F_CMD_SYNC_START){
        //            if(!Teach.isSyncAction(cINAction))
        //                model.set(cI + 1, {"mI_ActionType":Teach.actionTypes.kAT_Normal});
        //        }else if(cIAction.action === Teach.actions.F_CMD_SYNC_END){
        //            if(!Teach.isSyncAction(cINAction))
        //                model.set(cI + 1, {"mI_ActionType":Teach.actionTypes.kAT_SyncStart});
        //        }else if(cINAction.action === Teach.actions.F_CMD_SYNC_START){
        //            model.set(cI, {"mI_ActionType":Teach.actionTypes.kAT_SyncStart});
        //        }else if(cINAction.action === Teach.actions.F_CMD_SYNC_END){
        //            model.set(cI, {"mI_ActionType":Teach.actionTypes.kAT_Normal});
        //        }
        model.move(cI, cI  + 1, 1);
        if(Teach.isSyncAction(cIAction) ||
                Teach.isSyncAction(cINAction)){
            repaintProgramItem(model);
        }

    }

    function onEditConfirm(actionObject){
        currentModelData().mI_ActionObject = actionObject;
        if(ShareData.GlobalStatusCenter.getKnobStatus() === Keymap.KNOB_AUTO){
            if(panelRobotController.fixProgramOnAutoMode(editing.currentIndex,
                                                         programListView.currentIndex,
                                                         JSON.stringify(actionObject))){
                if(editing.currentIndex === 0)
                    panelRobotController.saveMainProgram(modelToProgram(0));
                else
                    panelRobotController.saveSubProgram(modelToProgram(editing.currentIndex));



            }
        }
    }

    function modelToProgram(which){
        var model = PData.programs[which];
        var ret = [];
        for(var i = 0; i < model.count; ++i){
            ret.push(model.get(i).mI_ActionObject);
        }
        return JSON.stringify(ret);
    }

    function onSaveTriggered(){
        var errInfo;
        if(editing.currentIndex == 0){
            errInfo = JSON.parse(panelRobotController.saveMainProgram(modelToProgram(0)));
            if(errInfo.length === 0){
                panelRobotController.sendMainProgramToHost();
            }
        }else{
            errInfo = JSON.parse(panelRobotController.saveSubProgram(editing.currentIndex, modelToProgram(editing.currentIndex)));
            if(errInfo.length === 0){
                panelRobotController.sendSubProgramToHost(editing.currentIndex);
            }
        }
        if(errInfo.length !== 0){
            var toShow = "";
            for(var i = 0; i < errInfo.length; ++i){
                toShow += qsTr("Line") + errInfo[i].line + ":" + Teach.ccErrnoToString(errInfo[i].errno) + "\n";
            }
            tipBox.show(toShow);
        }
        collectSpecialLines(editing.currentIndex);
        var programStr = editing.currentIndex == 0 ? qsTr("Main Program") : ICString.icStrformat(qsTr("Sub-{0} Program"), editing.currentIndex);
        ICOperationLog.opLog.appendOperationLog(ICString.icStrformat(qsTr("Save {0} of Record:{1}"), programStr, panelRobotController.currentRecordName()));
    }

    //    function saveProgram(which){

    //    }

    function currentModel(){
        return PData.programs.length == 0?  mainProgramModel: PData.programs[editing.currentIndex];
    }

    function currentModelData() {
        if(programListView.currentIndex < 0) return null;
        return currentModel().get(programListView.currentIndex);
    }

    function currentModelStep(){
        return panelRobotController.statusValue(PData.stepAddrs[editing.currentIndex]);
    }

    function currentModelRunningActionInfo(){
        var ret = panelRobotController.currentRunningActionInfo(editing.currentIndex);
        var info = JSON.parse(ret);
        return info;
    }

    function onUserChanged(user){
        PData.isReadOnly = ( (ShareData.GlobalStatusCenter.getKnobStatus() === Keymap.KNOB_AUTO) || !ShareData.UserInfo.currentHasMoldPerm());
        //        if(!ShareData.UserInfo.currentHasMoldPerm())
        programListView.currentIndex = -1;
    }

    function onKnobChanged(knobStatus){
        onUserChanged(null);
        var isAuto = (knobStatus === Keymap.KNOB_AUTO);
        isFollow.visible = isAuto;
        modifyEditor.isAutoMode = isAuto;
        actionEditorFrame.visible = false;
        speedDispalyContainer.visible = isAuto;
    }

    function onStackUpdated(stackID){
        var stackLines = PData.stackLinesInfo.getLines(editing.currentIndex, stackID)
        var md = currentModel();
        var tmp;
        var line;
        var si = Teach.getStackInfoFromID(stackID);
        var c1 = si.si0.doesBindingCounter ? si.si0.counterID : -1;
        var c2 = ((si.si1.doesBindingCounter) && (si.type == Teach.stackTypes.kST_Box)) ? si.si1.counterID : -1;
        for(var l in stackLines){
            line = stackLines[l];
            tmp = md.get(line);
            md.set(line, {"actionText":Teach.actionToString(tmp.mI_ActionObject)});
            PData.counterLinesInfo.removeLine(editing.currentIndex, line);
            if(c1 >= 0)
                PData.counterLinesInfo.add(editing.currentIndex, c1, line);
            if(c2 >= 0)
                PData.counterLinesInfo.add(editing.currentIndex, c2, line);
        }
//        collectSpecialLines(editing.currentIndex);
    }

    function onCounterUpdated(counterID){
        var counterLines  = PData.counterLinesInfo.getLines(editing.currentIndex,counterID);
        var md = currentModel();
        var tmp;
        var line;
        for(var l in counterLines){
            line = counterLines[l];
            tmp = md.get(line);
            md.set(line, {"actionText":Teach.actionToString(tmp.mI_ActionObject)});

        }
    }

    function onGlobalSpeedChanged(spd){
        speedDisplay.text = parseFloat(spd).toFixed(1);
    }

    //    function setCurrentModelData(actionObject){
    //        currentModel().set(programListView.currentIndex,
    //                           new Teach.ProgramModelItem(actionObject));
    //    }

    WorkerScript{
        id:repaintThread
        source: "repaintProgram.js"
    }

    Column{
        id:container
        width: 792
        height: 420
        spacing: 2
        Rectangle{
            id:programViewContainer
            x:2
            width: parent.width
            height: actionEditorFrame.visible ? container.height / 2 : container.height
            color: Theme.defaultTheme.BASE_BG

            Row{
                id:programSelecterContainer
                spacing: 10
                y:2
                z:1
                //                height: 24
                Text {
                    text: qsTr("Editing")
                    anchors.verticalCenter: parent.verticalCenter
                }
                ICComboBox{
                    id:editing
                    z:100
                    items: [qsTr("main"),
                        qsTr("Sub-1"),
                        qsTr("Sub-2"),
                        qsTr("Sub-3"),
                        qsTr("Sub-4"),
                        qsTr("Sub-5"),
                        qsTr("Sub-6"),
                        qsTr("Sub-7"),
                        qsTr("Sub-8")
                    ]
                    currentIndex: 0
                    onCurrentIndexChanged: {
                        if(currentIndex < 0) return;
                        programListView.model = PData.programs[currentIndex];
                        programListView.currentIndex = -1;
                    }
                }
                ICCheckBox{
                    id:isFollow
                    text: qsTr("Follow ?")
                    visible: false
                }
            }

            Row{
                id:speedDispalyContainer
                anchors.right: parent.right
                visible: false
                z:4
                spacing: 6
                ICCheckBox{
                    id:speedEn
                    text: qsTr("Speed En")
                    onVisibleChanged: {
                        isChecked = false;
                    }
                    onIsCheckedChanged: {
                        ShareData.GlobalStatusCenter.setTuneGlobalSpeedEn(isChecked);
                    }
                }

                Text {
                    text: qsTr("Speed:")
                    anchors.verticalCenter: parent.verticalCenter

                }
                Rectangle{
                    border.width: 1
                    border.color: "gray"
                    width: 70
                    height: 24
                    color: "lime"
                    Text {
                        id: speedDisplay
                        anchors.centerIn: parent
                    }
                }
                Text {
                    text: "%"
                    anchors.verticalCenter: parent.verticalCenter
                }
                onVisibleChanged: {
                    if(visible){
                        speedDisplay.text = panelRobotController.getConfigValueText("s_rw_0_16_1_294");
                    }
                }
            }

            Rectangle{
                id:programListContainer
                anchors.top: programSelecterContainer.bottom
                anchors.topMargin: 4
                //        anchors.bottom: parent.bottom
                border.width: 1
                border.color: "black"
                //                width: actionEditorFrame.visible ? container.width / 2 : container.width
                width: parent.width
                height: parent.height - programSelecterContainer.height - container.spacing
                color: "gray"
                //        visible: false
                ListModel{
                    id:mainProgramModel
                }
                ListModel{
                    id:sub1ProgramModel
                }
                ListModel{
                    id:sub2ProgramModel
                }
                ListModel{
                    id:sub3ProgramModel
                }
                ListModel{
                    id:sub4ProgramModel
                }
                ListModel{
                    id:sub5ProgramModel
                }
                ListModel{
                    id:sub6ProgramModel
                }
                ListModel{
                    id:sub7ProgramModel
                }
                ListModel{
                    id:sub8ProgramModel
                }

                ICButton{
                    id:autoEditBtn
                    function showModify(){
                        var actionObject = currentModelData().mI_ActionObject;
                        modifyEditor.openEditor(actionObject, Teach.actionObjectToEditableITems(actionObject));
                        var showY = autoEditBtn.y + autoEditBtn.height + 30;
                        if(showY + modifyEditor.height >= container.height)
                            showY = autoEditBtn.y - modifyEditor.height + 20;

                        if(showY < 0)
                            showY = 50;
                        modifyEditor.y = showY;
                    }
                    height: toolBar.height
                    width: 40
                    text: qsTr("Edit")
                    z: 1

                    anchors.right: programListView.right
                    anchors.rightMargin: 2
                    y: visible ? programListView.currentItem.y - programListView.contentY + 2 : 0
                    onYChanged: {
                        if(!autoEditBtn.visible){
                            modifyEditor.visible = false;
                            return;
                        }
                        if(modifyEditor.visible){
                            autoEditBtn.showModify();
                        }
                    }
                    onButtonClicked: autoEditBtn.showModify()

                    visible: {
                        if(programListView.currentItem == null ||
                                !ShareData.UserInfo.currentHasMoldPerm()) return false;
                        var ret =  programListView.currentItem.y >= programListView.contentY;
                        var currentItem = currentModelData();
                        if(currentItem === null) return false;
                        ret = ret && (Teach.actionObjectToEditableITems(currentItem.mI_ActionObject).length > 1);
                        return ret;
                    }
                }

                Row{
                    id:toolBar
                    //                    function updateToolBarCommand(){
                    //                        if(PData.isReadOnly)
                    //                            toolBar.visible = false;
                    //                        if(programListView.currentItem == null) toolBar.visible = false;
                    //                        toolBar.visible = ( programListView.currentItem.y >= programListView.contentY);
                    //                    }

                    function showModify(){
                        var actionObject = currentModelData().mI_ActionObject;
                        modifyEditor.openEditor(actionObject, Teach.actionObjectToEditableITems(actionObject));
                        var showY = toolBar.y + toolBar.height + 30;
                        if(showY + modifyEditor.height >= container.height)
                            showY = toolBar.y - modifyEditor.height + 20;
                        if(showY < 0){
                            showY = 50;
                        }

                        modifyEditor.y = showY;
                    }
                    z: 1
                    height: 30
                    spacing: 4
                    anchors.right: programListView.right
                    anchors.rightMargin: 2
                    y: visible ? programListView.currentItem.y - programListView.contentY + 2 : 0

                    onYChanged: {
                        if(!editBtn.visible){
                            modifyEditor.visible = false;
                            return;
                        }
                        if(modifyEditor.visible){
                            showModify();
                        }
                    }
                    visible: {
                        if(programListView.currentItem == null ||
                                PData.isReadOnly) return false;
                        return programListView.currentItem.y >= programListView.contentY;
                    }
                    ICButton{
                        id:moveUpBtn
                        height: parent.height
                        width: 40
                        text: qsTr("UP")
                        visible: {
                            return  (programListView.currentIndex > 0) && (programListView.currentIndex < programListView.count - 1)
                        }
                    }
                    ICButton{
                        id:moveDWBtn
                        height: parent.height
                        width: 40
                        text: qsTr("DW")
                        visible: {
                            return  (programListView.currentIndex < programListView.count - 2)
                        }
                    }

                    ICButton{
                        id:editBtn
                        height: parent.height
                        width: 40
                        text: qsTr("Edit")
                        onButtonClicked: {
                            actionEditorFrame.visible = false;
                            toolBar.showModify()
                        }

                        visible: {
                            var currentItem = currentModelData();
                            if(currentItem === null) return false;
                            return Teach.actionObjectToEditableITems(currentItem.mI_ActionObject).length !== 0
                        }

                    }
                    ICButton{
                        id:commentToggleBtn
                        width: 40
                        height: parent.height
                        text: qsTr("C/UC")
                        bgColor: "lime"
                        onButtonClicked: {
                            var modelObject = currentModelData();
                            if(modelObject.mI_ActionObject.action === Teach.actions.ACT_COMMENT){
                                if(modelObject.mI_ActionObject.commentAction === null)
                                    return;
                            }
                            if(modelObject.mI_ActionObject.action === Teach.actions.ACT_FLAG){
                                return;
                            }

                            if(modelObject.mI_ActionObject.action === Teach.actions.ACT_COMMENT){
                                //                                var cO = Teach.generateCommentAction(Teach.actionToString(modelObject.actionObject), modelObject.actionObject);
                                modelObject.mI_ActionObject = modelObject.mI_ActionObject.commentAction;
                            }
                            else{
                                modelObject.mI_ActionObject = Teach.generateCommentAction(Teach.actionToString(modelObject.mI_ActionObject), modelObject.mI_ActionObject);
                            }

                        }
                        visible: {
                            var modelObject = currentModelData();
                            if(modelObject === null) return false;
                            if((modelObject.mI_ActionObject.action === Teach.actions.ACT_COMMENT) &&
                                    modelObject.mI_ActionObject.commentAction == null  ) return false;
                            return (programListView.currentIndex < programListView.count - 1) &&
                                    (modelObject.mI_ActionObject.action !== Teach.actions.ACT_FLAG);
                        }
                    }
                    ICButton{
                        id:delBtn
                        height: parent.height
                        width: 40
                        text: qsTr("Del")
                        bgColor: "red"
                        visible: {
                            return programListView.currentIndex < programListView.count - 1
                        }

                    }
                }

                ListView{
                    id:programListView
                    y:2
                    //                    model: mainProgramModel
                    width: parent.width
                    height: parent.height - 2
                    spacing:2
                    clip: true
                    delegate: ProgramListItem{
                        x:1
                        width: programListView.width - x
                        //                        height: 30
                        isCurrent: ListView.isCurrentItem
                        isComment: mI_ActionObject.action === Teach.actions.ACT_COMMENT
                        isRunning: mI_IsActionRunning
                        lineNum: index
                        text: ((Teach.hasCounterIDAction(mI_ActionObject) || Teach.hasStackIDAction(mI_ActionObject)) && actionText.length !=0 ? actionText: Teach.actionToString(mI_ActionObject));

                        actionType: mI_ActionType
                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                if(!ShareData.UserInfo.currentHasMoldPerm())
                                    return;
                                programListView.currentIndex = index;
                            }
                        }
                    }

                    Timer{
                        id:refreshTimer
                        interval: 50
                        running: parent.visible
                        repeat: true
                        onTriggered: {

                            if(!panelRobotController.isAutoMode()) return;
                            // update counters show
                            var currentCounterID = panelRobotController.statusValue("c_ro_8_5_0_938");
                            var currentCounterCurrent = panelRobotController.statusValue("c_ro_13_19_0_938");
                            var counter = Teach.counterManager.getCounter(currentCounterID);
                            if(counter != null){
                                if(counter.current != currentCounterCurrent){
                                    counter.current = currentCounterCurrent;
                                    panelRobotController.saveCounterDef(counter.id, counter.name,counter.current, counter.target);
                                    onCounterUpdated(currentCounterID);

                                }
                            }

                            var cStep = currentModelStep();
                            //                            var cStep = Utils.getRandomNum(0, 10);
                            if(cStep < 0 || cStep >= currentModel().count){
                                return;
                            }
                            //                            console.log("CStep:", cStep, currentModel().count);
                            //                            var cStep = Utils.getRandomNum(0, 10);
                            var lastRunning = PData.lastRunning;

                            //                            console.log(cStep, lastRunning.model, lastRunning.step, lastRunning.items)
                            if(editing.currentIndex !== lastRunning.model ||
                                    cStep !== lastRunning.step)
                            {
                                var i;
                                var lastModel = PData.programs[lastRunning.model];
                                var setStopObject = {"mI_IsActionRunning":false};
                                for(i = 0; i < lastRunning.items.length; ++i){
                                    lastModel.set(lastRunning.items[i], setStopObject);
                                }

                                var cRunning = {"model":editing.currentIndex,"step":cStep};
                                var cModel = currentModel();
                                var uiRunningSteps = currentModelRunningActionInfo();
                                //                                var uiRunningSteps = panelRobotController.hostStepToUILines(editing.currentIndex, cStep);
                                var setRunningObject = {"mI_IsActionRunning":true};
                                for(i = 0; i < uiRunningSteps.length; ++i){
                                    cModel.set(uiRunningSteps[i], setRunningObject);
                                }
                                cRunning.items = uiRunningSteps;
                                //                                console.log(cRunning.items)
                                PData.lastRunning = cRunning;
                                if(isFollow.isChecked)
                                    programListView.positionViewAtIndex(uiRunningSteps[0], ListView.Center );


                            }

                        }
                    }

                }

            }
        }
        Rectangle{
            id:actionEditorFrame
            //            visible: false
            width: container.width
            height: container.height / 2
            //            y:2
            x:2

            //            anchors.left: programViewContainer.right
            //            anchors.right: container.right
            border.width: 1
            border.color: "black"
            ICButton{
                id:insertBtn
                x:4
                y:4
                width: 80
                height: 32
                text: qsTr("Insert")
                bgColor: "yellow"
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
                x:insertBtn.x
                y: 176
                width: insertBtn.width
                height: insertBtn.height
                text: qsTr("Menu")
                bgColor: "lime"
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
                function showMenu() {
                    setCurrentIndex(0);
                    linkedBtn1.visible = false;
                    linkedBtn2.visible = false;
                    linkedBtn3.visible = false;
                }
                //                function showAxis() { setCurrentIndex(1);}
                //                function showOutput() { setCurrentIndex(2);}
                function isMenuShow() { return currentIndex == 0;}
                id:actionEditorContainer
                width: parent.width - insertBtn.width - anchors.leftMargin - splitLine.width -splitLine.anchors.leftMargin
                height: parent.height - 1
                anchors.left: insertBtn.right
                anchors.leftMargin: 10
            }
            Component.onCompleted: {
                var editor = Qt.createComponent('ProgramActionMenu.qml');
                var actionMenuObject = editor.createObject(actionEditorContainer);
                editor = Qt.createComponent('AxisActionEditor.qml');
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


                actionEditorContainer.showMenu();
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
                    PData.linked1Function = actionMenuObject.pathMenuTriggered;

                    linkedBtn2.text = qsTr("Wait");
                    linkedBtn2.visible = true;
                    PData.linked2Function = actionMenuObject.waitMenuTriggered;

                    linkedBtn3.text = qsTr("Condition")
                    linkedBtn3.visible = true;
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
                    PData.linked3Function = actionMenuObject.conditionMenuTriggered;
                });
                actionMenuObject.customAlarmMenuTriggered.connect(function(){
                    actionEditorContainer.setCurrentIndex(12);
                    linkedBtn1.visible = false;
                    linkedBtn2.visible = false;
                    linkedBtn3.visible = false;
                });

                //                axisEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);
                //                outputEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);
                //                waitEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);
                //                checkEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);
                //                conditionEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);
                //                syncEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);
                //                commentEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);
                //                searchEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);

                actionMenuBtn.buttonClicked.connect(actionEditorContainer.showMenu);
                insertBtn.buttonClicked.connect(onInsertTriggered);


            }
        }
    }

    ICDialog{
        id:tipBox
        anchors.centerIn: container
        z: 100
    }
    ActionModifyEditor{
        id:modifyEditor
        z:3
        x: 10

    }

    //TODO:Use WorkerScript to implement this function
    function repaintProgramItem(programModel, start, end){
        var l = programModel.count;
        start = start || 0;
        end = end || l;

        if(start >= l || end > l)
            return;
        var step;
        var at;
        var isSyncStart = false;
        for(var i = start; i < end; ++i){
            step = programModel.get(i).mI_ActionObject;
            if(step.action === Teach.actions.F_CMD_SYNC_START){
                at = Teach.actionTypes.kAT_SyncStart;
                isSyncStart = true;
            }
            else if(step.action === Teach.actions.F_CMD_SYNC_END){
                at = Teach.actionTypes.kAT_SyncEnd;
                isSyncStart = false;
            }
            else
                at = Teach.actionTypes.kAT_Normal;
            if(isSyncStart)
                at = Teach.actionTypes.kAT_SyncStart;
            programModel.setProperty(i, "mI_ActionType", at);
        }
    }

    function collectSpecialLines(which){
        var program = PData.programs[which];
        PData.counterLinesInfo.clear(which);
        PData.stackLinesInfo.clear(which);
        var step;
        for(var i = 0; i < program.count; ++i){
            step = program.get(i);
            if(Teach.hasCounterIDAction(step.mI_ActionObject)){
                var cs = Teach.actionCounterIDs(step.mI_ActionObject);
                for(var c in cs){
                    PData.counterLinesInfo.add(which, cs[c], i);
                }

            }
            if(Teach.hasStackIDAction(step.mI_ActionObject)){
                PData.stackLinesInfo.add(which, step.mI_ActionObject.stackID, i);
            }
        }
    }

    function updateProgramModels(){
        //        PData.counterLinesInfo.clear();
        editing.currentIndex = -1;
        var counters = JSON.parse(panelRobotController.counterDefs());
        Teach.counterManager.init(counters);
        Teach.parseStacks(panelRobotController.stacks());
        var program = JSON.parse(panelRobotController.mainProgram());
        var i,j;
        var step;
        var at;
        var isSyncStart = false;
        Teach.definedPoints.clear();
        for(i = 0; i < 9; ++i){
            PData.programs[i].clear();
            program = JSON.parse(panelRobotController.programs(i));
            var jumpLines = [];
            for(var p = 0; p < program.length; ++p){
                step = program[p]
                if(Teach.canActionUsePoint(step)){
                    Teach.definedPoints.parseActionPoints(step);
                }
                if(step.action === Teach.actions.ACT_FLAG){
                    Teach.pushFlag(step.flag, step.comment);
                }else if(step.action === Teach.actions.F_CMD_SYNC_START){
                    at = Teach.actionTypes.kAT_SyncStart;
                    isSyncStart = true;
                }else if(step.action === Teach.actions.F_CMD_SYNC_END){
                    at = Teach.actionTypes.kAT_SyncEnd;
                    isSyncStart = false;
                }else if(Teach.isJumpAction(step.action)){
                    jumpLines.push(p);
                    at = Teach.actionTypes.kAT_Normal;
                }
                else
                    at = Teach.actionTypes.kAT_Normal;
                if(isSyncStart)
                    at = Teach.actionTypes.kAT_SyncStart;

                PData.programs[i].append(new Teach.ProgramModelItem(step, at));
            }
            for(var l = 0; l < jumpLines.length; ++l){
                step = program[jumpLines[l]];
                PData.programs[i].set(jumpLines[l], {"mI_ActionObject":step, "mI_IsActionRunning": true});
                PData.programs[i].set(jumpLines[l], {"mI_ActionObject":step, "mI_IsActionRunning": false});
            }
            collectSpecialLines(i);
        }
        editing.currentIndex = 0;

    }

    onVisibleChanged: {
        actionEditorFrame.visible = false;
        programListView.currentIndex = -1;
        //        programListView.contentY = 0;
    }

    Component.onCompleted: {
        //        Teach.parseStacks(panelRobotController.stacks());
        ShareData.GlobalStatusCenter.registeGlobalSpeedChangedEvent(programFlowPageInstance);
        PData.programs.push(mainProgramModel);
        PData.programs.push(sub1ProgramModel);
        PData.programs.push(sub2ProgramModel);
        PData.programs.push(sub3ProgramModel);
        PData.programs.push(sub4ProgramModel);
        PData.programs.push(sub5ProgramModel);
        PData.programs.push(sub6ProgramModel);
        PData.programs.push(sub7ProgramModel);
        PData.programs.push(sub8ProgramModel);


        updateProgramModels();
        panelRobotController.moldChanged.connect(updateProgramModels);
        modifyEditor.editConfirm.connect(onEditConfirm);
        delBtn.buttonClicked.connect(onDeleteTriggered);
        moveUpBtn.buttonClicked.connect(onUpTriggered);
        moveDWBtn.buttonClicked.connect(onDownTriggered);

        ShareData.UserInfo.registUserChangeEvent(programFlowPageInstance);
        ShareData.GlobalStatusCenter.registeKnobChangedEvent(programFlowPageInstance);
    }

}
