import QtQuick 1.1

FocusScope{
    property alias text: input.text
    property string bindConfig: ""
    property alias unit: unit.text
    property int alignMode: 0
    property bool isNumberOnly: true
    property alias inputWidth: rectangle.width
    property double min : 0
    property double max: 4000000000
    property int decimal: 0
    property alias rectangle: rectangle
    x: rectangle.x
    y: rectangle.y
    width: rectangle.width + unit.width
    height: 24

    signal editFinished();

    state: enabled ? "" : "disabled"

    states: [
        State {
            name: "disabled"
            PropertyChanges { target: rectangle; color:"gray";}
            PropertyChanges { target: input; color:"gainsboro";}

        }

    ]

    function isEmpty(){
        return text.length == 0;
    }

    Rectangle {
        id:rectangle
        border.color: "black"
        border.width: 1
        //        width: parent.width - unit.width
        width: 80
        height: parent.height
        enabled: parent.enabled
        TextInput{
            enabled: parent.enabled
            function onFocus(isActive){
                if(isActive){
                    var p = parent.mapToItem(null, input.x, input.y);
                    if(bindConfig.length != 0){
                        virtualKeyboard.openSoftPanel(p.x,
                                                      p.y,
                                                      input.width,
                                                      input.height,
                                                      isNumberOnly,
                                                      bindConfig,
                                                      true);
                    }else if(isNumberOnly){
                        virtualKeyboard.openSoftPanel(p.x, p.y, input.width, input.height, min, max, decimal);
                    }else{
                        virtualKeyboard.openSoftPanel(p.x, p.y, input.width, input.height,isNumberOnly);
                    }
                    if(rectangle.color != "#000000")
                        rectangle.color = "green";
                    virtualKeyboard.commit.disconnect(onCommit);
                    virtualKeyboard.reject.disconnect(onReject);
                    virtualKeyboard.commit.connect(onCommit);
                    virtualKeyboard.reject.connect(onReject);
                }else{
                    if(rectangle.color != "#000000")
                        rectangle.color = "white";
                    virtualKeyboard.commit.disconnect(onCommit);
                    virtualKeyboard.reject.disconnect(onReject);

                }

            }

            function onCommit(text){
                //                console.log(text)
                input.text = text;
                input.focus = false;
                editFinished();
            }

            function onReject(){
                input.focus = false;
            }

            id:input
            color: "black"
            //            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 4
            anchors.leftMargin: 4
            anchors.right: {
                if(alignMode == 1)
                    return unit.left
            }
            anchors.left: {
                if(alignMode == 0)
                    return parent.left
            }
            onFocusChanged: onFocus(input.focus)
        }
        Text {
            id: unit
            anchors.left: parent.right
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            enabled: parent.enabled

        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                input.focus = true;
            }
        }
    }
}
