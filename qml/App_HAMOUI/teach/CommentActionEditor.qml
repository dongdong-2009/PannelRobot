import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Item {

    function createActionObjects(){
        var ret = [];
        ret.push(Teach.generateCommentAction(comment.text))
        return ret;
    }

    width: parent.width
    height: parent.height

    Column{
        width: parent.width
        spacing: 6

        Text {
            text: qsTr("Comment:")
        }
        ICTextEdit{
            id:comment
            width: parent.width - 4
            height: 180
        }
    }

}
