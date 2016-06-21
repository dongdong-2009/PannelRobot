import QtQuick 1.1

Rectangle {
    property alias itemText: text.text
    property bool isChecked: false
    property alias textFont: text.font
    property string textColor:"black"
    property alias horizontalAlignment: text.horizontalAlignment
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
        x:2
        width: parent.width - x
        anchors.verticalCenter: parent.verticalCenter
//        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        color: enabled? textColor : "gray"

    }

    onIsCheckedChanged: {
        if(isChecked){
            x -= 1;
            y += 2;
            width += 1;
        }
        else{
            x += 1;
            y -= 2;
            width -= 1;
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {itemTriggered(); setChecked(true);}
    }
}
