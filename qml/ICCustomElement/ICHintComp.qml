import QtQuick 1.1
Rectangle{
    id: continer
    width: hinttext.width
    height: 30
    color: "grey"
    Text {
        id: hinttext
        text: "︾"
    }
    Text{
        id: hinttext1
        text: "︾"
        x: hinttext.x
        y: hinttext.y + 10
    }
    function hintplay(target){
        if(target.atYEnd){
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
}

