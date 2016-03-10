import QtQuick 1.1

Image {
    property url baseSource: ""
    function refreshImage(){
        source = enabled ? baseSource : panelRobotController.disableImage(baseSource);
    }

    onEnabledChanged: refreshImage()
    onSourceChanged: {
        if(baseSource.length == 0){
            baseSource = source;
        }
    }
    Component.onCompleted: {
        baseSource = source;
        refreshImage();
    }
}
