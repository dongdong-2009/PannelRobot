import QtQuick 1.1
import "../../ICCustomElement"

Item{
    property string pointDescr: ""
    property string  pointNum: ""
    property alias isChecked: ioPointNum.isChecked

    function setChecked(status){
        isChecked = status;
    }

    width: container.width
    height: ioPointNum.height
    Row{
        id:container
        spacing: 2
        ICCheckBox{
            id:ioPointNum
            text: pointNum
        }
        ICButton{
            id:actionBtn
            text: pointDescr
            width: 100
            height: ioPointNum.height
        }
    }

}
