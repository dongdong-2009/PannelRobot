import QtQuick 1.1
import ".."
import "../../ICCustomElement"
import "../Theme.js" as Theme



ContentPageBase{
    id:container
    menuItemTexts:["", "", "", "", "", "",qsTr("Return")]
    Rectangle{
        id:settingContainer
        anchors.fill: parent
        color: Theme.defaultTheme.BASE_BG


        QtObject{
            id:pdata
            property int menuItemHeight: 32
            property int menuItemY: 4
        }

        ICButtonGroup{
            id:menuContainer
            width: parent.width;
            height: pdata.menuItemHeight
            isAutoSize: false
            y:pdata.menuItemY
            z:1
            TabMenuItem{
                id:productSettingsMenuItem
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: pdata.menuItemHeight
                itemText: qsTr("Product Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                onIsCheckedChanged: {
                    if(isChecked){
                        pageContainer.setCurrentIndex(0)
                    }
                }
            }
            TabMenuItem{
                id:machineSettingsMenuItem
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: pdata.menuItemHeight
                itemText: qsTr("Machine Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                onIsCheckedChanged: {
                    if(isChecked){
                        pageContainer.setCurrentIndex(1)
                    }
                }
            }
            TabMenuItem{
                id:panelSettingsMenuItem
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: pdata.menuItemHeight
                itemText: qsTr("Panel Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                onIsCheckedChanged: {
                    if(isChecked){
                        pageContainer.setCurrentIndex(2)
                    }
                }
            }
        }

        Rectangle{
            id:spliteLine
            width: parent.width
            height: 1
            color: "black"
            anchors.top: menuContainer.bottom
        }

        ICStackContainer{
            id:pageContainer
            anchors.top: spliteLine.bottom
            width: parent.width
            height: settingContainer.parent.contentContainerHeight - spliteLine.height - menuContainer.height
        }

    }

    onMenuItem7Triggered: {
        pageContainer.currentPage().showMenu();
    }
    onVisibleChanged: {
        if(visible){
            pageContainer.currentPage().showMenu();
        }
    }

//    Flow{
//        id:versionContainer
//        width: statusSection.width
//        height: statusSection.height
//        spacing: 10
//        x:10
//        y:10
//        Text {
//            color: "lime"
//            text: qsTr("UI Version:") + "S6-0.1.1" + ";"
//        }
//        Text {
//            color: "lime"

//            text: qsTr("Controller Version:") + panelRobotController.controllerVersion();
//        }
//    }

    content: settingContainer
    statusSection: Text {
        width: container.width
        color: Theme.defaultTheme.Content.tipTextColor
        text: qsTr("Please enter specific settings page settings, /nclick on the bottom right of the Back button to return to the previous menu")
    }
    Component.onCompleted: {
        var settingClass = Qt.createComponent("ProductSettings.qml");
        var psObject = settingClass.createObject(pageContainer,{"width":pageContainer.width,"height": pageContainer.height});
        settingClass = Qt.createComponent("MachineSettings.qml");
        var msObject = settingClass.createObject(pageContainer,{"width":pageContainer.width,"height": pageContainer.height});
        settingClass = Qt.createComponent("PanelSettings.qml");
        var panelSettingsObject = settingClass.createObject(pageContainer,{"width":pageContainer.width,"height": pageContainer.height});
        pageContainer.addPage(psObject);
        pageContainer.addPage(msObject);
        pageContainer.addPage(panelSettingsObject);
        pageContainer.setCurrentIndex(0);
        productSettingsMenuItem.setChecked(true);
    }
}
