import QtQuick 1.1
import "Theme.js" as Theme

Rectangle {
    property alias itemText: text.text
    property bool isChecked: false
    id:container
    color:isChecked ? "yellow" : Theme.defaultTheme.TopHeader.menuItemBG
    function setChecked(checked){
        isChecked = checked;
    }

    Text {
        id: text
        width: container.width
        text: qsTr("item")
        wrapMode: Text.Wrap
//        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 2
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            setChecked(!isChecked)
        }

    }
}
