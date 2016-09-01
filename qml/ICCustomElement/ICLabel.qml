import QtQuick 1.1

Rectangle {
    height: 24
    property alias text: label.text
    property alias horizontalAlignment: label.horizontalAlignment
    property alias font: label.font
    property int horizontalTextOffset: 0

    Text {
        id: label
        text: qsTr("text")
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Component.onCompleted: {
        if(width == 0)
            width = label.width + 4 + horizontalTextOffset;
        label.width = width - horizontalTextOffset;
        label.x = horizontalTextOffset;
    }
}
