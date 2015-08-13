import QtQuick 1.1

FocusScope{
    property alias text: input.text
    property string bindConfig: ""
    property alias unit: unit.text
    property int alignMode: 0
    property bool isNumberOnly: true
    property alias inputWidth: rectangle.width
    x: rectangle.x
    y: rectangle.y
    width: 80
    height: 24

    function isEmpty(){
        return text.length == 0;
    }

    Rectangle {
        id:rectangle
        border.color: "gray"
        border.width: 1
        width: parent.width - unit.width
        height: parent.height
        TextInput{
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
                    }else{
                        virtualKeyboard.openSoftPanel(p.x, p.y, input.width, input.height,isNumberOnly);
                    }
                    rectangle.color = "green";
                    virtualKeyboard.commit.connect(onCommit);
                    virtualKeyboard.reject.connect(onReject);
                }else{
                    rectangle.color = "white";
                    virtualKeyboard.commit.disconnect(onCommit);
                    virtualKeyboard.reject.disconnect(onReject);

                }

            }

            function onCommit(text){
//                console.log(text)
                input.text = text;
                input.focus = false;

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
            onFocusChanged: onFocus(input.focus)
        }
        Text {
            id: unit
            anchors.left: parent.right
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                input.focus = true;
            }
        }
    }
}
