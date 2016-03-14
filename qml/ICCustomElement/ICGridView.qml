import QtQuick 1.1

GridView {
    id: gridView
    property variant hinttext: NULL
    property variant hinttext1: NULL
    property bool isshowhint: false
    property bool isshowviewborder: false
    property int hintx: 0
    property int hinty: 0
    onMovementEnded: {
        if(atYEnd){
            hinttext.text = "︽";
            hinttext1.text = "︽"
        }else {hinttext.text = "︾";hinttext1.text = "︾";}
    }
    SequentialAnimation{
        id: flicker
        loops: Animation.Infinite
        running: visible
        PropertyAnimation{ target: hinttext;properties: "color";to:"transparent";duration: 200}
        PropertyAnimation{ target: hinttext1;properties: "color";to:"black";duration: 200}
        PropertyAnimation{ target: hinttext;properties: "color";to:"black";duration: 200}
        PropertyAnimation{ target: hinttext1;properties: "color";to:"transparent";duration: 200}
    }
    Component.onCompleted: {
        var regt = Qt.createQmlObject('import QtQuick 1.0; Rectangle{visible: isshowviewborder;width: gridView.width;height: gridView.height;x: gridView.x;y: gridView.y;z: gridView.z - 1;border.color: "black"}',
             gridView.parent, "dynamicSnippet1");
        var hint = Qt.createQmlObject('import QtQuick 1.0; Rectangle{width: 15;height: 30;color: "grey"}',
             gridView.parent, "dynamicSnippet2");
        hint.x = gridView.width;
        hint.y = gridView.height - hint.height;
        if(hintx || hinty){
            hint.x = hintx;
            hint.y = hinty;
        }
        hint.visible = isshowhint;
        hinttext = Qt.createQmlObject('import QtQuick 1.0; Text{text: "︾";visible: hintvisible}',
             hint, "dynamicSnippet3");
        hinttext1 = Qt.createQmlObject('import QtQuick 1.0; Text{text: "︾";x: hinttext.x;y: hinttext.y + 10;visible: hintvisible}',
             hint, "dynamicSnippet3");
    }
}
