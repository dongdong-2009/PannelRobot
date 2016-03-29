import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../ExternalData.js" as ESData

Item {
    id:container

    function createActionObjects(){
        var ret = [];
        if(dataSource.configValue < 0) return ret;
        if(catchEn.isChecked){
            if(catchType.currentIndex == 1){
                ret.push(Teach.generateVisionCatchAction(-1, -1, false, 0, dataSource.configText()));
            }else{
                var valveInfo = oPointSel.getValveInfo();
                if(valveInfo == null)
                    return ret;
                ret.push(Teach.generateVisionCatchAction(valveInfo.hwPoint, valveInfo.type,
                                                         (onOffGroup.checkedIndex == 0 ? true:false),
                                                         actionTime.configValue,
                                                         dataSource.configText()));
            }
        }else if(waitDataEn.isChecked){
            ret.push(Teach.generateWaitVisionDataAction(waitTime.configValue, dataSource.configText()));
        }

        return ret;
    }
    ICButtonGroup{
        id:buttonGroup
        isAutoSize: false
        layoutMode: 2
    }

    Column{
        y:6
        spacing: 6
        ICComboBoxConfigEdit{
            id:dataSource
            configName: qsTr("Data Source")
            inputWidth: 500
            z:100
        }

        Row{
            spacing: 10
            ICCheckBox{
                id:catchEn
                text: qsTr("Catch")
            }
            ICComboBox{
                id:catchType
                items: [qsTr("O Point"), qsTr("Communicate")]
                currentIndex: 0
                visible: catchEn.isChecked
                width: 180
            }
            ICButtonGroup{
                id:onOffGroup
                isAutoSize: true
                mustChecked: true
                spacing: 20
                checkedIndex: 0
                ICCheckBox{
                    id:onStatus
                    text: qsTr("On")
                    isChecked: true
                }
                ICCheckBox{
                    id:offStatus
                    text: qsTr("Off")
                }
                visible: catchEn.isChecked && catchType.currentIndex == 0
            }
            ICConfigEdit{
                id:actionTime
                configName: qsTr("Action Time")
                configAddr: "s_rw_0_32_1_1201"
                configValue: "0.0"
                unit: qsTr("s")
                visible: catchEn.isChecked && catchType.currentIndex == 0

            }

            z:11
        }
        ICValveSelectView{
            id:oPointSel
            width: 690
            height: 110
            visible: catchType.currentIndex == 0 && catchEn.isChecked
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

        Column{
            spacing: 10
            z:10
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
                visible: waitDataEn.isChecked
            }
        }
    }
    Component.onCompleted: {
        buttonGroup.addButton(catchEn);
        buttonGroup.addButton(waitDataEn);
        dataSource.items = ESData.externalDataManager.dataSourceNameList();
    }
}
