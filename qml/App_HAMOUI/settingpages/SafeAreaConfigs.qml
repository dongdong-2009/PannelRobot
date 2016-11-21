import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine

Item {
    width: parent.width
    height: parent.height

    ListModel{
        id:buttonModel
    }
    ICListView{
        id:view
        width: 100
        height: parent.height
        color: "white"
        model:buttonModel
        highlight: Rectangle { width: view.width; height: 30;color: "lightsteelblue"; }
        highlightMoveDuration: 1
        delegate: Text {
            text: id +":"+typename
            MouseArea{
                anchors.fill: parent
                onClicked: {
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
            id: safeAreaPic
//            source: "../images/struct-guide.png"
            width: parent.width-300
            height: parent.height
        }
        Grid{
            columns: 2
            spacing: 10
            anchors.left: safeAreaPic.right
            anchors.leftMargin: 5
            width:300
            height:parent.height

            ICComboBoxConfigEdit{
                id:axis1Set
                z:3
                configName:qsTr("axis1")
                configNameWidth: maxPos1Set.configNameWidth
                popupHeight: 120
                function onAxisDefinesChanged(){
                    configValue = -1;
                    var axis = AxisDefine.usedAxisNameList();
                    axis.unshift(qsTr("NO"));
                    items = axis;
                }

                Component.onCompleted: {
                    AxisDefine.registerMonitors(axis1Set);
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
                configNameWidth: maxPos2Set.configNameWidth
                popupHeight: 120
                function onAxisDefinesChanged(){
                    configValue = -1;
                    var axis = AxisDefine.usedAxisNameList();
                    axis.unshift(qsTr("NO"));
                    items = axis;
                }

                Component.onCompleted: {
                    AxisDefine.registerMonitors(axis2Set);
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
                configNameWidth: maxPos3Set.configNameWidth
                popupHeight: 120
                function onAxisDefinesChanged(){
                    configValue = -1;
                    items = AxisDefine.usedAxisNameList();
                }
                Component.onCompleted: {
                    AxisDefine.registerMonitors(axis3Set);
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
            }
            ICButton{
                id:minPos3SetBtn
                text:qsTr("minPos3 Set")
                height: minPos3Set.height
                onBtnPressed: {
                    switch(axis3Set.configValue)
                    {
                    case 1:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        minPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
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
            }
            ICButton{
                id:maxPos3SetBtn
                text:qsTr("maxPos3 Set")
                height: maxPos3Set.height
                onBtnPressed: {
                    switch(axis3Set.configValue)
                    {
                    case 1:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                        break;
                    case 2:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                        break;
                    case 3:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                        break;
                    case 4:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                        break;
                    case 5:
                        maxPos3Set.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                        break;
                    case 6:
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
            }
            Text {
                text: qsTr(" ")
            }

            ICCheckBox{
                id:useIt
                configName: qsTr("Use it?")
            }
            Text {
                text: qsTr(" ")
            }
        }
    }


    Component.onCompleted:{
        buttonModel.append({"typename":safe1.typename,"id":safe1.type_id});

        pageContainer.addPage(safe1);

        pageContainer.setCurrentIndex(0);
    }
}

