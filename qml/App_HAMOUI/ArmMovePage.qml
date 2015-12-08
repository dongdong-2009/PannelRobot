import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap
import "teach"


Item {
    width: parent.width
    height: parent.height
    function sendCommand(cmd, type){
        panelRobotController.modifyConfigValue(24,
                                               type);
        panelRobotController.sendKeyCommandToHost(cmd);
    }

    Column{
        x:500
        y:200
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
                width: 50
                height: 32
                Text {
                    id: speed
                    anchors.centerIn: parent
                    onVisibleChanged: {
                        if(visible){
                            speed.text = "10.000";
                            panelRobotController.setConfigValue("s_rw_0_16_3_265", 10.000);
                        }
                    }
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
        x:50
        ICButton {
            id: text4


            width: 70
            height:48
            text: qsTr("Z-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NZ, Keymap.SINGLE_ARM_MOVE_TYPE)


        }
        ICButton {
            id: text3


            width: 70
            height:48
            text: qsTr("Z+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PZ, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text6
            width: 70
            height:48
            text: qsTr("U-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NU, Keymap.SINGLE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text5


            width: 70
            height:48
            text: qsTr("U+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PU, Keymap.SINGLE_ARM_MOVE_TYPE)


        }



        ICButton {
            id: text9


            width: 70
            height:48
            text: qsTr("Y-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NY, Keymap.SINGLE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text8


            width: 70
            height:48
            text: qsTr("Y+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PY, Keymap.SINGLE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text2


            width: 70
            height:48
            text: qsTr("V-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NV, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text1


            width: 70
            height:48
            text: qsTr("V+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PV, Keymap.SINGLE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text10


            width: 70
            height:48
            text: qsTr("X-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NX, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text7


            width: 70
            height:48
            text: qsTr("X+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PX, Keymap.SINGLE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text11


            width: 70
            height:48
            text: qsTr("W-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NW, Keymap.SINGLE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text12


            width: 70
            height:48
            text: qsTr("W+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PW, Keymap.SINGLE_ARM_MOVE_TYPE)


        }



        ICButton {
            id: text15


            width: 70
            height:48
            text: qsTr("Line Z-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NZ, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text16


            width: 70
            height:48
            text: qsTr("Line Z+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PZ, Keymap.COMBINE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text23


            width: 70
            height:48
            text: qsTr("Rotate U-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NU, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text24


            width: 70
            height:48
            text: qsTr("Rotate U+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PU, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text18


            width: 70
            height:48
            text: qsTr("Line Y-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NY, Keymap.COMBINE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text17


            width: 70
            height:48
            text: qsTr("Line Y+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PY, Keymap.COMBINE_ARM_MOVE_TYPE)
        }

        ICButton {
            id: text21


            width: 70
            height:48
            text: qsTr("Rotate V-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NV, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text22
            width: 70
            height:48
            text: qsTr("Rotate V+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PV, Keymap.COMBINE_ARM_MOVE_TYPE)
        }


        ICButton {
            id: text13


            width: 70
            height:48
            text: qsTr("Line X-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NX, Keymap.COMBINE_ARM_MOVE_TYPE)

        }

        ICButton {
            id: text14


            width: 70
            height:48
            text: qsTr("Line X+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PX, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text19


            width: 70
            height:48
            text: qsTr("Rotate W-")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_NW, Keymap.COMBINE_ARM_MOVE_TYPE)


        }

        ICButton {
            id: text20


            width: 70
            height:48
            text: qsTr("Rotate W+")
            onButtonClicked: sendCommand(Keymap.CMD_JOG_PW, Keymap.COMBINE_ARM_MOVE_TYPE)

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
            speed.text = spd
        }else if(key === Keymap.KEY_Down){
            spd = parseFloat(speed.text);
            spd -= 0.100
            if(spd <= 0)
                spd = 0;
            speed.text = spd
        }
        event.accepted = true;
    }
}
