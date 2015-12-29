import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../../utils/utils.js" as Utils

Rectangle {
    property int stackType: 0
    property int currentPage: 0
    property int pageCount: 2
    function createActionObjects(){
        var ret = [];
        if(useFlag.isChecked){
            var statckStr = stackSelector.configText;
            if(statckStr.currentIndex < 0) return ret;
            var begin = statckStr.indexOf('[') + 1;
            var end = statckStr.indexOf(']');
            ret.push(Teach.generateStackAction(statckStr.slice(begin, end), speed0.configValue, speed1.configValue));
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
    onStackTypeChanged: {
        pageCount = (stackType == 1 ? 3 : 2);
    }

    Row{
        id:navContainer
        x:630
        y:40
        spacing: 2
        Rectangle{
            id:navLine
            width: 1
            height: 150
            color: "gray"
        }

        ICButton{
            id:changePage
            width: 40
            height: navLine.height
            bgColor: "yellow"
            text: "-->"
            visible: defineStack.isChecked
            onButtonClicked: {
                ++currentPage;
                currentPage %= pageCount;
                if(currentPage == (pageCount - 1)){
                    text = "<--"
                    detailPage.visible  = true;
                    typeSelector.visible = false;

                }else if(currentPage == 0){
                    text = "-->"
                    detailPage.visible  = false;
                    typeSelector.visible = true;
                }
                else{
                    text = "-->"
                    detailPage.visible  = true;
                    typeSelector.visible = false;
                }

            }
        }
    }

    ICComboBox{
        id:stackViewSel
        z: 11
        y:topContainer.y
        x:200
        visible: defineStack.isChecked
        popupWidth: 200
        width: currentIndex == 0 ? 80 : popupWidth
        onCurrentIndexChanged: {
            if(currentIndex < 0 ) return;
            var si0, si1;
            var stackInfo;
            if(currentIndex == 0){
                si0 = new Teach.StackItem();
                si1 = new Teach.StackItem();
                stackInfo = new Teach.StackInfo(si0, si1,stackType, "");
            }else{
                stackInfo = Teach.getStackInfoFromID(parseInt(Utils.getValveFromBrackets(items[currentIndex])));
            }
            page1.motor0 = stackInfo.si0.m0pos;
            page1.motor1 = stackInfo.si0.m1pos;
            page1.motor2 = stackInfo.si0.m2pos;
            page1.motor3 = stackInfo.si0.m3pos;
            page1.motor4 = stackInfo.si0.m4pos;
            page1.motor5 = stackInfo.si0.m5pos;
            page1.space0 = stackInfo.si0.space0;
            page1.space1 = stackInfo.si0.space1;
            page1.space2 = stackInfo.si0.space2;
            page1.count0 = stackInfo.si0.count0;
            page1.count1 = stackInfo.si0.count1;
            page1.count2 = stackInfo.si0.count2;
            page1.seq = stackInfo.si0.sequence;
            page1.dir0 = stackInfo.si0.dir0;
            page1.dir1 = stackInfo.si0.dir1;
            page1.dir2 = stackInfo.si0.dir2;
            page1.doesBindingCounter = stackInfo.si0.doesBindingCounter;
            page1.setCounterID(stackInfo.si0.counterID);

            page2.motor0 = stackInfo.si1.m0pos;
            page2.motor1 = stackInfo.si1.m1pos;
            page2.motor2 = stackInfo.si1.m2pos;
            page2.motor3 = stackInfo.si1.m3pos;
            page2.motor4 = stackInfo.si1.m4pos;
            page2.motor5 = stackInfo.si1.m5pos;
            page2.space0 = stackInfo.si1.space0;
            page2.space1 = stackInfo.si1.space1;
            page2.space2 = stackInfo.si1.space2;
            page2.count0 = stackInfo.si1.count0;
            page2.count1 = stackInfo.si1.count1;
            page2.count2 = stackInfo.si1.count2;
            page2.seq = stackInfo.si1.sequence;
            page2.dir0 = stackInfo.si1.dir0;
            page2.dir1 = stackInfo.si1.dir1;
            page2.dir2 = stackInfo.si1.dir2;
            page2.doesBindingCounter = stackInfo.si1.doesBindingCounter;
            page2.setCounterID(stackInfo.si1.counterID);

            stackType = stackInfo.type;
        }
    }


    Item{
        id:topContainer
        height: flagPageSel.height
        ICButtonGroup{
            id:flagPageSel
            spacing: 10
            mustChecked: true
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

        ICConfigEdit{
            id:stackDescr
            x:300;
            configName: qsTr("Stack")
            inputWidth: 200
            isNumberOnly: false
            visible: (stackViewSel.currentIndex === 0) && (defineStack.isChecked)

        }

        ICButton{
            id:save
            anchors.left: stackDescr.right
            anchors.leftMargin: 6
            visible: defineStack.isChecked
            text: qsTr("Save")
            height: stackDescr.height
            width: 60
            onButtonClicked: {
                var si0 = new Teach.StackItem(page1.motor0 || 0.000,
                                              page1.motor1 || 0.000,
                                              page1.motor2 || 0.000,
                                              page1.motor3 || 0.000,
                                              page1.motor4 || 0.000,
                                              page1.motor5 || 0.000,
                                              page1.space0 || 0.000,
                                              page1.space1 || 0.000,
                                              page1.space2 || 0.000,
                                              page1.count0 || 0,
                                              page1.count1 || 0,
                                              page1.count2 || 0,
                                              page1.seq,
                                              page1.dir0,
                                              page1.dir1,
                                              page1.dir2,
                                              page1.realDoesBindingCounter(),
                                              page1.counterID());
                var si1 = new Teach.StackItem(page2.motor0 || 0.000,
                                              page2.motor1 || 0.000,
                                              page2.motor2 || 0.000,
                                              page2.motor3 || 0.000,
                                              page2.motor4 || 0.000,
                                              page2.motor5 || 0.000,
                                              page2.space0 || 0.000,
                                              page2.space1 || 0.000,
                                              page2.space2 || 0.000,
                                              page2.count0 || 0,
                                              page2.count1 || 0,
                                              page2.count2 || 0,
                                              page2.seq,
                                              page2.dir0,
                                              page2.dir1,
                                              page2.dir2,
                                              page2.realDoesBindingCounter(),
                                              page2.counterID());
                var stackInfo = new Teach.StackInfo(si0, si1, stackType, stackDescr.configValue);
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
            anchors.left: save.right
            anchors.leftMargin: 6
            visible: defineStack.isChecked
            text: qsTr("Delete")
            height: stackDescr.height
            width: save.width
            onButtonClicked: {
                if(stackViewSel.currentIndex === 0) return;
                Teach.delStack(parseInt(Utils.getValveFromBrackets(stackViewSel.currentText)));
                panelRobotController.saveStacks(Teach.statcksToJSON());
                updateStacksSel();
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
                    text: qsTr("Normal")
                    height: parent.height
                    width: parent.height
                    bgColor: stackType == 0 ? "lime" : "white"
                    onButtonClicked: {
                        stackType = 0;
                        pageCount = 2;
                    }
                }
                ICButton{
                    id:type2
                    text: qsTr("Box")
                    height: parent.height
                    width: parent.height
                    bgColor: stackType == 1 ? "lime" : "white"

                    onButtonClicked: {
                        stackType = 1;
                        pageCount = 3;

                    }
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
                Row{
                    id:menuContainer
                    spacing: 6
                    z:11
                    ICButton{
                        id:setIn
                        text: qsTr("Set In")
                        height: stackDescr.height
                        onButtonClicked: {
                            page1.motor0 = panelRobotController.statusValueText("c_ro_0_32_3_900");
                            page1.motor1 = panelRobotController.statusValueText("c_ro_0_32_3_904");
                            page1.motor2 = panelRobotController.statusValueText("c_ro_0_32_3_908");
                            page1.motor3 = panelRobotController.statusValueText("c_ro_0_32_3_912");
                            page1.motor4 = panelRobotController.statusValueText("c_ro_0_32_3_916");
                            page1.motor5 = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        }

                    }


                }

                Row{
                    anchors.left: menuContainer.right
                    anchors.leftMargin: 6
                    spacing: 6
                    y:menuContainer.y


                }

                StackActionEditorComponent{
                    anchors.top: menuContainer.bottom
                    anchors.topMargin: 4
                    x:menuContainer.x
                    id:page1
                    visible: currentPage == 1;
                }
                StackActionEditorComponent{
                    anchors.top: menuContainer.bottom
                    anchors.topMargin: 4
                    x:menuContainer.x
                    id:page2
                    visible: currentPage == 2;
                    mode: 1
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
            id:speed0
            visible: useFlag.isChecked
            configName: qsTr("Speed0")
            configAddr: "s_rw_0_16_1_265"
            unit: "%"
        }
        ICConfigEdit{
            id:speed1
            visible: useFlag.isChecked
            configName: qsTr("Speed1")
            configAddr: "s_rw_0_16_1_265"
            unit: "%"
        }
    }
    Component.onCompleted: {
        updateStacksSel();
        panelRobotController.moldChanged.connect(updateStacksSel);

    }
}
