import QtQuick 1.1
import "."
import "../ICCustomElement"
import "./Theme.js" as Theme
import "ShareData.js" as ShareData

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

        function onUserChanged(user){
            jog.visible = ShareData.UserInfo.currentSZHCPerm();
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
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"
            }

//            TabMenuItem {
//                id: toolsCalibrate
//                width: 80
//                height: pdata.menuItemHeight
//                itemText: qsTr("Tools Calibration")
//                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
//                textFont.pixelSize: getChecked() ? 18 : 16
//                textColor: getChecked() ? "yellow" : "black"
//            }
            TabMenuItem{
                id:programmableBtn
                width: 100
                height: pdata.menuItemHeight
                itemText: qsTr("Custom Btn")
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"

            }
//            TabMenuItem{
//                id:toolsCoordBtn
//                width: 100
//                height: pdata.menuItemHeight
//                itemText: qsTr("toolcoord")
//                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
//                textFont.pixelSize: getChecked() ? 18 : 16
//                textColor: getChecked() ? "yellow" : "black"

//            }
            TabMenuItem {
                id: debugprint
                width: 80
                height: pdata.menuItemHeight
                itemText: qsTr("Debugprint")
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"
                
            }
            TabMenuItem {
                id: jog
                width: 50
                height: pdata.menuItemHeight
                itemText: qsTr("Debug")
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"
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
                                "valves": [
                                    "valve0",
                                    "valve1",
                                    "valve2",
                                    "valve3",
                                    "valve4",
                                    "valve5",
                                    "valve6",
//                                    "valve7",
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
                                    "valve27",
                                    "valve28",
                                    "valve29",
                                    "valve30",
                                    "valve31",
                                    "valve32",
                                    "valve33",
                                    "valve34",
                                    "valve35",
                                    "valve36",
                                    "valve37",
                                    "valve38",
                                    "valve39",
                                    "valve40",
                                    "valve41",
                                    "valve42",
                                    "valve43",
                                    "valve44",
                                    "valve45",
                                    "valve46",
                                    "valve47",
                                    "valve48",
                                    "valve49",
                                    "valve50",
                                    "valve51",
                                    "valve52",
                                    "valve53",
                                    "valve54",
                                    "valve55",
                                    "valve56",
                                    "valve57",
                                    "valve58",
                                    "valve59",
                                    "valve60",
                                    "valve61",
                                    "valve62",
                                    "valve63",

                                    "valve64",
                                    "valve65",
                                    "valve66",
                                    "valve67",
                                    "valve68",
                                    "valve69",
                                    "valve70",
                                    "valve71",
                                    "valve72",
                                    "valve73",
                                    "valve74",
                                    "valve75",
                                    "valve76",
                                    "valve77",
                                    "valve78",
                                    "valve79",
                                    "valve80",
                                    "valve81",
                                    "valve82",
                                    "valve83",
                                    "valve84",
                                    "valve85",
                                    "valve86",
                                    "valve87",
                                    "valve88",
                                    "valve89",
                                    "valve90",
                                    "valve91",
                                    "valve92",
                                    "valve93",
                                    "valve94",
                                    "valve95",

                                    "valve96",
                                    "valve97",
                                    "valve98",
                                    "valve99",
                                    "valve100",
                                    "valve101",
                                    "valve102",
                                    "valve103",
                                    "valve104",
                                    "valve105",
                                    "valve106",
                                    "valve107",
                                    "valve108",
                                    "valve109",
                                    "valve110",
                                    "valve111",
                                    "valve112",
                                    "valve113",
                                    "valve114",
                                    "valve115",
                                    "valve116",
                                    "valve117",
                                    "valve118",
                                    "valve119",
                                    "valve120",
                                    "valve121",
                                    "valve122",
                                    "valve123",
                                    "valve124",
                                    "valve125",
                                    "valve126",
                                    "valve127"
                                ]
                            });
                pageContainer.addPage(page)
            }
//            var toolsCalibrationClass = Qt.createComponent('ToolsCalibration.qml');
//            pageContainer.addPage(toolsCalibrationClass.createObject(pageContainer));

            var programmableButtonClass = Qt.createComponent('ProgrammableButton.qml');
            pageContainer.addPage(programmableButtonClass.createObject(pageContainer));

//            var toolCoord = Qt.createComponent('ToolCoordPage.qml');
//            pageContainer.addPage(toolCoord.createObject(pageContainer));
            var debugprintClass = Qt.createComponent('Debugprint.qml');
            pageContainer.addPage(debugprintClass.createObject(pageContainer));
            var jogClass = Qt.createComponent('DebugPage.qml');
            pageContainer.addPage(jogClass.createObject(pageContainer));



            ShareData.UserInfo.registUserChangeEvent(manualContainer);
            onUserChanged(ShareData.UserInfo.current);

        }
    }

    AxisPosDisplayBar{
        id:posDisplayBar
    }

    content: manualContainer
    statusSection: posDisplayBar


    Component.onCompleted: {
        posDisplayBar.setJogPosVisible(false);
    }
}
