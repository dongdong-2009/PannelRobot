import QtQuick 1.1
import "Theme.js" as Theme

Rectangle {
//    property function load(){}
    property alias content:contentPage.sourceComponent
    property alias menu: menu.sourceComponent
    Rectangle{
        id:contentContainer
        width: parent.width
        height: parent.height * Theme.defaultTheme.Content.settingHeightProportion
        Loader{
            id:contentPage
            anchors.fill: parent
        }
        anchors.top: parent.top
    }
    Rectangle{
        id:tipContainer
        width: parent.width
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
        anchors.top:contentContainer.bottom
    }
    Rectangle{
        id:menuContainer
        width: parent.width
        height: parent.height * Theme.defaultTheme.Content.menuHeightProportion
        Loader{
            id:menu
            anchors.fill: parent
        }
        anchors.bottom: parent.bottom
    }
}
