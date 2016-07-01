import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Item {
    width: parent.width
    height: parent.height

    function createActionObjects(){
        var ret = [];
        ret.push(Teach.generateDataAction(targetAddr.configValue,
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
            ICConfigEdit{
                id:targetAddr
                configName: qsTr("Target Addr")
            }
            ICConfigEdit{
                id:data
                configName: qsTr("Data")
            }
        }
    }

}
