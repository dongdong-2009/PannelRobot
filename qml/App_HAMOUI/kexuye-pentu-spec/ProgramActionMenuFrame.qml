import QtQuick 1.1
import "../../ICCustomElement"
import "../teach"

ProgramActionMenuFrame{

    Rectangle{
        id:kexuyeActionsFrame
        parent: actionEditorContainerInstance()
        Grid{
            ICButton{
                id:ptLineXY
                text:qsTr("PT Line XY")
            }
        }
    }
    Component.onCompleted: {
        var frameIndex = actionEditorContainerInstance().addPage(kexuyeActionsFrame);
        actionEditorContainerInstance().setCurrentIndex(frameIndex - 1);
        actionEditorContainerInstance().showMenu = function(){
            actionEditorContainerInstance().setCurrentIndex(frameIndex - 1);
        }

        var editor = Qt.createComponent('KexuYeActionEdit.qml');
        var kxyObject = editor.createObject(actionEditorContainerInstance());
        var keyObjectIndex = actionEditorContainerInstance().addPage(kxyObject) - 1;
        ptLineXY.buttonClicked.connect(function(){
            actionEditorContainerInstance().setCurrentIndex(keyObjectIndex);
        });
    }
}
