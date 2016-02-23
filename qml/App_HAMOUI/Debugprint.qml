import QtQuick 1.1
import "../ICCustomElement"

Rectangle
{
    width: parent.width
    //height: parent.height
    color: "grey"
    ICButton{
        id:gototop
        x:700
        z:1
        text: qsTr("gototop")
        onButtonClicked: {
            flick.contentY = 0;
        }
    }


    ICButton{
        id:gotobottom
        x:700
        y:50
        z:1
        text: qsTr("gotobottom")
        onButtonClicked: {
            flick.contentY = debugtext.paintedHeight - 410;
        }
    }

    Flickable{
        id: flick
        width: parent.width
        height: parent.height - 80
        //可拖拽内容大小
//        contentWidth: debugtext.width
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
                repeat: visible;
                triggeredOnStart: true;
                running: true;
                onTriggered:{
//                    debugtext.text =  panelRobotController.debug_LogContent();
                    debugtext.text = dlkdjflkjda;
                }
        }
     }
}
