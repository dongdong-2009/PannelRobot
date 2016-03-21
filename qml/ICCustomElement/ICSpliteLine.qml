import QtQuick 1.1

Rectangle {
    id:spliteLine
    property int linelong: 0
    property string direction: ""
    property int wide: 0
    width: (direction == "horizontal") ? linelong : wide
    height: (direction == "verticality") ? linelong : wide
}
