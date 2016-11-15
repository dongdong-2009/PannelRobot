import QtQuick 1.1
import "../../ICCustomElement"

Item {
    width: parnt.width
    height: parent.height
    Image {
        id: safeAreaPic
        source: "../images/delta_jump.png"
        width: parnt.width-200
        height: parent.height
    }
    Rectangle{
        id:spliteLine
        width: 1
        height:parent.height
        color: "black"
        anchors.left: safeAreaPic.right
    }
    Grid{
        columns: 2
        spacing: 5
        anchors.left: spliteLine.right
        anchors.leftMargin: 5
        width:200
        height:parent.height
        ICConfigEdit{
            id:axis1Set
            configName:qsTr("axis1")
        }
        Text {
            text: qsTr(" ")
        }
        ICButton{
            id:minPos1SetBtn
            text:qsTr("minPos1 Set")
            height: minPos1Set.height
        }
        ICConfigEdit{
            id:minPos1Set
            configName:qsTr("minPos1")
            configNameWidth: maxPos1Set.configNameWidth
        }
        ICButton{
            id:maxPos1SetBtn
            text:qsTr("maxPos1 Set")
            height: maxPos1Set.height
        }
        ICConfigEdit{
            id:maxPos1Set
            configName:qsTr("maxPos1")
        }


    }
}

