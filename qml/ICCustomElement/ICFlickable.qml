import QtQuick 1.1
import "."

Flickable{
    id: flick
    property bool isshowhint: false
    property real hintx: 0
    property real hinty: 0
    onMovementEnded: {
        hint.item.hintplay(flick);
    }
    Loader{
        id:hint
        parent: flick.parent
        x: flick.width
        y: flick.height - 30
        z: 10
        visible: isshowhint
    }
    Component.onCompleted: {
        hint.source = "ICHintComp.qml";
        if(hintx)
            hint.x = hintx;
        if(hinty)
            hint.y = hinty;
    }
}
