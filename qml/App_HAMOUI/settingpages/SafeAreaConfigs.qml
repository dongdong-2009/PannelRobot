import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine

Item {
    id:root
    width: parent.width
    height: parent.height
    property variant configAddrs:["c_ro_0_32_3_900","c_ro_0_32_3_904","c_ro_0_32_3_908",
        "c_ro_0_32_3_912","c_ro_0_32_3_916","c_ro_0_32_3_920"]
    function showCurrentSafeArea(which){
        panelRobotController.setConfigValue("s_rw_1_5_0_228",which);
        panelRobotController.syncConfigs();
    }
    ListModel{
        id:buttonModel
    }
    ICListView{
        id:view
        width: 100
        height: parent.height
        model:buttonModel
        highlight: Rectangle { width: view.width; height: 20;color: "white"; }
        highlightMoveDuration: 1
        delegate: Text {
            text: id +":"+typename
            width: parent.width
            height: 20
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index;
                    pageContainer.setCurrentIndex(index);
                    showCurrentSafeArea(index);
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
        width: parent.width-100
        height: parent.height
    }

    Item {
        id:safe1
        width: parent.width-100
        height: parent.height
        anchors.left: spliteLine1.right
        property string typename: qsTr("Safe Area1")
        property int type_id: 0
        Image {
            id: safeAreaPic1
            source: "../images/safe_area1.png"
            width: parent.width-300
            height: parent.height
        }
        ICFlickable{
            anchors.left: safeAreaPic1.right
            anchors.leftMargin: 5
            height:parent.height
            width:300
            contentWidth: content.width
            contentHeight: content.height
            flickableDirection: Flickable.VerticalFlick
            Grid{
                id:content
                columns: 2
                spacing: 5
                width: parent.width

                ICConfigEdit{
                    id:safeSignalSet
                    inputWidth:30
                    configName:qsTr("SafePo1")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_6_7_0_228",configValue);
                    }
                }
                ICCheckBox{
                    id:usePart1
                    configName: qsTr("Use Part1?")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_27_1_0_228",usePart1.isChecked?1:0);
                    }
                }
                ICConfigEdit{
                    id:safeSignal2Set
                    inputWidth:30
                    configName:qsTr("SafePo2")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_13_7_0_228",configValue);
                    }
                }
                ICCheckBox{
                    id:usePart2
                    configName: qsTr("Use Part2?")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_28_1_0_228",usePart2.isChecked?1:0);
                    }
                }

                ICConfigEdit{
                    id:safeSignal3Set
                    inputWidth:30
                    configName:qsTr("SafePo3")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_20_7_0_228",configValue);
                    }
                }
                ICCheckBox{
                    id:usePart3
                    configName: qsTr("Use Part3?")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_29_1_0_228",usePart3.isChecked?1:0);
                    }
                }
                ICConfigEdit{
                    id:safeSignal4Set
                    inputWidth:30
                    configName:qsTr("SafePo4")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_1_7_0_229",configValue);
                    }
                }
                ICCheckBox{
                    id:usePart4
                    configName: qsTr("Use Part4?")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_30_1_0_228",usePart4.isChecked?1:0);
                    }
                }
                ICConfigEdit{
                    id:safeSignal5Set
                    inputWidth:30
                    configName:qsTr("SafePo5")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_8_7_0_229",configValue);
                    }
                }
                ICCheckBox{
                    id:usePart5
                    configName: qsTr("Use Part5?")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_31_1_0_228",usePart5.isChecked?1:0);
                    }
                }
                ICConfigEdit{
                    id:safeSignal6Set
                    inputWidth:30
                    configName:qsTr("SafePo6")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_15_7_0_229",configValue);
                    }
                }
                ICCheckBox{
                    id:usePart6
                    configName: qsTr("Use Part6?")
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_1_0_229",usePart6.isChecked?1:0);
                    }
                }
                ICComboBoxConfigEdit{
                    id:axis1Set
                    z:3
                    configName:qsTr("Axis1")
                    configValue: -1
                    configNameWidth: maxPos1Set.configNameWidth
                    popupHeight: 120
                    function onAxisDefinesChanged(){
                        var axis = AxisDefine.usedAxisNameList();
                        axis.unshift(qsTr("NO"));
                        axis1Set.items = axis;
                        axis2Set.items = axis;
                        axis3Set.items = axis;
                    }
                    Component.onCompleted: {
                        AxisDefine.registerMonitors(axis1Set);
                    }
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_4_0_227",configValue);
                    }
                }
                Text {
                    text: qsTr(" ")
                }

                ICConfigEdit{
                    id:minPos1Set
                    visible: usePart1.isChecked
                    configName:qsTr("P1-A")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_230",configValue);
                    }
                }
                ICButton{
                    id:minPos1SetBtn
                    visible: usePart1.isChecked
                    text:qsTr("P1-A Set")
                    height: minPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            minPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:maxPos1Set
                    visible: usePart1.isChecked
                    configName:qsTr("P1-B")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_248",configValue);
                    }
                }
                ICButton{
                    id:maxPos1SetBtn
                    visible: usePart1.isChecked
                    text:qsTr("P1-B Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            maxPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part2MinPos1Set
                    visible: usePart2.isChecked
                    configName:qsTr("P2-A")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_233",configValue);
                    }
                }
                ICButton{
                    id:part2MinPos1SetBtn
                    visible: usePart2.isChecked
                    text:qsTr("P2-A Set")
                    height: part2MinPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part2MinPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part2MaxPos1Set
                    visible: usePart2.isChecked
                    configName:qsTr("P2-B")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_251",configValue);
                    }
                }
                ICButton{
                    id:part2MaxPos1SetBtn
                    visible: usePart2.isChecked
                    text:qsTr("P2-B Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part2MaxPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part3MinPos1Set
                    visible: usePart3.isChecked
                    configName:qsTr("P3-A")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_236",configValue);
                    }
                }
                ICButton{
                    id:part3MinPos1SetBtn
                    visible: usePart3.isChecked
                    text:qsTr("P3-A Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part3MinPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part3MaxPos1Set
                    visible: usePart3.isChecked
                    configName:qsTr("P3-B")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_254",configValue);
                    }
                }
                ICButton{
                    id:part3MaxPos1SetBtn
                    visible: usePart3.isChecked
                    text:qsTr("P3-B Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part3MaxPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }
                ICConfigEdit{
                    id:part4MinPos1Set
                    visible: usePart4.isChecked
                    configName:qsTr("P4-A")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_239",configValue);
                    }
                }
                ICButton{
                    id:part4MinPos1SetBtn
                    visible: usePart4.isChecked
                    text:qsTr("P4-A Set")
                    height: minPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part4MinPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part4MaxPos1Set
                    visible: usePart4.isChecked
                    configName:qsTr("P4-B")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_257",configValue);
                    }
                }
                ICButton{
                    id:part4MaxPos1SetBtn
                    visible: usePart4.isChecked
                    text:qsTr("P4-B Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part4MaxPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part5MinPos1Set
                    visible: usePart5.isChecked
                    configName:qsTr("P5-A")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_242",configValue);
                    }
                }
                ICButton{
                    id:part5MinPos1SetBtn
                    visible: usePart5.isChecked
                    text:qsTr("P5-A Set")
                    height: part5MinPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part5MinPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part5MaxPos1Set
                    visible: usePart5.isChecked
                    configName:qsTr("P5-B")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_260",configValue);
                    }
                }
                ICButton{
                    id:part5MaxPos1SetBtn
                    visible: usePart5.isChecked
                    text:qsTr("P5-B Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part5MaxPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part6MinPos1Set
                    visible: usePart6.isChecked
                    configName:qsTr("P6-A")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_245",configValue);
                    }
                }
                ICButton{
                    id:part6MinPos1SetBtn
                    visible: usePart6.isChecked
                    text:qsTr("P6-A Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part6MinPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part6MaxPos1Set
                    visible: usePart6.isChecked
                    configName:qsTr("P6-B")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_263",configValue);
                    }
                }
                ICButton{
                    id:part6MaxPos1SetBtn
                    visible: usePart6.isChecked
                    text:qsTr("P6-B Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis1Set.configValue >0)
                            part6MaxPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis1Set.configValue-1]);
                    }
                }



                ICComboBoxConfigEdit{
                    id:axis2Set
                    z:2
                    configName:qsTr("Axis2")
                    configValue: -1
                    configNameWidth: maxPos1Set.configNameWidth
                    popupHeight: 120
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_4_4_0_227",configValue);
                    }
                }
                Text {
                    text: qsTr(" ")
                }

                ICConfigEdit{
                    id:minPos2Set
                    visible: usePart1.isChecked
                    configName:qsTr("P1-C")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_231",configValue);
                    }
                }
                ICButton{
                    id:minPos2SetBtn
                    visible: usePart1.isChecked
                    text:qsTr("P1-C Set")
                    height: maxPos1Set.height
                    onButtonClicked:  {
                        if(axis2Set.configValue >0)
                            minPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:maxPos2Set
                    visible: usePart1.isChecked
                    configName:qsTr("P1-D")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_249",configValue);
                    }
                }
                ICButton{
                    id:maxPos2SetBtn
                    visible: usePart1.isChecked
                    text:qsTr("P1-D Set")
                    height: maxPos1Set.height
                    onButtonClicked:  {
                        if(axis2Set.configValue >0)
                            maxPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part2MinPos2Set
                    visible: usePart2.isChecked
                    configName:qsTr("P2-C")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_234",configValue);
                    }
                }
                ICButton{
                    id:part2MinPos2SetBtn
                    visible: usePart2.isChecked
                    text:qsTr("P2-C Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis2Set.configValue >0)
                            part2MinPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part2MaxPos2Set
                    visible: usePart2.isChecked
                    configName:qsTr("P2-D")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_252",configValue);
                    }
                }
                ICButton{
                    id:part2MaxPos2SetBtn
                    visible: usePart2.isChecked
                    text:qsTr("P2-D Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis2Set.configValue >0)
                            part2MaxPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part3MinPos2Set
                    visible: usePart3.isChecked
                    configName:qsTr("P3-C")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_237",configValue);
                    }
                }
                ICButton{
                    id:part3MinPos2SetBtn
                    visible: usePart3.isChecked
                    text:qsTr("P3-C Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis2Set.configValue >0)
                            part3MinPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part3MaxPos2Set
                    visible: usePart3.isChecked
                    configName:qsTr("P3-D")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_255",configValue);
                    }
                }
                ICButton{
                    id:part3MaxPos2SetBtn
                    visible: usePart3.isChecked
                    text:qsTr("P3-D Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis2Set.configValue >0)
                            part3MaxPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }
                ICConfigEdit{
                    id:part4MinPos2Set
                    visible: usePart4.isChecked
                    configName:qsTr("P4-C")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_240",configValue);
                    }
                }
                ICButton{
                    id:part4MinPos2SetBtn
                    visible: usePart4.isChecked
                    text:qsTr("P4-C Set")
                    height: maxPos1Set.height
                    onButtonClicked:  {
                        if(axis2Set.configValue >0)
                            part4MinPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part4MaxPos2Set
                    visible: usePart4.isChecked
                    configName:qsTr("P4-D")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_258",configValue);
                    }
                }
                ICButton{
                    id:part4MaxPos2SetBtn
                    visible: usePart4.isChecked
                    text:qsTr("P4-D Set")
                    height: maxPos1Set.height
                    onButtonClicked:  {
                        if(axis2Set.configValue >0)
                            part4MaxPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part5MinPos2Set
                    visible: usePart5.isChecked
                    configName:qsTr("P5-C")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_243",configValue);
                    }
                }
                ICButton{
                    id:part5MinPos2SetBtn
                    visible: usePart5.isChecked
                    text:qsTr("P5-C Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis2Set.configValue >0)
                            part5MinPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part5MaxPos2Set
                    visible: usePart5.isChecked
                    configName:qsTr("P5-D")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_261",configValue);
                    }
                }
                ICButton{
                    id:part5MaxPos2SetBtn
                    visible: usePart5.isChecked
                    text:qsTr("P5-D Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis2Set.configValue >0)
                            part5MaxPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part6MinPos2Set
                    visible: usePart6.isChecked
                    configName:qsTr("P6-C")
                    configNameWidth: maxPos2Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_246",configValue);
                    }
                }
                ICButton{
                    id:part6MinPos2SetBtn
                    visible: usePart6.isChecked
                    text:qsTr("P6-C Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis2Set.configValue >0)
                            part6MinPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part6MaxPos2Set
                    visible: usePart6.isChecked
                    configName:qsTr("P6-D")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_264",configValue);
                    }
                }
                ICButton{
                    id:part6MaxPos2SetBtn
                    visible: usePart6.isChecked
                    text:qsTr("P6-D Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis2Set.configValue >0)
                            part6MaxPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis2Set.configValue-1]);
                    }
                }



                ICComboBoxConfigEdit{
                    id:axis3Set
                    z:1
                    configName:qsTr("Axis3")
                    configValue: -1
                    configNameWidth: maxPos1Set.configNameWidth
                    popupHeight: 120
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_8_4_0_227",configValue);
                    }
                }
                Text {
                    text: qsTr(" ")
                }

                ICConfigEdit{
                    id:minPos3Set
                    visible: usePart1.isChecked
                    configName:qsTr("P1-E")
                    configNameWidth: maxPos3Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_232",configValue);
                    }
                }
                ICButton{
                    id:minPos3SetBtn
                    visible: usePart1.isChecked
                    text:qsTr("P1-E Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            minPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:maxPos3Set
                    visible: usePart1.isChecked
                    configName:qsTr("P1-F")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_250",configValue);
                    }
                }
                ICButton{
                    id:maxPos3SetBtn
                    visible: usePart1.isChecked
                    text:qsTr("P1-F Set")
                    height: maxPos1Set.height
                    onButtonClicked:  {
                        if(axis3Set.configValue >0)
                            maxPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part2MinPos3Set
                    visible: usePart2.isChecked
                    configName:qsTr("P2-E")
                    configNameWidth: maxPos3Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_235",configValue);
                    }
                }
                ICButton{
                    id:part2MinPos3SetBtn
                    visible: usePart2.isChecked
                    text:qsTr("P2-E Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part2MinPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part2MaxPos3Set
                    visible: usePart2.isChecked
                    configName:qsTr("P2-F")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_253",configValue);
                    }
                }
                ICButton{
                    id:part2MaxPos3SetBtn
                    visible: usePart2.isChecked
                    text:qsTr("P2-F Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part2MaxPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part3MinPos3Set
                    visible: usePart3.isChecked
                    configName:qsTr("P3-E")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_238",configValue);
                    }
                }
                ICButton{
                    id:part3MinPos3SetBtn
                    visible: usePart3.isChecked
                    text:qsTr("P3-E Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part3MinPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part3MaxPos3Set
                    visible: usePart3.isChecked
                    configName:qsTr("P3-F")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_256",configValue);
                    }
                }
                ICButton{
                    id:part3MaxPos3SetBtn
                    visible: usePart3.isChecked
                    text:qsTr("P3-F Set")
                    height: part3MaxPos3Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part3MaxPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }
                ICConfigEdit{
                    id:part4MinPos3Set
                    visible: usePart4.isChecked
                    configName:qsTr("P4-E")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_241",configValue);
                    }
                }
                ICButton{
                    id:part4MinPos3SetBtn
                    visible: usePart4.isChecked
                    text:qsTr("P4-E Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part4MinPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part4MaxPos3Set
                    visible: usePart4.isChecked
                    configName:qsTr("P4-F")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_259",configValue);
                    }
                }
                ICButton{
                    id:part4MaxPos3SetBtn
                    visible: usePart4.isChecked
                    text:qsTr("P4-F Set")
                    height: maxPos1Set.height
                    onButtonClicked:  {
                        if(axis3Set.configValue >0)
                            part4MaxPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part5MinPos3Set
                    visible: usePart5.isChecked
                    configName:qsTr("P5-E")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_244",configValue);
                    }
                }
                ICButton{
                    id:part5MinPos3SetBtn
                    visible: usePart5.isChecked
                    text:qsTr("P5-E Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part5MinPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part5MaxPos3Set
                    visible: usePart5.isChecked
                    configName:qsTr("P5-F")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_262",configValue);
                    }
                }
                ICButton{
                    id:part5MaxPos3SetBtn
                    visible: usePart5.isChecked
                    text:qsTr("P5-F Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part5MaxPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part6MinPos3Set
                    visible: usePart6.isChecked
                    configName:qsTr("P6-E")
                    configNameWidth: maxPos1Set.configNameWidth
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_247",configValue);
                    }
                }
                ICButton{
                    id:part6MinPos3SetBtn
                    visible: usePart6.isChecked
                    text:qsTr("P6-E Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part6MinPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICConfigEdit{
                    id:part6MaxPos3Set
                    visible: usePart6.isChecked
                    configName:qsTr("P6-F")
                    min:-10000
                    max:10000
                    decimal: 3
                    function onValueChanged(){
                        panelRobotController.setConfigValue("s_rw_0_32_3_265",configValue);
                    }
                }
                ICButton{
                    id:part6MaxPos3SetBtn
                    visible: usePart6.isChecked
                    text:qsTr("P6-F Set")
                    height: maxPos1Set.height
                    onButtonClicked: {
                        if(axis3Set.configValue >0)
                            part6MaxPos3Set.configValue = panelRobotController.statusValueText(root.configAddrs[axis3Set.configValue-1]);
                    }
                }

                ICCheckBox{
                    id:useIt
                    configName: qsTr("Use it?")
                    onClicked: {
                        if(useIt.isChecked){
                            safe2UseIt.isChecked = 0;
                            axis1Set.onValueChanged();
                            axis2Set.onValueChanged();
                            axis3Set.onValueChanged();

                            minPos1Set.onValueChanged();
                            minPos2Set.onValueChanged();
                            minPos3Set.onValueChanged();
                            part2MinPos1Set.onValueChanged();
                            part2MinPos2Set.onValueChanged();
                            part2MinPos3Set.onValueChanged();
                            part3MinPos1Set.onValueChanged();
                            part3MinPos2Set.onValueChanged();
                            part3MinPos3Set.onValueChanged();
                            part4MinPos1Set.onValueChanged();
                            part4MinPos2Set.onValueChanged();
                            part4MinPos3Set.onValueChanged();
                            part5MinPos1Set.onValueChanged();
                            part5MinPos2Set.onValueChanged();
                            part5MinPos3Set.onValueChanged();
                            part6MinPos1Set.onValueChanged();
                            part6MinPos2Set.onValueChanged();
                            part6MinPos3Set.onValueChanged();

                            maxPos1Set.onValueChanged();
                            maxPos2Set.onValueChanged();           
                            maxPos3Set.onValueChanged();
                            part2MaxPos1Set.onValueChanged(); 
                            part2MaxPos2Set.onValueChanged();
                            part2MaxPos3Set.onValueChanged();
                            part3MaxPos1Set.onValueChanged();
                            part3MaxPos2Set.onValueChanged();
                            part3MaxPos3Set.onValueChanged();
                            part4MaxPos1Set.onValueChanged();
                            part4MaxPos2Set.onValueChanged();
                            part4MaxPos3Set.onValueChanged();
                            part5MaxPos1Set.onValueChanged();
                            part5MaxPos2Set.onValueChanged();
                            part5MaxPos3Set.onValueChanged();
                            part6MaxPos1Set.onValueChanged();
                            part6MaxPos2Set.onValueChanged();
                            part6MaxPos3Set.onValueChanged();

                            safeSignalSet.onValueChanged();
                            safeSignal2Set.onValueChanged();
                            safeSignal3Set.onValueChanged();
                            safeSignal4Set.onValueChanged();
                            safeSignal5Set.onValueChanged();
                            safeSignal6Set.onValueChanged();

                            usePart1.onValueChanged();
                            usePart2.onValueChanged();
                            usePart3.onValueChanged();
                            usePart4.onValueChanged();
                            usePart5.onValueChanged();
                            usePart6.onValueChanged();

                        }
                        panelRobotController.setConfigValue("s_rw_0_1_0_228",useIt.isChecked ? 1 : 0);
                        panelRobotController.syncConfigs();
                    }
                }
                Text {
                    text: qsTr(" ")
                }
            }
        }
        Component.onCompleted:{
            if(panelRobotController.getConfigValue("s_rw_1_5_0_228") == 0){
                axis1Set.configValue = panelRobotController.getConfigValue("s_rw_0_4_0_227");
                axis2Set.configValue = panelRobotController.getConfigValue("s_rw_4_4_0_227");
                axis3Set.configValue = panelRobotController.getConfigValue("s_rw_8_4_0_227");

                minPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_230")/1000;
                minPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_231")/1000;
                minPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_232")/1000;
                part2MinPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_233")/1000;
                part2MinPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_234")/1000;
                part2MinPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_235")/1000;
                part3MinPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_236")/1000;
                part3MinPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_237")/1000;
                part3MinPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_238")/1000;
                part4MinPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_239")/1000;
                part4MinPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_240")/1000;
                part4MinPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_241")/1000;
                part5MinPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_242")/1000;
                part5MinPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_243")/1000;
                part5MinPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_244")/1000;
                part6MinPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_245")/1000;
                part6MinPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_246")/1000;
                part6MinPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_247")/1000;

                maxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_248")/1000;
                maxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_249")/1000;
                maxPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_250")/1000;
                part2MaxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_251")/1000;
                part2MaxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_252")/1000;
                part2MaxPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_253")/1000;
                part3MaxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_254")/1000;
                part3MaxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_255")/1000;
                part3MaxPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_256")/1000;
                part4MaxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_257")/1000;
                part4MaxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_258")/1000;
                part4MaxPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_259")/1000;
                part5MaxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_260")/1000;
                part5MaxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_261")/1000;
                part5MaxPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_262")/1000;
                part6MaxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_263")/1000;
                part6MaxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_264")/1000;
                part6MaxPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_265")/1000;


                safeSignalSet.configValue= panelRobotController.getConfigValue("s_rw_6_7_0_228");
                safeSignal2Set.configValue= panelRobotController.getConfigValue("s_rw_13_7_0_228");
                safeSignal3Set.configValue= panelRobotController.getConfigValue("s_rw_20_7_0_228");
                safeSignal4Set.configValue= panelRobotController.getConfigValue("s_rw_1_7_0_229");
                safeSignal5Set.configValue= panelRobotController.getConfigValue("s_rw_8_7_0_229");
                safeSignal6Set.configValue= panelRobotController.getConfigValue("s_rw_15_7_0_229");

                usePart1.isChecked = panelRobotController.getConfigValue("s_rw_27_1_0_228");
                usePart2.isChecked = panelRobotController.getConfigValue("s_rw_28_1_0_228");
                usePart3.isChecked = panelRobotController.getConfigValue("s_rw_29_1_0_228");
                usePart4.isChecked = panelRobotController.getConfigValue("s_rw_30_1_0_228");
                usePart5.isChecked = panelRobotController.getConfigValue("s_rw_31_1_0_228");
                usePart6.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_229");


                useIt.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_228");
            }
        }
    }

    Item {
        id: safe2
        width: parent.width-100
        height: parent.height
        anchors.left: spliteLine1.right
        property string typename: qsTr("Safe Area2")
        property int type_id: 1
        Image {
            id: safeAreaPic2
            source: "../images/safe_area2.png"
            width: parent.width-300
            height: parent.height
        }
        Grid{
            columns: 2
            spacing: 10
            anchors.left: safeAreaPic2.right
            anchors.leftMargin: 5
            width:300
            height:parent.height

            ICComboBoxConfigEdit{
                id:safe2Axis1Set
                z:3
                configName:qsTr("Axis1")
                configValue: -1
                configNameWidth: safe2MaxPos1Set.configNameWidth
                popupHeight: 120
                function onAxisDefinesChanged(){
                    var axis = AxisDefine.usedAxisNameList();
                    axis.unshift(qsTr("NO"));
                    safe2Axis1Set.items = axis;
                    safe2Axis2Set.items = axis;
                    safe2Axis3Set.items = axis;
                }
                Component.onCompleted: {
                    AxisDefine.registerMonitors(safe2Axis1Set);
                }
                function onValueChanged(){
                    panelRobotController.setConfigValue("s_rw_0_4_0_227",configValue);
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
                        safe2MinPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[safe2Axis1Set.configValue-1]);
                }
            }

            ICConfigEdit{
                id:safe2MaxPos1Set
                configName:qsTr("maxPos1")
                min:-10000
                max:10000
                decimal: 3
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
                        safe2MaxPos1Set.configValue = panelRobotController.statusValueText(root.configAddrs[safe2Axis1Set.configValue-1]);
                }
            }


            ICComboBoxConfigEdit{
                id:safe2Axis2Set
                z:2
                configName:qsTr("Axis2")
                configValue: -1
                configNameWidth: safe2MaxPos2Set.configNameWidth
                popupHeight: 120
                function onValueChanged(){
                    panelRobotController.setConfigValue("s_rw_4_4_0_227",configValue);
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
                        safe2MinPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[safe2Axis2Set.configValue-1]);
                }
            }

            ICConfigEdit{
                id:safe2MaxPos2Set
                configName:qsTr("maxPos2")
                min:-10000
                max:10000
                decimal: 3
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
                        safe2MaxPos2Set.configValue = panelRobotController.statusValueText(root.configAddrs[safe2Axis2Set.configValue-1]);
                }
            }
            ICComboBoxConfigEdit{
                id:safe2Axis3Set
                z:1
                configName:qsTr("Axis3")
                configNameWidth: safe2MaxPos2Set.configNameWidth
                configValue: -1
                popupHeight: 120
                function onValueChanged(){
                    panelRobotController.setConfigValue("s_rw_8_4_0_227",configValue);
                }
            }
            Text {
                text: qsTr(" ")
            }
            ICCheckBox{
                id:safe2UseIt
                configName: qsTr("Use it?")
                onClicked: {
                    if(safe2UseIt.isChecked){
                        useIt.isChecked = 0;
                        safe2Axis1Set.onValueChanged();
                        safe2Axis2Set.onValueChanged();
                        safe2Axis3Set.onValueChanged();
                        safe2MinPos1Set.onValueChanged();
                        safe2MaxPos1Set.onValueChanged();
                        safe2MinPos2Set.onValueChanged();
                        safe2MaxPos2Set.onValueChanged();
                    }
                    panelRobotController.setConfigValue("s_rw_0_1_0_228",safe2UseIt.isChecked ? 1 : 0);
                    panelRobotController.syncConfigs();
                }
            }
            Text {
                text: qsTr(" ")
            }
        }
        Component.onCompleted:{
            if(panelRobotController.getConfigValue("s_rw_1_5_0_228") == 1){
                safe2Axis1Set.configValue = panelRobotController.getConfigValue("s_rw_0_4_0_227");
                safe2Axis2Set.configValue = panelRobotController.getConfigValue("s_rw_4_4_0_227");
                safe2Axis3Set.configValue = panelRobotController.getConfigValue("s_rw_8_4_0_227");
                safe2MinPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_230")/1000;
                safe2MaxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_248")/1000;
                safe2MinPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_231")/1000;
                safe2MaxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_249")/1000;
                safe2UseIt.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_228");
            }
        }
    }

    Component.onCompleted:{
        buttonModel.append({"typename":safe1.typename,"id":safe1.type_id});
        buttonModel.append({"typename":safe2.typename,"id":safe2.type_id});
        pageContainer.addPage(safe1);
        pageContainer.addPage(safe2);

        var type = panelRobotController.getConfigValue("s_rw_1_5_0_228");
        pageContainer.setCurrentIndex(type);
        view.currentIndex = type;
    }
}

