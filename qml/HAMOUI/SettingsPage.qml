import QtQuick 1.1
import "."
import "../ICCustomElement"
import "Theme.js" as Theme



ContentPageBase{
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
            y:pdata.menuItemY
            z:1
            TabMenuItem{
                id:productSettingsMenuItem
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: pdata.menuItemHeight
                itemText: qsTr("Product Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            }
            TabMenuItem{
                id:machineSettingsMenuItem
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: pdata.menuItemHeight
                itemText: qsTr("Machine Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
//                x:productSettingsMenuItem.x + productSettingsMenuItem.width + 1
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
        }
        Component.onCompleted: {
            var psClass = Qt.createComponent("ProductSettings.qml");
            var psObject = psClass.createObject(pageContainer);
            pageContainer.addPage(psObject);
            pageContainer.setCurrentIndex(0)
            productSettingsMenuItem.setChecked(true);
        }
    }

    onMenuItem7Triggered: {
        pageContainer.currentPage().showMenu();
    }

    content: settingContainer
    //    menu: settingMenu
}
