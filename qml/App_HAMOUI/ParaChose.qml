import QtQuick 1.1
import "../ICCustomElement"
import "ShareData.js" as ShareData

MouseArea{
    id:container
    width: 800
    height: 600
    x:0
    y:0

    signal loginSuccessful(string user)
    signal logout();

    Rectangle {
        width: 360
        height: 140
        border.width: 1
        border.color: "black"
        anchors.centerIn: parent
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 6
            id: paraDiff
            text: qsTr("Host configs and panel configs is different,please chose!")
        }
        Row{
            spacing: 50
            anchors.centerIn: parent
            ICButton{
                id:chose_manual
                text: qsTr("chose manual")
                onButtonClicked: {
                    panelRobotController.modifyConfigValue(1,
                                                           4097);

                }
            }
            ICButton{
                id:chose_host
                text: qsTr("chose host")
                onButtonClicked: {
                    panelRobotController.modifyConfigValue(1,
                                                           4096);

                }
            }
            ICButton{
                id:cancel
                text: qsTr("Cancel")
                onButtonClicked: {
                    container.visible = false;
                }
            }
        }
    }

}
