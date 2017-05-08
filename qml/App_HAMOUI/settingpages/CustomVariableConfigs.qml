import QtQuick 1.1
import "../../ICCustomElement"
import "../teach/Teach.js" as Teach
Item {
    ListModel{
        id:variableModel
    }
    property bool hasInit: false
    function init(){
        variableView.model = null;
        variableModel.clear();
        var vs = Teach.currentRecord.variableManager.variables;
        for(var i = 0 ; i < vs.length; ++i){
            variableModel.append(vs[i]);
        }
        variableView.model = variableModel;
        hasInit = true;
    }

    Column{
        ICButton{
            id:newBtn
            text: qsTr("New")
            onButtonClicked: {
                var v = Teach.currentRecord.variableManager.newVariable("CV", "", 0, 0);
                panelRobotController.saveVariableDef(v.id, v.name, v.unit, v.val, v.decimal);
                variableModel.insert(0, v);
            }
        }

        Row{
            id:viewHeader
            spacing: 4
            Text {
                id: headerID
                text: qsTr("ID")
                horizontalAlignment: Text.AlignHCenter
                width: 60
            }
            Text {
                id: headerName
                text: qsTr("Name")
                horizontalAlignment: Text.AlignHCenter
                width: 150

            }
            Text {
                id: headerVal
                text: qsTr("Val")
                horizontalAlignment: Text.AlignHCenter
                width: 120

            }
            Text {
                id: headerUnit
                text: qsTr("Unit")
                horizontalAlignment: Text.AlignHCenter
                width: 60

            }
            Text {
                id: headerDecimal
                text: qsTr("Decimal")
                horizontalAlignment: Text.AlignHCenter

                width: 60

            }
        }

        ListView{
            id:variableView
            width: viewHeader.width + 20
            height:  400
            clip: true
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            delegate: Item{
                height: 35
                width: viewHeader.width
                MouseArea{
                    anchors.fill: parent
                }
                Row{
                    spacing: viewHeader.spacing
                    Text {
                        text: id
                        width: headerID.width
                        horizontalAlignment: headerID.horizontalAlignment
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ICLineEdit{
                        isNumberOnly:  false
//                        inputWidth: headerName.width
                        inputWidth: headerName.width
                        anchors.verticalCenter: parent.verticalCenter
                        text: name
                    }
                    ICLineEdit{
//                        inputWidth: headerVal.width
                        inputWidth: headerVal.width
                        anchors.verticalCenter: parent.verticalCenter
                        text:val
                    }
                    ICLineEdit{
//                        isNumberOnly:  false
                        inputWidth: headerUnit.width
                        anchors.verticalCenter: parent.verticalCenter
                        text:unit
                    }
                    ICLineEdit{
                        inputWidth: headerDecimal.width
                        anchors.verticalCenter: parent.verticalCenter
                        text:decimal
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        panelRobotController.moldChanged.connect(init);
    }
}
