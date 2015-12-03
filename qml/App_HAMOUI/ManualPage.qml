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
                var page =
                        yDefinePage1Class.createObject(
                            pageContainer,
                            {
                                "valves": ["valve0", "valve1", "valve2", "valve3"]
                            });
                pageContainer.addPage(page)
                page =
                        yDefinePage1Class.createObject(
                            pageContainer,
                            {
                                "valves": ["valve0", "valve1", "valve2", "valve3"]
                            });
                pageContainer.addPage(page)
                //                menuItemTexts = ["Y010~27", "Y030~47", "", "", "", "",""]
            }
            var jogClass = Qt.createComponent('JogPage.qml');
            pageContainer.addPage(jogClass.createObject(pageContainer));
            var toolsCalibrationClass = Qt.createComponent('ToolsCalibration.qml');
            pageContainer.addPage(toolsCalibrationClass.createObject(pageContainer));
        }
    }

    AxisPosDisplayBar{
        id:posDisplayBar
    }

    content: manualContainer
    statusSection: posDisplayBar


}
