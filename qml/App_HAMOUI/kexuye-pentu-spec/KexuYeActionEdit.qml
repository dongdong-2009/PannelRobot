import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine


Item {
    id:container
    width: parent.width
    height: parent.height
    Column{
        id:configContainer
        property int posNameWidth: 60
        spacing: 4
        Text {
            id: actionName
            text: qsTr("text")

        }
        Row{
            id:pos1Container
            spacing: 4
            Text {
                text: qsTr("SPos:")
                width: configContainer.posNameWidth
                anchors.verticalCenter: parent.verticalCenter
            }
            ICConfigEdit{
                id:sPosM0
                configName: AxisDefine.axisInfos[0].name
            }
            ICConfigEdit{
                id:sPosM1
                configName: AxisDefine.axisInfos[1].name
            }
            ICConfigEdit{
                id:sPosM2
                configName: AxisDefine.axisInfos[2].name
            }
            ICConfigEdit{
                id:sPosM3
                configName: AxisDefine.axisInfos[3].name
            }
            ICConfigEdit{
                id:sPosM4
                configName: AxisDefine.axisInfos[4].name
            }
            ICConfigEdit{
                id:sPosM5
                configName: AxisDefine.axisInfos[5].name
            }
        }
        Row{
            id:pos2Container
            spacing: 4
            Text {
                text: qsTr("Pos 1:")
                width: configContainer.posNameWidth
                anchors.verticalCenter: parent.verticalCenter
            }
            ICConfigEdit{
                id:pos1M0
                configName: AxisDefine.axisInfos[0].name
            }
            ICConfigEdit{
                id:pos1M1
                configName: AxisDefine.axisInfos[1].name
            }
            ICConfigEdit{
                id:pos1M2
                configName: AxisDefine.axisInfos[2].name
            }
            ICConfigEdit{
                id:pos1M3
                configName: AxisDefine.axisInfos[3].name
            }
            ICConfigEdit{
                id:pos1M4
                configName: AxisDefine.axisInfos[4].name
            }
            ICConfigEdit{
                id:pos1M5
                configName: AxisDefine.axisInfos[5].name
            }
        }

        Row{
            id:pos3Container
            spacing: 4
            Text {
                text: qsTr("Pos 2:")
                width: configContainer.posNameWidth
                anchors.verticalCenter: parent.verticalCenter
            }
            ICConfigEdit{
                id:pos2M0
                configName: AxisDefine.axisInfos[0].name
            }
            ICConfigEdit{
                id:pos2M1
                configName: AxisDefine.axisInfos[1].name
            }
            ICConfigEdit{
                id:pos2M2
                configName: AxisDefine.axisInfos[2].name
            }
            ICConfigEdit{
                id:pos2M3
                configName: AxisDefine.axisInfos[3].name
            }
            ICConfigEdit{
                id:pos2M4
                configName: AxisDefine.axisInfos[4].name
            }
            ICConfigEdit{
                id:pos2M5
                configName: AxisDefine.axisInfos[5].name
            }
        }
    }
}
