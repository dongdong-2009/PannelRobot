import QtQuick 1.1

Rectangle {
    property alias text: text.text
    property alias icon: icon.source
    property int iconPos: 0
    signal buttonClicked()
    width: 100
    height: 32
    border.width: 1
    border.color: "gray"
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
        }
        onReleased: {
            parent.color = "white";
        }

        onClicked: {
            buttonClicked()
        }
    }
}
