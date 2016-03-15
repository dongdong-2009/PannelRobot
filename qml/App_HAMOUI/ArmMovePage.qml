import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap
import "configs/AxisDefine.js" as AxisDefine
import "ShareData.js" as ShareData
import "../utils/Storage.js" as Storage


Rectangle {
    id:container
    width: parent.width
    height: parent.height
    property int currentType: 0
    function sendCommand(cmd, type){
        if(currentType !== type){
            currentType = type;
            panelRobotController.modifyConfigValue(24,
                                                   type);
        }
        panelRobotController.sendKeyCommandToHost(cmd);
    }

    function onGlobalSpeedChanged(spd){
        speed.text = parseFloat(spd).toFixed(1);
    }
    border.width: 1
    border.color: "gray"
    color: "#A0A0F0"

    Column{
        id:speedSection
        anchors.right: parent.right
        anchors.rightMargin: 40
        spacing: 4
        Row{
            spacing: 2
            Text{
                id:localType
                text: currentType
            }
            Text {
                id:hostType
                onVisibleChanged: {
                    if(visible){
                        text = panelRobotController.debug_GetAddrValue(24);
                    }
                }
            }

            Text {
                text: qsTr("Speed")
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle{
                border.width: 1
                border.color: "gray"
                width: 70
                height: 32
                color: "lime"
                Text {
                    id: speed
                    text: "10.0"
                    anchors.centerIn: parent

                }
            }
            Text {
                text: "%"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        ICCheckBox{
            id:tuneSel
            text: qsTr("Tune Sel")
            onIsCheckedChanged: {
                keyboardSection.visible = !isChecked;
            }
        }
    }


    Grid{
        id:keyboardSection
        columns: 4
        spacing: 5
        //        x:50
        anchors.verticalCenter: parent.verticalCenter
        x: 10
        property int btnWidgth: 70
        property int btnHeight: 64
        ICButton {
            id: text4
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Z-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NZ, Keymap.SINGLE_ARM_MOVE_TYPE)


        }
        ICButton {
            id: text3
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Z+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PZ, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text6
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("U-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NU, Keymap.SINGLE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text5
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("U+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PU, Keymap.SINGLE_ARM_MOVE_TYPE)


        }



        ICButton {
            id: text9
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Y-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NY, Keymap.SINGLE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text8
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Y+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PY, Keymap.SINGLE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text2
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("V-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NV, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text1
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("V+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PV, Keymap.SINGLE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text10
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("X-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NX, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text7
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("X+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PX, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text11
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("W-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NW, Keymap.SINGLE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text12
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("W+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PW, Keymap.SINGLE_ARM_MOVE_TYPE)


        }



        ICButton {
            id: text15
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Line Z-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NZ, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text16
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Line Z+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PZ, Keymap.COMBINE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text23
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Rotate U-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NU, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text24
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Rotate U+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PU, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text18
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Line Y-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NY, Keymap.COMBINE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text17
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Line Y+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PY, Keymap.COMBINE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text21
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Rotate V-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NV, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text22
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Rotate V+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PV, Keymap.COMBINE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text13
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Line X-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NX, Keymap.COMBINE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text14
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Line X+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PX, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text19
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Rotate W-")
            onTriggered: sendCommand(Keymap.CMD_JOG_NW, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text20
            isAutoRepeat: true
            autoInterval: 10
            width: keyboardSection.btnWidgth
            height:keyboardSection.btnHeight
            text: qsTr("Rotate W+")
            onTriggered: sendCommand(Keymap.CMD_JOG_PW, Keymap.COMBINE_ARM_MOVE_TYPE)

        }

    }

    ICButtonGroup{
        id:keyboardSectionToSel
        x: keyboardSection.x
        y: keyboardSection.y
        isAutoSize: false
        visible: !keyboardSection.visible
        Grid{
            columns: 4
            spacing: 5
            ICButton {
                id: zSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Z")
            }
            ICButton {
                id: uSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("U")
            }
            ICButton {
                id: lineZSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line Z")
            }
            ICButton {
                id: rotateUSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate U")
            }

            ICButton {
                id: ySel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Y")
            }
            ICButton {
                id: vSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("V")
            }
            ICButton {
                id: lineYSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line Y")
            }
            ICButton {
                id: rotateVSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate V")
            }

            ICButton {
                id: xSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("X")
            }
            ICButton {
                id: wSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("W")
            }
            ICButton {
                id: lineXSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line X")
            }
            ICButton {
                id: rotateWSel
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate W")
            }
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
            function stopToPoint(){
                runToPoint(Keymap.CMD_PATH_STOP);
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
                            spacing: 10
                            ICButton{
                                id:lineRun1
                                text: qsTr("Run to This")
                                onBtnPressed: functionSection.runToPoint(Keymap.CMD_LINT_TO_START_POINT);
                                onBtnReleased: functionSection.stopToPoint();
                            }
                            ICButton{
                                id:lineSave1
                                text:qsTr("Set to Point-1");
                                width: 180
                                onButtonClicked: functionSection.savePointHelper(Keymap.kTP_LINE_START_POINT, linePoint1);
                            }
                        }
                        Text {
                            id: linePoint1
                            height: 32
                        }
                    }
                    Column{
                        Row{
                            spacing: 10
                            ICButton{
                                id:lineRun2
                                text: qsTr("Run to This")
                                onBtnPressed: functionSection.runToPoint(Keymap.CMD_LINT_TO_END_POINT);
                                onBtnReleased: functionSection.stopToPoint();

                            }
                            ICButton{
                                id:lineSave2
                                width: 180
                                text:qsTr("Set to Point-2");
                                onButtonClicked: functionSection.savePointHelper(Keymap.kTP_LINE_END_POINT, linePoint2);

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
                            spacing: 10

                            ICButton{
                                id:curveRun1
                                text: qsTr("Run to This")
                                onBtnPressed: functionSection.runToPoint(Keymap.CMD_ARC_TO_START_POINT);
                                onBtnReleased: functionSection.stopToPoint();

                            }
                            ICButton{
                                id:curveSave1
                                text:qsTr("Set to Point-1")
                                width: 180
                                onButtonClicked: functionSection.savePointHelper(Keymap.kTP_ARC_START_POINT, curvePoint1)

                            }
                        }
                        Text {
                            id: curvePoint1
                            text: ""
                        }
                    }
                    Column{
                        Row{
                            spacing: 10

                            ICButton{
                                id:curveRun2
                                text: qsTr("Run to This")
                            }
                            ICButton{
                                id:curveSave2
                                text:qsTr("Set to CPoint-2")
                                width: 180
                                onButtonClicked: functionSection.savePointHelper(Keymap.kTP_ARC_MID_POINT, curvePoint2)

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
                            spacing: 10

                            ICButton{
                                id:curveRun3
                                text: qsTr("Run to This")
                            }
                            ICButton{
                                id:curveSave3
                                text:qsTr("Set to CPoint-3")
                                width: 180

                                onButtonClicked: functionSection.savePointHelper(Keymap.kTP_ARC_END_POINT, curvePoint3)

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
        ShareData.GlobalStatusCenter.setTuneGlobalSpeedEn(visible);
        //        if(visible){
        ////            speed.text = "10.0";
        //            ShareData.GlobalStatusCenter.setGlobalSpeed(10.0);
        //            panelRobotController.modifyConfigValue("s_rw_0_16_1_265", 10.0);
        //            //            panelRobotController.syncConfigs();
        //        }

    }

    Component.onCompleted: {
        ShareData.GlobalStatusCenter.registeGlobalSpeedChangedEvent(container);
    }
}
