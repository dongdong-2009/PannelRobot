import QtQuick 1.1
import "Theme.js" as Theme
import "."
import "../ICCustomElement/"
import "ShareData.js" as ShareData
import "configs/Keymap.js" as Keymap


Rectangle {
    color:Theme.defaultTheme.BASE_BG
    property int menuItemWidth: width * Theme.defaultTheme.TopHeader.menuItemWidthProportion
    property int menuItemHeight: height * Theme.defaultTheme.TopHeader.menuItemHeightProportion
    property alias modeText: modeText
    property alias loginUser: loginBtn.text
    property int mode: 0
    property Item lastChecked: null

    signal calculatorItemStatusChanged(bool isChecked)
    signal ioItemStatusChanged(bool isChecked)
    signal recordItemStatusChanged(bool isChecked)
    signal alarmLogItemStatusChanged(bool isChecked);
    signal loginBtnClicked()
//    signal lan

    function onRecordChanged(){
        record.itemText = qsTr("Records:") + panelRobotController.currentRecordName();
    }

    function resetStatus(){
        if(lastChecked != null)
            lastChecked.isChecked = false;
    }

    Image {
        id: modeImg
        source: "images/modeSetting.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
        function onKnobChanged(knobStatus){
            if(knobStatus === Keymap.KNOB_MANUAL){
                source = "images/modeSetting.png";
                modeText.text = qsTr("Manual");
                modeBG.source = "images/modeTextBG_Red.png";
            }else if(knobStatus === Keymap.KNOB_AUTO){
                source = "images/modeAuto.png"
                modeText.text = qsTr("Auto");
                modeBG.source = "images/modeTextBG_Blue.png";
            }
        }
    }
    Rectangle{
        id: modeTextContainer
        width: parent.width *0.25
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: modeImg.right
        anchors.leftMargin: parent.width * 0.01

        Image {
            id: modeBG
            source: "images/modeTextBG_Red.png"
            anchors.centerIn: parent
        }

        Text {
            id: modeText
            text: qsTr("Manual")
            anchors.centerIn: parent
            color: "yellow"
            font.pixelSize: 24
        }
    }

    Row{
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01

        function itemToSignalMap(which){
            if(which == io)
                return ioItemStatusChanged;
            else if(which == record)
                return recordItemStatusChanged;
            else if(which == alarmLog)
                return alarmLogItemStatusChanged;
        }

        function isCheckedHandlerHelper(which, isChecked){
            if(lastChecked != which)
                resetStatus();
            itemToSignalMap(which)(isChecked);
            lastChecked = which;
        }

        TopMenuItem{
            id: calculator
            width: menuItemWidth
            height: menuItemHeight
            itemText: qsTr("Calculator")
            onIsCheckedChanged: calculatorItemStatusChanged(isChecked)
        }
        TopMenuItem{
            id: io
            width: menuItemWidth
            height:  menuItemHeight
            itemText: qsTr("I/O")
            onIsCheckedChanged: {
                parent.isCheckedHandlerHelper(io, isChecked);
            }

        }
        TopMenuItem{
            id: record
            width: menuItemWidth * 2
            height:  menuItemHeight
            itemText: qsTr("Records:") + panelRobotController.currentRecordName()
            onIsCheckedChanged: {
                parent.isCheckedHandlerHelper(record, isChecked);
            }
        }
        TopMenuItem{
            id: alarmLog
            width: menuItemWidth
            height:  menuItemHeight
            itemText: qsTr("Alarm log")
            onIsCheckedChanged: parent.isCheckedHandlerHelper(alarmLog, isChecked);
        }
        ICButton{
            id: loginBtn
            width: menuItemWidth
            height:  menuItemHeight
            text: qsTr("Login")
            onButtonClicked: {
                loginBtnClicked();
            }
        }
    }
    ICButtonGroup{
        id:buttonGroup
        layoutMode: 2
    }
    Timer{
        id:refreshTimer
        interval: 50; running: false; repeat: true;
        onTriggered: {

        }
    }

    Component.onCompleted: {
        buttonGroup.addButton(io);
        buttonGroup.addButton(record);
        buttonGroup.addButton(alarmLog)
        panelRobotController.moldChanged.connect(onRecordChanged);
        ShareData.GlobalStatusCenter.registeKnobChangedEvent(modeImg);
    }
}
