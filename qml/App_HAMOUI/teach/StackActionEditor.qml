import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../../utils/utils.js" as Utils

Rectangle {
    function createActionObjects(){
        var ret = [];
        if(useFlag.isChecked){
            var statckStr = stackSelector.configText;
            if(statckStr.currentIndex < 0) return ret;
            var begin = statckStr.indexOf('[') + 1;
            var end = statckStr.indexOf(']');
            ret.push(Teach.generateStackAction(statckStr.slice(begin, end), speed.configValue));
        }
        return ret;
    }
    function updateStacksSel(){
        Teach.parseStacks(panelRobotController.stacks());
        stackSelector.items =  Teach.stackInfosDescr()
        var hasStacks = Teach.stackInfosDescr();
        hasStacks.splice(0, 0, qsTr("New"));
        stackViewSel.currentIndex = -1;
        stackViewSel.items = hasStacks;
        stackViewSel.currentIndex = 0;

    }

    Row{
        id:topContainer
        spacing: 20
        ICButtonGroup{
            id:flagPageSel
            spacing: 10
            ICCheckBox{
                id:defineStack
                text: qsTr("Define Stack")
                isChecked: true
            }
            ICCheckBox{
                id:useFlag
                text: qsTr("Use Stack")
            }
        }

        ICButton{
            id:changePage
            text: "-->"
            height: defineStack.height
            visible: defineStack.isChecked
            onButtonClicked: {
                if(!detailPage.visible){
                    text = "<--"
                    detailPage.visible  = true;
                    typeSelector.visible = false;

                }else{
                    text = "-->"
                    detailPage.visible  = false;
                    typeSelector.visible = true;

                }

            }
        }
    }
    Column{
        anchors.top: topContainer.bottom
        anchors.topMargin: 6
        spacing: 4
        Column{
            spacing: 4
            visible: defineStack.isChecked

            Row{
                id:typeSelector
                spacing: 10
                height: 140
                visible: defineStack.isChecked
                //        layoutMode: 1
                ICButton{
                    id:type1
                    text: qsTr("Type1")
                    height: parent.height
                    width: parent.height
                }
                ICButton{
                    id:type2
                    text: qsTr("Type2")
                    height: parent.height
                    width: parent.height
                }
                ICButton{
                    id:type3
                    text: qsTr("Type3")
                    height: parent.height
                    width: parent.height
                }
            }
            Item{
                id:detailPage
                visible: false;
                Column{
                    spacing: 4
                    Row{
                        id:menuContainer
                        spacing: 6
                        z:11
                        ICButton{
                            id:setIn
                            text: qsTr("Set In")
                            height: stackDescr.height
                            onButtonClicked: {
                                motor0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                                motor1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                                motor2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                                motor3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                                motor4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                                motor5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                            }

                        }
                        ICComboBox{
                            id:stackViewSel
                            z: 11
                            popupWidth: 200
                            width: currentIndex == 0 ? 80 : popupWidth
                            onCurrentIndexChanged: {
                                if(currentIndex < 0 ) return;
                                var stackInfo;
                                if(currentIndex == 0){
                                    stackInfo = new Teach.StackInfo(0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0,0,0,0,0,0,0,0,"");
                                }else{
                                    stackInfo = Teach.getStackInfoFromID(parseInt(Utils.getValveFromBrackets(items[currentIndex])));
                                }
                                motor0.configValue = stackInfo.m0pos;
                                motor1.configValue = stackInfo.m1pos;
                                motor2.configValue = stackInfo.m2pos;
                                motor3.configValue = stackInfo.m3pos;
                                motor4.configValue = stackInfo.m4pos;
                                motor5.configValue = stackInfo.m5pos;
                                space0.configValue = stackInfo.space0;
                                space1.configValue = stackInfo.space1;
                                space2.configValue = stackInfo.space2;
                                count0.configValue = stackInfo.count0;
                                count1.configValue = stackInfo.count1;
                                count2.configValue = stackInfo.count2;
                                seq.configValue = stackInfo.sequence;
                                dir0.configValue = stackInfo.dir0;
                                dir1.configValue = stackInfo.dir1;
                                dir2.configValue = stackInfo.dir2;



                            }
                        }

                        ICConfigEdit{
                            id:stackDescr
                            configName: qsTr("Stack")
                            inputWidth: 200
                            isNumberOnly: false
                            visible: stackViewSel.currentIndex === 0
                        }

                        ICButton{
                            id:save
                            text: qsTr("Save")
                            height: stackDescr.height
                            onButtonClicked: {
                                var stackInfo = new Teach.StackInfo(motor0.configValue || 0.000,
                                                                    motor1.configValue || 0.000,
                                                                    motor2.configValue || 0.000,
                                                                    motor3.configValue || 0.000,
                                                                    motor4.configValue || 0.000,
                                                                    motor5.configValue || 0.000,
                                                                    space0.configValue || 0.000,
                                                                    space1.configValue || 0.000,
                                                                    space2.configValue || 0.000,
                                                                    count0.configValue || 0,
                                                                    count1.configValue || 0,
                                                                    count2.configValue || 0,
                                                                    seq.configValue,
                                                                    dir0.configValue,
                                                                    dir1.configValue,
                                                                    dir2.configValue,
                                                                    0,
                                                                    stackDescr.configValue);
                                if(stackViewSel.currentIndex === 0){
                                    Teach.appendStackInfo(stackInfo);
                                    panelRobotController.saveStacks(Teach.statcksToJSON());
                                    updateStacksSel();
                                }
                                else{
                                    Teach.updateStackInfo(parseInt(Utils.getValveFromBrackets(stackViewSel.currentText)), stackInfo);
                                    panelRobotController.saveStacks(Teach.statcksToJSON());
                                }
                                //                                stackSelector.items = Teach.stackInfosDescr();
                            }
                        }
                        ICButton{
                            id:deleteStack
                            text: qsTr("Delete")
                            height: stackDescr.height
                            onButtonClicked: {
                                if(stackViewSel.currentIndex === 0) return;
                                Teach.delStack(parseInt(Utils.getValveFromBrackets(stackViewSel.currentText)));
                                panelRobotController.saveStacks(Teach.statcksToJSON());
                                updateStacksSel();
                            }

                        }

                    }

                    Row{
                        spacing: 4
                        Grid{
                            //                id:posContainer
                            columns: 2
                            spacing: 4
                            ICConfigEdit{
                                id:motor0
                                configName: AxisDefine.axisInfos[0].name
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100
                            }
                            ICConfigEdit{
                                id:motor1
                                configName: AxisDefine.axisInfos[1].name
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100

                            }
                            ICConfigEdit{
                                id:motor2
                                configName: AxisDefine.axisInfos[2].name
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100

                            }
                            ICConfigEdit{
                                id:motor3
                                configName: AxisDefine.axisInfos[3].name
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100

                            }
                            ICConfigEdit{
                                id:motor4
                                configName: AxisDefine.axisInfos[4].name
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100

                            }
                            ICConfigEdit{
                                id:motor5
                                configName: AxisDefine.axisInfos[5].name
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100
                            }

                        }

                        Grid{
                            columns: 2
                            spacing: 4
                            ICConfigEdit{
                                id:space0
                                configName: qsTr("Space0")
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100
                            }
                            ICConfigEdit{
                                id:count0
                                configName: qsTr("Count0")
                                configAddr: "s_rw_0_32_0_1400"
                                inputWidth: 100
                            }
                            ICConfigEdit{
                                id:space1
                                configName: qsTr("Space1")
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100
                            }
                            ICConfigEdit{
                                id:count1
                                configName: qsTr("Count1")
                                configAddr: "s_rw_0_32_0_1400"
                                inputWidth: 100
                            }
                            ICConfigEdit{
                                id:space2
                                configName: qsTr("Space2")
                                configAddr: "s_rw_0_32_3_1300"
                                inputWidth: 100

                            }
                            ICConfigEdit{
                                id:count2
                                configName: qsTr("Count2")
                                configAddr: "s_rw_0_32_0_1400"
                                inputWidth: 100
                            }
                        }
                    }

                    Row{
                        z:10
                        spacing: 4
                        ICComboBoxConfigEdit{
                            id:dir0
                            configName: qsTr("Dir0")
                            items: [qsTr("RP"), qsTr("PP")]
                            z:10
                            configValue: 0

                        }
                        ICComboBoxConfigEdit{
                            id:dir1
                            configName: qsTr("Dir1")
                            items: [qsTr("RP"), qsTr("PP")]
                            z:10
                            configValue: 0
                        }
                        ICComboBoxConfigEdit{
                            id:dir2
                            configName: qsTr("Dir2")
                            items: [qsTr("RP"), qsTr("PP")]
                            z:10
                            configValue: 0
                        }
                    }

                }
                ICComboBoxConfigEdit{
                    id:seq
                    y: 112
                    x:404
                    configName: qsTr("Sequence")
                    items: ["X->Y->Z","X->Z->Y", "Y->X->Z","Y->Z->X", "Z->X->Y", "Z->Y->X"]
                    popupMode: 1
                    z:13
                    configValue: 0
                }
            }
        }
        ICComboBoxConfigEdit{
            id:stackSelector
            visible: useFlag.isChecked
            configName: qsTr("Stack")
            inputWidth: 200
            z:10
        }
        ICConfigEdit{
            id:speed
            visible: useFlag.isChecked
            configName: qsTr("Speed")
            configAddr: "s_rw_0_16_1_265"
            unit: "%"
        }
    }
    Component.onCompleted: {
        updateStacksSel();
        panelRobotController.moldChanged.connect(updateStacksSel);

    }
}
