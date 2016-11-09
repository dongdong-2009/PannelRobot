import QtQuick 1.1
import "../../ICCustomElement"

Rectangle {
    QtObject{
        id:pData
        property variant menuItemSize: {"width": 130, "height":40}
    }

    signal axisMenuTriggered()
    signal pathMenuTriggered()
    signal outputMenuTriggered()
    signal checkMenuTriggered()
    signal conditionMenuTriggered()
    signal waitMenuTriggered()
    signal stackMenuTriggered()
    signal syncMenuTriggered()
    signal counterMenuTriggered()
    signal commentMenuTriggered()
    signal customAlarmMenuTriggered()
    signal moduleMenuTriggered()
    signal searchMenuTriggered()
    signal originMenuTriggered()
    signal visionMenuTriggered()
    signal speedMenuTriggered()
    signal dataMenuTriggered()
    signal extentMenuTriggered()

    states: [
        State {
            name: "moduleEditMode"
            PropertyChanges {
                target: condition
                enabled:true
            }
        },
        State {
            name: "manualProgramEditMode"
            PropertyChanges {
                target: group
                enabled:false
            }
            PropertyChanges {
                target: other
                enabled:false

            }
        }

    ]


//    function axisMenuTrigger(){axisMenuTriggered();}
//    function pathMenuTrigger() {pathMenuTriggered();}
//    function outputMenuTrigger() {outputMenuTriggered();}
//    function checkMenuTrigger() {checkMenuTriggered();}
//    function conditionMenuTrigger() {conditionMenuTriggered();}
//    function waitMenuTrigger() {waitMenuTriggered();}
//    function stackMenuTrigger() { stackMenuTriggered();}
//    function syncMenuTrigger() {syncMenuTriggered();}
//    function counterMenuTrigger() {conditionMenuTriggered();}
//    function commentMenuTrigger() {commentMenuTriggered();}
//    function customAlarmMenuTrigger() {customAlarmMenuTriggered();}
//    function searchMenuTrigger() {searchMenuTriggered();}

    color: "#A0A0F0"

    Grid{
        columns: 5
        spacing: 6
        x:10
        y:20
        ICButton{
            id:axis
            text: qsTr("Axis Action")
            icon: "../images/action_item_axis.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: axisMenuTriggered()
        }
        ICButton{
            id:path
            text: qsTr("Path")
            icon: "../images/action_item_axis.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: pathMenuTriggered()
            visible: false
        }

        ICButton{
            id:output
            text: qsTr("Output Action")
            icon: "../images/action_item_output.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: outputMenuTriggered()
        }
        ICButton{
            id:check
            text:qsTr("Check")
            icon: "../images/action_item_check.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: checkMenuTriggered()
        }
        ICButton{
            id:condition
            text:qsTr("Condition")
            icon: "../images/action_item_condition.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: conditionMenuTriggered()
        }
        ICButton{
            id:wait
            text:qsTr("Wait")
            icon: "../images/action_item_wait.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: waitMenuTriggered()
        }
        ICButton{
            id:other
            text:qsTr("Counter")
            icon: "../images/action_item_counter.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: counterMenuTriggered()
        }

        ICButton{
            id:sync
            text:qsTr("Sync")
            icon: "../images/action_item_sync.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: syncMenuTriggered()
        }
        ICButton{
            id:comment
            text:qsTr("Comment")
            icon: "../images/action_item_comment.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: commentMenuTriggered()
        }
        ICButton{
            id:group
            text:qsTr("Stack")
            icon: "../images/action_item_stack.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: stackMenuTriggered()
        }
        ICButton{
            id:customAlarm
            text: qsTr("Custom Alarm")
            icon: "../images/action_item_custom_alarm.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: customAlarmMenuTriggered()
        }

        ICButton{
            id:callModule
            text: qsTr("Module")
            icon: "../images/action_item_module.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: moduleMenuTriggered()
        }
        ICButton{
            id:visionCommand
            text:qsTr("Vision")
            icon: "../images/action_item_vision.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: visionMenuTriggered()
            visible: false
        }

        ICButton{
            id:speedSettings
            text: qsTr("Path Speed")
            icon: "../images/pathSpeed.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: speedMenuTriggered()
            visible: false
        }

        ICButton{
            id:dataCommand
            text: qsTr("Data Command")
            icon: "../images/write_ram.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: dataMenuTriggered()
            visible: false
        }

        ICButton{
            id:origin
            text: qsTr("origin")
            icon: "../images/origin.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: originMenuTriggered()
//            visible: false
        }
        ICButton{
            id:extentAction
            text:qsTr("Extent")
            icon: "../images/action_item_more.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: extentMenuTriggered()
            visible: false
        }

    }
}
