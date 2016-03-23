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
import "ManualProgramManager.js" as ManualProgramManager


Rectangle {
    id:programFlowPageInstance
    property alias isActionEditorPanelVisable: actionEditorFrame.visible
    property bool hasInit: false
    property int currentEditingProgram: 0
    property int currentEditingModule: 0
    property bool hasModify: false
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

    function insertActionToList(actionObject){
        var cI = programListView.currentIndex;
        var oCI = cI;
        if(cI < 0)return;

        actionObject.insertedIndex = PData.programToInsertIndex[currentProgramIndex()]++;
        var cPI = currentProgramIndex();
        var model = currentModel();
        PData.counterLinesInfo.syncLines(cPI, oCI, 1);
        PData.stackLinesInfo.syncLines(cPI, oCI, 1);
        PData.pointLinesInfo.syncLines(cPI, oCI, 1);
        if(actionObject.action === Teach.actions.ACT_FLAG){
            //                Teach.pushFlag(actionObjects[i].flag, actionObjects[i].comment);
            Teach.flagsDefine.pushFlag(editing.currentIndex, new Teach.FlagItem(actionObject.flag, actionObject.comment));
        }
        if(Teach.hasCounterIDAction(actionObject)){
            var cs = Teach.actionCounterIDs(actionObject);
            for(var c in cs){
                PData.counterLinesInfo.add(cPI, cs[c], cI);
            }
        }
        if(Teach.hasStackIDAction(actionObject)){
            PData.stackLinesInfo.add(cPI, actionObject.stackID, cI);
        }
        if(Teach.canActionUsePoint(actionObject)){
            var points = Teach.definedPoints.parseActionPointsHelper(actionObject);
            for(var p = 0; p < points.length; ++p){
                PData.pointLinesInfo.add(cPI, points[p].index, cI);
            }
        }

        model.insert(cI++, new Teach.ProgramModelItem(actionObject, Teach.actionTypes.kAT_Normal));

        hasModify = true;
        //        repaintProgramItem(model);
    }

    function onInsertTriggered(){
        if(actionEditorContainer.isMenuShow()) return;
        var actionObjects = actionEditorContainer.currentPage().createActionObjects();
        if(actionObjects.length == 0) return;
        for(var i = 0; i < actionObjects.length; ++i){
            insertActionToList(actionObjects[i]);
        }
        repaintProgramItem(currentModel());
        programListView.positionViewAtIndex(programListView.currentIndex, ListView.Visible);
        //        var cI = programListView.currentIndex;
        //        var oCI = cI;
        //        if(cI < 0)return;
        //        if(actionEditorContainer.isMenuShow()) return;
        //        var actionObjects = actionEditorContainer.currentPage().createActionObjects();
        //        if(actionObjects.length == 0) return;
        //        var cPI = currentProgramIndex();
        //        var model = currentModel();
        //        PData.counterLinesInfo.syncLines(cPI, oCI, actionObjects.length);
        //        PData.stackLinesInfo.syncLines(cPI, oCI, actionObjects.length);
        //        for(var i = 0; i < actionObjects.length; ++i){
        //            if(actionObjects[i].action === Teach.actions.ACT_FLAG){
        //                //                Teach.pushFlag(actionObjects[i].flag, actionObjects[i].comment);
        //                Teach.flagsDefine.pushFlag(editing.currentIndex, new Teach.FlagItem(actionObjects[i].flag, actionObjects[i].comment));
        //            }else if(Teach.hasCounterIDAction(actionObjects[i])){
        //                var cs = Teach.actionCounterIDs(actionObjects[i]);
        //                for(var c in cs){
        //                    PData.counterLinesInfo.add(cPI, cs[c], cI);
        //                }
        //            }else if(Teach.hasStackIDAction(actionObjects[i])){
        //                PData.stackLinesInfo.add(cPI, actionObjects[i].stackID, cI);
        //            }

        //            model.insert(cI++, new Teach.ProgramModelItem(actionObjects[i], Teach.actionTypes.kAT_Normal));
        //        }
        //        hasModify = true;
        //        repaintProgramItem(model);
    }

    function onDeleteTriggered(){
        var cI = programListView.currentIndex;
        var oCI = cI;
        if(cI < 0)return;
        var model = currentModel();
        if(cI >= model.count - 1) return;
        var cPI = currentProgramIndex();
        var actionObject = model.get(cI).mI_ActionObject;
        if(actionObject.action === Teach.actions.ACT_FLAG){
            Teach.flagsDefine.delFlag(editing.currentIndex, actionObject.flag);
        }
        if(Teach.hasCounterIDAction(actionObject)){
            var cs = Teach.actionCounterIDs(actionObject);
            for(var c in cs){
                PData.counterLinesInfo.removeIDLine(cPI, cs[c], cI);
            }
        }
        if(Teach.hasStackIDAction(actionObject)){
            PData.stackLinesInfo.removeIDLine(cPI, actionObject.stackID, cI);
        }
        if(Teach.canActionUsePoint(actionObject)){
            var points = Teach.definedPoints.parseActionPointsHelper(actionObject);
            for(var p = 0; p < points.length; ++p){
                PData.pointLinesInfo.removeIDLine(cPI, points[p].index, cI);
            }
        }

        model.remove(cI);
        PData.counterLinesInfo.syncLines(cPI, oCI, -1);
        PData.stackLinesInfo.syncLines(cPI, oCI, -1);
        PData.pointLinesInfo.syncLines(cPI, oCI, -1);
        hasModify = true;
        repaintProgramItem(model);
    }

    function findSyncStart(endPos){
        var cM = currentModel();
        while(endPos > 0){
            if(cM.get(endPos).mI_ActionObject.action == Teach.actions.F_CMD_SYNC_START)
                return endPos;
            --endPos;
        }
        return endPos;
    }

    function onUpTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 1)return;
        var model = currentModel();
        if(cI >= model.count - 1) return;
        hasModify = true;
        var cIAction = model.get(cI).mI_ActionObject;
        var cIPAction = model.get(cI - 1).mI_ActionObject;
        var cPI = currentProgramIndex();

        var cs;
        var c;
        if(Teach.hasCounterIDAction(cIAction)){
            cs = Teach.actionCounterIDs(cIAction);
            for(c in cs){
                PData.counterLinesInfo.removeIDLine(cPI, cs[c], cI);
                PData.counterLinesInfo.add(cPI, cs[c], cI - 1);
            }
        }
        if(Teach.hasStackIDAction(cIAction)){
            PData.stackLinesInfo.removeIDLine(cPI, cIAction.stackID, cI);
            PData.stackLinesInfo.add(cPI, cIAction.stackID, cI - 1);
        }
        var points;
        var p;
        if(Teach.canActionUsePoint(cIAction)){
            points = Teach.definedPoints.parseActionPointsHelper(cIAction);
            for(p = 0; p < points.length; ++p){
                PData.pointLinesInfo.removeIDLine(cPI, points[p].index, cI);
                PData.pointLinesInfo.add(cPI, points[p].index, cI - 1);
            }
        }

        if(Teach.hasCounterIDAction(cIPAction)){
            cs = Teach.actionCounterIDs(cIPAction);
            for(c in cs){
                PData.counterLinesInfo.removeIDLine(cPI, cs[c], cI - 1);
                PData.counterLinesInfo.add(cPI, cs[c], cI);
            }
        }
        if(Teach.hasStackIDAction(cIPAction)){
            PData.stackLinesInfo.removeIDLine(cPI, cIPAction.stackID, cI - 1);
            PData.stackLinesInfo.add(cPI, cIPAction.stackID, cI);
        }
        if(Teach.canActionUsePoint(cIPAction)){
            points = Teach.definedPoints.parseActionPointsHelper(cIPAction);
            for(p = 0; p < points.length; ++p){
                PData.pointLinesInfo.removeIDLine(cPI, points[p].index, cI - 1);
                PData.pointLinesInfo.add(cPI, points[p].index, cI);
            }
        }

        model.move(cI, cI -1, 1);
        repaintProgramItem(model);
    }

    function onDownTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 0)return;
        var model = currentModel();
        if(cI >= model.count - 2) return;
        hasModify = true;
        var cIAction = currentModelData().mI_ActionObject;
        var cINAction = model.get(cI + 1).mI_ActionObject;
        var cPI = currentProgramIndex();

        var cs;
        var c;
        if(Teach.hasCounterIDAction(cIAction)){
            cs = Teach.actionCounterIDs(cIAction);
            for(c in cs){
                PData.counterLinesInfo.removeIDLine(cPI, cs[c], cI);
                PData.counterLinesInfo.add(cPI, cs[c], cI + 1);
            }
        }
        if(Teach.hasStackIDAction(cIAction)){
            PData.stackLinesInfo.removeIDLine(cPI, cIAction.stackID, cI);
            PData.stackLinesInfo.add(cPI, cIAction.stackID, cI + 1);
        }
        var points;
        var p;
        if(Teach.canActionUsePoint(cIAction)){
            points = Teach.definedPoints.parseActionPointsHelper(cIAction);
            for(p = 0; p < points.length; ++p){
                PData.pointLinesInfo.removeIDLine(cPI, points[p].index, cI);
                PData.pointLinesInfo.add(cPI, points[p].index, cI + 1);
            }
        }

        if(Teach.hasCounterIDAction(cINAction)){
            cs = Teach.actionCounterIDs(cINAction);
            for(c in cs){
                PData.counterLinesInfo.removeIDLine(cPI, cs[c], cI + 1);
                PData.counterLinesInfo.add(cPI, cs[c], cI);
            }
        }
        if(Teach.hasStackIDAction(cINAction)){
            PData.stackLinesInfo.removeIDLine(cPI, cINAction.stackID, cI + 1);
            PData.stackLinesInfo.add(cPI, cINAction.stackID, cI);
        }
        if(Teach.canActionUsePoint(cINAction)){
            points = Teach.definedPoints.parseActionPointsHelper(cINAction);
            for(p = 0; p < points.length; ++p){
                PData.pointLinesInfo.removeIDLine(cPI, points[p].index, cI + 1);
                PData.pointLinesInfo.add(cPI, points[p].index, cI);
            }
        }


        model.move(cI, cI  + 1, 1);
        repaintProgramItem(model);

    }

    function onEditConfirm(actionObject){
        //        currentModelData().mI_ActionObject = actionObject;
        var cM = currentModel();
        cM.setProperty(programListView.currentIndex, "mI_ActionObject", actionObject);
        if(ShareData.GlobalStatusCenter.getKnobStatus() === Keymap.KNOB_AUTO){
            var mID = moduleSel.currentIndex == 0 ? -1: Utils.getValueFromBrackets(moduleSel.currentText());
            if(panelRobotController.fixProgramOnAutoMode(editing.currentIndex,
                                                         mID,
                                                         programListView.currentIndex,
                                                         JSON.stringify(actionObject))){
                if(mID >=0){
                    saveModules();
                }else if(editing.currentIndex === 0)
                    panelRobotController.saveMainProgram(modelToProgram(0));
                else
                    panelRobotController.saveSubProgram(modelToProgram(editing.currentIndex));
            }
        }
        hasModify = true;
    }

    function updatePointsHelper(md, lines, point){
        var line;
        var tmp;
        for(var l in lines){
            line = lines[l];
            tmp = md.get(line);
            var actionObject = tmp.mI_ActionObject;
            var originpPoints = actionObject.points;
            for(var p = 0; p < originpPoints.length; ++p){
                if(point.index == Teach.definedPoints.extractPointIDFromPointName(originpPoints[p].pointName)){
                    actionObject.points[p].pos = point.point;
                }
            }
            md.setProperty(line, "mI_ActionObject",actionObject);
        }
    }

    function onPointChanged(point){
//        var cpI = currentProgramIndex();
        var pointLines;
        var md;
        var i;

        // module points execute
        if(moduleSel.currentIndex > 0)
            saveModules();
        var modulesNames = moduleSel.items;
        for(i = 1; i < modulesNames.length; ++i){
            updateProgramModel(functionsModel, Teach.functionManager.getFunctionByName(moduleSel.text(i)).program);
            collectSpecialLines(PData.kFunctionProgramIndex);
            pointLines = PData.pointLinesInfo.getLines(PData.kFunctionProgramIndex, point.index);
            md = functionsModel;
            if(pointLines.length > 0 ){
                updatePointsHelper(md, pointLines, point);
                saveModuleByName(modulesNames[i], false);
            }
        }
        if(moduleSel.currentIndex > 0){
            updateProgramModel(functionsModel, Teach.functionManager.getFunctionByName(moduleSel.currentText()).program);
            collectSpecialLines(PData.kFunctionProgramIndex);
        }

        // program execute
        for(i = 0; i < PData.kFunctionProgramIndex; ++i){
            pointLines = PData.pointLinesInfo.getLines(i, point.index);
            md = PData.programs[i];
            if(pointLines.length > 0){
                updatePointsHelper(md, pointLines, point);
                hasModify = true;
                saveProgram(i);
            }
        }
    }

    function modelToProgramHelper(which){
        var model = PData.programs[which];
        var ret = [];
        for(var i = 0; i < model.count; ++i){
            ret.push(model.get(i).mI_ActionObject);
        }
        return ret;
    }

    function modelToProgram(which){
        var ret = modelToProgramHelper(which);
        return JSON.stringify(ret);
    }

    function saveModuleByName(name, syncMold){
        var fun = Teach.functionManager.getFunctionByName(name);
        if(fun == null) return;
        fun.program = modelToProgramHelper(PData.kFunctionProgramIndex);
        var fJSON = Teach.functionManager.toJSON();
        var eIJSON = panelRobotController.saveFunctions(fJSON, syncMold);
        var errInfo = JSON.parse(eIJSON)[fun.id];
        return errInfo;
    }

    function saveModules(){
        return saveModuleByName(moduleSel.text(currentEditingModule), true);
    }

    function saveProgram(which){
        if(!hasInit) return;
        if(!hasModify) return;
        var errInfo;
        if(which == PData.kFunctionProgramIndex){
            errInfo = saveModules();
            //            var fun = Teach.functionManager.getFunctionByName(moduleSel.text(currentEditingModule));
            //            if(fun == null) return;
            //            fun.program = modelToProgramHelper(PData.kFunctionProgramIndex);
            //            var fJSON = Teach.functionManager.toJSON();
            //            var eIJSON = panelRobotController.saveFunctions(fJSON);
            //            errInfo = JSON.parse(eIJSON)[fun.id];
            //            console.log(eIJSON);
        }else if(which == PData.kManualProgramIndex){
            var program = modelToProgramHelper(PData.kManualProgramIndex);
            errInfo = JSON.parse(panelRobotController.checkProgram(JSON.stringify(program), "","","", ""));
            if(errInfo.length == 0)
                ManualProgramManager.manualProgramManager.updateProgramByName(editing.text(editing.currentIndex), program);
        }else if(which == 0){
            errInfo = JSON.parse(panelRobotController.saveMainProgram(modelToProgram(0)));
            if(errInfo.length === 0){
                panelRobotController.sendMainProgramToHost();
            }
        }else{
            errInfo = JSON.parse(panelRobotController.saveSubProgram(which, modelToProgram(which)));
            if(errInfo.length === 0){
                panelRobotController.sendSubProgramToHost(which);
            }
        }
        if(errInfo.length !== 0){
            var toShow = "";
            for(var i = 0; i < errInfo.length; ++i){
                toShow += qsTr("Line") + errInfo[i].line + ":" + Teach.ccErrnoToString(errInfo[i].errno) + "\n";
            }
            tipBox.warning(toShow, qsTr("OK"));
        }
        //        collectSpecialLines(editing.currentIndex);
        var programStr = which == 0 ? qsTr("Main Program") : ICString.icStrformat(qsTr("Sub-{0} Program"), which);
        ICOperationLog.opLog.appendOperationLog(ICString.icStrformat(qsTr("Save {0} of Record:{1}"), programStr, panelRobotController.currentRecordName()));
        hasModify = false;
    }

    function onFixIndexTriggered(){
        var cM = currentModel();
        var ao;
        for(var i = 0; i < cM.count; ++i){
            ao = cM.get(i).mI_ActionObject;
            ao.insertedIndex = i;
            cM.setProperty(i, "mI_ActionObject", ao);
        }
        PData.programToInsertIndex[currentProgramIndex()] = i;
    }

    function onSaveTriggered(){
        hasModify = true;
        saveProgram(currentProgramIndex());
    }

    function currentModel(){
        return PData.programs[currentProgramIndex()];
    }

    function currentProgramIndex(){
        if(PData.programs.length == 0) return 0;
        if(moduleSel.currentIndex != 0) return PData.kFunctionProgramIndex;
        if(editing.currentIndex > 8) return PData.kManualProgramIndex;
        return editing.currentIndex;
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
        //                console.log(ret);
        var info = JSON.parse(ret);
        info.steps = JSON.parse(info.steps);
        //        if(info.moduleID >= 0)
        //            console.log(ret);
        return info;
    }

    function setModuleEnabled(en){
        newModuleBtn.visible = en;
        delModuleBtn.visible = en && (moduleSel.currentIndex != 0);
    }

    function setManualProgramEnabled(en){
        newManualProgram.visible = en;
        deleteManualProgram = en && (editing.currentIndex > 8);
    }

    function onUserChanged(user){
        PData.isReadOnly = ( (ShareData.GlobalStatusCenter.getKnobStatus() === Keymap.KNOB_AUTO) || !ShareData.UserInfo.currentHasMoldPerm());
        //        if(!ShareData.UserInfo.currentHasMoldPerm())
        programListView.currentIndex = -1;
        setModuleEnabled(!PData.isReadOnly);
        setManualProgramEnabled(!PData.isReadOnly);
    }

    function onKnobChanged(knobStatus){
        onUserChanged(null);
        var isAuto = (knobStatus === Keymap.KNOB_AUTO);
        autoKeyboard.visible = isAuto;
        if(isAuto){
            singleCycle.setChecked(false);
            singleStep.setChecked(false);
        }

        editing.resetProgramItems(isAuto)
        isFollow.visible = isAuto;
        modifyEditor.isAutoMode = isAuto;
        actionEditorFrame.visible = false;
        speedDispalyContainer.visible = isAuto;
        //        setModuleEnabled(!isAuto);
        if(hasModify)
            onSaveTriggered();
    }

    function onStackUpdated(stackID){
        var cpI = currentProgramIndex();
        var stackLines = PData.stackLinesInfo.getLines(cpI, stackID)
        var md = currentModel();
        var tmp;
        var line;
        var si = Teach.getStackInfoFromID(stackID);
        var c1 = si.si0.doesBindingCounter ? si.si0.counterID : -1;
        var c2 = ((si.si1.doesBindingCounter) && (si.type == Teach.stackTypes.kST_Box)) ? si.si1.counterID : -1;
        for(var l in stackLines){
            line = stackLines[l];
            tmp = md.get(line);
            md.set(line, {"actionText":programListView.actionObjectToText(tmp.mI_ActionObject)});
            PData.counterLinesInfo.removeLine(cpI, line);
            if(c1 >= 0)
                PData.counterLinesInfo.add(cpI, c1, line);
            if(c2 >= 0)
                PData.counterLinesInfo.add(cpI, c2, line);
        }
        //        collectSpecialLines(editing.currentIndex);
    }

    function onCounterUpdated(counterID){
        var cpI = currentProgramIndex();
        var counterLines  = PData.counterLinesInfo.getLines(cpI,counterID);
        var md = currentModel();
        var tmp;
        var line;
        for(var l in counterLines){
            line = counterLines[l];
            tmp = md.get(line);
            md.set(line, {"actionText":programListView.actionObjectToText(tmp.mI_ActionObject)});

        }
    }

    function onGlobalSpeedChanged(spd){
        speedDisplay.text = parseFloat(spd).toFixed(1);
    }

    //    function setCurrentModelData(actionObject){
    //        currentModel().set(programListView.currentIndex,
    //                           new Teach.ProgramModelItem(actionObject));
    //    }

    //    WorkerScript{
    //        id:repaintThread
    //        source: "repaintProgram.js"
    //        onMessage: {
    //            var toRepainLine = messageObject.toRepainLine;
    //            var cM = currentModel();
    //            for(var line in toRepainLine){
    //                console.log(line, toRepainLine[line]);
    ////                cM.setProperty(line, "mI_ActionType", toRepainLine[line]);
    //            }
    //        }
    //    }

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
                    popupHeight: 350
                    property variant defaultPrograms: [qsTr("main"),
                        qsTr("Sub-1"),
                        qsTr("Sub-2"),
                        qsTr("Sub-3"),
                        qsTr("Sub-4"),
                        qsTr("Sub-5"),
                        qsTr("Sub-6"),
                        qsTr("Sub-7"),
                        qsTr("Sub-8")
                    ]
                    function resetProgramItems(isAutoMode){
                        if(isAutoMode)
                            items = defaultPrograms;
                        else
                            items = defaultPrograms.concat(ManualProgramManager.manualProgramManager.programsNameList());
                    }

                    items:defaultPrograms
                    currentIndex: 0
                    onCurrentIndexChanged: {
                        //                        console.log("onCurrentIndexChanged", currentIndex);

                        deleteManualProgram.visible = false;
                        if(currentIndex > 8){
                            saveProgram(currentEditingProgram);
                            deleteManualProgram.visible = newManualProgram.visible;
                            PData.programToInsertIndex[PData.kManualProgramIndex] = updateProgramModel(manualProgramModel, ManualProgramManager.manualProgramManager.getProgramByName(editing.text(currentIndex)).program);
                            programListView.model = manualProgramModel;
                            programListView.currentIndex = -1;
                            currentEditingProgram = PData.kManualProgramIndex;
                            PData.currentEditingProgram = PData.kManualProgramIndex;
                            Teach.currentParsingProgram = PData.kManualProgramIndex;

                        }else{
                            if(panelRobotController.isAutoMode()){
                                singleStep.setChecked(false);
                                singleCycle.setChecked(false);
                            }

                            PData.currentEditingProgram = currentIndex;
                            Teach.currentParsingProgram = currentIndex;
                            if(currentIndex < 0) return;
                            if(moduleSel.currentIndex != 0){
                                moduleSel.currentIndex = 0;
                            }else{
                                saveProgram(currentEditingProgram);
                                programListView.model = PData.programs[currentIndex];
                                programListView.currentIndex = -1;
                                currentEditingProgram = currentIndex;
                            }
                        }
                    }
                }
                ICButton{
                    id:newManualProgram
                    text: qsTr("New M CMD")
                    visible: newModuleBtn.visible
                    height: editing.height
                    font.pixelSize: 14
                    function onNewManualProgram(status){
                        tipBox.finished.disconnect(newManualProgram.onNewManualProgram);
                        if(status){
                            var toAdd = ManualProgramManager.manualProgramManager.addProgram(tipBox.inputText, [Teach.generteEndAction()]);
                            editing.resetProgramItems();
                        }
                    }


                    onButtonClicked: {
                        tipBox.showInput(qsTr("Please Input the new program Name"),
                                         qsTr("Program Name:"),
                                         false,
                                         qsTr("OK"),
                                         qsTr("Cancel"));
                        tipBox.finished.connect(newManualProgram.onNewManualProgram);

                    }

                }
                ICButton{
                    id:deleteManualProgram
                    text: qsTr("Del M CMD")
                    height: editing.height
                    visible: false
                    font.pixelSize: 14
                    onButtonClicked: {
                        ManualProgramManager.manualProgramManager.removeProgramByName(editing.currentText());
                        editing.currentIndex = 0;
                        editing.resetProgramItems();
                    }
                }

                ICComboBox{
                    id: moduleSel
                    z:editing.z - 1
                    width: 140
                    items: [qsTr("Main Module")]
                    currentIndex: 0

                    function setCurrentModule(moduleID){
                        if(moduleID < 0)
                            currentIndex = 0;
                        else{
                            var mItems = moduleSel.items;
                            var toFind = "[" + moduleID +"]";
                            for(var i = 0; i < mItems.length; ++i){
                                var index = mItems[i].indexOf(toFind);
                                if(index >= 0){
                                    currentIndex = i;
                                    break;
                                }
                            }
                        }
                    }

                    onCurrentIndexChanged: {
                        saveProgram(currentEditingProgram);
                        if(currentIndex < 0) return;
                        if(currentIndex == 0){
                            programListView.currentIndex = -1;
                            programListView.model = PData.programs[editing.currentIndex];
                            currentEditingProgram = editing.currentIndex;
                            currentEditingModule = 0;
                            delModuleBtn.visible = false;
                            if(PData.programActionMenu != null)
                                PData.programActionMenu.state = "";
                        }else{
                            PData.programToInsertIndex[PData.kFunctionProgramIndex] = updateProgramModel(functionsModel, Teach.functionManager.getFunctionByName(moduleSel.currentText()).program);
                            collectSpecialLines(PData.kFunctionProgramIndex);
                            programListView.currentIndex = -1;
                            programListView.model = functionsModel;
                            currentEditingProgram = PData.kFunctionProgramIndex
                            currentEditingModule = moduleSel.currentIndex;
                            delModuleBtn.visible = newModuleBtn.visible;
                            PData.programActionMenu.state = "moduleEditMode";
                            actionMenuBtn.clicked();
                        }
                    }
                }

                ICButton{
                    id:newModuleBtn
                    text: qsTr("New Module")
                    height: editing.height
                    function newModule(status){
                        tipBox.finished.disconnect(newModuleBtn.newModule);
                        if(status){
                            var newP = Teach.functionManager.newFunction(tipBox.inputText);
                            var modulesNames = moduleSel.items;
                            modulesNames.splice(1,0, newP.toString());
                            PData.programToInsertIndex[PData.kFunctionProgramIndex] = updateProgramModel(functionsModel, newP.program);
                            moduleSel.items = modulesNames;
                            moduleSel.currentIndex = 1;
                            collectSpecialLines(PData.programs.length - 1);
                            programListView.currentIndex = -1;
                            programListView.model = functionsModel;
                        }
                    }

                    onButtonClicked: {
                        tipBox.showInput(qsTr("Please Input the new module Name"),
                                         qsTr("Module Name:"),
                                         false,
                                         qsTr("OK"),
                                         qsTr("Cancel"));
                        tipBox.finished.connect(newModuleBtn.newModule);
                    }
                }

                ICButton{
                    id:delModuleBtn
                    text: qsTr("Del Module")
                    height: editing.height
                    onButtonClicked: {
                        var toDelID = Utils.getValueFromBrackets(moduleSel.currentText());
                        Teach.functionManager.delFunction(toDelID);
                        var ci = moduleSel.currentIndex;
                        var funs = moduleSel.items;
                        moduleSel.currentIndex = 0;
                        funs.splice(ci, 1);
                        moduleSel.items = funs;
                        panelRobotController.saveFunctions(Teach.functionManager.toJSON());
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
                border.width: 1
                border.color: "black"
                width: parent.width
                height: parent.height - programSelecterContainer.height - container.spacing
                color: "gray"
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
                ListModel{
                    id:functionsModel
                }
                ListModel{
                    id:manualProgramModel
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
                        id:tryRunBtn
                        height: parent.height
                        width: 40
                        text: qsTr("Run")
                        visible: {
                            var currentItem = currentModelData();
                            if(currentItem === null) return false;
                            return Teach.canActionTestRun(currentItem.mI_ActionObject);
                        }
                        function actionPointToLogPoint(pos){
                            return  JSON.stringify([pos.m0 || 0.000,
                                                    pos.m1 || 0.000,
                                                    pos.m2 || 0.000,
                                                    pos.m3 || 0.000,
                                                    pos.m4 || 0.000,
                                                    pos.m5 || 0.000]);
                        }

                        function getCurrentPoint(){
                            return  ([panelRobotController.statusValueText("c_ro_0_32_3_900"),
                                      panelRobotController.statusValueText("c_ro_0_32_3_904"),
                                      panelRobotController.statusValueText("c_ro_0_32_3_908"),
                                      panelRobotController.statusValueText("c_ro_0_32_3_912"),
                                      panelRobotController.statusValueText("c_ro_0_32_3_916"),
                                      panelRobotController.statusValueText("c_ro_0_32_3_920")]);
                        }

                        function getCurrentPointToLogPoint(){
                            return  JSON.stringify(tryRunBtn.getCurrentPoint());
                        }

                        onBtnPressed: {
                            console.log("Run")
                            if(panelRobotController.isOrigined()){
                                var ao = currentModelData().mI_ActionObject;
                                if(ao.action === Teach.actions.F_CMD_LINE3D_MOVE_POINT){
                                    panelRobotController.logTestPoint(Keymap.kTP_TEACH_LINE_START_POINT, tryRunBtn.actionPointToLogPoint(ao.points[0].pos));
                                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEACH_LINT_TO_START_POINT);
                                }else if(ao.action === Teach.actions.F_CMD_ARC3D_MOVE_POINT){
                                    panelRobotController.logTestPoint(Keymap.kTP_TEACH_ARC_START_POINT, tryRunBtn.getCurrentPointToLogPoint());
                                    panelRobotController.logTestPoint(Keymap.kTP_TEACH_ARC_MID_POINT, tryRunBtn.actionPointToLogPoint(ao.points[0].pos));
                                    panelRobotController.logTestPoint(Keymap.kTP_TEACH_ARC_END_POINT, tryRunBtn.actionPointToLogPoint(ao.points[1].pos));
                                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEACH_ARC_TO_START_POINT);
                                }else if(ao.action === Teach.actions.F_CMD_JOINTCOORDINATE){
                                    panelRobotController.logTestPoint(Keymap.kTP_TEACH_AUTO_START_POINT, tryRunBtn.actionPointToLogPoint(ao.points[0].pos));
                                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEACH_AUTO_TO_START_POINT);
                                }else if(ao.action === Teach.actions.F_CMD_COORDINATE_DEVIATION){
                                    panelRobotController.logTestPoint(Keymap.kTP_TEACH_RELATIVE_LINE_START_POINT, tryRunBtn.actionPointToLogPoint(ao.points[0].pos));
                                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEACH_RELATIVE_LINT_TO_START_POINT);
                                }else if(ao.action === Teach.actions.F_CMD_JOINT_RELATIVE){
                                    panelRobotController.logTestPoint(Keymap.kTP_TEACH_RELATIVE_AUTO_END_POINT, tryRunBtn.actionPointToLogPoint(ao.points[0].pos));
                                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEACH_RELATIVE_AUTO_TO_START_POINT);
                                }else if(ao.action === Teach.actions.F_CMD_SINGLE){
                                    var cP = tryRunBtn.getCurrentPoint();
                                    cP[ao.axis] = ao.pos;
                                    panelRobotController.logTestPoint(Keymap.TEACH_RELATIVE_AUTO_END_POINT, JSON.stringify(cP));
                                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEACH_RELATIVE_AUTO_TO_START_POINT);
                                }

                            }
                        }
                        onBtnReleased: {
                            if(panelRobotController.isOrigined())
                                panelRobotController.sendKeyCommandToHost(Keymap.CMD_ROUTE_STOP);
                        }

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
                        id:copyUp
                        height: parent.height
                        width: 40
                        text: qsTr("CUW")

                        ListModel{
                            id:testMo
                        }

                        visible: {
                            return  (programListView.currentIndex < programListView.count - 1)
                        }

                        onButtonClicked: {
                            var toInsert = Utils.cloneObject(currentModelData().mI_ActionObject);
                            //                            var toInsert = currentModelData().mI_ActionObject;
                            insertActionToList(toInsert);
                            //                            if(toInsert.action === Teach.actions.F_CMD_SYNC_START)
                            repaintProgramItem(currentModel());
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
                            return Teach.actionObjectToEditableITems(currentItem.mI_ActionObject).length !== 0;
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
                            var cM = currentModel();
                            if(modelObject.mI_ActionObject.action === Teach.actions.ACT_COMMENT){
                                if(modelObject.mI_ActionObject.commentAction === null)
                                    return;
                            }
                            if(modelObject.mI_ActionObject.action === Teach.actions.ACT_FLAG){
                                return;
                            }

                            if(modelObject.mI_ActionObject.action === Teach.actions.ACT_COMMENT){
                                //                                modelObject.mI_ActionObject = modelObject.mI_ActionObject.commentAction;
                                cM.setProperty(programListView.currentIndex, "mI_ActionObject", modelObject.mI_ActionObject.commentAction);
                            }
                            else{
                                cM.setProperty(programListView.currentIndex, "mI_ActionObject", Teach.generateCommentAction(programListView.actionObjectToText(modelObject.mI_ActionObject), modelObject.mI_ActionObject));
                                //                                modelObject.mI_ActionObject = Teach.generateCommentAction(programListView.actionObjectToText(modelObject.mI_ActionObject), modelObject.mI_ActionObject);
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
                            var modelObject = currentModelData();
                            if(modelObject === null) return true;
                            if((programListView.currentIndex == programListView.count - 1) &&
                                    modelObject.mI_ActionObject.action != Teach.actions.ACT_END){
                                return true;

                            }

                            return programListView.currentIndex < programListView.count - 1;
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
                    function actionObjectToText(actionObject){
                        var originText = Teach.actionToStringNoCusomName(actionObject);
                        if(actionObject.customName){
                            var styledCN = ICString.icStrformat('<font size="4" color="#0000FF">{0}</font>', actionObject.customName);
                            originText = styledCN + " " + originText;
                        }
                        return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + originText.replace("\n                            ", "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
                    }

                    delegate: ProgramListItem{
                        x:1
                        width: programListView.width - x
                        //                        height: 30
                        isCurrent: ListView.isCurrentItem
                        isComment: mI_ActionObject.action === Teach.actions.ACT_COMMENT
                        isRunning: mI_IsActionRunning
                        lineNum: index + ":" + mI_ActionObject.insertedIndex
                        text: ((Teach.hasCounterIDAction(mI_ActionObject) || Teach.hasStackIDAction(mI_ActionObject)) && actionText.length !=0 ? actionText: programListView.actionObjectToText(mI_ActionObject));

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
                            if(editing.currentIndex > 8) return;
                            // update counters show
                            var currentCounterID = panelRobotController.statusValue("c_ro_8_5_0_938");
                            var currentCounterCurrent = panelRobotController.statusValue("c_ro_13_19_0_938");
                            var counter = Teach.counterManager.getCounter(currentCounterID);
                            if(counter != null){
                                if(counter.current != currentCounterCurrent){
                                    counter.current = currentCounterCurrent;
                                    //                                    console.log("counter info:", counter.id, counter.name,  counter.target, counter.current, currentProgramIndex());
                                    panelRobotController.saveCounterDef(counter.id, counter.name,counter.current, counter.target);
                                    onCounterUpdated(currentCounterID);

                                }
                            }

                            var uiRunningSteps = currentModelRunningActionInfo();
                            if(!isFollow.isChecked)
                                return


                            var lastRunning = PData.lastRunning;

                            var programIndex = uiRunningSteps.programIndex;
                            if(programIndex !== lastRunning.model ||
                                    uiRunningSteps.hostStep !== lastRunning.step)
                            {
                                var i;
                                var lastModel = PData.programs[lastRunning.model];

                                for(i = 0; i < lastRunning.items.length; ++i){
                                    lastModel.setProperty(lastRunning.items[i], "mI_IsActionRunning", false);
                                }

                                var cRunning = {"model":programIndex,"step":uiRunningSteps.hostStep, "moduleID":uiRunningSteps.moduleID};

                                if(uiRunningSteps.moduleID !== lastRunning.moduleID){
                                    moduleSel.setCurrentModule(uiRunningSteps.moduleID);
                                }
                                var cModel = currentModel();
                                var uiSteps = uiRunningSteps.steps;
                                for(i = 0; i < uiSteps.length; ++i){
                                    cModel.setProperty(uiSteps[i], "mI_IsActionRunning", true);
                                }
                                cRunning.items = uiSteps;
                                PData.lastRunning = cRunning;
                                programListView.positionViewAtIndex(uiSteps[0], ListView.Center );

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
                PData.programActionMenu = actionMenuObject;
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
                editor = Qt.createComponent('ModuleActionEditor.qml')
                var moduleEditorObject = editor.createObject(actionEditorContainer);
                PData.moduleActionEditor = moduleEditorObject;
                editor = Qt.createComponent('OriginActionEditor.qml')
                var originEditorObject = editor.createObject(actionEditorContainer);
                PData.moduleActionEditor = originEditorObject;

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

    ICMessageBox{
        id:tipBox
        //        anchors.centerIn: programFlowPageInstance
        z: 100
        x:(container.width - tipBox.realWidth) >> 1;
        y:(container.height - tipBox.realHeight) >> 1;
    }
    ActionModifyEditor{
        id:modifyEditor
        z:3
        x: 10

    }

    Item{
        id: autoKeyboard
        width: 600
        height:80
        y:330
        x:800
        z:10
        PropertyAnimation{
            id:autoKeyboardOut
            target: autoKeyboard
            property: "x"
            to: 800 - autoKeyboard.width
            duration: 100
        }
        SequentialAnimation{
            id:autoKeyboardIn
            PropertyAnimation{
                target: autoKeyboard
                property: "x"
                to: 800
                duration: 100
            }
            PropertyAction{
                target: autoKeyboardContent
                property: "visible"
                value:false
            }
        }
        ICButton{
            id:autoKeyboardBtn
            text: ""
            icon: "../images/tools_autokeyboard.png"
            width: 64
            height: 64
            bgColor: "green"
            anchors.right: autoKeyboardContent.left
            y:autoKeyboardContent.y
            onButtonClicked: {
                if(!autoKeyboardContent.visible){
                    autoKeyboardContent.visible = true;
                    autoKeyboardOut.start();
                    //                    text = "→";
                }else{
                    //                    text = "←";
                    //                    armKeyboard.visible = false;
                    autoKeyboardIn.start();
                }
            }
        }

        Rectangle {
            id:autoKeyboardContent
            width: parent.width
            height: parent.height
            color: "#A0A0F0"
            border.width: 1
            border.color: "gray"
            visible: false
            Column{
                spacing: 6
                anchors.centerIn: parent
                Row{
                    spacing: 12
                    ICCheckBox{
                        id:singleStep
                        text: qsTr("Single Step")
                        height: 32
                        onClicked: {
                            if(isChecked){
                                singleCycle.setChecked(false)
                                panelRobotController.setAutoRunningMode(editing.currentIndex, Keymap.kAM_SINGLE_STEP_MODE);
                            }else
                                panelRobotController.setAutoRunningMode(editing.currentIndex, 0);

                        }
                    }
                    ICButton{
                        id:singleStartLine
                        width: 200
                        text:qsTr("Start Line:[-1]")

                        onButtonClicked: {
                            panelRobotController.setSingleRunStart(editing.currentIndex, - 1, programListView.currentIndex);
                            text = ICString.icStrformat(qsTr("Start Line:[{0}]"),  programListView.currentIndex);
                        }
                    }
                    ICButton{
                        id:singleStart
                        text:qsTr("Single Start")
                        onButtonClicked: {
                            panelRobotController.setAutoRunningMode(editing.currentIndex, Keymap.kAM_SINGLE_STEP_START);
                        }
                    }


                }
                Row{
                    ICCheckBox{
                        id:singleCycle
                        text: qsTr("Single Cycle")
                        height: 32
                        onClicked: {
                            if(isChecked){
                                singleStep.setChecked(false)
                                panelRobotController.setAutoRunningMode(editing.currentIndex, Keymap.kAM_SINGLE_CYCLE_MODE);
                            }else
                                panelRobotController.setAutoRunningMode(editing.currentIndex, 0);


                        }
                    }
                    ICButton{
                        id:singleCycleStart
                        text:qsTr("Cycle Start")
                        onButtonClicked: {
                            panelRobotController.setAutoRunningMode(editing.currentIndex, Keymap.kAM_SINGLE_CYCLE_START);

                        }
                    }
                }
            }
        }
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
            }else if(step.action === Teach.actions.F_CMD_SYNC_END){
                at = Teach.actionTypes.kAT_SyncEnd;
                isSyncStart = false;
            }else if((step.action === Teach.actions.ACT_FLAG) ||
                     Teach.isJumpAction(step.action)){
                at = Teach.actionTypes.kAT_Flag;
            }else if(step.action === Teach.actions.F_CMD_IO_INPUT){
                at = Teach.actionTypes.kAT_Wait;
            }else
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
        PData.pointLinesInfo.clear(which);
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
            if(Teach.canActionUsePoint(step.mI_ActionObject)){
                var points = Teach.definedPoints.parseActionPointsHelper(step.mI_ActionObject);
                for(var p = 0; p < points.length; ++p){
                    PData.pointLinesInfo.add(which, points[p].index, i);
                }
            }
        }
    }

    function updateProgramModel(model, program){
        model.clear();
        var step;
        var at;
        var isSyncStart = false;
        var jumpLines = [];
        var insertedIndex = 0;
        for(var p = 0; p < program.length; ++p){
            step = program[p];
            step["insertedIndex"] = step.hasOwnProperty("insertedIndex") ? step.insertedIndex : insertedIndex++;

            if(step.insertedIndex >= insertedIndex)
                insertedIndex = step.insertedIndex + 1;
            if(Teach.canActionUsePoint(step)){
                Teach.definedPoints.parseActionPoints(step);
            }
            if(step.action === Teach.actions.ACT_FLAG){
                at = Teach.actionTypes.kAT_Flag;
                Teach.flagsDefine.pushFlag(Teach.currentParsingProgram, new Teach.FlagItem(step.flag, step.comment));
            }else if(step.action === Teach.actions.F_CMD_SYNC_START){
                at = Teach.actionTypes.kAT_SyncStart;
                isSyncStart = true;
            }else if(step.action === Teach.actions.F_CMD_SYNC_END){
                at = Teach.actionTypes.kAT_SyncEnd;
                isSyncStart = false;
            }else if(Teach.isJumpAction(step.action)){
                jumpLines.push(p);
                at = Teach.actionTypes.kAT_Flag;
            }else if(step.action === Teach.actions.F_CMD_IO_INPUT){
                at = Teach.actionTypes.kAT_Wait;
            }
            else
                at = Teach.actionTypes.kAT_Normal;
            if(isSyncStart)
                at = Teach.actionTypes.kAT_SyncStart;

            model.append(new Teach.ProgramModelItem(step, at));
        }
        for(var l = 0; l < jumpLines.length; ++l){
            step = program[jumpLines[l]];
            model.set(jumpLines[l], {"mI_ActionObject":step, "mI_IsActionRunning": true});
            model.set(jumpLines[l], {"mI_ActionObject":step, "mI_IsActionRunning": false});
        }
        return insertedIndex;
    }

    function updateProgramModels(){
        //        PData.counterLinesInfo.clear();
        editing.currentIndex = -1;
        var counters = JSON.parse(panelRobotController.counterDefs());
        Teach.counterManager.init(counters);
        Teach.variableManager.init(JSON.parse(panelRobotController.variableDefs()));
        Teach.parseStacks(panelRobotController.stacks());
        Teach.functionManager.init(panelRobotController.functions());

        //        var program = JSON.parse(panelRobotController.mainProgram());
        var program;
        var i;
        Teach.definedPoints.clear();
        for(i = 0; i < 9; ++i){
            program = JSON.parse(panelRobotController.programs(i));
            Teach.currentParsingProgram = i;
            Teach.flagsDefine.clear(i);
            PData.programToInsertIndex[i] = updateProgramModel(PData.programs[i], program);
            collectSpecialLines(i);
        }
        editing.currentIndex = 0;

        var modulsNames = Teach.functionManager.functionsStrList();
        moduleSel.currentIndex = -1;
        moduleSel.items = [];

        modulsNames.splice(0, 0, qsTr("Main Module"));
        moduleSel.items = modulsNames;
        moduleSel.currentIndex = 0;
        currentEditingProgram = 0;
        currentEditingModule = 0;

    }

    onVisibleChanged: {
        actionEditorFrame.visible = false;
        programListView.currentIndex = -1;
        if(!visible){
            if(hasModify)
                onSaveTriggered();
        }
        //        programListView.contentY = 0;
    }

    Component.onCompleted: {
        //        Teach.parseStacks(panelRobotController.stacks());
        editing.items = editing.defaultPrograms.concat(ManualProgramManager.manualProgramManager.programsNameList());
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
        PData.programs.push(functionsModel);
        PData.programs.push(manualProgramModel);


        updateProgramModels();
        panelRobotController.moldChanged.connect(updateProgramModels);
        modifyEditor.editConfirm.connect(onEditConfirm);
        delBtn.buttonClicked.connect(onDeleteTriggered);
        moveUpBtn.buttonClicked.connect(onUpTriggered);
        moveDWBtn.buttonClicked.connect(onDownTriggered);

        ShareData.UserInfo.registUserChangeEvent(programFlowPageInstance);
        ShareData.GlobalStatusCenter.registeKnobChangedEvent(programFlowPageInstance);

        setModuleEnabled(false);
        setManualProgramEnabled(false);

        Teach.definedPoints.registerPointsMonitor(programFlowPageInstance);

        hasInit = true;
    }
}
