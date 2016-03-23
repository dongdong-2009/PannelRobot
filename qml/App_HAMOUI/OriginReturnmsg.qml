import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap

MouseArea{
    id:container
    width: 800
    height: 600
    x:0
    y:0
    property alias msgtext: msgtext.text

    function showForOrigin(){
        hinttext.text = qsTr("please press startup button to origin");
        if(!visible){
            originMode.visible = true;
            visible = true;
        }
    }

    function showForOriginning(){
        hinttext.text = qsTr("Originning");
        if(!visible){
//            originMode.visible = true;
            visible = true;
        }
    }

    function showForReturn(){
        hinttext.text = qsTr("please press startup button to return");
        if(!visible){
            originMode.visible = false;
            visible = true;
        }
    }

    function showForReturning(){
        hinttext.text = qsTr("Returning");
        if(!visible){
            originMode.visible = false;
            visible = true;
        }
    }

    function hide(){
        if(visible)
            visible = false;
    }

    Rectangle {
        id: continer
        width: 450
        height: 140
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
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            x:10
            onButtonClicked: {
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_KEY_STOP);
            }
        }

        ICButtonGroup{
            id:originMode
            anchors.top: hinttext.bottom
            anchors.topMargin: 6
            anchors.right: parent.right
            anchors.rightMargin: 20
            mustChecked: false
            layoutMode: 1
            spacing: 6
            ICCheckBox{
                id:nearOrigin
                text: qsTr("Near Origin")
            }
            ICCheckBox{
                id:logedPos
                text:qsTr("Emergence before shutdow")
            }
            ICCheckBox{
                id:reOrigin
                text:qsTr("ReOrigin")
            }

            onCheckedItemChanged: {
                if(checkedItem == nearOrigin)
                    panelRobotController.modifyConfigValue(28, 1);
                else if(checkedItem == logedPos)
                    panelRobotController.modifyConfigValue(28, 2);
                else if(checkedItem == reOrigin)
                    panelRobotController.modifyConfigValue(28, 3);
            }
            onVisibleChanged: {
//                if(checkedItem != nearOrigin)
                if(checkedItem != null)
                    checkedItem.setChecked(false);
//                else
//                    panelRobotController.modifyConfigValue(28, 1);
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
