import QtQuick 1.1

Rectangle {
    property int layoutMode: 0
    property int spacing: 1

    QtObject{
        id:pData
        property variant buttons: []
        property double startPos: spacing
    }

    signal buttonClickedID(int index)
    signal buttonClickedItem(variant item)

    function onIsCheckedChanged(index, isCheck){
        if(isCheck){
//            console.log(index);
            for(var i = 0 ; i < children.length; ++i){
                if(i !== index)
                    children[i].setChecked(false);
            }
//            children[index].setChecked(true);
            buttonClickedID(index);
            buttonClickedItem(children[index]);
        }
    }

    function addButton(button){
        var btns = pData.buttons;
        var l = btns.length;
        btns.push(button);
        pData.buttons = btns;
        if(layoutMode == 0){
            button.x = pData.startPos;
//            console.log(pData.startPos,button.width);
            pData.startPos += (button.width + spacing);
        }
        var fun = function(){
            var index = l;
            onIsCheckedChanged(index, children[index].isChecked)
        }

        button.isCheckedChanged.connect(fun);
    }

    Component.onCompleted: {
        var count = children.length;
        for(var i = 0; i < count; ++i){
            addButton(children[i]);
        }

//        if(count < 2) return;
//        var startPos = 0;
//        if(layoutMode == 0){
//            children[0].x = spacing;
//            startPos = children[0].x + children[0].width + spacing;

//            for(var i = 1; i < count; ++i){
//                children[i].x = startPos;
//                startPos += children[i].width + spacing;
//            }
//        }
    }

    color: parent.color
}
