import QtQuick 1.1
import "Theme.js" as Theme
import "."


Rectangle {
    color:Theme.defaultTheme.BASE_BG
    property int menuItemWidth: width * Theme.defaultTheme.TopHeader.menuItemWidthProportion
    property int menuItemHeight: height * Theme.defaultTheme.TopHeader.menuItemHeightProportion
    property alias modeText: modeText
    property int mode: 0

//    signal calculatorItemTriggered()
    signal ioItemTriggered()
    signal systemItemTriggered()
//    signal lan

    Image {
        id: modeImg
        source: "images/modeSetting.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
    }
    Rectangle{
        id: modeTextContainer
        width: parent.width *0.25
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: modeImg.right
        anchors.leftMargin: parent.width * 0.01

        Image {
            id: modeBG
            source: "images/modeTextBG_Red.png"
            anchors.centerIn: parent
        }

        Text {
            id: modeText
            text: qsTr("text")
            anchors.centerIn: parent
        }
    }

    Row{
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01

        TopMenuItem{
            id: calculator
            width: menuItemWidth
            height: menuItemHeight
            itemText: qsTr("Calculator")
        }
        TopMenuItem{
            id: io
            width: menuItemWidth
            height:  menuItemHeight
            itemText: qsTr("I/O")
            onItemTriggered: ioItemTriggered()

        }
        TopMenuItem{
            id: language
            width: menuItemWidth
            height:  menuItemHeight
            itemText: qsTr("Language")
        }
        TopMenuItem{
            id: system
            width: menuItemWidth
            height:  menuItemHeight
            itemText: qsTr("System")
            onItemTriggered: systemItemTriggered()
        }
        TopMenuItem{
            id: manual
            width: menuItemWidth
            height:  menuItemHeight
            itemText: qsTr("Manual")
        }
    }
}
