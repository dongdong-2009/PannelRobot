import QtQuick 1.1
import "."
import "../ICCustomElement"
import "Theme.js" as Theme



ContentPageBase{
    Rectangle{
        id:settingContainer
        anchors.fill: parent
        color: Theme.defaultTheme.BASE_BG
        Row{
            id:menuContainer
            width: parent.width
            height: 32
            y: 2
            TabMenuItem{
                id:productSettingsMenuItem
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: parent.height
                itemText: qsTr("Product Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor

            }
            TabMenuItem{
                id:machineSettingsMenuItem
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: parent.height
                itemText: qsTr("Machine Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor

            }
        }
        ICStackContainer{
            id:pageContainer
            anchors.top: menuContainer.bottom
        }
        Component.onCompleted: {
            var psClass = Qt.createComponent("ProductSettings.qml");
            var psObject = psClass.createObject(pageContainer);
            pageContainer.addPage(psObject);
            pageContainer.setCurrentIndex(0)
        }
    }

    content: settingContainer
//    menu: settingMenu
}
