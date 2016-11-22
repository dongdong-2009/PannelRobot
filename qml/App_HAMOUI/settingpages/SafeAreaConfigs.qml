import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine

Item {
    width: parent.width
    height: parent.height

    function showCurrentSafeArea(which){
        panelRobotController.setConfigValue("s_rw_1_5_0_222",which);
        panelRobotController.syncConfigs();
    }
    ListModel{
        id:buttonModel
    }
    ICListView{
        id:view
        width: 100
        height: parent.height
        color: "white"
        model:buttonModel
        highlight: Rectangle { width: view.width; height: 20;color: "lightsteelblue"; }
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
        Grid{
            columns: 2
            spacing: 10
            anchors.left: safeAreaPic1.right
            anchors.leftMargin: 5
            width:300
            height:parent.height

            ICComboBoxConfigEdit{
                id:axis1Set
                z:3
                configName:qsTr("axis1")
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
                    panelRobotController.setConfigValue("s_rw_0_4_0_221",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            Text {
                text: qsTr(" ")
            }

            ICConfigEdit{
                id:minPos1Set
                configName:qsTr("minPos1")
                configNameWidth: maxPos1Set.configNameWidth
                min:-10000
                max:10000
                decimal: 3
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_223",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:minPos1SetBtn
                text:qsTr("minPos1 Set")
                height: minPos1Set.height
                onButtonClicked: {
                    switch(axis1Set.configValue)
                    {
                    case 1:
                        minPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        minPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        minPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        minPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        minPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
                        minPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }

            ICConfigEdit{
                id:maxPos1Set
                configName:qsTr("maxPos1")
                min:-10000
                max:10000
                decimal: 3
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_224",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:maxPos1SetBtn
                text:qsTr("maxPos1 Set")
                height: maxPos1Set.height
                onBtnPressed: {
                    switch(axis1Set.configValue)
                    {
                    case 1:
                        maxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        maxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        maxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        maxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        maxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
                        maxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }


            ICComboBoxConfigEdit{
                id:axis2Set
                z:2
                configName:qsTr("axis2")
                configValue: -1
                configNameWidth: maxPos2Set.configNameWidth
                popupHeight: 120
                function onValueChanged(){
                    panelRobotController.setConfigValue("s_rw_4_4_0_221",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            Text {
                text: qsTr(" ")
            }

            ICConfigEdit{
                id:minPos2Set
                configName:qsTr("minPos2")
                configNameWidth: maxPos2Set.configNameWidth
                min:-10000
                max:10000
                decimal: 3
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_225",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:minPos2SetBtn
                text:qsTr("minPos2 Set")
                height: minPos2Set.height
                onBtnPressed: {
                    switch(axis2Set.configValue)
                    {
                    case 1:
                        minPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        minPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        minPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        minPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        minPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
                        minPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }

            ICConfigEdit{
                id:maxPos2Set
                configName:qsTr("maxPos2")
                min:-10000
                max:10000
                decimal: 3
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_226",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:maxPos2SetBtn
                text:qsTr("maxPos2 Set")
                height: maxPos2Set.height
                onBtnPressed: {
                    switch(axis2Set.configValue)
                    {
                    case 1:
                        maxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        maxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        maxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        maxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        maxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
                        maxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }


            ICComboBoxConfigEdit{
                id:axis3Set
                z:1
                configName:qsTr("axis3")
                configValue: -1
                configNameWidth: maxPos3Set.configNameWidth
                popupHeight: 120
                function onValueChanged(){
                    panelRobotController.setConfigValue("s_rw_8_4_0_221",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            Text {
                text: qsTr(" ")
            }

            ICConfigEdit{
                id:minPos3Set
                configName:qsTr("minPos3")
                configNameWidth: maxPos3Set.configNameWidth
                min:-10000
                max:10000
                decimal: 3
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_227",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:minPos3SetBtn
                text:qsTr("minPos3 Set")
                height: minPos3Set.height
                onBtnPressed: {
                    switch(axis3Set.configValue)
                    {
                    case 0:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 1:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 2:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 3:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 4:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 5:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }

            ICConfigEdit{
                id:maxPos3Set
                configName:qsTr("maxPos3")
                min:-10000
                max:10000
                decimal: 3
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_228",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:maxPos3SetBtn
                text:qsTr("maxPos3 Set")
                height: maxPos3Set.height
                onBtnPressed: {
                    switch(axis3Set.configValue)
                    {
                    case 0:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 1:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 2:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 3:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 4:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 5:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }

            ICConfigEdit{
                id:safeSignalSet
                configName:qsTr("SafePo")
                configNameWidth: maxPos3Set.configNameWidth
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_6_7_0_222",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            Text {
                text: qsTr(" ")
            }

            ICCheckBox{
                id:useIt
                configName: qsTr("Use it?")
                onClicked: {
                    panelRobotController.setConfigValue("s_rw_0_1_0_222",useIt.isChecked ? 1 : 0);
                    panelRobotController.syncConfigs();
                }
            }
            Text {
                text: qsTr(" ")
            }
        }
        Component.onCompleted:{
            if(panelRobotController.getConfigValue("s_rw_1_5_0_222") == 0){
                axis1Set.configValue = panelRobotController.getConfigValue("s_rw_0_4_0_221");
                axis2Set.configValue = panelRobotController.getConfigValue("s_rw_4_4_0_221");
                axis3Set.configValue = panelRobotController.getConfigValue("s_rw_8_4_0_221");
                minPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_223")/1000;
                maxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_224")/1000;
                minPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_225")/1000;
                maxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_226")/1000;
                minPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_227")/1000;
                maxPos3Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_228")/1000;
                safeSignalSet.configValue= panelRobotController.getConfigValue("s_rw_6_7_0_222");
                useIt.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_222");
            }
            axis1Set.configValueChanged.connect(axis1Set.onValueChanged);
            axis2Set.configValueChanged.connect(axis2Set.onValueChanged);
            axis3Set.configValueChanged.connect(axis3Set.onValueChanged);
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
                configName:qsTr("axis1")
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
                    console.log(configValue);
                    panelRobotController.setConfigValue("s_rw_0_4_0_221",configValue);
                    panelRobotController.syncConfigs();
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
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_223",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:safe2MinPos1SetBtn
                text:qsTr("minPos1 Set")
                height: safe2MinPos1Set.height
                onButtonClicked: {
                    switch(safe2Axis1Set.configValue)
                    {
                    case 1:
                        safe2MinPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        safe2MinPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        safe2MinPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        safe2MinPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        safe2MinPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
                        safe2MinPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }

            ICConfigEdit{
                id:safe2MaxPos1Set
                configName:qsTr("maxPos1")
                min:-10000
                max:10000
                decimal: 3
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_224",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:safe2MaxPos1SetBtn
                text:qsTr("maxPos1 Set")
                height: safe2MaxPos1Set.height
                onBtnPressed: {
                    switch(safe2Axis1Set.configValue)
                    {
                    case 1:
                        safe2MaxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        safe2MaxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        safe2MaxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        safe2MaxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        safe2MaxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
                        safe2MaxPos1Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }


            ICComboBoxConfigEdit{
                id:safe2Axis2Set
                z:2
                configName:qsTr("axis2")
                configValue: -1
                configNameWidth: safe2MaxPos2Set.configNameWidth
                popupHeight: 120
                function onValueChanged(){
                    panelRobotController.setConfigValue("s_rw_4_4_0_221",configValue);
                    panelRobotController.syncConfigs();
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
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_225",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:safe2minPos2SetBtn
                text:qsTr("minPos2 Set")
                height: safe2MinPos2Set.height
                onBtnPressed: {
                    switch(safe2Axis2Set.configValue)
                    {
                    case 1:
                        safe2MinPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        safe2MinPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        safe2MinPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        safe2MinPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        safe2MinPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
                        safe2MinPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }

            ICConfigEdit{
                id:safe2MaxPos2Set
                configName:qsTr("maxPos2")
                min:-10000
                max:10000
                decimal: 3
                onConfigValueChanged: {
                    panelRobotController.setConfigValue("s_rw_0_32_3_226",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            ICButton{
                id:safe2MaxPos2SetBtn
                text:qsTr("maxPos2 Set")
                height: safe2MaxPos2Set.height
                onBtnPressed: {
                    switch(safe2Axis2Set.configValue)
                    {
                    case 1:
                        safe2MaxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        safe2MaxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        safe2MaxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        safe2MaxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        safe2MaxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
                        safe2MaxPos2Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                        break;
                    default:break;
                    }
                }
            }
            ICComboBoxConfigEdit{
                id:safe2Axis3Set
                z:1
                configName:qsTr("axis3")
                configNameWidth: safe2MaxPos2Set.configNameWidth
                configValue: -1
                popupHeight: 120
                function onValueChanged(){
                    panelRobotController.setConfigValue("s_rw_8_4_0_221",configValue);
                    panelRobotController.syncConfigs();
                }
            }
            Text {
                text: qsTr(" ")
            }
            ICCheckBox{
                id:safe2UseIt
                configName: qsTr("Use it?")
                onClicked: {
                    panelRobotController.setConfigValue("s_rw_0_1_0_222",safe2UseIt.isChecked ? 1 : 0);
                    panelRobotController.syncConfigs();
                }
            }
            Text {
                text: qsTr(" ")
            }
        }
        Component.onCompleted:{
            if(panelRobotController.getConfigValue("s_rw_1_5_0_222") == 1){
                safe2Axis1Set.configValue = panelRobotController.getConfigValue("s_rw_0_4_0_221");
                safe2Axis2Set.configValue = panelRobotController.getConfigValue("s_rw_4_4_0_221");
                safe2Axis3Set.configValue = panelRobotController.getConfigValue("s_rw_8_4_0_221");
                safe2MinPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_223")/1000;
                safe2MaxPos1Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_224")/1000;
                safe2MinPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_225")/1000;
                safe2MaxPos2Set.configValue = panelRobotController.getConfigValue("s_rw_0_32_3_226")/1000;
                safe2UseIt.isChecked = panelRobotController.getConfigValue("s_rw_0_1_0_222");
            }
            console.log(safe2Axis1Set.configValue);
            safe2Axis1Set.configValueChanged.connect(safe2Axis1Set.onValueChanged);
            safe2Axis2Set.configValueChanged.connect(safe2Axis2Set.onValueChanged);
            safe2Axis3Set.configValueChanged.connect(safe2Axis3Set.onValueChanged);
        }
    }

    Component.onCompleted:{
        buttonModel.append({"typename":safe1.typename,"id":safe1.type_id});
        buttonModel.append({"typename":safe2.typename,"id":safe2.type_id});

        pageContainer.addPage(safe1);
        pageContainer.addPage(safe2);

        var type = panelRobotController.getConfigValue("s_rw_1_5_0_222");
        pageContainer.setCurrentIndex(type);
        view.currentIndex = type;
    }
}

