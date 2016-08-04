import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Item {
    width: parent.width
    height: parent.height

    function createActionObjects(){
        var ret = [];
        ret.push(Teach.generateDataAction(addrtarget.addr(),
                                          constData.isChecked ? 0 : 1,
                                          constData.isChecked ? data.configValue:addrEdit.addr(),
                                                                opContainer.checkedIndex));
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

        ICHCAddrEdit{
            id:addrtarget
            configName: qsTr("Addr Target:")
        }


        ICConfigEdit{
            id:data
            visible:constData.isChecked? true:false
            configName: qsTr("Data:")
            inputWidth: 120
            configValue: "0"
        }

        ICHCAddrEdit{
            id:addrEdit
            visible:constData.isChecked? false:true
            configName: qsTr("Addr Data:")
        }

        ICButtonGroup{
            id:opContainer
            spacing: 12
            mustChecked: true
            checkedIndex: 0
            ICCheckBox{
                id:opEqual
                text: qsTr("=")
                isChecked: true
            }
            ICCheckBox{
                id:opAddEqual
                text: qsTr("+=")
            }
            ICCheckBox{
                id:opMinusEqual
                text: qsTr("-=")
            }
            ICCheckBox{
                id:opMulEqual
                text: qsTr("x=")
            }
            ICCheckBox{
                id:opDivEqual
                text:qsTr("÷=")
            }
        }
    }
}
