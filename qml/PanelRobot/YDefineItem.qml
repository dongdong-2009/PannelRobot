import QtQuick 1.1

Rectangle {
    property alias pointDescr: pointDescr.text
    property bool isOn: false
    Row{
        spacing: 10
        Text {
            id: pointDescr
            text: qsTr("point")
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle{
            id:led
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
        }

        Rectangle{
            id:actionButton
            width: 80
            height: 32
            color: "white"
            Text {
                id:actionText
                text: qsTr("On")
                anchors.centerIn: parent
            }
        }
    }

    onIsOnChanged: {
        if(isOn){
            led.color = "lightgreen" ;
            actionText.text = qsTr("Off");
        }else{
            led.color = "gray"
            actionText.text = qsTr("On");
        }
    }
}
