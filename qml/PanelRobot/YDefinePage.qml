import QtQuick 1.1

Rectangle {
    property variant yDefines: []
    property string currentLanguage: "ch"

    //    anchors.top: parent.top

    Rectangle{
        id:leftContainer
    }
    Rectangle{
        id:rightContainer
    }

    Component.onCompleted: {
        var yDefineItemClass = Qt.createComponent('YDefineItem.qml');
        var leftItems = [];
        var rightItems = [];
        var yDefineItem;
        var topMargin = 20;
        if(yDefineItemClass.status == Component.Ready){
            var itemCountPerCol = yDefines.length >> 1;
            var yData;
            var i;
            for(i = 0; i < itemCountPerCol; ++i){
                yData = yDefines[i];
                yDefineItem = yDefineItemClass.createObject(leftContainer,
                                                            {"pointDescr":yData.pointName + ":" + yData.descr[currentLanguage],
                                                                "y":i * 40 + topMargin});

                leftItems.push(yDefineItem);
            }
            leftContainer.children = leftItems

            for(i = itemCountPerCol; i < yDefines.length; ++i){
                yData = yDefines[i];
                yDefineItem = yDefineItemClass.createObject(rightContainer,
                                                            {"pointDescr":yData.pointName + ":" + yData.descr[currentLanguage],
                                                                "y":(i - itemCountPerCol) * 40 + topMargin,
                                                                "x": 300});

                rightItems.push(yDefineItem);
            }
            rightContainer.children = rightItems

        }
    }

}
