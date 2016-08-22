import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "extents"
import "extents/ExtentActionDefine.js" as ExtentActionDefine

Item {
    id:container
    width: parent.width
    height: parent.height



    function createActionObjects(){
        var ret = [];
        if(axisPly.isChecked){
            ret.push(Teach.generateCustomAction(axisFlyConfigs.getActionProperties()));
        }
        return ret;
    }

    ICButtonGroup{
        id:cmdContainer
        layoutMode: 1
        isAutoSize: false
        mustChecked: true
        width: cmdContent.width
        height: cmdContent.height
        checkedIndex: 0
        y:6
        Flow{
            id:cmdContent
            width: 250
            ICCheckBox{
                id:axisPly
                text: qsTr("Axis Ply")
                isChecked: true
            }
        }
        onCheckedIndexChanged: {
            configsContainer.setCurrentIndex(checkedIndex);
        }
    }
    Rectangle{
        id:spliteLine
        height: 200
        color: "black"
        width: 1
        y:cmdContainer.y
        anchors.left: cmdContainer.right
        anchors.leftMargin: 4
    }
    ICStackContainer{
        id:configsContainer
        anchors.left: spliteLine.right
        anchors.leftMargin: 4
        Component.onCompleted: {
            addPage(axisFlyConfigs);
            currentIndex = 0;
        }
        PENQIANEditor{
            id:axisFlyConfigs
        }
    }
}
