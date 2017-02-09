import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine
import "../configs/IOConfigs.js" as IOConfigs
import "../configs/IODefines.js" as IODefines
import "../configs/Keymap.js" as Keymap

Item {
    id:root
    property int currentTest: -1
    property variant sentPulseAddrs: ["c_ro_0_32_3_900","c_ro_0_32_3_904",
        "c_ro_0_32_3_908", "c_ro_0_32_3_912","c_ro_0_32_3_916", "c_ro_0_32_3_920", "c_ro_0_32_3_924", "c_ro_0_32_3_928"
    ]
    property variant receivedPulseAddrs: ["c_ro_0_32_0_901", "c_ro_0_32_0_905",
        "c_ro_0_32_0_909","c_ro_0_32_0_913","c_ro_0_32_0_917","c_ro_0_32_0_921", "c_ro_0_32_0_925", "c_ro_0_32_0_929"]
    width: parent.width
    height: parent.height
    function startTest(index){
        debugItems.setProperty(index,"status",-1);
        currentTest = index;
    }
    function testResult(index,st){
        debugItems.setProperty(index,"status",st);
    }
    function testStop(){
        debugItems.setProperty(currentTest,"status",-2);
    }
    function setErrTip(index,tip){
        debugItems.setProperty(index,"errTip",tip);
    }


    Item {
        id: reserve
        width: parent.width-5
        height: 100
        Text {
            id: debugArea
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
                            debugItems.append({"type":"axisATest","id":i,"descr":qsTr("motor")+AxisDefine.axisInfos[i].name +qsTr("+test"),"status":-2,"errTip":""});
                            debugItems.append({"type":"axisDTest","id":i,"descr":qsTr("motor")+AxisDefine.axisInfos[i].name +qsTr("-test"),"status":-2,"errTip":""});
                        }
                    }
                    var yDefines = IOConfigs.teachSingleY;
                    for(var j=0;j<yDefines.length;++j){
                        debugItems.append({"type":"singleYOnTest","id":yDefines[j],"descr":qsTr("singleY")+ IODefines.getValveItemFromValveName(yDefines[j]).descr+qsTr("onTest"),"status":-2,"errTip":""});
                        debugItems.append({"type":"singleYOffTest","id":yDefines[j],"descr":qsTr("singleY")+ IODefines.getValveItemFromValveName(yDefines[j]).descr+qsTr("offTest"),"status":-2,"errTip":""});
                    }
                    yDefines = IOConfigs.teachHoldDoubleY;
                    for(var k=0;k<yDefines.length;++k){
                        debugItems.append({"type":"HoldDoubleYOnTest","id":yDefines[k],"descr":qsTr("HoldDoubleY")+ IODefines.getValveItemFromValveName(yDefines[k]).descr+qsTr("onTest"),"status":-2,"errTip":""});
                        debugItems.append({"type":"HoldDoubleYOffTest","id":yDefines[k],"descr":qsTr("HoldDoubleY")+ IODefines.getValveItemFromValveName(yDefines[k]).descr+qsTr("offTest"),"status":-2,"errTip":""});
                    }
                    if(debugItems.count === 0)return;
                    text = qsTr("StopTest")
                    bgColor = "red"
                    refreshTimer.singleMode =0;
                    startTest(currentTest<0? 0:currentTest);
                }
                else if(testBegin.bgColor == "red"){
                    testStop();
                    text = qsTr("StartTest")
                    bgColor = "green"
                    currentTest = -1;
                }
            }
        }
    }
    ListModel{
        id:debugItems
    }
    ICListView{
        id:debugView
        border.color:"black"
        border.width: 1
        anchors.top:reserve.bottom
        width: parent.width-5
        height: parent.height - reserve.height -10
        spacing: 2
        clip: true
        model: debugItems
        delegate: Rectangle{
            id:item
            width: debugView.width
            height: itemDescr.height + 12
            color: ListView.isCurrentItem? "lightsteelblue":"white"
            Text {
                id: itemDescr
                anchors.verticalCenter: parent.verticalCenter
                text: descr
            }
            Row{
                id: itemStatus
                spacing: 4
                anchors.right: parent.right
                anchors.rightMargin: 10
                height: parent.height
                Text{
                    id:tip
                    visible: itemStatusSignal.debugStatus === 0
                    anchors.verticalCenter: parent.verticalCenter
                    color: "red"
                    text:errTip
                }
                Text {
                    id: itemStatusSignal
                    anchors.verticalCenter: parent.verticalCenter
                    property int debugStatus: status
                    font.pixelSize:16
                    onDebugStatusChanged: {
                        if(debugStatus === -1){
                            text = "○";
                            color = "black";
                        }
                        else if(debugStatus === 0){
                            text = "x";
                            color = "red";
                        }
                        else if(debugStatus === 1){
                            text = "√";
                            color = "green";
                        }
                        else{
                            console.log("dis");
                            text = "";
                        }
                    }
                }
                ICButton{
                    id:redebug
                    visible: itemStatusSignal.debugStatus === 0
                    height: parent.height-2
                    width: (height << 1) + 10
                    text: qsTr("ReTest")
                    onButtonClicked: {
                        refreshTimer.singleMode = 1;
                        startTest(index);
                    }
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    debugView.currentIndex = index;
                }
            }
        }
    }

    onCurrentTestChanged: {
        if(currentTest === -1) return;
        if(debugItems.get(currentTest).status === -1){
            var type = debugItems.get(currentTest).type;
            var id = debugItems.get(currentTest).id;
            var toSend;
            switch(type){
            case "axisATest":{
                panelRobotController.setMotorTestPulseNum(10000);
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEST_JOG_PX + id);
            }break;
            case "axisDTest":{
                panelRobotController.setMotorTestPulseNum(10000);
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_TEST_JOG_NX + id);
            }break;
            case "singleYOnTest":{
                toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                panelRobotController.setYStatus(toSend, 1);
            }break;
            case "singleYOffTest":{
                toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                panelRobotController.setYStatus(toSend, 0);
            }break;
            case "HoldDoubleYOnTest":{
                toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                panelRobotController.setYStatus(toSend, 1);
            }break;
            case "HoldDoubleYOffTest":{
                toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                panelRobotController.setYStatus(toSend, 0);
            }break;
            default:break;
            }
        }
    }

    Timer{
        id:refreshTimer
        property int sDelay: 0
        property int rDelay: 0
        property int singleMode: 0
        interval: 50;repeat:true;running: visible
        onTriggered: {
            if(currentTest >=0 && currentTest < debugItems.count){
                if(debugItems.get(currentTest).status === -1){
                    var type = debugItems.get(currentTest).type;
                    var id = debugItems.get(currentTest).id;
                    var pulseSent,pulseReceived;
                    switch(type){
                    case "axisATest":
                    case "axisDTest":{
                        var tmp;
                        pulseSent = panelRobotController.statusValue(sentPulseAddrs[id]);
                        pulseReceived = panelRobotController.statusValue(receivedPulseAddrs[id]);
                        debugArea.text ="id:"+id+" R:"+pulseReceived+" S:"+pulseSent;
                        if(type==="axisDTest") tmp =-10000;
                        else tmp =10000;
                        if(Math.abs(pulseSent-tmp)<10){
                            rDelay = 0;
                            if(Math.abs(pulseSent-pulseReceived)<10){
                                sDelay =0;
                                testResult(currentTest,1);
                                break;
                            }
                            else{
                                if(sDelay ===20){
                                    sDelay = 0;
                                    testResult(currentTest,0);
                                    setErrTip(currentTest,"receivedErr");
                                    break;
                                }
                                sDelay++;
                            }
                        }
                        else{
                            if(rDelay ===20){
                                rDelay=0;
                                testResult(currentTest,0);
                                setErrTip(currentTest,"sendErr");
                                break;
                            }
                            rDelay++;
                        }
                    }break;
                    case "singleYOnTest":{
                        toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                        panelRobotController.setYStatus(toSend, 1);
                    }break;
                    case "singleYOffTest":{
                        toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                        panelRobotController.setYStatus(toSend, 0);
                    }break;
                    case "HoldDoubleYOnTest":{
                        toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                        panelRobotController.setYStatus(toSend, 1);
                    }break;
                    case "HoldDoubleYOffTest":{
                        toSend = JSON.stringify(IODefines.getValveItemFromValveName(id));
                        panelRobotController.setYStatus(toSend, 0);
                    }break;
                    default:break;
                    }
                }
                var currStatus = debugItems.get(currentTest).status;
                if(currStatus === 0 || currStatus ===1){
                    if(singleMode ===0){
                        if(currentTest == debugItems.count -1){
                            currentTest = -1;
                            testBegin.text = "StartTest";
                            testBegin.bgColor = "green";
                        }
                        else{
                            startTest(currentTest+1);
                        }
                    }
                }
            }

        }
    }
    onVisibleChanged: {
        panelRobotController.swichPulseAngleDisplay(visible ? 5:0);
    }
}

