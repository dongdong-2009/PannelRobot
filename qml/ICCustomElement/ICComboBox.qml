import QtQuick 1.1

Rectangle {
    property variant items: []
    property int currentIndex: -1

    width: 100
    height: 32

    Text {
        id: currentText
        text:currentIndex < 0 ?  "" : items[currentIndex]
        anchors.verticalCenter : parent.verticalCenter
    }
    ListModel{
        id:itemModel
    }

    Rectangle{
        id: itemContainer
        width: parent.width
        height: itemModel.count * 20
        ListView{
            id:view
            model: itemModel
//            anchors.fill: parent
            delegate: Text {
                text: name
                width: view.width
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        view.currentIndex = index
                        currentIndex = index
                        itemContainer.visible = false
                    }
                }
            }
            highlight: Rectangle { color: "lightsteelblue"; width: itemContainer.width }
            width: parent.width
            height: parent.height
        }
        visible: false
        anchors.top: parent.bottom

    }


    onItemsChanged: {
        for(var i = 0; i < items.length; ++i){
            itemModel.append({"index": i, "name":items[i]})
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            itemContainer.visible = true;
        }
    }
}
