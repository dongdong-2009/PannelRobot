import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine

Item {
    id:root
    width: parent.width
    height: parent.height
    property variant configAddrs:["c_ro_0_32_3_900","c_ro_0_32_3_904","c_ro_0_32_3_908",
        "c_ro_0_32_3_912","c_ro_0_32_3_916","c_ro_0_32_3_920"]

    function setCurrentTye(which){
        panelRobotController.setConfigValue("s_rw_1_5_0_228",which);
    }

    ListModel{
        id:buttonModel
    }
    ICListView{
        id:view
        width: 60
        height: parent.height
        model:buttonModel
        highlight: Rectangle { width: view.width; height: 20;color: "white"; }
        highlightMoveDuration: 1
        delegate: Text {
            text: typename
            verticalAlignment:Text.AlignVCenter
            horizontalAlignment:Text.AlignHCenter
            width: parent.width
            height: 30
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index;
                    pageContainer.setCurrentIndex(index);
                }
            }
        }
    }
    Rectangle{
        id:spliteLine1
        width: 1
        height:parent.height
        color: "black"
        anchors.left: view.right
    }

    ICStackContainer{
        id:pageContainer
        anchors.left: spliteLine1.right
        width: parent.width-70
        height: parent.height

        Item {
            id:safe1
            property string typename: qsTr("Safe Area1")
            property int type_id: 0
            property variant safeSignalAddr:["s_rw_6_7_0_228","s_rw_13_7_0_228","s_rw_20_7_0_228",
                "s_rw_1_7_0_229","s_rw_8_7_0_229","s_rw_15_7_0_229"]
            property variant partEnAddr: ["s_rw_27_1_0_228","s_rw_28_1_0_228","s_rw_29_1_0_228",
                "s_rw_30_1_0_228","s_rw_31_1_0_228","s_rw_0_1_0_229"]
            property variant axisSetAddr:["s_rw_0_4_0_227","s_rw_4_4_0_227","s_rw_8_4_0_227"]
            property variant minPosAddr:["s_rw_0_32_3_230","s_rw_0_32_3_231","s_rw_0_32_3_232","s_rw_0_32_3_233","s_rw_0_32_3_234","s_rw_0_32_3_235",
                "s_rw_0_32_3_236","s_rw_0_32_3_237","s_rw_0_32_3_238","s_rw_0_32_3_239","s_rw_0_32_3_240","s_rw_0_32_3_241",
                "s_rw_0_32_3_242","s_rw_0_32_3_243","s_rw_0_32_3_244","s_rw_0_32_3_245","s_rw_0_32_3_246","s_rw_0_32_3_247"]
            property variant maxPosAddr:["s_rw_0_32_3_248","s_rw_0_32_3_249","s_rw_0_32_3_250","s_rw_0_32_3_251","s_rw_0_32_3_252","s_rw_0_32_3_253",
                "s_rw_0_32_3_254","s_rw_0_32_3_255","s_rw_0_32_3_256","s_rw_0_32_3_257","s_rw_0_32_3_258","s_rw_0_32_3_259",
                "s_rw_0_32_3_260","s_rw_0_32_3_261","s_rw_0_32_3_262","s_rw_0_32_3_263","s_rw_0_32_3_264","s_rw_0_32_3_265"]
            Image {
                id: safeAreaPic1
                source: "../images/safe_area1.png"
                width: parent.width-300
                height: parent.height
                smooth: true
            }
            ICButton{
                id:confirmBtn1
                text:qsTr("confirmBtn")
                anchors.right: safeAreaPic1.right
                anchors.rightMargin: 10
                anchors.top:safeAreaPic1.top
                height: useIt.height
                onButtonClicked: {
                    var i,j,len;
                    setCurrentTye(0);

                    for(j=0;j<3;++j){
                        axisAndPosSet.itemAt(j).onValueChanged();
                        for(i=0,len=6;i<len;++i){
                            axisAndPosSet.itemAt(j).posRepeater.itemAt(i).onValueChanged(j);
                        }
                    }
                    for(i=0,len=6;i<len;++i){
                        partSel.itemAt(i).onValueChanged();
                    }
                    useIt.onValueChanged();
                    panelRobotController.syncConfigs();
                }
            }
            ICFlickable{
                id:configContent
                anchors.left: safeAreaPic1.right
                anchors.leftMargin: 5
                height:parent.height
                width: content.width + 25
                contentWidth: content.width
                contentHeight: content.height+10
                flickableDirection: Flickable.VerticalFlick
                isshowhint: true
                Column{
                    id:content
                    spacing: 5
                    ICCheckBox{
                        id:useIt
                        configName: qsTr("Use it?")
                        function onValueChanged(){
                            panelRobotController.setConfigValue("s_rw_0_1_0_228",useIt.isChecked ? 1 : 0);
                        }
                    }
                    Repeater{
                        id:partSel
                        model: 6
                        Row{
                            property alias safeSignal: safeSignalSet.configValue
                            property alias partEn: usePart.isChecked
                            function onValueChanged(){
                                panelRobotController.setConfigValue(safe1.safeSignalAddr[index],safeSignalSet.configValue);
                                panelRobotController.setConfigValue(safe1.partEnAddr[index],usePart.isChecked?1:0);
                            }
                            spacing: 5
                            ICConfigEdit{
                                id:safeSignalSet
                                inputWidth:30
                                configName:qsTr("Area")+(index+1)+qsTr("SafeSignal")
                                configValue: "0"
                            }
                            ICCheckBox{
                                id:usePart
                                configName: qsTr("Use Part")+(index+1)
                                isChecked: false
                            }
                        }
                    }
                    ICComboBoxConfigEdit{
                        id:safePartConfig
                        configName: qsTr("Part Config")
                        items:[qsTr("Part")+1,qsTr("Part")+2,qsTr("Part")+3,qsTr("Part")+4,qsTr("Part")+5,qsTr("Part")+6]
                        configValue: 0
                    }

                    Repeater{
                        id:axisAndPosSet
                        model: 3
                        Column{
                            id:subAxisSet
                            spacing: 5
                            property int whichAxis: index
                            property alias posRepeater: subPosSet
                            property alias axisItems: axisSet.items
                            property alias axisSel: axisSet.configValue
                            property alias axis: axisSet
                            function onValueChanged(){
                                panelRobotController.setConfigValue(safe1.axisSetAddr[index],axisSet.axisID+1);
                            }
                            ICComboBoxConfigEdit{
                                id:axisSet
                                enabled: (safePartConfig.configValue == 0)
                                property int axisID: -1
                                configName:qsTr("Axis")+(index+1)
                                configValue: -1
                                onConfigValueChanged: {
                                    getIDFromConfigValue(axisSet);
                                }
                            }

                            Repeater{
                                id:subPosSet
                                model: 6
                                Column{
                                    visible: (index == safePartConfig.configValue)
                                    spacing: 5
                                    property alias minPos: minPosSet.configValue
                                    property alias maxPos: maxPosSet.configValue
                                    function onValueChanged(part){
                                        panelRobotController.setConfigValue(safe1.minPosAddr[index*3+part],minPosSet.configValue);
                                        panelRobotController.setConfigValue(safe1.maxPosAddr[index*3+part],maxPosSet.configValue);
                                    }
                                    Row{
                                        spacing: 15
                                        ICConfigEdit{
                                            id:minPosSet
                                            configName:{
                                                if(subAxisSet.whichAxis < 1) return qsTr("A");
                                                else if(subAxisSet.whichAxis < 2) return qsTr("C");
                                                else return qsTr("E");
                                            }
                                            configNameWidth: axisSet.configNameWidth
                                            min:-10000
                                            max:10000
                                            decimal: 3
                                            configValue: "0.000"
                                        }
                                        ICButton{
                                            id:minPosSetBtn
                                            text:minPosSet.configName+qsTr("Set")
                                            height: maxPosSet.height
                                            onButtonClicked: {
                                                if(axisSet.configValue >0)
                                                    minPosSet.configValue = panelRobotController.statusValueText(root.configAddrs[axisSet.axisID]);
                                            }
                                        }
                                    }
                                    Row{
                                        spacing: 15
                                        ICConfigEdit{
                                            id:maxPosSet
                                            configName:{
                                                if(subAxisSet.whichAxis <1) return qsTr("B");
                                                else if(subAxisSet.whichAxis <2) return qsTr("D");
                                                else return qsTr("F");
                                            }
                                            configNameWidth: axisSet.configNameWidth
                                            min:-10000
                                            max:10000
                                            decimal: 3
                                            configValue: "0.000"
                                        }
                                        ICButton{
                                            id:maxPosSetBtn
                                            text:maxPosSet.configName+qsTr("Set")
                                            height: maxPosSet.height
                                            onButtonClicked: {
                                                if(axisSet.configValue >0)
                                                    maxPosSet.configValue = panelRobotController.statusValueText(root.configAddrs[axisSet.axisID]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: safe2
            property string typename: qsTr("Safe Area2")
            property int type_id: 1
            Image {
                id: safeAreaPic2
                source: "../images/safe_area2.png"
                width: parent.width-300
                height: parent.height
                smooth: true
            }
            ICButton{
                id:confirmBtn2
                text:qsTr("confirmBtn")
                anchors.right: safeAreaPic2.right
                anchors.rightMargin: 10
                anchors.top:safeAreaPic2.top
                height: safe2UseIt.height
                onButtonClicked: {
                    setCurrentTye(1);
                    safe2Axis1Set.onValueChanged();
                    safe2Axis2Set.onValueChanged();
                    safe2Axis3Set.onValueChanged();
                    safe2MinPos1Set.onValueChanged();
                    safe2MaxPos1Set.onValueChanged();
                    safe2MinPos2Set.onValueChanged();
                    safe2MaxPos2Set.onValueChanged();
                    safe2UseIt.onValueChanged();
                    panelRobotController.syncConfigs();
                }
            }
            Grid{
                columns: 2
                spacing: 10
                anchors.left: safeAreaPic2.right
                anchors.leftMargin: 5
                width:300
                height:parent.height

                ICCheckBox{
                    id:safe2UseIt
                    configName: qsTr("Use it?")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_1_0_228",safe2UseIt.isChecked ? 1 : 0);
                    }
                }
                Text {
                    text: qsTr(" ")
                }

                ICComboBoxConfigEdit{
                    id:safe2Axis1Set
                    property int axisID: -1
                    z:3
                    configName:qsTr("Axis1")
                    configValue: -1
                    configNameWidth: safe2MaxPos1Set.configNameWidth
                    onConfigValueChanged: {
                        getIDFromConfigValue(safe2Axis1Set);
                    }
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_4_0_227",axisID+1);
                    }
                }
                Text {
                    text: qsTr(" ")
                }

                ICConfigEdit{
                    id:safe2MinPos1Set
                    configName:qsTr("minPos1")
                    configNameWidth: safe2MaxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    configValue: "0.000"
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_230",configValue);
                    }
                }
                ICButton{
                    id:safe2MinPos1SetBtn
                    text:qsTr("minPos1 Set")
                    height: safe2MinPos1Set.height
                    onButtonClicked:{
                        if(safe2Axis1Set.configValue >0)
                            safe2MinPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[safe2Axis1Set.axisID]);
                    }
                }

                ICConfigEdit{
                    id:safe2MaxPos1Set
                    configName:qsTr("maxPos1")
                    min:-10000
                    max:10000
                    decimal: 3
                    configValue: "0.000"
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_248",configValue);
                    }
                }
                ICButton{
                    id:safe2MaxPos1SetBtn
                    text:qsTr("maxPos1 Set")
                    height: safe2MaxPos1Set.height
                    onButtonClicked:{
                        if(safe2Axis1Set.configValue >0)
                            safe2MaxPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[safe2Axis1Set.axisID]);
                    }
                }


                ICComboBoxConfigEdit{
                    id:safe2Axis2Set
                    property int axisID: -1
                    z:2
                    configName:qsTr("Axis2")
                    configValue: -1
                    configNameWidth: safe2MaxPos2Set.configNameWidth
                    onConfigValueChanged: {
                        getIDFromConfigValue(safe2Axis2Set);
                    }
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_4_4_0_227",axisID+1);
                    }
                }
                Text {
                    text: qsTr(" ")
                }

                ICConfigEdit{
                    id:safe2MinPos2Set
                    configName:qsTr("minPos2")
                    configNameWidth: safe2MaxPos2Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    configValue: "0.000"
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_231",configValue);
                    }
                }
                ICButton{
                    id:safe2minPos2SetBtn
                    text:qsTr("minPos2 Set")
                    height: safe2MinPos2Set.height
                    onButtonClicked:{
                        if(safe2Axis2Set.configValue >0)
                            safe2MinPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[safe2Axis2Set.axisID]);
                    }
                }

                ICConfigEdit{
                    id:safe2MaxPos2Set
                    configName:qsTr("maxPos2")
                    min:-10000
                    max:10000
                    decimal: 3
                    configValue: "0.000"
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_249",configValue);
                    }
                }
                ICButton{
                    id:safe2MaxPos2SetBtn
                    text:qsTr("maxPos2 Set")
                    height: safe2MaxPos2Set.height
                    onButtonClicked:{
                        if(safe2Axis2Set.configValue >0)
                            safe2MaxPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[safe2Axis2Set.axisID]);
                    }
                }
                ICComboBoxConfigEdit{
                    id:safe2Axis3Set
                    property int axisID: -1
                    z:1
                    configName:qsTr("Axis3")
                    configNameWidth: safe2MaxPos2Set.configNameWidth
                    configValue: -1
                    onConfigValueChanged: {
                        getIDFromConfigValue(safe2Axis3Set);
                    }
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_8_4_0_227",axisID+1);
                    }
                }
                Text {
                    text: qsTr(" ")
                }
            }
        }

        Item {
            id: safe3
            property string typename: qsTr("Safe Area3")
            property int type_id: 2
            property variant safeSignalAddr: ["s_rw_6_7_0_228","s_rw_13_7_0_228","s_rw_20_7_0_228",
            "s_rw_1_7_0_229","s_rw_8_7_0_229","s_rw_15_7_0_229"]
            property variant safeSignalDirAddr: ["s_rw_27_1_0_228","s_rw_28_1_0_228","s_rw_29_1_0_228",
            "s_rw_30_1_0_228","s_rw_31_1_0_228","s_rw_0_1_0_229"]
            property variant axisSetAddr: ["s_rw_0_4_0_227","s_rw_4_4_0_227","s_rw_8_4_0_227",
            "s_rw_12_4_0_227","s_rw_16_4_0_227","s_rw_20_4_0_227"]

            Image {
                id: safeAreaPic3
    //            source: "../images/safe_area2.png"
                width: parent.width-300
                height: parent.height
                smooth: true
            }
            ICButton{
                id:confirmBtn3
                text:qsTr("confirmBtn")
                anchors.right: safeAreaPic3.right
                anchors.rightMargin: 10
                anchors.top:safeAreaPic3.top
                height: safe3UseIt.height
                onButtonClicked: {
                    setCurrentTye(2);
                    for(var i=0;i<6;++i){
                        safe3ParaConfig.itemAt(i).onValueChanged();
                    }
                    safe3UseIt.onValueChanged();
                    panelRobotController.syncConfigs();
                }
            }
            Column{
                spacing: 10
                anchors.left: safeAreaPic3.right
                anchors.leftMargin: 5
                width:300
                height:parent.height

                ICCheckBox{
                    id:safe3UseIt
                    configName: qsTr("Use it?")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_1_0_228",safe3UseIt.isChecked ? 1 : 0);
                    }
                }

                Repeater{
                    id:safe3ParaConfig
                    model: 6
                    Row{
                        spacing: 5
                        property alias safe3SafeSignal: safe3SafeSignalSet.configValue
                        property alias safe3SafeSignalDir: safe3SafeSignalDir.isChecked
                        property alias safe3Axis: safe3AxisSet
                        property alias axisSel: safe3AxisSet.configValue
                        function onValueChanged(){
                            panelRobotController.setConfigValue(safe3.safeSignalAddr[index],safe3SafeSignalSet.configValue);
                            panelRobotController.setConfigValue(safe3.safeSignalDirAddr[index],safe3SafeSignalDir.isChecked?1:0);
                            panelRobotController.setConfigValue(safe3.axisSetAddr[index],safe3AxisSet.axisID+1);
                        }
                        ICConfigEdit{
                            id:safe3SafeSignalSet
                            inputWidth:40
                            configName:qsTr("SafeSig")+(index+1)
                            configValue: "0"
                        }
                        ICCheckBox{
                            id:safe3SafeSignalDir
                            configName: qsTr("Reverse")
                        }

                        ICComboBoxConfigEdit{
                            id:safe3AxisSet
                            property int axisID: -1
                            z:8
                            inputWidth:60
                            configName:qsTr("Axis")+(index+1)
                            configValue: -1
                            onConfigValueChanged: {
                                getIDFromConfigValue(safe3AxisSet);
                            }
                        }
                    }
                }
            }
        }

        Item {
            id:safe4
            property string typename: qsTr("Safe Area4")
            property int type_id: 3
            property variant axisSetAddr:["s_rw_0_4_0_227","s_rw_4_4_0_227","s_rw_8_4_0_227","s_rw_12_4_0_227","s_rw_16_4_0_227","s_rw_20_4_0_227",
            "s_rw_24_4_0_227","s_rw_28_4_0_227","s_rw_22_4_0_229","s_rw_26_4_0_229","s_rw_8_7_0_229","s_rw_15_7_0_229"]
            property variant relativeConfigAddr: ["s_rw_0_32_3_242","s_rw_0_32_3_243","s_rw_0_32_3_244","s_rw_30_1_0_229",
            "s_rw_0_32_3_245","s_rw_31_1_0_229","s_rw_0_32_3_246","s_rw_0_1_0_229","s_rw_31_1_0_228","s_rw_0_32_3_247"]
            Image {
                id: safeAreaPic4
                source: "../images/safe_area1.png"
                width: parent.width-300
                height: parent.height
                smooth: true
            }
            ICButton{
                id:confirmBtn4
                text:qsTr("confirmBtn")
                anchors.right: safeAreaPic4.right
                anchors.rightMargin: 10
                anchors.top:safeAreaPic4.top
                height: safe4UseIt.height
                onButtonClicked: {
                    var i,j,len;
                    setCurrentTye(3);
                    for(j=0;j<4;++j){
                        for(i=0;i<3;++i){
                           safe4AxisAndPosSet.itemAt(j).itemAt(i).onValueChanged(j);
                        }
                    }
                    for(i=0;i<4;++i){
                        safe4PartSel.itemAt(i).onValueChanged();
                    }
                    relativeLimitSet.onValueChanged();
                    safe4UseIt.onValueChanged();
                    panelRobotController.syncConfigs();
                }
            }
            ICFlickable{
                id:safe4ConfigContent
                anchors.left: safeAreaPic4.right
                anchors.leftMargin: 5
                height:parent.height
                width: safe4Content.width + 25
                contentWidth: safe4Content.width
                contentHeight: safe4Content.height+10
                flickableDirection: Flickable.VerticalFlick
                isshowhint: true
                Column{
                    id:safe4Content
                    spacing: 5
                    ICCheckBox{
                        id:safe4UseIt
                        configName: qsTr("Use it?")
                        function onValueChanged(){
                            panelRobotController.setConfigValue("s_rw_0_1_0_228",safe4UseIt.isChecked ? 1 : 0);
                        }
                    }

                    Column{
                        id:relativeLimitSet
                        spacing: 5
                        property alias relativeAxis1: relativeAxis1Set.axisID
                        property alias relativeAxis2: relativeAxis2Set.axisID
                        property alias totalLen: totalLenEdit.configValue
                        property alias lenCheckEn: lenCheckEnEdit.isChecked
                        property alias safeLen: safeLenEdit.configValue
                        property alias pointCheckEn: pointCheckEnEdit.isChecked
                        property alias safePoint: safePointEdit.configValue
                        property alias isOpp: isOppEdit.isChecked
                        function onValueChanged(){
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[0],relativeAxis1+ 1);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[1],relativeAxis2+ 1);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[2],totalLen);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[3],lenCheckEn?1:0);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[4],safeLen);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[5],pointCheckEn?1:0);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[6],safePoint);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[7],isOpp?1:0);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[8],axis1Dir.isChecked?1:0);
                            panelRobotController.setConfigValue(safe4.relativeConfigAddr[9],axis2Dir.isChecked?1:0);
                        }
                        Text {
                            id:relativeTip
                            text: qsTr("Relative Move Config")
                        }
                        Row{
                            spacing: 2
                            ICComboBoxConfigEdit{
                                id:relativeAxis1Set
                                property int axisID: -1
                                configName:qsTr("Relative Axis")+1
                                configNameWidth: relativeTip.width
                                configValue: -1
                                inputWidth: 70
                                onConfigValueChanged: {
                                    getIDFromConfigValue(relativeAxis1Set);
                                }
                            }
                            ICCheckBox{
                                id:axis1Dir
                                text: qsTr("reverse")
                            }
                        }
                        Row{
                            spacing: 2
                            ICComboBoxConfigEdit{
                                id:relativeAxis2Set
                                property int axisID: -1
                                configName:qsTr("Relative Axis")+2
                                configNameWidth: relativeTip.width
                                configValue: -1
                                inputWidth: 70
                                onConfigValueChanged: {
                                    getIDFromConfigValue(relativeAxis2Set);
                                }
                            }
                            ICCheckBox{
                                id:axis2Dir
                                text: qsTr("reverse")
                            }
                        }

                        ICConfigEdit{
                            id:totalLenEdit
                            configName: qsTr("Total L")
                            configNameWidth: relativeTip.width
                            min:-10000
                            max:10000
                            decimal: 3
                            configValue: "0.000"
                        }


                        ICCheckBox{
                            id:lenCheckEnEdit
                            text: qsTr("Len Check En")
                        }
                        ICConfigEdit{
                            id:safeLenEdit
                            configName: qsTr("Safe L")
                            configNameWidth: relativeTip.width
                            min:-10000
                            max:10000
                            decimal: 3
                            configValue: "0.000"
                        }
                        ICCheckBox{
                            id:pointCheckEnEdit
                            text: qsTr("Point Check En")
                        }
                        Row{
                            spacing: 5
                            ICConfigEdit{
                                id:safePointEdit
                                configName: qsTr("Safe P")
                                configNameWidth: relativeTip.width
                                configValue: "0"
                            }
                            ICCheckBox{
                                id:isOppEdit
                                text: qsTr("Check Dir")
                            }
                        }
                    }

                    Text {
                        text: qsTr("Safe Area Config")
                    }
                    Repeater{
                        id:safe4PartSel
                        model: 4
                        Row{
                            property alias safeSignal: safe4SignalSet.configValue
                            property alias partEn: safe4UsePart.isChecked
                            function onValueChanged(){
                                panelRobotController.setConfigValue(safe1.safeSignalAddr[index],safe4SignalSet.configValue);
                                panelRobotController.setConfigValue(safe1.partEnAddr[index],safe4UsePart.isChecked?1:0);
                            }
                            spacing: 5
                            ICConfigEdit{
                                id:safe4SignalSet
                                inputWidth:30
                                configName:qsTr("Area")+(index+1)+qsTr("SafeSignal")
                                configValue: "0"
                            }
                            ICCheckBox{
                                id:safe4UsePart
                                configName: qsTr("Use Part")+(index+1)
                                isChecked: false
                            }
                        }
                    }
                    ICComboBoxConfigEdit{
                        id:safe4PartConfig
                        configName: qsTr("Part Config")
                        items:[qsTr("Part")+1,qsTr("Part")+2,qsTr("Part")+3,qsTr("Part")+4]
                        configValue: 0
                    }

                    Repeater{
                        id:safe4AxisAndPosSet
                        model: 4
                        Repeater{
                            id:safe4SubAxisAndPosSet
                            property int whichPart: index
                            model: 3
                            Column{
                                visible: (safe4SubAxisAndPosSet.whichPart == safe4PartConfig.configValue)
                                spacing: 5
                                property alias axisItems: safe4AxisSet.items
                                property alias axisSel: safe4AxisSet.configValue
                                property alias axis: safe4AxisSet
                                property alias minPos: safe4MinPosSet.configValue
                                property alias maxPos: safe4MaxPosSet.configValue
                                function onValueChanged(part){
                                    panelRobotController.setConfigValue(safe4.axisSetAddr[index+part*3],safe4AxisSet.axisID + 1);
                                    panelRobotController.setConfigValue(safe1.minPosAddr[index+part*3],safe4MinPosSet.configValue);
                                    panelRobotController.setConfigValue(safe1.maxPosAddr[index+part*3],safe4MaxPosSet.configValue);
                                }

                                ICComboBoxConfigEdit{
                                    id:safe4AxisSet
                                    property int axisID: -1
                                    configName:qsTr("Axis")+(index+1)
                                    configValue: -1
                                    onConfigValueChanged: {
                                        getIDFromConfigValue(safe4AxisSet);
                                    }
                                }
                                Column{
                                    spacing: 5
                                    Row{
                                        spacing: 15
                                        ICConfigEdit{
                                            id:safe4MinPosSet
                                            configName:{
                                                if(index < 1) return qsTr("A");
                                                else if(index < 2) return qsTr("C");
                                                else return qsTr("E");
                                            }
                                            configNameWidth: safe4AxisSet.configNameWidth
                                            min:-10000
                                            max:10000
                                            decimal: 3
                                            configValue: "0.000"
                                        }
                                        ICButton{
                                            id:safe4MinPosSetBtn
                                            text:safe4MinPosSet.configName+qsTr("Set")
                                            height: safe4MinPosSet.height
                                            onButtonClicked: {
                                                if(safe4AxisSet.configValue >0)
                                                    safe4MinPosSet.configValue = panelRobotController.statusValueText(root.configAddrs[safe4AxisSet.axisID]);
                                            }
                                        }
                                    }
                                    Row{
                                        spacing: 15
                                        ICConfigEdit{
                                            id:safe4MaxPosSet
                                            configName:{
                                                if(index <1) return qsTr("B");
                                                else if(index <2) return qsTr("D");
                                                else return qsTr("F");
                                            }
                                            configNameWidth: safe4AxisSet.configNameWidth
                                            min:-10000
                                            max:10000
                                            decimal: 3
                                            configValue: "0.000"
                                        }
                                        ICButton{
                                            id:safe4maxPosSetBtn
                                            text:safe4MaxPosSet.configName+qsTr("Set")
                                            height: safe4MaxPosSet.height
                                            onButtonClicked: {
                                                if(safe4AxisSet.configValue >0)
                                                    safe4MaxPosSet.configValue = panelRobotController.statusValueText(root.configAddrs[safe4AxisSet.axisID]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted:{
        onAxisDefinesChanged();
        AxisDefine.registerMonitors(root);
        var i,j;
        if(panelRobotController.getConfigValue("s_rw_1_5_0_228") == 0){
            for(i=0;i<3;++i){
                axisAndPosSet.itemAt(i).axis.axisID = panelRobotController.getConfigValue(safe1.axisSetAddr[i])-1;
                getConfigValueFromID(axisAndPosSet.itemAt(i).axis.axisID,axisAndPosSet.itemAt(i).axis);
                for(j=0;j<6;++j){
                    axisAndPosSet.itemAt(i).posRepeater.itemAt(j).minPos = panelRobotController.getConfigValueText(safe1.minPosAddr[j*3+i]);
                    axisAndPosSet.itemAt(i).posRepeater.itemAt(j).maxPos = panelRobotController.getConfigValueText(safe1.maxPosAddr[j*3+i]);
                }
            }
            for(i=0;i<6;++i){
              partSel.itemAt(i).safeSignal = panelRobotController.getConfigValue(safe1.safeSignalAddr[i]);
              partSel.itemAt(i).partEn = panelRobotController.getConfigValue(safe1.partEnAddr[i]);
            }
            useIt.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_228");
        }
        else if(panelRobotController.getConfigValue("s_rw_1_5_0_228") == 1){
            safe2Axis1Set.axisID = panelRobotController.getConfigValue("s_rw_0_4_0_227")-1;
            getConfigValueFromID(safe2Axis1Set.axisID,safe2Axis1Set);
            safe2Axis2Set.axisID = panelRobotController.getConfigValue("s_rw_4_4_0_227")-1;
            getConfigValueFromID(safe2Axis2Set.axisID,safe2Axis2Set);
            safe2Axis3Set.axisID = panelRobotController.getConfigValue("s_rw_8_4_0_227")-1;
            getConfigValueFromID(safe2Axis3Set.axisID,safe2Axis3Set);
            safe2MinPos1Set.configValue = panelRobotController.getConfigValueText("s_rw_0_32_3_230");
            safe2MaxPos1Set.configValue = panelRobotController.getConfigValueText("s_rw_0_32_3_248");
            safe2MinPos2Set.configValue = panelRobotController.getConfigValueText("s_rw_0_32_3_231");
            safe2MaxPos2Set.configValue = panelRobotController.getConfigValueText("s_rw_0_32_3_249");
            safe2UseIt.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_228");
        }
        else if(panelRobotController.getConfigValue("s_rw_1_5_0_228") == 2){
            for(i=0;i<6;++i){
                safe3ParaConfig.itemAt(i).safe3Axis.axisID = panelRobotController.getConfigValue(safe3.axisSetAddr[i])-1;
                getConfigValueFromID(safe3ParaConfig.itemAt(i).safe3Axis.axisID,safe3ParaConfig.itemAt(i).safe3Axis);
                safe3ParaConfig.itemAt(i).safe3SafeSignalDir = panelRobotController.getConfigValue(safe3.safeSignalDirAddr[i]);
                safe3ParaConfig.itemAt(i).safe3SafeSignal = panelRobotController.getConfigValue(safe3.safeSignalAddr[i]);
            }
            safe3UseIt.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_228");
        }
        else if(panelRobotController.getConfigValue("s_rw_1_5_0_228") == 3){
            for(i=0;i<4;++i){
                for(j=0;j<3;++j){
                    safe4AxisAndPosSet.itemAt(i).itemAt(j).axis.axisID = panelRobotController.getConfigValue(safe4.axisSetAddr[j+i*3])-1;
                    getConfigValueFromID(safe4AxisAndPosSet.itemAt(i).itemAt(j).axis.axisID,safe4AxisAndPosSet.itemAt(i).itemAt(j).axis);
                    safe4AxisAndPosSet.itemAt(i).itemAt(j).minPos = panelRobotController.getConfigValueText(safe1.minPosAddr[j+i*3]);
                    safe4AxisAndPosSet.itemAt(i).itemAt(j).maxPos = panelRobotController.getConfigValueText(safe1.maxPosAddr[j+i*3]);
                }
            }
            for(i=0;i<4;++i){
              safe4PartSel.itemAt(i).safeSignal = panelRobotController.getConfigValue(safe1.safeSignalAddr[i]);
              safe4PartSel.itemAt(i).partEn = panelRobotController.getConfigValue(safe1.partEnAddr[i]);
            }
            relativeLimitSet.relativeAxis1 = panelRobotController.getConfigValue(safe4.relativeConfigAddr[0])/1000-1;
            getConfigValueFromID(relativeLimitSet.relativeAxis1,relativeAxis1Set);
            relativeLimitSet.relativeAxis2 = panelRobotController.getConfigValue(safe4.relativeConfigAddr[1])/1000-1;
            getConfigValueFromID(relativeLimitSet.relativeAxis2,relativeAxis2Set);
            relativeLimitSet.totalLen = panelRobotController.getConfigValueText(safe4.relativeConfigAddr[2]);
            relativeLimitSet.lenCheckEn = panelRobotController.getConfigValue(safe4.relativeConfigAddr[3]);
            relativeLimitSet.safeLen = panelRobotController.getConfigValueText(safe4.relativeConfigAddr[4]);
            relativeLimitSet.pointCheckEn = panelRobotController.getConfigValue(safe4.relativeConfigAddr[5]);
            relativeLimitSet.safePoint = panelRobotController.getConfigValue(safe4.relativeConfigAddr[6])/1000;
            relativeLimitSet.isOpp = panelRobotController.getConfigValueText(safe4.relativeConfigAddr[7]);
            axis1Dir.isChecked = panelRobotController.getConfigValue(safe4.relativeConfigAddr[8]) == 1?true:false;
            axis2Dir.isChecked = panelRobotController.getConfigValue(safe4.relativeConfigAddr[9])/1000 == 1?true:false;
            safe4UseIt.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_228");
        }
        buttonModel.append({"typename":safe1.typename,"id":safe1.type_id});
        buttonModel.append({"typename":safe2.typename,"id":safe2.type_id});
        buttonModel.append({"typename":safe3.typename,"id":safe3.type_id});
        buttonModel.append({"typename":safe4.typename,"id":safe4.type_id});
        pageContainer.addPage(safe1);
        pageContainer.addPage(safe2);
        pageContainer.addPage(safe3);
        pageContainer.addPage(safe4);

        var type = panelRobotController.getConfigValue("s_rw_1_5_0_228");
        pageContainer.setCurrentIndex(type);
        view.currentIndex = type;
    }

    function getConfigValueFromID(id,editor){
        if(id == -1){
            editor.configValue = 0;
            return;
        }
        for(var i=0,len=editor.items.length;i<len;++i){
            if(editor.items[i] == AxisDefine.axisInfos[id].name){
                editor.configValue = i;
                return;
            }
        }
        editor.configValue = 0;
    }

    function getIDFromConfigValue(editor){
        var axisName = editor.items[editor.configValue];
        for(var i=0,len=AxisDefine.axisInfos.length;i<len;++i){
            if(axisName == AxisDefine.axisInfos[i].name){
                editor.axisID = i;
                return;
            }
        }
        editor.axisID = -1;
    }

    function onAxisDefinesChanged(){
        var axis = AxisDefine.usedAxisNameList();
        axis.unshift(qsTr("NO"));
        var i,j,sel;
        for(i=0;i<3;++i){
           if(axisAndPosSet.itemAt(i).axisSel >=axis.length){
              axisAndPosSet.itemAt(i).axisSel = -1;
           }
           axisAndPosSet.itemAt(i).axisItems = axis;
           if(axisAndPosSet.itemAt(i).axisSel  == -1){
               axisAndPosSet.itemAt(i).axisSel  = 0;
           }
        }

        if(safe2Axis1Set.configValue >=axis.length){
            safe2Axis1Set.configValue = -1;
        }
        safe2Axis1Set.items = axis;
        if(safe2Axis1Set.configValue == -1){
            safe2Axis1Set.configValue = 0;
        }

        if(safe2Axis2Set.configValue >=axis.length){
            safe2Axis2Set.configValue = -1;
        }
        safe2Axis2Set.items = axis;
        if(safe2Axis2Set.configValue == -1){
            safe2Axis2Set.configValue = 0;
        }

        if(safe2Axis3Set.configValue >=axis.length){
            safe2Axis3Set.configValue = -1;
        }
        safe2Axis3Set.items = axis;
        if(safe2Axis3Set.configValue == -1){
            safe2Axis3Set.configValue = 0;
        }

        for(i=0;i<6;++i){
            if(safe3ParaConfig.itemAt(i).axisSel >=axis.length){
               safe3ParaConfig.itemAt(i).axisSel = -1;
            }
            safe3ParaConfig.itemAt(i).safe3Axis.items = axis;
            if(safe3ParaConfig.itemAt(i).axisSel == -1){
                safe3ParaConfig.itemAt(i).axisSel = 0;
            }
        }

        for(j=0;j<4;++j){
            for(i=0;i<3;++i){
               if(safe4AxisAndPosSet.itemAt(j).itemAt(i).axisSel >=axis.length){
                  safe4AxisAndPosSet.itemAt(j).itemAt(i).axisSel = -1;
               }
               safe4AxisAndPosSet.itemAt(j).itemAt(i).axisItems = axis;
               if(safe4AxisAndPosSet.itemAt(j).itemAt(i).axisSel == -1){
                   safe4AxisAndPosSet.itemAt(j).itemAt(i).axisSel = 0;
               }
            }
        }

        if(relativeAxis1Set.configValue >=axis.length){
            relativeAxis1Set.configValue = -1;
        }
        relativeAxis1Set.items = axis;
        if(relativeAxis1Set.configValue ==-1){
            relativeAxis1Set.configValue = 0;
        }

        if(relativeAxis2Set.configValue >=axis.length){
            relativeAxis2Set.configValue = -1;
        }
        relativeAxis2Set.items = axis;
        if(relativeAxis2Set.configValue == -1){
           relativeAxis2Set.configValue = 0;
        }
    }
}
