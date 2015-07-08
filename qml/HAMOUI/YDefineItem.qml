import QtQuick 1.1

Rectangle {
    property alias pointDescr: pointDescr.text
    property bool isOn: false
    property alias hasMappedX: xLed.visible
    Row{
        spacing: 12
        Text {
            id: pointDescr
            text: qsTr("point")
            anchors.verticalCenter: parent.verticalCenter
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

        Rectangle{
            id:yLed
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
        }

        Rectangle{
            id:xLed
            width: 32
            height: 32
            border.color: "black"
            border.width: 2
            color: "gray"
            visible: hasMappedX
        }
    }

    onIsOnChanged: {
        if(isOn){
            yLed.color = "lightgreen" ;
            actionText.text = qsTr("Off");
        }else{
            yLed.color = "gray"
            actionText.text = qsTr("On");
        }
    }
}
