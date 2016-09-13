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
import "../ExternalData.js" as ESData
import "extents/ExtentActionDefine.js" as ExtentActionDefine


Rectangle {
    id:programFlowPageInstance
    property alias actionMenuFrameSource:actionEditorFrame.source
    property alias isActionEditorPanelVisable: actionEditorFrame.visible
    property bool hasInit: false
    property int currentEditingProgram: 0
    property int currentEditingModule: 0
    property bool hasModify: false

    signal actionLineDeleted(int index, variant actionObject);

    function menuFrame(){ return actionEditorFrame;}

    function actionModifyEditor() { return modifyEditor;}

    function registerEditableAction(action, editorsList, editableItems){
        for(var i = 0, len = editorsList.length; i < len; ++i){
            modifyEditor.registerEditableItem(editorsList[i].editor, editorsList[i].itemName);
        }

        PData.registerEditableActions[action] = editableItems;
    }

    function getRecordContent(which){
        return JSON.parse(panelRobotController.programs(which));
    }

    function actionObjectToText(actionObject){
        var originText = Teach.actionToStringNoCusomName(actionObject);
        if(actionObject.customName){
            var styledCN = ICString.icStrformat('<font size="4" color="#0000FF">{0}</font>', actionObject.customName);
            originText = styledCN + " " + originText;
        }
        var reg = new RegExp("\n                            ", 'g');
        return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + originText.replace(reg, "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    }

    function beforeSaveProgram(which){

    }

    function afterSaveProgram(which){

    }

    function copyLine(){
        return Utils.cloneObject(currentModelData().mI_ActionObject);
    }

    function showActionEditorPanel(){
        if(actionEditorFrame.visible && !actionEditorFrame.item.isMenuVisiable()){
            actionEditorFrame.item.showMenu();
            return;
        }
        if(!actionEditorFrame.visible)
            programListView.contentY += actionEditorFrame.height;
        else
            programListView.contentY -= actionEditorFrame.height;

        actionEditorFrame.visible = !actionEditorFrame.visible;
    }

    function hideActionEditorPanel(){
        if(actionEditorFrame.visible){
            programListView.contentY -= actionEditorFrame.height;
            actionEditorFrame.visible = false;
        }
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
            Teach.flagsDefine.pushFlag(cPI, new Teach.FlagItem(actionObject.flag, actionObject.comment));
        }
        if(Teach.hasCounterIDAction(actionObject)){
            var cs = Teach.actionCounterIDs(actionObject);
            for(var c in cs){
                PData.counterLinesInfo.add(cPI, cs[c], cI);
            }
        }
        if(Teach.hasStackIDAction(actionObject)){
            PData.stackLinesInfo.add(cPI, Teach.actionStackID(actionObject), cI);
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
        var actionObjects = actionEditorFrame.item.createActionObjects();
        if(actionObjects.length == 0) return;
        for(var i = 0; i < actionObjects.length; ++i){
            insertActionToList(actionObjects[i]);
        }
        repaintProgramItem(currentModel());
        programListView.positionViewAtIndex(programListView.currentIndex, ListView.Visible);
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
            PData.stackLinesInfo.removeIDLine(cPI, Teach.actionStackID(actionObject), cI);
        }
        if(Teach.canActionUsePoint(actionObject)){
            var points = Teach.definedPoints.parseActionPointsHelper(actionObject);
            for(var p = 0; p < points.length; ++p){
                PData.pointLinesInfo.removeIDLine(cPI, points[p].index, cI);
            }
        }

        model.remove(cI);
        actionLineDeleted(cI, actionObject);
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
        var sid;
        if(Teach.hasCounterIDAction(cIAction)){
            cs = Teach.actionCounterIDs(cIAction);
            for(c in cs){
                PData.counterLinesInfo.removeIDLine(cPI, cs[c], cI);
                PData.counterLinesInfo.add(cPI, cs[c], cI - 1);
            }
        }
        if(Teach.hasStackIDAction(cIAction)){
            sid = Teach.actionStackID(cIAction);
            PData.stackLinesInfo.removeIDLine(cPI, sid, cI);
            PData.stackLinesInfo.add(cPI, sid, cI - 1);
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
            sid = Teach.actionStackID(cIPAction);
            PData.stackLinesInfo.removeIDLine(cPI, sid, cI - 1);
            PData.stackLinesInfo.add(cPI, sid, cI);
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
        var sid;
        if(Teach.hasCounterIDAction(cIAction)){
            cs = Teach.actionCounterIDs(cIAction);
            for(c in cs){
                PData.counterLinesInfo.removeIDLine(cPI, cs[c], cI);
                PData.counterLinesInfo.add(cPI, cs[c], cI + 1);
            }
        }
        if(Teach.hasStackIDAction(cIAction)){
            sid = Teach.actionStackID(cIAction);
            PData.stackLinesInfo.removeIDLine(cPI, sid, cI);
            PData.stackLinesInfo.add(cPI, sid, cI + 1);
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
            sid = Teach.actionStackID(cINAction);
            PData.stackLinesInfo.removeIDLine(cPI, sid, cI + 1);
            PData.stackLinesInfo.add(cPI, sid, cI);
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
                    saveModules(false);
                }else if(editing.currentIndex === 0)
                    panelRobotController.saveMainProgram(modelToProgram(0));
                else
                    panelRobotController.saveSubProgram(editing.currentIndex, modelToProgram(editing.currentIndex));
            }
            return;
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
            var toFixAction;
            if(actionObject.action === Teach.actions.ACT_COMMENT){
                toFixAction = actionObject.commentAction;
            }else
                toFixAction = actionObject;

            var originpPoints = toFixAction.points;
            for(var p = 0; p < originpPoints.length; ++p){
                if(point.index == Teach.definedPoints.extractPointIDFromPointName(originpPoints[p].pointName)){
                    toFixAction.points[p].pos = point.point;
                }
            }
            md.setProperty(line, "mI_ActionObject",actionObject);
        }
    }

    function updateStacksHelper(md, lines, stackID, cpI){
        var si = Teach.getStackInfoFromID(stackID);
        if(si == null) return;
        if(lines.length <= 0 ) return;
        var line;
        var tmp;
        var c1 = si.si0.doesBindingCounter ? si.si0.counterID : -1;
        var c2 = ((si.si1.doesBindingCounter) && (si.type == Teach.stackTypes.kST_Box)) ? si.si1.counterID : -1;
        for(var l in lines){
            line = lines[l];
            tmp = md.get(line);
            md.set(line, {"actionText":actionObjectToText(tmp.mI_ActionObject)});
            PData.counterLinesInfo.removeLine(cpI, line);
            if(c1 >= 0)
                PData.counterLinesInfo.add(cpI, c1, line);
            if(c2 >= 0)
                PData.counterLinesInfo.add(cpI, c2, line);
        }
    }

    function onPointChanged(point){
        //        var cpI = currentProgramIndex();
        var pointLines;
        var md;
        var i;
        var len;

        // module points execute
        if(moduleSel.currentIndex > 0)
            saveModules();
        var funs = Teach.functionManager.functions;
        for(i = 0, len = funs.length; i < len; ++i){
            updateProgramModel(functionsModel, funs[i].program);
            collectSpecialLines(PData.kFunctionProgramIndex);
            pointLines = PData.pointLinesInfo.getLines(PData.kFunctionProgramIndex, point.index);
            md = functionsModel;
            if(pointLines.length > 0 ){
                updatePointsHelper(md, pointLines, point);
                saveModuleByName(funs[i].toString(), false);
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

        var mPs = ManualProgramManager.manualProgramManager.programList();
        for(i = 0; i < mPs.length; ++i){
            updateProgramModel(manualProgramModel, mPs[i].program);
            collectSpecialLines(PData.kManualProgramIndex);
            pointLines = PData.pointLinesInfo.getLines(PData.kManualProgramIndex, point.index);
            md = manualProgramModel;
            if(pointLines.length > 0 ){
                updatePointsHelper(md, pointLines, point);
                saveManualProgramByName("[" + mPs[i].id + "]");
            }
        }
        if(editing.currentIndex > 8){
            updateProgramModel(manualProgramModel, ManualProgramManager.manualProgramManager.getProgramByName(editing.currentText()).program);
            collectSpecialLines(PData.kManualProgramIndex);
        }
        hasModify = true;
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

    function saveModuleByName(name, syncMold, sendToHost){
        var fun = Teach.functionManager.getFunctionByName(name);
        if(fun == null) return;
        fun.program = modelToProgramHelper(PData.kFunctionProgramIndex);
        var fJSON = Teach.functionManager.toJSON();
        var eIJSON = panelRobotController.saveFunctions(fJSON, syncMold, (sendToHost == undefined ? true : sendToHost));
        var errInfo = JSON.parse(eIJSON)[fun.id];
        return errInfo;
    }

    function saveManualProgramByName(name){
        var program = modelToProgramHelper(PData.kManualProgramIndex);
        var errInfo = JSON.parse(panelRobotController.checkProgram(JSON.stringify(program), "","","", ""));
        if(errInfo.length == 0){
            var updateID = ManualProgramManager.manualProgramManager.updateProgramByName(name, program);
            if(updateID == 0)
                panelRobotController.manualRunProgram(JSON.stringify(program),
                                                      "","", "", "", 19, false);
            else if(updateID == 1)
                panelRobotController.manualRunProgram(JSON.stringify(program),
                                                      "","", "", "", 18, false);
        }
        return errInfo;
    }

    function saveModules(sendToHost){
        return saveModuleByName(moduleSel.text(currentEditingModule), true, (sendToHost == undefined ?  true : sendToHost));
    }

    function saveProgram(which){
        if(!hasInit) return;
        if(!hasModify) return;
        beforeSaveProgram(which);
        var errInfo;
        tipBox.runningTip(qsTr("Program Compiling..."));
        var pName;
        if(which == PData.kFunctionProgramIndex){
            pName = qsTr("Modules");
            errInfo = saveModules();
        }else if(which == PData.kManualProgramIndex){
            pName = qsTr("Manual Program");
            errInfo = saveManualProgramByName(editing.text(PData.lastEditingIndex));
        }else if(which == 0){
            pName = qsTr("Main Program")
            errInfo = JSON.parse(panelRobotController.saveMainProgram(modelToProgram(0)));
            if(errInfo.length === 0){
                panelRobotController.sendMainProgramToHost();
            }
        }else{
            pName = qsTr("Sub-") + which;
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
            tipBox.warning( ICString.icStrformat(qsTr("Save {0} fail!.\n"), pName), qsTr("OK"), toShow);
        }
        else
            tipBox.hide();
        var programStr = which == 0 ? qsTr("Main Program") : ICString.icStrformat(qsTr("Sub-{0} Program"), which);
        ICOperationLog.opLog.appendOperationLog(ICString.icStrformat(qsTr("Save {0} of Record:{1}"), programStr, panelRobotController.currentRecordName()));
        hasModify = false;
        afterSaveProgram(which);
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
        if(editing.currentIndex < 0) return 0;
        return editing.currentIndex;
    }

    function currentModelData() {
        if(programListView.currentIndex < 0) return null;
        return currentModel().get(programListView.currentIndex);
    }

    function currentModelStep(){
        return panelRobotController.statusValue(PData.stepAddrs[editing.currentIndex]);
    }

    function mappedModelRunningActionInfo(baseRunningActionInfo){
        return baseRunningActionInfo;
    }

    function currentModelRunningActionInfo(){
        var ret = panelRobotController.currentRunningActionInfo(editing.currentIndex);
        //                console.log(ret);
        var info = JSON.parse(ret);
        info.steps = JSON.parse(info.steps);
        //        if(info.moduleID >= 0)
        //            console.log(ret);
        return mappedModelRunningActionInfo(info);
    }

    function setModuleEnabled(en){
        newModuleBtn.visible = en && (editing.currentIndex < 9) && !PData.isReadOnly;
        delModuleBtn.visible = en && (moduleSel.currentIndex != 0) && newModuleBtn.visible;
    }

    function setManualProgramEnabled(en){
        newManualProgram.visible = en;
        deleteManualProgram.visible = en && (editing.currentIndex > 8);
    }

    function onUserChanged(user){
        PData.isReadOnly = ( (ShareData.GlobalStatusCenter.getKnobStatus() === Keymap.KNOB_AUTO) || !ShareData.UserInfo.currentHasMoldPerm());
        if(PData.isReadOnly){
            hideActionEditorPanel();
        }

        programListView.currentIndex = -1;
        setModuleEnabled(!PData.isReadOnly);
        setManualProgramEnabled(!PData.isReadOnly);
    }

    function onKnobChanged(knobStatus){
        onUserChanged(null);
        var isAuto = (knobStatus === Keymap.KNOB_AUTO);
        autoKeyboard.visible = isAuto;
        autoRunInfoContainer.visible = isAuto;
        moduleSel.currentIndex = 0;
        if(isAuto){
            singleCycle.setChecked(false);
            singleStep.setChecked(false);
        }else
            programListView.clearLastRunning(PData.lastRunning);
        editing.resetProgramItems(isAuto);
        isFollow.visible = isAuto;

        modifyEditor.isAutoMode = isAuto;
        PData.clearAutoModifyPosActions();
        hideActionEditorPanel();
        speedDispalyContainer.visible = isAuto;
        if(hasModify)
            onSaveTriggered();
    }

    function onStackUpdated(stackID){
        if(moduleSel.currentIndex > 0)
            saveModules();
        var funs = Teach.functionManager.functions;
        var i, len;
        var stackLines;
        var md;
        for(i = 0, len = funs.length; i < len; ++i){
            updateProgramModel(functionsModel, funs[i].program);
            collectSpecialLines(PData.kFunctionProgramIndex);
            stackLines = PData.stackLinesInfo.getLines(PData.kFunctionProgramIndex, stackID);
            md = functionsModel;
            if(stackLines.length > 0 ){
                updateStacksHelper(md, stackLines, stackID, PData.kFunctionProgramIndex);
                saveModuleByName(funs[i].toString(), false);
            }
        }
        if(moduleSel.currentIndex > 0){
            updateProgramModel(functionsModel, Teach.functionManager.getFunctionByName(moduleSel.currentText()).program);
            collectSpecialLines(PData.kFunctionProgramIndex);
        }

        for(i = 0, len = PData.kFunctionProgramIndex; i < len; ++i){
            stackLines = PData.stackLinesInfo.getLines(i, stackID);
            md = PData.programs[i];
            if(stackLines.length > 0){
                updateStacksHelper(md, stackLines, stackID, i);
                hasModify = true;
                saveProgram(i);
            }
        }
        hasModify = true;
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
            md.set(line, {"actionText":actionObjectToText(tmp.mI_ActionObject)});

        }
    }

    function onGlobalSpeedChanged(spd){
        speedDisplay.text = parseFloat(spd).toFixed(1);
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
                        if(isAutoMode){
                            currentIndex = 0;
                            items = defaultPrograms;
                        }
                        else
                            items = defaultPrograms.concat(ManualProgramManager.manualProgramManager.programsNameList());
                    }

                    items:defaultPrograms
                    currentIndex: 0
                    onCurrentIndexChanged: {
                        //                        console.log("onCurrentIndexChanged", currentIndex);
                        if(actionEditorFrame.visible && !actionEditorFrame.item.isMenuVisiable()){
                            actionEditorFrame.item.showMenu();
                        }
                        deleteManualProgram.visible = false;
                        if(currentIndex > 8){
                            saveProgram(currentEditingProgram);
                            deleteManualProgram.visible = newManualProgram.visible;
                            newModuleBtn.visible = false;
                            Teach.currentParsingProgram = PData.kManualProgramIndex;
                            PData.programToInsertIndex[PData.kManualProgramIndex] = updateProgramModel(manualProgramModel, ManualProgramManager.manualProgramManager.getProgramByName(editing.text(currentIndex)).program);
                            programListView.model = manualProgramModel;
                            programListView.currentIndex = -1;
                            currentEditingProgram = PData.kManualProgramIndex;
                            PData.currentEditingProgram = PData.kManualProgramIndex;
                            PData.lastEditingIndex = currentIndex;
                            actionEditorFrame.item.setMode("manualProgramEditMode");

                        }else{
                            actionEditorFrame.item.setMode("");
                            setModuleEnabled(true);
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
                            PData.lastEditingIndex = currentIndex;
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
                    popupHeight: 350
                    visible: editing.currentIndex < 9

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
                        if(actionEditorFrame.visible && !actionEditorFrame.item.isMenuVisiable()){
                            actionEditorFrame.item.showMenu();
                        }
                        saveProgram(currentEditingProgram);
                        if(currentIndex < 0) return;
                        if(currentIndex == 0){
                            programListView.currentIndex = -1;
                            Teach.currentParsingProgram = editing.currentIndex;
                            programListView.model = PData.programs[editing.currentIndex];
                            currentEditingProgram = editing.currentIndex;
                            currentEditingModule = 0;
                            delModuleBtn.visible = false;
                            if(actionEditorFrame.progress == 1)
                                actionEditorFrame.item.setMode("");
                            PData.currentEditingProgram = editing.currentIndex;
                        }else{
                            Teach.currentParsingProgram = PData.kFunctionProgramIndex;
                            PData.programToInsertIndex[PData.kFunctionProgramIndex] = updateProgramModel(functionsModel, Teach.functionManager.getFunctionByName(moduleSel.currentText()).program);
                            collectSpecialLines(PData.kFunctionProgramIndex);
                            programListView.currentIndex = -1;
                            programListView.model = functionsModel;
                            currentEditingProgram = PData.kFunctionProgramIndex
                            currentEditingModule = moduleSel.currentIndex;
                            delModuleBtn.visible = newModuleBtn.visible;
                            actionEditorFrame.item.setMode("moduleEditMode");
                            PData.currentEditingProgram = PData.kFunctionProgramIndex;


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
                            saveModules();
//                            hasModify = true;
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
                        hasModify = false;
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
//                        speedDisplay.text = panelRobotController.getConfigValueText("s_rw_0_16_1_294");
                        speedDisplay.text = ShareData.GlobalStatusCenter.getGlobalSpeed();
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
//                        if(Teach.hasPosAction(actionObject)){
//                            var index = programListView.currentIndex;
//                            var pIndex = editing.currentIndex;
//                            var mIndex = moduleSel.currentIndex;
//                            var lineID = (mIndex > 0 ? (mIndex + 8) : pIndex) + ":" + index;
//                            console.log(lineID);
//                            if(PData.hasAutoModified(lineID)){
//                                actionObject.pos = PData.autoModifyPosActions[lineID];
//                            }
//                            PData.autoModifyPosActions[lineID] = actionObject.pos;
//                        }

                        modifyEditor.openEditor(actionObject, PData.isRegisterEditableAction(actionObject.action) ? PData.registerEditableActions[actionObject.action]:Teach.actionObjectToEditableITems(actionObject));
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

                        onBtnPressed: {
                            console.log("Run")
                            if(panelRobotController.isOrigined()){
                                var actionObject = currentModelData().mI_ActionObject;
                                var p = [actionObject, Teach.generteEndAction()];
                                panelRobotController.manualRunProgram(JSON.stringify(p), "", "","","");
                            }
                        }
                        onBtnReleased: {
                            if(panelRobotController.isOrigined())
                                panelRobotController.sendKeyCommandToHost(Keymap.CMD_MANUAL_STOP);
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

                        Rectangle{
                            id:copyAdvance
                            border.width: 1
                            border.color: "black"
                            color: "#A0A0F0"
                            MouseArea{
                                anchors.fill: parent
                            }
                            width: 310
                            height: 100
                            x:parent.width - width
                            y:{
                                if(toolBar.y < height)
                                    return parent.height;
                                 return -height;
                            }
                            visible: false
                            Column{
                                anchors.centerIn: parent
                                spacing: 6
                                ICButton{
                                    id:copyCurrentLineBtn
                                    text: qsTr("Copy Current Line")
                                    width: 210
                                    onButtonClicked: {
                                        PData.setClipboard([copyLine()]);
                                        copyAdvance.visible = false;
                                        pasteBtn.enabled = PData.clipboard.length != 0;
                                    }
                                }
                                Row{
                                    spacing: 6
                                    ICConfigEdit{
                                        id:seq
                                        configName: qsTr("Seq")
                                        inputWidth: 50
                                        height: copyMultiLineBtn.height
                                        configValue: "0"
                                    }
                                    ICButton{
                                        id:copyMultiLineBtn
                                        text:qsTr("Copy Between Seq and Current")
                                        width: 210
                                        onButtonClicked: {
                                            var toCopy = [];
                                            var begin = Math.min(parseInt(seq.configValue), programListView.currentIndex);
                                            var end = Math.max(parseInt(seq.configValue), programListView.currentIndex);
                                            for(var i = begin; i <= end; ++i){
                                                toCopy.push(Utils.cloneObject(currentModel().get(i).mI_ActionObject));
                                            }
                                            PData.setClipboard(toCopy);
                                            pasteBtn.enabled = PData.clipboard.length != 0;
                                            copyAdvance.visible = false;

                                        }
                                    }
                                }
                            }
                        }


                        visible: {
                            return  (programListView.currentIndex < programListView.count - 1)
                        }

                        onButtonClicked: {
                            copyAdvance.visible = true;
//                            var toInsert = Utils.cloneObject(currentModelData().mI_ActionObject);
//                            var toInsert = copyLine();
                            //                            var toInsert = currentModelData().mI_ActionObject;
//                            insertActionToList(toInsert);
                            //                            if(toInsert.action === Teach.actions.F_CMD_SYNC_START)
//                            repaintProgramItem(currentModel());
                        }
                    }

                    ICButton{
                        id:pasteBtn
                        height: parent.height
                        width: 40
                        text: qsTr("Paste")
                        enabled: false

                        onButtonClicked: {
                            for(var i = 0, len = PData.clipboard.length; i < len; ++i){
                                insertActionToList(PData.clipboard[i]);
                            }
                            repaintProgramItem(currentModel());
                        }
                    }

                    ICButton{
                        id:editBtn
                        height: parent.height
                        width: 40
                        text: qsTr("Edit")
                        onButtonClicked: {
                            hideActionEditorPanel();
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
                                cM.setProperty(programListView.currentIndex, "mI_ActionObject", Teach.generateCommentAction(actionObjectToText(modelObject.mI_ActionObject), modelObject.mI_ActionObject));
                            }
                            hasModify = true;

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
                        visible: false
//                        {

//                            var modelObject = currentModelData();
//                            if(modelObject === null) return true;
//                            if((programListView.currentIndex == programListView.count - 1) &&
//                                    (modelObject.mI_ActionObject.action != Teach.actions.ACT_END &&
//                                     modelObject.mI_ActionObject.action != Teach.actions.F_CMD_PROGRAM_CALL_BACK)){
//                                return true;

//                            }

//                            return programListView.currentIndex < programListView.count - 1;
//                        }

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


                    function clearLastRunning(lastRunning){
                        var i;
                        var lastModel = PData.programs[lastRunning.model];

                        for(i = 0; i < lastRunning.items.length; ++i){
                            lastModel.setProperty(lastRunning.items[i], "mI_IsActionRunning", false);
                        }
                        lastRunning = {"model": -1, "moduleID":-1, "step":-1, "items":[]}
                    }

                    delegate: ProgramListItem{
                        x:1
                        width: programListView.width - x
                        //                        height: 30
                        isCurrent: ListView.isCurrentItem
                        isComment: mI_ActionObject.action === Teach.actions.ACT_COMMENT
                        isRunning: mI_IsActionRunning
                        lineNum: index + ":" + mI_ActionObject.insertedIndex
                        text: ((Teach.hasCounterIDAction(mI_ActionObject) || Teach.hasStackIDAction(mI_ActionObject)) && actionText.length !=0 ? actionText: actionObjectToText(mI_ActionObject));

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

                            if(!panelRobotController.isInAuto()) return;
                            autoKeyboard.visible = !panelRobotController.isAutoRunning();
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
                            if((moduleSel.currentIndex > 0 && uiRunningSteps.model < 0) ||
                                    (moduleSel.currentIndex == 0 && uiRunningSteps.model >= 0)) return
                            if(programIndex !== lastRunning.model ||
                                    uiRunningSteps.hostStep !== lastRunning.step)
                            {
                                var i;
                                programListView.clearLastRunning(lastRunning);
//                                var lastModel = PData.programs[lastRunning.model];

//                                for(i = 0; i < lastRunning.items.length; ++i){
//                                    lastModel.setProperty(lastRunning.items[i], "mI_IsActionRunning", false);
//                                }

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
        Loader{
            id:actionEditorFrame
            width: container.width
            height: container.height / 2
            x:2
            source: "ProgramActionMenuFrame.qml"
            onLoaded: {
                actionEditorFrame.item.insertActionTriggered.connect(onInsertTriggered);
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

    MouseArea{
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

    MouseArea{
        id:autoRunInfoContainer
        width: 150
        height:300
        y:90
        x:-width
        z:9
        PropertyAnimation{
            id:autoRunInfoOut
            target: autoRunInfoContainer
            property: "x"
            to: 0
            duration: 100
        }
        SequentialAnimation{
            id:autoRunInfoIn
            PropertyAnimation{
                target: autoRunInfoContainer
                property: "x"
                to: -autoRunInfoContainer.width
                duration: 100
            }
            PropertyAction{
                target: autoRunInfoPage
                property: "visible"
                value:false
            }
        }
        ICButton{
            id:autoRunInfoBtn
            text: ""
            icon: "../images/tools_autoruninfo.png"
            width: 64
            height: 64
            bgColor: "green"
            anchors.left: autoRunInfoContainer.right
            anchors.bottom: autoRunInfoContainer.bottom
            onButtonClicked: {
                if(!autoRunInfoPage.visible){
                    autoRunInfoPage.visible = true;
                    autoRunInfoOut.start();
                    //                    text = "→";
                }else{
                    //                    text = "←";
                    //                    armKeyboard.visible = false;
                    autoRunInfoIn.start();
                }
            }
        }
        AutoRunInfoPage{
            id:autoRunInfoPage
            width: parent.width
            height: parent.height
            visible: false
            onVisibleChanged: {
                isAnalogEn = panelRobotController.getConfigValue("s_rw_0_32_0_213");
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
            }else if(step.action === Teach.actions.F_CMD_IO_INPUT
                     || step.action === Teach.actions.F_CMD_WATIT_VISION_DATA){
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
                PData.stackLinesInfo.add(which, Teach.actionStackID(step.mI_ActionObject), i);
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
        var currentParsingProgram = PData.programToParsingIndex(model);
        Teach.flagsDefine.clear(currentParsingProgram);
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
                Teach.flagsDefine.pushFlag(currentParsingProgram, new Teach.FlagItem(step.flag, step.comment));
            }else if(step.action === Teach.actions.F_CMD_SYNC_START){
                at = Teach.actionTypes.kAT_SyncStart;
                isSyncStart = true;
            }else if(step.action === Teach.actions.F_CMD_SYNC_END){
                at = Teach.actionTypes.kAT_SyncEnd;
                isSyncStart = false;
            }else if(Teach.isJumpAction(step.action)){
                jumpLines.push(p);
                at = Teach.actionTypes.kAT_Flag;
            }else if(step.action === Teach.actions.F_CMD_IO_INPUT ||
                     step.action === Teach.actions.F_CMD_WATIT_VISION_DATA){
                at = Teach.actionTypes.kAT_Wait;
            }
            else
                at = Teach.actionTypes.kAT_Normal;
            if(isSyncStart)
                at = Teach.actionTypes.kAT_SyncStart;

            model.append(new Teach.ProgramModelItem(step, at));
        }
        return insertedIndex;
    }

    function updateProgramModels(){
        hasModify = false;
        programListView.model = null;
        Teach.definedPoints.clear();
        editing.currentIndex = -1;
        var counters = JSON.parse(panelRobotController.counterDefs());
        Teach.counterManager.init(counters);
        Teach.variableManager.init(JSON.parse(panelRobotController.variableDefs()));
        Teach.parseStacks(panelRobotController.stacks());
        Teach.functionManager.init(panelRobotController.functions());


        //        var program = JSON.parse(panelRobotController.mainProgram());
        var program;
        var i;
        if(hasInit){
            var sI;
            var toSendStackData = new ESData.RawExternalDataFormat(-1, []);
            for(i = 0; i < Teach.stackInfos.length; ++i){
                sI = Teach.stackInfos[i];
                if(sI.dsHostID >= 0 && sI.posData.length > 0){
                    ESData.externalDataManager.registerDataSource(sI.dsName,
                                                                  ESData.CustomDataSource.createNew(sI.dsName, sI.dsHostID));
                    toSendStackData.dsID = sI.dsName;
                    toSendStackData.dsData = sI.posData;
                    var posData = ESData.externalDataManager.parseRaw(toSendStackData);
                    panelRobotController.sendExternalDatas(JSON.stringify(posData));
                }
            }
        }

        for(i = 0; i < 9; ++i){
//            program = JSON.parse(panelRobotController.programs(i));
            Teach.currentParsingProgram = i;
            Teach.flagsDefine.clear(i);
            program = getRecordContent(i);
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
        programListView.model = mainProgramModel;

    }

    onVisibleChanged: {
        hideActionEditorPanel();
        programListView.currentIndex = -1;
        if(!visible){
            if(hasModify)
                onSaveTriggered();
        }
    }

    Component.onCompleted: {
        ExtentActionDefine.init(Teach.counterManager);
        Teach.registerCustomActions(panelRobotController, ExtentActionDefine.extentActions);
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
        var mPs = ManualProgramManager.manualProgramManager.programList();
        for(var i = 0; i < mPs.length; ++i){
            Teach.definedPoints.parseProgram(mPs[i].program);
        }

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

        for(var ac in Teach.customActions){
            modifyEditor.registerEditableItem(Teach.customActions[ac].editableItems.editor,
                                              Teach.customActions[ac].editableItems.itemDef.item);
        }

        hasInit = true;
    }
}
