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
    property alias seqItems: seq.items
    property alias dir0: dir0.configValue
    property alias dir1: dir1.configValue
    property alias dir2: dir2.configValue

    property bool  doesBindingCounter: false

    property alias isOffsetEn: offsetEn.isChecked
    property alias isZWithYEn: zWithYEn.isChecked
    property alias offsetX: x_offset.configValue
    property alias offsetY: y_offset.configValue
    property alias offsetZ: z_offset.configValue
    property variant dataSource: []
    property alias runSeq:runSeq.configValue

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
    StackThreePointWayEditor{
        id:threePointWayEditor
        width: 680
        height: 180
        z:100
        y:-40
        visible: false
        onEditConfirm: {
            motor0.configValue = data.sp.m0;
            motor1.configValue = data.sp.m1;
            motor2.configValue = data.sp.m2;
            motor3.configValue = data.sp.m3;
            motor4.configValue = data.sp.m4;
            motor5.configValue = data.sp.m5;
            offsetX = data.offset.m0;
            offsetY = data.offset.m1;
            space0.configValue = Math.abs(data.space.m0).toFixed(3);
            space1.configValue = Math.abs(data.space.m1).toFixed(3);
            dir0.configValue = data.space.m0 >= 0 ? 1 : 0;
            dir1.configValue = data.space.m1 >= 0 ? 1 : 0;
            if((offsetX != "0.000") || (offsetY != "0.000"))
                offsetEn.isChecked = true;

        }
    }

    ICCheckBox{
        id:offsetEn
        text: qsTr("Offset En")
        x:200
        y:-32
        visible: mode != 2
    }
    ICCheckBox{
        id:zWithYEn
        anchors.left: offsetEn.right
        anchors.leftMargin: 6
        anchors.top: offsetEn.top
        text: qsTr("Offset Z with Y")
        visible: motor1.visible && motor2.visible && offsetEn.isChecked
    }

    ICButton{
        id:threePointWayBtn
        text:qsTr("Three Point Way")
        anchors.left: zWithYEn.right
        anchors.leftMargin: 32
        anchors.top: zWithYEn.top

        height: offsetEn.height
        width: 150
        visible:offsetEn.visible && motor0.visible && motor1.visible
        onButtonClicked: {
            threePointWayEditor.show({"sp":{"m0":motor0.configValue,
                                             "m1":motor1.configValue,
                                             "m2":motor2.configValue,
                                             "m3":motor3.configValue,
                                             "m4":motor4.configValue,
                                             "m5":motor5.configValue},
                                         "offset":{"m0":x_offset.getConfigValue(), "m1":y_offset.getConfigValue(), "m2":z_offset.getConfigValue()},
                                         "space":{"m0":space0.getConfigValue(), "m1":space1.getConfigValue(), "m2":space2.getConfigValue()}
                                     });
        }
    }

    Column{
        id:content
        spacing: 4
        property int posWidth: 80
        property int spaceWidth: 70
        property int counteWidth: 50
        property int axisNameWidth: 30
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
                    configNameWidth: content.axisNameWidth
                }
                ICConfigEdit{
                    id:motor1
                    configName: AxisDefine.axisInfos[1].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                    configNameWidth: content.axisNameWidth

                }
                ICConfigEdit{
                    id:motor2
                    configName: AxisDefine.axisInfos[2].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                    configNameWidth: content.axisNameWidth

                }
                ICConfigEdit{
                    id:motor3
                    configName: AxisDefine.axisInfos[3].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                    configNameWidth: content.axisNameWidth

                }
                ICConfigEdit{
                    id:motor4
                    configName: AxisDefine.axisInfos[4].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                    configNameWidth: content.axisNameWidth

                }
                ICConfigEdit{
                    id:motor5
                    configName: AxisDefine.axisInfos[5].name
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                    configNameWidth: content.axisNameWidth
                }

            }

            Column{
                id:offsetPosContainer
                property int offsetNameWidth: 50
                spacing: 4
                visible: offsetEn.isChecked
                ICConfigEdit{
                    id:x_offset
                    configName:qsTr("X Offset")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                    configNameWidth: offsetPosContainer.offsetNameWidth

                }
                ICConfigEdit{
                    id:y_offset
                    configName:qsTr("Y Offset")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                    configNameWidth: offsetPosContainer.offsetNameWidth

                }
                ICConfigEdit{
                    id:z_offset
                    configName:qsTr("Z Offset")
                    configAddr: "s_rw_0_32_3_1300"
                    inputWidth: content.posWidth
                    configNameWidth: offsetPosContainer.offsetNameWidth

                }
            }

            Grid{
                columns: 2
                spacing: 4
                ICConfigEdit{
                    id:space0
                    configName: qsTr("Space0")
                    configAddr: "s_rw_0_32_3_1301"
                    inputWidth: content.spaceWidth
                    configNameWidth: 90
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
                    configAddr: "s_rw_0_32_3_1301"
                    inputWidth: content.spaceWidth
                    configNameWidth: space0.configNameWidth
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
                    configAddr: "s_rw_0_32_3_1301"
                    inputWidth: content.spaceWidth
                    configNameWidth: space0.configNameWidth

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

        Item{
            width:600
            height:dir0.height
            z:10
            visible: !dataSourceSel.visible
            ICComboBoxConfigEdit{
                id:dir0
                configName: qsTr("Dir0")
                items: [qsTr("RP"), qsTr("PP")]
                configValue: 0
            }
            ICComboBoxConfigEdit{
                id:dir1
                anchors.left: parent.left
                anchors.leftMargin: dir0.visible?(dir0.width+4):0
                configName: qsTr("Dir1")
                items: [qsTr("RP"), qsTr("PP")]
                configValue: 0
            }
            ICComboBoxConfigEdit{
                id:dir2
                anchors.left: parent.left
                anchors.leftMargin: (dir0.visible?(dir0.width+4):0) +(dir1.visible?(dir1.width+4):0)
                configName: qsTr("Dir2")
                items: [qsTr("RP"), qsTr("PP")]
                configValue: 0
            }
            ICComboBoxConfigEdit{
                id:seq
                anchors.right: parent.right
                configName: qsTr("Sequence")
                items: ["X->Y->Z","X->Z->Y", "Y->X->Z","Y->Z->X", "Z->X->Y", "Z->Y->X", qsTr("Only X"), qsTr("Only Y"), qsTr("Only Z")]
                z:13
                configValue: 0
            }
        }

        Row{
            spacing: 6
            z:100
            id:coutnerContainer
            ICComboBoxConfigEdit{
                id:counterSel
                configName: qsTr("Counter")
                inputWidth: 300
                visible: mode != 1
            }

            ICComboBoxConfigEdit{
                id:runSeq
                configName: qsTr("Run Seq")
                inputWidth: 150
                visible: mode != 1
                items:[qsTr("FinalX"), qsTr("FinalY"), qsTr("FinalZ"), qsTr("Run Together")]
                configValue: 3
            }
        }
    }

    function updateCounters(){
        counterSel.configValue = -1;
        var countersStrList = Teach.currentRecord.counterManager.countersStrList();
        countersStrList.splice(0, 0, qsTr("Self"));
        counterSel.items = countersStrList;
    }

    //    onVisibleChanged: {
    //        if(visible)
    //            updateCounters();
    //        else
    //            counterSel.configValue = -1;
    //    }
    onDataSourceChanged: {
        var items = dataSource;
        items.splice(0,0, qsTr("Custom Pos"));
        dataSourceSel.items = items;
        dataSourceSel.configValue = 0;
    }

    function onTeachInited(){
        updateCounters();
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }

    Component.onCompleted: {
        if(Teach.currentRecord == null)
            Teach.registerWatiTeachInitedObj(container)
        else
            onTeachInited();
    }
    function onAxisDefinesChanged(){
        motor0.visible = AxisDefine.axisInfos[0].visiable;
        motor1.visible = AxisDefine.axisInfos[1].visiable;
        motor2.visible = AxisDefine.axisInfos[2].visiable;
        motor3.visible = AxisDefine.axisInfos[3].visiable;
        motor4.visible = AxisDefine.axisInfos[4].visiable;
        motor5.visible = AxisDefine.axisInfos[5].visiable;

        x_offset.visible = AxisDefine.axisInfos[0].visiable;
        y_offset.visible = AxisDefine.axisInfos[1].visiable;
        z_offset.visible = AxisDefine.axisInfos[2].visiable;

        space0.visible = AxisDefine.axisInfos[0].visiable;
        space1.visible = AxisDefine.axisInfos[1].visiable;
        space2.visible = AxisDefine.axisInfos[2].visiable;

        count0.visible = AxisDefine.axisInfos[0].visiable;
        count1.visible = AxisDefine.axisInfos[1].visiable;
        count2.visible = AxisDefine.axisInfos[2].visiable;

        dir0.visible = AxisDefine.axisInfos[0].visiable;
        dir1.visible = AxisDefine.axisInfos[1].visiable;
        dir2.visible = AxisDefine.axisInfos[2].visiable;

        runSeq.setItemVisble(0,AxisDefine.axisInfos[0].visiable);
        runSeq.setItemVisble(1,AxisDefine.axisInfos[1].visiable);
        runSeq.setItemVisble(2,AxisDefine.axisInfos[2].visiable);

        if(AxisDefine.axisInfos[0].visiable === false &&
                AxisDefine.axisInfos[1].visiable=== false &&
                    AxisDefine.axisInfos[2].visiable=== false){
            seq.items = ["","","","","","","","",""];
            for(var i=0;i<9;++i){
               seq.setItemVisble(i,false);
            }
        }
        else if(AxisDefine.axisInfos[0].visiable === false &&
                AxisDefine.axisInfos[1].visiable=== false){
            seq.items = ["","","","","","","","",qsTr("Only Z")];
            for(var i=0;i<9;++i){
                if(i === 8) continue;
               seq.setItemVisble(i,false);
            }
            seq.configValue = 8;
        }
        else if(AxisDefine.axisInfos[0].visiable === false &&
                AxisDefine.axisInfos[2].visiable=== false){
            seq.items = ["","","","","","","",qsTr("Only Y"),""];
            for(var i=0;i<9;++i){
                if(i === 7) continue;
               seq.setItemVisble(i,false);
            }
            seq.configValue = 7;
        }
        else if(AxisDefine.axisInfos[1].visiable ===false &&
                AxisDefine.axisInfos[2].visiable=== false){
            seq.items = ["","","","","","",qsTr("Only X"),"",""];
            for(var i=0;i<9;++i){
                if(i === 6) continue;
               seq.setItemVisble(i,false);
            }
            seq.configValue = 6;
        }
        else if(AxisDefine.axisInfos[0].visiable === false){
            seq.items = ["","","","Y->Z","","Z->Y","",qsTr("Only Y"),qsTr("Only Z")];
            seq.setItemVisble(0,false);
            seq.setItemVisble(1,false);
            seq.setItemVisble(2,false);
            seq.setItemVisble(4,false);
            seq.setItemVisble(6,false);
            seq.configValue = 3;
        }
        else if(AxisDefine.axisInfos[1].visiable === false){
            seq.items = ["","X->Z","","","Z->X","",qsTr("Only X"),"",qsTr("Only Z")];
            seq.setItemVisble(0,false);
            seq.setItemVisble(2,false);
            seq.setItemVisble(3,false);
            seq.setItemVisble(5,false);
            seq.setItemVisble(7,false);
            seq.configValue = 1;
        }
        else if(AxisDefine.axisInfos[2].visiable === false){
            seq.items = ["X->Y","","Y->X","","","",qsTr("Only X"),qsTr("Only Y"),""];
            seq.setItemVisble(1,false);
            seq.setItemVisble(3,false);
            seq.setItemVisble(4,false);
            seq.setItemVisble(5,false);
            seq.setItemVisble(8,false);
            seq.configValue = 0;
        }
        else{
             seq.items = ["X->Y->Z","X->Z->Y", "Y->X->Z","Y->Z->X", "Z->X->Y", "Z->Y->X", qsTr("Only X"), qsTr("Only Y"), qsTr("Only Z")];
             seq.configValue = 0;
        }
    }
}
