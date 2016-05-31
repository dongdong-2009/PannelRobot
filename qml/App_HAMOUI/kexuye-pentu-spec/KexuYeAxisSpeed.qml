import QtQuick 1.1
import "../../ICCustomElement"

Item {
    id:container
    width: parent.width
    height: parent.height
    Column{
        id:configContainer
        property int posNameWidth: 60
        spacing: 4
        Row{
            spacing: 10
            Text {
                id: returnspeed
                text: qsTr("return Speed")
                width: 200
                anchors.verticalCenter: parent.verticalCenter
                color: "green"
            }
        }
        Row{
            spacing: 10
            id:rspeedContainer
            ICConfigEdit{
                id:m0Speed
                configName: qsTr("X")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
            ICConfigEdit{
                id:m1Speed
                configName: qsTr("Y")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
            ICConfigEdit{
                id:m2Speed
                configName: qsTr("Z")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
            ICConfigEdit{
                id:m3Speed
                configName: qsTr("A")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
            ICConfigEdit{
                id:m4Speed
                configName: qsTr("B")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
            ICConfigEdit{
                id:m5Speed
                configName: qsTr("C")
                configAddr: "s_rw_0_32_1_1200"
                unit: qsTr("%")

            }
        }
    }
}
