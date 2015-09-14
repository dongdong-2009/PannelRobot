import QtQuick 1.1

Rectangle {
    id:container
    property variant items: []
    property int currentIndex: -1
    property alias currentText: currentText.text
    property int popupMode : 0
    property int itemHeight: 24

    width: 100
    height: 24

    border.width: 1
    border.color: "gray"

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
        text:currentIndex < 0 ?  "" : items[currentIndex]
        anchors.verticalCenter : parent.verticalCenter
    }
    ListModel{
        id:itemModel
    }

    Rectangle{
        id: itemContainer
        width: parent.width
//        height: itemHeight * itemModel.count
        border.width: parent.border.width
        border.color: parent.border.color
        ListView{
            id:view
            model: itemModel
            //            anchors.fill: parent
            delegate: Item{
                width: view.width
                height: itemHeight
                Text {
                    text: name
                    width: view.width
                    anchors.verticalCenter: parent.verticalCenter
                    //                font.pixelSize : 18
                }
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
        anchors.top: currentText.bottom
        onVisibleChanged: {
            if(visible){
                height = itemHeight * itemModel.count;
            }
        }
    }

    onPopupModeChanged: {
        if(popupMode == 0){
            itemContainer.anchors.bottom = undefined;
            itemContainer.anchors.top = currentText.bottom;
        }else{
            itemContainer.anchors.top = undefined;
            itemContainer.anchors.bottom = currentText.top;
        }
    }


    onItemsChanged: {
        itemModel.clear();
        for(var i = 0; i < items.length; ++i){
            itemModel.append({"index": i, "name":items[i]})
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            itemContainer.visible = true;
            //            itemContainer.z = 100

        }
    }
}
