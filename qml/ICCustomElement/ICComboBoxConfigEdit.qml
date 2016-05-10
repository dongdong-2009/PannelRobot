import QtQuick 1.1

Item {
    property alias configName: configName.text
    property string configAddr:""
    property alias configValue: edit.currentIndex

//    property string configText:edit.currentText
    property alias configNameWidth: configName.width
    property alias inputWidth: edit.width
    property alias items: edit.items
    property alias popupMode : edit.popupMode
    property alias popupHeight: edit.popupHeight
    property variant indexMappedValue: []


    function configText(){
        return edit.currentText();
    }

    function text(index) {
        return items[index];
    }

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
