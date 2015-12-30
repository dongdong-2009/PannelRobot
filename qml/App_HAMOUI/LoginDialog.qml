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
        width: 360
        height: 140
        border.width: 1
        border.color: "black"
        anchors.centerIn: parent

        Grid{
            anchors.centerIn: parent
            spacing: 6
            columns: 2
            Text {
                id: userNameLabel
                text: qsTr("User:")
            }
            ICComboBox{
                id:userName
                width: 200
                onVisibleChanged: {
                    if(visible){
                        items = ShareData.UserInfo.users();
                    }
                }
                z:100
            }
            Text {
                id: passwordLabel
                text: qsTr("Password:")
            }
            ICLineEdit{
                id:password
                isNumberOnly: false
                inputWidth: userName.width
            }
            ICButton{
                id:cancel
                text: qsTr("Cancel")
                onButtonClicked: container.visible = false
            }
            Row{
                ICButton{
                    id:logoutBtn
                    text: qsTr("Log out")
                    onButtonClicked: {
                        setTologout();
                    }
                }
                ICButton{
                    id:loginBtn
                    text: qsTr("Login in")
                    onButtonClicked: {
                        if(ShareData.UserInfo.loginUser(userName.currentText, password.text)){
                            loginSuccessful(userName.currentText);
                            container.visible = false;
                        }
                    }
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
