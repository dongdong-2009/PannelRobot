import QtQuick 1.1
import "../../ICCustomElement"
import "../teach"
import "ProgramActionMenuFrame.js" as LocalPData
import "Teach.js" as LocalTeach
import "../teach/ProgramActionMenuFrame.js" as BasePData
ProgramActionMenuFrame{
    function showActionMenu(){
        actionEditorContainerInstance().setCurrentIndex(LocalPData.menuIndex);
        linkedBtn1Instance().visible = false;
        linkedBtn2Instance().visible = false;
        linkedBtn3Instance().visible = false;
    }



    Rectangle{
        id:kexuyeActionsFrame
        color: "#A0A0F0"
        parent: actionEditorContainerInstance()
        Grid{
            anchors.centerIn: parent
            spacing: 20
            ICButton{
                id:ptLine2D
                text:qsTr("PT Line 2D")
            }
            ICButton{
                id:ptArc3D
                text:qsTr("PT Arc 3D")
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
        var kxyObjectIndex = actionEditorContainerInstance().addPage(kxyObject) - 1;
        editor = Qt.createComponent('KexuYeAxisSpeed.qml');
        var kxyspeed = editor.createObject(actionEditorContainerInstance());
        var kxyAxisSpeedIndex = actionEditorContainerInstance().addPage(kxyspeed) - 1;
        var kxySpeedIndex = function(){
                actionEditorContainerInstance().setCurrentIndex(kxyAxisSpeedIndex);
        }

        var setModeEditorHelper = function(mode, name){
            kxyObject.mode = mode;
            kxyObject.setModeName(name);
            actionEditorContainerInstance().setCurrentIndex(kxyObjectIndex);
            linkedBtn1Instance().visible = true;
            linkedBtn1Instance().text = qsTr("AxisSpeed");
            BasePData.linked1Function = kxySpeedIndex;
        }

        //mode-0
        ptLine2D.buttonClicked.connect(function(){
            setModeEditorHelper(LocalTeach.pentuModes.Line2DRepeat, ptLine2D.text);
        });
        //mode-1
        ptArc3D.buttonClicked.connect(function(){
            setModeEditorHelper(LocalTeach.pentuModes.Arc3DRepeat, ptArc3D.text);
        });
    }
}
