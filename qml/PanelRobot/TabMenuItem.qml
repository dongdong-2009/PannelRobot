import QtQuick 1.1
import "Theme.js" as Theme

Rectangle {
    property alias itemText: text.text
    property bool isChecked: false
    signal itemTriggered()


    function setChecked(isCheck){
        this.isChecked = isCheck;
    }

    function getChecked(){
        return this.isChecked;
    }

    color: getChecked() ? Theme.defaultTheme.TabMenuItem.checkedColor : Theme.defaultTheme.TabMenuItem.unCheckedColor;

    Text {
        id: text
        text: qsTr("TabItem")
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {itemTriggered(); setChecked(true);}
    }
}
