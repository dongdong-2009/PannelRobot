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
import "teach/Teach.js" as Teach
import "teach/ManualProgramManager.js" as ManualProgramManager
import "ToolCoordManager.js" as ToolCoordManager
import "settingpages/RunningConfigs.js" as Mdata
import "../utils/utils.js" as Utils

Rectangle {
    id:mainWindow
    width: Theme.defaultTheme.MainWindow.width
    height: Theme.defaultTheme.MainWindow.height
    property bool isInit: false
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
        property int lastAxis: 0
    }
    ICMessageBox{
        id:tipBox
        x:300
        y:200
        visible: false
        z:1000
    }
    Text {
        id: restTip
        color: "red"
        y:timelable.y
        anchors.right: timelable.left
        anchors.rightMargin: 6
        z:1000
        font.pixelSize: 14
        function setRestTime(rt){
            visible = (rt < 168) && rt != 0;
            text = qsTr("Rest Time:") + rt;
        }
        Component.onCompleted: {
            setRestTime(panelRobotController.restUseTime());
        }
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
                return programPage;
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
            width: parent.width
            height: parent.height
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
            id:recordManagementPageInstance
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
                    x:6
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

    ICMessageBox{
        id: tipForstartup
        x:300
        y:200
        z: 101
        visible: false
     }

    ParaChose{
        id:paraChose
        visible: false
        anchors.centerIn: parent
    }

    ICMessageBox{
        id:originAlarm
        z:1001
        visible: false
        x:200
        y:200
        onAccept: {
            panelRobotController.modifyConfigValue(28, 4);
        }
        onReject: {
            panelRobotController.sendKeyCommandToHost(Keymap.CMD_KEY_STOP);
        }
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
        onHourGone: restTip.setRestTime(panelRobotController.restUseTime());
//        onSecondGone: restTip.setRestTime(panelRobotController.restUseTime());
    }


    function onKnobChanged(knobStatus){
        //        var toTest = {
        //            "dsID":"www.geforcevision.com.cam",
        //            "dsData":[
        //                {
        //                    "camID":"0",
        //                    "data":[
        //                        {"ModelID":"0","X":57.820,"Y":475.590,"Angel":0.002,"ExtValue_0":null,"ExtValue_1":null}
        //                    ]
        //                }
        //            ]
        //        };
//                var toTest = {
//                    "dsID":"www.geforcevision.com.cam",
//                    "dsData":[
//                        {
//                            "camID":"0",
//                            "data":[
//                                {"ModelID":"0","X":"197.171","Y":"491.124","Angel": "-85.684","ExtValue_0":null,"ExtValue_1":null},
//                                {"ModelID":"0","X":"197.171","Y":"491.124","Angel": "-85.684","ExtValue_0":null,"ExtValue_1":null},
//                            ]
//                        }
//                    ]
//                };
//        var toTest = {
//            "dsID":"www.geforcevision.com.cam",
//            "dsData":[
//                {
//                    "camID":"0",
//                    "data":[
//                        {"ModelID":"0","X":"7.209","Y":"404.623","Angel":"1.185","ExtValue_0":"0.000","ExtValue_1":"0.000"},
//                    ]
//                }
//            ]
//        }

        //        var toTest = {
        //            "dsID":"www.geforcevision.com.cam",
        //            "reqType":"listModel",
        //            "currentModel":{"name":"模板名称","modelID":0},
        //            "data":
        //            [
        //                {
        //                    "name":"模板名称",
        //                    "models":
        //                    [
        //                        {"id":0, "offsetX":1.000, "offsetY":2.000, "offsetA":3.000, "modelImgPath":"http://图片在视觉服务器系统中的路径.png"},
        //                        {"id":1, "offsetX":1.000, "offsetY":2.000, "offsetA":3.000, "modelImgPath":"http://图片在视觉服务器系统中的路径.png"},
        //                    ]
        //                },
        //                {
        //                    "name":"模板名称",
        //                    "models":
        //                    [
        //                        {"id":0, "offsetX":1.000, "offsetY":2.000, "offsetA":3.000, "modelImgPath":"http://图片在视觉服务器系统中的路径.png"},
        //                        {"id":1, "offsetX":1.000, "offsetY":2.000, "offsetA":3.000, "modelImgPath":"http://图片在视觉服务器系统中的路径.png"},
        //                    ]
        //                },
        //            ]
        //        };

//                onETH0DataIn(JSON.stringify(toTest));
//        onETH0DataIn('{"dsID":"www.geforcevision.com.cam","dsData":[{"camID":"0","data":[{"ModelID":"0","X":"7.209","Y":"404.623","Angel":"1.185","ExtValue_0":"0.000","ExtValue_1":"0.000"},]}]}')
        //        var toTest = {
        //            "dsID":"www.geforcevision.com.cam",
        //            "reqType":"standardize",
        //            "camID":0,
        //            "data":[
        //                { "X":0.000,"Y":0.000 },
        //                { "X":0.000,"Y":0.000 },
        //                { "X":0.000,"Y":0.000 }
        //            ]
        //        };

        //        var toTest = {
        //            "dsID":"www.geforcevision.com.cam",
        //            "reqType":"photo",
        //            "camID":0,
        //        };

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
            if(panelRobotController.getConfigValue("s_rw_0_32_0_211") == 0){
                ShareData.GlobalStatusCenter.setGlobalSpeed(10.0);
                //            panelRobotController.modifyConfigValue("s_rw_0_16_1_294", 10.0);
                panelRobotController.modifyConfigValue("s_rw_0_32_1_212", 10.0);
            }
            menuOperation.setChecked(true);
            middleHeader.onMenuItemTriggered(menuOperation);
        }else if(isAuto){
            var gsEn = parseInt(panelRobotController.getCustomSettings("IsTurnAutoSpeedEn", 0));
            if(gsEn > 0){
                var gS = panelRobotController.getCustomSettings("TurnAutoSpeed", 10.0);
                ShareData.GlobalStatusCenter.setGlobalSpeed(gS);
                //                panelRobotController.modifyConfigValue("s_rw_0_16_1_294", gS);
                panelRobotController.modifyConfigValue("s_rw_0_32_1_212", gS);
            }
        }else if(isStop){
            if(pData.lastKnob != knobStatus){
                middleHeader.showStandbyPage();
            }
        }
        ShareData.GlobalStatusCenter.setTuneGlobalSpeedEn(isManual);
        mainHeader.speed = ShareData.GlobalStatusCenter.getGlobalSpeed();
        pData.lastKnob = knobStatus;
        pData.lastAxis = 0;
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
        var posData = ESData.externalDataManager.parse(String(data));
        console.log("cam data:", JSON.stringify(posData));
        var usid = JSON.parse(panelRobotController.usedSourceStacks());
        for(var sid in usid){
            if(usid[sid] == posData.hostID){
                var stackInfo = Teach.currentRecord.stackManager.getStackInfoFromID(sid);
                if(stackInfo.si0.doesBindingCounter){
                    var c = Teach.currentRecord.counterManager.getCounter(stackInfo.si0.counterID);
                    Teach.currentRecord.counterManager.updateCounter(c.id, c.name, c.current, c.target);
                    panelRobotController.saveCounterDef(c.id, c.name, c.current, c.target);
                    counterUpdated(c.id);
                }
            }
        }
        if(posData.reqType == "query")
            panelRobotController.sendExternalDatas(JSON.stringify(posData));
        recordManagementPageInstance.onGetVisionData(posData);
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
        //        panelRobotController.modifyConfigValue("s_rw_0_16_1_294", 10.0);
        panelRobotController.modifyConfigValue("s_rw_0_32_1_212", 10.0);
        mainHeader.setRecordItemEnabled(false);
        panelRobotController.setETh0Filter("test\r\n");
        panelRobotController.eth0DataComeIn.connect(onETH0DataIn);

        var axisNum = panelRobotController.getConfigValue("s_rw_16_6_0_184");
        AxisDefine.changeAxisNum(axisNum);
        var m = [];
        m[0] = panelRobotController.getConfigValue("s_rw_31_1_0_104");
        m[1] = panelRobotController.getConfigValue("s_rw_31_1_0_111");
        m[2] = panelRobotController.getConfigValue("s_rw_31_1_0_118");
        m[3] = panelRobotController.getConfigValue("s_rw_31_1_0_125");
        m[4] = panelRobotController.getConfigValue("s_rw_31_1_0_132");
        m[5] = panelRobotController.getConfigValue("s_rw_31_1_0_139");
        m[6] = panelRobotController.getConfigValue("s_rw_31_1_0_146");
        m[7] = panelRobotController.getConfigValue("s_rw_31_1_0_153");
        AxisDefine.changeAxisVisble(m,axisNum);

        var axisUnit = [];
        axisUnit[0] = panelRobotController.getConfigValue("s_rw_24_4_0_104");
        axisUnit[1] = panelRobotController.getConfigValue("s_rw_24_4_0_111");
        axisUnit[2] = panelRobotController.getConfigValue("s_rw_24_4_0_118");
        axisUnit[3] = panelRobotController.getConfigValue("s_rw_24_4_0_125");
        axisUnit[4] = panelRobotController.getConfigValue("s_rw_24_4_0_132");
        axisUnit[5] = panelRobotController.getConfigValue("s_rw_24_4_0_139");
        axisUnit[6] = panelRobotController.getConfigValue("s_rw_24_4_0_146");
        axisUnit[7] = panelRobotController.getConfigValue("s_rw_24_4_0_153");
        for(var i=0;i<8;++i)
            AxisDefine.changeAxisUnit(i, axisUnit[i]);

        onUserChanged(ShareData.UserInfo.currentUser());
        standbyPage.source = "StandbyPage.qml";
        panelRobotController.sendingContinuousData.connect(function(){
            tipBox.runningTip(qsTr("Sending Data..."), qsTr("Get it"));
        });
        panelRobotController.sentContinuousData.connect(function(t){
            tipBox.hide();
        });
        panelRobotController.needToInitHost.connect(function(){
            panelRobotController.manualRunProgram(JSON.stringify(ManualProgramManager.manualProgramManager.getProgram(0).program),
                                                  "","", "", "", 19, false);
            panelRobotController.manualRunProgram(JSON.stringify(ManualProgramManager.manualProgramManager.getProgram(1).program),
                                                  "","", "", "", 18, false);

            var i;
            var sI;
            var len;
            var toSendStackData = new ESData.RawExternalDataFormat(-1, []);
            for(i = 0; i < Teach.currentRecord.stackManager.stackInfos.length; ++i){
                sI = Teach.currentRecord.stackManager.stackInfos[i];
                if(sI.dsHostID >= 0 && sI.posData.length > 0){
                    ESData.externalDataManager.registerDataSource(sI.dsName,
                                                                  ESData.CustomDataSource.createNew(sI.dsName, sI.dsHostID));
                    toSendStackData.dsID = sI.dsName;
                    toSendStackData.dsData = sI.posData;
                    var posData = ESData.externalDataManager.parseRaw(toSendStackData);
                    panelRobotController.sendExternalDatas(JSON.stringify(posData));
                }
            }

            var toolCoords = ToolCoordManager.toolCoordManager.toolCoordList();
            for(i =0;i<toolCoords.length;++i){
                panelRobotController.sendToolCoord(toolCoords[i].id,JSON.stringify(toolCoords[i].info));
            }

            var v,isNormal=true,ret=[];
            var iosettings = JSON.parse(panelRobotController.getCustomSettings("IOSettings", "[]", "IOSettings"));
            for(i = 0, len = iosettings.length; i < len; ++i){
                v = iosettings[i];
                if(v.check == true){
                    console.log("send:");
                    /*
typedef union {
struct{
uint16_t on:1;//< 输出 普通IO或则M值 0为断，1为通
uint16_t id:7;//< 输出点ID 普通IO或则M值
uint16_t out_type:1;//< 输出类型 0为普通输出，1为M值输出
uint16_t type:5;//< 类型
uint16_t res:2;//< 预留
}bit;
uint16_t io_all;
}IORunningSetting;//< IO运行设定
*/
                    var value = 0;
                    value=v.outstatus_init?1:0;
                    if(v.outType_init==0){
                        ret = Mdata.getOutIDFromConfig(v.outid_init);
                        value|=ret[1]<<1;
                        isNormal = ret[0];
                    }
                    else{
                        value|=v.outid_init<<1;
                    }
//                    value|=v.outid_init<<1;
                    value|=v.outType_init<<8;
                    value|=v.sendMode<<9;
                    value|=isNormal<<14;
                    console.log(isNormal,ret[1],value);
                    panelRobotController.modifyConfigValue(13,value);
                }
            }
            iosettings = JSON.parse(panelRobotController.getCustomSettings("IOCheckSet", "[]", "IOCheckSet"));
            for(i = 0, len = iosettings.length; i < len; ++i){
                v = iosettings[i];
                if(v.check == true){
                    console.log("send:");
                    value =v.checkStatus?1:0;
                    value|=v.checkId<<1;
                    value|=v.checkType<<8;
                    value|=v.outStatus<<10;
                    if(v.outType==0){
                        ret = Mdata.getOutIDFromConfig(v.outId);
                        value|=ret[1]<<11;
                        isNormal = ret[0];
                    }else{
                        value|=v.outId<<11;
                    }
                    value|=v.outType<<18;
                    value|=isNormal<<19;
                    console.log(isNormal,ret[1],value);
                    panelRobotController.modifyConfigValue(32,value);
                }
            }

            isInit = true;
        });
        //        panelRobotController.manualRunProgram(JSON.stringify(ManualProgramManager.manualProgramManager.getProgram(0).program),
        //                                              "","", "", "", 19);
        //        panelRobotController.manualRunProgram(JSON.stringify(ManualProgramManager.manualProgramManager.getProgram(1).program),
        //                                              "","", "", "", 18);

        mainHeader.speed = ShareData.GlobalStatusCenter.getGlobalSpeed();
        refreshTimer.start();
        console.log("main load finished!");
    }

    focus: true
    Keys.onPressed: {
        var key = event.key;
        if(key == 16777248) return;
//        console.log("Main key press exec", key);
        if(key === Keymap.KNOB_MANUAL ||
                key === Keymap.KNOB_SETTINGS ||
                key === Keymap.KNOB_AUTO){
            Keymap.currentKeySequence.length = 0;
        }
        else
        {
            Keymap.currentKeySequence.push(key);
            if(Keymap.currentKeySequence.length === Keymap.hwtestSequence.length)
            {
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
                }else if(Keymap.matchGhostSequence()){
                    var tipG = Qt.createComponent("../ICCustomElement/ICMessageBox.qml");
                    var tipGO = tipG.createObject(mainWindow);
                    tipGO.z = 100;
                    tipGO.x = 300;
                    tipGO.y = 100;
                    tipGO.useKeyboard = true;
                    tipGO.acceptKey = Keymap.KEY_F4;
                    tipGO.rejectKey = Keymap.KEY_F5;
                    var name = Utils.formatDate(new Date, "yyyyMMddhhmmss");
                    tipGO.accept.connect(function(){
                        tipGO.useKeyboard = false;
                        tipGO.runningTip(qsTr("Exporting..."));
                        panelRobotController.makeGhost(name, Storage.backup());
                        panelRobotController.exportGhost(name + ".ghost.hcdb");
                        tipGO.hide();
                        mainWindow.focus = true;
                    });
                    tipGO.reject.connect(function(){
                        tipGO.hide();
                        mainWindow.focus = true;
                    });
                    tipGO.show(qsTr("Need to ghost and export to U Disk?\nThe name of ghost is ") + name,
                               qsTr("Yes[F4]"), qsTr("No[F5]"));

                }
                //                    panelRobotController
                Keymap.currentKeySequence.length = 0;
            }
        }
        if(panelRobotController.currentErrNum() !== 7){
            var keyStatus = [key === Keymap.KEY_F1,key === Keymap.KEY_F2,key === Keymap.KEY_F3,
                    key === Keymap.KEY_F4,key === Keymap.KEY_F5];
            handControlButtonBandingOperationPressed(keyStatus);
        }

        if((key === Keymap.KEY_Stop) && (panelRobotController.currentErrNum() !== 0)){
            if(panelRobotController.currentMode() == Keymap.CMD_RUNNING ||
                    panelRobotController.currentMode() == Keymap.CMD_SINGLE){
                autoAlarmTipPage.visible = true;
                return;
            }
        }

        var stopBtnEn = parseInt(panelRobotController.getCustomSettings("X47UseForStop", 0));
        var stopBtnStatus = panelRobotController.isInputOn(037,IODefines.IO_BOARD_0);//x047
        if(key === Keymap.KEY_Run && stopBtnStatus == 1 && stopBtnEn == 1){
            tipForstartup.information(qsTr("Please confirm your stop signal off"),qsTr("Get it"));
            return;
        }
        tipForstartup.visible = false;



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
            //            console.log(Keymap.getKeyMappedAction(key));
            if(panelRobotController.isTryTimeOver() && key == Keymap.KNOB_AUTO){
                tipBox.warning(qsTr("Please Register!"));
            }else
                panelRobotController.sendKnobCommandToHost(Keymap.getKeyMappedAction(key));
        }else if(Keymap.isContinuousType(key)){
            Keymap.setKeyPressed(key, true);
        }

        event.accepted = true;

    }
    Keys.onReleased: {
        //        console.log("Main key release exec");
        var key = event.key;
        if(Keymap.isAxisKeyType(key))
        {
            Keymap.setKeyPressed(key, false);
        }else if(Keymap.isContinuousType(key))
        {
            Keymap.setKeyPressed(key, false);
            if(key === Keymap.KEY_Up || key === Keymap.KEY_Down)
                Keymap.endSpeedCaclByTimeStop();
        }
        if(panelRobotController.currentErrNum() !== 7){
            var keyStatus = [key === Keymap.KEY_F1,key === Keymap.KEY_F2,key === Keymap.KEY_F3,
                    key === Keymap.KEY_F4,key === Keymap.KEY_F5];
            handControlButtonBandingOperationReleased(keyStatus);
        }
        event.accepted = true;
    }


    function handControlLEDBandingOperation()
    {
        var handControSetting = Mdata.ledKesSetData;
        if(handControSetting.length==10)
        {
            for(var i = 0; i < 5; ++i)
            {
                var board=0,s=0;
                if(handControSetting[i].functionCheck)
                {
                    var id = handControSetting[i].bindingNum;
                    switch(handControSetting[i].bindingType)
                    {
                    default:
                    case 0:
                        board=IODefines.IO_BOARD_0+parseInt(id/32);
                        id = id%32;
                        s=panelRobotController.isInputOn(id,board);
//                        console.log("bangding input:"+id+"status:"+s);
                        break;
                    case 1:
                        board=IODefines.IO_BOARD_0+parseInt(id/32);
                        id = id%32;
                        s=panelRobotController.isOutputOn(id,board);
//                        console.log("bangding output"+id+"status:"+s);
                        break;
                    case 2:
                        board=IODefines.M_BOARD_0+parseInt(id/32);
                        id = id%32;
                        s=panelRobotController.isOutputOn(id,board);
//                        console.log("bangding M value"+id+"status:"+s);
                        break;
                    }
                }
                panelRobotController.setLEDStatus(i,s);
            }
        }
    }

    function handControlButtonBandingOperationPressed(keyStatus)
    {
        var handControSetting = Mdata.ledKesSetData;
        if(handControSetting.length==10)
        {
            var setTmp ={};
            var j,len;
            for(var i = 5;i < 10; ++i)
            {
                setTmp = handControSetting[i];
                if(setTmp.functionCheck && keyStatus[i-5])
                {
                    var id = setTmp.thingID;
                    if(id<0) continue;
                    var usefulMode = setTmp.usefulMode;
                    var modeList = [Keymap.CMD_MANUAL,Keymap.CMD_CONFIG,Keymap.CMD_AUTO,Keymap.CMD_RUNNING,Keymap.CMD_SINGLE,Keymap.CMD_ONE_CYCLE];
                    var modes =[];
                    for(j=0;j<6;++j){
                        if((usefulMode&(1<<j)) != 0){
                            modes.push(modeList[j]);
                        }
                    }
                    var keyEn = false;
                    var currMode = panelRobotController.currentMode();
                    for(j=0,len =modes.length;j<len;++j){
                        if(currMode == modes[j]){
                            keyEn = true;
                        }
                    }
                    if(keyEn){
                        var keyType = setTmp.keyFuncType;
                        switch(setTmp.bindingType)
                        {
                        case 0://yOut
                        case 1://mOut
                            var valveTmp = IODefines.getValveItemFromValveID(id);
                            var toSend = JSON.stringify(valveTmp);
                            if(keyType == 1){
                                refreshTimer.outPutStatus = panelRobotController.isOutputOn(valveTmp.y1Point,valveTmp.y1Board);
                                panelRobotController.setYStatus(toSend, !refreshTimer.outPutStatus);
                            }
                            else if(keyType == 2 || keyType == 3){
                                panelRobotController.setYStatus(toSend, keyType==2? true:false);
                            }
                            break;
                        case 2://可编程按键
                            var p = ManualProgramManager.manualProgramManager.getProgram(id).program;
                            console.log("p",JSON.stringify(p));
                            panelRobotController.manualRunProgram(JSON.stringify(p),
                                                                  "","", "", "");
                            break;
                        }
                    }
                }
            }
        }
    }
    function handControlButtonBandingOperationReleased(keyStatus)
    {
        var handControSetting = Mdata.ledKesSetData;
        if(handControSetting.length==10)
        {
            var setTmp ={};
            var j,len;
            for(var i = 5;i < 10; ++i)
            {
                setTmp = handControSetting[i];
                if(setTmp.functionCheck && keyStatus[i-5])
                {
                    var id = setTmp.thingID;
                    if(id<0) continue;
                    var usefulMode = setTmp.usefulMode;
                    var modeList = [Keymap.CMD_MANUAL,Keymap.CMD_CONFIG,Keymap.CMD_AUTO,Keymap.CMD_RUNNING,Keymap.CMD_SINGLE,Keymap.CMD_ONE_CYCLE];
                    var modes =[];
                    for(j=0;j<6;j++){
                        if((usefulMode&(1<<j)) !== 0){
                            modes.push(modeList[j]);
                        }
                    }
                    var keyEn = false;
                    var currMode = panelRobotController.currentMode();
                    for(j=0,len =modes.length;j<len;++j){
                        if(currMode == modes[j]){
                            keyEn = true;
                        }
                    }
                    if(keyEn){
                        var keyType = setTmp.keyFuncType;
                        switch(setTmp.bindingType)
                        {
                        case 0://yOut
                        case 1://mOut
                            var valveTmp = IODefines.getValveItemFromValveID(id);
                            var toSend = JSON.stringify(valveTmp);
                            if(keyType == 1 || keyType == 0){
                                var outStatus = panelRobotController.isOutputOn(valveTmp.y1Point,valveTmp.y1Board);
                                if(keyType == 0)
                                    panelRobotController.setYStatus(toSend, !outStatus);
                                else
                                    panelRobotController.setYStatus(toSend, refreshTimer.outPutStatus);
                            }
                            break;
                        case 2://可编程按键
                            panelRobotController.sendKeyCommandToHost(Keymap.CMD_MANUAL_STOP);
                            break;
                        }
                    }
                }
            }
        }
    }

    function getExternalFuncBtn(){
        var originBtnStatus = panelRobotController.isInputOn(022,IODefines.IO_BOARD_0);//x032
        var startupBtnStatus = panelRobotController.isInputOn(036,IODefines.IO_BOARD_0);//x046
        var stopBtnStatus = panelRobotController.isInputOn(037,IODefines.IO_BOARD_0);//x047
        var automodeBtnStatus = panelRobotController.isInputOn(023,IODefines.IO_BOARD_0);//x033

        var  originBtnEn = parseInt(panelRobotController.getCustomSettings("X32UseForOrigin", 0));
        var automodeBtnEn = parseInt(panelRobotController.getCustomSettings("X33UseForAuto", 0));
        var startupBtnEn = parseInt(panelRobotController.getCustomSettings("X46UseForStartup", 0));
        var stopBtnEn = parseInt(panelRobotController.getCustomSettings("X47UseForStop", 0));

        if(originBtnStatus){
            if(originBtnStatus != refreshTimer.originBtnOld){
                    refreshTimer.originBtnDelay++;
                    if(refreshTimer.originBtnDelay >=5){
                        refreshTimer.originBtnDelay =0;
                        refreshTimer.originBtnOld = originBtnStatus;
                        if(originBtnEn){
                            panelRobotController.sendKeyCommandToHost(Keymap.CMD_CONFIG);
                            panelRobotController.sendKeyCommandToHost(Keymap.CMD_KEY_ORIGIN);
                        }
                    }
                }else refreshTimer.originBtnDelay =0;
        }else refreshTimer.originBtnOld = 0;

        if(startupBtnStatus){
            if(startupBtnStatus != refreshTimer.startupBtnOld){
                    refreshTimer.startupBtnDelay++;
                    if(refreshTimer.startupBtnDelay >=5){
                        refreshTimer.startupBtnDelay =0;
                        refreshTimer.startupBtnOld = startupBtnStatus;
                        if(startupBtnEn){
                            if(!(stopBtnStatus == 1 && stopBtnEn == 1)){
                                panelRobotController.sendKeyCommandToHost(Keymap.CMD_KEY_RUN);
                            }
                        }
                    }
                }else refreshTimer.startupBtnDelay =0;
            }else refreshTimer.startupBtnOld = 0;

        if(stopBtnStatus){
            if(stopBtnStatus != refreshTimer.stopBtnOld){
                    refreshTimer.stopBtnDelay++;
                    if(refreshTimer.stopBtnDelay >=5){
                        refreshTimer.stopBtnDelay =0;
                        refreshTimer.stopBtnOld = stopBtnStatus;
                        if(stopBtnEn){
                            if(!(panelRobotController.currentErrNum() !== 0 &&
                                    (panelRobotController.currentMode() == Keymap.CMD_RUNNING ||
                                        panelRobotController.currentMode() == Keymap.CMD_SINGLE))){
                                panelRobotController.sendKeyCommandToHost(Keymap.CMD_KEY_STOP);
                                panelRobotController.sendKeyCommandToHost(Keymap.CMD_KEY_STOP);
                            }
                        }
                    }
                }else refreshTimer.stopBtnDelay =0;
        }else refreshTimer.stopBtnOld = 0;

        if(automodeBtnStatus){
            if(automodeBtnStatus != refreshTimer.automodeBtnOld){
                    refreshTimer.automodeBtnDelay++;
                    if(refreshTimer.automodeBtnDelay >=5){
                        refreshTimer.automodeBtnDelay =0;
                        refreshTimer.automodeBtnOld = automodeBtnStatus;
                        if(automodeBtnEn){
                            panelRobotController.sendKeyCommandToHost(Keymap.CMD_AUTO);
                        }
                    }
                }else refreshTimer.automodeBtnDelay =0;
            }else refreshTimer.automodeBtnOld = 0;
        }

        function switchMoldByIOStatus(){
            var moldbyIOData = Mdata.moldbyIOData;
        var btnStatus;
        var btnStatusOldTmp = refreshTimer.btnStatusOld;
            var delayCntTmp = refreshTimer.delayCnt;
            var record;
        var curMode;
            for(var i=0;i<moldbyIOData.length;++i){
            btnStatus = panelRobotController.isInputOn(moldbyIOData[i].ioID,IODefines.IO_BOARD_0 + parseInt(moldbyIOData[i].ioID) /32);
                record = moldbyIOData[i].mold;
            curMode = panelRobotController.currentMode();
            if(btnStatus){
                if(btnStatus != btnStatusOldTmp[i]){
                        if(delayCntTmp[i] == undefined){
                            delayCntTmp[i] = 0;
                        }
                        delayCntTmp[i]++;
                        if(delayCntTmp[i] >= 10){
                            delayCntTmp[i] = 0;
                            btnStatusOldTmp[i] = btnStatus;
                            if(curMode === Keymap.CMD_ORIGIN || curMode === Keymap.CMD_RETURN ||
                                    curMode === Keymap.CMD_ORIGIN_ING || curMode === Keymap.CMD_RETURN_ING)
                                continue;
                            panelRobotController.modifyConfigValue(1,Keymap.CMD_CONFIG);
                            if(panelRobotController.loadRecord(record)){
                                ICOperationLog.appendOperationLog(qsTr("Load record ") + record);
                            }
                            if(curMode === Keymap.CMD_RUNNING || curMode === Keymap.CMD_SINGLE ||
                                    curMode === Keymap.CMD_ONE_CYCLE)
                               curMode = Keymap.CMD_AUTO;
                            panelRobotController.modifyConfigValue(1,curMode);
                        }
                    }
                    else{
                        delayCntTmp[i] = 0;
                    }
                    refreshTimer.delayCnt = delayCntTmp;
                }
                else{
                    btnStatusOldTmp[i] = 0;
                }
            }
        refreshTimer.btnStatusOld = btnStatusOldTmp;
//        console.log(refreshTimer.btnStatusOld);
        }

    Timer{
        id:refreshTimer
        property variant btnStatusOld: []
        property variant delayCnt:[]
        property int originBtnOld: 0
        property int originBtnDelay: 0
        property int startupBtnOld: 0
        property int startupBtnDelay: 0
        property int stopBtnOld: 0
        property int stopBtnDelay: 0
        property int automodeBtnOld: 0
        property int automodeBtnDelay: 0
        property int outPutStatus: 0
        interval: 50; running: false; repeat: true
        onTriggered: {
            var pressedKeys = Keymap.pressedKeys();
            var currentMode = panelRobotController.currentMode();
            if(isInit){
                getExternalFuncBtn();
                switchMoldByIOStatus();
            }
            handControlLEDBandingOperation();
            for(var i = 0 ; i < pressedKeys.length; ++i){
                // speed handler
                if(pressedKeys[i] === Keymap.KEY_Up || pressedKeys[i] === Keymap.KEY_Down){

                    var tuneGlobalSpeedEn = ShareData.GlobalStatusCenter.getTuneGlobalSpeedEn();
                    if(tuneGlobalSpeedEn){
                        if(ShareData.GlobalStatusCenter.getKnobStatus() == Keymap.KNOB_MANUAL &&
                                panelRobotController.getConfigValue("s_rw_0_32_0_211") == 1)
                            continue;
                        var spd;
                        var speed = ShareData.GlobalStatusCenter.getGlobalSpeed();
                        spd = parseFloat(speed);
                        var dir = pressedKeys[i] === Keymap.KEY_Up ? 1 : -1;
                        //                        spd = Keymap.endSpeed(spd, dir)
                        spd = Keymap.endSpeedCalcByTime(spd, dir);
                        speed = spd.toFixed(1);
                        ShareData.GlobalStatusCenter.setGlobalSpeed(speed);
                        //                        panelRobotController.modifyConfigValue("s_rw_0_16_1_294", speed);
                        panelRobotController.modifyConfigValue("s_rw_0_32_1_212", speed);
                        mainHeader.speed = speed;
                    }

                }
                else{
                    panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(pressedKeys[i]));
                }
            }
            if(!panelRobotController.isOrigined()){
                tipBar.tip = qsTr("Please press origin key and then press start key to find origin signal.")
                tipBar.visible = !originreturnmsgmsg.visible;
            }else{
                tipBar.visible = false;
            }

            if(currentMode == Keymap.CMD_STANDBY){
                panelRobotController.readCurrentKnobValue();
            }
            if(currentMode == Keymap.CMD_ORIGIN){
                originreturnmsgmsg.showForOrigin();
            }else if(currentMode == Keymap.CMD_RETURN){
                originreturnmsgmsg.showForReturn();
            }else if(panelRobotController.isOriginning()){
                originreturnmsgmsg.showForOriginning();
            }else if(panelRobotController.isReturnning()){
                originreturnmsgmsg.showForReturning();
            }else originreturnmsgmsg.hide();

            var alarmNum = panelRobotController.currentErrNum();
            if(alarmNum !== alarmBar.errID){
                alarmBar.errID = alarmNum;
                if(alarmNum === 0){
                    alarmlogPage.resolvedAlarms();
                }else if(alarmNum === 1){

                }else{
                    alarmlogPage.appendAlarm(alarmNum);
                }

                if(alarmNum === 2){
                    paraChose.visible = true;
                }else if(alarmNum >= 530 && alarmNum <= 537){
                    originAlarm.show(qsTr("Origin is changed? Do you want to refind an origin?"), qsTr("Refind"), qsTr("Stop"));
                }else{
                    paraChose.visible = false;
                }
            }

            if(ShareData.GlobalStatusCenter.getKnobStatus() == Keymap.KNOB_MANUAL &&
                    panelRobotController.getConfigValue("s_rw_0_32_0_211") == 1){
                var currentAxis = panelRobotController.getPullyAxis();
                //                if(currentAxis < 0 || currentAxis > 7) return;
                if(currentAxis <= 0) return;
                if(currentAxis != pData.lastAxis ){
                    pData.lastAxis = currentAxis;
                    ShareData.GlobalStatusCenter.setGlobalSpeed((panelRobotController.getConfigValue(AxisDefine.axisInfos[currentAxis - 1].sAddr) / 10).toFixed(1));
                    mainHeader.speed = ShareData.GlobalStatusCenter.getGlobalSpeed();
                }
            }
        }
    }
}

