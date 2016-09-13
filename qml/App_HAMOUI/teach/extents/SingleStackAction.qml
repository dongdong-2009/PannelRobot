import QtQuick 1.1
import "../../../ICCustomElement"
import "../../configs/AxisDefine.js" as AxisDefine
import "ExtentActionDefine.js" as ExtentActionDefine

import "../Teach.js" as Teach


ExtentActionEditorBase {
    width: content.width + 20
    height: content.height
    property alias startPos: startPosEdit.configValue
    property alias space: spaceEdit.configValue
    property alias count: countEdit.configValue
    property alias speed: speedEdit.configValue
    property int configs: 0
    function counterID() {
        var counterStr = counterSel.configText();
        var begin = counterStr.indexOf('[') + 1;
        var end = counterStr.indexOf(']');
        return parseInt(counterStr.slice(begin,end));
    }

    function refreshSel(){
        var oaS = axisSel.configValue;
        axisSel.configValue = -1;
        axisSel.items = AxisDefine.usedAxisNameList();
        axisSel.configValue = oaS >= axisSel.items.length ? -1 : oaS;

        oaS = counterSel.configValue;
        counterSel.configValue = -1;
        var countersStrList = Teach.counterManager.countersStrList();
        countersStrList.splice(0, 0, qsTr("Self"));
        counterSel.items = countersStrList;
        counterSel.configValue = oaS >= counterSel.items.length ? - 1 : oaS;
    }

    function setCounterID(id, doesBindingCounter){
        if(doesBindingCounter){
            var toSearch = "[" + id +"]";
            var items = counterSel.items;
            for(var i = 0; i < items.length; ++i){
                if(items[i].indexOf(toSearch) >=0 ){
                    counterSel.configValue = i;
                    return i;
                }
            }
        }
        counterSel.configValue = 0;
        return 0;
    }
    function syncConfig(){
        configs = axisSel.configValue;
        configs |= dirEdit.isChecked ? 1 <<  5: 0;
        configs |= counterSel.configValue > 0 ? 1 << 16 : 0;
        configs |= counterSel.configValue <= 0 ? 0 : counterID() << 17;
    }

    onActionObjectChanged: {
        if(actionObject == null) return;
        configs = actionObject.configs;
        startPos = actionObject.startPos;
        space = actionObject.space;
        count = actionObject.count;
        speed = actionObject.speed;
        var axisID = configs & 0x1F;
        var dir = configs >> 5 & 1;
        var bindingCounter = (configs >> 16) & 1;
        var cID = (configs >>17);
        axisSel.configValue = axisID;
        dirEdit.isChecked = dir ? 1 : 0;
        setCounterID(cID, bindingCounter);
    }

    Column{
        id:content
        spacing: 6

        ICComboBoxConfigEdit{
            id:axisSel
            configName: qsTr("Axis")
            onConfigValueChanged: syncConfig()
            z:10
        }

        Row{
            spacing: 6
            ICCheckBox{
                id:dirEdit
                text: qsTr("PP")
                onIsCheckedChanged: syncConfig()

            }

            ICConfigEdit{
                id:startPosEdit
                configName: qsTr("Start Pos")
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: 60
                configValue: "0.000"
                unit: {
                    var cI = axisSel.configValue;
                    if(cI < 0)
                        return "";
                    return AxisDefine.axisInfos[cI].unit;
                }
            }
            ICButton{
                id:setIn
                text: qsTr("Set In")
                onButtonClicked: {
                    if(axisSel.configValue < 0) return;
                    startPos = (panelRobotController.statusValue(AxisDefine.axisInfos[axisSel.configValue].jAddr) / 1000).toFixed(3)
                }
            }
        }

        ICConfigEdit{
            id:spaceEdit
            configName: qsTr("Space")
            configAddr: "s_rw_0_32_3_1300"
            configValue: "0.000"
            unit:startPosEdit.unit
            configNameWidth: startPosEdit.configNameWidth
        }
        ICConfigEdit{
            id:countEdit
            configName: qsTr("Count")
            configValue: "0"
            configAddr: "s_rw_0_32_0_1400"
            configNameWidth: startPosEdit.configNameWidth
        }
        ICConfigEdit{
            id:speedEdit
            configName: qsTr("Speed")
            configValue: "80.0"
            configAddr: "s_rw_0_32_1_212"
            unit: qsTr("%")
            configNameWidth: startPosEdit.configNameWidth
        }
        ICComboBoxConfigEdit{
            id:counterSel
            configName: qsTr("Counter")
            inputWidth: 250
            popupMode: 1
            popupHeight: 100
            onConfigValueChanged: syncConfig()

        }
    }
    onVisibleChanged: {
        if(visible){
            refreshSel();
        }
    }
    Component.onCompleted: {
        bindActionDefine(ExtentActionDefine.extentSingleStackAction);
        refreshSel();
    }
}
