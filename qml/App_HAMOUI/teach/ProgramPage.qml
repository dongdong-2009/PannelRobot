import QtQuick 1.1
import "."
import "../"
import "../../ICCustomElement"
import "../Theme.js" as Theme



ContentPageBase{
    menuItemTexts:[qsTr("Editor S/H"), qsTr("Insert"), qsTr("Delete"), qsTr("Up"), qsTr("Down"), "",qsTr("Save")]
    Rectangle{
        id:programContainer
        anchors.fill: parent
        color: Theme.defaultTheme.BASE_BG


        QtObject{
            id:pdata
            property int menuItemHeight: 32
            property int menuItemY: 4
        }

//        Rectangle{
//            id:spliteLine
//            width: parent.width
//            height: 1
//            color: "black"
//            anchors.top: menuContainer.bottom
//        }

        ICStackContainer{
            id:pageContainer
//            width: parent.width
//            height: parent.height
//            anchors.top: spliteLine.bottom
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

    content: programContainer
    //    menu: settingMenu
}
