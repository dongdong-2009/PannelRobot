import QtQuick 1.1
import "Teach.js" as Teach

Rectangle{
    id:container
    property string lineNum: "0"
    property bool isComment: false
    property bool isCurrent: false
    property bool isRunning: false
    property int actionType: Teach.actionTypes.kAT_Normal
    property string text: ""

    height: descr.height + 12

    function judgeState(){
        var ret = "";
        if(isCurrent){
            ret += "current";
        }
        if(isComment)
            ret += "comment";

        if(!isCurrent && isRunning)
            ret = "running";
        if(actionType === Teach.actionTypes.kAT_SyncStart && ret === "")
            ret =  "syncstart";
        else if(actionType === Teach.actionTypes.kAT_SyncEnd && ret === "")
            ret = "syncend";
        else if(actionType === Teach.actionTypes.kAT_Flag && ret === "")
            ret = "flag";
        else if(actionType === Teach.actionTypes.kAT_Wait && ret === "")
            ret = "wait";
        return ret;
    }

    states: [
        State {
            name: "comment"
            PropertyChanges { target: num; text: "#" + lineNum; horizontalAlignment:Text.AlignLeft;}
            PropertyChanges { target: container; color: "gray";}
        },
        State {
            name: "current"
            PropertyChanges { target: container; color: "lightsteelblue";}

        },
        State {
            name: "currentcomment"
            PropertyChanges { target: num; text: "#" + lineNum; horizontalAlignment:Text.AlignLeft;}
            PropertyChanges { target: container; color: "lightsteelblue";}
        },
        State {
            name: "running"
            PropertyChanges {target: container; color:"lime";}
        },
        State {
            name: "syncstart"
            PropertyChanges {target: container; color:"yellow";}

        },
        State{
            name: "syncend"
            PropertyChanges {target: container; color:"cyan";}
        },
        State{
            name: "flag"
            PropertyChanges {target: container; color:"orchid";}
        },
        State{
            name: "wait"
            PropertyChanges {target: container; color:"red";}
        }

    ]

    Text{
        id:num
        width: 65
        text: lineNum
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignRight
    }
    Text {
        id:descr
        text: container.text
        textFormat: Text.RichText
        width: parent.width - num.width
//        wrapMode: Text.WrapAnywhere
        anchors.left: num.right
        anchors.verticalCenter: parent.verticalCenter
    }
    //    color: lineNum % 2 == 1 ? "cyan" : "yellow"
    color: "white"

    onIsCommentChanged: {
        state = judgeState();
    }

    onIsCurrentChanged: {
        state = judgeState();
    }

    onIsRunningChanged: {
        state = judgeState();
    }

    onActionTypeChanged: {
        state = judgeState();
    }

    Component.onCompleted: {

        state = judgeState();
    }
}
