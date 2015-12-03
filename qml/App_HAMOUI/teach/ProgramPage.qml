import QtQuick 1.1
import "."
import "../"
import "../../ICCustomElement"
import "../Theme.js" as Theme
import "../configs/Keymap.js" as Keymap
import "../ShareData.js" as ShareData


ContentPageBase{
    id:programPageInstance
    property int mode: ShareData.GlobalStatusCenter.getKnobStatus()
    property bool isReadOnly: true
    menuItemTexts:{
        return isReadOnly ? ["", "", "", "", "", "",""]:
        [qsTr("Editor S/H"), qsTr("Insert"), qsTr("Delete"), qsTr("Up"), qsTr("Down"), "",qsTr("Save")];
    }

    function onUserChanged(user){
        isReadOnly = ( (mode === Keymap.KNOB_AUTO) || !ShareData.UserInfo.currentHasMoldPerm());
    }

    Rectangle{
        id:programContainer
        anchors.fill: parent
        color: Theme.defaultTheme.BASE_BG


        QtObject{
            id:pdata
            property int menuItemHeight: 32
            property int menuItemY: 4
        }

        ICStackContainer{
            id:pageContainer
        }
        Component.onCompleted: {
            var programFlowClass = Qt.createComponent('ProgramFlowPage.qml');
            if (programFlowClass.status == Component.Ready){
                var page = programFlowClass.createObject(pageContainer)
                pageContainer.addPage(page);
            }
            pageContainer.setCurrentIndex(0);
        }
    }

    onMenuItem1Triggered: {
        pageContainer.currentPage().showActionEditorPanel();
    }
    onMenuItem2Triggered: {
        pageContainer.currentPage().onInsertTriggered();
    }
    onMenuItem3Triggered: {
        pageContainer.currentPage().onDeleteTriggered();

    }
    onMenuItem4Triggered: {
        pageContainer.currentPage().onUpTriggered();
    }
    onMenuItem5Triggered: {
        pageContainer.currentPage().onDownTriggered();
    }
    onMenuItem7Triggered: {
        pageContainer.currentPage().onSaveTriggered();
    }

//    onMenuItem7Triggered: {
//        pageContainer.currentPage().showMenu();
//    }

    AxisPosDisplayBar{
        id:posDisplayBar
    }

    content: programContainer
    statusSection: posDisplayBar

    Component.onCompleted: {
        ShareData.UserInfo.registUserChangeEvent(programPageInstance);
    }

    Timer{
        id:refreshTimer
        interval: 50
        running: parent.visible
        repeat: true
        onTriggered: {
            if(mode !== ShareData.GlobalStatusCenter.getKnobStatus()){
                mode = ShareData.GlobalStatusCenter.getKnobStatus();
                if(mode === Keymap.KNOB_AUTO)
                    isReadOnly = true;
                else if(ShareData.UserInfo.currentHasMoldPerm())
                    isReadOnly = false;
            }
        }
    }
}
