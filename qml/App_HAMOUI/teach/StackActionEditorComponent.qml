import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine
import "../teach/Teach.js" as Teach

Item {
    id:container
    width: content.width
    height: content.height
    property alias motor0: motor0.configValue
    property alias motor1: motor1.configValue
    property alias motor2: motor2.configValue
    property alias motor3: motor3.configValue
    property alias motor4: motor4.configValue
    property alias motor5: motor5.configValue

    property alias space0: space0.configValue
    property alias space1: space1.configValue
    property alias space2: space2.configValue

    property alias count0: count0.configValue
    property alias count1: count1.configValue
    property alias count2: count2.configValue

    property alias seq: seq.configValue
    property alias dir0: dir0.configValue
    property alias dir1: dir1.configValue
    property alias dir2: dir2.configValue

    property bool  doesBindingCounter: false

    property alias isOffsetEn: offsetEn.isChecked
    property alias offsetX: x_offset.configValue
    property alias offsetY: y_offset.configValue
    property alias offsetZ: z_offset.configValue
    property variant dataSource: []

    property bool isCustomDataSource: dataSourceSel.configValue == 0

    property string dataSourceName: dataSourceSel.configText()

    function realDoesBindingCounter(){

        return counterSel.configValue != 0;
    }

    function setDataSourceName(dsName){
        var items = dataSourceSel.items;
        for(var i = 0; i < items.length; ++i){
            if(items[i] == dsName){
                dataSourceSel.configValue = i;
                return;
            }
        }
        dataSourceSel.configValue = -1;
    }


    property int mode: 0
    function counterID() {
        var counterStr = counterSel.configText();
        var begin = counterStr.indexOf('[') + 1;
        var end = counterStr.indexOf(']');
        return parseInt(counterStr.slice(begin,end));
    }

    function setCounterID(id){
        if(doesBindingCounter){
            var toSearch = "[" + id +"]";
            var items = counterSel.items;
            for(var i = 0; i < items.length; ++i){
                if(items[i].indexOf(toSearch) >=0 ){
                    counterSel.configValue = i;
                    return i;
                }
            }
        }
        counterSel.configValue = 0;
        return 0;
    }

    ICCheckBox{
        id:offsetEn
        text: qsTr("Offset En")
        x:200
        y:-32
        visible: mode != 2
    }

    Column{
        id:content
        spacing: 4
        property int posWidth: 80
        property int spaceWidth: 70
        property int counteWidth: 60
        Column{
            id:dataSourceContainer
            spacing: 6
            z:101
            visible: mode == 2
            ICComboBoxConfigEdit{
                id:dataSourceSel
                configName: qsTr("Data Source")
                inputWidth: 500
                items: dataSource
                z:101
            }
        }
        Row{
            spacing: 4
            visible: !dataSourceSel.visible
            Grid{
                visible: mode == 0
                //                id:posContainer
                columns: 2
                rows: 3
                spacing: 4
                flow: Grid.TopToBottom
                ICConfigEdit{
                    id:motor0
                    configName: AxisDefine.axisInfos[0].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                }
                ICConfigEdit{
                    id:motor1
                    configName: AxisDefine.axisInfos[1].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth

                }
                ICConfigEdit{
                    id:motor2
                    configName: AxisDefine.axisInfos[2].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth

                }
                ICConfigEdit{
                    id:motor3
                    configName: AxisDefine.axisInfos[3].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth

                }
                ICConfigEdit{
                    id:motor4
                    configName: AxisDefine.axisInfos[4].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth

                }
                ICConfigEdit{
                    id:motor5
                    configName: AxisDefine.axisInfos[5].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                }

            }

            Column{
                id:offsetPosContainer
                spacing: 4
                visible: offsetEn.isChecked
                ICConfigEdit{
                    id:x_offset
                    configName:qsTr("X Offset")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth

                }
                ICConfigEdit{
                    id:y_offset
                    configName:qsTr("Y Offset")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth

                }
                ICConfigEdit{
                    id:z_offset
                    configName:qsTr("Z Offset")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth

                }
            }

            Grid{
                columns: 2
                spacing: 4
                ICConfigEdit{
                    id:space0
                    configName: qsTr("Space0")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.spaceWidth
                }
                ICConfigEdit{
                    id:count0
                    configName: qsTr("Count0")
                    configAddr: "s_rw_0_32_0_1400"
                    inputWidth: content.counteWidth
                }
                ICConfigEdit{
                    id:space1
                    configName: qsTr("Space1")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.spaceWidth
                }
                ICConfigEdit{
                    id:count1
                    configName: qsTr("Count1")
                    configAddr: "s_rw_0_32_0_1400"
                    inputWidth: content.counteWidth
                }
                ICConfigEdit{
                    id:space2
                    configName: qsTr("Space2")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.spaceWidth
                    //                    visible: mode == 0

                }
                ICConfigEdit{
                    id:count2
                    configName: qsTr("Count2")
                    configAddr: "s_rw_0_32_0_1400"
                    inputWidth: content.counteWidth
                    //                    visible: mode == 0
                }
            }
        }

        Row{
            z:10
            spacing: 4
            visible: !dataSourceSel.visible
            ICComboBoxConfigEdit{
                id:dir0
                configName: qsTr("Dir0")
                items: [qsTr("RP"), qsTr("PP")]
                popupMode: 1
                configValue: 0

            }
            ICComboBoxConfigEdit{
                id:dir1
                configName: qsTr("Dir1")
                items: [qsTr("RP"), qsTr("PP")]
                popupMode: 1
                configValue: 0
            }
            ICComboBoxConfigEdit{
                id:dir2
                configName: qsTr("Dir2")
                items: [qsTr("RP"), qsTr("PP")]
                popupMode: 1
                configValue: 0
            }
            ICComboBoxConfigEdit{
                id:seq
                //            y: 112
                //            x:404
                configName: qsTr("Sequence")
                items: ["X->Y->Z","X->Z->Y", "Y->X->Z","Y->Z->X", "Z->X->Y", "Z->Y->X"]
                popupMode: 1
                z:13
                configValue: 0
            }
        }

        ICComboBoxConfigEdit{
            id:counterSel
            popupMode: dataSourceSel.visible ? 0 : 1
            configName: qsTr("Counter")
            inputWidth: 300
            popupHeight: 150
            z:100
        }
    }

    function updateCounters(){
        var countersStrList = Teach.counterManager.countersStrList();
        countersStrList.splice(0, 0, qsTr("Self"));
        counterSel.items = countersStrList;
    }

    onVisibleChanged: {
        if(visible)
            updateCounters();
    }
    onDataSourceChanged: {
        var items = dataSource;
        items.splice(0,0, qsTr("Custom Pos"));
        dataSourceSel.items = items;
        dataSourceSel.configValue = 0;
    }

    Component.onCompleted: {
        updateCounters();
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }
    function onAxisDefinesChanged(){
        motor0.visible = AxisDefine.axisInfos[0].visiable;
        motor1.visible = AxisDefine.axisInfos[1].visiable;
        motor2.visible = AxisDefine.axisInfos[2].visiable;
        motor3.visible = AxisDefine.axisInfos[3].visiable;
        motor4.visible = AxisDefine.axisInfos[4].visiable;
        motor5.visible = AxisDefine.axisInfos[5].visiable;

    }
}
