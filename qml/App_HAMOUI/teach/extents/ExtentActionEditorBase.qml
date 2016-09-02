import QtQuick 1.1
import "ExtentActionEditorBase.js" as PData
Item {
    id:instance
    property variant actionObject: null
//    property variant editor: null

    function bindActionDefine(ad){
        PData.actionDefine = ad;
    }


    function getActionProperties(){
        if(instance.hasOwnProperty("configsCheck")){
            if(!instance.configsCheck())
                return null;
        }
        return PData.actionDefine.getActionPropertiesHelper(instance)
    }

    onActionObjectChanged: {
        if(actionObject == null) return;
        PData.actionDefine.actionObjectChangedHelper(instance, actionObject);
    }


    function updateActionObject(ao){
        PData.actionDefine.updateActionObjectHelper(instance,ao);
    }

}
