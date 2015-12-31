import QtQuick 1.1

Item {
    property alias text: text.text
    property bool isChecked: false
    property bool useCustomClickHandler: false
    property bool isEditable: true
//    property alias boxWidth: box.width

    signal clicked();

    function setChecked(isCheck){
        this.isChecked = isCheck;
    }

    function getChecked(){
        return this.isChecked;
    }

    width: text.width + box.width + box.anchors.leftMargin
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
//        width:parent.width - box.width
//        height: parent.height
        anchors.left: box.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 4
        color: enabled ? "black" : "gray"
    }

    MouseArea{
        anchors.fill: parent

        onClicked: {
            if(useCustomClickHandler || !isEditable) return;
            setChecked(!isChecked);
            parent.clicked()
        }
    }
}
