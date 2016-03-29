import QtQuick 1.1
import "."

Rectangle{
    property bool isShowHint: false
    property alias hintx: hint.x
    property alias hinty: hint.y
    property alias cellWidth: gridView.cellWidth
    property alias cellHeight: gridView.cellHeight
    property alias delegate: gridView.delegate
    property alias model: gridView.model
    property alias clip: gridView.clip
    color: "transparent"
    GridView {
        id: gridView
        x:4
        y:4
        width: parent.width - 8
        height: parent.height - 8
        onMovementEnded: {
            hint.item.hintplay(gridView);
        }
        Loader{
            id:hint
            parent: gridView.parent
            x: gridView.width
            y: gridView.height - hint.item.height
            z: gridView.z + 1
            visible: isShowHint
        }
        Component.onCompleted: {
            hint.source = "ICHintComp.qml";
        }
    }
}
