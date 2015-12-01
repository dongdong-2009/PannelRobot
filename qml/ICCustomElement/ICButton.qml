import QtQuick 1.1

Rectangle {
    id:container
    property alias text: text.text
    property alias icon: icon.source
    property int iconPos: 0
    property bool isAutoRepeat: false
    property alias autoInterval: autoTimer.interval
    property alias bgColor: container.color
    signal buttonClicked()
    signal clickedText(string text)
    signal triggered()
    width: 100
    height: 32
    border.width: 1
    border.color: "gray"

    state: enabled ? "" : "disabled"

    states: [
        State {
            name: "disabled"
            PropertyChanges { target: container; color:"gray";}
            PropertyChanges { target: text; color:"gainsboro";}

        }

    ]
    Row{
        width: parent.width
        height: parent.height
        layoutDirection: iconPos == 0? Qt.LeftToRight : Qt.RightToLeft
        Image {
            id: icon
            fillMode: Image.Stretch
            anchors.verticalCenter: parent.verticalCenter
//            anchors.left: iconPos == 0 ? parent.left : text.right
        }
        Item{
            width: parent.width
            height: parent.height
            Text {
                id: text
                text: "ICButton"
                anchors.verticalCenter:parent.verticalCenter
                anchors.horizontalCenter: {
                    if(icon.source == ""){
                        return parent.horizontalCenter;
                    }
                }
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        onPressed: {
            parent.color = "lightsteelblue";
            if(isAutoRepeat){
                triggered()
                autoTimer.start();
            }
        }
        onReleased: {
            parent.color = "white";
            if(isAutoRepeat)
                autoTimer.stop();
        }

        onClicked: {
            buttonClicked()
            clickedText(text.text)
            triggered()
        }
    }
    Timer{
        id:autoTimer
        interval: 50; running: false; repeat: true
        onTriggered: {
            parent.triggered()
        }
    }
}
