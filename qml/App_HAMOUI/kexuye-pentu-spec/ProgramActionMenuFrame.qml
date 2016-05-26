import QtQuick 1.1
import "../../ICCustomElement"
import "../teach"

ProgramActionMenuFrame{

    Rectangle{
        id:kexuyeActionsFrame
        parent: actionEditorContainerInstance()
        Grid{
            ICButton{
                id:action1
                text:qsTr("Action1")
            }
        }
    }
    Component.onCompleted: {
        var frameIndex = actionEditorContainerInstance().addPage(kexuyeActionsFrame);
        actionEditorContainerInstance().setCurrentIndex(frameIndex - 1);
        console.log("dfsdfdsf", frameIndex);
    }
}
