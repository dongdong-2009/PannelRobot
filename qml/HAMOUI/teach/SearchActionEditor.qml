import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Item {
    signal backToMenuTriggered()

    function createActionObjects(){
        return [];
    }

    width: parent.width
    height: parent.height


    ICButton{
        id:backToMenu
        text: qsTr("Back to Menu")
        onButtonClicked: backToMenuTriggered()
    }
    ICButton{
        id:search
        text: qsTr("Start Search")
        width: 100
        anchors.top: backToMenu.bottom
        anchors.topMargin: 10
    }
}
