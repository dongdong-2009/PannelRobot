import QtQuick 1.1
import '.'
import '../ICCustomElement'
import "Theme.js" as Theme

Rectangle {
    id:mainWindow
    width: Theme.defaultTheme.MainWindow.width
    height: Theme.defaultTheme.MainWindow.height
    TopHeader{
        id:mainHeader
        width: mainWindow.width
        height: mainWindow.height * Theme.defaultTheme.MainWindow.topHeaderHeightProportion
        onSystemItemTriggered: console.log("system clicked")
        onIoItemTriggered: console.log("IO clicked")
    }
    Rectangle{
        id:middleHeader
        width: mainWindow.width
        height: mainWindow.height * Theme.defaultTheme.MainWindow.middleHeaderHeightProportion
        color: Theme.defaultTheme.BASE_BG
        anchors.top: mainHeader.bottom
        Row{
            function buttonToPage(which){
                if(which == menuOperation) {

                    return manualPage;
                }
                else if(which == menuSettings) {

                    return settingPage;
                }
                else return null;
            }
            function onMenuItemTriggered(which){
                var c = middleMenuContainer.children;
                for(var i = 0; i < c.length;++i){
                    if(c[i] == which){
                        var page = buttonToPage(which);
                        if(page == null) continue
                        page.visible = true;
                        continue;
                    }
                    if(c[i].hasOwnProperty("setChecked")){
                        c[i].setChecked(false);
                        var page = buttonToPage(c[i]);
                        if(page == null) continue
                        page.visible = false;
                    }
                }
            }

            id:middleMenuContainer
            spacing: 1
            width: mainWindow.width
            height: mainWindow.height * Theme.defaultTheme.MainWindow.middleHeaderHeightProportion
            TabMenuItem{
                id:menuOperation
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: parent.height
                itemText: qsTr("Operation")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                onItemTriggered: {
                    middleMenuContainer.onMenuItemTriggered(menuOperation)
                }
            }
            TabMenuItem{
                id:menuAuto
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: parent.height
                itemText: qsTr("Auto")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                onItemTriggered: middleMenuContainer.onMenuItemTriggered(menuAuto)

            }
            TabMenuItem{
                id:menuSettings
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: parent.height
                itemText: qsTr("Settings")
                isChecked: true
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                onItemTriggered: {
                    middleMenuContainer.onMenuItemTriggered(menuSettings);
                }

            }
            ICTextEdit{
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderTI1Proportion;
                height: parent.height
                text: "0"
            }
            ICTextEdit{
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderTI2Proportion;
                height: parent.height
                text:qsTr("Sample")
            }
        }
    }

    Rectangle{
        id:container
        width: mainWindow.width
//        height: mainWindow.height * Theme.defaultTheme.MainWindow.containerHeightProportion
        anchors.top: middleHeader.bottom
        anchors.bottom: parent.bottom
        Loader{
            id:settingPage
            source: "SettingsPage.qml"
            anchors.fill: parent
        }
        Loader{
            id:manualPage
            source: "ManualPage.qml"
            anchors.fill: parent
            visible: false
        }
    }
}
