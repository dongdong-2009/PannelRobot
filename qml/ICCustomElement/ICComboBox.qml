import QtQuick 1.1

Rectangle {
    id:container
    property variant items: []
    property int currentIndex: -1
    property int popupMode : 0
    property int itemHeight: 32
    property int contentFontPixelSize: currentText.font.pixelSize
    property alias popupWidth: itemContainer.width
    property int popupHeight: 0

    function currentText(){
        return currentIndex < 0 ?  "" : items[currentIndex];
    }

    function text(index){
        if(index < 0 || index >= items.length) return "";
        return items[index];
    }

    function setItemVisible(index, vi){
        itemModel.setProperty(index, "vis", vi);
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
        text: /*currentIndex < 0 ?  "" : items[currentIndex]*/
        {
            if(currentIndex < 0)
                return "";
            else{
//                console.log("currentIndex",currentIndex,items);
                return items[currentIndex];
            }
        }
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
    ListModel{
        id:itemModel
    }

    Text{
        id:widthHelper
        visible: false
    }

    Rectangle{
        id: itemContainer
//        width: parent.width
        border.width: parent.border.width
        border.color: parent.border.color
        ListView{
            id:view
            z:10
            y:1
            clip: true
            model: itemModel
            delegate: Text{
                height:visible?itemHeight:0
                text: name
                verticalAlignment: Text.AlignVCenter
                x:4
                font.pixelSize: contentFontPixelSize
                visible: vis
                MouseArea{
                    height: itemHeight
                    width: view.width
                    onClicked: {
                        view.currentIndex = index
                        currentIndex = index
                        itemContainer.visible = false
                    }
                }
            }
            highlight: Rectangle {x:1;color: "lightsteelblue"; width: itemContainer.width - x;}
            highlightMoveDuration: 1
            width: parent.width
            height: parent.height - y
        }
        visible: false
        anchors.top: currentText.bottom
        onVisibleChanged: {
            if(visible){
                var realHeight = 0;
                for(var i=0;i<itemModel.count;++i){
                    if(itemModel.get(i).vis ==true){
                         realHeight += itemHeight;
                    }
                }
                height = popupHeight == 0 ? realHeight : Math.min(realHeight, popupHeight);
                var maxWidth = container.width - 10;
                var item;
                for(var i = 0; i < itemModel.count; ++i){
                    item = itemModel.get(i);
                    widthHelper.text = item.name;
                    if(widthHelper.width > maxWidth)
                        maxWidth = widthHelper.width;
                }
                width = maxWidth + 10;
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
            itemModel.append({"index": i, "name":items[i], "vis":true})
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(itemModel.count > 0){
                view.currentIndex = currentIndex;
                itemContainer.visible = true;
            }
        }
    }
}
