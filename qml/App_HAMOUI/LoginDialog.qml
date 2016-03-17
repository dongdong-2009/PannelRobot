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

    function setTologout(){
        ShareData.UserInfo.logout();
        logout();
        container.visible = false;
    }

    Rectangle {
        id: continer
        width: 360
        height: 180
        border.width: 1
        border.color: "black"
        anchors.centerIn: parent
        color: "#A0A0F0"

        Grid{
            anchors.centerIn: parent
            spacing: 8
            columns: 2
            Text {
                id: userNameLabel
                text: qsTr("User:")
                height: 32
                verticalAlignment: Text.AlignVCenter

            }
            ICComboBox{
                id:userName
                width: 200
                height: 32
                contentFontPixelSize: 18
                onVisibleChanged: {
                    if(visible){
                        items = ShareData.UserInfo.users();
                    }
                }
                onCurrentIndexChanged: warning.text = " ";
                z:100
            }
            Text {
                id: passwordLabel
                text: qsTr("Password:")
                height: 32
                verticalAlignment: Text.AlignVCenter

            }
            ICLineEdit{
                id:password
                height: 32
                isNumberOnly: false
                inputWidth: userName.width
                onTextChanged: warning.text = " ";
            }
            Text {
                id: nul
                height: 20
                text: qsTr(" ")
            }
            Text {
                id: warning
                height: 20
                text: (" ")
                color: "red"
            }
            ICButton{
                id:cancel
                text: qsTr("Cancel")
                height: 48
                onButtonClicked: container.visible = false
            }
            Row{
                ICButton{
                    id:logoutBtn
                    height: cancel.height
                    text: qsTr("Log out")
                    onButtonClicked: {
                        setTologout();
                    }
                    bgColor: "yellow"
                }
                ICButton{
                    id:loginBtn
                    height: cancel.height
                    text: qsTr("Login in")
                    onButtonClicked: {
                        if(ShareData.UserInfo.loginUser(userName.currentText(), password.text)){
                            loginSuccessful(userName.currentText());
                            container.visible = false;
                        }else warning.text = (qsTr("password is incorrect!!"));flicker.running = true;
                    }
                    bgColor: "lime"
                }
                SequentialAnimation{
                    id: flicker
                    loops: 3
                    running: false
                    PropertyAnimation{ target: warning;properties: "color";to:"transparent";duration: 100}
                    PropertyAnimation{ target: warning;properties: "color";to:"red";duration: 100}
                }
            }
        }

        onVisibleChanged: {
            if(visible){
                userName.currentIndex = -1;
                password.text = "";
            }

        }
    }
}
