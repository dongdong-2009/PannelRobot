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
    property alias isChecked:configName.isChecked
    property alias isEditable: configName.isEditable

    function setChecked(status){
        configName.isChecked = status;
    }

    height: 24
    width: container.width


    Row{
        id:container
        spacing: 4
        ICCheckBox {
            id: configName
            anchors.verticalCenter: parent.verticalCenter
        }
        ICLineEdit{
            id: edit
            enabled: configName.isChecked
        }
    }
}
