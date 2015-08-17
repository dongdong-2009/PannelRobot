import QtQuick 1.1

Item {
    property string bindStatus: ""
    property alias text: status.text
    width: 50
    height: 24
    Text {
        id: status
        width: parent.width
        height: parent.height
    }
}
