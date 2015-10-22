import QtQuick 1.1

import "."
import "../ICCustomElement/"
import "configs/AxisDefine.js" as AxisDefine

Item {
    x:4
    ICStatusScope{
        Grid{
            rows: 2
            columns: 4
            spacing: 4
            AxisPosDisplayComponent{
                id:m0
                name: AxisDefine.axisInfos[0].name
                unit: AxisDefine.axisInfos[0].unit
                bindStatus: "c_ro_0_32_3_900"
            }
            AxisPosDisplayComponent{
                id:m1
                name: AxisDefine.axisInfos[1].name
                unit: AxisDefine.axisInfos[1].unit
                bindStatus: "c_ro_0_32_3_904"

            }
            AxisPosDisplayComponent{
                id:m2
                name: AxisDefine.axisInfos[2].name
                unit: AxisDefine.axisInfos[2].unit
                bindStatus: "c_ro_0_32_3_908"

            }
            AxisPosDisplayComponent{
                id:m3
                name: AxisDefine.axisInfos[3].name
                unit: AxisDefine.axisInfos[3].unit
                bindStatus: "c_ro_0_32_3_912"

            }
            AxisPosDisplayComponent{
                id:m4
                name: AxisDefine.axisInfos[4].name
                unit: AxisDefine.axisInfos[4].unit
                bindStatus: "c_ro_0_32_3_916"

            }
            AxisPosDisplayComponent{
                id:m5
                name: AxisDefine.axisInfos[5].name
                unit: AxisDefine.axisInfos[5].unit
                bindStatus: "c_ro_0_32_3_920"

            }
        }
    }
}
