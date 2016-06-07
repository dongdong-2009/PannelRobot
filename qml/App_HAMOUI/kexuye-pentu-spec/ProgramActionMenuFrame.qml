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

    function isMenuVisiable() { return kexuyeActionsFrame.visible;}




    Rectangle{
        id:kexuyeActionsFrame
        color: "#A0A0F0"
        parent: actionEditorContainerInstance()
        Grid{
            anchors.centerIn: parent
            spacing: 20
            ICButton{
                id:ptLine_U_2D
                text:qsTr("PT U 2D")
            }
            ICButton{
                id:ptLine_Z_2D
                text:qsTr("PT Z 2D")
            }
            ICButton{
                id:ptLine_Saw_2D
                text:qsTr("PT Saw 2D")
            }
            ICButton{
                id:ptLine_Dir_2D
                text:qsTr("PT Dir 2D")
            }
            ICButton{
                id:ptArc3D
                text:qsTr("PT Arc 3D")
            }
        }
        ICButton{
            id:baseCmd
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text:qsTr("Base CMD")
            onButtonClicked: {
                actionEditorContainerInstance().setCurrentIndex(0);
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
        kxyObject.detailInstance = kxyspeed;
        var kxySpeedIndex = function(){
            if(kxyspeed.speedcontainer().visible){
                linkedBtn1Instance().text = qsTr("DetailFace");
                actionEditorContainerInstance().setCurrentIndex(kxyObjectIndex);
            }
            else{
                linkedBtn1Instance().text = qsTr("Return");
                actionEditorContainerInstance().setCurrentIndex(kxyAxisSpeedIndex);
            }

        }

        var setModeEditorHelper = function(mode, name, pos1name, pos2name){
            kxyObject.mode = mode;
            kxyObject.setModeName(name);
            kxyObject.setPosName(pos1name, pos2name);
            actionEditorContainerInstance().setCurrentIndex(kxyObjectIndex);
            linkedBtn1Instance().visible = true;
            linkedBtn1Instance().text = qsTr("DetailFace");
            BasePData.linked1Function = kxySpeedIndex;
        }

        //mode-0
        ptLine_U_2D.buttonClicked.connect(function(){
            setModeEditorHelper(LocalTeach.pentuModes.LineU2DRepeat, ptLine_U_2D.text, qsTr("Set EPos"), qsTr("Set TPos"));
        });
        ptLine_Z_2D.buttonClicked.connect(function(){
            setModeEditorHelper(LocalTeach.pentuModes.LineZ2DRepeat, ptLine_Z_2D.text, qsTr("Set EPos"), qsTr("Set TPos"));
        });
        ptLine_Saw_2D.buttonClicked.connect(function(){
            setModeEditorHelper(LocalTeach.pentuModes.LineSaw2DRepeat, ptLine_Saw_2D.text, qsTr("Set EPos"), qsTr("Set TPos"));
        });
        ptLine_Dir_2D.buttonClicked.connect(function(){
            setModeEditorHelper(LocalTeach.pentuModes.LineDir2DRepeat, ptLine_Dir_2D.text, qsTr("Set EPos"), qsTr("Set TPos"));
        });
        //mode-4
        ptArc3D.buttonClicked.connect(function(){
            setModeEditorHelper(LocalTeach.pentuModes.Arc3DRepeat, ptArc3D.text, qsTr("Set TPos"), qsTr("Set EPos"));
        });
    }
}
