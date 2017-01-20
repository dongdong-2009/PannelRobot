import QtQuick 1.1

Rectangle {
    id:container
    property alias text: text.text
    property alias icon: icon.source
    property int iconPos: -1
    property int customIconX: 0
    property int iY: 0
    property int customTextX: 0
    property int customTextY: 0
    property bool isAutoRepeat: false
    property int autoInterval: 50
    property int delayOnAutoRepeat: 200
    property string bgColor: "white"
    property alias textColor: text.color
    property alias font: text.font
    signal buttonClicked()
    signal clickedText(string text)
    signal triggered()
    signal btnPressed()
    signal btnReleased()
    function clicked(){
        buttonClicked();
    }

    width: 100
    height: 32
    border.width: 1
    border.color: "gray"
    color: bgColor

    onBgColorChanged: {
        color = bgColor;
    }

    state: enabled ? "" : "disabled"

    states: [
        State {
            name: "disabled"
            PropertyChanges { target: container; color:"gray";}
            PropertyChanges { target: text; color:"gainsboro";}

        }

    ]
    Image {
        id: icon
        fillMode: Image.Stretch
        onProgressChanged: {
            if(progress == 1.0){
                if(source === "")
                    iconPos = -1;
                else{
                    if(iconPos === -1)
                        iconPos = 0;
                }
            }
        }

        visible: iconPos >= 0
        //            anchors.left: iconPos == 0 ? parent.left : text.right
    }
    Text {
        id: text
        text: "ICButton"
        y: (parent.height - height) >> 1
        x: (parent.width - width) >> 1
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
    }

    Component.onCompleted: {
        if(iconPos === 0){
            icon.x = 2;
            text.horizontalAlignment = Text.AlignLeft;
            text.x = icon.x + icon.paintedWidth + 2;
            text.y = (container.height - text.height) >> 1;
            icon.y = (container.height - icon.paintedHeight) >> 1;
        }else if(iconPos === 1){
            text.x = 2;
            text.y = (container.height - text.height) >> 1;
            text.horizontalAlignment = Text.AlignLeft;
            icon.x = text.x + text.width + 2;
            icon.y = (container.height - icon.paintedHeight) >> 1;
        }else if(iconPos === 2){
            text.y = 0;
            text.horizontalAlignment = Text.AlignLeft;
            icon.y = text.y + text.font.pixelSize + 2;
        }else if(iconPos === 4){
            text.x = customTextX;
            text.y = customTextY;
            icon.x = customIconX;
            icon.y = iY;
        }
    }

    MouseArea{
        anchors.fill: parent
        preventStealing: true
        onPressed: {
            parent.color = "lightsteelblue";
            if(isAutoRepeat){
                triggered()
                autoTimer.interval = delayOnAutoRepeat;
                autoTimer.start();
            }
            btnPressed();

        }
        onReleased: {
            parent.color = bgColor;
            if(isAutoRepeat)
                autoTimer.stop();
            btnReleased()
        }
        onExited: {
            parent.color = bgColor;
            if(isAutoRepeat){
                autoTimer.stop();
            }
            btnReleased();
        }

        onClicked: {
            buttonClicked();
            clickedText(text.text);
            if(!isAutoRepeat)
                triggered();
        }
        onVisibleChanged: {
            if(!visible && pressed){
                parent.color = bgColor;
                if(isAutoRepeat){
                    autoTimer.stop();
                }
                btnReleased();
            }
        }
    }

    Timer{
        id:autoTimer
        interval: 50; running: false; repeat: true;
        onTriggered: {
            autoTimer.interval = autoInterval;
            parent.triggered();
        }
    }
}
