import QtQuick 1.1

Item {
    property alias configName: configName.text
    property alias configAddr: edit.bindConfig
    property alias unit: edit.unit
    property alias configValue: edit.text
    property alias alignMode: edit.alignMode
    property alias configNameWidth: configName.width
    property alias inputWidth: edit.inputWidth
    property alias isNumberOnly: edit.isNumberOnly
    property alias min: edit.min
    property alias max: edit.max
    property alias decimal: edit.decimal

    signal editFinished();


    height: 24
    width: container.width + container.spacing
    Row{
        id:container
        spacing: 2
        width: configName.width + edit.width
        height: parent.height
        Text {
            id: configName
//            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            height: parent.height
        }
        ICLineEdit{
            id: edit
            height: parent.height
            onEditFinished: editFinished()
        }
    }

}
