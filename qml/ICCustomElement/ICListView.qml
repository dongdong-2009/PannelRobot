import QtQuick 1.1
import "."

Rectangle{
    property bool isShowHint: false
    property alias hintx: hint.x
    property alias hinty: hint.y
    property alias delegate: listView.delegate
    property alias model: listView.model
    property alias clip: listView.clip
    property alias highlight : listView.highlight
    property alias highlightMoveDuration : listView.highlightMoveDuration
    property alias currentIndex : listView.currentIndex

    color: "transparent"
    ListView {
        id: listView
        x:4
        y:4
        width: parent.width - 8
        height: parent.height - 8
        onMovementEnded: {
            hint.item.hintplay(listView);
        }
        Loader{
            id:hint
            parent: listView.parent
            x: listView.width
            y: listView.height - hint.item.height
            z: listView.z + 1
            visible: isShowHint
        }
        Component.onCompleted: {
            hint.source = "ICHintComp.qml";
        }
    }
}
