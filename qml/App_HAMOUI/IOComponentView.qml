import QtQuick 1.1

Rectangle {
    property variant ioDefines: []
    property int type: 0

//    width: parent.width
//    height: parent.height
    ListModel{
        id:model
    }

    ListView{
        id:view
        width: parent.width
        height: 400
        spacing: 10
        model: model
//        anchors.bottom: parent.bottom
//        anchors.top: parent.top
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
                color: "gray"
            }
            Text {
                text: descr
                anchors.verticalCenter: parent.verticalCenter

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
