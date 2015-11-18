import QtQuick 1.1

Item {
    property int layoutMode: 0
    property int spacing: 1
    property Item checkedItem: null
    property bool isAutoSize: true
    id:container

    function autoResize(){
        var buttons  = pData.buttons;
        var allPText;
        var maxPtext;
        if(isAutoSize){
            if(layoutMode == 0){
                allPText = "width";
                maxPtext = "height";
            }else{
                allPText = "height";
                maxPtext = "width";
            }

            var maxP = 0;
            for(var i = 0; i <buttons.length; ++i){
                container[allPText] += buttons[i][allPText] + spacing;
                if(buttons[i][maxPtext] > maxP) maxP = buttons[i][maxPtext];
            }
            container[maxPtext] = maxP;
        }
    }

    QtObject{
        id:pData
        property variant buttons: []
        property double startPos: spacing
        function deepFindCheckBox(item){
            if(item.hasOwnProperty("isChecked")){
                addButton(item);
                return;
            }
            var itemChildren = item.children;

            var count = itemChildren.length;
            for(var i = 0; i < count; ++i){
                pData.deepFindCheckBox(itemChildren[i]);
            }

        }

    }

    signal buttonClickedID(int index)
    signal buttonClickedItem(variant item)

    function onIsCheckedChanged(index, isCheck){
        if(isCheck){
            //            console.log(index);
            var btns = pData.buttons;
            for(var i = 0 ; i < btns.length; ++i){
                if(i !== index)
                    btns[i].setChecked(false);
            }
            //            children[index].setChecked(true);
            buttonClickedID(index);
            buttonClickedItem(btns[index]);
            checkedItem = btns[index];
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
        }else if(layoutMode == 1){
            button.y = pData.startPos;
            pData.startPos += (button.height + spacing);
        }

        var fun = function(){
            var index = l;
            onIsCheckedChanged(index, btns[index].isChecked)
        }

        button.isCheckedChanged.connect(fun);
    }

    onIsAutoSizeChanged: {
        autoResize();
    }

    Component.onCompleted: {
        pData.deepFindCheckBox(container)
        autoResize();
    }

    //    color: parent.color
}
