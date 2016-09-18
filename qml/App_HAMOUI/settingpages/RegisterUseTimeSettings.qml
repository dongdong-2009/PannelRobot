import QtQuick 1.1
import "../../ICCustomElement"
import "../ShareData.js" as ShareData


Item {
    id:instance
    x:20
    y:20
    Column{
        spacing: 6
        Row
        {
            spacing: 6
            Text {
                visible: false
                text: qsTr("Rest Time:")
            }
            Text {
                id: restTime
                visible: false
                Component.onCompleted: {
                    setRestTime(panelRobotController.restUseTime());
                }

                function setRestTime(rt){
                    if(rt == 0)
                        restTime.text = qsTr("Forever")
                    else
                        restTime.text = rt + qsTr("hour")
                }
            }
        }
        Row{
            spacing: 6
            Text {
                id:mcL
                text: qsTr("Machine Code:")
            }
            Text {
                id: machineCode
            }
        }
        ICConfigEdit{
            id:registerEdit
            configName: qsTr("Register Code:")
            configNameWidth: mcL.width
            inputWidth: 200
            isNumberOnly: false
        }

        Row{
            spacing: 6
            ICButton{
                id:generateMachineCodeBtn
                width: 200
                text:qsTr("Generate Machine Code")
                onButtonClicked: {
                    machineCode.text = panelRobotController.generateMachineCode();
                }
            }
            ICButton{
                id:registerBtn
                text: qsTr("Register")
                onButtonClicked: {
                    var rt = panelRobotController.registerUseTime(factoryCode.configValue,
                                                                  machineCode.text,
                                                                  registerEdit.configValue);
                    if(rt < 0){
                        tip.text = qsTr("Wrong register code!");
                    }else{
                        tip.text = qsTr("Register successfully!");
                        restTime.setRestTime(rt);
                    }
                }
            }
            Text {
                id: tip
                color: "red"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        ICConfigEdit{
            id:factoryCode
            configName: qsTr("Factory code(6bit):")
            configValue: panelRobotController.factoryCode();
        }
        ICConfigEdit{
            id:restTimeEdit
            configName: qsTr("Rest Time(0 Forever):")
            configValue: panelRobotController.restUseTime();
            unit: qsTr("hour")
        }
    }

    function onUserChanged(user){
        var isSuper = ShareData.UserInfo.currentHasRootPerm();
        restTimeEdit.visible = isSuper;
        factoryCode.visible = isSuper;
    }

    function onFCChanged(){
        panelRobotController.setFactoryCode(factoryCode.configValue);
    }

    function onRTChanged(){
        panelRobotController.setRestUseTime(restTimeEdit.configValue);
        restTime.setRestTime(panelRobotController.restUseTime());
    }

    Component.onCompleted: {
        ShareData.UserInfo.registUserChangeEvent(instance);
        factoryCode.configValueChanged.connect(onFCChanged);
        restTimeEdit.configValueChanged.connect(onRTChanged);
    }
}
