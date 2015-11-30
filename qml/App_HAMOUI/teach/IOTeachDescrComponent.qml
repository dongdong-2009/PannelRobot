import QtQuick 1.1
import "../../ICCustomElement"

Item{
    property string pointDescr: ""
    property alias isChecked: ioPointNum.isChecked
    width: ioPointNum.width
    height: ioPointNum.height
    ICCheckBox{
        id:ioPointNum
        text: pointDescr
    }
}
