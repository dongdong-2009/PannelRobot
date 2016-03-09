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
//            TabMenuItem {
//                id: armMove
//                width: parent.width
//                       * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
//                height: pdata.menuItemHeight
//                itemText: qsTr("Arm Move")
//                color: getChecked(
//                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor
//            }
            TabMenuItem {
                id: group1
                width: 80
                height: pdata.menuItemHeight
                itemText: qsTr("Output Y")
                color: getChecked(
                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor
            }

            TabMenuItem {
                id: toolsCalibrate
                width: 80
                height: pdata.menuItemHeight
                itemText: qsTr("Tools Calibration")
                color: getChecked(
                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor
            }
            TabMenuItem{
                id:programmableBtn
                width: 100
                height: pdata.menuItemHeight
                itemText: qsTr("Custom Btn")
                color: getChecked(
                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor

            }

            TabMenuItem {
                id: jog
                width: 50
                height: pdata.menuItemHeight
                itemText: qsTr("Debug")
                color: getChecked(
                           ) ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor
                //                x:productSettingsMenuItem.x + productSettingsMenuItem.width + 1
            }
            TabMenuItem {
                id: debugprint
                width: 80
                height: pdata.menuItemHeight
                itemText: qsTr("Debugprint")
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
            height: manualContainer.parent.contentContainerHeight - menuContainer.height - spliteLine.height
        }
        Component.onCompleted: {
//            var armMoveClass = Qt.createComponent('ArmMovePage.qml');
//            pageContainer.addPage(armMoveClass.createObject(pageContainer));
            var yDefinePage1Class = Qt.createComponent('YDefinePage.qml')
            if (yDefinePage1Class.status === Component.Ready) {
                var page =
                        yDefinePage1Class.createObject(
                            pageContainer,
                            {
                                "valves": ["valve0", "valve1", "valve2", "valve3",
                                           "valve4",
                                           "valve5",
                                           "valve6",
                                           "valve7",
                                           "valve8",
                                           "valve9",
                                           "valve10",
                                           "valve11",
                                           "valve12",
                                            "valve13",
                                    "valve14",
                                    "valve15",
                                    "valve16",
                                    "valve17",
                                    "valve18",
                                    "valve19",
                                    "valve20",
                                    "valve21",
                                    "valve22",
                                    "valve23",
                                    "valve24",
                                    "valve25",
                                    "valve26",
                                    "valve27"

                                ]
                            });
                pageContainer.addPage(page)
            }
            var toolsCalibrationClass = Qt.createComponent('ToolsCalibration.qml');
            pageContainer.addPage(toolsCalibrationClass.createObject(pageContainer));

            var programmableButtonClass = Qt.createComponent('ProgrammableButton.qml');
            pageContainer.addPage(programmableButtonClass.createObject(pageContainer));

            var jogClass = Qt.createComponent('DebugPage.qml');
            pageContainer.addPage(jogClass.createObject(pageContainer));
            var debugprintClass = Qt.createComponent('Debugprint.qml');
            pageContainer.addPage(debugprintClass.createObject(pageContainer));
        }
    }

    AxisPosDisplayBar{
        id:posDisplayBar
    }

    content: manualContainer
    statusSection: posDisplayBar


}
