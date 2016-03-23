import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap

MouseArea{
    id:container
    width: 800
    height: 600
    x:0
    y:0
    property alias hinttext: hinttext.text
    property alias msgtext: msgtext.text

    function showForOrigin(){
        hinttext = qsTr("please press startup button to origin");
        if(!visible)
            visible = true;
    }

    function showForReturn(){
        hinttext = qsTr("please press startup button to return");
        if(!visible)
            visible = true;
    }

    function hide(){
        if(visible)
            visible = false;
    }

    Rectangle {
        id: continer
        width: 650
        height: 80
        border.width: 1
        border.color: "black"
        anchors.centerIn: parent
        color: "#A0A0F0"


        Text {
            id: hinttext
            anchors.horizontalCenter: parent.horizontalCenter
            y:6
        }
        ICButton{
            id:stop
            text: qsTr("Stop")
            anchors.top: hinttext.bottom
            anchors.topMargin: 6
            x:10
            onButtonClicked: {
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_STOP);
            }
        }

        ICButtonGroup{
            anchors.top: hinttext.bottom
            anchors.topMargin: 6
            anchors.right: parent.right
            anchors.rightMargin: 20
            mustChecked: true
            ICCheckBox{
                id:nearOrigin
                text: qsTr("Near Origin")
            }
            ICCheckBox{
                id:logedPos
                text:qsTr("Emergence before shutdow")
            }
            onCheckedItemChanged: {
                if(checkedItem == nearOrigin)
                    panelRobotController.modifyConfigValue(28, 1);
                else if(checkedItem == logedPos)
                    panelRobotController.modifyConfigValue(28, 2);
            }
            onVisibleChanged: {
                nearOrigin.setChecked(true);
            }
        }

        Text {
            id: msgtext
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 6
            anchors.rightMargin: 6
            visible: false
        }
    }
}
