import QtQuick 1.1
import "../../ICCustomElement"
import "../teach"
import "ProgramActionMenuFrame.js" as LocalPData
import "Teach.js" as LocalTeach
ProgramActionMenuFrame{
    function showActionMenu(){
        actionEditorContainerInstance().setCurrentIndex(LocalPData.menuIndex);
        linkedBtn1Instance().visible = false;
        linkedBtn2Instance().visible = false;
        linkedBtn3Instance().visible = false;
    }



    Rectangle{
        id:kexuyeActionsFrame
        parent: actionEditorContainerInstance()
        Grid{
            ICButton{
                id:ptLineXY
                text:qsTr("PT Line XY")
            }
            ICButton{
                id:baseCmd
                text:qsTr("Base CMD")
                onButtonClicked: {
                    actionEditorContainerInstance().setCurrentIndex(0);
                }
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
            kxyObject.mode = LocalTeach.pentuModes.singleAxisRepeat;
            actionEditorContainerInstance().setCurrentIndex(keyObjectIndex);
        });

    }
}
