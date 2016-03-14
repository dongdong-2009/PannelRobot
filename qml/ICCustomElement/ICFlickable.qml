import QtQuick 1.1

Flickable{
    id: flick
    property variant hinttext: NULL
    onMovementEnded: {
        if(atYEnd){
            hinttext.text = "∧";
        }else hinttext.text = "∨";
    }
    SequentialAnimation{
        id: flicker
        loops: Animation.Infinite
        running: visible
        PropertyAnimation{ target: hinttext;properties: "color";to:"transparent";duration: 500}
        PropertyAnimation{ target: hinttext;properties: "color";to:"black";duration: 500}
    }
    Component.onCompleted: {
        var hint = Qt.createQmlObject('import QtQuick 1.0; Rectangle{width: 20; height: 20;color: "grey"}',
             flick, "dynamicSnippet1");
        hint.x = flick.width - hint.width;
        hint.y = flick.height - hint.height;
        hinttext = Qt.createQmlObject('import QtQuick 1.0; Text{anchors.centerIn: parent;text: "∨"}',
             hint, "dynamicSnippet2");
    }
}
