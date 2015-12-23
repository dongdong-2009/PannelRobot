import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../../utils/utils.js" as Utils

Rectangle {
    function createActionObjects(){
        var ret = [];
        var md = counterModel.get(counterview.currentIndex);
        if(setCounter.isChecked)
            ret.push(Teach.generateCounterAction(md.id));
        else if(clearCounter.isChecked)
            ret.push(Teach.generateClearCounterAction(md.id));
        //        if(useFlag.isChecked){
        //            var statckStr = stackSelector.configText;
        //            if(statckStr.currentIndex < 0) return ret;
        //            var begin = statckStr.indexOf('[') + 1;
        //            var end = statckStr.indexOf(']');
        //            ret.push(Teach.generateStackAction(statckStr.slice(begin, end), speed.configValue));
        //        }
        return ret;
    }

    ICButtonGroup{
        id:typeContainer
        layoutMode: 1
        mustChecked: true
        spacing: 2
        ICCheckBox{
            id:setCounter
            text: qsTr("Set Counter")
        }
        ICCheckBox{
            id:clearCounter
            text: qsTr("Clear Counter")
        }
    }

    Column{
        id:commandContainer
        spacing: 6
        anchors.left: counterViewContaienr.right
        anchors.leftMargin: 6
        y:counterViewContaienr.y
        ICLineEdit{
            id:newCounterName
            isNumberOnly: false
            inputWidth: 120
        }
        ICButton{
            id:newCounterBtn
            text: qsTr("New")
            width: 80
            onButtonClicked: {
                var toAdd = Teach.counterManager.newCounter(newCounterName.text, 0, 0);
                if(panelRobotController.saveCounterDef(toAdd.id, toAdd.name, toAdd.current, toAdd.target))
                    counterModel.append(toAdd);
            }
        }

        ICButton{
            id:delCounterBtn
            text: qsTr("Delete")
            x:newCounterBtn.x
            width: 80
            onButtonClicked: {
                var counterID = counterModel.get(counterview.currentIndex).id;
                Teach.counterManager.delCounter(counterID);
                if(panelRobotController.delCounterDef(counterID))
                    counterModel.remove(counterview.currentIndex);
            }

        }
    }

    Rectangle{
        id:counterViewContaienr
        border.width: 1
        border.color: "black"
        width: 395
        height: parent.height - 10
        anchors.left: typeContainer.right
        anchors.leftMargin: 4
        Column{
            anchors.fill: parent
            spacing: 2
            Row{
                id:viewHeader
                spacing: 4
                Text {
                    id: headerID
                    text: qsTr("ID")
                    horizontalAlignment: Text.AlignHCenter
                    width: headerSplitLine.width * 0.1 - parent.spacing
                }
                Text {
                    id: headerName
                    text: qsTr("Name")
                    horizontalAlignment: Text.AlignHCenter

                    width: headerSplitLine.width * 0.5 - parent.spacing

                }
                Text {
                    id: headerCurrent
                    text: qsTr("Current")
                    horizontalAlignment: Text.AlignHCenter

                    width: headerSplitLine.width * 0.2 - parent.spacing

                }
                Text {
                    id: headerTarget
                    text: qsTr("Target")
                    horizontalAlignment: Text.AlignHCenter

                    width: headerSplitLine.width * 0.2 - parent.spacing

                }
            }
            Rectangle{
                id:headerSplitLine
                height: 1
                width: counterViewContaienr.width - 12
                color: "gray "
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ListModel{
                id:counterModel
            }

            ListView{
                id:counterview
                clip: true
                width: headerSplitLine.width
                height: counterViewContaienr.height - viewHeader.height - headerSplitLine.height - parent.spacing - 5
                x: headerSplitLine.x
                model: counterModel
                highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                delegate: Item{
                    height: 35
                    width: headerSplitLine.width
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            counterview.currentIndex = index;
                        }
                    }

                    Column{
                        spacing: 2

                        Row{
                            height: 32
                            spacing: viewHeader.spacing
                            Text {
                                text: id
                                width: headerID.width
                                horizontalAlignment: headerID.horizontalAlignment
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: name
                                width: headerName.width
                                anchors.verticalCenter: parent.verticalCenter

                            }
                            ICLineEdit{
                                text: current
                                inputWidth: headerCurrent.width
                                anchors.verticalCenter: parent.verticalCenter
                                onEditFinished: {
                                    counterview.currentIndex = index;
                                    var md = counterModel.get(counterview.currentIndex);
                                    md.current = text;
                                    Teach.counterManager.updateCounter(md.id, md.name, md.current, md.target);
                                    panelRobotController.saveCounterDef(md.id, md.name, md.current, md.target);
                                }
                            }
                            ICLineEdit{
                                text:target
                                inputWidth: headerTarget.width
                                anchors.verticalCenter: parent.verticalCenter
                                onEditFinished: {
                                    counterview.currentIndex = index;
                                    var md = counterModel.get(counterview.currentIndex);
                                    md.target = text;
                                    Teach.counterManager.updateCounter(md.id, md.name, md.current, md.target);
                                    panelRobotController.saveCounterDef(md.id, md.name, md.current, md.target);
                                }
                            }
                        }
                        Rectangle{
                            height: 1
                            width: headerSplitLine.width
                            //                        anchors.horizontalCenterOffset: -4
                            color: "gray "
                        }
                    }
                }
            }

        }
    }
    function onMoldChanged(){
        var counters = JSON.parse(panelRobotController.counterDefs());
        Teach.counterManager.init(counters);
        counterModel.clear();
        var cs = Teach.counterManager.counters;
        for(var c in cs){
            counterModel.append(cs[c]);
        }
    }

    Component.onCompleted: {
        panelRobotController.moldChanged.connect(onMoldChanged);
        onMoldChanged();
    }
}
