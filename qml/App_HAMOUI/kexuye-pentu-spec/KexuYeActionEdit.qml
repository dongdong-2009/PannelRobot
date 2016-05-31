import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine
import "Teach.js" as LocalTeach

Item {
    id:container
    width: parent.width
    height: parent.height
    property int mode: 0
    property variant plane: [0, 1]
    function createActionObjects(){
        var ret = [];
        var c = LocalTeach.counterManager.newCounter("", 0, repeateCount.configValue);
        var rcID = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);
        c = LocalTeach.counterManager.newCounter("", 0, dirCount.configValue);
        var dirCID = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);
        c= LocalTeach.counterManager.newCounter("", 0, rotateCount.configValue);
        var rotateCID = c.id;
        panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);
        ret.push(LocalTeach.generatePENTUAction(mode, planeSel.configValue, pos1Container.getPoint(),[80.0, 80.0, 80.0, 80.0, 80.0, 80.0],
                                                repeateSpeed.configValue, repeateCount.configValue, zlength.configValue,
                                                dirAxisSel.configValue, dirLength.configValue, dirSpeed.configValue, dirCount.configValue,
                                                pos2Container.getPoint(), pos3Container.getPoint(),
                                                rotate.configValue, rotateSpeed.configValue, rotateCount.configValue, 0.1,
                                                rcID, dirCID, rotateCID));
        return ret;
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
                text: mode == 0 ? qsTr("PT Line 2D") : qsTr("PT Arc 3D")
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
                    if(configValue == 0){
                        container.plane = [0, 1];
                        pos1Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos1Axis2.configName = AxisDefine.axisInfos[1].name;
                        pos2Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos2Axis2.configName = AxisDefine.axisInfos[1].name;
                        dirAxisSel.items = ["X", "Y"]
                    }else if(configValue == 1){
                        plane = [0, 2];
                        pos1Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos1Axis2.configName = AxisDefine.axisInfos[2].name;
                        pos2Axis1.configName = AxisDefine.axisInfos[0].name;
                        pos2Axis2.configName = AxisDefine.axisInfos[2].name;
                        dirAxisSel.items = ["X", "Z"]
                    }else if(configValue == 2){
                        plane = [1, 2];
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
                items: ["X", "Y"]
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

            Text {
                text: qsTr("SPos:")
                width: configContainer.posNameWidth
                anchors.verticalCenter: parent.verticalCenter
            }
            ICConfigEdit{
                id:sPosM0
                configName: AxisDefine.axisInfos[0].name
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM1
                configName: AxisDefine.axisInfos[1].name
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM2
                configName: AxisDefine.axisInfos[2].name
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM3
                configName: AxisDefine.axisInfos[3].name
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM4
                configName: AxisDefine.axisInfos[4].name
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:sPosM5
                configName: AxisDefine.axisInfos[5].name
                configAddr: "s_rw_0_32_3_1300"
            }
        }
        Row{
            spacing: 4
            Row{
                id:pos2Container
                spacing: 4
                function getPoint(){
                    var ret = {};
                    var axis1 = "m" + plane[0];
                    var axis2 = "m" + plane[1];
                    ret.pointName = "";
                    ret.pos = {};
                    ret.pos[axis1] = pos1Axis1.configValue;
                    ret.pos[axis2] = pos1Axis2.configValue;
                    return ret;
                }

                Text {
                    text: qsTr("Pos 1:")
                    width: configContainer.posNameWidth
                    anchors.verticalCenter: parent.verticalCenter
                }
                ICConfigEdit{
                    id:pos1Axis1
                    configName: AxisDefine.axisInfos[0].name
                    configAddr: "s_rw_0_32_3_1300"
                }
                ICConfigEdit{
                    id:pos1Axis2
                    configName: AxisDefine.axisInfos[1].name
                    configAddr: "s_rw_0_32_3_1300"
                }

            }

            Row{
                id:pos3Container
                spacing: 4
                visible: mode == 0 ? false : true
                function getPoint(){
                    var ret = {};
                    var axis1 = "m" + plane[0];
                    var axis2 = "m" + plane[1];
                    ret.pointName = "";
                    ret.pos = {};
                    ret.pos[axis1] = pos2Axis1.configValue;
                    ret.pos[axis2] = pos2Axis2.configValue;
                    return ret;
                }
                Text {
                    text: qsTr("Pos 2:")
                    width: configContainer.posNameWidth
                    anchors.verticalCenter: parent.verticalCenter
                }
                ICConfigEdit{
                    id:pos2Axis1
                    configName: AxisDefine.axisInfos[0].name
                    configAddr: "s_rw_0_32_3_1300"
                }
                ICConfigEdit{
                    id:pos2Axis2
                    configName: AxisDefine.axisInfos[1].name
                    configAddr: "s_rw_0_32_3_1300"
                }
            }
        }


        Row{
            spacing: 10
            id:repeateContainer
            ICConfigEdit{
                id:repeateSpeed
                configName: qsTr("Rpeate Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
            ICConfigEdit{
                id:repeateCount
                configName: qsTr("Repeate Count")
            }
            ICConfigEdit{
                id:zlength
                configName: qsTr("z length")
            }
        }

        Row{
            id:dirContainer
            spacing: 10
            ICConfigEdit{
                id:dirLength
                configName: qsTr("Dir Length")
                configAddr: "s_rw_0_32_3_1300"
                unit: qsTr("mm")
            }
            ICConfigEdit{
                id:dirSpeed
                configName: qsTr("Dir Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")
            }
            ICConfigEdit{
                id:dirCount
                configName: qsTr("Dir Count")
            }
        }

        Row{
            id:rotateContainer
            spacing: 10
            ICConfigEdit{
                id:rotate
                configName: qsTr("Rotate")
                configAddr: "s_rw_0_32_3_1300"
            }
            ICConfigEdit{
                id:rotateSpeed
                configName: qsTr("Rotate Speed")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")
            }
            ICConfigEdit{
                id:rotateCount
                configName: qsTr("Rotate Count")
            }
        }
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
        pos1Axis2.configValue = 0.000;

        pos2Axis1.configValue = 0.000;
        pos2Axis2.configValue = 0.000;

        repeateSpeed.configValue = 80.0;
        dirSpeed.configValue = 80.0;
        dirLength.configValue = 50.000;
        repeateCount.configValue = 2;
        zlength.configValue = 100;
        dirCount.configValue = 10;
        rotate.configValue = 90.000;
        rotateSpeed.configValue = 5.0;
        rotateCount.configValue = 4;

    }
}
