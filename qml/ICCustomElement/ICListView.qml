import QtQuick 1.1
import "."

ListView {
    id: listView
    property bool isshowhint: false
    property bool isshowviewborder: false
    property alias hintx: hint.x
    property alias hinty: hint.y
    onMovementEnded: {
        hint.item.hintplay(listView);
    }
    Loader{
        id:hint
        parent: listView.parent
        x: listView.width
        y: listView.height - hint.item.height
        z: listView.z + 1
        visible: isshowhint
    }
    Component.onCompleted: {
        Qt.createQmlObject('import QtQuick 1.0; Rectangle{visible: isshowviewborder;width: gridView.width;height: gridView.height;x: gridView.x;y: gridView.y;z: gridView.z - 1;border.color: "black"}',
                            listView.parent, "dynamicSnippet1");
        hint.source = "ICHintComp.qml";
    }
}
