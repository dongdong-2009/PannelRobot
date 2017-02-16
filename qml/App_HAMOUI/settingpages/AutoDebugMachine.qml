import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine
import "../configs/IOConfigs.js" as IOConfigs
import "../configs/IODefines.js" as IODefines
import "../configs/Keymap.js" as Keymap

ICStackContainer{
    id:pageContainer
    width: parent.width
    height: parent.height
    property variant sentPulseAddrs: ["c_ro_0_32_3_900","c_ro_0_32_3_904",
        "c_ro_0_32_3_908", "c_ro_0_32_3_912","c_ro_0_32_3_916", "c_ro_0_32_3_920", "c_ro_0_32_3_924", "c_ro_0_32_3_928"]
    property variant receivedPulseAddrs: ["c_ro_0_32_0_901", "c_ro_0_32_0_905",
        "c_ro_0_32_0_909","c_ro_0_32_0_913","c_ro_0_32_0_917","c_ro_0_32_0_921", "c_ro_0_32_0_925", "c_ro_0_32_0_929"]
    property variant zPulseAddrs: ["c_ro_0_16_0_902", "c_ro_0_16_0_906",
        "c_ro_0_16_0_910", "c_ro_0_16_0_914", "c_ro_0_16_0_918", "c_ro_0_16_0_922", "c_ro_0_16_0_926", "c_ro_0_16_0_930"]
    property variant pulsePerRevolutionAddrs: ["s_rw_0_16_0_101","s_rw_0_16_0_108",
        "s_rw_0_16_0_115","s_rw_0_16_0_122","s_rw_0_16_0_129","s_rw_0_16_0_136","s_rw_0_16_0_143","s_rw_0_16_0_150"]
    property variant testSpeedAddrs: ["s_rw_0_8_0_225","s_rw_8_8_0_225","s_rw_16_8_0_225",
        "s_rw_24_8_0_225","s_rw_0_8_0_226","s_rw_8_8_0_226","s_rw_16_8_0_226","s_rw_24_8_0_226"]
    ICButton{
        id:exit
        visible: pageContainer.currentIndex
        height:32;width:64
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top:parent.top
        text: qsTr("Exit")+">"
        onButtonClicked: {
            pageContainer.setCurrentIndex(0);
        }
    }

    ValveSettings{
        id:valveSettings
    }

    AxisConfigs{
        id:motorSettings
    }

    Item {
        id:root
        property int currentTest: -1
        function startTest(index){
            debugItems.setProperty(index,"status",-1);
            currentTest = index;
        }
        function testResult(index,st){
            debugItems.setProperty(index,"status",st);
        }
        function testStop(){
            if(currentTest >=0){
                refreshTimer.testDelay = 0;
                debugItems.setProperty(currentTest,"status",-2);
            }
        }
        function setErrTip(index,tip){
            debugItems.setProperty(index,"errTip",tip);
        }

        function setErrType(index,type){
           debugItems.setProperty(index,"errType",type);
        }

        function setMoveData(index,data){
            debugItems.setProperty(index,"moveData",data);
        }

        Item {
            id: reserve
            width: parent.width-5
            height: 100
            ICConfigEdit{
                id:testSpeed
                unit: qsTr("%")

            }
            ICButton{
                id:testBegin
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                radius: height >> 1
                text:qsTr("StartTest")
                bgColor:"green"
                textColor: "white"
                onButtonClicked: {
                    if(testBegin.bgColor == "green"){
                        debugItems.clear();
                        var axisNum = panelRobotController.getConfigValue("s_rw_16_6_0_184");
                        for(var i=0;i<axisNum;++i){
                            if(AxisDefine.axisInfos[i].visiable === true){
                                debugItems.append({"type":"axisATest","id":i,"descr":qsTr("motor")+AxisDefine.axisInfos[i].name +qsTr("+test"),"moveData":"","status":-2,"errTip":"","errType":0});
                                debugItems.append({"type":"axisDTest","id":i,"descr":qsTr("motor")+AxisDefine.axisInfos[i].name +qsTr("-test"),"moveData":"","status":-2,"errTip":"","errType":0});
                            }
                        }
                        var yDefines = IOConfigs.teachSingleY;
                        for(var j=0;j<yDefines.length;++j){
                            debugItems.append({"type":"singleYOnTest","id":yDefines[j],"descr":qsTr("singleY")+ IODefines.getValveItemFromValveName(yDefines[j]).descr+qsTr("onTest"),"moveData":"","status":-2,"errTip":"","errType":0});
                            debugItems.append({"type":"singleYOffTest","id":yDefines[j],"descr":qsTr("singleY")+ IODefines.getValveItemFromValveName(yDefines[j]).descr+qsTr("offTest"),"moveData":"","status":-2,"errTip":"","errType":0});
                        }
                        yDefines = IOConfigs.teachHoldDoubleY;
                        for(var k=0;k<yDefines.length;++k){
                            debugItems.append({"type":"HoldDoubleYOnTest","id":yDefines[k],"descr":qsTr("HoldDoubleY")+ IODefines.getValveItemFromValveName(yDefines[k]).descr+qsTr("onTest"),"moveData":"","status":-2,"errTip":"","errType":0});
                            debugItems.append({"type":"HoldDoubleYOffTest","id":yDefines[k],"descr":qsTr("HoldDoubleY")+ IODefines.getValveItemFromValveName(yDefines[k]).descr+qsTr("offTest"),"moveData":"","status":-2,"errTip":"","errType":0});
                        }
                        if(debugItems.count === 0)return;
//                        panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEST_CLEAR);
                        text = qsTr("StopTest")
                        bgColor = "red"
                        refreshTimer.singleMode =0;
                        root.startTest(0);
                    }
                    else if(testBegin.bgColor == "red"){
                        root.testStop();
                        text = qsTr("StartTest")
                        bgColor = "green"
                        root.currentTest = -1;
                    }
                }
            }
        }

        ListModel{
            id:debugItems
        }
        ICListView{
            id:debugView
            anchors.top:reserve.bottom
            width: parent.width-5
            height: parent.height - reserve.height -10
            border.color:"black"
            border.width: 1
            spacing: 2
            clip: true
            model: debugItems
            delegate: Rectangle{
                id:item
                width: debugView.width
                height: itemDescr.height + 12
                color: ListView.isCurrentItem? "lightsteelblue":"white"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        debugView.currentIndex = index;
                    }
                }
                Text {
                    id: itemDescr
                    anchors.verticalCenter: parent.verticalCenter
                    text: descr+": "+moveData
                }
                Row{
                    id: itemStatus
                    spacing: 4
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    height: parent.height
                    Text {
                        id: itemStatusSignal
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize:16
                        text:{
                            if(status === -1){
                                return "○";
                            }
                            else if(status === 0){
                                return "x";
                            }
                            else if(status === 1){
                                return "√";
                            }
                            else{
                                return "";
                            }
                        }
                        color: {
                            if(status === -1){
                                return "black";
                            }
                            else if(status === 0){
                                return "red";
                            }
                            else if(status === 1){
                                return "green";
                            }
                            else{
                               return "black";
                            }
                        }
                    }
                    Text{
                        id:tip
                        visible: status === 0
                        anchors.verticalCenter: parent.verticalCenter
                        color: "red"
                        text:errTip
                    }
                    ICButton{
                        id:redebug
                        visible: status === 0
                        height: parent.height-2
                        width: (height << 1)-10
                        text: qsTr("ReTest")
                        enabled: testBegin.bgColor == "green"
                        onButtonClicked:{
                            refreshTimer.singleMode = 1;
                            root.testStop();
                            root.startTest(index);
                        }
                    }
                    ICButton{
                        id:toSet
                        visible: status === 0 && errType === 1
                        height: parent.height-2
                        width: (height << 1)-10
                        text: qsTr("Set")
                        enabled: testBegin.bgColor == "green"
                        onButtonClicked:{
                            if(type === "axisATest" || type === "axisDTest"){
                                pageContainer.setCurrentIndex(1);
                            }
                            else{
                                pageContainer.setCurrentIndex(2);
                            }
                        }
                    }
                }
            }
        }

        onCurrentTestChanged: {
            if(currentTest === -1) return;
            if(debugItems.get(currentTest).status === -1){
                var type = debugItems.get(currentTest).type;
                var id = debugItems.get(currentTest).id;
                switch(type){
                case "axisATest":
                case "axisDTest":{
                    var pNum =panelRobotController.getConfigValue(pulsePerRevolutionAddrs[id]);
                    panelRobotController.setMotorTestPulseNum(pNum*1.5);
                    panelRobotController.sendKeyCommandToHost((type === "axisATest"? Keymap.CMD_TEST_JOG_PX:Keymap.CMD_TEST_JOG_NX) + id);
                }break;
                case "singleYOnTest":
                case "singleYOffTest":
                case "HoldDoubleYOnTest":
                case "HoldDoubleYOffTest":{
                    var toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                    var st;
                    if(type === "singleYOnTest" || type === "HoldDoubleYOnTest"){
                        st = 1;
                    }else{
                        st = 0;
                    }
                    panelRobotController.setYStatus(toSend, st);
                }break;
                default:break;
                }
            }
        }

        Timer{
            id:refreshTimer
            property int testDelay: 0
            property int sDelay: 0
            property int rDelay: 0
            property int singleMode: 0
            interval: 50;repeat:true;running: visible
            onTriggered: {
                if(root.currentTest >=0 && root.currentTest < debugItems.count){
                    var type = debugItems.get(root.currentTest).type;
                    var id = debugItems.get(root.currentTest).id;
                    var pulseSent,pulseReceived,zPulse;
                    switch(type){
                    case "axisATest":
                    case "axisDTest":{
                        var tmp;
                        pulseSent = panelRobotController.statusValue(sentPulseAddrs[id]);
                        pulseReceived = panelRobotController.statusValue(receivedPulseAddrs[id]);
                        zPulse = panelRobotController.statusValue(zPulseAddrs[id]);
                        root.setMoveData(root.currentTest,qsTr("R")+pulseReceived+" "+qsTr("S")+pulseSent+" "+"Z"+zPulse);

                        if(debugItems.get(root.currentTest).status === -1){
                            var pNum =panelRobotController.getConfigValue(pulsePerRevolutionAddrs[id]);
                            if(type==="axisDTest") tmp =-pNum*1.5;
                            else tmp =pNum*1.5;
                            if(Math.abs(pulseSent-tmp)<10){
                                rDelay = 0;
                                if(Math.abs(pulseSent-pulseReceived)<10){
                                    sDelay =0;
                                    if(zPulse>pNum && zPulse< (65536-pNum)){
                                        root.testResult(root.currentTest,0);
                                        root.setErrTip(root.currentTest,qsTr("zPulse Err"));
                                        root.setErrType(root.currentTest,0);
                                    }
                                    else{
                                        root.testResult(root.currentTest,1);
                                    }
                                    break;
                                }
                                else{
                                    if(sDelay ===40){
                                        sDelay = 0;
                                        root.testResult(root.currentTest,0);
                                        root.setErrTip(root.currentTest,qsTr("receivedErr"));
                                        root.setErrType(root.currentTest,1);
                                        break;
                                    }
                                    sDelay++;
                                }
                            }
                            else{
                                if(rDelay ===20){
                                    rDelay=0;
                                    root.testResult(root.currentTest,0);
                                    root.setErrTip(root.currentTest,qsTr("sendErr"));
                                    root.setErrType(root.currentTest,0);
                                    break;
                                }
                                rDelay++;
                            }
                        }
                    }break;
                    case "singleYOnTest":
                    case "singleYOffTest":
                    case "HoldDoubleYOnTest":
                    case "HoldDoubleYOffTest":{
                        if(debugItems.get(root.currentTest).status === -1){
                            var valve = IODefines.getValveItemFromValveName(id);
                            var y1status = panelRobotController.isOutputOn(valve.y1Point, valve.y1Board);
                            var y2status = 0;
                            var outputStr;
                            if(type === "HoldDoubleYOnTest" || type === "HoldDoubleYOffTest"){
                                y2status = panelRobotController.isOutputOn(valve.y2Point, valve.y2Board);
                                outputStr = qsTr("Output1")+(y1status?qsTr("on"):qsTr("off"))+" "+qsTr("Output2")+(y2status?qsTr("on"):qsTr("off"));
                            }
                            else{
                              outputStr= qsTr("Output1")+(y1status?qsTr("on"):qsTr("off"));
                            }
                            if(type === "singleYOffTest" || type === "HoldDoubleYOffTest"){
                                y1status = !y1status;
                                if(type === "HoldDoubleYOffTest"){
                                    y2status = !y2status;
                                }
                            }
                            if(y1status && !y2status){
                                rDelay = 0;
                                var x1Status = panelRobotController.isInputOn(valve.x1Point, valve.x1Board);
                                var x2Status = 0;
                                var x2DirStatus = 1;
                                if(type === "HoldDoubleYOnTest" || type === "HoldDoubleYOffTest"){
                                    x2Status = panelRobotController.isInputOn(valve.x2Point, valve.x2Board);
                                    x2DirStatus = valve.x2Dir;
                                    root.setMoveData(root.currentTest,qsTr("Input1")+(x1Status?qsTr("on"):qsTr("off"))+" "+outputStr+" "+qsTr("Input2")+(x2Status?qsTr("on"):qsTr("off")));
                                }
                                else{
                                    root.setMoveData(root.currentTest,qsTr("Input1")+(x1Status?qsTr("on"):qsTr("off"))+" "+outputStr);
                                }
                                if(type === "singleYOffTest" ||type === "HoldDoubleYOffTest"){
                                    x1Status = !x1Status;
                                    if(type === "HoldDoubleYOffTest"){
                                        x2Status = !x2Status;
                                    }
                                }
                                if((valve.x1Dir?x1Status:(!x1Status)) && (x2DirStatus?(!x2Status):x2Status)){
                                       sDelay =0;
                                       root.testResult(root.currentTest,1);
                                }
                                else{
                                    if(sDelay ===20){
                                        sDelay = 0;
                                        root.testResult(root.currentTest,0);
                                        root.setErrTip(root.currentTest,qsTr("inputErr"));
                                        root.setErrType(root.currentTest,1);
                                        break;
                                    }
                                    sDelay++;
                                }
                            }
                            else{
                                root.setMoveData(root.currentTest,outputStr);
                                if(rDelay === 10){
                                    rDelay=0;
                                    root.testResult(root.currentTest,0);
                                    root.setErrTip(root.currentTest,qsTr("outputErr"));
                                    root.setErrType(root.currentTest,0);
                                    break;
                                }
                                rDelay++;
                            }
                        }
                    }break;
                    default:break;
                    }
                    var currStatus = debugItems.get(root.currentTest).status;
                    if(currStatus === 0 || currStatus ===1){
                        if(singleMode ===0){
                            if(root.currentTest == debugItems.count -1){
                                root.currentTest = -1;
                                testBegin.text = qsTr("StartTest");
                                testBegin.bgColor = "green";
                            }
                            else{
                                testDelay++;
                                if(testDelay === 10){
                                    testDelay = 0;
                                    root.startTest(root.currentTest+1);
                                }
                            }
                        }
                        else{
                            root.currentTest = -1;
                        }
                    }
                }

            }
        }
    }
    onVisibleChanged: {
        panelRobotController.swichPulseAngleDisplay(visible ? 5:0);
    }
    Component.onCompleted: {
        pageContainer.addPage(root);
        pageContainer.addPage(motorSettings);
        pageContainer.addPage(valveSettings);

        pageContainer.setCurrentIndex(0);
    }
}

