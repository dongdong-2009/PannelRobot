import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/IODefines.js" as IODefines
import "../AppSettings.js" as UISettings
import "../../utils/stringhelper.js" as ICString


Item {

    QtObject{
        id:pData
        property string currentLanguage: UISettings.AppSettings.prototype.currentLanguage()
        property variant inputs: [
            "X010",
            "X011",
            "X012",
            "X014",
            "EuX010",
            "INX01"
        ]
    }

    signal backToMenuTriggered()

    function createActionObjects(){
        var ret = [];
        if(defineFlag.isChecked){
            ret.push(Teach.generateFlagAction(Teach.useableFlag(), flagDescr.text));
            return ret;
        }

        var input;
        for(var i = 0; i < inputModel.count; ++i)
        {
            input = inputModel.get(i);
            if(input.isEn){
                var isOn = statusGroup.checkedItem == onBox ? true : false;
                var flagStr = flag.currentText;
                if(flag.currentIndex < 0) return ret;
                var begin = flagStr.indexOf('[') + 1;
                var end = flagStr.indexOf(']');
                ret.push(Teach.generateConditionAction(input.hwPoint,
                                                       isOn,
                                                       limit.configValue,
                                                       parseInt(flagStr.slice(begin,end))));
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

    ICButtonGroup{
        id:editorSel
        anchors.top:  backToMenu.bottom
        anchors.topMargin:  10
        checkedItem: defineFlag
        Row{
            spacing: 10
            ICCheckBox{
                id:defineFlag
                text: qsTr("Define Flag")
                width: 150
                isChecked: true
            }
            ICCheckBox{
                id:useFlag
                text:qsTr("Use Flag")
                width: 150

            }
        }
        height: 32
    }



    Rectangle{
        id:defineFlagEditor
        visible: defineFlag.isChecked
        anchors.top:  editorSel.bottom
        anchors.topMargin:  10
        width: parent.width - 2
        height: parent.height - 170
        Row{
            spacing: 6
            Text {
                text: qsTr("Flag Descr:")
                anchors.verticalCenter: parent.verticalCenter
            }
            ICLineEdit{
                id:flagDescr
                width: 200
                isNumberOnly: false

            }
        }
    }

    Rectangle{
        id:useFlagEditor
        visible: useFlag.isChecked
        anchors.top:  editorSel.bottom
        anchors.topMargin:  10
        width: parent.width
        height: parent.height

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
            height: parent.height - 170
            ListView{
                id:inputListView
                width: parent.width
                height: parent.height
                model: inputModel
                spacing: 10
                delegate: ICCheckBox{
                    text: inputDefine
                    width: parent.width
                    height: 24
                    isChecked: isEn
                    useCustomClickHandler: true
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            inputModel.onCheckBoxStatusChanged(index, !parent.isChecked);
                        }
                    }
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
                ICConfigEdit{
                    id:limit
                    configName: qsTr("Limit:")
                    unit: qsTr("s")
                    width: 100
                    height: 24
                }
            }
            height: 32
        }


        Row{
            anchors.top: statusGroup.bottom;
            anchors.topMargin: 6
            Text {
                text: qsTr("Go to flag:")
                anchors.verticalCenter: parent.verticalCenter
            }
            ICComboBox{
                id: flag
                popupMode: 1

                onVisibleChanged: {
                    var flags = Teach.flags;
                    var ret = [];
                    for(var i = 0; i < flags.length; ++i){
                        ret.push(qsTr("Flag") +
                                 ICString.icStrformat("[{0}]", flags[i]));
                    }
                    items = ret;
                }
            }
        }
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
