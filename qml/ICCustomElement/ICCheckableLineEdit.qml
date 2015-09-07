import QtQuick 1.1

Item {
    property alias configName: configName.text
    property alias configAddr: edit.bindConfig
    property alias unit: edit.unit
    property alias configValue: edit.text
    property alias alignMode: edit.alignMode
    property alias configNameWidth: configName.width
    property alias inputWidth: edit.inputWidth
    height: 24
    width: container.width
    function isChecked(){
        return configName.isChecked;
    }

    Row{
        id:container
        spacing: 2
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
