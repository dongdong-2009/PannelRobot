import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Item {
    signal backToMenuTriggered()

    function createActionObjects(){
        var ret = [];
        ret.push(Teach.generateCommentAction(comment.text))
        return ret;
    }

    width: parent.width
    height: parent.height


    ICButton{
        id:backToMenu
        text: qsTr("Back to Menu")
        onButtonClicked: backToMenuTriggered()
    }

    Column{
        width: parent.width
        spacing: 6
        anchors.top: backToMenu.bottom
        anchors.topMargin: 10

        Text {
            text: qsTr("Comment:")
        }
        ICTextEdit{
            id:comment
            width: parent.width - 4
            height: 200
        }
    }

}
