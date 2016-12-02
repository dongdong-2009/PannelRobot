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
            isNumberOnly: false
        }
        ICConfigEdit{
            id:dataEdit
            configName: qsTr("Data")
            isNumberOnly: false
        }
    }
    Row{
        spacing: 6
        ICButton {
            id:writeBtn
            text: qsTr("Write")
            onButtonClicked: {
                panelRobotController.writeQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), parseInt(dataEdit.configValue, 16));
            }
        }
        ICButton {
            id:readBtn
            text: qsTr("Read")
            onButtonClicked: {
                panelRobotController.readQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16));
            }
        }
        ICButton{
            id:writeEPBtn
            text: qsTr("Write EP")
            onButtonClicked: {
                panelRobotController.writeQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), parseInt(dataEdit.configValue, 16), true);
            }
        }
        ICButton{
            id:readEPBtn
            text: qsTr("Read EP")
            onButtonClicked: {
                panelRobotController.readQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), true);

            }
        }

        anchors.top: qkConfigContainer.bottom
        anchors.topMargin: 6
    }
    function onReadFinished(data){
        console.log("onReadFinished", data);
        dataEdit.configValue = ((data>>16) & 0xFFFF).toString(16);
    }

    Component.onCompleted: {
        panelRobotController.readQKConfigFinished.connect(onReadFinished);
    }
}
