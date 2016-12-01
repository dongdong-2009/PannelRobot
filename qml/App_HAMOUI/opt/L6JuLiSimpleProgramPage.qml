import QtQuick 1.1
import "../../ICCustomElement"
import "../teach/Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../teach"
import "../teach/ProgramFlowPage.js" as ProgramFlowPage
import "../configs/IODefines.js" as IODefines
Rectangle {
    id:instance
    property variant programInfo: {
        "mainProgramID":0,
                "getMaterialProgramID":1,
                "releaseProductModuleID":0,
                "releaseProductStackCounterID":0,
                "checkMAFlag" : 0,
                "checkMBFlag" : 1,
                "checkMMaxFlag" : 2,
                "startGetMFlag" : 3,
                "mForGetM" : 0,
                "yForGetM" : 013,
                "yForGetP":014,
                "yForPosM" : 015,
                "yForPosP" : 016,
                "yForRemoveM" : 021,
                "yForVec" : 006,
                "xForMF" : 010,
                "xForMA" : 020,
                "xForMB" : 021,
    }

    function valveIDFromPoint(point) {
        return "valve" + point;
    }

    function syncActions(actions){
        actions.splice(0, 0, Teach.generateSyncBeginAction());
        actions.push(Teach.generateSyncEndAction());
        return actions;
    }

    function showActionEditorPanel(){}
    function onInsertTriggered(){}
    function onDeleteTriggered(){}
    function onUpTriggered(){}
    function onDownTriggered(){}
    function onFixIndexTriggered(){}
    function generateReleaseProductModule(stackInfo){
        stackInfo.doesBindingCounter = true;
        stackInfo.counterID = programInfo.releaseProductStackCounterID;
        var releaseProductCounter = Teach.counterManager.getCounter(programInfo.releaseProductStackCounterID);
        if(releaseProductCounter === null){
            releaseProductCounter = Teach.counterManager.newCounter(qsTr("Release Product Stack"), 0, stackInfo.count0 * stackInfo.count1 * stackInfo.count2);
        }else
            Teach.counterManager.updateCounter(programInfo.releaseProductStackCounterID, qsTr("Release Product Stack"), releaseProductCounter.current, stackInfo.count0 * stackInfo.count1 * stackInfo.count2);
        var stack = Teach.getStackInfoFromID(programInfo.releaseProductModuleID);
        if(stack === null){
            stack = Teach.getStackInfoFromID(Teach.appendStackInfo(new Teach.StackInfo(stackInfo, stackInfo, 0, qsTr("Release Product"))));
        }else{
            stack.si0 = stackInfo;
            Teach.updateStackInfo(programInfo.releaseProductModuleID, stack);
        }
        panelRobotController.saveCounterDef(releaseProductCounter.id, releaseProductCounter.name, releaseProductCounter.current, releaseProductCounter.target);
        panelRobotController.saveStacks(Teach.stacksToJSON());

        var p = [];
        p = p.concat(syncActions([Teach.generateOutputAction(programInfo.yForPosM, IODefines.VALVE_BOARD, 0, programInfo.yForPosM, 0.00),
                                  Teach.generateOutputAction(programInfo.yForVec, IODefines.VALVE_BOARD, 0, programInfo.yForVec, 0.00),
                                 ]));
        p[p.length - 3].customName = qsTr("Swich to p pos");
        p[p.length - 2].customName = qsTr("Swich to rp pose");
        p.push(Teach.generateStackAction(0, relPSpdm0.configValue, relPSpdm1.configValue, relPSpdm2.configValue));
        p.push(Teach.generateOutputAction(programInfo.yForGetP, IODefines.VALVE_BOARD, 0, programInfo.yForGetP, gPVOFFDelay.configValue));
        p.push(Teach.generateCounterAction(programInfo.releaseProductStackCounterID));
        p.push(Teach.generateCounterJumpAction(0, programInfo.releaseProductStackCounterID, 1, 1));
        p.push(Teach.generateFlagAction(0, qsTr("Clear Counter")));
        p.push(Teach.generteEndAction());

        var releaseProductModule = Teach.functionManager.getFunction(programInfo.releaseProductModuleID);
        if(releaseProductModule == null){
            releaseProductModule = Teach.functionManager.newFunction(qsTr("Release Product"), p);
        }else
            Teach.functionManager.updateFunction(programInfo.releaseProductModuleID, qsTr("Release Product"), p);
        panelRobotController.saveFunctions(Teach.functionManager.toJSON(), true, true);
        return programInfo.releaseProductModuleID;
    }

    function generateUpMaterialProgram(){
        var ret = [];
        ret.push(Teach.generateFlagAction(0, qsTr("Wait for m0 off")));
        ret.push(Teach.generateConditionAction(IODefines.M_BOARD_0, programInfo.mForGetM, 0, 0, 0, 0)); // check m0
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 3, uMPm3.configValue, uMPm3Spd.configValue, 0.00));
        ret.push(Teach.generteEndAction());
        ProgramFlowPage.instance.updateProgramModel(ProgramFlowPage.programs[programInfo.getMaterialProgramID], ret);
        ProgramFlowPage.instance.hasModify = true;
        ProgramFlowPage.instance.saveProgram(programInfo.getMaterialProgramID);

        ret = [];
        ret.push(Teach.generateFlagAction(0, qsTr("Start")));
        ret.push(Teach.generateConditionAction(0, programInfo.xForMA, 0, 1, 0, 1)); // check x030
        ret.push(Teach.generateConditionAction(0, programInfo.xForMB, 0, 1, 0, 1)); // check x030
        ret.push(Teach.generateJumpAction(0));
        ret.push(Teach.generateFlagAction(1, qsTr("Stop Up Material Axis")));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 3, 0, 0, 0, false, false, 0, false, 0, 0, false, 0, false, 0, true));
        ret.push(Teach.generteEndAction());
        ProgramFlowPage.instance.updateProgramModel(ProgramFlowPage.programs[2], ret);
        ProgramFlowPage.instance.hasModify = true;
        ProgramFlowPage.instance.saveProgram(2);

        panelRobotController.setConfigValue("m_rw_1_1_0_357", 1);
        panelRobotController.syncConfigs();
    }

    function setPosDataHelper(posName){
        return {
            "pos":{"m0":this[posName + "m0"].configValue,"m1":this[posName + "m1"].configValue, "m2":this[posName + "m2"].configValue},
            "spd":{"m0":this[posName + "m0Spd"].configValue,"m1":this[posName + "m1Spd"].configValue, "m2":this[posName + "m2Spd"].configValue},
            "dly":{"m0":this[posName + "m0Delay"].configValue,"m1":this[posName + "m1Delay"].configValue, "m2":this[posName + "m2Delay"].configValue}
        };
    }

    function saveReserveData(){
        var defaultSPD = "80.0";
        var defaultPOS = "0.000";
        var defaultAxisDly = "0.00";
        var defaultValveDly = "0.50";
        return {
            "standbyPos":setPosDataHelper("sp"),
            "getProductPos":setPosDataHelper("gp"),
            "getProductValveOnDly":gPVONDelay.configValue,
            "getProductBackPos":{
                "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":gFBm2.configValue},
                "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":gFBm2Spd.configValue},
                "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":gFBm2Delay.configValue},
            },
            "releaseMaterialPos":setPosDataHelper("rMP"),
            "releaseMaterialValveOffDly":rMVOFFDelay.configValue,
            "releaseMaterialBackPos":{
                "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":rMFBm2.configValue},
                "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":rMFBm2Spd.configValue},
                "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":rMFBm2Delay.configValue},
            },
            "releaseProductStackInfo":{
                "m0pos" : releaseProductStack.motor0 ,
                "m1pos" : releaseProductStack.motor1 ,
                "m2pos" : releaseProductStack.motor2 ,
                "m3pos" : releaseProductStack.motor3 ,
                "m4pos" : releaseProductStack.motor4 ,
                "m5pos" : releaseProductStack.motor5 ,
                "space0" : releaseProductStack.space0 ,
                "space1" : releaseProductStack.space1 ,
                "space2" : releaseProductStack.space2 ,
                "count0" : releaseProductStack.count0 ,
                "count1" : releaseProductStack.count1 ,
                "count2" : releaseProductStack.count2 ,
                "sequence" : releaseProductStack.seq ,
                "dir0" : releaseProductStack.dir0 ,
                "dir1" : releaseProductStack.dir1 ,
                "dir2" : releaseProductStack.dir2 ,
                "doesBindingCounter" : true ,
                "counterID" : 0 ,
                "isOffsetEn" : releaseProductStack.isOffsetEn,
                "isZWithYEn" : releaseProductStack.isZWithYEn,
                "offsetX" : releaseProductStack.offsetX ,
                "offsetY" : releaseProductStack.offsetY ,
                "offsetZ" : releaseProductStack.offsetZ ,
                "dataSourceName" : "",
                "dataSourceID" : -1,
                "runSeq" : releaseProductStack.runSeq
            },
            "releaseProductSPD":{"all":relPSpd.configValue, "m0":relPSpdm0.configValue, "m1":relPSpdm1.configValue, "m2":relPSpdm2.configValue},
            "getProductValveOffDelay":gPVOFFDelay.configValue,
            "getMaterialAPos":setPosDataHelper("gMA"),
            "getMaterialBPos":setPosDataHelper("gMB"),
            "getMaterialValveOnDly":gMVOnDelay.configValue,
            "removeMaterialPos":setPosDataHelper("rMP"),
            "removeMaterialValveOnDly":rMVOnDelay.configValue,
            "upMaterialPos":{
                "pos":{"m3":uMPm3.configValue},
                "spd":{"m3":uMPm3Spd.configValue},
                "dly":{"m3":defaultAxisDly},
            },
        };
    }

    function onSaveTriggered(){
        var ret = [];
        ProgramFlowPage.moldExtentData = saveReserveData();
        ret.push(Teach.generateCommentAction("Reserve Data", null, JSON.stringify(ProgramFlowPage.moldExtentData)));
        ret[0].insertedIndex = 0;
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, spm1.configValue, spm1Spd.configValue, spm1Delay.configValue));
        ret = ret.concat([Teach.generateOutputAction(programInfo.yForVec, IODefines.VALVE_BOARD, 0, programInfo.yForVec, 0.00),
                          Teach.generateOutputAction(programInfo.yForPosM, IODefines.VALVE_BOARD, 1, programInfo.yForPosM, 0.00)]);
        ret[ret.length - 2].customName = qsTr("Swich to gm pose");
        ret[ret.length - 1].customName = qsTr("Swich to m pos");
        ret.push(Teach.generateFlagAction(programInfo.checkMMaxFlag, qsTr("Wait for Material")));
        ret.push(Teach.generateConditionAction(0, programInfo.xForMA, 0, 1, 0, programInfo.checkMAFlag)); // check x030
        ret.push(Teach.generateConditionAction(0, programInfo.xForMB, 0, 1, 0, programInfo.checkMBFlag)); // check x031
        ret.push(Teach.generateMemCmpJumpAction(programInfo.checkMMaxFlag, 3281027081, uMPm3.configValue, 2, 0)); // check < x2 max
        ret.push(Teach.generateCustomAlarmAction(5000)); // no material alarm
        ret.push(Teach.generateFlagAction(programInfo.checkMAFlag, qsTr("get material-A start")));
        ret.push(Teach.generateOutputAction(programInfo.mForGetM, IODefines.M_BOARD_0, 1, 32, 0)); // lock up material process
        ret.push(Teach.generateSyncBeginAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 0, gMAm0.configValue, gMAm0Spd.configValue, gMAm0Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, gMAm2.configValue, gMAm2Spd.configValue, gMAm2Delay.configValue));
        ret.push(Teach.generateSyncEndAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, gMAm1.configValue, gMAm1Spd.configValue, gMAm1Delay.configValue));
        ret.push(Teach.generateJumpAction(programInfo.startGetMFlag));
        ret.push(Teach.generateFlagAction(programInfo.checkMBFlag, qsTr("get material-B start")));
        ret.push(Teach.generateOutputAction(programInfo.mForGetM, IODefines.M_BOARD_0, 1, 32, 0)); // lock up material process
        ret.push(Teach.generateSyncBeginAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 0, gMBm0.configValue, gMBm0Spd.configValue, gMBm0Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, gMBm2.configValue, gMBm2Spd.configValue, gMBm2Delay.configValue));
        ret.push(Teach.generateSyncEndAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, gMBm1.configValue, gMBm1Spd.configValue, gMBm1Delay.configValue));
        ret.push(Teach.generateFlagAction(programInfo.startGetMFlag, qsTr("Begin to get material")));
        ret.push(Teach.generateOutputAction(programInfo.yForGetM, IODefines.VALVE_BOARD, 1, programInfo.yForGetM, gMVOnDelay.configValue));
        ret.push(Teach.generateCommentAction(qsTr("to back suck pos")));
        ret.push(Teach.generateSyncBeginAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 0, bSPm0.configValue, bSPm0Spd.configValue, bSPm0Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, bSPm1.configValue, bSPm1Spd.configValue, bSPm1Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, bSPm2.configValue, bSPm2Spd.configValue, bSPm2Delay.configValue));
        ret.push(Teach.generateSyncEndAction());
        ret.push(Teach.generateOutputAction(programInfo.yForRemoveM, IODefines.IO_BOARD_0, programInfo.yForGetM, rMVOnDelay.configValue));
        ret.push(Teach.generateCheckAction(programInfo.yForGetM, Teach.VALVE_CHECK_START, 0.00));
        ret.push(Teach.generateCommentAction(qsTr("Start to get product")));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, spm1.configValue, spm1Spd.configValue, spm1Delay.configValue));
        ret = ret.concat(syncActions([Teach.generateOutputAction(programInfo.mForGetM, IODefines.M_BOARD_0, 0, 32, 0),// lock up material process
                                      Teach.generateOutputAction(programInfo.yForVec, IODefines.VALVE_BOARD, 1, programInfo.yForVec, 0.00),
                                      Teach.generateOutputAction(programInfo.yForPosM, IODefines.VALVE_BOARD, 0, programInfo.yForPosM, 0.00),
                                      Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 0, gpm0.configValue, gpm0Spd.configValue, gpm0Delay.configValue),
                                      Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, spm2.configValue,spm2Spd.configValue, spm2Delay.configValue)
                                     ]));
        ret[ret.length - 5].customName = qsTr("Swich to gp pose");
        ret[ret.length - 4].customName = qsTr("Swich to p pos");
        ret.push(Teach.generateWaitAction(programInfo.xForMF, IODefines.IO_BOARD_0, 1, 30.00));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, gpm1.configValue, gpm1Spd.configValue, gpm1Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, gpm2.configValue, gpm2Spd.configValue, gpm2Delay.configValue));
        ret.push(Teach.generateOutputAction(programInfo.yForGetP, IODefines.VALVE_BOARD, 1, programInfo.yForGetP, gPVONDelay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, gFBm2.configValue, gFBm2Spd.configValue, gFBm2Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, spm1.configValue, spm1Spd.configValue, spm1Delay.configValue));
        ret.push(Teach.generateCheckAction(programInfo.yForGetP, Teach.VALVE_CHECK_START, 0.00));
        ret.push(Teach.generateOutputAction(programInfo.yForPosM, IODefines.VALVE_BOARD, 1, programInfo.yForPosM, 0.00));
        ret[ret.length - 1].customName = qsTr("Swich to m pos");
        ret.push(Teach.generateSyncBeginAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 0, rMPm0.configValue, rMPm0Spd.configValue, rMPm0Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, rMPm2.configValue, rMPm2Spd.configValue, rMPm2Delay.configValue));
        ret.push(Teach.generateSyncEndAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, rMPm1.configValue, rMPm1Spd.configValue, rMPm1Delay.configValue));
        ret.push(Teach.generateOutputAction(programInfo.yForGetM, IODefines.VALVE_BOARD, 0, programInfo.yForGetM, rMVOFFDelay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, rMFBm2.configValue, rMFBm2Spd.configValue, rMFBm2Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, spm1.configValue, spm1Spd.configValue, spm1Delay.configValue));
        ret.push(Teach.generateCheckAction(programInfo.yForGetM, Teach.VALVE_CHECK_END, 0.00));
        ret.push(Teach.generateCommentAction(qsTr("Start to release product")));
        ret.push(Teach.generateCallModuleAction(generateReleaseProductModule(releaseProductStack.getStackItem()), -1));
        ret.push(Teach.generteEndAction());

        ProgramFlowPage.instance.updateProgramModel(ProgramFlowPage.programs[0], ret);
        ProgramFlowPage.instance.onFixIndexTriggered();
        ProgramFlowPage.instance.hasModify = true;
        ProgramFlowPage.instance.saveProgram(programInfo.mainProgramID);
        generateUpMaterialProgram();
        ProgramFlowPage.instance.refreshFunctions();

    }
    Column{
        spacing: 4
        y:4
        ICButtonGroup{
            id:funSel
            isAutoSize: true
            mustChecked: true
            spacing: 40
            checkedIndex: 0
            ICCheckBox{
                id:actionInMold
                text: qsTr("In Mold")
                isChecked: true
            }
            ICCheckBox{
                id:releaseMaterial
                text: qsTr("Rel P")
            }
            ICCheckBox{
                id:getMaterial
                text:qsTr("Get M")
            }
            onButtonClickedID: {
                pageContainer.setCurrentIndex(index);
            }
        }
        Rectangle{
            id:horSplitLine
            height: 1
            color: "black"
            width: instance.width
        }
        ICStackContainer{
            id:pageContainer
            height: instance.height - funSel.height - horSplitLine.height - 90
            width: instance.width
            Component.onCompleted: {
                setCurrentIndex(addPage(inMoldPageContainer));
                addPage(releaseProductPageContainer);
                addPage(getMaterialPageContainer);
            }

            ICFlickable{
                id:inMoldPageContainer

                contentHeight: inMoldPageContent.height
                flickableDirection: Flickable.VerticalFlick
                Column{
                    id:inMoldPageContent
                    spacing: 4
                    Grid{
                        spacing: 4
                        columns: 6
                        Text {id:firstWidth;text: " ";width: 100}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: AxisDefine.axisInfos[0].name}
                        Text {text: AxisDefine.axisInfos[1].name}
                        Text {text: AxisDefine.axisInfos[2].name}

                        Text {text: qsTr("Standby Pos")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:spSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: setInHelper("sp");
                        }
                        ICConfigEdit{
                            id:spm0
                            configAddr: AxisDefine.axisInfos[0].rangeAddr
                        }
                        ICConfigEdit{
                            id:spm1
                            configAddr: AxisDefine.axisInfos[1].rangeAddr
                        }
                        ICConfigEdit{
                            id:spm2
                            configAddr: AxisDefine.axisInfos[2].rangeAddr
                        }

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:spm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:spm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:spm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:spm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:spm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:spm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }

                        Text {text: qsTr("Get Pos")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:gpSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: setInHelper("gp")
                        }
                        ICConfigEdit{
                            id:gpm0
                            configAddr: AxisDefine.axisInfos[0].rangeAddr
                        }
                        ICConfigEdit{
                            id:gpm1
                            configAddr: AxisDefine.axisInfos[1].rangeAddr
                        }
                        ICConfigEdit{
                            id:gpm2
                            configAddr: AxisDefine.axisInfos[2].rangeAddr
                        }

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gpm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gpm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gpm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gpm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gpm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gpm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }

                        Text {text: qsTr("Get PV On Delay")}
                        Text {text: qsTr("(s)")}
                        ICConfigEdit{
                            id:gPVONDelay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                    }
                    Row{
                        Text {
                            id:getProductVTitle
                            text: qsTr("Get Pro V")
                            width: gpSetIn.x
                        }
                        ICValveSelComponent{
                            id:getProductVSel
                            valvesToSel: ["valve1", "valve2", "valve3", "valve4"]
                            width: inMoldPageContainer.width - getProductVTitle.width - 10
                        }
                        visible: false
                    }
                    Grid{
                        spacing: 4
                        columns: 6

                        Text {text: qsTr("Get F B"); width: firstWidth.width}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:gFBSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: {
                                gFBm2.configValue = (panelRobotController.statusValue("c_ro_0_32_0_913") / 1000).toFixed(3);
                            }
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm2
                            configAddr: AxisDefine.axisInfos[2].rangeAddr
                        }

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }

                        Text {text: qsTr("Rel M Pos")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:rMPSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: setInHelper("rMP")
                        }
                        ICConfigEdit{
                            id:rMPm0
                            configAddr: AxisDefine.axisInfos[0].rangeAddr
                        }
                        ICConfigEdit{
                            id:rMPm1
                            configAddr: AxisDefine.axisInfos[1].rangeAddr
                        }
                        ICConfigEdit{
                            id:rMPm2
                            configAddr: AxisDefine.axisInfos[2].rangeAddr
                        }

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMPm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:rMPm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:rMPm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMPm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:rMPm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:rMPm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }

                        Text {text: qsTr("Rel M OFF Delay")}
                        Text {text: qsTr("(s)")}
                        ICConfigEdit{
                            id:rMVOFFDelay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}

                        Text {text: qsTr("Rel M F B")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:rMFBSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: {
                                rMFBm2.configValue = (panelRobotController.statusValue("c_ro_0_32_0_913") / 1000).toFixed(3);
                            }
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm2
                            configAddr: AxisDefine.axisInfos[2].rangeAddr
                        }

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                    }
                }
            }

            ICFlickable{
                id:releaseProductPageContainer
                contentHeight: releaseProductPageContent.height
                flickableDirection: Flickable.VerticalFlick
                Column{
                    spacing: 6
                    id:releaseProductPageContent
                    Item {
                        width: 50
                        height: 50
                    }

                    StackActionEditorComponent{
                        id:releaseProductStack
                        isCounterEn: false
                    }
                    Row{
                        spacing: 6
                        ICConfigEdit{
                            id:relPSpdm0
                            configName: qsTr("Rel P SPD") + AxisDefine.axisInfos[0].name
                            configAddr: "s_rw_0_32_1_1200"
                            unit: qsTr("%")
//                            visible: false
                        }
                        ICConfigEdit{
                            id:relPSpdm1
                            configName: qsTr("Rel P SPD ") + AxisDefine.axisInfos[1].name
                            configAddr: "s_rw_0_32_1_1200"
                            unit: qsTr("%")
//                            visible: false

                        }
                        ICConfigEdit{
                            id:relPSpdm2
                            configName: qsTr("Rel P SPD m2") + AxisDefine.axisInfos[2].name
                            configAddr: "s_rw_0_32_1_1200"
                            unit: qsTr("%")
//                            visible: false

                        }
                        ICConfigEdit{
                            id:relPSpd
                            configName: qsTr("Rel P SPD")
                            configAddr: "s_rw_0_32_1_1200"
                            unit: qsTr("%")
                            visible: false
                        }
                    }
                    ICConfigEdit{
                        id:gPVOFFDelay
                        configAddr: "s_rw_0_32_2_1100"
                        configName: qsTr("Get PV Off Delay")
                        unit: "s"
                    }
                }
            }

            ICFlickable{
                id:getMaterialPageContainer
                contentHeight: getMaterialPageContent.height
                flickableDirection: Flickable.VerticalFlick
                Column{
                    spacing: 6
                    id:getMaterialPageContent

                    Grid{
                        spacing: 4
                        columns: 7
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: AxisDefine.axisInfos[0].name}
                        Text {text: AxisDefine.axisInfos[1].name}
                        Text {text: AxisDefine.axisInfos[2].name}
                        Text {text: AxisDefine.axisInfos[3].name}

                        Text {text: qsTr("Get M A"); width: firstWidth.width}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:gMASetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: setInHelper("gmA")
                        }
                        ICConfigEdit{
                            id:gMAm0
                            configAddr: AxisDefine.axisInfos[0].rangeAddr
                        }
                        ICConfigEdit{
                            id:gMAm1
                            configAddr: AxisDefine.axisInfos[1].rangeAddr
                        }
                        ICConfigEdit{
                            id:gMAm2
                            configAddr: AxisDefine.axisInfos[2].rangeAddr
                        }
                        Text {text: " "}

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gMAm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gMAm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gMAm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        Text {text: " "}


                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gMAm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gMAm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gMAm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}


                        Text {text: qsTr("Get M B"); width: firstWidth.width}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:gMBSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: setInHelper("gMB")
                        }
                        ICConfigEdit{
                            id:gMBm0
                            configAddr: AxisDefine.axisInfos[0].rangeAddr
                        }
                        ICConfigEdit{
                            id:gMBm1
                            configAddr: AxisDefine.axisInfos[1].rangeAddr
                        }
                        ICConfigEdit{
                            id:gMBm2
                            configAddr: AxisDefine.axisInfos[2].rangeAddr
                        }
                        Text {text: " "}


                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gMBm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gMBm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gMBm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        Text {text: " "}


                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gMBm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gMBm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gMBm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}

                        Text {text: qsTr("Get M V On Delay")}
                        Text {text: qsTr("s")}
                        ICConfigEdit{
                            id:gMVOnDelay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}


                        Text {text: qsTr("B S P"); width: firstWidth.width}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:bSPSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: setInHelper("bSP")
                        }
                        ICConfigEdit{
                            id:bSPm0
                            configAddr: AxisDefine.axisInfos[0].rangeAddr
                        }
                        ICConfigEdit{
                            id:bSPm1
                            configAddr: AxisDefine.axisInfos[1].rangeAddr
                        }
                        ICConfigEdit{
                            id:bSPm2
                            configAddr: AxisDefine.axisInfos[2].rangeAddr
                        }
                        Text {text: " "}


                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:bSPm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:bSPm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:bSPm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        Text {text: " "}


                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:bSPm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:bSPm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:bSPm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}

                        Text {text: qsTr("R M V On Delay")}
                        Text {text: qsTr("s")}
                        ICConfigEdit{
                            id:rMVOnDelay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}

                        Text {text: qsTr("Up M Pos"); width: firstWidth.width}
                        Text {text: "(" + AxisDefine.axisInfos[3].unit + ")"}
                        ICButton{
                            id:uMPSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                            onButtonClicked: {
                                uMPm3.configValue = (panelRobotController.statusValue("c_ro_0_32_0_913") / 1000).toFixed(3);

                            }
                        }
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:uMPm3
                            configAddr: AxisDefine.axisInfos[3].rangeAddr
                        }


                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:uMPm3Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                    }


                    Row{
                        Text {
                            id:getMaterialVTitle
                            text: qsTr("Get Pro V")
                            width: gpSetIn.x
                        }
                        ICValveSelComponent{
                            id:getMaterialVSel
                            valvesToSel: ["valve1", "valve2", "valve3", "valve4"]
                            width: inMoldPageContainer.width - getMaterialVTitle.width - 10
                        }
                        visible: false
                    }
                }
            }
        }
    }

    function initPosHelper(posName, data){
        this[posName + "m0"].configValue = data.pos.m0;
        this[posName + "m1"].configValue = data.pos.m1;
        this[posName + "m2"].configValue = data.pos.m2;
        this[posName + "m0Spd"].configValue = data.spd.m0;
        this[posName + "m1Spd"].configValue = data.spd.m1;
        this[posName + "m2Spd"].configValue = data.spd.m2;
        this[posName + "m0Delay"].configValue = data.dly.m0;
        this[posName + "m1Delay"].configValue = data.dly.m1;
        this[posName + "m2Delay"].configValue = data.dly.m2;
    }

    function setInHelper(posName){
        this[posName + "m0"].configValue = (panelRobotController.statusValue("c_ro_0_32_0_901") / 1000).toFixed(3);
        this[posName + "m1"].configValue = (panelRobotController.statusValue("c_ro_0_32_0_905") / 1000).toFixed(3);
        this[posName + "m2"].configValue = (panelRobotController.statusValue("c_ro_0_32_0_909") / 1000).toFixed(3);
    }

    onVisibleChanged:{
        if(visible){
            var moldExtentData = ProgramFlowPage.moldExtentData;
            var defaultSPD = "80.0";
            var defaultPOS = "0.000";
            var defaultAxisDly = "0.00";
            var defaultValveDly = "0.50";
            if(moldExtentData === undefined ||
                    moldExtentData === null ||
                    moldExtentData === ""){
                var releaseProductCounter = Teach.counterManager.getCounter(programInfo.releaseProductStackCounterID);
                if(releaseProductCounter === null){
                    releaseProductCounter = Teach.counterManager.newCounter(qsTr("Release Product Stack"), 0, 0);
                }
                moldExtentData = {
                    "standbyPos":{
                        "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":defaultPOS},
                        "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":defaultSPD},
                        "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":defaultAxisDly},
                    },
                    "getProductPos":{
                        "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":defaultPOS},
                        "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":defaultSPD},
                        "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":defaultAxisDly},
                    },
                    "getProductValveOnDly":defaultValveDly,
                    "getProductBackPos":{
                        "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":defaultPOS},
                        "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":defaultSPD},
                        "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":defaultAxisDly},
                    },
                    "releaseMaterialPos":{
                        "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":defaultPOS},
                        "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":defaultSPD},
                        "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":defaultAxisDly},
                    },
                    "releaseMaterialValveOffDly":defaultValveDly,
                    "releaseMaterialBackPos":{
                        "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":defaultPOS},
                        "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":defaultSPD},
                        "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":defaultAxisDly},
                    },
                    "releaseProductStackInfo":{
                        "m0pos" : defaultPOS ,
                        "m1pos" : defaultPOS ,
                        "m2pos" : defaultPOS ,
                        "m3pos" : defaultPOS ,
                        "m4pos" : defaultPOS ,
                        "m5pos" : defaultPOS ,
                        "space0" : defaultPOS ,
                        "space1" : defaultPOS ,
                        "space2" : defaultPOS ,
                        "count0" : 0 ,
                        "count1" : 0 ,
                        "count2" : 0 ,
                        "sequence" : 0 ,
                        "dir0" : 0 ,
                        "dir1" : 0 ,
                        "dir2" : 0 ,
                        "doesBindingCounter" : true ,
                        "counterID" : 0 ,
                        "isOffsetEn" : false,
                        "isZWithYEn" : false,
                        "offsetX" : defaultPOS ,
                        "offsetY" : defaultPOS ,
                        "offsetZ" : defaultPOS ,
                        "dataSourceName" : "",
                        "dataSourceID" : -1,
                        "runSeq" : 3
                    },
                    "releaseProductSPD":{"all":defaultSPD, "m0":defaultSPD, "m1":defaultSPD, "m2":defaultSPD},
                    "getProductValveOffDelay":defaultValveDly,
                    "getMaterialAPos":{
                        "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":defaultPOS},
                        "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":defaultSPD},
                        "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":defaultAxisDly},
                    },
                    "getMaterialBPos":{
                        "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":defaultPOS},
                        "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":defaultSPD},
                        "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":defaultAxisDly},
                    },
                    "getMaterialValveOnDly":defaultValveDly,
                    "removeMaterialPos":{
                        "pos":{"m0":defaultPOS,"m1":defaultPOS, "m2":defaultPOS},
                        "spd":{"m0":defaultSPD,"m1":defaultSPD, "m2":defaultSPD},
                        "dly":{"m0":defaultAxisDly,"m1":defaultAxisDly, "m2":defaultAxisDly},
                    },
                    "removeMaterialValveOnDly":defaultValveDly,
                    "upMaterialPos":{
                        "pos":{"m3":defaultPOS},
                        "spd":{"m3":defaultSPD},
                        "dly":{"m3":defaultAxisDly},
                    },
                }
            }

            initPosHelper("sp", moldExtentData.standbyPos);
            initPosHelper("gp", moldExtentData.getProductPos);
            gPVONDelay.configValue = moldExtentData.getProductValveOnDly;
            gFBm2.configValue = moldExtentData.getProductBackPos.pos.m2;
            gFBm2Spd.configValue = moldExtentData.getProductBackPos.spd.m2;
            gFBm2Delay.configValue = moldExtentData.getProductBackPos.dly.m2;
            initPosHelper("rMP", moldExtentData.releaseMaterialPos);
            rMVOFFDelay.configValue = moldExtentData.releaseMaterialValveOffDly;
            rMFBm2.configValue = moldExtentData.releaseMaterialBackPos.pos.m2;
            rMFBm2Spd.configValue = moldExtentData.releaseMaterialBackPos.spd.m2;
            rMFBm2Delay.configValue = moldExtentData.releaseMaterialBackPos.dly.m2;

            releaseProductStack.motor0 = moldExtentData.releaseProductStackInfo.m0pos;
            releaseProductStack.motor1 = moldExtentData.releaseProductStackInfo.m1pos;
            releaseProductStack.motor2 = moldExtentData.releaseProductStackInfo.m2pos;
            releaseProductStack.motor3 = moldExtentData.releaseProductStackInfo.m3pos;
            releaseProductStack.motor4 = moldExtentData.releaseProductStackInfo.m4pos;
            releaseProductStack.motor5 = moldExtentData.releaseProductStackInfo.m5pos;
            releaseProductStack.space0 = moldExtentData.releaseProductStackInfo.space0;
            releaseProductStack.space1 = moldExtentData.releaseProductStackInfo.space1;
            releaseProductStack.space2 = moldExtentData.releaseProductStackInfo.space2;
            releaseProductStack.count0 = moldExtentData.releaseProductStackInfo.count0;
            releaseProductStack.count1 = moldExtentData.releaseProductStackInfo.count1;
            releaseProductStack.count2 = moldExtentData.releaseProductStackInfo.count2;
            releaseProductStack.dir0 = moldExtentData.releaseProductStackInfo.dir0;
            releaseProductStack.dir1 = moldExtentData.releaseProductStackInfo.dir1;
            releaseProductStack.dir2 = moldExtentData.releaseProductStackInfo.dir2;
            releaseProductStack.seq = moldExtentData.releaseProductStackInfo.sequence;
            releaseProductStack.doesBindingCounter = moldExtentData.releaseProductStackInfo.doesBindingCounter;
            //            releaseProductStack.updateCounters();
            releaseProductStack.setCounterID(moldExtentData.releaseProductStackInfo.counterID);
            releaseProductStack.isOffsetEn = moldExtentData.releaseProductStackInfo.isOffsetEn;
            releaseProductStack.isZWithYEn = moldExtentData.releaseProductStackInfo.isZWithYEn;
            releaseProductStack.offsetX = moldExtentData.releaseProductStackInfo.offsetX;
            releaseProductStack.offsetY = moldExtentData.releaseProductStackInfo.offsetY;
            releaseProductStack.offsetZ = moldExtentData.releaseProductStackInfo.offsetZ;
            releaseProductStack.dataSourceName = moldExtentData.releaseProductStackInfo.dataSourceName;
            //            releaseProductStack.dataSource = moldExtentData.releaseProductStackInfo.dataSourceID;
            releaseProductStack.runSeq = moldExtentData.releaseProductStackInfo.runSeq;
            relPSpd.configValue = moldExtentData.releaseProductSPD.all;
            relPSpdm0.configValue = moldExtentData.releaseProductSPD.m0;
            relPSpdm1.configValue = moldExtentData.releaseProductSPD.m1;
            relPSpdm2.configValue = moldExtentData.releaseProductSPD.m2;
            gPVOFFDelay.configValue = moldExtentData.getProductValveOffDelay;
            initPosHelper("gMA", moldExtentData.getMaterialAPos);
            initPosHelper("gMB", moldExtentData.getMaterialBPos);
            gMVOnDelay.configValue = moldExtentData.getMaterialValveOnDly;
            initPosHelper("bSP", moldExtentData.removeMaterialPos);
            rMVOnDelay.configValue = moldExtentData.removeMaterialValveOnDly;
            uMPm3.configValue = moldExtentData.upMaterialPos.pos.m3;
            uMPm3Spd.configValue = moldExtentData.upMaterialPos.spd.m3;
            //            gpm0.configValue = moldExtentData.getProductPos.pos.m0;
            //            gpm1.configValue = moldExtentData.getProductPos.pos.m1;
            //            gpm2.configValue = moldExtentData.getProductPos.pos.m1;
            //            gpm2Spd.configValue = moldExtentData.getProductPos.spd.m2;
            //            gpm1Spd.configValue = moldExtentData.getProductPos.spd.m1;
            //            gpm2Spd.configValue = moldExtentData.getProductPos.spd.m2;
        }
    }
}
