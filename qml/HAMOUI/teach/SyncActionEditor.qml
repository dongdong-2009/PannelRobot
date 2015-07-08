import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach


Item{
    signal backToMenuTriggered()

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


    ICButton{
        id:backToMenu
        text: qsTr("Back to Menu")
        onButtonClicked: backToMenuTriggered()
    }
    ICButtonGroup{
        anchors.top: backToMenu.bottom
        anchors.topMargin: 10
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
