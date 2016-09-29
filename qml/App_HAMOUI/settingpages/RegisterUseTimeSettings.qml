import QtQuick 1.1
import "../../ICCustomElement"
import "../ShareData.js" as ShareData


Item {
    id:instance
    x:20
    y:20
    Column{
        spacing: 6
        Row
        {
            id: restTimeLable
            visible: false
            spacing: 6
            Text {
                text: qsTr("Rest Time:")
            }
            Text {
                id: restTime
                Component.onCompleted: {
                    setRestTime(panelRobotController.restUseTime());
                }

                function setRestTime(rt){
                    if(rt == 0)
                        restTime.text = qsTr("Forever")
                    else
                        restTime.text = rt + qsTr("hour")
                }
            }
        }
        Row{
            spacing: 6
            visible: false
            Text {
                id:mcL
                text: qsTr("Machine Code:")
            }
            Text {
                id: machineCode
            }
        }
        ICConfigEdit{
            id:registerEdit
            configName: qsTr("Register Code:")
            configNameWidth: mcL.width
            inputWidth: 200
//            isNumberOnly: false
        }

        Row{
            spacing: 6
            anchors.right: registerEdit.right
            ICButton{
                id:generateMachineCodeBtn
                visible: false
                width: 200
                text:qsTr("Generate Machine Code")
                onButtonClicked: {
                    machineCode.text = panelRobotController.generateMachineCode();
                }
            }
            Text {
                id: tip
                color: "red"
                anchors.verticalCenter: parent.verticalCenter
            }
//            ICButton{
//                id:registerBtn
//                text: qsTr("Register")
//                onButtonClicked: {
//                    var rt = panelRobotController.registerUseTime(factoryCode.configValue,
//                                                                  machineCode.text,
//                                                                  registerEdit.configValue);
//                    if(rt < 0){
//                        tip.text = qsTr("Wrong register code!");
//                    }else{
//                        tip.text = qsTr("Register successfully!");
//                        restTime.setRestTime(rt);
//                    }
//                }
//            }
            ICButton{
                id:registerBtn
                text: qsTr("Register")
                onButtonClicked: {
                    var currentDate = new Date();
                    var yy = currentDate.getFullYear();
                    var mm = currentDate.getMonth() + 1;
                    var dd =  currentDate.getDate();
                    var hh =  currentDate.getHours();
                    var hours2 = (((year2.text - yy)*12 + (month2.text - mm))*30 + day2.text - dd)*24 - hh;
                    var hours3 = (((year3.text - yy)*12 + (month3.text - mm))*30 + day3.text - dd)*24 - hh;
                    if(registerEdit.configValue == lockcode1.text){
                        restTimeEdit.configValue = hours2;
                        restTime.setRestTime(hours2);
                        tip.text = qsTr("Register successfully!");
                    }
                    else if(registerEdit.configValue == lockcode2.text){
                        restTimeEdit.configValue = hours3;
                        restTime.setRestTime(hours3);
                        tip.text = qsTr("Register successfully!");
                    }
                    else if(registerEdit.configValue == lockcode3.text){
                        restTimeEdit.configValue = 0;
                        restTime.setRestTime(0);
                        restTimeLable.visible = true;
                        tip.text = qsTr("Register successfully!");
                    }
                    else{
                        tip.text = qsTr("Wrong register code!");
                    }
                }
            }
        }
        ICConfigEdit{
            id:factoryCode
            visible: false
            configName: qsTr("Factory code(6bit):")
            configValue: panelRobotController.factoryCode();
        }
        ICConfigEdit{
            id:restTimeEdit
            visible: false
            configName: qsTr("Rest Time(0 Forever):")
            configValue: panelRobotController.restUseTime();
            unit: qsTr("hour")
        }
    }
    ICButton{
        id:setLockCode
        text: ""
//        visible: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        border.color: "transparent"
        bgColor: "transparent"
        width: 150
        onButtonClicked: {
            container.visible = true;
        }
    }
    MouseArea{
        id: container
        parent: mainWindow
        z: 1000
        height: 600
        width: 800
        visible: false
        Rectangle{
//            id: container
            radius: 15
            width: 360
            height: 140 + (setpassword.visible ? setpassword.height : 0) + (warning.visible ? warning.height : 0)
//            visible: false
            anchors.centerIn: parent
            border.width: 1
            border.color: "black"
            color: "#A0A0F0"
            Column{
                spacing: 10
                anchors.centerIn: parent
                Row{
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
                        inputWidth: 200
                        onTextChanged: warning.text = "";
                    }
                }
                Row{
                    x: password.x
                    ICButton{
                        id:cancel
                        text: qsTr("Cancel")
                        bgColor: "yellow"
                        height: 48
                        onButtonClicked: container.visible = false
                    }
                    ICButton{
                        id:ok
                        text: qsTr("OK")
                        bgColor: "green"
                        height: 48
                        onButtonClicked: {
                            if(password.text == panelRobotController.getCustomSettings("s_rw_0_32_0_848",0)){
                                container.visible = false;
                                timelimit.visible = true;
                            }
                            else{
                                warning.text = (qsTr("Paswrd is Incorrect!"));
                                flicker.running = true;
                            }
                        }
                    }
                }
                SequentialAnimation{
                    id: flicker
                    loops: 3
                    running: false
                    PropertyAnimation{ target: warning;properties: "color";to:"transparent";duration: 100}
                    PropertyAnimation{ target: warning;properties: "color";to:"red";duration: 100}
                }
                Text {
                    id: warning
                    x: password.x
                    height: 20
                    text: ""
                    color: "red"
                    visible: text.length > 0
                }
                ICConfigEdit{
                    id:setpassword
                    isNumberOnly: false
                    configName: qsTr("Setpaswd:")
                    configValue: panelRobotController.getCustomSettings("s_rw_0_32_0_848",0)
                    inputWidth: 200
    //                configAddr: "s_rw_0_32_0_848"
                    onConfigValueChanged: {
                        panelRobotController.setCustomSettings("s_rw_0_32_0_848",configValue);
    //                    panelRobotController.syncConfigs();
                    }
                }
            }
            onVisibleChanged: {
                if(visible){
                    password.text = "";
                }

            }
        }
    }
    MouseArea{
        id: timelimit
        parent: mainWindow
        z: 1000
        height: 600
        width: 800
        visible: false
        ICLineEdit{
            id:enabledate
            height: 32
            width: 150
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            rectangle.border.color: "transparent"
            rectangle.color: "transparent"
//            isNumberOnly: false
            inputWidth: 100
            onTextChanged: {
                if(text == 88888){
                    panelRobotController.setCustomSettings("unablemerge",0);
                    tipMessg.information(qsTr("Lock Enable,Please Restart to Take Effect"));
                    timelimit.visible = false;
                }
                text = "";
            }
        }
        Rectangle{
            height: 300
            width: 600
            radius: 15
            anchors.centerIn: parent
            border.width: 1
            border.color: "black"
            color: "#A0A0F0"
            Column{
                id: dateset
                spacing: 20
                anchors.centerIn: parent
                Row{
                    spacing: 5
                    Text {
                        id: firsttime
                        text: qsTr("FirTime:")
                    }
                    ICLineEdit{
                        id:year1
                        unit: qsTr("year")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockyear1",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockyear1",text);
                    }
                    ICLineEdit{
                        id:month1
                        unit: qsTr("mon")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockmonth1",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockmonth1",text);
                    }
                    ICLineEdit{
                        id:day1
                        unit: qsTr("day")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockday1",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockday1",text);
                    }
                    ICLineEdit{
                        id:lockcode1
                        unit: qsTr("LockCode")
                        alignMode: 1
                        visible: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockcode1",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockcode1",text);
                    }
                }
                Row{
                    spacing: 5
                    Text {
                        id: middletime
                        text: qsTr("MidTime:")
                    }
                    ICLineEdit{
                        id:year2
                        unit: qsTr("year")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockyear2",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockyear2",text);
                    }
                    ICLineEdit{
                        id:month2
                        unit: qsTr("mon")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockmonth2",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockmonth2",text);
                    }
                    ICLineEdit{
                        id:day2
                        unit: qsTr("day")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockday2",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockday2",text);
                    }
                    ICLineEdit{
                        id:lockcode2
                        unit: qsTr("LockCode")
                        alignMode: 1
                        visible: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockcode2",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockcode2",text);
                    }
                }
                Row{
                    spacing: 5
                    Text {
                        id: finaltime
                        text: qsTr("FinTime:")
                    }
                    ICLineEdit{
                        id:year3
                        unit: qsTr("year")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockyear3",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockyear3",text);
                    }
                    ICLineEdit{
                        id:month3
                        unit: qsTr("mon")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockmonth3",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockmonth3",text);
                    }
                    ICLineEdit{
                        id:day3
                        unit: qsTr("day")
                        alignMode: 1
                        enabled: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockday3",0)
                        onTextChanged: panelRobotController.setCustomSettings("lockday3",text);
                    }
                    ICLineEdit{
                        id:lockcode3
                        unit: qsTr("LockCode")
                        alignMode: 1
                        visible: JSON.parse(panelRobotController.getCustomSettings("unablemerge",0)) ? false : true
                        text: panelRobotController.getCustomSettings("lockcode3",1)
                        onTextChanged: panelRobotController.setCustomSettings("lockcode3",text);
                    }
                }
            }
            Row{
                anchors.right: dateset.right
                anchors.top: dateset.bottom
                anchors.topMargin: 30
                spacing: 30
                ICButton{
                    id:lockcancel
                    text: qsTr("Cancel")
                    bgColor: "yellow"
                    height: 48
                    onButtonClicked: timelimit.visible = false
                }
                ICButton{
                    id:lockok
                    text: qsTr("OK")
                    bgColor: "green"
                    height: 48
                    onButtonClicked: {
                        var currentDate = new Date();
                        var yy = currentDate.getFullYear();
                        var mm = currentDate.getMonth() + 1;
                        var dd =  currentDate.getDate();
                        var hh =  currentDate.getHours();
                        var hours = (((year1.text - yy)*12 + (month1.text - mm))*30 + day1.text - dd)*24 - hh;
                        restTimeEdit.configValue = hours;
                        panelRobotController.setCustomSettings("unablemerge",1);
                        tipMessg.information(qsTr("Lock Success,Please Restart to Take Effect"));
                        timelimit.visible = false;
                    }
                }
            }
        }
    }
    ICMessageBox{
        id:tipMessg
        x:300
        y:150
        z:3
        onAccept: panelRobotController.reboot()
    }
    function lockCodeSeted(isSeted){

    }


    function onUserChanged(user){
        var isSuper = ShareData.UserInfo.currentHasRootPerm();
//        restTimeEdit.visible = isSuper;
//        factoryCode.visible = isSuper;
        setpassword.visible = isSuper;
        enabledate.visible = isSuper;
    }

    function onFCChanged(){
        panelRobotController.setFactoryCode(factoryCode.configValue);
    }

    function onRTChanged(){
        panelRobotController.setRestUseTime(restTimeEdit.configValue);
        restTime.setRestTime(panelRobotController.restUseTime());
    }

    Component.onCompleted: {
        ShareData.UserInfo.registUserChangeEvent(instance);
        factoryCode.configValueChanged.connect(onFCChanged);
        restTimeEdit.configValueChanged.connect(onRTChanged);
    }
}
