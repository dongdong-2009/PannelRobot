import QtQuick 1.1
import "../../ICCustomElement"


Rectangle {
    property alias modelImg:img.source
    property alias modelName: name.text
    property alias offsetX: offsetXEdit.configValue
    property alias offsetY: offsetYEdit.configValue
    property alias offsetA: offsetAEdit.configValue
    function getOffsetData(){
        var md = nameToModel();
        if(md == null) return null;
        md.offsetX = offsetX;
        md.offsetY = offsetY;
        md.offsetA = offsetA;
        return md;
    }
    function nameToModel(){
        for(var i = modelName.length - 1; i > 0; --i){
            if(modelName[i] == "["){
                return {"name":modelName.substring(0, i),
                    "model":parseInt(modelName.substring(i - 1, modelName.length -2))
                };
            }
        }
        return null;
    }

    signal offsetChanged(variant data)
    signal modelChanged(variant data)
    width: content.width
    height: content.height

    Column{
        id:content
        spacing: 6
        Text {
            id:name
        }


        Row{
            spacing: 32
            Image {
                id:img
                //                        source: modelImgPath
                width: 128
                height: 128
            }
            Column{
                spacing: 6
                ICConfigEdit{
                    id:offsetXEdit
                    configName: qsTr("Offset X")
                    onEditFinished: offsetChanged(getOffsetData())
                }
                ICConfigEdit{
                    id:offsetYEdit
                    configName: qsTr("Offset Y")
                    onEditFinished: offsetChanged(getOffsetData())
                }
                ICConfigEdit{
                    id:offsetAEdit
                    configName: qsTr("Offset A")
                    onEditFinished: offsetChanged(getOffsetData())
                }
            }
            ICButton{
                id:useThis
                text: qsTr("Use this Model")
                onButtonClicked: {
                    modelChanged(nameToModel())
                }
            }
        }
        Rectangle{
            height: 1
            color: "black"
            width: parent.parent.width
        }
    }
}
