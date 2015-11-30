import QtQuick 1.1
import "."
import "../ICCustomElement"
import "./Theme.js" as Theme

ContentPageBase {
    Rectangle {
        id: manualContainer
        color: Theme.defaultTheme.BASE_BG
        width: parent.width
        height: parent.height


        QtObject {
            id: pdata
            property int menuItemHeight: 32
            property int menuItemY: 4
        }

        ICButtonGroup {
            id: menuContainer
            width: parent.width
            height: pdata.menuItemHeight
            isAutoSize: false
            y: pdata.menuItemY
            z: 1
            TabMenuItem {
                id: group1
                width: parent.width
                       * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: pdata.menuItemHeight
                itemText: qsTr("Y010~27")
                color: getChecked(
                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor
            }
            TabMenuItem {
                id: group2
                width: parent.width
                       * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: pdata.menuItemHeight
                itemText: qsTr("Y030~47")
                color: getChecked(
                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor
                //                x:productSettingsMenuItem.x + productSettingsMenuItem.width + 1
            }
            TabMenuItem {
                id: jog
                width: parent.width
                       * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: pdata.menuItemHeight
                itemText: qsTr("Jog")
                color: getChecked(
                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor
                //                x:productSettingsMenuItem.x + productSettingsMenuItem.width + 1
            }
            TabMenuItem {
                id: toolsCalibrate
                width: parent.width
                       * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: pdata.menuItemHeight
                itemText: qsTr("Tools Calibration")
                color: getChecked(
                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor
                //                x:productSettingsMenuItem.x + productSettingsMenuItem.width + 1
            }
            onButtonClickedID: {
                pageContainer.setCurrentIndex(index)
            }
            Component.onCompleted: {
                group1.setChecked(true)
            }
        }

        Rectangle {
            id: spliteLine
            width: parent.width
            height: 1
            color: "black"
            anchors.top: menuContainer.bottom
        }

        ICStackContainer {
            id: pageContainer
            anchors.top: spliteLine.bottom
            width: parent.width
            height: parent.height - menuContainer.height - spliteLine.height
        }
        Component.onCompleted: {
            var yDefinePage1Class = Qt.createComponent('YDefinePage.qml')
            if (yDefinePage1Class.status === Component.Ready) {
                var page = yDefinePage1Class.createObject(pageContainer, {
                                                              ioStart: 0
                                                          })
                pageContainer.addPage(page)
                page = yDefinePage1Class.createObject(pageContainer, {
                                                          ioStart: 16
                                                      })
                pageContainer.addPage(page)
                //                menuItemTexts = ["Y010~27", "Y030~47", "", "", "", "",""]
            }
            var jogClass = Qt.createComponent('JogPage.qml');
            pageContainer.addPage(jogClass.createObject(pageContainer));
            var toolsCalibrationClass = Qt.createComponent('ToolsCalibration.qml');
            pageContainer.addPage(toolsCalibrationClass.createObject(pageContainer));
        }
    }

    //    ICStackContainer{
    //        id:manualContainer
    //        anchors.fill: parent
    //        Component.onCompleted:{
    //            var yDefinePage1Class = Qt.createComponent('YDefinePage1.qml');
    //            if (yDefinePage1Class.status == Component.Ready){
    //                var page = yDefinePage1Class.createObject(manualContainer, {"ioStart":0})
    //                addPage(page)
    //                page = yDefinePage1Class.createObject(manualContainer, {"ioStart":16})
    //                addPage(page)
    //                menuItemTexts = ["Y010~27", "Y030~47", "", "", "", "",""]
    //            }
    //            manualContainer.setCurrentIndex(0)
    //        }
    //    }
    content: manualContainer

    //    onMenuItem1Triggered: manualContainer.setCurrentIndex(0)
    //    onMenuItem2Triggered: manualContainer.setCurrentIndex(1);
    //    menu: manualMenu
}
