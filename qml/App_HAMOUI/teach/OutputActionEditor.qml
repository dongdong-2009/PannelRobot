import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../AppSettings.js" as UISettings


Item {

    QtObject{
        id:pData
        property string currentLanguage: UISettings.AppSettings.prototype.currentLanguage()
        property variant outputs: [
            "Y010",
            "Y011",
            "Y012",
            "Y014",
            "EuY010"
        ]
    }

    signal backToMenuTriggered()

    function createActionObjects(){
        var ret = [];
        var output;
        for(var i = 0; i < outputModel.count; ++i)
        {
            output = outputModel.get(i);
            if(output.isEn){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                ret.push(Teach.generateOutputAction(output.hwPoint, isOn, delay.configValue));
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
        id: outputContainer
        //        visible: false
        ListModel{
            id:outputModel
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
            id:outputListView
            width: parent.width
            height: parent.height
            model: outputModel
            spacing: 10
            delegate: ICCheckBox{
                text: outputDefine
                width: parent.width
                height: 24
                isChecked: isEn
                useCustomClickHandler: true
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        outputModel.onCheckBoxStatusChanged(index, !parent.isChecked);
                    }
                }


                //                MouseArea{
                //                    anchors.fill: parent
                //                    onClicked: {
                //                        outputListView.currentIndex = index
                //                    }
                //                }
            }
        }
    }

    ICButtonGroup{
        id:statusGroup
        anchors.top: outputContainer.bottom;
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
        id:delay
        configName: qsTr("Delay:")
        unit: qsTr("s")
        anchors.top: statusGroup.bottom;
        anchors.topMargin: 6
        width: 100
        height: 24
        visible: true
        z:1
    }

    Component.onCompleted: {

        var yDefines = pData.outputs;
        var yDefine;
        for(var i = 0; i < yDefines.length; ++i){
            yDefine = IODefines.getYDefineFromPointName(yDefines[i]);
            outputModel.append({"isEn":false,
                                   "outputDefine": yDefines[i] + ":"
                                   + yDefine.yDefine.descr,
                                   "hwPoint":yDefine.hwPoint});
        }

    }

}
