import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Item {
    width: parent.width
    height: parent.height

    function createActionObjects(){
        var ret = [];
        ret.push(Teach.generateDataAction(addrEdit.addr(),
                                          constData.isChecked ? 0 : 1,
                                                                data.configValue));
        return ret;
    }

    Column{
        spacing: 24
        ICButtonGroup{
            spacing: 24
            mustChecked: true
            checkedIndex: 0
            ICCheckBox{
                id:constData
                text: qsTr("Const Data")
                isChecked: true
            }
            ICCheckBox{
                id:addrData
                text: qsTr("Addr Data")
            }
        }
        Row{
            spacing: 24
            ICConfigEdit{
                id:targetAddr
                configName: qsTr("Target Addr")
                inputWidth: 120
            }
            ICConfigEdit{
                id:data
                configName: qsTr("Data")
                inputWidth: 120
            }
        }
       Row{
         ICHCAddrEdit{
              id:addrEdit
              addr_edit: qsTr("addr:")
              startPos_inputWidth: 80
              size_inputWidth: 80
              baseAddr_inputWidth: 80
              decimal_inputWidth: 80
              }
            }
        }
    }
