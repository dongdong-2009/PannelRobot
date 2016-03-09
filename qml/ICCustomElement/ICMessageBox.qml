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

    signal accept();
    signal reject();
    signal finished(int status)

    function show(tip, yesText, noText){
        text = tip || "";
        yesBtnText = yesText || "Yes";
        noBtnText = noText || "No";
        container.visible = true;
    }
    function warning(tip, Text){
        text = tip || "";
        yesBtnText = Text || "OK";
        noBtn.visible = false;
        container.visible = true;
    }

    function showInput(tip, configName, isNumberOnly, yesText, noText){
        input.visible = true;
        input.configName = configName;
        input.isNumberOnly = isNumberOnly;
        input.configValue = "";
        show(tip, yesText, noText)
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
            }
        }
    }
}
