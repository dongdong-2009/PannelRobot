import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine

Rectangle {
    id: continer
    width: 100
    height: 62
    QtObject{
        id:pData
        property variant axisDefine: panelRobotController.axisDefine()
    }

    Rectangle{
        id:splitLine
        width: 1
        height: parent.height
        color: "gray"
        x:310
    }

    Grid{
        columns: 2
        rows: 5
        spacing: 10
        flow: Grid.TopToBottom
        OriginActionEditorAxisComponent{
            id:m0Axis
            axisName: AxisDefine.axisInfos[0].name
            psName: [qsTr("1"), qsTr("2"), qsTr("3")]
            axisDefine: pData.axisDefine.s1Axis
            rangeAddr: "s_rw_0_32_3_1000"
            z: 5
        }
        OriginActionEditorAxisComponent{
            id:m1Axis
            axisName: AxisDefine.axisInfos[1].name
            psName: [qsTr("1"), qsTr("2"), qsTr("3")]
            axisDefine: pData.axisDefine.s2Axis
            rangeAddr: "s_rw_0_32_3_1001"
            z: 4
        }
        OriginActionEditorAxisComponent{
            id:m2Axis
            axisName: AxisDefine.axisInfos[2].name
            psName: [qsTr("1"), qsTr("2"), qsTr("3")]
            axisDefine: pData.axisDefine.s3Axis
            rangeAddr: "s_rw_0_32_3_1002"
            z: 3
        }
        OriginActionEditorAxisComponent{
            id:m3Axis
            axisName: AxisDefine.axisInfos[3].name
            psName: [qsTr("1"), qsTr("2"), qsTr("3")]
            axisDefine: pData.axisDefine.s4Axis
            rangeAddr: "s_rw_0_32_3_1003"
            z: 2
        }
        OriginActionEditorAxisComponent{
            id:m4Axis
            axisName: AxisDefine.axisInfos[4].name
            psName: [qsTr("1"), qsTr("2"), qsTr("3")]
            axisDefine: pData.axisDefine.s5Axis
            rangeAddr: "s_rw_0_32_3_1004"
            z: 1
        }
        OriginActionEditorAxisComponent{
            id:m5Axis
            axisName: AxisDefine.axisInfos[5].name
            psName: [qsTr("1"), qsTr("2"), qsTr("3")]
            axisDefine: pData.axisDefine.s6Axis
            rangeAddr: "s_rw_0_32_3_1005"
            z: 5
        }
    }
    Component.onCompleted: {
    }
}
