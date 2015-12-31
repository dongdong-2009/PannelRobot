import QtQuick 1.1
import '.'
import '../ICCustomElement'

Rectangle{
    width: 800
    height: 600
    property int startupTime: 20
    Item{
        id: splash
        width: parent.width
        height: parent.height
        z:1000
        Image {
            source: "images/startup_page.png"
            width: parent.width
            height: parent.height
        }
        Component.onCompleted: {
            startup.start();
        }

//        ICProgressBar{
//            id:progressBar
//            width: parent.width - 100;
//            height: 24
//            x:50
//            y:parent.height - 30
//        }
    }

    Loader{
        id:mainFrame
        anchors.fill: parent
    }
    Timer{
        id:startup
        interval: 50
        running: false
        repeat: false
        onTriggered: {
            mainFrame.source = "MainFrame.qml";
            splash.visible = false;
//            finish.start();
        }
    }
//    Timer{
//        id:finish
//        interval: startupTime * 10
//        running: false
//        repeat: true
//        onTriggered: {
//            //            splash.visible = false
//            var cStep = progressBar.value();
//            cStep += 1;
//            console.log(cStep);
//            if(cStep == 100){
//                finish.repeat = false;
//                finish.stop();
//                splash.visible = false;
//            }
//            progressBar.setValue(cStep);
//        }
//    }

}
