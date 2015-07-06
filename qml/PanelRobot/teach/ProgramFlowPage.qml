import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../Theme.js" as Theme
import "../../utils/utils.js" as Utils


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


    function showActionEditorPanel(){
        actionEditorFrame.visible = !actionEditorFrame.visible;
    }

    function onInsertTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 0)return;
        if(actionEditorContainer.isMenuShow()) return;
        var actionObjects = actionEditorContainer.currentPage().createActionObjects();
        var model = currentModel();
        for(var i = 0; i < actionObjects.length; ++i){
            model.insert(cI++, new Teach.ProgramModelItem(actionObjects[i]));
        }
    }

    function onDeleteTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 0)return;
        var model = currentModel();
        if(cI >= model.count - 1) return;
        model.remove(cI);
    }

    function onUpTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 1)return;
        var model = currentModel();
        if(cI >= model.count - 1) return;
        model.move(cI, cI -1, 1);
    }

    function onDownTriggered(){
        var cI = programListView.currentIndex;
        if(cI < 0)return;
        var model = currentModel();
        if(cI >= model.count - 2) return;
        model.move(cI, cI  + 1, 1);

    }

    function modelToProgram(which){
        var model = pData.programs[which];
        var ret = [];
        for(var i = 0; i < model.count; ++i){
            ret.push(model.get(i).actionObject);
        }
        return JSON.stringify(ret);
    }

    function onSaveTriggered(){
        var errno;
        if(editing.currentIndex == 0){
            errno = panelRobotController.saveMainProgram(modelToProgram(0));
        }else{
            errno = panelRobotController.saveSubProgram(editing.currentIndex, modelToProgram(editing.currentIndex));
        }
        if(errno !== 0){
            tipBox.show(Teach.ccErrnoToString(errno));
        }
    }

//    function saveProgram(which){

//    }

    function currentModel(){
        return pData.programs[editing.currentIndex];
    }

    Row{
        id:container
        width: 796
        height: 436
        spacing: 2
        Rectangle{
            id:programViewContainer
            x:2
            width: actionEditorFrame.visible ? container.width / 2 : container.width
            height: parent.height
            color: Theme.defaultTheme.BASE_BG

            Row{
                id:programSelecterContainer
                spacing: 10
                y:2
                z:1
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
                    onCurrentIndexChanged: {
                        programListView.model = pData.programs[currentIndex];
                    }
                }
            }

            Rectangle{
                anchors.top: programSelecterContainer.bottom
                anchors.topMargin: 4
                //        anchors.bottom: parent.bottom
                border.width: 1
                border.color: "black"
                //                width: actionEditorFrame.visible ? container.width / 2 : container.width
                width: parent.width
                height: 408
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
                    y:2
                    model: mainProgramModel
                    width: parent.width
                    height: parent.height
                    highlight: Rectangle {x:1; color: "lightsteelblue"; width: programListView.width - 1 }
                    highlightMoveDuration:200
                    spacing:2
                    delegate: Item{
                        width: parent.width
                        height: 24
                        Text {
                            text: "    " + Teach.actionToString(actionObject)
                            width: programListView.width
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                programListView.currentIndex = index
                            }
                        }
                    }
                }

            }
        }
        Rectangle{
            id:actionEditorFrame
            //            visible: false
            width: container.width / 2 - container.spacing
            height: container.height
            y:2
            //            anchors.left: programViewContainer.right
            //            anchors.right: container.right
            border.width: 1
            border.color: "black"
            ICStackContainer{
                function showMenu() { setCurrentIndex(0);}
//                function showAxis() { setCurrentIndex(1);}
//                function showOutput() { setCurrentIndex(2);}
                function isMenuShow() { return currentIndex == 0;}
                id:actionEditorContainer
                width: parent.width
                height: parent.height
            }
            Component.onCompleted: {
                var editor = Qt.createComponent('ProgramActionMenu.qml');
                var actionMenuObject = editor.createObject(actionEditorContainer);
                editor = Qt.createComponent('AxisActionEditor.qml');
                var axisEditorObject = editor.createObject(actionEditorContainer);
                editor = Qt.createComponent('OutputActionEditor.qml')
                var outputEditorObject = editor.createObject(actionEditorContainer);
                actionEditorContainer.addPage(actionMenuObject)
                actionEditorContainer.addPage(axisEditorObject);
                actionEditorContainer.addPage(outputEditorObject)
                actionEditorContainer.showMenu();
                actionMenuObject.axisMenuTriggered.connect(function(){actionEditorContainer.setCurrentIndex(1)});
                actionMenuObject.outputMenuTriggered.connect(function(){actionEditorContainer.setCurrentIndex(2)});
                axisEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);
                outputEditorObject.backToMenuTriggered.connect(actionEditorContainer.showMenu);

            }
        }
    }

    ICDialog{
        id:tipBox
        anchors.centerIn: container
        z: 100
    }

    function updateProgramModels(){
        var program = JSON.parse(panelRobotController.mainProgram());
        var i,j;
        var step;
        mainProgramModel.clear();
        for(i = 0; i < program.length; ++i){
            step = program[i];
            mainProgramModel.append(new Teach.ProgramModelItem(step));
        }

        for(i = 1; i < 8; ++i){
            pData.programs[i].clear();
            program = JSON.parse(panelRobotController.subProgram(i));
            for(var p = 0; p < program.length; ++p){
                step = program[p]
                pData.programs[i].append(new Teach.ProgramModelItem(step));
            }
        }
    }

    Component.onCompleted: {
        updateProgramModels();
        panelRobotController.moldChanged.connect(updateProgramModels);
    }

}
