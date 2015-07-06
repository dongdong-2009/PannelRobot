import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../AppSettings.js" as UISettings


Item {

    QtObject{
        id:pData
        property string currentLanguage: UISettings.AppSettings.prototype.currentLanguage()
        property variant inputs: [
            "X010",
            "X011",
            "X012",
            "X014",
            "EuX010"
        ]
    }

    signal backToMenuTriggered()

    function createActionObjects(){
        var ret = [];
        var input;
        for(var i = 0; i < inputModel.count; ++i)
        {
            input = inputModel.get(i);
            if(input.isEn){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateCheckAction(input.hwPoint, isOn, limit.configValue));
                break;
            }
        }
        return ret;
    }
    width: parent.width
    height: parent.height


    ICButton{
        id:backToMenu
        text: qsTr("Back to Menu")
        onButtonClicked: backToMenuTriggered()
    }

    Rectangle {
        id: inputContainer
//        visible: false
        ListModel{
            id:inputModel
            function onCheckBoxStatusChanged(index, isChecked){
                this.set(index, {"isEn":isChecked});
                if(!isChecked) return;
                for(var i = 0; i < this.count; ++i){
                    if(i !== index){
                        this.set(i, {"isEn":false});
                    }
                }
            }
        }

        width: parent.width - 2
        height: parent.height - 150
        anchors.top:  backToMenu.bottom
        anchors.topMargin:  10
        ListView{
            id:inputListView
            width: parent.width
            height: parent.height
            model: inputModel
            spacing: 10
            delegate: Item{
                width: parent.width
                height: 24
                Row{
                    ICCheckBox{
                        text: ""
                        width: 32
                        isChecked: isEn
                        useCustomClickHandler: true
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                inputModel.onCheckBoxStatusChanged(index, !parent.isChecked);
                            }
                        }
                    }
                    Text {
                        text: inputDefine
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                //                MouseArea{
                //                    anchors.fill: parent
                //                    onClicked: {
                //                        inputListView.currentIndex = index
                //                    }
                //                }
            }
        }
    }

    ICButtonGroup{
        id:statusGroup
        anchors.top: inputContainer.bottom;
        anchors.topMargin: 6
        checkedItem: onBox
        Row{
            spacing: 10
            ICCheckBox{
                id:onBox
                text: qsTr("ON")
                isChecked: true
            }
            ICCheckBox{
                id:offBox
                text: qsTr("OFF")
            }
        }
        height: 32
    }

    ICConfigEdit{
        id:limit
        configName: qsTr("Limit:")
        unit: qsTr("s")
        anchors.top: statusGroup.bottom;
        anchors.topMargin: 6
        width: 100
        height: 24
        visible: true
        z:1
    }

    Component.onCompleted: {

        var xDefines = pData.inputs;
        var xDefine;
        for(var i = 0; i < xDefines.length; ++i){
            xDefine = IODefines.getXDefineFromPointName(xDefines[i]);
            inputModel.append({"isEn":false,
                                   "inputDefine": xDefines[i] + ":"
                                   + xDefine.xDefine.descr[pData.currentLanguage],
                               "hwPoint":xDefine.hwPoint});
        }

    }

}
