import QtQuick 1.1
import "."

Flickable{
    id: flick
    property bool isshowhint: false
    property alias hintx: hint.x
    property alias hinty: hint.y
    clip: true
    onMovementEnded: {
        hint.item.hintplay(flick);
    }
    Loader{
        id:hint
        parent: flick.parent
        x: flick.width + flick.x - hint.item.width
        y: flick.height + flick.y - hint.item.height
        z: flick.z + 1
        visible: isshowhint && flick.contentHeight > flick.height
//        onStatusChanged: {
//            if(status == Loader.Ready){
//                x = flick.width + flick.x - hint.item.width;
//                y = flick.height + flick.y - hint.item.height;
//            }
//        }
    }
    Component.onCompleted: {
        hint.source = "ICHintComp.qml";
    }
}
