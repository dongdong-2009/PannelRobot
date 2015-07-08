import QtQuick 1.1
import "../../ICCustomElement"

Rectangle {
    QtObject{
        id:pData
        property variant menuItemSize: {"width": 130, "height":32}
    }

    signal axisMenuTriggered()
    signal outputMenuTriggered()
    signal checkMenuTriggered()
    signal conditionMenuTriggered()
    signal waitMenuTriggered()
    signal groupMenuTriggered()
    signal syncMenuTriggered()
    signal otherMenuTriggered()
    signal commentMenuTriggered()
    signal searchMenuTriggered()

    Grid{
        columns: 2
        spacing: 10
        x:20
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
            text:qsTr("Other/Flag")
            icon: "../images/action_item_other.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: otherMenuTriggered()
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
            text:qsTr("Group")
            icon: "../images/action_item_parallel.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: groupMenuTriggered()
        }
        ICButton{
            id:search
            text: qsTr("Search")
            icon: "../images/action_item_search.png"
            width: pData.menuItemSize.width
            height: pData.menuItemSize.height
            onButtonClicked: searchMenuTriggered()
        }
    }
}
