import QtQuick 1.1
import "../ICCustomElement"
import "Teach.js" as Teach

Rectangle {
    QtObject{
        id:pData
        property variant programs: [mainProgramModel,
        sub1ProgramModel,
        sub2ProgramModel,
        sub3ProgramModel,
        sub4ProgramModel,
        sub5ProgramModel,
        sub6ProgramModel,
        sub7ProgramModel,
        sub8ProgramModel]
    }

    Row{
        id:programSelecterContainer
        Text {
            text: qsTr("Editing")
            anchors.verticalCenter: parent.verticalCenter
        }
        ICComboBox{
            id:editing
            z:100
            items: [qsTr("main"),
                qsTr("Sub-1"),
                qsTr("Sub-2"),
                qsTr("Sub-3"),
                qsTr("Sub-4"),
                qsTr("Sub-5"),
                qsTr("Sub-6"),
                qsTr("Sub-7"),
                qsTr("Sub-8")
            ]
            currentIndex: 0
        }
    }

    Rectangle{
        anchors.top: programSelecterContainer.bottom
//        anchors.bottom: parent.bottom
        border.width: 2
        border.color: "black"
        width: 400
        height: 400
//        visible: false
        ListModel{
            id:mainProgramModel
        }
        ListModel{
            id:sub1ProgramModel
        }
        ListModel{
            id:sub2ProgramModel
        }
        ListModel{
            id:sub3ProgramModel
        }
        ListModel{
            id:sub4ProgramModel
        }
        ListModel{
            id:sub5ProgramModel
        }
        ListModel{
            id:sub6ProgramModel
        }
        ListModel{
            id:sub7ProgramModel
        }
        ListModel{
            id:sub8ProgramModel
        }

        ListView{
            id:programListView
            model: mainProgramModel
            width: parent.width
            height: parent.height
            highlight: Rectangle { color: "lightsteelblue"; width: programListView.width }
            delegate: Text {
                text: Teach.actionToString(actionObject)
                width: programListView.width
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        programListView.currentIndex = index
                    }
                }
            }
        }

    }

    Component.onCompleted: {
        var program = JSON.parse(panelRobotController.mainProgram());
        var i,j;
        var step;
        for(i = 0; i < program.length; ++i){
            step = program[i];
            for(j = 0; j < step.length; ++j){
                mainProgramModel.append({"actionObject":step[i]});
            }
        }

        for(i = 1; i < 8; ++i){
            program = JSON.parse(panelRobotController.subProgram(i));
            for(var p = 0; p < program.length; ++p){
                step = program[p]
                for(j = 0; j < step.length; ++j){
                    pData.programs[i].append({"actionObject":step[i]});
                }
            }
        }
    }
}
