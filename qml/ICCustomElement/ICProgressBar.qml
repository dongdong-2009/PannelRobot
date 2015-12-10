import QtQuick 1.1

Rectangle {
    property string progressColor: "blue"
    property int maximum: 100
    property int minimum: 0

    border.width: 1
    border.color: "black"

    signal valueChanged(int val)

    QtObject{
        id:pData
        property int value: 0
    }

    function setRange(min, max)
    {
        maximum = max;
        minimum = min;
    }

    function value(){
        return pData.value;
    }

    function setValue(val){
        if(val < minimum)
            val = minimum;
        if(val > maximum)
            val = maximum;
        if(val !== pData.value){
            pData.value = val;
            valueChanged(val);
        }
    }

    width: 200
    height: 24
    Rectangle{
        id:process
        width: parent.width * pData.value / maximum - parent.border.width
        height: parent.height - parent.border.width
        y:parent.border.width
        x:parent.border.width
        color: parent.progressColor
    }

}
