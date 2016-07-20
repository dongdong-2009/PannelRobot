import QtQuick 1.1

Item {
    property alias configName: addr_edit.text

    property alias startPos_configValue: edit_startPos_.text
    property alias size_configValue: edit_size_.text
    property alias baseAddr_configValue: edit_baseAddr_.text
    property alias decimal_configValue: edit_decimal_.text

    function addr(){
        return (parseInt(startPos_configValue)<<5) | (parseInt(size_configValue)<<10) | (parseInt(baseAddr_configValue)<<16) | (parseInt(decimal_configValue)<<30) ;
    }

    height: 24
    width:container.spacing
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
        }
        ICLineEdit{
            id: edit_startPos_
            height: parent.height
            text:"0"
            inputWidth:80
            min:0
            max:32-1
         }
        Text {
            id: size_
            text:qsTr("size")
            verticalAlignment: Text.AlignVCenter
            height: parent.height
        }
        ICLineEdit{
            id: edit_size_
            height: parent.height
            text:"32"
            inputWidth:80
            min:0
            max:64-1
         }
        Text {
            id: baseAddr_
            text:qsTr("baseAddr")
            verticalAlignment: Text.AlignVCenter
            height: parent.height
        }
        ICLineEdit{
            id: edit_baseAddr_
            height: parent.height
            text:("1")
            inputWidth:80
            min:0
            max:16*1024-1
         }
        Text {
            id: decimal_
            text:qsTr("decimal")
            verticalAlignment: Text.AlignVCenter
            height: parent.height
        }
        ICLineEdit{
            id: edit_decimal_
            height: parent.height
            text:("0")
            inputWidth:80
            min:0
            max:4-1
         }
    }
}


