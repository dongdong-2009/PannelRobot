import QtQuick 1.1
import "../ICCustomElement"

Rectangle
{
    id:container
    width: parent.width
    height: parent.height
    color: "grey"
    property variant buffer: []
    property bool isover: false
    ICButton{
        id:gototop
        x:700
        z:1
        text: qsTr("gototop")
        onButtonClicked: {
            debugView.contentY = 0;
        }
    }


    ICButton{
        id:gotobottom
        x:700
        y:50
        z:1
        text: qsTr("gotobottom")
        onButtonClicked: {
            debugView.contentY = (debugModel.count - 19)*20;    //why can't use myitem.height
//            console.log(debugModel.count,myitem.height);
        }
    }



    Timer {
            id: mytimer
            interval: 1000;
            repeat: visible;
            triggeredOnStart: true;
            running: visible;
            onTriggered:{
                if(isover){
                    var i,count = 0;
                    var buffer1 = panelRobotController.debug_LogContent().split("\n");
                    if(container.buffer.length < buffer1.length){
                        for(i = container.buffer.length;i < buffer1.length;i++){
                            debugModel.append({"text1": buffer1[i]});
                        }
                        container.buffer = buffer1;
                    }else if(container.buffer.length == buffer1.length){
                            if(container.buffer[count] != buffer1[count])
                            var j = 0;
                            for(;j < container.buffer.length;j++){
                                if(container.buffer[j] == buffer1[j]){
                                    count = j;
                                    break;
                                }
                            }
                            for(i = 0;i < j;i++){
                                debugModel.append({"text1": buffer1[i]});
                            }
                        }
                }
            }
    }

    ListModel {
        id:debugModel
    }

    ListView {
        id:debugView
        width: parent.width
        height: parent.height
        model: debugModel
        clip: true
        highlight: Rectangle {width: 650; height: 20;color: "lightsteelblue"; radius: 5}
        delegate: Item {
            id:myitem
            width: 650
            height: 20
            Text {
                text: text1
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
//                debugView.currentIndex = index;
            }
        }
    }

    WorkerScript {
         id: myWorker
         source: "script.js"
         onMessage: isover = messageObject.over
     }

    Component.onCompleted: {
        container.buffer = panelRobotController.debug_LogContent().split("\n");
        myWorker.sendMessage({'buffer':container.buffer, 'model':debugModel});
    }
}
