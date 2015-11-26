import QtQuick 1.1

Rectangle {
    property variant ioDefines: []
    property int type: 0
    property string status:""

    ListModel{
        id:model
    }

    ListView{
        id:view
        width: parent.width
        height: 400
        spacing: 10
        model: model
        delegate: Row{
            spacing: 10
            Text {
                text: pointNum
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle{
                id:led
                width: 32
                height: 32
                border.color: "black"
                border.width: 2
//                color: isOn ? "lime":"gray"
                color: {
                    if(!isOn) return "gray";
                    if(type == 0) return "red";
                    return "lime";
                }
            }
            Text {
                text: descr
                anchors.verticalCenter: parent.verticalCenter

            }
        }
    }

    onIoDefinesChanged: {
        var def;
        model.clear();
        for(var i = 0; i < ioDefines.length; ++i){
            def = ioDefines[i];
            model.append({
                             "pointNum":def.pointNum,
                             "index": def.index,
                             "descr":def.descr,
                             "isOn":false
                         });
        }
    }

    onStatusChanged: {
//        if(!visible) return;
        var pNum;
        for(var i = 0; i < model.count; ++i){
            pNum = model.get(i).index;
            if(pNum >= status.length) model.setProperty(i, "isOn", false);
            model.setProperty(i, "isOn", parseInt(status[pNum]) > 0);
        }
    }
}
