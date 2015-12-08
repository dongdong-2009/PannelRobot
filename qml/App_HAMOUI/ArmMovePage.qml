import QtQuick 1.1
import "../ICCustomElement"
import "configs/Keymap.js" as Keymap
import "teach"


Item {
    Item {
        id: item1
        x: -624
        y: -47
        width: 114
        height: 68
    }

    Text {
        id: text1
        x: -19
        y: -149
        width: 64
        height: 64
        text: qsTr("V+")
        font.pixelSize: 12
    }

    Text {
        id: text2
        x: 74
        y: -149
        width: 64
        height: 64
        text: qsTr("V-")
        font.pixelSize: 12
    }

    Text {
        id: text3
        x: -201
        y: -158
        width: 64
        height: 64
        text: qsTr("Z+")
        font.pixelSize: 12
    }

    Text {
        id: text4
        x: -353
        y: -158
        width: 64
        height: 64
        text: qsTr("Z-")
        font.pixelSize: 12
    }

    Text {
        id: text5
        x: -105
        y: -200
        width: 64
        height: 64
        text: qsTr("U+")
        font.pixelSize: 12
    }

    Text {
        id: text6
        x: -105
        y: -96
        width: 64
        height: 64
        text: qsTr("U-")
        font.pixelSize: 12
    }

    Text {
        id: text7
        x: -189
        y: 104
        width: 64
        height: 64
        text: qsTr("X+")
        font.pixelSize: 12
    }

    Text {
        id: text8
        x: -279
        y: -72
        width: 64
        height: 64
        text: qsTr("Y+")
        font.pixelSize: 12
    }

    Text {
        id: text9
        x: -279
        y: 8
        width: 64
        height: 64
        text: qsTr("Y-")
        font.pixelSize: 12
    }

    Text {
        id: text10
        x: -361
        y: 104
        width: 64
        height: 64
        text: qsTr("X-")
        font.pixelSize: 12
    }

    Text {
        id: text11
        x: -19
        y: -56
        width: 64
        height: 64
        text: qsTr("W-")
        font.pixelSize: 12
    }

    Text {
        id: text12
        x: 74
        y: -56
        width: 64
        height: 64
        text: qsTr("W+")
        font.pixelSize: 12
    }

    Text {
        id: text13
        x: -64
        y: 104
        width: 64
        height: 64
        text: qsTr("Line X-")
        font.pixelSize: 12
    }

    Text {
        id: text14
        x: 32
        y: 104
        width: 64
        height: 64
        text: qsTr("Line X+")
        font.pixelSize: 12
    }
//    width: parent.width
//    height: parent.height


}
