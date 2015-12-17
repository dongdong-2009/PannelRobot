import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap
import "configs/AxisDefine.js" as AxisDefine



Rectangle {
    width: parent.width
    height: parent.height
    //    property bool ready: false
    function sendCommand(cmd, type){
        panelRobotController.modifyConfigValue(24,
                                               type);
        panelRobotController.sendKeyCommandToHost(cmd);
    }
    border.width: 1
    border.color: "gray"
    color: "#A0A0F0"
    Column{
        //        x:360
        //        y:10
        id:speedSection
        anchors.right: parent.right
        anchors.rightMargin: 40
        Text {
            text: qsTr("▲")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 15
        }
        Row{
            spacing: 2
            Text {
                text: qsTr("Speed")
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle{
                border.width: 1
                border.color: "gray"
                width: 70
                height: 32
                Text {
                    id: speed
                    anchors.centerIn: parent

                }
            }
            Text {
                text: "%"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Text {
            text: qsTr("▼")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 15
        }
    }

    Grid{
        id:keyboardSection
        columns: 4
        spacing: 20
        //        x:50
        anchors.verticalCenter: parent.verticalCenter
        x: 10
        ICButton {
            id: text4
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Z-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NZ, Keymap.SINGLE_ARM_MOVE_TYPE)


        }
        ICButton {
            id: text3
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Z+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PZ, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text6
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("U-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NU, Keymap.SINGLE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text5
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("U+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PU, Keymap.SINGLE_ARM_MOVE_TYPE)


        }



        ICButton {
            id: text9
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Y-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NY, Keymap.SINGLE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text8
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Y+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PY, Keymap.SINGLE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text2
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("V-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NV, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text1
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("V+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PV, Keymap.SINGLE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text10
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("X-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NX, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text7
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("X+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PX, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text11
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("W-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NW, Keymap.SINGLE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text12
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("W+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PW, Keymap.SINGLE_ARM_MOVE_TYPE)


        }



        ICButton {
            id: text15
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Line Z-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NZ, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text16
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Line Z+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PZ, Keymap.COMBINE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text23
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Rotate U-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NU, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text24
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Rotate U+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PU, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text18
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Line Y-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NY, Keymap.COMBINE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text17
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Line Y+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PY, Keymap.COMBINE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text21
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Rotate V-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NV, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text22
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Rotate V+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PV, Keymap.COMBINE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text13
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Line X-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NX, Keymap.COMBINE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text14
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Line X+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PX, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text19
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Rotate W-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NW, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text20
            isAutoRepeat: true
            autoInterval: 10
            width: 70
            height:48
            text: qsTr("Rotate W+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PW, Keymap.COMBINE_ARM_MOVE_TYPE)

        }

    }

    Rectangle{
        id:verSpliteLine
        width: 1
        height: keyboardSection.height
        color: "gray"
        anchors.left: keyboardSection.right
        anchors.leftMargin: 4
        y:keyboardSection.y
    }
    Rectangle{
        id:horSpliteLine
        width: 300
        height: 1
        color: "gray"
        anchors.top: speedSection.bottom
        anchors.topMargin: 4
        x:verSpliteLine.x
    }
    Item{
        id:pathTestSection
        anchors.top:  horSpliteLine.bottom;
        anchors.topMargin: 2
        x:horSpliteLine.x + 6
        ICButtonGroup{
            id:functionSel
            mustChecked: true
            spacing: 6

            ICCheckBox{
                id:lineFunction
                text: qsTr("Line Test")
                isChecked: true
            }
            ICCheckBox{
                id:curveFunction
                text: qsTr("Curve Test")
            }
        }
        ICStackContainer{
            anchors.top:functionSel.bottom
            anchors.topMargin: 4
            id:functionSection
            function getCurrentPoint(){
                return [panelRobotController.statusValueText("c_ro_0_32_3_900"),
                        panelRobotController.statusValueText("c_ro_0_32_3_904"),
                        panelRobotController.statusValueText("c_ro_0_32_3_908"),
                        panelRobotController.statusValueText("c_ro_0_32_3_912"),
                        panelRobotController.statusValueText("c_ro_0_32_3_916"),
                        panelRobotController.statusValueText("c_ro_0_32_3_920")];
            }
            function pointToText(point){
                return AxisDefine.axisInfos[0].name + ":" + point[0] + "," +
                        AxisDefine.axisInfos[1].name + ":" + point[1] + "," +
                        AxisDefine.axisInfos[2].name + ":" + point[2] + "\n" +
                        AxisDefine.axisInfos[3].name + ":" + point[3] + "," +
                        AxisDefine.axisInfos[4].name + ":" + point[4] + "," +
                        AxisDefine.axisInfos[5].name + ":" + point[5];
            }
            function runToPoint(cmd){
                if(panelRobotController.isOrigined()){
                    panelRobotController.sendKeyCommandToHost(cmd);
                }
            }

            //< 手动记录坐标类型 0：直线起点位置；1：直线终点位置
            //<              10：弧线中间点位置；11：弧线终点位置
            function savePointHelper(type, toShow){
                if(panelRobotController.isOrigined()){
                    var points = functionSection.getCurrentPoint();
                    toShow.text = functionSection.pointToText(points);
                    panelRobotController.logTestPoint(type, JSON.stringify(points));
                }
            }

            Item{
                id:lineTestContainer
                visible: lineFunction.isChecked
                Column{
                    spacing: 12
                    Column{
                        Row{
                            ICButton{
                                id:lineRun1
                                text: qsTr("Run to This")
                                isAutoRepeat: true
                                onTriggered: functionSection.runToPoint(Keymap.CMD_LINT_TO_START_POINT);

                            }
                            ICButton{
                                id:lineSave1
                                text:qsTr("Set to Point-1");
                                onButtonClicked: functionSection.savePointHelper(1, linePoint1);
                            }
                        }
                        Text {
                            id: linePoint1
                            height: 32
                        }
                    }
                    Column{
                        Row{
                            ICButton{
                                id:lineRun2
                                text: qsTr("Run to This")
                                isAutoRepeat: true
                                onTriggered: functionSection.runToPoint(Keymap.CMD_LINT_TO_END_POINT);
                            }
                            ICButton{
                                id:lineSave2
                                text:qsTr("Set to Point-2");
                                onButtonClicked: functionSection.savePointHelper(0, linePoint2);

                            }
                        }
                        Text {
                            id: linePoint2
                            height: 32

                        }
                    }
                }
            }
            Item{
                id:curveTestContainer
                visible: curveFunction.isChecked
                Column{
                    spacing: 12
                    Column{
                        Row{
                            ICButton{
                                id:curveRun1
                                text: qsTr("Run to This")
                                isAutoRepeat: true
                                onTriggered: functionSection.runToPoint(Keymap.CMD_ARC_TO_START_POINT);
                            }
                            ICButton{
                                id:curveSave1
                                text:qsTr("Set to Point-1");
                                onButtonClicked: functionSection.savePointHelper(10, curvePoint1);

                            }
                        }
                        Text {
                            id: curvePoint1
                            text: ""
                        }
                    }
                    Column{
                        Row{
                            ICButton{
                                id:curveRun2
                                text: qsTr("Run to This")
                            }
                            ICButton{
                                id:curveSave2
                                text:qsTr("Set to Point-2");
                                onButtonClicked: functionSection.savePointHelper(11, curvePoint2);

                            }
                        }
                        Text {
                            id: curvePoint2
                            height: 32
                            text: ""

                        }
                    }
                    Column{
                        Row{
                            ICButton{
                                id:curveRun3
                                text: qsTr("Run to This")
                            }
                            ICButton{
                                id:curveSave3
                                text:qsTr("Set to Point-3");
                                onButtonClicked: functionSection.savePointHelper(12, curvePoint3);

                            }
                        }
                        Text {
                            id: curvePoint3
                            height: 32
                            text: ""

                        }
                    }
                }
            }
        }

    }


    onVisibleChanged: {
        if(visible){
            speed.text = "10.0";
            panelRobotController.modifyConfigValue("s_rw_0_16_1_265", 10.0);
//            panelRobotController.syncConfigs();
        }

    }

    focus: visible
    Keys.onPressed: {
        var key = event.key;
        var spd;
        var pu = Keymap.PULLY_UP;
        var pd = Keymap.PULLY_DW;
        if(!panelRobotController.isQWS()){
            pu = parseInt(0x01000037);
            pd = parseInt(0x01000039);
        }

        if(key === pu){
            spd = parseFloat(speed.text);
            spd += 0.1
            if(spd >= 100)
                spd = 100.0;
            speed.text = spd.toFixed(1);
            event.accepted = true;
            panelRobotController.modifyConfigValue("s_rw_0_16_1_265", speed);


        }else if(key === pd){
            spd = parseFloat(speed.text);
            spd -= 0.1
            if(spd <= 0)
                spd = 0;
            speed.text = spd.toFixed(1);
            event.accepted = true;
            panelRobotController.modifyConfigValue("s_rw_0_16_1_265", speed);
        }
    }
}
