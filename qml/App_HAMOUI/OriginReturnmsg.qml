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
        originMode.visible = false;

    }

    function showForOriginning(){
        hinttext.text = qsTr("Originning");
//        if(!visible){
//            //            originMode.visible = true;

//        }
        originMode.visible = false;
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
        ICFlickable{
//            isshowhint: helpText.visible
            width: 280
            height: originMode.height - 20
            clip: true
            flickableDirection: Flickable.VerticalFlick
            contentWidth: helpText.width
            contentHeight: helpText.height
            anchors.top: hinttext.bottom
            anchors.topMargin: 6
            Text {
                id: helpText
                visible: false
                width: parent.width
                wrapMode: Text.WrapAnywhere
                text: qsTr("1.Mode 1\n2.Mode 2\n3.Mode 3")
            }
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
        ICButton{
            id:help
            text: qsTr("Show Help")
            y:stop.y
            anchors.left: stop.right
            anchors.leftMargin: 20
            onButtonClicked: {
                helpText.visible = !helpText.visible;
                text = helpText.visible ? qsTr("Hide Help") : qsTr("Show Help");
            }
        }

        ICButtonGroup{
            id:originMode
            visible: false
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
                if(!visible){
                    if(checkedItem != null){
                        checkedItem.setChecked(false);
                        checkedItem = null;
                    }
                    helpText.visible = false;
                    help.text = qsTr("Show Help");
                }
                else panelRobotController.modifyConfigValue(28, 3);

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
