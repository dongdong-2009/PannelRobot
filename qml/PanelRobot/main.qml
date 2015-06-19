import QtQuick 1.1
import '.'
import '../ICCustomElement'
import "Theme.js" as Theme
import "configs/Keymap.js" as Keymap

Rectangle {
    id:mainWindow
    width: Theme.defaultTheme.MainWindow.width
    height: Theme.defaultTheme.MainWindow.height
    TopHeader{
        id:mainHeader
        width: mainWindow.width
        height: mainWindow.height * Theme.defaultTheme.MainWindow.topHeaderHeightProportion
        onSystemItemTriggered: console.log("system clicked")
        onIoItemTriggered: ioPage.visible = !ioPage.visible
    }
    Rectangle{
        id:middleHeader
        width: mainWindow.width
        height: mainWindow.height * Theme.defaultTheme.MainWindow.middleHeaderHeightProportion
        color: Theme.defaultTheme.BASE_BG
        anchors.top: mainHeader.bottom
//        z:1
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
            var c = menuContainer.children;
            for(var i = 0; i < c.length;++i){
                if(c[i] == which){
                    var page = buttonToPage(which);
                    if(page == null) continue
                    page.visible = true;
                    page.focus = true;
                    continue;
                }
                if(c[i].hasOwnProperty("setChecked")){
//                    c[i].setChecked(false);
                    var page = buttonToPage(c[i]);
                    if(page == null) continue
                    page.visible = false;
                    page.focus = false;

                }
            }
        }
        ICButtonGroup{
            id:menuContainer
            width: parent.width
            height: parent.height
            TabMenuItem{
                id:menuOperation
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: parent.height
                itemText: qsTr("Operation")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor

            }
            TabMenuItem{
                id:menuAuto
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: parent.height
                itemText: qsTr("Auto")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor

            }
            TabMenuItem{
                id:menuSettings
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion
                height: parent.height
                itemText: qsTr("Settings")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            }
            onButtonClickedItem: {
                middleHeader.onMenuItemTriggered(item);
            }

        }
//        ICTextEdit{
//            width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderTI1Proportion;
//            height: parent.height
//            text: "0"
//            focus: false
//        }
//        ICTextEdit{
//            width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderTI2Proportion;
//            height: parent.height
//            text:qsTr("Sample")
//            focus: false
//            anchors.left:
//        }

    }

    Rectangle{
        id:container
        width: mainWindow.width
        //        height: mainWindow.height * Theme.defaultTheme.MainWindow.containerHeightProportion
        anchors.top: middleHeader.bottom
        anchors.bottom: parent.bottom
        //        anchors.topMargin: 1
        focus: true
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
    IOPage{
        id:ioPage
        width: parent.width
        height: container.height - 78
        visible: false
        anchors.top: container.top
    }

    Component.onCompleted: {
        menuSettings.setChecked(true);
        console.log("main load finished!")
    }
    focus: true
    Keys.onPressed: {
        var key = event.key;
        console.log("Main key press exec", key);
        if(Keymap.isAxisKeyType(key)){
            Keymap.setKeyPressed(key, true);
        }
        else if(Keymap.isCommandKeyType(key)){
            panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(key));
        }

    }
    Keys.onReleased: {
        console.log("Main key release exec");
        var key = event.key;
        if(Keymap.isAxisKeyType(key)){
            Keymap.setKeyPressed(key, false);
        }
    }

    Timer{
        id:refreshTimer
        interval: 50; running: true; repeat: true
        onTriggered: {
            var pressedKeys = Keymap.pressedKeys();
            for(var i = 0 ; i < pressedKeys.length; ++i){
                console.log("Send command");
                panelRobotController.sendKeyCommandToHost(Keymap.getKeyMappedAction(pressedKeys[i]));
            }
        }
    }
}
