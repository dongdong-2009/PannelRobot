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
            width: contentContainerWidth
            height: contentContainerHeight - spliteLine.height - menuContainer.height
        }

    }

    onMenuItem7Triggered: {
        pageContainer.currentPage().showMenu();
    }

    content: settingContainer
    //    menu: settingMenu

    Component.onCompleted: {
        var settingClass = Qt.createComponent("ProductSettings.qml");
        var psObject = settingClass.createObject(pageContainer);
        settingClass = Qt.createComponent("MachineSettings.qml");
        var msObject = settingClass.createObject(pageContainer);
        settingClass = Qt.createComponent("PanelSettings.qml");
        var panelSettingsObject = settingClass.createObject(pageContainer);
        pageContainer.addPage(psObject);
        pageContainer.addPage(msObject);
        pageContainer.addPage(panelSettingsObject);
        pageContainer.setCurrentIndex(0);
        productSettingsMenuItem.setChecked(true);
    }
}
