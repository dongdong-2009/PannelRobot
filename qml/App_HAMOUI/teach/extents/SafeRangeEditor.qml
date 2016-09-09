import QtQuick 1.1
import "../../../ICCustomElement"
import "ExtentActionDefine.js" as ExtentActionDefine
import "../../configs/AxisDefine.js" as AxisDefine

ExtentActionEditorBase {
    width: content.width + 20
    height: content.height
    id:instance
    property alias para1: para1Edit.configValue
    property alias pos1 : pos1Edit.configValue
    property alias pos2 : pos2Edit.configValue
    property alias lpos1: lpos1Edit.configValue
    property alias lpos2: lpos2Edit.configValue
    property alias aid  : aidEdit.configValue

    Column{
        id:content
        spacing: 6
        ICCheckBox{
            id:checkOut
            text: qsTr("Out Range")
        }
        Row{
            spacing: 6
            ICComboBoxConfigEdit{
                id:limitedAxisSel
                configName: qsTr("Limited Axis")
                items: [
                    AxisDefine.axisInfos[0].name,
                    AxisDefine.axisInfos[1].name,
                AxisDefine.axisInfos[2].name,
                AxisDefine.axisInfos[3].name,
                AxisDefine.axisInfos[4].name,
                AxisDefine.axisInfos[5].name]
                popupMode: 1
            }
            ICConfigEdit{
                id:pos1Edit
                configValue: "0"
                configNameWidth: 40
            }
            ICConfigEdit{
                id:pos2Edit
                configValue: "0"
                configNameWidth: 40
            }
        }
        Row{
            spacing: 6
            ICComboBoxConfigEdit{
                id:limitAxisSel
                configName: qsTr("Limit Axis")
                items: limitedAxisSel.items
                popupMode: 1

            }

            ICConfigEdit{
                id:lpos1Edit
                configValue: "0"
                configNameWidth: 40
            }
            ICConfigEdit{
                id:lpos2Edit
                configValue: "0"
                configNameWidth: 40
            }
        }

        ICConfigEdit{
            id:aidEdit
            configValue: "5000"
            configNameWidth: 40
        }
        ICConfigEdit{
            id:para1Edit
            visible: false
            configValue: {
              var ret= limitedAxisSel.configValue
                ret|= limitAxisSel.configValue<<4
                ret|= checkOut.isChecked?1<<9:0
               return ret |= 3<<10
            }
            configNameWidth: 40
        }


    }
    Component.onCompleted: {
        bindActionDefine(ExtentActionDefine.extentSafeRangeAction);
    }
}
