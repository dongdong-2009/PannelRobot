import QtQuick 1.1
import "../../ICCustomElement"
import "../teach/Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../teach"
import "../teach/ProgramFlowPage.js" as ProgramFlowPage
import "../configs/IODefines.js" as IODefines
Rectangle {
    id:instance

    function showActionEditorPanel(){}
    function onInsertTriggered(){}
    function onDeleteTriggered(){}
    function onUpTriggered(){}
    function onDownTriggered(){}
    function onFixIndexTriggered(){}
    function onSaveTriggered(){
        var ret = [];
        var checkMAFlag = 0;
        var checkMBFlag = 1;
        var checkMMaxFlag = 2;
        var mForGetM = 0;
        var yForGetM = 013;
        var yForPosM = 015;
        ret.push(Teach.generateCommentAction("Reserve Data", null, ""));
        ret[0].insertedIndex = 0;
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, spm1.configValue, spm1Spd.configValue, spm1Delay.configValue));
        ret.push(Teach.generateOutputAction(yForPosM, IODefines.IO_BOARD_0, 1, 0.00));
        ret.push(Teach.generateConditionAction(0, 16, 0, 1, 0, checkMAFlag)); // check x030
        ret.push(Teach.generateConditionAction(0, 17, 0, 1, 0, checkMBFlag)); // check x031
        ret.push(Teach.generateMemCmpJumpAction(checkMMaxFlag, 3281027081, uMPm3.configValue, 2, 0)); // check < x2 max
        ret.push(Teach.generateCustomAlarmAction(5000)); // no material alarm
        ret.push(Teach.generateFlagAction(checkMAFlag, qsTr("get material-A start")));
        ret.push(Teach.generateOutputAction(mForGetM, IODefines.M_BOARD_0, 1, 32, 0)); // lock up material process
        ret.push(Teach.generateSyncBeginAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 0, gMAm0.configValue, gMAm0Spd.configValue, gMAm0Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, gMAm2.configValue, gMAm2Spd.configValue, gMAm2Delay.configValue));
        ret.push(Teach.generateSyncEndAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, gMAm1.configValue, gMAm1Spd.configValue, gMAm1Delay.configValue));
//        ret.push(Teach)
        ret.push(Teach.generateFlagAction(checkMBFlag, qsTr("get material-B start")));
        ret.push(Teach.generateOutputAction(yForGetM, IODefines.IO_BOARD_0, 1, yForGetM, gMAOnDelay.configValue));
        ret.push(Teach.generateSyncBeginAction());
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 0, bSPm0m0.configValue, bSPm0Spd.configValue, bSPm0Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 1, bSPm1.configValue, bSPm1Spd.configValue, bSPm1Delay.configValue));
        ret.push(Teach.generateAxisServoAction(Teach.actions.F_CMD_SINGLE, 2, bSPm2.configValue, bSPm2Spd.configValue, bSPm2Delay.configValue));
        ret.push(Teach.generateSyncEndAction());
        ret.push(Teach.generteEndAction());
        ProgramFlowPage.instance.updateProgramModel(ProgramFlowPage.programs[0], ret);
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
                        Text {id:firstWidth;text: " ";width: 80}
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
                        }
                        ICConfigEdit{
                            id:spm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:spm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:spm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
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
                        }
                        ICConfigEdit{
                            id:gpm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:gpm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:gpm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
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
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
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
                        }
                        ICConfigEdit{
                            id:rMPm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:rMPm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:rMPm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
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

                        Text {text: qsTr("Rel M F B")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:rMFBSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
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
                        }
                        ICConfigEdit{
                            id:gMAm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:gMAm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:gMAm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
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
                        }
                        ICConfigEdit{
                            id:gMBm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:gMBm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:gMBm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
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
                            id:gMAOnDelay
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
                        }
                        ICConfigEdit{
                            id:bSPm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:bSPm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:bSPm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
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

                        Text {text: qsTr("Up M Pos"); width: firstWidth.width}
                        Text {text: "(" + AxisDefine.axisInfos[3].unit + ")"}
                        ICButton{
                            id:uMPSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                        }
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:uMPm3
                            configAddr: AxisDefine.axisInfos[3].limitAddr
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
    //    Component.onStatusChanged: {
    //        console.log(errorString())
    //    }
}
