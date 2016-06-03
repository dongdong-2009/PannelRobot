import QtQuick 1.1

import "."
import "../ICCustomElement/"
import "configs/AxisDefine.js" as AxisDefine

Item {
    id:container
    x:4
    function setWorldPosVisible(en){
        worldPos.visible = en;
    }

    function setJogPosVisible(en){
        jogPos.visible = en;
    }

    ICStatusScope{
        Column{

        Grid{
            id:worldPos
            rows: 1
            columns: 6
            spacing: 25
            AxisPosDisplayComponent{
                id:m0
                name: AxisDefine.axisInfos[0].name+" :"
                unit: AxisDefine.axisInfos[0].unit
                bindStatus: "c_ro_0_32_3_900"
            }
            AxisPosDisplayComponent{
                id:m1
                name: AxisDefine.axisInfos[1].name+" :"
                unit: AxisDefine.axisInfos[1].unit
                bindStatus: "c_ro_0_32_3_904"

            }
            AxisPosDisplayComponent{
                id:m2
                name: AxisDefine.axisInfos[2].name+" :"
                unit: AxisDefine.axisInfos[2].unit
                bindStatus: "c_ro_0_32_3_908"

            }
            AxisPosDisplayComponent{
                id:m3
                name: AxisDefine.axisInfos[3].name+" :"
                unit: AxisDefine.axisInfos[3].unit
                bindStatus: "c_ro_0_32_3_912"

            }
            AxisPosDisplayComponent{
                id:m4
                name: AxisDefine.axisInfos[4].name+" :"
                unit: AxisDefine.axisInfos[4].unit
                bindStatus: "c_ro_0_32_3_916"

            }
            AxisPosDisplayComponent{
                id:m5
                name: AxisDefine.axisInfos[5].name+" :"
                unit: AxisDefine.axisInfos[5].unit
                bindStatus: "c_ro_0_32_3_920"

            }
        }
        Grid{
            id:jogPos
            rows: 1
            columns: 6
            spacing: 25
            AxisPosDisplayComponent{
                id:a0
                name: AxisDefine.axisInfos[0].name+" :"
                unit: "°"
                bindStatus: "c_ro_0_32_0_901"
                mode:0.001
            }
            AxisPosDisplayComponent{
                id:a1
                name: AxisDefine.axisInfos[1].name+" :"
                unit: "°"
                bindStatus: "c_ro_0_32_0_905"
                mode:0.001

            }
            AxisPosDisplayComponent{
                id:a2
                name: AxisDefine.axisInfos[2].name+" :"
                unit: "°"
                bindStatus: "c_ro_0_32_0_909"
                mode:0.001

            }
            AxisPosDisplayComponent{
                id:a3
                name: AxisDefine.axisInfos[3].name+" :"
                unit: "°"
                bindStatus: "c_ro_0_32_0_913"
                mode:0.001

            }
            AxisPosDisplayComponent{
                id:a4
                name: AxisDefine.axisInfos[4].name+" :"
                unit: "°"
                bindStatus: "c_ro_0_32_0_917"
                mode:0.001

            }
            AxisPosDisplayComponent{
                id:a5
                name: AxisDefine.axisInfos[5].name+" :"
                unit: "°"
                bindStatus: "c_ro_0_32_0_921"
                mode:0.001

            }
        }
    }
    }

    function onAxisDefinesChanged(){
        m0.visible = AxisDefine.axisInfos[0].visiable;
        m1.visible = AxisDefine.axisInfos[1].visiable;
        m2.visible = AxisDefine.axisInfos[2].visiable;
        m3.visible = AxisDefine.axisInfos[3].visiable;
        m4.visible = AxisDefine.axisInfos[4].visiable;
        m5.visible = AxisDefine.axisInfos[5].visiable;

        a0.visible = AxisDefine.axisInfos[0].visiable;
        a1.visible = AxisDefine.axisInfos[1].visiable;
        a2.visible = AxisDefine.axisInfos[2].visiable;
        a3.visible = AxisDefine.axisInfos[3].visiable;
        a4.visible = AxisDefine.axisInfos[4].visiable;
        a5.visible = AxisDefine.axisInfos[5].visiable;

    }

    Component.onCompleted: {
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }
}
