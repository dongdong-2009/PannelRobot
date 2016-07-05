import QtQuick 1.1
import "../../ICCustomElement"
import "../../utils/Storage.js" as Storage

Item {


    ICMessageBox{
        id:backupNameDialog
        x:250
        y:50
        z:2
        onAccept: {
            var backupName = inputText;
            if(hmiConfigs.isChecked){
                panelRobotController.backupHMIBackups(backupName, Storage.backup());
            }else if(machineRunningConfigs.isChecked){
                panelRobotController.backupMRBackups(backupName);
            }else if(ghost.isChecked){
                panelRobotController.makeGhost(backupName, Storage.backup());
            }
        }
    }

    Column{
        spacing: 6
        ICButtonGroup{
            spacing: 24
            checkedItem: local
            checkedIndex: 0
            mustChecked: true
            ICCheckBox{
                id:local
                text: qsTr("Local")
                isChecked: true
            }
            ICCheckBox{
                id:uDisk
                text: qsTr("U Disk")
            }
        }
        ICButtonGroup{
            spacing: 24
            checkedItem: machineRunningConfigs
            checkedIndex: 0
            mustChecked: true
            ICCheckBox{
                id:machineRunningConfigs
                text: qsTr("Machine Running(Mold, Machine)")
                isChecked: true
            }
            ICCheckBox{
                id:hmiConfigs
                text: qsTr("HMI Configs(Programable Button, Panel Settings)")
            }
            ICCheckBox{
                id:ghost
                text: qsTr("ghost")
            }
        }
        Row{
            spacing: 12
            ICListView{
                id:backuViews
                width: 600
                height: 250
                isShowHint: true
                border.color: "black"
                ListModel{
                    id:localMachineBackupModel
                }
                ListModel{
                    id:localHMIBackupModel
                    function syncModel(){
                        localHMIBackupModel.clear();
                        var backups = JSON.parse(nelRobotController.scanHMIBackups(0));

                    }
                }
                ListModel{
                    id:uDiskMachineBackupModel
                }
                ListModel{
                    id:uDiskHMIBackupModel
                }
            }
            Column{
                ICButton{
                    id:newBackup
                    width: 150
                    text: qsTr("Backup Current")
                    onButtonClicked: {
                        backupNameDialog.showInput(qsTr("Please input the backup name"),
                                                   qsTr("Backup Name"),
                                                   false,
                                                   qsTr("Ok"), qsTr("Cancel"));
                    }
                }
                ICButton{
                    id:restore
                    width: newBackup.width
                    text: qsTr("Restore Selected")
                }
                ICButton{
                    id:deleteBackup
                    width: newBackup.width
                    text: qsTr("Delete")
                }

                ICButton{
                    id:exportOrImport
                    width: newBackup.width
                    text: qsTr("Export")
                }
            }
        }
    }
}
