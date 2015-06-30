import QtQuick 1.1
import "."
import "../ICCustomElement"
import "./Theme.js" as Theme

ContentPageBase{
    Rectangle{
        id:manualContainer
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
                id:group1
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: pdata.menuItemHeight
                itemText: qsTr("Y010~27")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
            }
            TabMenuItem{
                id:group2
                width: parent.width * Theme.defaultTheme.MainWindow.middleHeaderMenuItemWidthProportion;
                height: pdata.menuItemHeight
                itemText: qsTr("Y030~47")
                color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor :  Theme.defaultTheme.TabMenuItem.unCheckedColor
                //                x:productSettingsMenuItem.x + productSettingsMenuItem.width + 1
            }
            onButtonClickedID: {
                pageContainer.setCurrentIndex(index);
            }
            Component.onCompleted: {
                group1.setChecked(true);
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
            var yDefinePage1Class = Qt.createComponent('YDefinePage1.qml');
            if (yDefinePage1Class.status == Component.Ready){
                var page = yDefinePage1Class.createObject(pageContainer, {"ioStart":0})
                pageContainer.addPage(page)
                page = yDefinePage1Class.createObject(pageContainer, {"ioStart":16})
                pageContainer.addPage(page)
                //                menuItemTexts = ["Y010~27", "Y030~47", "", "", "", "",""]
            }
//            manualContainer.setCurrentIndex(0)
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
