import QtQuick 1.1
import "."
import "../"
import "../../ICCustomElement"
import "../Theme.js" as Theme
import "../configs/Keymap.js" as Keymap
import "../ShareData.js" as ShareData
import "../opt/optconfigs.js" as OptConfigs


ContentPageBase{
    id:programPageInstance
    //    property int mode: ShareData.GlobalStatusCenter.getKnobStatus()
    //    property bool isReadOnly: true
    //    menuItemTexts:{
    //        return isReadOnly ? ["", "", "", "", "", "",""]:
    //        [qsTr("Editor S/H"), qsTr("Insert"), qsTr("Delete"), qsTr("Up"), qsTr("Down"), "",qsTr("Save")];
    //    }

    function setMenuItemTexts(isReadOnly){
        menuItemTexts =  isReadOnly ? ["", "", "", "", "", "",""]:
                                      [qsTr("Editor S/H"), qsTr("Insert"), qsTr("Delete"), qsTr("Up"), qsTr("Down"), qsTr("Fix Index"),qsTr("Save")];
    }

    function onUserChanged(user){
        var isReadOnly = ( (ShareData.GlobalStatusCenter.getKnobStatus() === Keymap.KNOB_AUTO) || !ShareData.UserInfo.currentHasMoldPerm());
        setMenuItemTexts(isReadOnly);
    }

    function onKnobChanged(knobStatus){
        onUserChanged();
    }

    Rectangle{
        id:programContainer
        anchors.fill: parent
        color: Theme.defaultTheme.BASE_BG

        ICButton{
            id:swichBtn
            text: qsTr("Adv")
            width: 40
            z:10
            visible: false
            onButtonClicked: {
                var pi =  pageContainer.currentIndex + 1;
                pi %= 2;
                pageContainer.setCurrentIndex(pi);
                if(pi == 0)
                    text = qsTr("Sp");
                else
                    text = qsTr("Adv");
            }
        }

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
            if(OptConfigs.simpleProgram !== ""){
                programFlowClass = Qt.createComponent(OptConfigs.simpleProgram);
                if (programFlowClass.status == Component.Ready){
                    page = programFlowClass.createObject(pageContainer)
                    pageContainer.addPage(page);
                    swichBtn.visible = true;
                    pageContainer.setCurrentIndex(1);
                }
            }
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
    onMenuItem6Triggered: {
        pageContainer.currentPage().onFixIndexTriggered();
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
        ShareData.GlobalStatusCenter.registeKnobChangedEvent(programPageInstance);
        swichBtn.anchors.top = programContainer.top;
        swichBtn.anchors.right = programContainer.right;
        swichBtn.anchors.rightMargin = 50;

    }


}
