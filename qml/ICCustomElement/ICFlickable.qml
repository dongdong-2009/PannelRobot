import QtQuick 1.1
import "."

Flickable{
    id: flick
    property bool isshowhint: false
    property alias hintx: hint.x
    property alias hinty: hint.y
    onMovementEnded: {
        hint.item.hintplay(flick);
    }
    Loader{
        id:hint
        parent: flick.parent
        x: flick.width
        y: flick.height - hint.item.height
        z: flick.z + 1
        visible: isshowhint
    }
    Component.onCompleted: {
        hint.source = "ICHintComp.qml";
    }
}
