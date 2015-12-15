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

    signal accept();
    signal reject();

    function show(tip, yesText, noText){
        text = tip || "";
        yesBtnText = yesText || "Yes";
        noBtnText = noText || "No";
        container.visible = true;
    }

    Rectangle{
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
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                ICButton{
                    id:yesBtn
                    onButtonClicked: {
                        accept();
                        container.visible = false;
                    }

                }
                ICButton{
                    id:noBtn
                    onButtonClicked: {
                        reject();
                        container.visible = false;
                    }
                }
            }
        }
    }
}
