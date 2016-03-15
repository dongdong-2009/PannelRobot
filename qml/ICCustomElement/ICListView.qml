import QtQuick 1.1

ListView {
    id: listView
    property bool isshowhint: false
    property bool isshowviewborder: false
    property real hintx: 0
    property real hinty: 0
    onMovementEnded: {
        hint.item.hintplay(listView);
    }
    Loader{
        id:hint
        parent: gridView.parent
        x: gridView.width
        y: gridView.height - 30
        z: 10
        visible: isshowhint
    }
    Component.onCompleted: {
        Qt.createQmlObject('import QtQuick 1.0; Rectangle{visible: isshowviewborder;width: gridView.width;height: gridView.height;x: gridView.x;y: gridView.y;z: gridView.z - 1;border.color: "black"}',
                            gridView.parent, "dynamicSnippet1");
        hint.source = "ICHintComp.qml";
        if(hintx)
            hint.x = hintx;
        if(hinty)
            hint.y = hinty;
    }
}
