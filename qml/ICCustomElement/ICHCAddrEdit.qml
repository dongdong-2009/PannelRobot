import QtQuick 1.1

Item {
    id:instance
    property alias configName: addr_edit.text
    property alias configNameWidth: addr_edit.width

    property alias startPos_configValue: edit_startPos_.text
    property alias size_configValue: edit_size_.text
    property alias baseAddr_configValue: edit_baseAddr_.text
    property alias decimal_configValue: edit_decimal_.text

    property int configValue: 0
    property int mode: 1

    function addr(){
        return (parseInt(startPos_configValue)<<5) | (parseInt(size_configValue)<<10) | (parseInt(baseAddr_configValue)<<16) | (parseInt(decimal_configValue)<<30) ;
    }

    onConfigValueChanged: {
        baseAddr_configValue = (configValue >> 16) & 0x3FFF;
    }

    height: 24
    width:mode == 1 ? container.width : addr_edit.width + edit_baseAddr_.width
    Row{
        id:container
        spacing: 5
        width: addr_edit.width +startPos_.width + edit_startPos_.width + edit_size_.width +edit_baseAddr_.width +edit_decimal_.width + size_.width + baseAddr_.width + decimal_.width
        height: parent.height
        Text {
            id: addr_edit
            verticalAlignment: Text.AlignVCenter
            height: parent.height
        }
        Text {
            id: startPos_
            text:qsTr("startPos")
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            visible: mode == 1

        }
        ICLineEdit{
            id: edit_startPos_
            height: parent.height
            text:"0"
            inputWidth:80
            min:0
            max:32-1
            visible: mode == 1
            onTextChanged: instance.configValue = instance.addr();
         }
        Text {
            id: size_
            text:qsTr("size")
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            visible: mode == 1
        }
        ICLineEdit{
            id: edit_size_
            height: parent.height
            text:"32"
            inputWidth:80
            min:0
            max:64-1
            visible: mode == 1
            onTextChanged: instance.configValue = instance.addr();
         }
        Text {
            id: baseAddr_
            text:qsTr("baseAddr")
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            visible: mode == 1
        }
        ICLineEdit{
            id: edit_baseAddr_
            height: parent.height
            text:("1")
            inputWidth:80
            min:0
            max:16*1024-1
            onTextChanged: instance.configValue = instance.addr();
         }
        Text {
            id: decimal_
            text:qsTr("decimal")
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            visible: mode == 1
        }
        ICLineEdit{
            id: edit_decimal_
            height: parent.height
            text:("0")
            inputWidth:80
            min:0
            max:4-1
            visible: mode == 1
            onTextChanged: instance.configValue = instance.addr();
         }
    }
}


