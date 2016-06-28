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
import "ExternalData.js" as ESData
import "../utils/stringhelper.js" as ICString
import "configs/AxisDefine.js" as AxisDefine
Rectangle {
    id:mainWindow
    width: Theme.defaultTheme.MainWindow.width
    height: Theme.defaultTheme.MainWindow.height
    property bool run_Ready: false
    property bool stop_Ready: false
    property bool return_Ready: false
    property bool output_off: false
    function onScreenSave(){
        panelRobotController.closeBacklight();
        loginDialog.setTologout();
    }

    function onScreenRestore(){
        panelRobotController.setBrightness(panelRobotController.getCustomSettings("Brightness", 8));
    }
    QtObject{
        id:pData
        property int lastKnob: -1
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
        function showStandbyPage(){
            var c = menuContainer.children;
            var page;
            for(var i = 0, len = c.length; i < len;++i){
                if(c[i].hasOwnProperty("setChecked")){
                    c[i].setChecked(false);
                }
                page = buttonToPage(c[i]);
                if(page == null) continue
                page.visible = false;
                page.focus = false;
            }
            standbyPage.visible = true;
            standbyPage.focus = true;
        }

        function onMenuItemTriggered(which){
            standbyPage.visible = false;
            var c = menuContainer.children;
            var page;
            for(var i = 0, len = c.length; i < len;++i){
                if(c[i] == which){
                    page = buttonToPage(which);
                    if(page == null) continue
                    page.visible = true;
                    page.focus = true;
                    continue;
                }
                if(c[i].hasOwnProperty("setChecked")){
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
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"

            }
            TabMenuItem{
                id:menuProgram
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: parent.height
                itemText: qsTr("Program")
                color: getChecked() ? "green" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"
            }
            TabMenuItem{
                id:menuSettings
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: parent.height
                itemText: qsTr("Settings")
                color: getChecked() ? "red" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"
            }
            onButtonClickedItem: {
                middleHeader.onMenuItemTriggered(item);
            }

        }
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
            id:standbyPage
//            source: "StandbyPage.qml"
            width: parent.width
            height: parent.height
        }

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
            visible: false
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

    OriginReturnmsg{
        id: originreturnmsgmsg
        z:100
        visible: false
        anchors.centerIn: parent
    }
    AutoAlarmTipPage{
        id:autoAlarmTipPage
        z:101
        visible: false
        anchors.centerIn: parent

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
        y:110
        //        x:pointManagerBtn.width
        width: 700
        height: 400
        z:4
        visible: armKeyboardContainer.visible


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
            width: 48
            height: 48
            anchors.bottom: parent.bottom
            bgColor: "green"
            icon: "images/tools_pointsmanage.png"
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

    StackCustomPointEditor{
        id:customPointEditor
        visible: false
        y:110
        width: 600
        height: 400
    }

    Item{
        id:armKeyboardContainer
        y:50
        x:800 - armKeyboardBtn.width
        width: 700
        height: 420
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
            width: 48
            height: 48
            bgColor: "green"
            iconPos: 1
            icon: "images/tools_keyboard.png"
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

    ICTimeLable{
        id:timelable
        anchors.right: parent.right
        anchors.rightMargin: armKeyboardBtn.width
        y:armKeyboardContainer.y

        form: "yyyy-MM-dd  hh:mm:ss  DDD"
    }

    function onKnobChanged(knobStatus){

        var isAuto = (knobStatus === Keymap.KNOB_AUTO);
        var isManual = (knobStatus === Keymap.KNOB_MANUAL);
        var isStop  = (knobStatus === Keymap.KNOB_SETTINGS);
        if(armKeyboard.visible) armKeyboardBtn.clicked();
        armKeyboardContainer.visible = isManual;

        onUserChanged(ShareData.UserInfo.current);
        menuSettings.enabled = (isStop);

        menuOperation.enabled = !isAuto;
        menuProgram.itemText = isAuto ? qsTr("V Program") : qsTr("Program");
        if(isAuto) {
            menuProgram.setChecked(true);
            //            recordPageInBtn.clicked();
        }
        if(!menuSettings.enabled && menuSettings.isChecked) menuProgram.setChecked(true);
        if(isManual){
            ShareData.GlobalStatusCenter.setGlobalSpeed(10.0);
            panelRobotController.modifyConfigValue("s_rw_0_16_1_294", 10.0);
            menuOperation.setChecked(true);
            middleHeader.onMenuItemTriggered(menuOperation);
        }else if(isAuto){
            var gsEn = parseInt(panelRobotController.getCustomSettings("IsTurnAutoSpeedEn", 0));
            if(gsEn > 0){
                var gS = panelRobotController.getCustomSettings("TurnAutoSpeed", 10.0);
                ShareData.GlobalStatusCenter.setGlobalSpeed(gS);
                panelRobotController.modifyConfigValue("s_rw_0_16_1_294", gS);
            }
        }else if(isStop){
            if(pData.lastKnob != knobStatus){
                middleHeader.showStandbyPage();
            }
        }
        pData.lastKnob = knobStatus;
    }

    function onUserChanged(user){
        var isRecordEn = ShareData.UserInfo.currentHasMoldPerm() && ShareData.GlobalStatusCenter.getKnobStatus() !== Keymap.KNOB_AUTO;

        menuSettings.enabled = !ShareData.UserInfo.isCurrentNoPerm() && ShareData.GlobalStatusCenter.getKnobStatus() === Keymap.KNOB_SETTINGS;
        if(menuSettings.isChecked && !menuSettings.enabled){
            //            menuOperation.setChecked(true);
            middleHeader.showStandbyPage();
        }

        mainHeader.setRecordItemEnabled(isRecordEn);
        if(!isRecordEn)
            recordPageInBtn.clicked();

    }

    function onETH0DataIn(data){
        console.log("raw data:", data);
        var posData = ESData.externalDataManager.parse(data);
        console.log("cam data:", JSON.stringify(posData));

        panelRobotController.sendExternalDatas(JSON.stringify(posData));
    }

    Component.onCompleted: {
        //        menuOperation.setChecked(true);
        panelRobotController.setScreenSaverTime(panelRobotController.getCustomSettings("ScreensaverTime", 5));
        panelRobotController.screenSave.connect(onScreenSave);
        panelRobotController.screenRestore.connect(onScreenRestore);

        Storage.initialize();
        IODefines.combineValveDefines(Storage.getSetting(panelRobotController.currentRecordName() + "_valve"));
        ShareData.GlobalStatusCenter.registeKnobChangedEvent(mainWindow);
        ShareData.UserInfo.registUserChangeEvent(mainWindow);
        panelRobotController.readCurrentKnobValue();
        ShareData.GlobalStatusCenter.setGlobalSpeed(10.0);
        panelRobotController.modifyConfigValue("s_rw_0_16_1_294", 10.0);
        mainHeader.setRecordItemEnabled(false);
        panelRobotController.setETh0Filter("test\r\n");
        panelRobotController.eth0DataComeIn.connect(onETH0DataIn);

        AxisDefine.changeAxisNum(panelRobotController.getConfigValue("s_rw_16_6_0_184"));
        onUserChanged(ShareData.UserInfo.currentUser());
        standbyPage.source = "StandbyPage.qml";
        console.log("main load finished!")
    }

    focus: true
    Keys.onPressed: {
        var key = event.key;
        //        console.log("Main key press exec", key);
        if(key === Keymap.KNOB_MANUAL ||
                key === Keymap.KNOB_SETTINGS ||
                key === Keymap.KNOB_AUTO){
            Keymap.currentKeySequence.length = 0;
        }
        else{
            Keymap.currentKeySequence.push(key);
            if(Keymap.currentKeySequence.length === Keymap.hwtestSequence.length){
                if(Keymap.matchHWTestSequence())
                    panelRobotController.runHardwareTest();
                else if(Keymap.matchRecalSequence()){
                    var tipC = Qt.createComponent("../ICCustomElement/ICMessageBox.qml");
                    var tip = tipC.createObject(mainWindow);
                    tip.z = 100;
                    tip.x = 300;
                    tip.y = 100;
                    tip.useKeyboard = true;
                    tip.acceptKey = Keymap.KEY_F4;
                    tip.rejectKey = Keymap.KEY_F5;
                    tip.accept.connect(function(){
                        panelRobotController.recal();
                    });
                    tip.show(qsTr("Recalibrate need to reboot. Continue?"), qsTr("Yes[F4]"), qsTr("No[F5]"));
                }

//                    panelRobotController
                Keymap.currentKeySequence.length = 0;
            }
        }

        if((key === Keymap.KEY_Stop) && (panelRobotController.currentErrNum() !== 0)){
            if(panelRobotController.currentMode() == Keymap.CMD_RUNNING ||
                    panelRobotController.currentMode() == Keymap.CMD_SINGLE){
                autoAlarmTipPage.visible = true;
                return;
            }
        }

        if(Keymap.isAxisKeyType(key)){
            Keymap.setKeyPressed(key, true);
        }else if(Keymap.isCommandKeyType(key)){
            if(key === Keymap.KNOB_MANUAL ||
                    key === Keymap.KNOB_SETTINGS ||
                    key === Keymap.KNOB_AUTO)
            {
                //                ShareData.knobStatus = key;
                ShareData.GlobalStatusCenter.setKnobStatus(key);
            }
//                        console.log("knob", key, Keymap.getKeyMappedAction(key));
            panelRobotController.sendKnobCommandToHost(Keymap.getKeyMappedAction(key));
        }else if(Keymap.isContinuousType(key)){
            Keymap.setKeyPressed(key, true);
        }

        event.accepted = true;

    }
    Keys.onReleased: {
        //        console.log("Main key release exec");
        var key = event.key;
        if(Keymap.isAxisKeyType(key)){
            Keymap.setKeyPressed(key, false);
        }else if(Keymap.isContinuousType(key)){
            Keymap.setKeyPressed(key, false);
            if(key === Keymap.KEY_Up || key === Keymap.KEY_Down)
                Keymap.endSpeedCaclByTimeStop();
        }

        event.accepted = true;
    }

    Timer{
        id:refreshTimer
        interval: 50; running: true; repeat: true
        onTriggered: {
            var pressedKeys = Keymap.pressedKeys();
            for(var i = 0 ; i < pressedKeys.length; ++i){
                // speed handler
                if(pressedKeys[i] === Keymap.KEY_Up || pressedKeys[i] === Keymap.KEY_Down){

                    var tuneGlobalSpeedEn = ShareData.GlobalStatusCenter.getTuneGlobalSpeedEn();
                    if(tuneGlobalSpeedEn){
                        var spd;
                        var speed = ShareData.GlobalStatusCenter.getGlobalSpeed();
                        spd = parseFloat(speed);
                        var dir = pressedKeys[i] === Keymap.KEY_Up ? 1 : -1;
                        //                        spd = Keymap.endSpeed(spd, dir)
                        spd = Keymap.endSpeedCalcByTime(spd, dir);
                        speed = spd.toFixed(1);
                        ShareData.GlobalStatusCenter.setGlobalSpeed(speed);
                        panelRobotController.modifyConfigValue("s_rw_0_16_1_294", speed);
                    }

                }else{
                    panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(pressedKeys[i]));
                }
            }
            if(!panelRobotController.isOrigined()){
                tipBar.tip = qsTr("Please press origin key and then press start key to find origin signal.")
                tipBar.visible = !originreturnmsgmsg.visible;
            }else{
                tipBar.visible = false;
            }

            if(panelRobotController.currentMode() == Keymap.CMD_STANDBY){
                panelRobotController.readCurrentKnobValue();
            }
            if(panelRobotController.currentMode() == Keymap.CMD_ORIGIN){
                originreturnmsgmsg.showForOrigin();
            }else if(panelRobotController.currentMode() == Keymap.CMD_RETURN){
                originreturnmsgmsg.showForReturn();
            }else if(panelRobotController.isOriginning()){
                originreturnmsgmsg.showForOriginning();
            }else if(panelRobotController.isReturnning()){
                originreturnmsgmsg.showForReturning();
            }else originreturnmsgmsg.hide();

            var alarmNum = panelRobotController.currentErrNum();
            if(alarmNum !== alarmBar.errID){
                alarmBar.errID = alarmNum;
                if(alarmNum == 7){
                    var toSend = IODefines.valveItemJSON("valve16");
                    panelRobotController.setYStatus(toSend, 0);
                    toSend = IODefines.valveItemJSON("valve17");
                    panelRobotController.setYStatus(toSend, 0);
                    toSend = IODefines.valveItemJSON("valve18");
                    panelRobotController.setYStatus(toSend, 0);
                    toSend = IODefines.valveItemJSON("valve19");
                    panelRobotController.setYStatus(toSend, 0);
                    toSend = IODefines.valveItemJSON("valve20");
                    panelRobotController.setYStatus(toSend, 0);
                    toSend = IODefines.valveItemJSON("valve21");
                    panelRobotController.setYStatus(toSend, 0);
                }

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
            var myiStatus = panelRobotController.iStatus(0);
            if(!(myiStatus & 0x400000))     //x36
                mainWindow.run_Ready = true;
            if(run_Ready && (myiStatus & 0x400000)){
                mainWindow.run_Ready = false;
                panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(Keymap.KEY_Run));
            }
            if(!(myiStatus & 0x800000))
                mainWindow.stop_Ready = true;
            if(stop_Ready && (myiStatus & 0x800000)){
                mainWindow.stop_Ready = false;
                panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(Keymap.KEY_Stop));
            }
            if(!(myiStatus & 0x1000000))
                mainWindow.return_Ready = true;
            if(return_Ready && (myiStatus & 0x1000000)){
                mainWindow.return_Ready = false;
                panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(Keymap.KEY_Return));
            }

//            myiStatus = panelRobotController.iStatus(1);
//            if((myiStatus & 0x8000))
//                mainWindow.stop_Ready = true;
//            if(mainWindow.stop_Ready && !(myiStatus & 0x8000)){
//                mainWindow.stop_Ready = false;
//                panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(Keymap.KEY_Stop));
//            }

//            if(!(myiStatus & 0x8000))
//                mainWindow.output_off = ture;
//            if(mainWindow.output_off && (myiStatus & 0x8000)){
//                mainWindow.output_off = false;
//                var toSend = IODefines.valveItemJSON("valve16");
//                panelRobotController.setYStatus(toSend, 0);
//                toSend = IODefines.valveItemJSON("valve17");
//                panelRobotController.setYStatus(toSend, 0);
//                toSend = IODefines.valveItemJSON("valve18");
//                panelRobotController.setYStatus(toSend, 0);
//                toSend = IODefines.valveItemJSON("valve19");
//                panelRobotController.setYStatus(toSend, 0);
//                toSend = IODefines.valveItemJSON("valve20");
//                panelRobotController.setYStatus(toSend, 0);
//                toSend = IODefines.valveItemJSON("valve21");
//                panelRobotController.setYStatus(toSend, 0);
//            }
        }
    }
}

