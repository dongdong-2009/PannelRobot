import QtQuick 1.1
import "../../../ICCustomElement"
import "../../configs/AxisDefine.js" as AxisDefine
import "ExtentActionDefine.js" as ExtentActionDefine
import "../../configs/IODefines.js" as IODefines

ExtentActionEditorBase {
    id:instance
    width: content.width + 20
    height: content.height

    property alias id: axisSel.configValue
    property alias tpos: posEdit.configValue
    property alias speed: speedEdit.configValue
    property alias delay: delayEdit.configValue
    property alias stopEn: isStopEn.isChecked
    property alias point: isStopEn.configValue
    property alias pStatus: pointStatus.currentIndex
    property alias immStop: isImmStop.isChecked
    property alias devPos: devPosEdit.configValue
    property alias devLen: devLenEdit.configValue
    property alias decSpeed: decSpeedEdit.configValue
    property alias memAddr: memPosAddr.configValue

    Row{
        id:content
        spacing: 20
        Column{
            spacing: 6
            ICComboBoxConfigEdit{
                id:axisSel
                configName: qsTr("Axis")
                configNameWidth: decSpeedEdit.configNameWidth
                inputWidth: decSpeedEdit.inputWidth
                popupHeight: 120
                z:2
                configValue: -1
                function onAxisDefinesChanged(){
                    items= AxisDefine.usedAxisNameList();
                }
                Component.onCompleted: {
                    AxisDefine.registerMonitors(axisSel);
                    if(items.length > 0)configValue=0;
                }
            }

            ICConfigEdit{
                id:posEdit
                configName: qsTr("Pos")
                configNameWidth: decSpeedEdit.configNameWidth
                min:-10000
                max:10000
                decimal: 3

            }
            ICConfigEdit{
                id:speedEdit
                configName: qsTr("Speed")
                configNameWidth: decSpeedEdit.configNameWidth
                configValue: "80.0"
                min:0.1
                max:100
                decimal: 1
            }
            ICConfigEdit{
                id:delayEdit
                configName: qsTr("Delay")
                configNameWidth: decSpeedEdit.configNameWidth
                configValue: "0.00"
                min:0
                max:10000
                decimal: 2
            }
            ICConfigEdit{
                id:devLenEdit
                configName: qsTr("devLen")
                configNameWidth: decSpeedEdit.configNameWidth
                configValue: "0.000"
                min:-10000
                max:10000
                decimal: 3
            }

            ICConfigEdit{
                id:decSpeedEdit
                configName: qsTr("DecSpeed")
                configValue: "10.0"
                min:0.1
                max:100
                decimal: 1
            }
        }
        Column{
            spacing: 6
            Row{
                z:2
                spacing: 6
                ICCheckableComboboxEdit{
                    id:isStopEn
                    configName: qsTr("Input")
                    configValue: -1
                    inputWidth: 60
                    popupHeight: 120
                    Component.onCompleted: {
                        var ioBoardCount = panelRobotController.getConfigValue("s_rw_22_2_0_184");
                        if(ioBoardCount == 0)
                            ioBoardCount = 1;
                        var len = ioBoardCount * 32;
                        var ioItems = [];
                        for(var i = 0; i < len; ++i){
                            ioItems.push(IODefines.xDefines[i].pointName);
                        }
                        items = ioItems;
                        configValue = 0;
                    }
                }
                ICComboBox{
                    id:pointStatus
                    enabled:isStopEn.isChecked
                    width: 60
                    items:[qsTr("on"),qsTr("off")]
                    Component.onCompleted: {
                        currentIndex = 0;
                    }
                }
            }
            Row{
                spacing: 6
                Text {
                    id: toStop
                    height: isImmStop.height
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("To stop")
                }
                ICCheckBox{
                    id:isImmStop
                    enabled:isStopEn.isChecked
                    configName: qsTr("Imm stop")
                }
            }

            ICConfigEdit{
                id:devPosEdit
                configName: qsTr("devPos")
                configValue: "0"
                min:0
                max:1000
            }
            ICHCAddrEdit{
                id:memPosAddr
                mode:0
                configName: qsTr("MemPosAddr")
                baseAddrMin:800
                baseAddrMax:899
                baseAddr_configValue: "800"
            }
        }
    }
    Component.onCompleted: {
        axisSel.onAxisDefinesChanged();
        bindActionDefine(ExtentActionDefine.extentSingleMemposAction);
    }
}


