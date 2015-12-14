import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap
import "teach"


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
        x:360
        y:10
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

    onVisibleChanged: {
        if(visible){
            speed.text = "10.000";
            panelRobotController.setConfigValue("s_rw_0_16_3_265", 10.000);
        }

    }

    focus: visible
    Keys.onPressed: {
        var key = event.key;
        var spd;
        if(key === Keymap.KEY_Up){
            spd = parseFloat(speed.text);
            spd += 0.100
            if(spd >= 100)
                spd = 100.000;
            speed.text = spd.toFixed(3);
            event.accepted = true;

        }else if(key === Keymap.KEY_Down){
            spd = parseFloat(speed.text);
            spd -= 0.100
            if(spd <= 0)
                spd = 0;
            speed.text = spd.toFixed(3);
            event.accepted = true;

        }
        else
            speed.text = key
    }
}
