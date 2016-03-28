import QtQuick 1.1
import "../../ICCustomElement"
import "../../utils/stringhelper.js" as ICString

Item {
    property int iWidth: 50
    Column{
        spacing: 20
        ICCheckBox{
            id:networkEn
            text: qsTr("Network En")
        }

        Row{
            spacing: 4
            Text {
                id: localAddrLabel
                text: qsTr("Local Addr:")
                anchors.verticalCenter: parent.verticalCenter
                width: 100
            }
            ICLineEdit{
                id: localAddr0
                inputWidth: iWidth
            }
            Text {
                text: "."
                anchors.bottom: parent.bottom
            }
            ICLineEdit{
                id: localAddr1
                inputWidth: iWidth

            }
            Text {
                text: "."
                anchors.bottom: parent.bottom

            }
            ICLineEdit{
                id: localAddr2
                inputWidth: iWidth

            }
            Text {
                text: "."
                anchors.bottom: parent.bottom

            }
            ICLineEdit{
                id: localAddr3
                inputWidth: iWidth
            }
        }

        Row{
            spacing: 4
            Text {
                id: hostAddrLabel
                text: qsTr("Host Addr:")
                anchors.verticalCenter: parent.verticalCenter
                width: 100
            }
            ICLineEdit{
                id: hostAddr0
                inputWidth: iWidth
            }
            Text {
                text: "."
                anchors.bottom: parent.bottom
            }
            ICLineEdit{
                id: hostAddr1
                inputWidth: iWidth

            }
            Text {
                text: "."
                anchors.bottom: parent.bottom

            }
            ICLineEdit{
                id: hostAddr2
                inputWidth: iWidth

            }
            Text {
                text: "."
                anchors.bottom: parent.bottom
            }
            ICLineEdit{
                id: hostAddr3
                inputWidth: iWidth
            }
            Text {
                text: ":"
            }
            ICLineEdit{
                id:port
                inputWidth: 80
            }
        }

        ICComboBoxConfigEdit{
            id:communicateMode
            items: [qsTr("Serve"), qsTr("Client")]
            configName: qsTr("CommunicateMode")
        }
        ICButton{
            id:saveBtn
            text: qsTr("Save")
            onButtonClicked: {
                var isEn = networkEn.isChecked;
                var localAddr = ICString.icStrformat("{0}.{1}.{2}.{3}",
                                                     localAddr0.text,
                                                     localAddr1.text,
                                                     localAddr2.text,
                                                     localAddr3.text);
                var hostAddr =  ICString.icStrformat("{0}.{1}.{2}.{3}",
                                                     hostAddr0.text,
                                                     hostAddr1.text,
                                                     hostAddr2.text,
                                                     hostAddr3.text);
                var cMode = communicateMode.configValue;
                panelRobotController.setCustomSettings("NetworkEn", isEn);
                panelRobotController.setCustomSettings("LocalAddr", localAddr);
                panelRobotController.setCustomSettings("HostAddr", hostAddr + ":" + port.text);
                panelRobotController.setCustomSettings("CommunicateMode", cMode);
                panelRobotController.setEth0Enable(isEn, cMode, localAddr, hostAddr, port.text);
            }
        }

        ICButton{
            id:sendTestData
            text: qsTr("Send Test")
            onButtonClicked: {
                panelRobotController.writeDataToETH0("Test ETH0\r\n");
            }
        }
        Text {
            id: testRecv
            text: qsTr("text")
        }
    }
    function onETH0DataComeIn(data){
        testRecv.text = data;
    }

    Component.onCompleted: {
        var isNetworkEn = panelRobotController.getCustomSettings("NetworkEn", false);
        networkEn.setChecked(isNetworkEn);

        var localAddr = panelRobotController.getCustomSettings("LocalAddr", "192.168.10.201");
        var localAddrs = localAddr.split(".");
        localAddr0.text = localAddrs[0];
        localAddr1.text = localAddrs[1];
        localAddr2.text = localAddrs[2];
        localAddr3.text = localAddrs[3];

        var hostAddrs = panelRobotController.getCustomSettings("HostAddr", "192.168.10.197:9760").split(":");
        var hostIPs = hostAddrs[0].split(".");
        hostAddr0.text = hostIPs[0];
        hostAddr1.text = hostIPs[1];
        hostAddr2.text = hostIPs[2];
        hostAddr3.text = hostIPs[3];
        port.text = hostAddrs[1];

        var cMode = panelRobotController.getCustomSettings("CommunicateMode", 1);
        communicateMode.configValue = cMode;
        panelRobotController.setEth0Enable(isNetworkEn, cMode, localAddr, hostAddrs[0], hostAddrs[1]);

        panelRobotController.eth0DataComeIn.connect(onETH0DataComeIn);
    }
}
