import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach


Item{
    function createActionObjects(){
        var ret = [];
        if(syncBegin.isChecked)
            ret.push(Teach.generateSyncBeginAction());
        else if(syncEnd.isChecked)
            ret.push(Teach.generateSyncEndAction());
        return ret;
    }

    width: parent.width
    height: parent.height

    ICButtonGroup{
        layoutMode: 1
        spacing: 10
        ICCheckBox{
            id:syncBegin
            text: qsTr("Sync Begin")
        }

        ICCheckBox{
            id:syncEnd
            text: qsTr("Sync End")
        }

    }
}
