import QtQuick 1.1

Rectangle {
    id:container
    property variant items: []
    property int currentIndex: -1
//    property alias currentText: currentText.text
    property int popupMode : 0
    property int itemHeight: 24
    property alias popupWidth: itemContainer.width

    function currentText(){
        return currentIndex < 0 ?  "" : items[currentIndex];
    }

    function text(index){
        if(index < 0 || index >= items.length) return "";
        return items[index];
    }

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
        x:4
    }
    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: "▼"
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
            z:10
            model: itemModel
            //            anchors.fill: parent
            delegate: Item{
                width: view.width
                height: itemHeight
                Text {
                    text: name
                    width: view.width
                    anchors.verticalCenter: parent.verticalCenter
                    x:4
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
            highlightMoveDuration: 1
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
        MouseArea{
            width: 800
            height: 600
            Component.onCompleted: {
                var p = mapFromItem(null, 0, 0);
                x = p.x;
                y = p.y;
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
            if(itemModel.count > 0){
                view.currentIndex = currentIndex;
                itemContainer.visible = true;
//                if(currentIndex >=0){
//                }
            }
            //            itemContainer.z = 100

        }
    }
}
