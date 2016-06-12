import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach

Rectangle {
    id: continer
    width: 100
    height: 62

    function createActionObjects(){
        var ret = [];
        ret.push(Teach.generateSpeedAction(startSpeed.configValue, endSpeed.configValue));
        return ret;
    }

    Column{
        spacing: 6
        Text {
            text: qsTr("Path Speed:")
        }
        ICConfigEdit{
            id:startSpeed
            configName: qsTr("Start Speed")
            configAddr: "s_rw_0_32_1_1200"
            configNameWidth: 120
            unit: qsTr("%")
        }
        ICConfigEdit{
            id:endSpeed
            configName: qsTr("End Speed")
            configAddr: "s_rw_0_32_1_1200"
            configNameWidth: 120
            unit: qsTr("%")

        }
    }
}
