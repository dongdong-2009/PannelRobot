import QtQuick 1.1

Item {
    property alias text: text.text
    property bool isChecked: false
    property bool useCustomClickHandler: false

    function setChecked(isCheck){
        this.isChecked = isCheck;
    }

    function getChecked(){
        return this.isChecked;
    }
    width: 60
    height: 24
    Rectangle{
        id:box
        width: parent.height
        height: parent.height
        border.width: 1
        border.color: "gray"
        color: isChecked ? "lightgreen" :"white"
    }
    Text {
        id: text
        text: "ICCheckBox"
        width:parent.width - box.width
//        height: parent.height
        anchors.left: box.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 4
    }

    MouseArea{
        anchors.fill: parent

        onClicked: {
            if(useCustomClickHandler) return;
            setChecked(!isChecked);
        }
    }
}
