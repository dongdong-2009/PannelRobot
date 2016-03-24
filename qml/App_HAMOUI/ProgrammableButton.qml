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
            text: po.name
            onBtnPressed: {
                var p = buttonModel.get(index).po.program;
                panelRobotController.manualRunProgram(JSON.stringify(p),
                                                      "","", "", "");
            }
            onBtnReleased: {
                panelRobotController.sendKeyCommandToHost(Keymap.CMD_MANUAL_STOP);
            }
        }
    }
    function onProgramAdded(program){
        buttonModel.append({"po":program});
    }

    function onProgramChanged(program){
        var pID = program.id
        for(var i = 0; i < buttonModel.count; ++i){
            if(buttonModel.get(i).po.id == pID){
                buttonModel.setProperty(i, "po", program);
                break;
            }
        }
    }

    function onProgramRemoved(programID){
        for(var i = 0; i < buttonModel.count; ++i){
            if(buttonModel.get(i).po.id == programID){
                buttonModel.remove(i);
                break;
            }
        }
    }

    Component.onCompleted: {
        var programs = ManualProgramManager.manualProgramManager.programs;
        for(var i = 0; i < programs.length; ++i){
            console.log(programs[i].id, programs[i].name);
            buttonModel.append({"po":programs[i]});
        }
        ManualProgramManager.manualProgramManager.registerMonitor(container);
    }
}
