import QtQuick 1.1
import "../qml/ICCustomElement"

Rectangle {
    width: 600
    height: 480

    function loadUSBDirs(){
        qmlDirsModel.clear();
        var dirStr = panelRobotController.usbDirs();
        if(dirStr.length !== 0){
            var dirs = JSON.parse(dirStr);
            for(var i = 0; i < dirs.length; ++i){
                qmlDirsModel.append({"dirName":dirs[i]});
            }
        }
    }

    function loadLocalDirs(){
        qmlDirsModel.clear();
        var dirStr = panelRobotController.localUIDirs();
        if(dirStr.length !== 0){
            var dirs = JSON.parse(dirStr);
            for(var i = 0; i < dirs.length; ++i){
                qmlDirsModel.append({"dirName":dirs[i]});
            }
        }
    }

    Row{
        id:dirSel
        spacing: 20
        x:2
        y:6
        ICCheckBox{
            id:usb
            width: 60
            text: qsTr("USB")
            isChecked: true
            useCustomClickHandler: true
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(!usb.isChecked){
                        usb.isChecked = true;
                        local.isChecked = false;
                        loadUSBDirs();
                    }
                }
            }
        }
        ICCheckBox{
            id:local
            width: 60
            text: qsTr("Local")
            isChecked: false
            useCustomClickHandler: true
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(!local.isChecked){
                        local.isChecked = true;
                        usb.isChecked = false;
                        loadLocalDirs();
                    }
                }
            }
        }
    }

    Rectangle{
        id:uiContainer
        width: 400
        height: 300
//        visible: false
        x:2
        border.color: "gray"
        border.width: 1

        anchors.top: dirSel.bottom
        anchors.topMargin: 6

        ListModel{
            id:qmlDirsModel
        }

        ListView{
            id:qmlDirs
            width: 400
            height: 300
            model: qmlDirsModel
            highlight: Rectangle { x:1;color: "lightsteelblue"; width: qmlDirs.width - 3 }
            delegate: Item{
                width: parent.width
                height: 24
                Text {
                    text: dirName
                }
                MouseArea{
                    anchors.fill:  parent
                    onClicked: {
                        qmlDirs.currentIndex = index
                    }
                }
            }

        }
    }
    Column{
        id: commandContainer
        anchors.left: uiContainer.right
        anchors.leftMargin: 10
        spacing: 6
        y:uiContainer.y
        ICButton{
            id:delBtn
            text: qsTr("Del")
            visible: local.isChecked
        }
        ICButton{
            id:copyToLocal
            text: qsTr("Copy to local")
            visible: usb.isChecked
        }
        ICButton{
            id:setAsMain
            text: qsTr("Set as Running")
            visible: local.isChecked
            onButtonClicked: {
                panelRobotController.setToRunningUIPath(qmlDirsModel.get(qmlDirs.currentIndex).dirName)
            }
        }
    }

    Component.onCompleted: {
        loadUSBDirs();
    }
}
