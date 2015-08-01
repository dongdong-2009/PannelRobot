import QtQuick 1.1
import ".."
import "../../ICCustomElement"
import "../Theme.js" as Theme


Item {
    width: parent.width
    height: parent.height
    ICButtonGroup{
        id:menuContainer
        width: parent.width;
        height: pdata.menuItemHeight
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
                    pageContainer.setCurrentIndex(0);
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
    }
}
