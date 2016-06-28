import QtQuick 1.1
import "../../ICCustomElement"

Item {
    property alias isSel: cid.isChecked
    property alias cID: cid.text
    property alias cName:name.text
    property alias cc: current.text
    property alias ct: target.text
    property alias cIDWidth: cid.width
    property alias nameWidth: name.width
    property alias currentWidth: current.inputWidth
    property alias targetWidth: target.inputWidth
    width: container.width
    height: container.height
    signal counterEditFinished(int cid, string name, int current, int target)
    Row{
        id:container
        spacing: 4
        ICCheckBox{
            id:cid
        }
        Text {
            text: ":"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            id: name
            anchors.verticalCenter: parent.verticalCenter
        }
        ICLineEdit{
            id:current
            onEditFinished: {
                counterEditFinished(parseInt(cid.text), name.text, parseInt(current.text), parseInt(target.text));
            }
        }
        ICLineEdit{
            id:target
            onEditFinished: {
                counterEditFinished(parseInt(cid.text), name.text, parseInt(current.text), parseInt(target.text));
            }
        }
    }
}
