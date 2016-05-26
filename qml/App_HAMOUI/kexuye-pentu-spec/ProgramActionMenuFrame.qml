import QtQuick 1.1
import "../../ICCustomElement"
import "../teach"

ProgramActionMenuFrame{
    Row{
        ICButton{
            id:kexuyeCmdBtn
            text:qsTr("KXY CMD")
        }

        ICButton{
            id:baseCmdBtn
            text:qsTr("Base CMD")
        }

    }
}
