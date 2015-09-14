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
            }
            AxisPosDisplayComponent{
                id:m1
                name: AxisDefine.axisInfos[1].name
                unit: AxisDefine.axisInfos[1].unit
            }
            AxisPosDisplayComponent{
                id:m2
                name: AxisDefine.axisInfos[2].name
                unit: AxisDefine.axisInfos[2].unit
            }
            AxisPosDisplayComponent{
                id:m3
                name: AxisDefine.axisInfos[3].name
                unit: AxisDefine.axisInfos[3].unit
            }
            AxisPosDisplayComponent{
                id:m4
                name: AxisDefine.axisInfos[4].name
                unit: AxisDefine.axisInfos[4].unit
            }
            AxisPosDisplayComponent{
                id:m5
                name: AxisDefine.axisInfos[5].name
                unit: AxisDefine.axisInfos[5].unit
            }
        }
    }
}
