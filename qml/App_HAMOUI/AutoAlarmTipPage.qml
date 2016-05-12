import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap

MouseArea {
    id:container
    width: 800
    height: 600
    x:0
    y:0
    Rectangle {
        id: continer
        width: 300
        height: 60
        border.width: 1
        border.color: "black"
        anchors.centerIn: parent
        color: "#A0A0F0"

        Row{
            anchors.centerIn: parent
            ICButton{
                id:continueRun
                text: qsTr("Continue")
                bgColor: "red"
                onButtonClicked: {
                    container.visible = false;
                    panelRobotController.sendKeyCommandToHost(Keymap.CMD_KEY_CONTINUE);

                }
            }
            ICButton{
                id:cancel
                text: qsTr("Cancel")
                bgColor: "lime"
                onButtonClicked: {
                    container.visible = false;
                }
            }
        }
    }
}
