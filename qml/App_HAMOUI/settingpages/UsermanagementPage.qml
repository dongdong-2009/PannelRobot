import QtQuick 1.1
import "../../ICCustomElement"
import "../ShareData.js" as ShareData

Item {
    id:myItem
    width: parent.width
    height: parent.height
    property bool isnew: true
    property variant usermsgBuff: []
    function perms(perm){
        switch(parseInt(perm)){
        case 0: op.isChecked = true;mold.isChecked = false;system.isChecked = false;user.isChecked = false;break;
        case 1: op.isChecked = false;mold.isChecked = true;system.isChecked = false;user.isChecked = false;break;
        case 2: op.isChecked = false;mold.isChecked = false;system.isChecked = true;user.isChecked = false;break;
        case 3: op.isChecked = false;mold.isChecked = true;system.isChecked = true;user.isChecked = false;break;
        case 4: op.isChecked = false;mold.isChecked = false;system.isChecked = false;user.isChecked = true;break;
        case 5: op.isChecked = false;mold.isChecked = true;system.isChecked = false;user.isChecked = true;break;
        case 6: op.isChecked = false;mold.isChecked = false;system.isChecked = true;user.isChecked = true;break;
        case 7: op.isChecked = false;mold.isChecked = true;system.isChecked = true;user.isChecked = true;break;
        default: op.isChecked = false;mold.isChecked = false;system.isChecked = false;user.isChecked = false;break;
        }
    }
    Rectangle{
        id:container
        width: parent.width
        height: parent.height
        //        border.width: 1
        //        border.color: "black"
        //        anchors.centerIn: parent
        Row{
            spacing: 30
            anchors.centerIn: parent
            Row{
                Text {
                    id: nameList
                    text: qsTr("namelist:")
                }
                Rectangle{
                    id: opa
                    border.color: "black"
                    width: username.width - 30
                    height: 130
                    ListModel {
                        id:userModel
                    }
                    ListView {
                        id:userView
                        width: parent.width - 5
                        height: parent.height - 5
                        model: userModel
                        clip: true
                        anchors.centerIn: parent
                        highlight: Rectangle {width: opa.width; height: 20;color: "lightsteelblue"; radius: 5}
                        highlightMoveDuration:100
                        delegate: Text {
                            width: parent.width
                            text: name
                            wrapMode: Text.WordWrap
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    userView.currentIndex = index;
                                    username.configValue = userModel.get(index).name;
                                }
                            }
                        }

                    }
                }
            }

            Column{
                spacing: 10
                Row{
                    spacing: 20
                    Column{
                        spacing: 40
                        ICConfigEdit{
                            id:username
                            isNumberOnly: false
                            configName: qsTr("username:")
                            inputWidth: 200
                            onConfigValueChanged: {
                                if(ShareData.UserInfo.userscount() == 0)
                                    isnew = true;
                                if(userModel.count == 0)
                                    return
                                for(var i =0 ;i < ShareData.UserInfo.userscount();i++){
                                    if(username.configValue == userModel.get(i).name){
                                        okBtn.enabled = false;
                                        isnew = false;
                                        userView.currentIndex = i;
                                        usermsgBuff  = ShareData.UserInfo.users_();
                                        perms(usermsgBuff[i][ShareData.USERS_TB_INFO.perm_col]);
                                        password.configValue = usermsgBuff[i][ShareData.USERS_TB_INFO.password_col];
                                        break;
                                    }else isnew = true;
                                }
                                if(isnew){
                                    okBtn.enabled = true;
                                    op.isChecked = false;
                                    mold.isChecked = false;
                                    system.isChecked = false;
                                    user.isChecked = false;
                                    password.configValue = "";
                                }
                            }
                        }
                        ICConfigEdit{
                            id:password
                            isNumberOnly: false
                            configName: qsTr("password:")
                            inputWidth: 200
                        }
                    }
                    Column{
                        spacing: 2
                        ICCheckBox{
                            width: 20
                            height: 20
                            id: op
                            text: "op"
                        }
                        ICCheckBox{
                            width: 20
                            height: 20
                            id: mold
                            text: "mold"
                        }
                        ICCheckBox{
                            width: 20
                            height: 20
                            id: system
                            text: "system"
                        }
                        ICCheckBox{
                            width: 20
                            height: 20
                            id: user
                            text: "user"
                        }
                    }
                }
                Row{
                    spacing: 30
                    ICButton{
                        id:cancelBtn
                        text: qsTr("cancel")
                        radius:5
                        onButtonClicked: {
                            op.isChecked = false;
                            mold.isChecked = false;
                            system.isChecked = false;
                            user.isChecked = false;
                            username.configValue = "";
                            password.configValue = "";
                        }
                    }
                    ICButton{
                        id:deleteBtn
                        text: qsTr("delete")
                        radius:5
                        onButtonClicked: {
                            ShareData.UserInfo.deleteUser(usermsgBuff[userView.currentIndex][ShareData.USERS_TB_INFO.user_name_col]);
                            usermsgBuff  = ShareData.UserInfo.users_();
                            userModel.remove(userView.currentIndex);
                            if(userView.currentIndex >= 0)
                                username.configValue = userModel.get(userView.currentIndex).name;
                            if(userModel.count == 0){
                                okBtn.enabled = true;
                                isnew = true;
                            }
                        }
                    }
                    ICButton{
                        id:okBtn
                        text: qsTr("ok")
                        radius:5
                        enabled: false
                        onButtonClicked: {
                            var newAddbuffer = [];
                            newAddbuffer[0] = username.configValue;
                            for(var i =0 ;i < userModel.count;i++){
                                if(username.configValue == userModel.get(i).name){
                                    isnew = false;
                                    break;
                                }else isnew = true;
                            }
                            newAddbuffer[1] = password.configValue;
                            var perm1 = (op.isChecked ? 0 : 0);
                            var perm2 = (mold.isChecked ? 1 : 0);
                            var perm3 = (system.isChecked ? 2 : 0);
                            var perm4 = (user.isChecked ? 4 : 0);
                            newAddbuffer[2] = perm1 + perm2 + perm3 + perm4;
                            if(isnew){
//                                userModel.insert(0,{"name": newAddbuffer[0]});
                                userModel.append({"name": newAddbuffer[0]});
                                userView.currentIndex = userModel.count - 1;
                                ShareData.UserInfo.addUser(newAddbuffer[0],newAddbuffer[1],parseInt(newAddbuffer[2]));
                                usermsgBuff  = ShareData.UserInfo.users_();
                                okBtn.enabled = false;
                            }

                        }
                    }
                }
            }

        }

        Component.onCompleted: {
            usermsgBuff  = ShareData.UserInfo.users_();
            username.configValue = usermsgBuff[0][ShareData.USERS_TB_INFO.user_name_col];
            password.configValue = usermsgBuff[0][ShareData.USERS_TB_INFO.password_col];
            perms(usermsgBuff[0][ShareData.USERS_TB_INFO.perm_col]);
            for(var i = 0 ;i < usermsgBuff.length;i++){
                userModel.append({"name": usermsgBuff[i][ShareData.USERS_TB_INFO.user_name_col]});
            }
        }
    }
}



