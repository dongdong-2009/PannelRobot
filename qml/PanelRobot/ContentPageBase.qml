import QtQuick 1.1
import "Theme.js" as Theme

Rectangle {
    //    property function load(){}
    property alias content:contentContainer.children
//    property alias menu: menuContainer.children
    property variant menuItemTexts: ["", "", "", "", "", "",""]

    signal menuItem1Triggered();
    signal menuItem2Triggered();
    signal menuItem3Triggered();
    signal menuItem4Triggered();
    signal menuItem5Triggered();
    signal menuItem6Triggered();
    signal menuItem7Triggered();
    Column{
        spacing: 2
        width: parent.width
        height: parent.height
        Rectangle{
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
                text: qsTr("text")
                color: Theme.defaultTheme.Content.tipTextColor
                anchors.centerIn: parent
            }
            //            anchors.top:contentContainer.bottom
        }
        Rectangle{
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
                    onItemTriggered: menuItem1Triggered()
                }
                BottomMenuItem{
                    id:menu2
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[1]
                    onItemTriggered: menuItem2Triggered()
                }
                BottomMenuItem{
                    id:menu3
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[2]
                    onItemTriggered: menuItem3Triggered()
                }
                BottomMenuItem{
                    id:menu4
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[3]
                    onItemTriggered: menuItem4Triggered()
                }
                BottomMenuItem{
                    id:menu5
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[4]
                    onItemTriggered: menuItem5Triggered()
                }
                BottomMenuItem{
                    id:menu6
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[5]
                    onItemTriggered: menuItem6Triggered()
                }
                BottomMenuItem{
                    id:menu7
                    width: menuContainer.width / 7
                    height: parent.height
                    itemText: menuItemTexts[6]
                    onItemTriggered: menuItem7Triggered()
                }
            }
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
