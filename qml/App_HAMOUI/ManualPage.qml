import QtQuick 1.1
import "."
import "../ICCustomElement"
import "./Theme.js" as Theme
import "ShareData.js" as ShareData
import "configs/IOConfigs.js" as IOConfis

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
            TabMenuItem {
                id: introduce
                width: 80
                height: pdata.menuItemHeight
                itemText: qsTr("Machine Introduce")
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"
            }
            TabMenuItem {
                id: group1
                width: 80
                height: pdata.menuItemHeight
                itemText: qsTr("Output Y")
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"
            }

            TabMenuItem {
                id: toolsCalibrate
                width: 80
                height: pdata.menuItemHeight
                itemText: qsTr("Tools Calibration")
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"
            }
            TabMenuItem{
                id:programmableBtn
                width: 100
                height: pdata.menuItemHeight
                itemText: qsTr("Custom Btn")
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"

            }
            TabMenuItem{
                id:toolsCoordBtn
                width: 100
                height: pdata.menuItemHeight
                itemText: qsTr("toolcoord")
                color: getChecked() ? "blue" :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                textFont.pixelSize: getChecked() ? 18 : 16
                textColor: getChecked() ? "yellow" : "black"

            }
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
                introduce.setChecked(true)
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
            var machineIntroduce = Qt.createComponent('MachineIntroduce.qml');
            pageContainer.addPage(machineIntroduce.createObject(pageContainer));

            var yDefinePage1Class = Qt.createComponent('YDefinePage.qml')
            if (yDefinePage1Class.status === Component.Ready) {
                var page =
                        yDefinePage1Class.createObject(
                            pageContainer,
                            {
                                "valves": IOConfis.manualShowValves
                            });
                pageContainer.addPage(page)
            }
            var toolsCalibrationClass = Qt.createComponent('ToolsCalibration.qml');
            pageContainer.addPage(toolsCalibrationClass.createObject(pageContainer));

            var programmableButtonClass = Qt.createComponent('ProgrammableButton.qml');
            pageContainer.addPage(programmableButtonClass.createObject(pageContainer));

            var toolCoord = Qt.createComponent('ToolCoordPage.qml');
            pageContainer.addPage(toolCoord.createObject(pageContainer));
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
        onVisibleChanged: {
            if(visible)
                setCurrentState(ShareData.barStatus);
        }
    }

    content: manualContainer
    statusSection: posDisplayBar


}
