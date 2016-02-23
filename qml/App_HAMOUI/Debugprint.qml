import QtQuick 1.1

Rectangle
{
    width: parent.width
    height: parent.height
    color: "grey"

    Flickable{
        id: flick
        width: parent.width
        height: parent.height
        //可拖拽内容大小
        contentWidth: debugtext.width
        contentHeight: debugtext.height
        //隐藏大于显示窗口的部分
        clip: true;
        Text{
            id:debugtext
            //text:panelRobotController.debug_LogContent()
        }
        Timer {
                id: mytimer
                interval: 1000;
                repeat: true;
                triggeredOnStart: true;
                running: true;
                onTriggered:{
                    debugtext.text =  panelRobotController.debug_LogContent();
                }
        }
     }
}

    //        Timer {
    //                var i=0;
    //                id: mytimer
    //                interval: 1000;
    //                repeat: true;
    //                triggeredOnStart: true;
    //                running: true;
    //                onTriggered:{
    //                    debugtext.text =  panelRobotController.debug_LogContent();
    //                    //debugtext.text = i++;
    //                }
    //    }

