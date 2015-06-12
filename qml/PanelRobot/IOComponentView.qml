import QtQuick 1.1

Rectangle {
    property variant ioDefines: []
    property int type: 0
    ListModel{
        id:model
    }

    ListView{
        id:view
        model: model
        delegate: Row{
            Text {
                text: pointNum
            }
            Rectangle{
                id:led
                width: 32
                height: 32
                border.color: "black"
                border.width: 2
                color: "gray"
            }
            Text {
                text: descr
            }
        }
    }

    onIoDefinesChanged: {
        var def;
        for(var i = 0; i < ioDefines.length; ++i){
            def = ioDefines[i];
            model.append({
                             "pointNum":def.pointNum,
                             "index": def.index,
                             "descr":def.descr
                         });
        }
    }
}
