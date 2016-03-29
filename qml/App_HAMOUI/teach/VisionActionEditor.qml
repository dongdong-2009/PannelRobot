import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines

Item {
    id:container
    Column{
        Row{
            ICCheckBox{
                id:catchEn
                text: qsTr("Catch")
            }
            ICComboBox{
                id:catchType
                items: [qsTr("O Point"), qsTr("Communicate")]
            }
            z:10
        }
        ICValveSelectView{
            id:oPointSel
            width: 600
            height: 200
            valves: [
                "valve0",
                "valve1",
                "valve2",
                "valve3",
                "valve4",
                "valve5",
                "valve6",
                "valve7",
                "valve8",
                "valve9",
                "valve10",
                "valve11",
                "valve12",
                "valve13",
                "valve14",
                "valve15",
                "valve16",
                "valve17",
                "valve18",
                "valve19",
                "valve20",
                "valve21",
                "valve22",
                "valve23",
            ]
        }

        Row{
            ICCheckBox{
                id:waitDataEn
                text: qsTr("Wait Data")
            }
            ICConfigEdit{
                id:waitTime
                configName: qsTr("Wait Time")
                configAddr: "s_rw_0_32_1_1201"
                configValue: "0.0"
                unit: qsTr("s")
            }
        }
    }
}
