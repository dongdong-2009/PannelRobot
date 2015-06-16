import QtQuick 1.1

Rectangle {
    width: 300
    height: 300
    focus: false
    QtObject{
        id:pData
        property int numBtnWidth: 48
        property int numBtnheight: 48

    }

    Rectangle{
        id:numberKeyboard
        focus: false
        Row{
            id:row1
            ICButton{
                id:num7
                text: "7"
                width: pData.numBtnWidth
                height: pData.numBtnheight
            }
            ICButton{
                id:num8
                text: "8"
                width: pData.numBtnWidth
                height: pData.numBtnheight
            }
            ICButton{
                id:num9
                text: "9"
                width: pData.numBtnWidth
                height: pData.numBtnheight
            }
        }
    }
    Rectangle{
        id:fullKeyboard
        visible: false
    }
}
