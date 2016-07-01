import QtQuick 1.1
import "../../ICCustomElement"
import '..'


ICSettingConfigsScope{
        id:maintainPage
    Row{
        id:versionContainer
        Text {
            text: qsTr("UI Version:") + "PENSHENG-PENTU-1.0-S6-1.0.3;"
        }
        Text {
            id:hostVersion
        }
        onVisibleChanged: {
            if(visible)
                hostVersion.text = qsTr("Controller Version:") + panelRobotController.controllerVersion();
        }
    }

    Row{
        spacing: 6
        anchors.top: versionContainer.bottom
        anchors.topMargin: 10;
        Rectangle{
            id:listViewContainer
            width: 600
            height: 380
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
                    panelRobotController.startUpdate(updaterModel.get(updaterView.currentIndex).name)
                }
            }

        }
    }
}
