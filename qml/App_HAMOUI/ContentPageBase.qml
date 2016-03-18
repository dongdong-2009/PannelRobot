import QtQuick 1.1
import "Theme.js" as Theme
import "configs/Keymap.js" as Keymap

Item {
    //    property function load(){}
    property alias content:contentContainer.children
    property alias statusSection:tipContainer.children
    //    property alias menu: menuContainer.children
    property variant menuItemTexts: ["", "", "", "", "", "",""]
    property  alias contentContainerWidth: contentContainer.width
    property  alias contentContainerHeight: contentContainer.height


//    focus: true

    signal menuItem1Triggered();
    signal menuItem2Triggered();
    signal menuItem3Triggered();
    signal menuItem4Triggered();
    signal menuItem5Triggered();
    signal menuItem6Triggered();
    signal menuItem7Triggered();
    Rectangle{
        width: parent.width
        height: 1
        color: "black"
        anchors.bottom: contentLayout.top
    }
    Column{
        spacing: 2
        width: parent.width
        height: parent.height
        id:contentLayout
        Item{
            id:contentContainer
            width: parent.width
            height: parent.height * Theme.defaultTheme.Content.settingHeightProportion

            //            anchors.top: parent.top
        }
        Rectangle{
            id:tipContainer
            x:1
            width: parent.width - border.width
            height: parent.height * Theme.defaultTheme.Content.tipHeightProportion
            color: Theme.defaultTheme.Content.tipBG
            border.color: Theme.defaultTheme.Content.tipBorderBG
            border.width: Theme.defaultTheme.Content.tipBorderWidth
            Text {
                id: tip
                color: Theme.defaultTheme.Content.tipTextColor
                anchors.centerIn: parent
            }
            //            anchors.top:contentContainer.bottom
        }
        Item{
            id:menuContainer
            width: parent.width
            height: parent.height - contentContainer.height - tipContainer.height
            Row{
                spacing: 2
                width: menuContainer.width
                height: menuContainer.height
                BottomMenuItem{
                    id:menu1
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[0]
                    enabled: itemText.length > 0
                    onItemTriggered: menuItem1Triggered()
                }
                BottomMenuItem{
                    id:menu2
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[1]
                    enabled: itemText.length > 0
                    onItemTriggered: menuItem2Triggered()
                }
                BottomMenuItem{
                    id:menu3
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[2]
                    enabled: itemText.length > 0
                    onItemTriggered: menuItem3Triggered()
                }
                BottomMenuItem{
                    id:menu4
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[3]
                    enabled: itemText.length > 0
                    onItemTriggered: menuItem4Triggered()
                }
                BottomMenuItem{
                    id:menu5
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[4]
                    enabled: itemText.length > 0
                    onItemTriggered: menuItem5Triggered()
                }
                BottomMenuItem{
                    id:menu6
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[5]
                    enabled: itemText.length > 0
                    onItemTriggered: menuItem6Triggered()
                }
                BottomMenuItem{
                    id:menu7
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[6]
                    enabled: itemText.length > 0
                    onItemTriggered: menuItem7Triggered()
                }
            }
//            focus: true
//            Keys.onPressed: {
//                console.log("contentPage base key exec", event.key)
//                if (event.key === Keymap.KEY_F1) {
//                    menuItem1Triggered()
//                    event.accepted = true;
//                }
//                else if (event.key === Keymap.KEY_F2){
//                    menuItem2Triggered()
//                    event.accepted = true;
//                }
//                else if (event.key === Keymap.KEY_F3){
//                    menuItem3Triggered()
//                    event.accepted = true;
//                }
//                else if (event.key === Keymap.KEY_F4){
//                    menuItem4Triggered()
//                    event.accepted = true;
//                }
//                else if (event.key === Keymap.KEY_F5){
//                    menuItem5Triggered()
//                    event.accepted = true;
//                }else{
//                    event.accepted = false;
//                }
//            }
        }
    }
    onMenuItemTextsChanged: {
        menu1.itemText = menuItemTexts[0];
        menu2.itemText = menuItemTexts[1];
        menu3.itemText = menuItemTexts[2];
        menu4.itemText = menuItemTexts[3];
        menu5.itemText = menuItemTexts[4];
        menu6.itemText = menuItemTexts[5];
        menu7.itemText = menuItemTexts[6];

    }

}
