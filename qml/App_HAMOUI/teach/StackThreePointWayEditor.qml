import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine


Rectangle {
    id:instance
    color: "#A0A0F0"
    border.width: 1
    border.color: "black"
    MouseArea{
        anchors.fill: parent
    }

    function show(data){
        spMotor0.configValue = data.sp.m0;
        spMotor1.configValue = data.sp.m1;
        spMotor2.configValue = data.sp.m2;
        spMotor3.configValue = data.sp.m3;
        spMotor4.configValue = data.sp.m4;
        spMotor5.configValue = data.sp.m5;

        xNMotor0.configValue = (spMotor0.getConfigValue() + data.space.m0).toFixed(3);
        xNMotor1.configValue = (spMotor1.getConfigValue() + data.offset.m1).toFixed(3);
        yNMotor0.configValue = (spMotor0.getConfigValue() + data.offset.m0).toFixed(3);
        yNMotor1.configValue = (spMotor1.getConfigValue() + data.space.m1).toFixed(3);
        visible = true;
    }

    signal editConfirm(variant data)

    Row{
        ICButton{
            id:okBtn
            text: qsTr("OK")
            bgColor: "lime"
            width: 60
            onButtonClicked: {
                editConfirm({"sp":{"m0":spMotor0.configValue,
                                    "m1":spMotor1.configValue,
                                    "m2":spMotor2.configValue,
                                    "m3":spMotor3.configValue,
                                    "m4":spMotor4.configValue,
                                    "m5":spMotor5.configValue},
                                "offset":{"m0":(yNMotor0.getConfigValue() - spMotor0.getConfigValue()).toFixed(3),
                                    "m1":(xNMotor1.getConfigValue() - spMotor1.getConfigValue()).toFixed(3)},
                                "space":{"m0":(xNMotor0.getConfigValue() - spMotor0.getConfigValue()),
                                    "m1":(yNMotor1.getConfigValue() - spMotor1.getConfigValue())}
                            });
                instance.visible = false;
            }

        }
        ICButton{
            id:cancelBtn
            text:qsTr("Cancel")
            bgColor: "red"
            width: okBtn.width
            onButtonClicked: {
                instance.visible = false;
            }
        }
    }

    Grid{
        id:spContainer
        x:10
        anchors.verticalCenter: parent.verticalCenter
        columns: 2
        rows: 4
        spacing: 4
        flow:Grid.TopToBottom
        Text {
            id: startPointLabel
            text: qsTr("Start Point")
            verticalAlignment: Text.AlignVCenter
            height: spSetIn.height
        }
        ICConfigEdit{
            id:spMotor0
            configName: AxisDefine.axisInfos[0].name
            configAddr: "s_rw_0_32_3_1300"
            inputWidth: 80
            configNameWidth: 30
        }
        ICConfigEdit{
            id:spMotor1
            configName: AxisDefine.axisInfos[1].name
            configAddr: "s_rw_0_32_3_1300"
            inputWidth: spMotor0.inputWidth
            configNameWidth: 30

        }
        ICConfigEdit{
            id:spMotor2
            configName: AxisDefine.axisInfos[2].name
            configAddr: "s_rw_0_32_3_1300"
            inputWidth: spMotor0.inputWidth
            configNameWidth: 30

        }
        ICButton{
            id:spSetIn
            text: qsTr("Set In")
            width: spMotor0.width
        }

        ICConfigEdit{
            id:spMotor3
            configName: AxisDefine.axisInfos[3].name
            configAddr: "s_rw_0_32_3_1300"
            inputWidth: spMotor0.inputWidth
            configNameWidth: 30

        }
        ICConfigEdit{
            id:spMotor4
            configName: AxisDefine.axisInfos[4].name
            configAddr: "s_rw_0_32_3_1300"
            inputWidth: spMotor0.inputWidth
            configNameWidth: 30

        }
        ICConfigEdit{
            id:spMotor5
            configName: AxisDefine.axisInfos[5].name
            configAddr: "s_rw_0_32_3_1300"
            inputWidth: spMotor0.inputWidth
            configNameWidth: 30
        }
    }

    Column{
        id:xDirNextPointLabelContainer
        anchors.left: spContainer.right
        y:40
        rotation: -45
        Text {
            id:xDirNextPointLabel
            text: AxisDefine.axisInfos[0].name + qsTr(" dir next Point")
            font.pixelSize: 12
        }
        Rectangle{
            height: 2
            width:xDirNextPointLabel.width
            color: "black"
        }
    }
    Column{
        id:yDirNextPointLabelContainer
        anchors.left: spContainer.right
        //        anchors.leftMargin: 5
        y:120
        rotation: 45
        Rectangle{
            height: 2
            width:yDirNextPointLabel.width
            color: "black"
        }
        Text {
            id:yDirNextPointLabel
            text: AxisDefine.axisInfos[1].name + qsTr(" dir next Point")
            font.pixelSize: 12
        }
    }
    Column{
        anchors.left:xDirNextPointLabelContainer.right
        y:10
        spacing: 4
        Row{
            id:xDirNextPointContainer
            spacing: 4
            ICConfigEdit{
                id:xNMotor0
                configName: AxisDefine.axisInfos[0].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: 80
                configNameWidth: 30
            }
            ICConfigEdit{
                id:xNMotor1
                configName: AxisDefine.axisInfos[1].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: spMotor0.inputWidth
                configNameWidth: 30

            }
            ICConfigEdit{
                id:xNMotor2
                configName: AxisDefine.axisInfos[2].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: spMotor0.inputWidth
                configNameWidth: 30
                visible: false

            }
        }
        ICButton{
            id:xNSetIn
            text: qsTr("Set In")
        }
    }
    Text {
        anchors.left: spContainer.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 32
        color: "red"
        text: qsTr("The system will caculate the offset and space when comfirm. \nYou just need to set the count configs after this setting.")
    }
    Column{
        anchors.left:yDirNextPointLabelContainer.right
        y:110
        spacing: 4
        ICButton{
            id:yNSetIn
            text:qsTr("Set In")
        }

        Row{
            id:yDirNextPointContainer
            spacing: 4

            ICConfigEdit{
                id:yNMotor0
                configName: AxisDefine.axisInfos[0].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: 80
                configNameWidth: 30
            }
            ICConfigEdit{
                id:yNMotor1
                configName: AxisDefine.axisInfos[1].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: spMotor0.inputWidth
                configNameWidth: 30

            }
            ICConfigEdit{
                id:yNMotor2
                configName: AxisDefine.axisInfos[2].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: spMotor0.inputWidth
                configNameWidth: 30
                visible: false

            }
        }
    }

    Component.onCompleted: {
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }
    function onAxisDefinesChanged(){
        spMotor0.visible = AxisDefine.axisInfos[0].visiable;
        spMotor1.visible = AxisDefine.axisInfos[1].visiable;
        spMotor2.visible = AxisDefine.axisInfos[2].visiable;
        spMotor3.visible = AxisDefine.axisInfos[3].visiable;
        spMotor4.visible = AxisDefine.axisInfos[4].visiable;
        spMotor5.visible = AxisDefine.axisInfos[5].visiable;
    }
}
