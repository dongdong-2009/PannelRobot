import QtQuick 1.1

Item {
    property alias configName: configName.text
    property alias configAddr: edit.bindConfig
    property alias unit: edit.unit
    property alias configValue: edit.text
    property alias alignMode: edit.alignMode
    Row{
        spacing: 2
        Text {
            id: configName
            anchors.verticalCenter: parent.verticalCenter
        }
        ICTextEdit{
            id: edit
        }
    }
}
