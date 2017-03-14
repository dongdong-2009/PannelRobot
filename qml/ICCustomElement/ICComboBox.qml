import QtQuick 1.1

Rectangle {
    id:container
    property variant items: []
    property int currentIndex: -1
//    property int itemHeight: 32
    property int contentFontPixelSize: currentText.font.pixelSize

    function currentText(){
        return currentIndex < 0 ?  "" : items[currentIndex];
    }

    function text(index){
        if(index < 0 || index >= items.length) return "";
        return items[index];
    }

    function setItemVisible(index, vi){
//        itemModel.setProperty(index, "vis", vi);
    }

    width: 100
    height: 24

    border.width: 1
    border.color: "black"

    state: enabled ? "" : "disabled"

    states: [
        State {
            name: "disabled"
            PropertyChanges { target: container; color:"gray";}
            PropertyChanges { target: currentText; color:"gainsboro";}

        }
    ]

    Text {
        id: currentText
        text: currentIndex < 0 ?  "" : items[currentIndex]
        anchors.verticalCenter : parent.verticalCenter
        x:4
        width: parent.width - dropDownBox.width
        elide: Text.ElideRight
    }
    Text {
        id:dropDownBox
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: "▼"
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(items.length > 0){
                var p = parent.mapToItem(null, x, y)
                currentIndex = comboBoxView.openView(p.x, p.y, width, height, items, currentIndex);
            }
        }
    }
}
