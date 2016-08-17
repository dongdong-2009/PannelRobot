import QtQuick 1.1
import "../../ICCustomElement"
import '..'


ICSettingConfigsScope{
    id:maintainPage
    Column{
        spacing: 4
        Row{
            id:versionContainer
            Text {
                text: qsTr("UI Version:") + "Robot-1.0.7" + ";"
            }
            Text {
                id:hostVersion
            }
            onVisibleChanged: {
                if(visible)
                    hostVersion.text = qsTr("Controller Version:") + panelRobotController.controllerVersion();
            }
        }

        ICButtonGroup{
            spacing: 24
            mustChecked: true
            checkedIndex: 0
            ICCheckBox{
                id:update
                text: qsTr("Update")
                isChecked: true
            }
            ICCheckBox{
                id:backupRestore
                text: qsTr("Backup/Restore")
                onIsCheckedChanged: {
                    if(isChecked)
                        backupRestoreContainer.source = "DataManagePage.qml";
                }
            }
        }
        Rectangle{
            id:splitLine
            height: 1
            width: 798
            color: "black"
        }

        Row{
            id:updateContainer
            spacing: 6
            visible: !backupRestore.isChecked
            Rectangle{
                id:listViewContainer
                width: 600
                height: 310
                ListModel{
                    id:updaterModel
                }

                ListView{
                    id:updaterView
                    width: parent.width
                    height: parent.height
                    model: updaterModel
                    clip: true
                    delegate: Rectangle{
                        width: parent.width
                        height: 32
                        border.width: 1
                        border.color: "black"
                        color: updaterView.currentIndex == index ? "lightsteelblue" : "white"

                        Text{
                            text: name
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                updaterView.currentIndex = index;
                            }
                        }
                    }
                }
            }
            Column{
                spacing: 6
                ICButton{
                    id:scanUpdater
                    text: qsTr("Scan Updater")
                    width: 150
                    height: 32
                    onButtonClicked: {
                        var updatersJSON = panelRobotController.scanUSBUpdaters("HCRobot");

                        var upaaters = JSON.parse(updatersJSON);
                        updaterModel.clear();
                        for(var i = 0; i < upaaters.length; ++i){
                            updaterModel.append({"name":upaaters[i]});
                        }
                    }
                }
                ICButton{
                    id:startUpdate
                    text: qsTr("Start Update")
                    width: 150
                    height: 32
                    onButtonClicked: {
                        var name = updaterModel.get(updaterView.currentIndex).name;
                        panelRobotController.backupUpdater(name)
                        panelRobotController.startUpdate(name);
                    }
                }

            }
        }

        Loader{
            id:backupRestoreContainer
            visible: backupRestore.isChecked
            width: updateContainer.width
            height: updateContainer.height
        }
    }
}
