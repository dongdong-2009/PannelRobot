import QtQuick 1.1
import "configs/Keymap.js" as Keymap
import "../ICCustomElement"
import "teach/ManualProgramManager.js" as ManualProgramManager
import "teach/Teach.js" as Teach
import "configs/IODefines.js" as IODefines


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
                console.log(JSON.stringify(p));
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
        var programs = ManualProgramManager.manualProgramManager.programList();
//        var ppProgram = {"id":0, "name":"公转盘正转", "program":[]};
//        var rpProgram = {"id":1, "name":"公转盘反转", "program":[]};
//        ppProgram.program.push(Teach.generateFlagAction(0, ""));
//        ppProgram.program.push(Teach.generateConditionAction(IODefines.IO_BOARD_0, 20, 0, true, 0, 1))
//        ppProgram.program.push(Teach.generateOutputAction(20, IODefines.TIMEY_BOARD_START, true, 68, 0.2));
//        ppProgram.program.push(Teach.generateConditionAction(IODefines.IO_BOARD_0, 20, 0, false, 0, 0));
//        ppProgram.program.push(Teach.generateOutputAction(20, IODefines.IO_BOARD_0, false, 20, 0));
//        ppProgram.program.push(Teach.generateFlagAction(1, ""));
//        ppProgram.program.push(Teach.generteEndAction());

//        rpProgram.program.push(Teach.generateFlagAction(0, ""));
//        rpProgram.program.push(Teach.generateConditionAction(IODefines.IO_BOARD_0, 21, 0, true, 0, 1))
//        rpProgram.program.push(Teach.generateOutputAction(21, IODefines.TIMEY_BOARD_START, true, 69, 0.2));
//        rpProgram.program.push(Teach.generateConditionAction(IODefines.IO_BOARD_0, 21, 0, false, 0, 0));
//        rpProgram.program.push(Teach.generateOutputAction(21, IODefines.IO_BOARD_0, false, 21, 0));
//        rpProgram.program.push(Teach.generateFlagAction(1, ""));
//        rpProgram.program.push(Teach.generteEndAction());


//        programs.push(ppProgram);
//        programs.push(rpProgram);
        for(var i = 0; i < programs.length; ++i){
            buttonModel.append({"po":programs[i]});
        }
        ManualProgramManager.manualProgramManager.registerMonitor(container);
    }
}
