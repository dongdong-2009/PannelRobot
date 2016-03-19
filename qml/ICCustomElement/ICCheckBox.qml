import QtQuick 1.1

Item {
    id:container
    property alias text: text.text
    property bool isChecked: false
    property bool useCustomClickHandler: false
    property bool isEditable: true
    property int textPos: 0

    signal clicked();

    function setChecked(isCheck){
        this.isChecked = isCheck;
    }

    function getChecked(){
        return this.isChecked;
    }

    width: text.width + box.width + 4
    height: 24
    Rectangle{
        id:box
        width: parent.height
        height: parent.height
        border.width: 1
        border.color: "black"
        color: isChecked ? "lightgreen" :"white"
        Image{
            id:checkedImage
            source: "images/checked.svg"
            width:parent.width + 6
            height:parent.height + 6
            visible: isChecked
            y:-2
        }
    }
    Text {
        id: text
        text: "ICCheckBox"
        anchors.verticalCenter: parent.verticalCenter
        color: enabled ? "black" : "gray"
        x:box.x + box.width + 4
    }

    onTextPosChanged: {
        if(textPos == 0){
            box.x = 0
            text.x = box.x + box.width + 4
        }else if(textPos == 1){
            text.x = 0;
            box.x = text.x + text.width + 4
        }else if(textPos == 2){
            box.x = 0;
            text.anchors.horizontalCenter = container.horizontalCenter
        }
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
