import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine
import "Teach.js" as LocalTeach
import "../teach/Teach.js" as BaseTeach
import "../teach/ManualProgramManager.js" as ManualProgramManager
import "../configs/IODefines.js" as IODefines

Item {
    id:container
    width: parent.width
    height: parent.height
    property int mode: 0
    property variant plane: [0, 1, 2]
    property variant actionObject: null
    property variant detailInstance: null
    property variant stackInstance: null
    property bool isauto: false

    onIsautoChanged: {
        if(isauto){
            planeSel.visible = false;
            dirAxisSel.visible = false;
            editaction.visible = false;
//            repeateCount.visible = false;
//            dirCount.visible = false;
            gunfresh1.visible = false;
            gunfresh2.visible = false;
        }
        else {
            planeSel.visible = true;
            dirAxisSel.visible = true;
            editaction.visible = false;true
//            repeateCount.visible = true;
//            dirCount.visible = true;
            gunfresh1.visible = true;
            gunfresh2.visible = true;
        }
    }

    function createActionObjects(){
        return createActionObj(null);
    }

    function createActionObj(actObt){
        var ret = [];
        if(actObt == null){
            var details = detailInstance.getDetails();
            var stack = stackInstance.getstackInstace();
        }
//        var rc = BaseTeach.counterManager.getCounter(0);
//        if(rc == null){
//            rc= BaseTeach.counterManager.newCounter("", 0, 50000);
//            panelRobotController.saveCounterDef(rc.id, rc.name, rc.current, rc.target);
//        }
//        var rotateCID = rc.id;
        var rotateCID = -1;
//        var c = BaseTeach.counterManager.newCounter("", 0, repeateCount.configValue);
//        var rcID = c.id;
        var rcID = -1;
//        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);

//        c = BaseTeach.counterManager.newCounter("", 0, dirCount.configValue);
//        var dirCID = c.id;
        var dirCID = -1;
//        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);

//        if(actObt == null)
//            c = BaseTeach.counterManager.newCounter("", 0, stack.xcount * stack.ycount);
//        else
//            c = BaseTeach.counterManager.newCounter("", 0, actObt.xcount * actObt.ycount);
//        var aaaa = stackCount = c.id;
         var aaaa = -1;
//        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);

//        c = BaseTeach.counterManager.newCounter("", 0, rotateCount.configValue);
//        var bbbb = c.id;
        var bbbb = -1;
//        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);

        if(actObt == null){
            if(stack.useStack)
                var newstack = newStack(null);
            else newstack = 0;
        }
        else{
            if(actObt.useStack)
                newstack = newStack(actObt);
            else newstack = 0;
        }
        if(actObt == null)
            ret.push(LocalTeach.generatePENTUAction(
                        mode, planeSel.configValue, pos1Container.getPoint(), details.spd0,
                        details.spd1, details.spd2, details.spd3, details.spd4, details.spd5,
                        repeateSpeed.configValue, repeateCount.configValue, zlength.configValue,
                        dirAxisSel.configValue, dirLength.configValue, dirSpeed.configValue,
                        dirCount.configValue, pos2Container.getPoint(), pos3Container.getPoint(),
                        rotate.configValue, rotateSpeed.configValue, rotateCount.configValue,
                        details.delay0, details.delay1, details.delay2, rcID, dirCID, rotateCID,
                        details.delay20, details.delay21, details.delay22, details.fixtureSwitch,
                        details.fixture1Switch, details.slope, gunFollowEn.isChecked,
                        aaaa,bbbb,editaction.configValue,
                        stack.useStack,stack.useDeviation,stack.turns,stack.stackSpeed,stack.xdeviation,
                        stack.ydeviation,stack.zdeviation,stack.xspace,stack.yspace,stack.zspace,
                        stack.xcount,stack.ycount,stack.zcount,stack.xdirection,stack.ydirection,
                        stack.zdirection,newstack,isGunBack.isChecked,
                        details.use0,details.use1,details.use2,details.use3,details.use4,details.use5));
        else
            ret.push(LocalTeach.generatePENTUAction(
                        actObt.mode, actObt.plane, actObt.startPos, actObt.startPosSpeed0, actObt.startPosSpeed1,
                        actObt.startPosSpeed2, actObt.startPosSpeed3, actObt.startPosSpeed4, actObt.startPosSpeed5,
                        actObt.repeateSpeed, actObt.repeateCount, actObt.zlength, actObt.dirAxis, actObt.dirLength, actObt.dirSpeed,
                        actObt.dirCount, actObt.point1, actObt.point2, actObt.rotate, actObt.rotateSpeed, actObt.rotateCount,
                        actObt.fixtureDelay0, actObt.fixtureDelay1, actObt.fixtureDelay2, rcID, dirCID, rotateCID,
                        actObt.fixture2Delay0, actObt.fixture2Delay1, actObt.fixture2Delay2, actObt.fixture1Switch, actObt.fixture2Switch,
                        actObt.slope, actObt.gunFollowEn,aaaa,bbbb,actObt.editaction,
                        actObt.useStack,actObt.useDeviation,actObt.turns,actObt.stackSpeed,actObt.xdeviation,actObt.ydeviation,
                        actObt.zdeviation,actObt.xspace,actObt.yspace,actObt.zspace,actObt.xcount,actObt.ycount,
                        actObt.zcount,actObt.xdirection,actObt.ydirection,actObt.zdirection,newstack,actObt.isGunBack,
                        actObt.gun1use0,actObt.gun1use1,actObt.gun1use2,actObt.gun2use0,actObt.gun2use1,actObt.gun2use2));
        return ret;
    }

    function newStack(actObt){
        var sid = LocalTeach.useableStack();
        if(actObt == null){
            var stack = stackInstance.getstackInstace();
            var si0 = new LocalTeach.StackItem(sPosM0.configValue || 0.000,
                                          sPosM1.configValue || 0.000,
                                          sPosM2.configValue || 0.000,
                                          sPosM3.configValue || 0.000,
                                          sPosM4.configValue || 0.000,
                                          sPosM5.configValue || 0.000,
                                          stack.xspace || 0.000,
                                          stack.yspace || 0.000,
                                          stack.zspace || 0.000,
                                          stack.xcount || 0,
                                          stack.ycount || 0,
                                          stack.zcount || 0,
                                          stack.turns,
                                          stack.xdirection,
                                          stack.ydirection,
                                          stack.zdirection,
                                          true,
                                          aaaa,
                                          stack.useDeviation,
                                          stack.xdeviation,
                                          stack.ydeviation,
                                          stack.zdeviation,
                                          "custompoint[" + sid + "]",
                                          sid);
        }
        else
            si0 = new LocalTeach.StackItem(actObt.startPos.sPosM0.configValue || 0.000,
                                          actObt.startPos.sPosM1.configValue || 0.000,
                                          actObt.startPos.sPosM2.configValue || 0.000,
                                          actObt.startPos.sPosM3.configValue || 0.000,
                                          actObt.startPos.sPosM4.configValue || 0.000,
                                          actObt.startPos.sPosM5.configValue || 0.000,
                                          actObt.xspace || 0.000,
                                          actObt.yspace || 0.000,
                                          actObt.zspace || 0.000,
                                          actObt.xcount || 0,
                                          actObt.ycount || 0,
                                          actObt.zcount || 0,
                                          actObt.turns,
                                          actObt.xdirection,
                                          actObt.ydirection,
                                          actObt.zdirection,
                                          true,
                                          actObt.aaaa,
                                          actObt.useDeviation,
                                          actObt.xdeviation,
                                          actObt.ydeviation,
                                          actObt.zdeviation,
                                          "custompoint[" + sid + "]",
                                          sid);
        var stackInfo = new LocalTeach.StackInfo(si0, si0, 0, "stack1", "custompoint[" + sid + "]", sid, []);
        sid = LocalTeach.appendStackInfo(stackInfo);
        panelRobotController.saveStacks(LocalTeach.stacksToJSON());
        return sid;
    }

    function updateActionObject(ao){
        ao.plane = planeSel.configValue;
        ao.dirAxis = dirAxisSel.configValue;
        ao.startPos = pos1Container.getPoint();
        ao.point1 = pos2Container.getPoint();
        ao.point2 = pos3Container.getPoint();

        ao.repeateSpeed = repeateSpeed.configValue;
        ao.dirSpeed = dirSpeed.configValue;
        ao.dirLength  = dirLength.configValue;
        ao.repeateCount = repeateCount.configValue;
        ao.zlength = zlength.configValue;
        ao.dirCount  = dirCount.configValue;
        ao.rotate = rotate.configValue;
        ao.rotateSpeed = rotateSpeed.configValue;
        ao.rotateCount = rotateCount.configValue;
        ao.isGunBack = isGunBack.isChecked;
        ao.editaction = editaction.configValue;

//        var c = BaseTeach.counterManager.getCounter(ao.dirCounterID);
//        BaseTeach.counterManager.updateCounter(c.id, c.name, c.current, ao.dirCount);
//        panelRobotController.saveCounterDef(c.id, c.name, c.current, ao.dirCount);
////        counterUpdated(c.id);

//        c = BaseTeach.counterManager.getCounter(ao.rotateCounterID);
//        BaseTeach.counterManager.updateCounter(c.id, c.name, c.current, ao.rotateCount);
//        panelRobotController.saveCounterDef(c.id, c.name, c.current, ao.rotateCount);
////        counterUpdated(c.id);

//        c = BaseTeach.counterManager.getCounter(ao.repeateCounterID);
//        BaseTeach.counterManager.updateCounter(c.id, c.name, c.current, ao.repeateCount);
//        panelRobotController.saveCounterDef(c.id, c.name, c.current, ao.repeateCount);
////        counterUpdated(c.id);
    }

    function setModeName(name){
        actionName.text = name;
    }
    function setPosName(name1,name2){
        button_setPos1.text = name1;
        button_setPos2.text = name2;
    }
    function gunFollowEnvisible(){
        gunFollowEn.visible  = false;       //do not use
//        if(mode < 4 || mode == 8)
//            gunFollowEn.visible  = false;
//        else{
//            if(planeSel.configValue == 0 && dirAxisSel.configValue == 0)
//                gunFollowEn.visible  = true;
//            else gunFollowEn.visible  = false;
//        }
    }
    function hideUselessEdit(){
        planeSel.visible = mode == 8 ? false : true;
        dirAxisSel.visible = mode == 8 ? false : true;
        editaction.visible = mode == 8 ? true : false;
        button_setPos1.visible = mode == 8 ? false : true;
//        pos1Axis1.visible = mode == 8 ? false : true;
//        pos1Axis2.visible = mode == 8 ? false : true;
        repeateSpeed.visible = mode == 8 ? false : true;
//        repeateCount.visible = mode == 8 ? false : true;
//        zlength.visible = mode == 8 ? false : true;
//        dirLength.visible = mode == 8 ? false : true;
        dirSpeed.visible = mode == 8 || mode == 6 || mode == 9 ? false : true;
    }
    function hidePoint(mode){
        if(mode == 8){
            pos1Axis1.visible = false;
            pos1Axis2.visible = false;
            pos2Axis1.visible = false;
            pos2Axis2.visible = false;
        }
        else if(mode == 6){
            pos1Axis1.visible = true;
            pos1Axis2.visible = true;
            pos2Axis1.visible = false;
            pos2Axis2.visible = false;
        }
        else if(mode == 9){
            if(dirAxisSel.configValue == 0){
                pos1Axis1.visible = true;
                pos1Axis2.visible = false;
                pos2Axis1.visible = false;
                pos2Axis2.visible = true;
            }
            else {
                pos1Axis1.visible = false;
                pos1Axis2.visible = true;
                pos2Axis1.visible = true;
                pos2Axis2.visible = false;
            }
        }
        else{
            if(dirAxisSel.configValue == 0){
                pos1Axis1.visible = false;
                pos1Axis2.visible = true;
                pos2Axis1.visible = true;
                pos2Axis2.visible = false;
            }
            else {
                pos1Axis1.visible = true;
                pos1Axis2.visible = false;
                pos2Axis1.visible = false;
                pos2Axis2.visible = true;
            }
        }

    }

    function onProgramAdded(program){
        resetItems();
    }

    function onProgramChanged(program){
        resetItems();
    }

    function onProgramRemoved(programID){
        resetItems();
    }

    function resetItems(){
        var ret = [];
        editaction.configValue = -1;
        editaction.items = ManualProgramManager.manualProgramManager.programsNameList();
    }

    Column{
        id:configContainer
        property int posNameWidth: 60
        spacing: 4
        Row{
            id: row1
            spacing: 10
            z:10
            Text {
                id: actionName
                width: 200
                anchors.verticalCenter: parent.verticalCenter
                color: "green"
            }
            ICComboBoxConfigEdit{
                id:planeSel
//                enabled: !useEn.isChecked
                configName: qsTr("plane")
                items: ["XY", "XZ", "YZ"]
                //                configValue: 0
                onConfigValueChanged: {
//                    if(mode > 3 && configValue == 0 && dirAxisSel.configValue == 0)
//                        gunFollowEn.visible = true;
//                    else gunFollowEn.visible = false;
                    if(configValue == 0){
                        container.plane = [0, 1, 2];
                        pos1Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos1Axis2.configName = AxisDefine.axisInfos[1].name;
                        pos2Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos2Axis2.configName = AxisDefine.axisInfos[1].name;
                        dirAxisSel.items = ["X", "Y"];
                    }else if(configValue == 1){
                        plane = [0, 2, 1];
                        pos1Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos1Axis2.configName = AxisDefine.axisInfos[2].name;
                        pos2Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos2Axis2.configName = AxisDefine.axisInfos[2].name;
                        dirAxisSel.items = ["X", "Z"];
                    }else if(configValue == 2){
                        plane = [1, 2, 0];
                        pos1Axis1.configName = AxisDefine.axisInfos[1].name;
                        pos1Axis2.configName = AxisDefine.axisInfos[2].name;
                        pos2Axis1.configName = AxisDefine.axisInfos[1].name;
                        pos2Axis2.configName = AxisDefine.axisInfos[2].name;
                        dirAxisSel.items = ["Y", "Z"]
                    }
                    if(actionObject == null)
                        hidePoint(mode);
                    else hidePoint(actionObject.mode);
                }
            }

            ICComboBoxConfigEdit{
                id:dirAxisSel
                width: 200
//                enabled: !useEn.isChecked
                configName: mode == 9 ? qsTr("Repeat Axis") : qsTr("Dir Axis")
//                items: ["X", "Y", "Z"]
                onConfigValueChanged:{
//                    if(mode > 3 && configValue == 0 && planeSel.configValue == 0)
//                        gunFollowEn.visible = true;
//                    else gunFollowEn.visible = false;
                    if(actionObject == null)
                        hidePoint(mode);
                    else hidePoint(actionObject.mode);
                }
            }
            ICComboBoxConfigEdit{
                id: editaction
                visible: false
//                enabled: useEn.isChecked
                configName: qsTr("Actions")
            }
            ICCheckBox{
                id:isGunBack
                width: 60
                text: qsTr("Is Gun Back")
                isChecked: false
                useCustomClickHandler: true
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(!isGunBack.isChecked)
                            isGunBack.isChecked = true;
                        else isGunBack.isChecked = false;
                    }
                }
            }
        }
        Row{
            id:pos1Container
            spacing: 4
            function getPoint(){
                return {
                    "pointName":"",
                    "pos":{
                        "m0":sPosM0.configValue,
                        "m1":sPosM1.configValue,
                        "m2":sPosM2.configValue,
                        "m3":sPosM3.configValue,
                        "m4":sPosM4.configValue,
                        "m5":sPosM5.configValue
                    }
                };
            }
            ICButton{
                id:button_setStartPos
//                enabled: !useEn.isChecked
                text: qsTr("Set SPos")
                width: configContainer.posNameWidth + 10
                height: sPosM0.height
                anchors.verticalCenter: parent.verticalCenter
                bgColor: "lime"
                onButtonClicked: {
                    sPosM0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                    sPosM1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                    sPosM2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                    sPosM3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
//                    sPosM4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
//                    sPosM5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                    sPosM4.configValue = 0.000;
                    sPosM5.configValue = 0.000;
                }
            }
            ICConfigEdit{
                id:sPosM0
//                enabled: !useEn.isChecked
                width: 150
                configNameWidth: 28
                configName: AxisDefine.axisInfos[0].name
                unit: AxisDefine.axisInfos[0].unit
                configAddr: "s_rw_0_32_3_1000"
            }
            ICConfigEdit{
                id:sPosM1
//                enabled: !useEn.isChecked
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[1].name
                unit: AxisDefine.axisInfos[1].unit
                configAddr: "s_rw_0_32_3_1001"
            }
            ICConfigEdit{
                id:sPosM2
//                enabled: !useEn.isChecked
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[2].name
                unit: AxisDefine.axisInfos[2].unit
                configAddr: "s_rw_0_32_3_1002"
            }
        }
        Row{
            id:linkpos1Container
            spacing: 4
            x: 74
            ICConfigEdit{
                id:sPosM3
//                enabled: !useEn.isChecked
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[3].name
                unit: AxisDefine.axisInfos[3].unit
                configAddr: "s_rw_0_32_3_1003"
            }
            ICConfigEdit{
                id:sPosM4
//                enabled: !useEn.isChecked
                visible: false
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[4].name
                unit: AxisDefine.axisInfos[4].unit
                configAddr: "s_rw_0_32_3_1004"
            }
            ICConfigEdit{
                id:sPosM5
//                enabled: !useEn.isChecked
                visible: false
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[5].name
                unit: AxisDefine.axisInfos[5].unit
                configAddr: "s_rw_0_32_3_1005"
            }
        }
        Row{
            spacing: 85
            Row{
                id:pos2Container
                spacing: 4
                function getPoint(){
                    var ret = {};
                    var axis1 = "m" + plane[0];
                    var axis2 = "m" + plane[1];
                    var axis3 = "m" + plane[2];
                    ret.pointName = "";
                    ret.pos = {};
                    ret.pos[axis1] = pos1Axis1.configValue;
                    ret.pos[axis2] = pos1Axis2.configValue;
                    ret.pos[axis3] = pos1Container.getPoint().pos[axis3];
                    if(mode > 3 && mode != 8 && mode != 9)
                        ret.pos["m" + 3] = pos1Axis4.configValue;
                    else
                        ret.pos["m" + 3] = pos1Container.getPoint().pos.m3;
                    return ret;
                }
                ICButton{
                    id:button_setPos1
//                    enabled: !useEn.isChecked
                    width: configContainer.posNameWidth + 10
                    height: sPosM0.height
                    anchors.verticalCenter: parent.verticalCenter
                    bgColor: "lime"
                    onButtonClicked: {
                        switch(planeSel.configValue){
                        case 0:{
                            pos1Axis1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                            pos1Axis2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                            break;}
                        case 1:{
                            pos1Axis1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                            pos1Axis2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                            break;}
                        case 2:{
                            pos1Axis1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                            pos1Axis2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                            break;}
                        }
                        pos1Axis4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                    }
                }
//                Text {
//                    id:pos1
//                    width: 35
//                    anchors.verticalCenter: parent.verticalCenter
//                }
                ICConfigEdit{
                    id:pos1Axis1
//                    enabled: !useEn.isChecked
                    width: sPosM0.width
                    configNameWidth: sPosM0.configNameWidth
                    configName: AxisDefine.axisInfos[0].name
                    configAddr: "s_rw_0_32_3_1000"
                    unit: AxisDefine.axisInfos[0].unit
                }
                ICConfigEdit{
                    id:pos1Axis2
//                    enabled: !useEn.isChecked
                    width: sPosM0.width
                    configNameWidth: sPosM0.configNameWidth
                    configName: AxisDefine.axisInfos[1].name
                    configAddr: "s_rw_0_32_3_1001"
                    unit: AxisDefine.axisInfos[1].unit
                }
                ICConfigEdit{
                    id:pos1Axis4
//                    enabled: !useEn.isChecked
                    visible: mode > 3 && mode != 8 && mode != 9
                    width: sPosM0.width
                    configNameWidth: sPosM0.configNameWidth
                    configName: AxisDefine.axisInfos[3].name
                    configAddr: "s_rw_0_32_3_1003"
                    unit: AxisDefine.axisInfos[3].unit
                }
                ICCheckBox{
                    id:gunFollowEn
                    visible: false
//                    enabled: !useEn.isChecked
                    text: qsTr("Gun Follow En")
                    onVisibleChanged: {
                        isChecked = false;
                    }
                }
            }

            Row{
                id:pos3Container
                spacing: 4
                visible: mode == 2
                function getPoint(){
                    var ret = {};
                    var axis1 = "m" + plane[0];
                    var axis2 = "m" + plane[1];
                    var axis3 = "m" + plane[2];
                    ret.pointName = "";
                    ret.pos = {};
                    ret.pos[axis1] = pos2Axis1.configValue;
                    ret.pos[axis2] = pos2Axis2.configValue;
                    ret.pos[axis3] = pos1Container.getPoint().pos[axis3];
                    return ret;
                }
                ICButton{
                    id:button_setPos2
                    width: configContainer.posNameWidth + 10
                    height: sPosM0.height
                    anchors.verticalCenter: parent.verticalCenter
                    bgColor: "lime"
                    onButtonClicked: {
                        switch(planeSel.configValue){
                        case 0:{
                            pos2Axis1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                            pos2Axis2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                            break;}
                        case 1:{
                            pos2Axis1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                            pos2Axis2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                            break;}
                        case 2:{
                            pos2Axis1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                            pos2Axis2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                            break;}
                        }
                    }
                }
//                Text {
//                    id:pos2
//                    width: 35
//                    anchors.verticalCenter: parent.verticalCenter
//                }
                ICConfigEdit{
                    id:pos2Axis1
                    configName: AxisDefine.axisInfos[0].name
                    configAddr: "s_rw_0_32_3_1000"
                    unit: AxisDefine.axisInfos[0].unit
                }
                ICConfigEdit{
                    id:pos2Axis2
                    configName: AxisDefine.axisInfos[1].name
                    configAddr: "s_rw_0_32_3_1001"
                    unit: AxisDefine.axisInfos[1].unit
                }
            }
        }


        Row{
            spacing: 10
            id:repeateContainer
            ICConfigEdit{
                id:repeateSpeed
//                enabled: !useEn.isChecked
//                visible: mode == 3 ? true : false
                width: 237
                configName: qsTr("Rpeate Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
            ICConfigEdit{
                id:repeateCount
//                enabled: !useEn.isChecked
                visible: (mode == 3 || mode == 7 || mode == 9) ? true : false
                width: repeateSpeed.width
                configName: qsTr("Repeate Count")
            }
            ICConfigEdit{
                id:zlength
//                enabled: !useEn.isChecked
                visible: mode > 3 && mode != 8 && mode != 9 ? true : false
                width: repeateSpeed.width
                configName: qsTr("z length")
                configAddr: "s_rw_0_32_3_1300"
                unit: qsTr("mm")
            }
        }

        Row{
            id:dirContainer
            spacing: 10
            ICConfigEdit{
                id:dirLength
//                enabled: !useEn.isChecked
                visible: mode == 2 || mode == 6 || mode == 8 || mode == 9 ? false : true
                width: repeateSpeed.width
                configName: qsTr("Dir Length")
                configAddr: "s_rw_0_32_3_1300"
                unit: qsTr("mm")
            }
            ICConfigEdit{
                id:dirSpeed
//                enabled: !useEn.isChecked
                width: repeateSpeed.width
                configName: qsTr("Dir Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")
            }
            ICConfigEdit{
                id:dirCount
                visible: mode != 2 && mode != 9
                width: repeateSpeed.width
                configName: qsTr("Dir Count")
            }
        }

        Row{
            id:rotateContainer
            spacing: 10
            ICConfigEdit{
                id:rotate
                width: repeateSpeed.width
                configName: qsTr("Rotate")
                configAddr: "s_rw_0_32_3_1300"
                unit: qsTr("°")
            }
            ICConfigEdit{
                id:rotateSpeed
                width: repeateSpeed.width
//                visible: mode == 8 ? false : true
                configName: qsTr("Rotate Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")
            }
            ICConfigEdit{
                id:rotateCount
                visible: false
                width: repeateSpeed.width
                configName: qsTr("Rotate Count")
            }
        }
    }
    ICButton{
        id:gunfresh1
        height: 32
        width: 80
        anchors.right: container.right
        y: row1.height + 5
        text: qsTr("Gunfresh1")
        anchors.leftMargin: 12
        bgColor: "grey"
        onButtonClicked: {
            lookOver.running = false;
            if(gunfresh1.bgColor == "grey"){
                gunfresh1.bgColor = "lime";
                var toSend = IODefines.valveItemJSON("valve4");
                panelRobotController.setYStatus(toSend, 1);
                toSend = IODefines.valveItemJSON("valve5");
                panelRobotController.setYStatus(toSend, 1);
            }
            else{
                gunfresh1.bgColor = "grey";
                toSend = IODefines.valveItemJSON("valve6");
                panelRobotController.setYStatus(toSend, 0);

            }
            gunfresh1Timer.running = true;
            lookOver.running = true;
        }
    }
    ICButton{
        id:gunfresh2
        height: 32
        width: 80
        y: gunfresh1.y + gunfresh1.height + 5
        text: qsTr("Gunfresh2")
        anchors.leftMargin: 12
        anchors.right: gunfresh1.right
        bgColor: "grey"
        onButtonClicked: {
            lookOver.running = false;
            if(gunfresh2.bgColor == "grey"){
                gunfresh2.bgColor = "lime"
                var toSend = IODefines.valveItemJSON("valve7");
                panelRobotController.setYStatus(toSend, 1);
                toSend = IODefines.valveItemJSON("valve8");
                panelRobotController.setYStatus(toSend, 1);
            }
            else{
                gunfresh2.bgColor = "grey"
                toSend = IODefines.valveItemJSON("valve9");
                panelRobotController.setYStatus(toSend, 0);
            }
            gunfresh2Timer.running = true;
            lookOver.running = true;
        }
    }
    Timer {
        id: gunfresh1Timer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            if(gunfresh1.bgColor == "grey"){
                var toSend = IODefines.valveItemJSON("valve4");
                panelRobotController.setYStatus(toSend, 0);
                toSend = IODefines.valveItemJSON("valve5");
                panelRobotController.setYStatus(toSend, 0);
            }
            else{
                toSend = IODefines.valveItemJSON("valve6");
                panelRobotController.setYStatus(toSend, 1);
            }
        }
    }
    Timer {
        id: gunfresh2Timer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            if(gunfresh2.bgColor == "grey"){
                var toSend = IODefines.valveItemJSON("valve7");
                panelRobotController.setYStatus(toSend, 0);
                toSend = IODefines.valveItemJSON("valve8");
                panelRobotController.setYStatus(toSend, 0);
            }
            else{
                toSend = IODefines.valveItemJSON("valve9");
                panelRobotController.setYStatus(toSend, 1);
            }
        }
    }
    Timer {
        id: lookOver
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            if(panelRobotController.isOutputOn(4, 0)&&panelRobotController.isOutputOn(5, 0)&&
                    panelRobotController.isOutputOn(6, 0))
                gunfresh1.bgColor = "lime";
            else if(!(panelRobotController.isOutputOn(4, 0)||panelRobotController.isOutputOn(5, 0)||
                    panelRobotController.isOutputOn(6, 0)))
                gunfresh1.bgColor = "grey";
            if(panelRobotController.isOutputOn(7, 0)&&panelRobotController.isOutputOn(8, 0)&&
                    panelRobotController.isOutputOn(9, 0))
                gunfresh2.bgColor = "lime";
            else if(!(panelRobotController.isOutputOn(7, 0)||panelRobotController.isOutputOn(8, 0)||
                    panelRobotController.isOutputOn(9, 0)))
                gunfresh2.bgColor = "grey";
        }
    }
    onActionObjectChanged: {
        if(actionObject == null) return;

        pos1Axis4.configValue = actionObject.point1.pos.m3;

        planeSel.configValue = actionObject.plane;
        dirAxisSel.configValue = actionObject.dirAxis;
        sPosM0.configValue = actionObject.startPos.pos.m0;
        sPosM1.configValue = actionObject.startPos.pos.m1;
        sPosM2.configValue = actionObject.startPos.pos.m2;
        sPosM3.configValue = actionObject.startPos.pos.m3;
        sPosM4.configValue = actionObject.startPos.pos.m4;
        sPosM5.configValue = actionObject.startPos.pos.m5;

        pos1Axis1.configValue = actionObject.point1.pos["m" + plane[0]];
        pos1Axis2.configValue = actionObject.point1.pos["m" + plane[1]];
        button_setPos1.text = qsTr("Set EPos");
        pos2Axis1.configValue = actionObject.point2.pos["m" + plane[0]];
        pos2Axis2.configValue = actionObject.point2.pos["m" + plane[1]];

        repeateSpeed.configValue = actionObject.repeateSpeed;
        dirSpeed.configValue = actionObject.dirSpeed;
        dirLength.configValue = actionObject.dirLength;
        repeateCount.configValue = actionObject.repeateCount;
        zlength.configValue = actionObject.zlength;
        dirCount.configValue = actionObject.dirCount;
        rotate.configValue = actionObject.rotate;
        rotateSpeed.configValue = actionObject.rotateSpeed;
        rotateCount.configValue = actionObject.rotateCount;
        isGunBack.isChecked = actionObject.isGunBack;
        editaction.configValue = actionObject.editaction;
        planeSel.visible = actionObject.mode == 8 ? false : true;
        dirAxisSel.visible = actionObject.mode == 8 ? false : true;
        editaction.visible = actionObject.mode == 8 ? true : false;
        pos2Container.visible = actionObject.mode == 8 ? false : true;
        if(actionObject.mode == 2 || actionObject.mode == 9){
            pos3Container.visible = actionObject.mode == 2;
            setPosName(qsTr("Repeat EPos"), qsTr("Dir EPos"));
            dirLength.visible = false;
            dirCount.visible = false;
        }
        else {
            dirLength.visible = true;
            dirCount.visible = true;
            pos3Container.visible = false;
            setPosName(qsTr("Set EPos"), qsTr("Set TPos"));
        }
        if(actionObject.mode > 3 && actionObject.mode != 8 && actionObject.mode != 9){
//            if(actionObject.plane == 0 && actionObject.dirAxis == 0)
//                gunFollowEn.visible = true;
            zlength.visible = true;
        }
        else zlength.visible = false;
        if(actionObject.mode == 3 || actionObject.mode == 7 || actionObject.mode == 9)
            repeateCount.visible = true;
        else repeateCount.visible = false;
        if(actionObject.mode == 6){
            pos1Axis1.visible = true;
            pos1Axis2.visible = true;
            pos2Axis1.visible = false;
            pos2Axis2.visible = false;
            dirLength.visible = false;
            dirSpeed.visible = false;
        }
        else if(actionObject.mode == 9){
            if(dirAxisSel.configValue == 0){
                pos1Axis1.visible = true;
                pos1Axis2.visible = false;
                pos2Axis1.visible = false;
                pos2Axis2.visible = true;
            }
            else {
                pos1Axis1.visible = false;
                pos1Axis2.visible = true;
                pos2Axis1.visible = true;
                pos2Axis2.visible = false;
            }
        }
        else{
            if(dirAxisSel.configValue == 0){
                pos1Axis1.visible = false;
                pos1Axis2.visible = true;
                pos2Axis1.visible = true;
                pos2Axis2.visible = false;
            }
            else {
                pos1Axis1.visible = true;
                pos1Axis2.visible = false;
                pos2Axis1.visible = false;
                pos2Axis2.visible = true;
            }
//            if(actionObject.mode != 2 && actionObject.mode != 9)
                dirLength.visible = actionObject.mode != 2 && actionObject.mode != 8 && actionObject.mode != 9;
            dirSpeed.visible = actionObject.mode != 8 && actionObject.mode != 9;
        }
        dirAxisSel.configName = actionObject.mode == 9 ? qsTr("Repeat Axis") : qsTr("Dir Axis");
        pos1Axis4.visible = actionObject.mode > 3 && actionObject.mode != 8 && actionObject.mode != 9;
        repeateSpeed.visible = actionObject.mode != 8;
    }


    Component.onCompleted: {
        planeSel.configValue = 0;
        dirAxisSel.configValue = 1;
        sPosM0.configValue = 0.000;
        sPosM1.configValue = 0.000;
        sPosM2.configValue = 0.000;
        sPosM3.configValue = 0.000;
        sPosM4.configValue = 0.000;
        sPosM5.configValue = 0.000;

        pos1Axis1.configValue = 0.000;
        pos1Axis2.configValue = 0.000;
        pos1Axis4.configValue = 0.000;

        pos2Axis1.configValue = 0.000;
        pos2Axis2.configValue = 0.000;

        repeateSpeed.configValue = 100.0;
        dirSpeed.configValue = 10.0;
        dirLength.configValue = 0.000;
        repeateCount.configValue = 0;
        zlength.configValue = 0.000;
        dirCount.configValue = 0;
        rotate.configValue = 0.000;
        rotateSpeed.configValue = 30.0;
        rotateCount.configValue = 0;
        isGunBack.isChecked = false;

        resetItems();
        ManualProgramManager.manualProgramManager.registerMonitor(container);
    }
}
