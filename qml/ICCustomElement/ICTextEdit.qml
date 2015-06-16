import QtQuick 1.1

FocusScope{
    property alias text: input.text
    property string bindConfig: ""
    x: rectangle.x
    y: rectangle.y
    width: 80
    height: 24

    Rectangle {
        id:rectangle
        border.color: "gray"
        border.width: 1
        width: parent.width
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
                                                      bindConfig,
                                                      true);
                    }else{
                        virtualKeyboard.openSoftPanel(p.x, p.y, input.width, input.height);
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
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            onFocusChanged: onFocus(input.focus)
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    input.focus = true;
                }
            }
        }
    }
}
