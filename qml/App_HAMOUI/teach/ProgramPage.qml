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
        if(ShareData.GlobalStatusCenter.getKnobStatus() == Keymap.KNOB_AUTO && pageContainer.pages.length > 1 && pageContainer.currentIndex > 0){
            menuItemTexts = ["", "", "", "", "", "",qsTr("C Modify")];
        }
    }

    function onKnobChanged(knobStatus){
        if(knobStatus == Keymap.KNOB_AUTO && pageContainer.pages.length > 1){
            swichBtn.toAdv();
        }
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
            height: 26
            z:10
            visible: false
            function toAdv(){
                text = qsTr("Sp");
                pageContainer.setCurrentIndex(0);
            }

            onButtonClicked: {
                var pi =  pageContainer.currentIndex + 1;
                pi %= 2;
                pageContainer.setCurrentIndex(pi);
                if(pi == 0)
                    text = qsTr("Sp");
                else
                    text = qsTr("Adv");
                onUserChanged();
            }
        }

        QtObject{
            id:pdata
            property int menuItemHeight: 32
            property int menuItemY: 4
        }

        ICStackContainer{
            id:pageContainer
            width: parent.width
            height: parent.height
        }
        Component.onCompleted: {
            var programFlowClass = Qt.createComponent('ProgramFlowPage.qml');
            if (programFlowClass.status == Component.Ready){
                var page = programFlowClass.createObject(pageContainer)
                pageContainer.addPage(page);
            }
            pageContainer.setCurrentIndex(0);
            if(OptConfigs.simpleProgram !== ""){
                programFlowClass = Qt.createComponent("../opt/" + OptConfigs.simpleProgram);
                if (programFlowClass.status == Component.Ready){
                    page = programFlowClass.createObject(pageContainer)
                    pageContainer.addPage(page);
                    swichBtn.visible = true;
                    pageContainer.setCurrentIndex(1);
                }else
                    console.log("opt/teach/page:", programFlowClass.errorString());
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
        if(ShareData.GlobalStatusCenter.getKnobStatus() == Keymap.KNOB_AUTO && pageContainer.currentIndex > 0){
            pageContainer.currentPage().onAutoEditConfirm();
        }else
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
        posDisplayBar.setWorldPosVisible(false);
        swichBtn.anchors.top = programContainer.top;
//        swichBtn.anchors.right = programContainer.right;
//        swichBtn.anchors.rightMargin = 50;
        swichBtn.x = 140;
        swichBtn.anchors.topMargin = -swichBtn.height - 2;
    }
}

