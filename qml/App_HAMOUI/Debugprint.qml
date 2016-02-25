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
    property int begin: 1
    property int end: 0
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
            debugView.contentY = (debugModel.count - container.height/30)*30 +12;
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
                    var i, j;
                    var buffer1 = panelRobotController.debug_LogContent().split("\n");
                    if(container.buffer.length < buffer1.length){
//                        console.log("upovercome");
                        for(i = container.buffer.length;i < buffer1.length - 1;i++){
                            debugModel.append({"text1": buffer1[i]});
                        }
                        container.buffer = buffer1;
                    }else if(container.buffer.length == buffer1.length){
                            if(container.buffer[1] != buffer1[1]){
                                begin = 1;
                                debugModel.append({"text1": buffer1[0]});
                            }
                            if(container.buffer[begin] != buffer1[begin]){
                                for(i = begin + 1;i < buffer1.length;i++){
                                    if(container.buffer[i] == buffer1[i]){
                                        end = i;
                                        for(i = begin;i < end; i++){
                                            debugModel.append({"text1": buffer1[i]});
                                        }
                                        begin = end;
                                        if(container.buffer[1] != buffer1[1])
                                            begin = 1;
                                        break;
                                    }
                                }
                            }
                            container.buffer = buffer1;
                        }
                }
            }
    }

    ListModel {
        id:debugModel
    }

    ListView {
        id:debugView
        x:50
        width: parent.width
        height: parent.height
        model: debugModel
        clip: true
        highlight: Rectangle {width: 650; height: 20;color: "lightsteelblue"; radius: 5}
        delegate: Item {
            width: 650
            height: 30
            Text {
                width: parent.width
                text: text1
                wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
            }
//            MouseArea{
//                anchors.fill: parent
//                onClicked: {
//                    debugView.currentIndex = index;
//                }
//            }
        }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    debugView.currentIndex = index;
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
        console.log(debugView.width);
    }
}
