import QtQuick 1.1
import "configs/Keymap.js" as Keymap
import "../ICCustomElement"
import "teach/ManualProgramManager.js" as ManualProgramManager


Item {
    id:container
    width: parent.width
    height: parent.height
    ListModel{
        id:buttonModel
    }

    GridView{
        id:view
        width: parent.width
        height: parent.height
        cellHeight: 32
        cellWidth: 150
        model:buttonModel
        delegate: ICButton{
            text: name
            onBtnPressed: {
                panelRobotController.manualRunProgram(JSON.stringify(buttonModel.get(index).program),
                                                      "","", "", "");
            }
            onBtnReleased: {
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_MANUAL_STOP);
            }
        }
    }
    function onProgramAdded(program){
        buttonModel.append(program);
    }

    function onProgramChanged(program){
        var pID = program.id
        for(var i = 0; i < buttonModel.count; ++i){
            if(buttonModel.get(i).id == pID){
                buttonModel.set(i, program);
                break;
            }
        }
    }

    function onProgramRemoved(programID){
        for(var i = 0; i < buttonModel.count; ++i){
            if(buttonModel.get(i).id == programID){
                buttonModel.remove(i);
                break;
            }
        }
    }

    Component.onCompleted: {
        var programs = ManualProgramManager.manualProgramManager.programs;
        for(var i = 0; i < programs.length; ++i){
            buttonModel.append(programs[i]);
        }
        ManualProgramManager.manualProgramManager.registerMonitor(container);
    }
}
