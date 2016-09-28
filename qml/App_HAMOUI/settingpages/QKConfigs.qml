import QtQuick 1.1
import "../../ICCustomElement"

Item {
    width: parent.width
    height: parent.height

    Row{
        id:qkConfigContainer
        spacing: 6
        ICConfigEdit{
            id:axisEdit
            configName: qsTr("Axis")
        }
        ICConfigEdit{
            id:addrEdit
            configName: qsTr("Addr")
        }
        ICConfigEdit{
            id:dataEdit
            configName: qsTr("Data")
        }
    }
    Row{
        spacing: 6
        ICButton {
            id:writeBtn
            text: qsTr("Write")
            onButtonClicked: {
                panelRobotController.writeQKConfig(axisEdit.configValue, addrEdit.configValue, dataEdit.configValue);
            }
        }
        ICButton {
            id:readBtn
            text: qsTr("Read")
            onButtonClicked: {
                panelRobotController.readQKConfig(axisEdit.configValue, addrEdit.configValue);
            }
        }
        ICButton{
            id:writeEPBtn
            text: qsTr("Write EP")
            onButtonClicked: {
                panelRobotController.writeQKConfig(axisEdit.configValue, addrEdit.configValue, dataEdit.configValue, true);
            }
        }
        ICButton{
            id:readEPBtn
            text: qsTr("Read EP")
            onButtonClicked: {
                panelRobotController.readQKConfig(axisEdit.configValue, addrEdit.configValue, true);

            }
        }

        anchors.top: qkConfigContainer.bottom
        anchors.topMargin: 6
    }
    function onReadFinished(data){
        dataEdit.configValue = data & 0xFFFF;
    }

    Component.onCompleted: {
        panelRobotController.readQKConfigFinished.connect(onReadFinished(data));
    }
}
