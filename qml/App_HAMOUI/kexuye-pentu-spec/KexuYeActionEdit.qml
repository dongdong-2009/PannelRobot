import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine
import "Teach.js" as LocalTeach
import "../teach/Teach.js" as BaseTeach


Item {
    id:container
    width: parent.width
    height: parent.height
    property int mode: 0
    property variant plane: [0, 1, 2]
    property variant actionObject: null
    property variant detailInstance: null
    function createActionObjects(){
        var ret = [];
         var rc = BaseTeach.counterManager.getCounter(0);
        if(rc == null){
            rc= BaseTeach.counterManager.newCounter("", 0, rotateCount.configValue);
            panelRobotController.saveCounterDef(rc.id, rc.name, rc.current, rc.target);
        }
        var c = BaseTeach.counterManager.newCounter("", 0, repeateCount.configValue);
        var rcID = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);
        c = BaseTeach.counterManager.newCounter("", 0, dirCount.configValue);
        var dirCID = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);
        var rotateCID = rc.id;
        var rotateOKCount = rotate.configValue / 90;
        if(rotate.configValue < 0)rotateOKCount = -rotateOKCount;
        c = BaseTeach.counterManager.newCounter("", 0, rotateOKCount);
        var rotateOKCID = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);

        c = BaseTeach.counterManager.newCounter("", 0, rotateCount.configValue);
        var aaaa = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);

        c = BaseTeach.counterManager.newCounter("", 0, rotateCount.configValue);
        var bbbb = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);


        var details = detailInstance.getDetails();
        ret.push(LocalTeach.generatePENTUAction(mode, planeSel.configValue, pos1Container.getPoint(), details.spd0,
                                                details.spd1, details.spd2, details.spd3, details.spd4, details.spd5,
                                                repeateSpeed.configValue, repeateCount.configValue, zlength.configValue,
                                                dirAxisSel.configValue, dirLength.configValue, dirSpeed.configValue,
                                                dirCount.configValue, pos2Container.getPoint(), pos3Container.getPoint(),
                                                rotate.configValue, rotateSpeed.configValue, rotateCount.configValue,
                                                details.delay0, details.delay1, details.delay2, rcID, dirCID, rotateCID,
                                                details.delay20, details.delay21, details.delay22, details.fixtureSwitch,
                                                details.fixture1Switch, details.slope, rotateOKCID, gunFollowEn.isChecked,
                                                aaaa,bbbb));
        return ret;
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
    }

    function setModeName(name){
        actionName.text = name;
    }
    function setPosName(name1,name2){
        button_setPos1.text = name1;
        button_setPos2.text = name2;
    }
    function gunFollowEnvisible(){
        if(mode < 4)
            gunFollowEn.visible  = false;
        else{
            if(planeSel.configValue == 0 && dirAxisSel.configValue == 0)
                gunFollowEn.visible  = true;
            else gunFollowEn.visible  = false;
        }
    }

    Column{
        id:configContainer
        property int posNameWidth: 60
        spacing: 4
        Row{
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
                configName: qsTr("plane")
                items: ["XY", "XZ", "YZ"]
                //                configValue: 0
                onConfigValueChanged: {
                    if(mode > 3 && configValue == 0 && dirAxisSel.configValue == 0)
                        gunFollowEn.visible = true;
                    else gunFollowEn.visible = false;
                    if(configValue == 0){
                        container.plane = [0, 1, 2];
                        pos1Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos1Axis2.configName = AxisDefine.axisInfos[1].name;
                        pos2Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos2Axis2.configName = AxisDefine.axisInfos[1].name;
                        dirAxisSel.items = ["X", "Y"]
                    }else if(configValue == 1){
                        plane = [0, 2, 1];
                        pos1Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos1Axis2.configName = AxisDefine.axisInfos[2].name;
                        pos2Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos2Axis2.configName = AxisDefine.axisInfos[2].name;
                        dirAxisSel.items = ["X", "Z"]
                    }else if(configValue == 2){
                        plane = [1, 2, 0];
                        pos1Axis1.configName = AxisDefine.axisInfos[1].name;
                        pos1Axis2.configName = AxisDefine.axisInfos[2].name;
                        pos2Axis1.configName = AxisDefine.axisInfos[1].name;
                        pos2Axis2.configName = AxisDefine.axisInfos[2].name;
                        dirAxisSel.items = ["Y", "Z"]
                    }
                }
            }

            ICComboBoxConfigEdit{
                id:dirAxisSel
                configName: qsTr("Dir Axis")
//                items: ["X", "Y", "Z"]
                onConfigValueChanged:
                    if(mode > 3 && configValue == 0 && planeSel.configValue == 0)
                        gunFollowEn.visible = true;
                    else gunFollowEn.visible = false;
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
                text: qsTr("Set SPos")
                width: configContainer.posNameWidth + 10
                height: sPosM0.height
                anchors.verticalCenter: parent.verticalCenter
                onButtonClicked: {
                    sPosM0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                    sPosM1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                    sPosM2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                    sPosM3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                    sPosM4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                    sPosM5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                }
            }
            ICConfigEdit{
                id:sPosM0
                width: 150
                configNameWidth: 28
                configName: AxisDefine.axisInfos[0].name
                unit: AxisDefine.axisInfos[0].unit
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM1
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[1].name
                unit: AxisDefine.axisInfos[1].unit
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM2
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[2].name
                unit: AxisDefine.axisInfos[2].unit
                configAddr: "s_rw_0_32_3_1300"
            }
        }
        Row{
            id:linkpos1Container
            spacing: 4
            x: 74
            ICConfigEdit{
                id:sPosM3
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[3].name
                unit: AxisDefine.axisInfos[3].unit
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM4
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[4].name
                unit: AxisDefine.axisInfos[4].unit
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM5
                width: sPosM0.width
                configNameWidth: sPosM0.configNameWidth
                configName: AxisDefine.axisInfos[5].name
                unit: AxisDefine.axisInfos[5].unit
                configAddr: "s_rw_0_32_3_1300"
            }
        }
        Row{
            spacing: 124
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
                    ret.pos["m" + 3] = pos1Axis4.configValue;
                    return ret;
                }
                ICButton{
                    id:button_setPos1
                    width: configContainer.posNameWidth + 10
                    height: sPosM0.height
                    anchors.verticalCenter: parent.verticalCenter
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
                    width: sPosM0.width
                    configNameWidth: sPosM0.configNameWidth
                    configName: AxisDefine.axisInfos[0].name
                    configAddr: "s_rw_0_32_3_1300"
                    unit: AxisDefine.axisInfos[0].unit
                }
                ICConfigEdit{
                    id:pos1Axis2
                    width: sPosM0.width
                    configNameWidth: sPosM0.configNameWidth
                    configName: AxisDefine.axisInfos[1].name
                    configAddr: "s_rw_0_32_3_1300"
                    unit: AxisDefine.axisInfos[1].unit
                }
                ICConfigEdit{
                    id:pos1Axis4
                    visible: false
                    width: sPosM0.width
                    configNameWidth: sPosM0.configNameWidth
                    configName: AxisDefine.axisInfos[3].name
                    configAddr: "s_rw_0_32_3_1300"
                    unit: AxisDefine.axisInfos[3].unit
                }
                ICCheckBox{
                    id:gunFollowEn
                    text: qsTr("Gun Follow En")
                    onVisibleChanged: {
                        isChecked = false;
                    }
                }
            }

            Row{
                id:pos3Container
                spacing: 4
                visible: false
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
                    configAddr: "s_rw_0_32_3_1300"
                    unit: AxisDefine.axisInfos[0].unit
                }
                ICConfigEdit{
                    id:pos2Axis2
                    configName: AxisDefine.axisInfos[1].name
                    configAddr: "s_rw_0_32_3_1300"
                    unit: AxisDefine.axisInfos[1].unit
                }
            }
        }


        Row{
            spacing: 10
            id:repeateContainer
            ICConfigEdit{
                id:repeateSpeed
//                visible: mode == 3 ? true : false
                width: 237
                configName: qsTr("Rpeate Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
            ICConfigEdit{
                id:repeateCount
                visible: (mode == 3 || mode == 7) ? true : false
                width: repeateSpeed.width
                configName: qsTr("Repeate Count")
            }
            ICConfigEdit{
                id:zlength
                visible: mode > 3 ? true : false
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
                visible: mode == 2 ? false : true
                width: repeateSpeed.width
                configName: qsTr("Dir Length")
                configAddr: "s_rw_0_32_3_1300"
                unit: qsTr("mm")
            }
            ICConfigEdit{
                id:dirSpeed
                width: repeateSpeed.width
                configName: qsTr("Dir Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")
            }
            ICConfigEdit{
                id:dirCount
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
                configName: qsTr("Rotate Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")
            }
            ICConfigEdit{
                id:rotateCount
                width: repeateSpeed.width
                configName: qsTr("Rotate Count")
            }
        }
    }
    onActionObjectChanged: {
        if(actionObject == null) return;

        pos1Axis4.configValue = actionObject.point1.pos["m" + 3];

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

        if(actionObject.mode > 3){
            if(actionObject.plane == 0 && actionObject.dirAxis == 0)
                gunFollowEn.visible = true;
            zlength.visible = true;
        }
        if(actionObject.mode == 3 || actionObject.mode == 7)
            repeateCount.visible = true;
    }

    Component.onCompleted: {
        planeSel.configValue = 0;
        dirAxisSel.configValue = 1;
        sPosM0.configValue = 20.000;
        sPosM1.configValue = 20.000;
        sPosM2.configValue = 0.000;
        sPosM3.configValue = 0.000;
        sPosM4.configValue = 0.000;
        sPosM5.configValue = 0.000;

        pos1Axis1.configValue = 500.000;
        pos1Axis2.configValue = 20.000;
        pos1Axis4.configValue = 0.000;

        pos2Axis1.configValue = 0.000;
        pos2Axis2.configValue = 0.000;

        repeateSpeed.configValue = 100.0;
        dirSpeed.configValue = 100.0;
        dirLength.configValue = 50.000;
        repeateCount.configValue = 2;
        zlength.configValue = -100;
        dirCount.configValue = 10;
        rotate.configValue = 90.000;
        rotateSpeed.configValue = 5.0;
        rotateCount.configValue = 4;
    }
}
