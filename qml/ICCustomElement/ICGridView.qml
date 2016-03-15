import QtQuick 1.1
import "."

GridView {
    id: gridView
    property bool isshowhint: false
    property bool isshowviewborder: false
    property alias hintx: hint.x
    property alias hinty: hint.y
    onMovementEnded: {
        hint.item.hintplay(gridView);
    }
    Loader{
        id:hint
        parent: gridView.parent
        x: gridView.width
        y: gridView.height - hint.item.height
        z: gridView.z + 1
        visible: isshowhint
    }
    Component.onCompleted: {
        Qt.createQmlObject('import QtQuick 1.0; Rectangle{visible: isshowviewborder;width: gridView.width;height: gridView.height;x: gridView.x;y: gridView.y;z: gridView.z - 1;border.color: "black"}',
             gridView.parent, "dynamicSnippet1");
        hint.source = "ICHintComp.qml";
    }
}
