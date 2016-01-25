import QtQuick 1.1
import '.'
import '../ICCustomElement'
import 'teach'
import "Theme.js" as Theme
import "configs/Keymap.js" as Keymap
import "ShareData.js" as ShareData
import "../utils/Storage.js" as Storage
import "configs/IODefines.js" as IODefines
import "ICOperationLog.js" as ICOperationLog
Rectangle {
    id:mainWindow
    width: Theme.defaultTheme.MainWindow.width
    height: Theme.defaultTheme.MainWindow.height
    function onScreenSave(){
        panelRobotController.closeBacklight();
        loginDialog.setTologout();
    }

    function onScreenRestore(){
        panelRobotController.setBrightness(panelRobotController.getCustomSettings("Brightness", 8));
    }


    TopHeader{
        id:mainHeader
        z:4
        width: mainWindow.width
        height: mainWindow.height * Theme.defaultTheme.MainWindow.topHeaderHeightProportion
        onRecordItemStatusChanged: {
            if(isChecked){
                recordManagementPage.visible = true
                pageOutAnimation.target = recordManagementPage;
                pageOutAnimation.start();
            }else{
                pageInAnimation.start();
            }
        }
        onIoItemStatusChanged: {
            if(isChecked){
                ioPage.visible = true;
                pageOutAnimation.target = ioPage;
                pageOutAnimation.start();
            }else{
                pageInAnimation.start();
            }
        }
        onLoginBtnClicked: loginDialog.visible = true
        onCalculatorItemStatusChanged: calculator.visible = isChecked
        onAlarmLogItemStatusChanged: {
            if(isChecked){
                alarmlogPageContainer.visible = true;
                pageOutAnimation.target = alarmlogPageContainer;
                pageOutAnimation.start();
            }else{
                pageInAnimation.start();
            }
        }
    }
    Rectangle{
        id:middleHeader
        width: mainWindow.width
        height: mainWindow.height * Theme.defaultTheme.MainWindow.middleHeaderHeightProportion
        color: Theme.defaultTheme.BASE_BG
        anchors.top: mainHeader.bottom
        //        z:1
        function buttonToPage(which){
            if(which == menuOperation) {

                return manualPage;
            }
            else if(which == menuSettings) {

                return settingPage;
            }
            else if(which == menuProgram){
                return programPage
            }

            else return null;
        }
        function onMenuItemTriggered(which){
            var c = menuContainer.children;
            var page;
            for(var i = 0; i < c.length;++i){
                if(c[i] == which){
                    page = buttonToPage(which);
                    if(page == null) continue
                    page.visible = true;
                    page.focus = true;
                    continue;
                }
                if(c[i].hasOwnProperty("setChecked")){
                    //                    c[i].setChecked(false);
                    page = buttonToPage(c[i]);
                    if(page == null) continue
                    page.visible = false;
                    page.focus = false;

                }
            }
        }



        ICButtonGroup{
            id:menuContainer
            width: parent.width
            height: parent.height
            isAutoSize: false
            //            z: 1
            TabMenuItem{
                id:menuOperation
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: parent.height
                itemText: qsTr("Operation")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor

            }
            TabMenuItem{
                id:menuProgram
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: parent.height
                itemText: qsTr("Program")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor

            }
            TabMenuItem{
                id:menuSettings
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: parent.height
                itemText: qsTr("Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            }
            onButtonClickedItem: {
                middleHeader.onMenuItemTriggered(item);
            }

        }
        //        ICTextEdit{
        //            width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderTI1Proportion;
        //            height: parent.height
        //            text: "0"
        //            focus: false
        //        }
        //        ICTextEdit{
        //            width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderTI2Proportion;
        //            height: parent.height
        //            text:qsTr("Sample")
        //            focus: false
        //            anchors.left:
        //        }

    }

    Item{
        id:container
        width: mainWindow.width
        height: mainWindow.height * Theme.defaultTheme.MainWindow.containerHeightProportion
        anchors.top: middleHeader.bottom
        anchors.bottom: parent.bottom
        //        anchors.topMargin: 1
        focus: true
        Loader{
            id:settingPage
            source: "settingpages/SettingsPage.qml"
            anchors.fill: parent
            width: parent.width
            height: parent.height
            visible: false
        }
        Loader{
            id:manualPage
            width: parent.width
            height: parent.height
            source: "ManualPage.qml"
            //            anchors.fill: parent
            //            visible: false
        }
        Loader{
            id:programPage
            source: "teach/ProgramPage.qml"
            anchors.fill: parent
            visible: false
        }
        Component.onCompleted: {
            console.log("main.container",container.width, container.height)
        }
    }
    PropertyAnimation{
        id:pageOutAnimation
        target: ioPage
        property: "y"
        to:48
        duration: 100
    }
    SequentialAnimation{
        id:pageInAnimation
        PropertyAnimation{
            target: pageOutAnimation.target
            property: "y"
            to:-385
            duration: 100
        }
        PropertyAction{
            target: pageOutAnimation.target
            property: "visible"
            value: false
        }
    }
    Column{
        id:ioPage
        visible: false
        y:-385
        width: parent.width
        height: parent.height
        z:3

        IOPage{
            width: parent.width
            height: container.height - 95
        }
        ICButton{
            id:ioPageInBtn
            width: 40
            bgColor: "yellow"
            text: qsTr("↑")
            anchors.horizontalCenter: parent.horizontalCenter
            onButtonClicked: {
                mainHeader.resetStatus();
            }
        }

    }
    Column{
        id:recordManagementPage
        visible: false
        y:-385
        width: parent.width
        height: parent.height
        z:3

        RecordManagementPage{
            width: parent.width
            height: container.height - 95
        }
        ICButton{
            id:recordPageInBtn
            width: 40
            bgColor: "yellow"
            text: qsTr("↑")
            anchors.horizontalCenter: parent.horizontalCenter
            onButtonClicked: {
                mainHeader.resetStatus();
            }
        }
    }
    Column{
        id:alarmlogPageContainer
        visible: false
        y:-385
        width: parent.width
        height: parent.height
        z:3

        Rectangle{
            width: parent.width
            height: container.height - 95
            color: "#d1d1d1"
            Column{
                spacing: 4
                anchors.fill: parent
                ICButtonGroup{
                    mustChecked: true
                    spacing: 20
                    ICCheckBox{
                        id:alarmSel
                        text: qsTr("Alarm Log")
                        isChecked: true
                    }
                    ICCheckBox{
                        id:operationSel
                        text:qsTr("Operation Log")
                    }
                }

                ICAlarmPage{
                    id:alarmlogPage
                    width: parent.width
                    height: parent.height - alarmSel.height - parent.spacing
                    visible: alarmSel.isChecked
                }
                ICOperationLogPage{
                    id:operationLog
                    width: parent.width
                    height: parent.height - alarmSel.height - parent.spacing
                    visible: operationSel.isChecked
                }
            }
        }

        ICButton{
            id:alarmLogPageInBtn
            width: 40
            bgColor: "yellow"
            text: qsTr("↑")
            anchors.horizontalCenter: parent.horizontalCenter
            onButtonClicked: {
                mainHeader.resetStatus();
            }
        }
    }

    LoginDialog{
        id:loginDialog
        visible: false
        z:1000
        anchors.centerIn: parent
        onLogout: {
            mainHeader.loginUser = qsTr("Login");
            ICOperationLog.appendOperationLog(qsTr("Sign out"));

        }
        onLoginSuccessful: {
            mainHeader.loginUser = user;
            ICOperationLog.appendOperationLog(user + " " + qsTr("Sign in"));
        }
    }
    ParaChose{
        id:paraChose
        visible: false
        anchors.centerIn: parent
    }

    ICCalculator{
        id:calculator
        z:100
        visible: false
        anchors.centerIn: parent
        color: "#A0A0F0"
    }

    ICAlarmBar{
        id:alarmBar
        width: 798
        height: 42
        y:508
        x:1
        z:2
        //        errID: 1
    }
    ICTipBar{
        id:tipBar
        width: 798
        height: 42
        y:508
        x:1
    }

    Item{
        id:pointManagerContainer
        y:100
//        x:pointManagerBtn.width
        width: 700
        height: 400
        z:4

        PropertyAnimation{
            id:pointManagerOut
            target: pointManagerContainer
            property: "x"
            to: 650
            duration: 100
        }
        SequentialAnimation{
            id:pointManagerIn
            PropertyAnimation{
                target: pointManagerContainer
                property: "x"
                to: 0
                duration: 100
            }
            PropertyAction{
                target: pointManager
                property: "visible"
                value:false
            }
        }

        ICButton{
            id:pointManagerBtn
            text: "→"
            width: 40
            anchors.bottom: parent.bottom
            bgColor: "green"
            onButtonClicked: {
                if(!pointManager.visible){
                    pointManager.visible = true;
                    pointManagerOut.start();
                    text = "←";
                }else{
                    text = "→";
                    //                    armKeyboard.visible = false;
                    pointManagerIn.start();
                }
            }
        }

        PointManager{
            id:pointManager
            anchors.right:  pointManagerBtn.left
            visible: false
        }
    }

    Item{
        id:armKeyboardContainer
        y:60
        x:800 - armKeyboardBtn.width
        width: 700
        height: 400
        z:4

        PropertyAnimation{
            id:armKeyboardOut
            target: armKeyboardContainer
            property: "x"
            to: 100
            duration: 100
        }
        SequentialAnimation{
            id:armKeyboardIn
            PropertyAnimation{
                target: armKeyboardContainer
                property: "x"
                to: 800 - armKeyboardBtn.width
                duration: 100
            }
            PropertyAction{
                target: armKeyboard
                property: "visible"
                value:false
            }
        }

        ICButton{
            id:armKeyboardBtn
            text: "←"
            width: 40
            bgColor: "green"
            onButtonClicked: {
                if(!armKeyboard.visible){
                    armKeyboard.visible = true;
                    armKeyboardOut.start();
                    text = "→";
                }else{
                    text = "←";
                    //                    armKeyboard.visible = false;
                    armKeyboardIn.start();
                    mainWindow.focus = true;
                }
            }
        }

        ArmMovePage{
            id:armKeyboard
            anchors.left: armKeyboardBtn.right
            visible: false
        }


    }

    function onKnobChanged(knobStatus){
        var isAuto = (knobStatus === Keymap.KNOB_AUTO)
        if(armKeyboard.visible) armKeyboardBtn.clicked();
        armKeyboardContainer.visible = !isAuto;
        //        mainWindow.focus = true;
        menuSettings.enabled = !isAuto;
        menuProgram.itemText = isAuto ? qsTr("V Program") : qsTr("Program");
        if(isAuto) menuProgram.setChecked(true);
        if(knobStatus === Keymap.KNOB_MANUAL){
            ShareData.GlobalStatusCenter.setGlobalSpeed(10.0);
            panelRobotController.modifyConfigValue("s_rw_0_16_1_294", 10.0);
        }
    }

    Component.onCompleted: {
        menuOperation.setChecked(true);
        panelRobotController.setScreenSaverTime(panelRobotController.getCustomSettings("ScreensaverTime", 5));
        panelRobotController.screenSave.connect(onScreenSave);
        panelRobotController.screenRestore.connect(onScreenRestore);

        Storage.initialize();
        IODefines.combineValveDefines(Storage.getSetting(panelRobotController.currentRecordName() + "_valve"));
        ShareData.GlobalStatusCenter.registeKnobChangedEvent(mainWindow);
        panelRobotController.readCurrentKnobValue();
        ShareData.GlobalStatusCenter.setGlobalSpeed(10.0);
        panelRobotController.modifyConfigValue("s_rw_0_16_1_294", 10.0);
        console.log("main load finished!")
    }

    focus: true
    Keys.onPressed: {
        var key = event.key;
        console.log("Main key press exec", key);
        if(Keymap.isAxisKeyType(key)){
            Keymap.setKeyPressed(key, true);
        }
        else if(Keymap.isCommandKeyType(key)){
            if(key === Keymap.KNOB_MANUAL ||
                    key === Keymap.KNOB_SETTINGS ||
                    key === Keymap.KNOB_AUTO)
            {
                //                ShareData.knobStatus = key;
                ShareData.GlobalStatusCenter.setKnobStatus(key);
            }
            panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(key));
        }else{
            // pully speed handler
            var spd;
            var pu = Keymap.PULLY_UP;
            var pd = Keymap.PULLY_DW;
            if(!panelRobotController.isQWS()){
                pu = parseInt(0x01000037);
                pd = parseInt(0x01000039);
            }

            if(key === pu || key === pd){
                var tuneGlobalSpeedEn = ShareData.GlobalStatusCenter.getTuneGlobalSpeedEn();
                if(tuneGlobalSpeedEn){
                    var speed = ShareData.GlobalStatusCenter.getGlobalSpeed();
                    spd = parseFloat(speed);
                    var dir = key === pu ? 1 : -1;
                    spd = Keymap.endSpeed(spd, dir)
                    speed = spd.toFixed(1);
                    ShareData.GlobalStatusCenter.setGlobalSpeed(speed);
                    panelRobotController.modifyConfigValue("s_rw_0_16_1_294", speed);
                }
            }
        }

        event.accepted = true;

    }
    Keys.onReleased: {
        console.log("Main key release exec");
        var key = event.key;
        if(Keymap.isAxisKeyType(key)){
            Keymap.setKeyPressed(key, false);
        }
        event.accepted = true;
    }

    Timer{
        id:refreshTimer
        interval: 50; running: true; repeat: true
        onTriggered: {
            var pressedKeys = Keymap.pressedKeys();
            for(var i = 0 ; i < pressedKeys.length; ++i){
                //                console.log("Send command:", key);
                panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(pressedKeys[i]));
            }
            if(!panelRobotController.isOrigined()){
                tipBar.tip = qsTr("Please press origin key and then press start key to find origin signal.")
                tipBar.visible = true;
            }else{
                tipBar.visible = false;
            }

            var alarmNum = panelRobotController.currentErrNum();
            if(alarmNum !== alarmBar.errID){
                alarmBar.errID = alarmNum;
                if(alarmNum === 0){
                    alarmlogPage.resolvedAlarms();
                }else{
                    alarmlogPage.appendAlarm(alarmNum);
                }

                if(alarmNum === 2){
                    paraChose.visible = true;
                }else{
                    paraChose.visible = false;
                }
            }

        }
    }
}

