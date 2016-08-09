import QtQuick 1.1

MouseArea {
    id:container
    width: 800
    height: 600
    x:0
    y:0
    visible: false

    property alias text: tip.text
    property alias yesBtnText: yesBtn.text
    property alias noBtnText: noBtn.text
    property alias realWidth: realFrame.width
    property alias realHeight: realFrame.height
    property alias inputText: input.configValue
    property bool useKeyboard: false
    property int acceptKey: -1
    property int rejectKey: -1

    signal accept();
    signal reject();
    signal finished(int status)



    function show(tip, yesText, noText, details){
        text = tip || "";
        yesBtnText = yesText || ("Yes");
        noBtnText = noText || ("No");
        container.visible = true;
        realFrame.color = "#A0A0F0";
        yesBtn.color = "lime"
        noBtn.color = "yellow"
        yesBtn.visible = true;
        noBtn.visible = true;
    }

    function hide(){
        detailContainer.visible = false;
        detailText.text = "";
        container.visible = false;
    }

    function runningTip(tip, yesText){
        text = tip || "";
        yesBtnText = yesText || ("Get it");
        yesBtn.visible = (yesText == undefined ? false : true);
        noBtn.visible = false;
        container.visible = true;
        realFrame.color = "#A0A0F0";
        yesBtn.color = "lime";
        panelRobotController.processEvents();
    }

    function information(tip, Text){
        text = tip || "";
        yesBtnText = Text || ("OK");
        noBtn.visible = false;
        yesBtn.visible = true;
        container.visible = true;
        realFrame.color = "#A0A0F0";
        yesBtn.color = "lime"
    }

    function warning(tip, Text, details){
        text = tip || "";
        yesBtnText = Text || ("OK");
        noBtn.visible = false;
        yesBtn.visible = true;
        container.visible = true;
        realFrame.color = "yellow";
        yesBtn.color = "red";
        detailText.text = details || ""
    }

    function showInput(tip, configName, isNumberOnly, yesText, noText){
        input.visible = true;
        input.configName = configName;
        input.isNumberOnly = isNumberOnly;
        input.configValue = "";
        show(tip, yesText, noText)
    }

    focus: useKeyboard && visible
    Keys.onPressed: {
        if(!useKeyboard) return;
        if(event.key == acceptKey){
            yesBtn.clicked();
            event.accepted = true;
        }
        else if(event.key == rejectKey){
            noBtn.clicked();
            event.accepted = true;
        }

    }


    Rectangle{
        id:realFrame
        border.color: "black"
        border.width: 1
        width: content.width + 20
        height: content.height + 20
        Column{
            id:content
            spacing: 6
            anchors.centerIn: parent
            Text {
                id: tip
            }
            ICConfigEdit{
                id:input
                visible: false
                inputWidth: tip.width
            }

            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                ICButton{
                    id:yesBtn
                    onButtonClicked: {
                        accept();
                        finished(1)
                        container.visible = false;
                        input.visible = false;
                    }

                }
                ICButton{
                    id:noBtn
                    onButtonClicked: {
                        reject();
                        finished(0)
                        container.visible = false;
                        input.visible = false;
                    }
                }
                ICButton{
                    id:detailsBtn
                    visible: detailText.text.length > 0
                    text: qsTr("Details")
                    onButtonClicked: {
                        detailContainer.visible = !detailContainer.visible;
                    }
                }
            }
        }
    }
    Rectangle{
        id:detailContainer
        width: realFrame.width
        height: 150
        border.color: "black"
        border.width: 1
        color:"#A0A0F0";
        anchors.left: realFrame.left
        anchors.top: realFrame.bottom
        visible: false
        ICFlickable{
            width: parent.width
            height: parent.height
            contentWidth: detailText.width
            contentHeight: detailText.height
            flickableDirection: Flickable.VerticalFlick
            clip: true
            Text{
                id:detailText
                width: parent.width
            }
        }
    }
}
