import QtQuick 1.1

import "."
import "../ICCustomElement/"

Item {
    x:4
    ICStatusScope{
        Grid{
            rows: 2
            columns: 4
            spacing: 4
            AxisPosDisplayComponent{
                id:m0
                name: qsTr("M0")
                unit: "mm"
            }
            AxisPosDisplayComponent{
                id:m1
                name: qsTr("M1")
                unit: "mm"
            }
            AxisPosDisplayComponent{
                id:m2
                name: qsTr("M2")
                unit: "mm"
            }
            AxisPosDisplayComponent{
                id:m3
                name: qsTr("M3")
                unit: "mm"
            }
            AxisPosDisplayComponent{
                id:m4
                name: qsTr("M4")
                unit: "mm"
            }
            AxisPosDisplayComponent{
                id:m5
                name: qsTr("M5")
                unit: "mm"
            }
        }
    }
}
