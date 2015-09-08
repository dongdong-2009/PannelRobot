import QtQuick 1.1

Item {
    property alias configName: configName.text
    property string configAddr:""
//    property alias unit: edit.unit
    property alias configValue: edit.currentIndex
    property alias configText:edit.currentText
//    property alias alignMode: edit.alignMode
    property alias configNameWidth: configName.width
    property alias inputWidth: edit.width
    property alias items: edit.items
    height: 24
    width: container.width
    Row{
        id:container
        spacing: 2
        width: configName.width + edit.width
        height: parent.height
        Text {
            id: configName
            anchors.verticalCenter: parent.verticalCenter
        }
        ICComboBox{
            id: edit
        }
    }
}
