import QtQuick 1.1
import "../../ICCustomElement"

Item {
    width: parent.width
    height: parent.height
    //    property int number: 1

    ListModel{
        id:buttonModel
    }
    ListView{
        id:view
        width: 30
        height: parent.height
        model:buttonModel
        delegate: ICButton{
            text: id
            onBtnPressed:{
            }
        }
    }

    ICStackContainer{
        id:pageContainer
        width: parent.width
        height: parent.height
    }

    Item {
        id:safe1
        Image {
            id: safeAreaPic
            source: "../images/struct-guide.png"
            width: parent.width-300
            height: parent.height
        }
        Rectangle{
            id:spliteLine
            width: 1
            height:parent.height
            color: "black"
            anchors.left: safeAreaPic.right
        }
        Grid{
            columns: 2
            spacing: 10
            anchors.left: spliteLine.right
            anchors.leftMargin: 5
            width:150
            height:parent.height

            ICComboBoxConfigEdit{
                id:axis1Set
                configName:qsTr("axis1")
                configNameWidth: maxPos1Set.configNameWidth
            }
            Text {
                text: qsTr(" ")
            }

            ICConfigEdit{
                id:minPos1Set
                configName:qsTr("minPos1")
                configNameWidth: maxPos1Set.configNameWidth
            }
            ICButton{
                id:minPos1SetBtn
                text:qsTr("minPos1 Set")
                height: minPos1Set.height
            }

            ICConfigEdit{
                id:maxPos1Set
                configName:qsTr("maxPos1")
            }
            ICButton{
                id:maxPos1SetBtn
                text:qsTr("maxPos1 Set")
                height: maxPos1Set.height
            }


            ICComboBoxConfigEdit{
                id:axis2Set
                configName:qsTr("axis2")
                configNameWidth: maxPos2Set.configNameWidth
            }
            Text {
                text: qsTr(" ")
            }

            ICConfigEdit{
                id:minPos2Set
                configName:qsTr("minPos2")
                configNameWidth: maxPos2Set.configNameWidth
            }
            ICButton{
                id:minPos2SetBtn
                text:qsTr("minPos2 Set")
                height: minPos2Set.height
            }

            ICConfigEdit{
                id:maxPos2Set
                configName:qsTr("maxPos2")
            }
            ICButton{
                id:maxPos2SetBtn
                text:qsTr("maxPos2 Set")
                height: maxPos2Set.height
            }


            ICComboBoxConfigEdit{
                id:axis3Set
                configName:qsTr("axis3")
                configNameWidth: maxPos3Set.configNameWidth
            }
            Text {
                text: qsTr(" ")
            }

            ICConfigEdit{
                id:minPos3Set
                configName:qsTr("minPos3")
                configNameWidth: maxPos3Set.configNameWidth
            }
            ICButton{
                id:minPos3SetBtn
                text:qsTr("minPos3 Set")
                height: minPos3Set.height
            }

            ICConfigEdit{
                id:maxPos3Set
                configName:qsTr("maxPos3")
            }
            ICButton{
                id:maxPos3SetBtn
                text:qsTr("maxPos3 Set")
                height: maxPos3Set.height
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
//        buttonModel.append();
//        toolCoordModel.append({"name":toolCoords[i].name, "id":toolCoords[i].id, "info":{"data":toolCoords[i].info}});

        pageContainer.addPage(safe1);
        pageContainer.setCurrentIndex(0);
    }
}

