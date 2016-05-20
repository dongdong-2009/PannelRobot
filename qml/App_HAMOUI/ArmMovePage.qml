import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap
import "configs/AxisDefine.js" as AxisDefine
import "ShareData.js" as ShareData
import "../utils/Storage.js" as Storage

MouseArea{
    id:instance
    width: parent.width
    height: parent.height
    property int currentType: 0
    property int pullyAxis: -1
    function sendCommand(cmd, type){
        if(currentType !== type){
            currentType = type;
            panelRobotController.modifyConfigValue(24,
                                                   type);
        }
        panelRobotController.sendKeyCommandToHost(cmd);
    }
    Rectangle {
        id:container
        width: parent.width
        height: parent.height



        function onGlobalSpeedChanged(spd){
            speed.text = parseFloat(spd).toFixed(1);
        }
        border.width: 1
        border.color: "gray"
        color: "#A0A0F0"

        Row{
            id:speedSection
            anchors.right: parent.right
            anchors.rightMargin: 60
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

        Column{
            id:tuneSection
            anchors.top: speedSection.bottom
            anchors.left: verSpliteLine.left
            anchors.leftMargin: 4
            spacing: 6

            ICCheckBox{
                id:tuneSel
                text: qsTr("Tune Sel")
                font.pixelSize: 18
                onIsCheckedChanged: {
                    if(isChecked){
                        keyboardSection.visible = false;
                        partkeyboardSection.visible = false;
                        axisSelContiner.visible = false;
                    }else {
                        if(fullkeybd.isChecked){
                            keyboardSection.visible = true;
                            partkeyboardSection.visible = false;
                        }
                        else if(partkeybd.isChecked){
                            keyboardSection.visible = false;
                            partkeyboardSection.visible = true;
                            axisSelContiner.visible = true;

                        }
                    }
                }
                onVisibleChanged: {
                    if(!visible)
                        setChecked(false)
                }
            }
            Row{
                spacing: 4
                Text {
                    id:tuneSelLabel
                    text: qsTr("Tune Speed:")
                    font.pixelSize: 16
                }
                ICButtonGroup{
                    id:tuneSpeedGroup
                    property int currentSpeed: 1
                    isAutoSize: false
                    mustChecked: true
                    checkedIndex: 0
                    layoutMode: 2
                    height: tuneSpeedSel.height
                    width: tuneSpeedSel.width
                    onCheckedItemChanged: {
                        if(checkedItem == tuneSpeedX1){
                            panelRobotController.setPullySpeed(1);
                            currentSpeed = 1;
                        }else if(checkedItem == tuneSpeedX5){
                            panelRobotController.setPullySpeed(5);
                            currentSpeed = 5;
                        }else if(checkedItem == tuneSpeedX10){
                            panelRobotController.setPullySpeed(10);
                            currentSpeed = 10;
                        }else if(checkedItem == tuneSpeedX50){
                            panelRobotController.setPullySpeed(50)
                            currentSpeed = 50;
                        }
                    }

                    Grid{
                        id:tuneSpeedSel
                        columns: 2
                        spacing: 10
                        ICCheckBox{
                            id:tuneSpeedX1
                            text:"X1"
                            isChecked: true
                        }
                        ICCheckBox{
                            id:tuneSpeedX5
                            text:"X5"
                        }
                        ICCheckBox{
                            id:tuneSpeedX10
                            text:"X10"
                        }
                        ICCheckBox{
                            id:tuneSpeedX50
                            text:"X50"
                        }
                    }
                }
            }
        }
        ICButtonGroup{
            id: continer
            x: 10
            height: 25
            isAutoSize: false
            mustChecked: true
            checkedIndex: 1
            layoutMode: 2
            ICCheckBox{
                id:fullkeybd
                text: qsTr("fullkeybd")
                font.pixelSize: 18
                onIsCheckedChanged: {
                    keyboardSection.visible = isChecked;
                    partkeyboardSection.visible = !isChecked;
                    axisSelContiner.visible = !isChecked;
                }
            }
            ICCheckBox{
                id:partkeybd
                anchors.left: fullkeybd.right
                anchors.leftMargin: 10
                text: qsTr("partkeybd")
                font.pixelSize: 18
                isChecked: true

                onIsCheckedChanged: {
                    keyboardSection.visible = !isChecked;
                    partkeyboardSection.visible = isChecked;
                }
            }
        }
        ICButtonGroup{
            id: axisSelContiner
            x: 10
            visible: partkeybd.isChecked
            anchors.top: continer.bottom
            anchors.topMargin: 20
            isAutoSize: true
            mustChecked: true
            checkedIndex: 1
            layoutMode: 1
            spacing: 20
//            onVisibleChanged: {
//                if(!visible){
//                    worldcodinate.isChecked = false;
//                    jointcodinate.isChecked = true;
//                }
//            }
            onCheckedItemChanged: {
                if(checkedItem == worldcodinate){
                    panelRobotController.modifyConfigValue(24, Keymap.COMBINE_ARM_MOVE_TYPE);
                }else if(checkedItem == jointcodinate){
                    panelRobotController.modifyConfigValue(24, Keymap.SINGLE_ARM_MOVE_TYPE);
                }
            }

            ICCheckBox{
                id:worldcodinate
                x: partkeybd.x
                text: qsTr("worldcodinate")
                font.pixelSize: 18
            }
            ICCheckBox{
                id:jointcodinate
                x: partkeybd.x
                isChecked: true
                text: qsTr("jointcodinate")
                font.pixelSize: 18
            }
        }
        Grid{
            id:keyboardSection
            columns: 4
            spacing: 5
            //        x:50
            anchors.verticalCenter: parent.verticalCenter
            x: 10
            anchors.top: continer.bottom
            anchors.topMargin: 5
            property int btnWidgth: 70
            property int btnHeight: 60
            ICButton {
                id: text4
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("Z-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NZ, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_Z ? "lime" : "white"

            }
            ICButton {
                id: text3
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("Z+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PZ, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_Z ? "lime" : "white"


            }

            ICButton {
                id: text6
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text:qsTr("J") + qsTr("U-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NU, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_U ? "lime" : "white"


            }

            ICButton {
                id: text5
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("U+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PU, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_U ? "lime" : "white"



            }



            ICButton {
                id: text9
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("Y-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NY, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_Y ? "lime" : "white"


            }


            ICButton {
                id: text8
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("Y+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PY, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_Y ? "lime" : "white"


            }


            ICButton {
                id: text2
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("V-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NV, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_V ? "lime" : "white"


            }

            ICButton {
                id: text1
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("V+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PV, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_V ? "lime" : "white"


            }

            ICButton {
                id: text10
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("X-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NX, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_X ? "lime" : "white"



            }

            ICButton {
                id: text7
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("X+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PX, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_X ? "lime" : "white"



            }

            ICButton {
                id: text11
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("W-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NW, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_W ? "lime" : "white"



            }

            ICButton {
                id: text12
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("J") + qsTr("W+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PW, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_W ? "lime" : "white"



            }



            ICButton {
                id: text15
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line Z-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NZ, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_LZ ? "lime" : "white"



            }

            ICButton {
                id: text16
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line Z+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PZ, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_LZ ? "lime" : "white"


            }


            ICButton {
                id: text23
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate U-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NU, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_RU ? "lime" : "white"



            }

            ICButton {
                id: text24
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate U+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PU, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_RU ? "lime" : "white"


            }

            ICButton {
                id: text18
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line Y-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NY, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_LY ? "lime" : "white"



            }

            ICButton {
                id: text17
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line Y+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PY, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_LY ? "lime" : "white"


            }

            ICButton {
                id: text21
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate V-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NV, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_RV ? "lime" : "white"



            }

            ICButton {
                id: text22
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate V+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PV, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_RV ? "lime" : "white"


            }


            ICButton {
                id: text13
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line X-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NX, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_LX ? "lime" : "white"


            }

            ICButton {
                id: text14
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Line X+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PX, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_LX ? "lime" : "white"



            }

            ICButton {
                id: text19
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate W-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NW, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_RW ? "lime" : "white"



            }

            ICButton {
                id: text20
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: qsTr("Rotate W+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PW, Keymap.COMBINE_ARM_MOVE_TYPE)
                bgColor: pullyAxis == AxisDefine.kAP_RW ? "lime" : "white"


            }

        }
        Grid{
            id:partkeyboardSection
            columns: 4
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
            x: 10
            anchors.top: axisSelContiner.bottom
            anchors.topMargin: 15
            visible: false
            property int btnWidgth: 70
            property int btnHeight: 60
            ICButton {
                id: ptext4
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("Z-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NZ, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_LZ ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_Z ? "lime" : "white");
                }


            }
            ICButton {
                id: ptext3
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("Z+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PZ, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_LZ ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_Z ? "lime" : "white");

                }


            }

            ICButton {
                id: ptext6
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("U-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NU, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_RU ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_U ? "lime" : "white");

                }



            }

            ICButton {
                id: ptext5
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("U+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PU, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_RU ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_U ? "lime" : "white");

                }


            }



            ICButton {
                id: ptext9
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("Y-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NY, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_LY ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_Y ? "lime" : "white");

                }


            }


            ICButton {
                id: ptext8
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("Y+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PY, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_LY ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_Y ? "lime" : "white");

                }


            }


            ICButton {
                id: ptext2
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("V-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NV, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_RV ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_V ? "lime" : "white");

                }


            }

            ICButton {
                id: ptext1
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("V+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PV, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_RV ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_V ? "lime" : "white");
                }


            }

            ICButton {
                id: ptext10
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("X-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NX, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_LX ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_X ? "lime" : "white");

                }



            }

            ICButton {
                id: ptext7
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("X+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PX, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_LX ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_X ? "lime" : "white");

                }



            }

            ICButton {
                id: ptext11
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("W-")
                onTriggered: sendCommand(Keymap.CMD_JOG_NW, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_RW ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_W ? "lime" : "white");

                }


            }

            ICButton {
                id: ptext12
                isAutoRepeat: true
                autoInterval: 10
                width: keyboardSection.btnWidgth
                height:keyboardSection.btnHeight
                text: (jointcodinate.isChecked ? qsTr("J") : qsTr("WD")) + qsTr("W+")
                onTriggered: sendCommand(Keymap.CMD_JOG_PW, Keymap.SINGLE_ARM_MOVE_TYPE)
                bgColor:{
                    if(axisSelContiner.checkedItem == worldcodinate)
                        return (pullyAxis == AxisDefine.kAP_RW ? "lime" : "white");
                    return (pullyAxis == AxisDefine.kAP_W ? "lime" : "white");
                }


            }

        }

        ICButtonGroup{
            id:keyboardSectionToSel
            x: keyboardSection.x
            y: keyboardSection.y
            isAutoSize: false
            visible: !(keyboardSection.visible | partkeyboardSection.visible)
            SequentialAnimation{
                running: keyboardSectionToSel.visible
                PropertyAnimation{
                    targets: [zSel, ySel, xSel, uSel, vSel, wSel,
                        lineXSel, lineYSel, lineZSel,rotateUSel, rotateVSel, rotateWSel]
                    property: "rotation"
                    to: 30
                    duration: 100
                }
                PropertyAnimation{
                    targets: [zSel, ySel, xSel, uSel, vSel, wSel,
                        lineXSel, lineYSel, lineZSel,rotateUSel, rotateVSel, rotateWSel]
                    property: "rotation"
                    to: 0
                    duration: 100
                }
                PropertyAnimation{
                    targets: [zSel, ySel, xSel, uSel, vSel, wSel,
                        lineXSel, lineYSel, lineZSel,rotateUSel, rotateVSel, rotateWSel]
                    property: "rotation"
                    to: -30
                    duration: 100
                }
                PropertyAnimation{
                    targets: [zSel, ySel, xSel, uSel, vSel, wSel,
                        lineXSel, lineYSel, lineZSel,rotateUSel, rotateVSel, rotateWSel]
                    property: "rotation"
                    to: 0
                    duration: 100
                }
            }

            Grid{
                id:tuneSelGrid
                columns: 4
                spacing: 5
                function setPullyAxis(axis){
                    panelRobotController.setPullyAxis(axis, tuneSpeedGroup.currentSpeed);
                }

                ICButton {
                    id: zSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("J") + qsTr("Z")
                    bgColor: pullyAxis == AxisDefine.kAP_Z ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_Z);
                    }



                }
                ICButton {
                    id: uSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("J") + qsTr("U")
                    bgColor: pullyAxis == AxisDefine.kAP_U ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_U);
                    }



                }
                ICButton {
                    id: lineZSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("WD") + qsTr("Z")
                    bgColor: pullyAxis == AxisDefine.kAP_LZ ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_LZ);
                    }


                }
                ICButton {
                    id: rotateUSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("WD") + qsTr("U")
                    bgColor: pullyAxis == AxisDefine.kAP_RU ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_RU);
                    }


                }

                ICButton {
                    id: ySel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("J") + qsTr("Y")
                    bgColor: pullyAxis == AxisDefine.kAP_Y ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_Y);
                    }


                }
                ICButton {
                    id: vSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("J") + qsTr("V")
                    bgColor: pullyAxis == AxisDefine.kAP_V ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_V);
                    }


                }
                ICButton {
                    id: lineYSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("WD") + qsTr("Y")
                    bgColor: pullyAxis == AxisDefine.kAP_LY ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_LY);
                    }


                }
                ICButton {
                    id: rotateVSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("WD") + qsTr("V")
                    bgColor: pullyAxis == AxisDefine.kAP_RV ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_RV);
                    }


                }

                ICButton {
                    id: xSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("J") + qsTr("X")
                    bgColor: pullyAxis == AxisDefine.kAP_X ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_X);
                    }


                }
                ICButton {
                    id: wSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("J") + qsTr("W")
                    bgColor: pullyAxis == AxisDefine.kAP_W ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_W);
                    }


                }
                ICButton {
                    id: lineXSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("WD") + qsTr("X")
                    bgColor: pullyAxis == AxisDefine.kAP_LX ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_LX);
                    }


                }
                ICButton {
                    id: rotateWSel
                    width: keyboardSection.btnWidgth
                    height:keyboardSection.btnHeight
                    text: qsTr("WD") + qsTr("W")
                    bgColor: pullyAxis == AxisDefine.kAP_RW ? "lime" : "white"
                    onButtonClicked: {
                        tuneSelGrid.setPullyAxis(AxisDefine.kAP_RW);
                    }


                }
            }
        }

        ICSpliteLine{
            id:verSpliteLine
            wide: 1
            linelong: keyboardSection.height
            direction: "verticality"
            color: "gray"
            anchors.left: keyboardSection.right
            anchors.leftMargin: 4
            y:keyboardSection.y
        }
        ICSpliteLine{
            id:horSpliteLine
            direction: "horizontal"
            linelong: 340
            wide: 1
            color: "gray"
            anchors.top: tuneSection.bottom
            anchors.topMargin: 6
            x:verSpliteLine.x
        }
        Item{
            id:pathTestSection
            anchors.top:  horSpliteLine.bottom;
            anchors.topMargin: 6
            x:horSpliteLine.x + 6
            ICButtonGroup{
                id:functionSel
                mustChecked: true
                spacing: 6
                checkedIndex: 0

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
                    var ret = "";
                    var count = 0;
                    for(var i = 0, len = AxisDefine.axisInfos.length; i < len; ++i){
                        ++count;
                        if(AxisDefine.axisInfos[i].visiable){
                            ret += AxisDefine.axisInfos[i].name + ":" + point[i];
                            if(count == 2)
                                ret += "\n";
                            else
                                ret += ",";
                        }
                    }
                    ret.length = ret.length - 1;
                    return ret;
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

        Timer{
            id:refreshTimer
            interval: 50; running: visible; repeat: true
            onTriggered: {
                pullyAxis = panelRobotController.getPullyAxis();

            }
        }


        Component.onCompleted: {
            ShareData.GlobalStatusCenter.registeGlobalSpeedChangedEvent(container);
            //        partkeybd.setChecked(true);
            keyboardSection.visible = false;
            partkeyboardSection.visible = true;
            AxisDefine.registerMonitors(instance);
            onAxisDefinesChanged();
        }
    }
    function onAxisDefinesChanged(){
        text4.visible = AxisDefine.axisInfos[2].visiable;
        text3.visible = AxisDefine.axisInfos[2].visiable;
        text5.visible = AxisDefine.axisInfos[3].visiable;
        text6.visible = AxisDefine.axisInfos[3].visiable;
        text8.visible = AxisDefine.axisInfos[1].visiable;
        text9.visible = AxisDefine.axisInfos[1].visiable;
        text1.visible = AxisDefine.axisInfos[4].visiable;
        text2.visible = AxisDefine.axisInfos[4].visiable;
        text7.visible = AxisDefine.axisInfos[0].visiable;
        text10.visible = AxisDefine.axisInfos[0].visiable;
        text11.visible = AxisDefine.axisInfos[5].visiable;
        text12.visible = AxisDefine.axisInfos[5].visiable;
        text15.visible = AxisDefine.axisInfos[2].visiable;
        text16.visible = AxisDefine.axisInfos[2].visiable;
        text24.visible = AxisDefine.axisInfos[3].visiable;
        text23.visible = AxisDefine.axisInfos[3].visiable;
        text18.visible = AxisDefine.axisInfos[1].visiable;
        text17.visible = AxisDefine.axisInfos[1].visiable;
        text21.visible = AxisDefine.axisInfos[4].visiable;
        text22.visible = AxisDefine.axisInfos[4].visiable;
        text14.visible = AxisDefine.axisInfos[0].visiable;
        text13.visible = AxisDefine.axisInfos[0].visiable;
        text19.visible = AxisDefine.axisInfos[5].visiable;
        text20.visible = AxisDefine.axisInfos[5].visiable;

        ptext4.visible = AxisDefine.axisInfos[2].visiable;
        ptext3.visible = AxisDefine.axisInfos[2].visiable;
        ptext6.visible = AxisDefine.axisInfos[3].visiable;
        ptext5.visible = AxisDefine.axisInfos[3].visiable;
        ptext9.visible = AxisDefine.axisInfos[1].visiable;
        ptext8.visible = AxisDefine.axisInfos[1].visiable;
        ptext2.visible = AxisDefine.axisInfos[4].visiable;
        ptext1.visible = AxisDefine.axisInfos[4].visiable;
        ptext10.visible = AxisDefine.axisInfos[0].visiable;
        ptext7.visible = AxisDefine.axisInfos[0].visiable;
        ptext11.visible = AxisDefine.axisInfos[5].visiable;
        ptext12.visible = AxisDefine.axisInfos[5].visiable;

        xSel.visible = AxisDefine.axisInfos[0].visiable;
        ySel.visible = AxisDefine.axisInfos[1].visiable;
        zSel.visible = AxisDefine.axisInfos[2].visiable;
        uSel.visible = AxisDefine.axisInfos[3].visiable;
        vSel.visible = AxisDefine.axisInfos[4].visiable;
        wSel.visible = AxisDefine.axisInfos[5].visiable;
        lineXSel.visible = AxisDefine.axisInfos[0].visiable;
        lineYSel.visible = AxisDefine.axisInfos[1].visiable;
        lineZSel.visible = AxisDefine.axisInfos[2].visiable;
        rotateUSel.visible = AxisDefine.axisInfos[3].visiable;
        rotateVSel.visible = AxisDefine.axisInfos[4].visiable;
        rotateWSel.visible = AxisDefine.axisInfos[5].visiable;

    }

}
