import QtQuick 1.1
import "../ICCustomElement"

Rectangle
{
    id:container
    width: parent.width
    height: parent.height
    color: "grey"
    property variant buffer: []
    ICButton{
        id:gototop
        x:700
        z:1
        text: qsTr("gototop")
        onButtonClicked: {
        }
    }


    ICButton{
        id:gotobottom
        x:700
        y:50
        z:1
        text: qsTr("gotobottom")
        onButtonClicked: {
            console.log(container.buffer[1]);
        }
    }



    Timer {
            id: mytimer
            interval: 1000;
            repeat: visible;
            triggeredOnStart: true;
            running: visible;
            onTriggered:{
                container.buffer = panelRobotController.debug_LogContent().split("\n");
                console.log(container.buffer[1]);
            }
    }

    ListModel {
        id:debugModel
        ListElement {
                 text: "Bill Smith"
             }
    }

    ListView {
        id:debugView
        width: parent.width
        height: parent.height
        model: debugModel
        clip: true
        highlight: Rectangle {width: 650; height: 20;color: "lightsteelblue"; radius: 2}
        delegate: Item {
            width: 650
            height: 20
            Text {
                text: text
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Component.onCompleted: {
        for(var i = 0 ;i < container.buffer.length;i++){
            debugModel.append({"text": container.buffer[i]});
        }
    }
}
