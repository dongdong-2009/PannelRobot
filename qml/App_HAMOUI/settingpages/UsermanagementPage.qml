import QtQuick 1.1
import "../../ICCustomElement"
import "../ShareData.js" as ShareData

Item {
    id:myItem
    width: parent.width
    height: parent.height
    function perms(perm){
        switch(parseInt(perm)){
        case 0: op.setChecked(true);mold.setChecked(false);system.setChecked(false);user.setChecked(false);break;
        case 1: op.setChecked(false);mold.setChecked(true);system.setChecked(false);user.setChecked(false);break;
        case 2: op.setChecked(false);mold.setChecked(false);system.setChecked(true);user.setChecked(false);break;
        case 3: op.setChecked(false);mold.setChecked(true);system.setChecked(true);user.setChecked(false);break;
        case 4: op.setChecked(false);mold.setChecked(false);system.setChecked(false);user.setChecked(true);break;
        case 5: op.setChecked(false);mold.setChecked(true);system.setChecked(false);user.setChecked(true);break;
        case 6: op.setChecked(false);mold.setChecked(false);system.setChecked(true);user.setChecked(true);break;
        case 7: op.setChecked(false);mold.setChecked(true);system.setChecked(true);user.setChecked(true);break;
        default: op.setChecked(false);mold.setChecked(false);system.setChecked(false);user.setChecked(false);break;
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
                            text: user.name
                            wrapMode: Text.WordWrap
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    userView.currentIndex = index;
                                    username.configValue = userModel.get(index).user.name;

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
                                if(userModel.count == 0)
                                    return
                                var u
                                var isNew = true;
                                for(var i =0 , len = userModel.count; i < len; i++){
                                    u = userModel.get(i).user;
                                    if(username.configValue == u.name){
                                        userView.currentIndex = i;
                                        perms(u[ShareData.USERS_TB_INFO.perm_col]);
                                        password.configValue = u[ShareData.USERS_TB_INFO.password_col];
                                        isNew = false;
                                        break;
                                    }
                                }
                                if(isNew){
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
                            ShareData.UserInfo.deleteUser(userModel.get(userView.currentIndex)[ShareData.USERS_TB_INFO.user_name_col]);
                            userModel.remove(userView.currentIndex);
                            if(userView.currentIndex >= 0)
                                username.configValue = userModel.get(userView.currentIndex).name;
                        }
                    }
                    ICButton{
                        id:okBtn
                        text: qsTr("ok")
                        radius:5
                        enabled: true
                        onButtonClicked: {
                            if(username.configValue == "" || password.configValue == ""){
                                msg.warning(qsTr("username or password can not be empty!!"));
                                return;
                            }
                            var newAddbuffer = {};
                            newAddbuffer.name = username.configValue;
                            var isnew = true;
                            for(var i =0, len = userModel.count;i < len;i++){
                                if(username.configValue == userModel.get(i).user.name){
                                    isnew = false;
                                    break;
                                }
                            }
                            newAddbuffer.password = password.configValue;
                            var perm1 = (op.isChecked ? 0 : 0);
                            var perm2 = (mold.isChecked ? 1 : 0);
                            var perm3 = (system.isChecked ? 2 : 0);
                            var perm4 = (user.isChecked ? 4 : 0);
                            newAddbuffer.perm = perm1 + perm2 + perm3 + perm4;
                            if(!op.isChecked)
                                if(newAddbuffer.perm == 0){
                                    msg.warning(qsTr("please set perm!!"));
                                    return;
                                }
                            if(isnew){
                                userModel.append({"user":newAddbuffer});
                                userView.currentIndex = userModel.count - 1;
                                ShareData.UserInfo.addUser(newAddbuffer.name,newAddbuffer.password,parseInt(newAddbuffer.perm));
                            }else{
                                userModel.setProperty(i, "user", newAddbuffer);
                                ShareData.UserInfo.updateUser(newAddbuffer.name, newAddbuffer.password, parseInt(newAddbuffer.perm));
                            }

                        }
                    }
                }
            }

        }
        ICMessageBox{
            id:msg
            z:100
            x: 300
            y: 100
        }

        Component.onCompleted: {
            var u = ShareData.UserInfo.users_();
            for(var i = 0, len = u.length; i < len; ++i){
                if(u[i].name === "szhcroot"){
                    u.splice(i, 1);
                    break;
                }
            }

            for(i = 0 ;i < u.length;i++){
                userModel.append({"user": u[i]});
            }
            userView.currentIndex = -1;
        }
    }
}



