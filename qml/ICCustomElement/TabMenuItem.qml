import QtQuick 1.1

Rectangle {
    property alias itemText: text.text
    property bool isChecked: false
    signal itemTriggered()


    function setChecked(isCheck){
        this.isChecked = isCheck;
    }

    function getChecked(){
        return this.isChecked;
    }

    color: getChecked() ? "gray" : "white"

    Text {
        id: text
        text: qsTr("TabItem")
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {itemTriggered(); setChecked(true);}
    }
}
