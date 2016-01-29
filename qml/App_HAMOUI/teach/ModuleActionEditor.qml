import QtQuick 1.1
import "Teach.js" as Teach

import "../../utils/utils.js" as Utils

import "../../ICCustomElement"
import "ProgramFlowPage.js" as ProgramFlowPage


Item {
    function setModuleSelections(moduleNames){
        moduleSel.items = moduleNames;
    }
    function setFlagSelections(flags){
        flags.splice(0, 0, qsTr("Next Line"));
        callBackSel.items = tmp;
    }

    function createActionObjects(){
        var ret = [];
        var mID = (Utils.getValueFromBrackets(moduleSel.configText()));
        var fID = (callBackSel.configValue <= 0 ? -1 : Utils.getValueFromBrackets(callBackSel.configText()));
        ret.push(Teach.generateCallModuleAction(mID, fID));
        return ret;
    }

    Column{
        spacing: 10
        ICComboBoxConfigEdit{
            id:moduleSel
            configName: qsTr("Call Module")
            z:2
            configNameWidth: 100
            inputWidth: 200
        }
        ICComboBoxConfigEdit{
            id:callBackSel
            configName: qsTr("Return To Flag")
            configNameWidth: 100
            inputWidth: 200

        }
    }
    onVisibleChanged: {
        if(visible){
            setFlagSelections(Teach.flagsDefine.flagNameList(ProgramFlowPage.currentEditingProgram));
            setModuleSelections(Teach.functionManager.functionsStrList());
        }
    }
}
