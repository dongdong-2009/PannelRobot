import QtQuick 1.1

Item {
    property alias configName: configName.text
    property string configAddr:""
    property alias configValue: edit.currentIndex
//    property alias configText:edit.currentText
    property alias configNameWidth: configName.width
    property alias inputWidth: edit.width
    property alias items: edit.items
    property alias isChecked:configName.isChecked
    property alias popupMode: edit.popupMode

    function configText(){
        return edit.currentText();
    }

    function setChecked(status){
        configName.isChecked = status;
    }

    height: 24
    width: container.width

    Row{
        id:container
        spacing: 2
        width: configName.width + edit.width
        height: parent.height
        ICCheckBox {
            id: configName
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
        }
        ICComboBox{
            id: edit
            enabled: configName.isChecked
            height: parent.height
        }
    }
}
