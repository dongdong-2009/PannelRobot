import QtQuick 1.1
import "../../ICCustomElement"
import "../teach"
import "ProgramActionMenuFrame.js" as LocalPData

ProgramActionMenuFrame{
    function showActionMenu(){
        actionEditorContainerInstance().setCurrentIndex(LocalPData.menuIndex);
    }



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
        var frameIndex = actionEditorContainerInstance().addPage(kexuyeActionsFrame) - 1;
        actionEditorContainerInstance().setCurrentIndex(frameIndex );
        LocalPData.menuIndex = frameIndex;
        var editor = Qt.createComponent('KexuYeActionEdit.qml');
        var kxyObject = editor.createObject(actionEditorContainerInstance());
        var keyObjectIndex = actionEditorContainerInstance().addPage(kxyObject) - 1;
        ptLineXY.buttonClicked.connect(function(){
            actionEditorContainerInstance().setCurrentIndex(keyObjectIndex);
        });
    }
}
