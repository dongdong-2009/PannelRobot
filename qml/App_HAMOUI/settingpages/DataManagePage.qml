import QtQuick 1.1
import "../../ICCustomElement"

Item {
    Column{
        spacing: 6
        ICButtonGroup{
            spacing: 24
            checkedItem: local
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
        }
        Row{
            spacing: 12
            ICListView{
                id:backuViews
                width: 600
                height: 300
                isShowHint: true
                border.color: "black"
                ListModel{
                    id:localMachineBackupModel
                }
                ListModel{
                    id:localHMIBackupModel
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
